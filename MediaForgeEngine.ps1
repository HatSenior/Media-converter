function Invoke-MediaProbe([string]$Path) {
    $probe = Get-Command ffprobe.exe -ErrorAction SilentlyContinue
    if(-not $probe -or -not (Test-Path -LiteralPath $Path -PathType Leaf)){return $null}
    try {
        $start = New-Object Diagnostics.ProcessStartInfo
        $start.FileName = $probe.Source
        $start.Arguments = "-v error -show_format -show_streams -of json `"$Path`""
        $start.UseShellExecute = $false; $start.CreateNoWindow = $true
        $start.RedirectStandardOutput = $true; $start.RedirectStandardError = $true
        $process = New-Object Diagnostics.Process; $process.StartInfo = $start; [void]$process.Start()
        $json = $process.StandardOutput.ReadToEnd()
        if(-not $process.WaitForExit(12000)){try{$process.Kill()}catch{};$process.Dispose();return $null}
        $process.Dispose(); if(-not $json){return $null}
        $data = $json | ConvertFrom-Json
        $video = @($data.streams | Where-Object codec_type -eq 'video' | Select-Object -First 1)[0]
        $audio = @($data.streams | Where-Object codec_type -eq 'audio' | Select-Object -First 1)[0]
        $fps = 0.0
        if($video -and $video.avg_frame_rate -match '^(\d+)/(\d+)$' -and [double]$matches[2] -ne 0){$fps=[double]$matches[1]/[double]$matches[2]}
        $duration = 0.0
        if($data.format.duration){[double]::TryParse([string]$data.format.duration,[Globalization.NumberStyles]::Float,[Globalization.CultureInfo]::InvariantCulture,[ref]$duration)|Out-Null}
        return [pscustomobject]@{
            Container=[string]$data.format.format_name; Duration=$duration; Bitrate=[long]$(if($data.format.bit_rate){$data.format.bit_rate}else{0})
            HasVideo=[bool]$video; VideoCodec=[string]$video.codec_name; Width=[int]$video.width; Height=[int]$video.height; Fps=$fps
            HasAudio=[bool]$audio; AudioCodec=[string]$audio.codec_name; AudioBitrate=[long]$(if($audio.bit_rate){$audio.bit_rate}else{0})
            SampleRate=[int]$(if($audio.sample_rate){$audio.sample_rate}else{0}); Channels=[int]$(if($audio.channels){$audio.channels}else{0})
        }
    } catch { return $null }
}

function New-MediaProcessSpec {
    return [pscustomobject]@{
        Mode='video'; OutputFormat='MP4'; Resolution='Original'; CustomWidth=0; CustomHeight=0; KeepAspect=$true
        Fps='Original'; Speed=1.0; Volume=1.0; Normalize=$false; AudioMode='keep'; AudioFormat='MP3'; AudioQuality='Balanced'; AudioBitrate=0
        CompressionMode='target'; TargetSizeMB=25.0; CompressionLevel='Balanced'; FrameTimestamp='00:00:00.000'; FrameFormat='PNG'; FrameQuality=90
    }
}

function Get-AtTempoChain([double]$Speed) {
    if($Speed -le 0){$Speed=1}
    $parts = New-Object Collections.Generic.List[string]
    while($Speed -gt 2.0){$parts.Add('atempo=2.0');$Speed/=2.0}
    while($Speed -lt 0.5){$parts.Add('atempo=0.5');$Speed/=0.5}
    $parts.Add(('atempo={0:0.####}' -f $Speed).Replace(',','.'))
    return ($parts -join ',')
}

function Get-CompressionCrf([string]$Level) {
    switch($Level){'Light'{20};'Strong'{28};'Maximum'{32};default{24}}
}

function Get-AudioCodecArguments([string]$Format,[string]$Quality,[int]$ManualBitrate) {
    $bitrate=if($ManualBitrate -gt 0){$ManualBitrate}elseif($Quality -eq 'High'){256}elseif($Quality -eq 'Small size'){96}else{160}
    switch($Format.ToUpperInvariant()) {
        'WAV' { return '-c:a pcm_s16le' }
        'FLAC' { return '-c:a flac' }
        'OGG' { return "-c:a libvorbis -b:a ${bitrate}k" }
        'AAC' { return "-c:a aac -b:a ${bitrate}k" }
        'M4A' { return "-c:a aac -b:a ${bitrate}k" }
        default { return "-c:a libmp3lame -b:a ${bitrate}k" }
    }
}

function Get-EngineOutputExtension($Spec,[string]$InputPath) {
    if($Spec.Mode -eq 'frame'){return $Spec.FrameFormat.ToLowerInvariant().Replace('jpg','jpg')}
    if($Spec.AudioMode -eq 'extract'){return $Spec.AudioFormat.ToLowerInvariant()}
    if($Spec.AudioMode -eq 'remove'){return [IO.Path]::GetExtension($InputPath).TrimStart('.').ToLowerInvariant()}
    if($Spec.Mode -eq 'audio'){return [IO.Path]::GetExtension($InputPath).TrimStart('.').ToLowerInvariant()}
    if($Spec.OutputFormat){return $Spec.OutputFormat.ToLowerInvariant()}
    return 'mp4'
}

function New-FFmpegPlan($Spec,$Analysis,[string]$InputPath,[string]$OutputPath,[string]$PassLogPath) {
    $input = '"' + $InputPath.Replace('"','\"') + '"'; $output = '"' + $OutputPath.Replace('"','\"') + '"'
    if($Spec.Mode -eq 'frame') {
        $quality = if($Spec.FrameFormat -eq 'PNG'){''}else{"-q:v $([Math]::Max(2,[Math]::Min(31,[Math]::Round(31-(29*$Spec.FrameQuality/100)))))"}
        return [pscustomobject]@{Passes=@([pscustomobject]@{Arguments="-hide_banner -y -ss $($Spec.FrameTimestamp) -i $input -frames:v 1 $quality $output";Output=$OutputPath});EstimatedBytes=0}
    }
    $requiresVideoEncoding=($Spec.Resolution -and $Spec.Resolution -ne 'Original') -or ($Spec.Fps -and $Spec.Fps -ne 'Original') -or ([Math]::Abs([double]$Spec.Speed-1.0) -gt 0.001)
    if($Spec.AudioMode -eq 'remove' -and -not $requiresVideoEncoding) {
        return [pscustomobject]@{Passes=@([pscustomobject]@{Arguments="-hide_banner -y -i $input -map 0:v -map 0:s? -c copy -an $output";Output=$OutputPath});EstimatedBytes=0}
    }
    if($Spec.AudioMode -eq 'extract') {
        $audioArgs=Get-AudioCodecArguments $Spec.AudioFormat $Spec.AudioQuality $Spec.AudioBitrate
        return [pscustomobject]@{Passes=@([pscustomobject]@{Arguments="-hide_banner -y -i $input -vn $audioArgs $output";Output=$OutputPath});EstimatedBytes=0}
    }
    $videoFilters=New-Object Collections.Generic.List[string];$audioFilters=New-Object Collections.Generic.List[string]
    if($Spec.Resolution -and $Spec.Resolution -ne 'Original') {
        if($Spec.Resolution -eq 'Custom') {
            $w=[Math]::Max(2,[int]$Spec.CustomWidth);$h=[Math]::Max(2,[int]$Spec.CustomHeight)
            if($Spec.KeepAspect){$videoFilters.Add("scale=$($w):-2")}else{$videoFilters.Add("scale=$($w):$($h)")}
        } else {$height=[int]($Spec.Resolution -replace '\D','');$videoFilters.Add("scale=-2:$height")}
    }
    if($Spec.Fps -and $Spec.Fps -ne 'Original'){$fps=([string]$Spec.Fps -replace '[^0-9\.]','');if($fps){$videoFilters.Add("fps=$fps")}}
    if([Math]::Abs([double]$Spec.Speed-1.0) -gt 0.001){$speed=([string]::Format([Globalization.CultureInfo]::InvariantCulture,'{0:0.####}',[double]$Spec.Speed));$videoFilters.Add("setpts=PTS/$speed");if($Analysis.HasAudio){$audioFilters.Add((Get-AtTempoChain ([double]$Spec.Speed)))}}
    if($Spec.Normalize){$audioFilters.Add('loudnorm=I=-16:TP=-1.5:LRA=11')}elseif([Math]::Abs([double]$Spec.Volume-1.0) -gt 0.001){$volume=([string]::Format([Globalization.CultureInfo]::InvariantCulture,'{0:0.####}',[double]$Spec.Volume));$audioFilters.Add("volume=$volume")}
    $vf=if($videoFilters.Count){'-vf "'+($videoFilters -join ',')+'"'}else{''};$af=if($audioFilters.Count){'-af "'+($audioFilters -join ',')+'"'}else{''}
    if($Spec.Mode -eq 'audio') {
        if($Analysis.HasVideo){$args="-hide_banner -y -i $input -c:v copy $af -c:a aac -b:a 160k $output"}
        else{$extension=[IO.Path]::GetExtension($OutputPath).TrimStart('.').ToUpperInvariant();$audioArgs=Get-AudioCodecArguments $extension 'Balanced' 0;$args="-hide_banner -y -i $input $af $audioArgs $output"}
        return [pscustomobject]@{Passes=@([pscustomobject]@{Arguments=$args;Output=$OutputPath});EstimatedBytes=0}
    }
    if($Spec.Mode -eq 'compress' -and $Spec.CompressionMode -eq 'target' -and $Analysis.Duration -gt 0) {
        $totalKbps=[Math]::Floor(([double]$Spec.TargetSizeMB*8192.0/[double]$Analysis.Duration)*0.965);$audioKbps=if($Analysis.HasAudio){[Math]::Min(160,[Math]::Max(64,[Math]::Floor($totalKbps*0.12)))}else{0};$videoKbps=[Math]::Max(120,$totalKbps-$audioKbps)
        $passLog='"'+$PassLogPath.Replace('"','\"')+'"';$audioArg=if($Analysis.HasAudio){"-c:a aac -b:a ${audioKbps}k"}else{'-an'}
        $pass1="-hide_banner -y -i $input $vf -c:v libx264 -b:v ${videoKbps}k -pass 1 -passlogfile $passLog -an -f null NUL"
        if($Spec.AudioMode -eq 'remove'){$audioArg='-an'}
        $pass2="-hide_banner -y -i $input $vf $af -c:v libx264 -b:v ${videoKbps}k -pass 2 -passlogfile $passLog $audioArg -movflags +faststart $output"
        return [pscustomobject]@{Passes=@([pscustomobject]@{Arguments=$pass1;Output=$null},[pscustomobject]@{Arguments=$pass2;Output=$OutputPath});EstimatedBytes=[long]($Spec.TargetSizeMB*1MB)}
    }
    $videoArgs=if($Spec.Mode -eq 'compress'){"-c:v libx264 -crf $(Get-CompressionCrf $Spec.CompressionLevel) -preset medium"}else{'-c:v libx264 -crf 22 -preset medium'}
    $finalAudioArgs=if($Spec.AudioMode -eq 'remove'){'-an'}else{'-c:a aac -b:a 160k'}
    return [pscustomobject]@{Passes=@([pscustomobject]@{Arguments="-hide_banner -y -i $input $vf $af $videoArgs $finalAudioArgs -movflags +faststart $output";Output=$OutputPath});EstimatedBytes=0}
}

function Get-AvailableHardwareEncoders {
    $ffmpeg=Get-Command ffmpeg.exe -ErrorAction SilentlyContinue;if(-not $ffmpeg){return @()}
    try{$text=& $ffmpeg.Source -hide_banner -encoders 2>&1 | Out-String;return @('h264_nvenc','h264_qsv','h264_amf')|Where-Object{$text -match [regex]::Escape($_)}}catch{return @()}
}
