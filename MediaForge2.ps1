Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName PresentationCore
Add-Type -AssemblyName WindowsBase

$bootstrapRoot = if($env:MEDIAFORGE_ROOT){$env:MEDIAFORGE_ROOT.TrimEnd('\')}else{(Get-Location).Path}
$interfacePath = Join-Path $bootstrapRoot 'MediaForge.xaml'
$logicPath = Join-Path $bootstrapRoot 'MediaForgeLogic.ps1'

if(-not(Test-Path -LiteralPath $interfacePath)){throw 'Не найден файл интерфейса MediaForge.xaml.'}
if(-not(Test-Path -LiteralPath $logicPath)){throw 'Не найден файл логики приложения MediaForgeLogic.ps1.'}

[xml]$xaml = [IO.File]::ReadAllText($interfacePath,[Text.Encoding]::UTF8)
$logicSource = [IO.File]::ReadAllText($logicPath,[Text.Encoding]::UTF8)
. ([scriptblock]::Create($logicSource))
