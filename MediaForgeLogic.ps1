$window = [Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $xaml))
foreach($name in 'FileList','GalleryView','GalleryItems','ViewPicker','ListSurface','EmptyAddButton','EmptyAddText','AddMoreButton','AddMoreText','UndoButton','RedoButton','ActionPanel','FolderButton','FolderButtonText','RenameButton','ConversionExpander','ConversionHeaderText','ConversionList','ConversionScrollViewer','BulkPanel','GlobalImagePanel','GlobalVideoPanel','GlobalAudioPanel','GlobalImageLabel','GlobalVideoLabel','GlobalAudioLabel','GlobalImagePicker','GlobalVideoPicker','GlobalAudioPicker','StatusText','ConvertButton','TaglineText','FilesCaption','ThemeCaption','LanguageCaption','ThemePicker','LanguagePicker') {
    Set-Variable $name $window.FindName($name)
}

$appRoot = if($env:MEDIAFORGE_ROOT){$env:MEDIAFORGE_ROOT.TrimEnd('\')}else{(Get-Location).Path}
$settingsPath = Join-Path $appRoot 'mediaforge-settings.json'
$script:language = 'ru'
$script:theme = 'mono'
$script:viewMode = 'list'
$script:updatingPreferences = $false

$script:i18n = @{
    en=@{tagline=' — thoughtful media conversion';theme='THEME';language='LANGUAGE';files='MEDIA QUEUE · DRAG TO ORGANIZE';addMore='Add more media';empty='Drop media here or choose files';folder='New collection';rename='Rename';remove='Remove';conversion='Shape the output';statusDefault='Choose a format for each file';convert='Start conversion';future='Ready-to-create file';outputTip='Double-click to rename the output file';image='Image';video='Video';audio='Audio';folderType='Collection';emptyFolder='Empty collection';fileOne='file';fileMany='files';individual='Mixed formats';mediaFilter='Media';allFiles='All files';added='Added: {0}';renameFolderOnly='Only collections can be renamed in the source list';excluded='Removed from queue: {0}';renameTitle='Rename';outputName='Name the output file';cancel='Cancel';save='Save';createFolder='New collection';createHint='Name it and optionally add media now';addOptional='＋ Add media (optional)';noneSelected='No files selected';selected='Selected: {0}';create='Create';created='Collection “{0}” created';ffmpegMissing='FFmpeg was not found. Install it and add ffmpeg.exe to PATH.';converting='Converting…';processing='Processing {0} of {1}';processingName='Processing {0} of {1}: {2}';start='Start conversion';errors='Finished with {0} errors';done='Done. Created batch {0}';defaultFolder='Collection';bytes='B';kilobytes='KB';megabytes='MB';gigabytes='GB';undo='Undo';redo='Redo';deleteItem='Remove from queue';undone='Last action undone';redone='Action repeated'}
    ru=@{tagline=' — осмысленная конвертация медиа';theme='ТЕМА';language='ЯЗЫК';files='МЕДИА · ПЕРЕТАСКИВАЙТЕ, ЧТОБЫ НАВЕСТИ ПОРЯДОК';addMore='Добавить ещё медиа';empty='Перетащите медиа сюда или выберите файлы';folder='Новая коллекция';rename='Переименовать';remove='Убрать';conversion='Настроить результат';statusDefault='Выберите формат для каждого файла';convert='Начать конвертацию';future='Будущий файл';outputTip='Двойной щелчок — изменить название будущего файла';image='Изображение';video='Видео';audio='Аудио';folderType='Коллекция';emptyFolder='Пустая коллекция';fileOne='файл';fileFew='файла';fileMany='файлов';individual='Разные форматы';mediaFilter='Медиа';allFiles='Все файлы';added='Добавлено: {0}';renameFolderOnly='В исходном списке можно переименовывать только коллекции';excluded='Убрано из списка: {0}';renameTitle='Изменить название';outputName='Название будущего файла';cancel='Отмена';save='Сохранить';createFolder='Новая коллекция';createHint='Введите название и при желании сразу добавьте медиа';addOptional='＋ Добавить медиа (необязательно)';noneSelected='Файлы не выбраны';selected='Выбрано: {0}';create='Создать';created='Коллекция «{0}» создана';ffmpegMissing='FFmpeg не найден. Установите FFmpeg и добавьте ffmpeg.exe в PATH.';converting='Конвертация…';processing='Обрабатывается {0} из {1}';processingName='Обрабатывается {0} из {1}: {2}';start='Начать конвертацию';errors='Завершено с ошибками: {0}';done='Готово. Создан пакет {0}';defaultFolder='Коллекция';bytes='Б';kilobytes='КБ';megabytes='МБ';gigabytes='ГБ';undo='Отменить';redo='Повторить';deleteItem='Убрать из списка';undone='Последнее действие отменено';redone='Действие повторено'}
    zh=@{tagline=' — 让媒体转换更有条理';theme='主题';language='语言';files='媒体队列 · 拖放即可整理';addMore='添加更多媒体';empty='将媒体拖到这里，或选择文件';folder='新建集合';rename='重命名';remove='移除';conversion='设置输出方式';statusDefault='为每个文件选择格式';convert='开始转换';future='待生成文件';outputTip='双击可修改输出文件名';image='图像';video='视频';audio='音频';folderType='集合';emptyFolder='空集合';fileOne='个文件';fileMany='个文件';individual='多种格式';mediaFilter='媒体文件';allFiles='所有文件';added='已添加：{0}';renameFolderOnly='源列表中只能重命名集合';excluded='已从队列移除：{0}';renameTitle='重命名';outputName='输出文件名';cancel='取消';save='保存';createFolder='新建集合';createHint='输入名称，也可以现在添加媒体';addOptional='＋ 添加媒体（可选）';noneSelected='尚未选择文件';selected='已选择：{0}';create='创建';created='已创建集合“{0}”';ffmpegMissing='未找到 FFmpeg。请安装并将 ffmpeg.exe 添加到 PATH。';converting='正在转换…';processing='正在处理第 {0}/{1} 个';processingName='正在处理第 {0}/{1} 个：{2}';start='开始转换';errors='完成，但有 {0} 个错误';done='完成。已创建批次 {0}';defaultFolder='集合';bytes='字节';kilobytes='KB';megabytes='MB';gigabytes='GB'}
    fr=@{tagline=' — conversion média bien pensée';theme='THÈME';language='LANGUE';files='MÉDIAS · GLISSEZ POUR ORGANISER';addMore='Ajouter des médias';empty='Déposez vos médias ici ou choisissez des fichiers';folder='Nouvelle collection';rename='Renommer';remove='Retirer';conversion='Façonner le résultat';statusDefault='Choisissez un format pour chaque fichier';convert='Lancer la conversion';future='Fichier à créer';outputTip='Double-cliquez pour renommer le fichier de sortie';image='Image';video='Vidéo';audio='Audio';folderType='Collection';emptyFolder='Collection vide';fileOne='fichier';fileMany='fichiers';individual='Formats variés';mediaFilter='Médias';allFiles='Tous les fichiers';added='{0} fichier(s) ajouté(s)';renameFolderOnly='Seules les collections peuvent être renommées dans la liste source';excluded='Retiré(s) de la file : {0}';renameTitle='Renommer';outputName='Nom du fichier de sortie';cancel='Annuler';save='Enregistrer';createFolder='Nouvelle collection';createHint='Nommez-la et ajoutez éventuellement des médias';addOptional='＋ Ajouter des médias (facultatif)';noneSelected='Aucun fichier sélectionné';selected='Sélection : {0}';create='Créer';created='Collection « {0} » créée';ffmpegMissing='FFmpeg est introuvable. Installez-le et ajoutez ffmpeg.exe au PATH.';converting='Conversion…';processing='Traitement de {0} sur {1}';processingName='Traitement de {0} sur {1} : {2}';start='Lancer la conversion';errors='Terminé avec {0} erreur(s)';done='Terminé. Lot {0} créé';defaultFolder='Collection';bytes='o';kilobytes='Ko';megabytes='Mo';gigabytes='Go'}
    ja=@{tagline=' — メディア変換を、もっと心地よく';theme='テーマ';language='言語';files='メディア · ドラッグして整理';addMore='メディアを追加';empty='ここにメディアをドロップ、またはファイルを選択';folder='新しいコレクション';rename='名前を変更';remove='取り除く';conversion='出力を整える';statusDefault='ファイルごとに形式を選択してください';convert='変換を開始';future='作成予定のファイル';outputTip='ダブルクリックで出力ファイル名を変更';image='画像';video='動画';audio='音声';folderType='コレクション';emptyFolder='空のコレクション';fileOne='件';fileMany='件';individual='複数の形式';mediaFilter='メディア';allFiles='すべてのファイル';added='{0} 件追加しました';renameFolderOnly='元の一覧ではコレクションのみ名前を変更できます';excluded='キューから {0} 件取り除きました';renameTitle='名前を変更';outputName='出力ファイル名';cancel='キャンセル';save='保存';createFolder='新しいコレクション';createHint='名前を付け、必要ならメディアも追加できます';addOptional='＋ メディアを追加（任意）';noneSelected='ファイルが選択されていません';selected='{0} 件選択';create='作成';created='コレクション「{0}」を作成しました';ffmpegMissing='FFmpeg が見つかりません。インストール後、ffmpeg.exe を PATH に追加してください。';converting='変換中…';processing='{1} 件中 {0} 件目を処理中';processingName='{1} 件中 {0} 件目を処理中：{2}';start='変換を開始';errors='{0} 件のエラーがありました';done='完了しました。バッチ {0} を作成';defaultFolder='コレクション';bytes='B';kilobytes='KB';megabytes='MB';gigabytes='GB'}
    de=@{tagline=' — Medien bewusst konvertieren';theme='DESIGN';language='SPRACHE';files='MEDIEN · ZIEHEN UND ORDNEN';addMore='Weitere Medien hinzufügen';empty='Medien hier ablegen oder Dateien auswählen';folder='Neue Sammlung';rename='Umbenennen';remove='Entfernen';conversion='Ausgabe gestalten';statusDefault='Format für jede Datei wählen';convert='Konvertierung starten';future='Zukünftige Datei';outputTip='Doppelklicken, um die Ausgabedatei umzubenennen';image='Bild';video='Video';audio='Audio';folderType='Sammlung';emptyFolder='Leere Sammlung';fileOne='Datei';fileMany='Dateien';individual='Gemischte Formate';mediaFilter='Medien';allFiles='Alle Dateien';added='Hinzugefügt: {0}';renameFolderOnly='In der Quellliste können nur Sammlungen umbenannt werden';excluded='Aus Warteschlange entfernt: {0}';renameTitle='Umbenennen';outputName='Name der Ausgabedatei';cancel='Abbrechen';save='Speichern';createFolder='Neue Sammlung';createHint='Namen eingeben und auf Wunsch Medien hinzufügen';addOptional='＋ Medien hinzufügen (optional)';noneSelected='Keine Dateien ausgewählt';selected='Ausgewählt: {0}';create='Erstellen';created='Sammlung „{0}“ erstellt';ffmpegMissing='FFmpeg wurde nicht gefunden. Installieren Sie es und fügen Sie ffmpeg.exe zum PATH hinzu.';converting='Konvertierung…';processing='{0} von {1} wird verarbeitet';processingName='{0} von {1} wird verarbeitet: {2}';start='Konvertierung starten';errors='Mit {0} Fehler(n) beendet';done='Fertig. Stapel {0} erstellt';defaultFolder='Sammlung';bytes='B';kilobytes='KB';megabytes='MB';gigabytes='GB'}
    es=@{tagline=' — conversión multimedia con criterio';theme='TEMA';language='IDIOMA';files='ARCHIVOS · ARRASTRA PARA ORGANIZAR';addMore='Añadir más archivos';empty='Suelta archivos aquí o selecciónalos';folder='Nueva colección';rename='Renombrar';remove='Quitar';conversion='Definir el resultado';statusDefault='Elige un formato para cada archivo';convert='Iniciar conversión';future='Archivo por crear';outputTip='Haz doble clic para cambiar el nombre de salida';image='Imagen';video='Vídeo';audio='Audio';folderType='Colección';emptyFolder='Colección vacía';fileOne='archivo';fileMany='archivos';individual='Formatos variados';mediaFilter='Multimedia';allFiles='Todos los archivos';added='Añadidos: {0}';renameFolderOnly='En la lista de origen solo se pueden renombrar colecciones';excluded='Quitados de la cola: {0}';renameTitle='Renombrar';outputName='Nombre del archivo de salida';cancel='Cancelar';save='Guardar';createFolder='Nueva colección';createHint='Ponle un nombre y añade archivos si quieres';addOptional='＋ Añadir archivos (opcional)';noneSelected='No hay archivos seleccionados';selected='Seleccionados: {0}';create='Crear';created='Colección «{0}» creada';ffmpegMissing='No se encontró FFmpeg. Instálalo y añade ffmpeg.exe al PATH.';converting='Convirtiendo…';processing='Procesando {0} de {1}';processingName='Procesando {0} de {1}: {2}';start='Iniciar conversión';errors='Finalizado con {0} error(es)';done='Listo. Se creó el lote {0}';defaultFolder='Colección';bytes='B';kilobytes='KB';megabytes='MB';gigabytes='GB'}
}

$script:languageChoices = @(
    [pscustomobject]@{Key='en';Label='English'},[pscustomobject]@{Key='ru';Label='Русский'},[pscustomobject]@{Key='zh';Label='中文'},
    [pscustomobject]@{Key='fr';Label='Français'},[pscustomobject]@{Key='ja';Label='日本語'},[pscustomobject]@{Key='de';Label='Deutsch'},[pscustomobject]@{Key='es';Label='Español'}
)
$script:themes = [ordered]@{
    mono=@{Window='#F1F1EE';Surface='#FFFFFF';Card='#F8F8F6';Soft='#E8E8E4';Hover='#DEDEDA';Selected='#CFCFCA';Primary='#111111';OnPrimary='#FFFFFF';Text='#111111';Muted='#686864';Border='#C9C9C4';Accent='#555550';Folder='#E8E8E4'}
    editorial=@{Window='#FFF9F7';Surface='#FFFFFF';Card='#FFF0F2';Soft='#E9D7CE';Hover='#F6DDE3';Selected='#EAB8C2';Primary='#7B292C';OnPrimary='#FFFDFC';Text='#38211D';Muted='#85675E';Border='#D8B9AF';Accent='#B94F5B';Folder='#F4D5DC'}
    grove=@{Window='#F1EBDD';Surface='#FFFDF5';Card='#F5F0DF';Soft='#DCE3C9';Hover='#CED9B7';Selected='#B8C99A';Primary='#36533C';OnPrimary='#FFFDF5';Text='#28362A';Muted='#65705E';Border='#BBC4A9';Accent='#76945E';Folder='#DCE3C9'}
    cobalt=@{Window='#EEF5FF';Surface='#FFFFFF';Card='#F3F7FC';Soft='#DCE9F8';Hover='#C9DDF3';Selected='#AFCDEB';Primary='#174F8A';OnPrimary='#FFFFFF';Text='#16324A';Muted='#61788B';Border='#B8CCE0';Accent='#3982C4';Folder='#DCE9F8'}
}
$script:themeLabels = @{
    en=@('Black & white','Clay & rose','Beige & green','White & blue');ru=@('Чёрно-белая','Глина и роза','Бежево-зелёная','Бело-синяя');zh=@('黑白','陶土与玫瑰','米色与绿色','白色与蓝色');fr=@('Noir et blanc','Terre et rose','Beige et vert','Blanc et bleu');ja=@('モノクロ','クレイ＆ローズ','ベージュ＆グリーン','ホワイト＆ブルー');de=@('Schwarz & Weiß','Ton & Rosé','Beige & Grün','Weiß & Blau');es=@('Blanco y negro','Arcilla y rosa','Beige y verde','Blanco y azul')
}

$script:historyI18n = @{
    zh=@{undo='撤销';redo='重做';deleteItem='从队列移除';undone='已撤销上一步操作';redone='已重新执行操作'}
    fr=@{undo='Annuler';redo='Rétablir';deleteItem='Retirer de la file';undone='Dernière action annulée';redone='Action rétablie'}
    ja=@{undo='元に戻す';redo='やり直す';deleteItem='キューから取り除く';undone='直前の操作を元に戻しました';redone='操作をやり直しました'}
    de=@{undo='Rückgängig';redo='Wiederholen';deleteItem='Aus Warteschlange entfernen';undone='Letzte Aktion rückgängig gemacht';redone='Aktion wiederholt'}
    es=@{undo='Deshacer';redo='Rehacer';deleteItem='Quitar de la cola';undone='Se deshizo la última acción';redone='Se repitió la acción'}
}
$script:featureI18n = @{
    en=@{addMedia='Add media';addToFolder='Add media to this collection';allImages='Images to';allVideos='Videos to';allAudio='Audio to';listView='List';galleryView='Gallery';typeLabel='Type';formatLabel='Format';nameLabel='Name'}
    ru=@{addMedia='Добавить медиа';addToFolder='Добавить медиа в эту коллекцию';allImages='Изображения в';allVideos='Видео в';allAudio='Аудио в';listView='Список';galleryView='Галерея';typeLabel='Тип';formatLabel='Формат';nameLabel='Название'}
    zh=@{addMedia='添加媒体';addToFolder='将媒体添加到此集合';allImages='图像转为';allVideos='视频转为';allAudio='音频转为';listView='列表';galleryView='画廊';typeLabel='类型';formatLabel='格式';nameLabel='名称'}
    fr=@{addMedia='Ajouter des médias';addToFolder='Ajouter des médias à cette collection';allImages='Images en';allVideos='Vidéos en';allAudio='Audio en';listView='Liste';galleryView='Galerie';typeLabel='Type';formatLabel='Format';nameLabel='Nom'}
    ja=@{addMedia='メディアを追加';addToFolder='このコレクションにメディアを追加';allImages='画像を';allVideos='動画を';allAudio='音声を';listView='リスト';galleryView='ギャラリー';typeLabel='種類';formatLabel='形式';nameLabel='名前'}
    de=@{addMedia='Medien hinzufügen';addToFolder='Medien zu dieser Sammlung hinzufügen';allImages='Bilder in';allVideos='Videos in';allAudio='Audio in';listView='Liste';galleryView='Galerie';typeLabel='Typ';formatLabel='Format';nameLabel='Name'}
    es=@{addMedia='Añadir archivos';addToFolder='Añadir archivos a esta colección';allImages='Imágenes a';allVideos='Vídeos a';allAudio='Audio a';listView='Lista';galleryView='Galería';typeLabel='Tipo';formatLabel='Formato';nameLabel='Nombre'}
}
$script:shortFiles = @{en='Drop media';ru='Перетащите медиа';zh='拖入媒体';fr='Déposez vos médias';ja='メディアをドロップ';de='Medien hier ablegen';es='Suelta archivos aquí'}

function T([string]$key) {
    if($script:language -eq 'ru') {
        $folderWords=@{folder='Создать папку';create='Создать папку';createFolder='Создать папку';createHint='Введите название папки и при желании сразу добавьте медиа';folderType='Папка';emptyFolder='Пустая папка';defaultFolder='Папка';created='Папка «{0}» создана'}
        if($folderWords.ContainsKey($key)){return [string]$folderWords[$key]}
    }
    if($key -eq 'files'){return [string]$script:shortFiles[$script:language]}
    if($script:i18n[$script:language].ContainsKey($key)){return [string]$script:i18n[$script:language][$key]}
    if($script:featureI18n[$script:language].ContainsKey($key)){return [string]$script:featureI18n[$script:language][$key]}
    if($script:historyI18n.ContainsKey($script:language) -and $script:historyI18n[$script:language].ContainsKey($key)){return [string]$script:historyI18n[$script:language][$key]}
    return [string]$script:i18n.en[$key]
}
function TF([string]$key,[object[]]$values) { return [string]::Format((T $key),$values) }
function Xml-Escape([string]$value) { return [Security.SecurityElement]::Escape($value) }

try {
    if(Test-Path -LiteralPath $settingsPath){$saved=Get-Content -Raw -Encoding UTF8 -LiteralPath $settingsPath|ConvertFrom-Json;if($script:i18n.ContainsKey([string]$saved.language)){$script:language=[string]$saved.language};if($script:themes.Contains([string]$saved.theme)){$script:theme=[string]$saved.theme};if(@('list','gallery') -contains [string]$saved.viewMode){$script:viewMode=[string]$saved.viewMode}}
} catch {}

function Save-Preferences {
    try{[pscustomobject]@{language=$script:language;theme=$script:theme;viewMode=$script:viewMode}|ConvertTo-Json|Set-Content -Encoding UTF8 -LiteralPath $settingsPath}catch{}
}

function Apply-Theme {
    $palette=$script:themes[$script:theme]
    foreach($key in $palette.Keys){$window.Resources[$key+'Brush']=[Windows.Media.SolidColorBrush]::new([Windows.Media.ColorConverter]::ConvertFromString($palette[$key]))}
}
$imageExt = '.jpg','.jpeg','.png','.webp','.bmp','.gif','.tif','.tiff','.avif'
$videoExt = '.mp4','.mov','.mkv','.avi','.webm','.wmv','.m4v'
$audioExt = '.mp3','.wav','.flac','.m4a','.aac','.ogg','.opus','.wma'
$files = New-Object System.Collections.ObjectModel.ObservableCollection[object]
$nodes = New-Object System.Collections.ObjectModel.ObservableCollection[object]
$conversionRows = New-Object System.Collections.ObjectModel.ObservableCollection[object]
$script:formatChoices = @{}
$script:outputNames = @{}
$script:selectedItems = @()
$script:selectionAnchor = $null
$FileList.ItemsSource = $nodes
$GalleryItems.ItemsSource = $files
$ConversionList.ItemsSource = $conversionRows
$script:dragStart = $null
$script:dragItem = $null
$script:lastListClickItem=$null;$script:lastListClickAt=[datetime]::MinValue
$script:lastOutputClickItem=$null;$script:lastOutputClickAt=[datetime]::MinValue
$script:scrollStates=@{}
$script:undoStack = New-Object Collections.Generic.List[object]
$script:redoStack = New-Object Collections.Generic.List[object]
$script:restoringHistory = $false

function Get-NodeSnapshot($node) {
    if($node.IsFolder) {
        $children=@();foreach($child in @($node.Children)){$children+=,(Get-NodeSnapshot $child)}
        $folderFormats=@{};if($node.FolderFormats){foreach($key in $node.FolderFormats.Keys){$folderFormats[$key]=$node.FolderFormats[$key]}}
        return [pscustomobject]@{IsFolder=$true;Name=[string]$node.Name;FolderFormat=$node.FolderFormat;FolderFormats=$folderFormats;Children=$children}
    }
    return [pscustomobject]@{IsFolder=$false;Path=[string]$node.Path;Name=[string]$node.Name}
}

function Get-StateSnapshot {
    $tree=@();foreach($node in @($nodes)){$tree+=,(Get-NodeSnapshot $node)}
    $names=@{};foreach($key in $script:outputNames.Keys){$names[$key]=$script:outputNames[$key]}
    $formats=@{};foreach($key in $script:formatChoices.Keys){$formats[$key]=$script:formatChoices[$key]}
    return [pscustomobject]@{Tree=$tree;OutputNames=$names;FormatChoices=$formats}
}

function Restore-SnapshotNode($snapshot,$collection) {
    if($snapshot.IsFolder) {
        $node=New-FolderNode ([string]$snapshot.Name);$node.FolderFormat=$snapshot.FolderFormat;if($snapshot.FolderFormats){foreach($key in $snapshot.FolderFormats.Keys){$node.FolderFormats[$key]=$snapshot.FolderFormats[$key]}};$collection.Add($node)
        foreach($child in @($snapshot.Children)){Restore-SnapshotNode $child $node.Children}
    } else {
        $node=New-FileNode ([string]$snapshot.Path)
        if($node){if($snapshot.Name){$node.Name=[string]$snapshot.Name;$node.DisplayName=Get-ShortName $node.Name};$files.Add($node);$collection.Add($node)}
    }
}

function Restore-StateSnapshot($snapshot) {
    $script:restoringHistory=$true
    try {
        Clear-MarkedItems;$script:selectionAnchor=$null;$files.Clear();$nodes.Clear();$script:outputNames=@{};$script:formatChoices=@{}
        foreach($key in $snapshot.OutputNames.Keys){$script:outputNames[$key]=$snapshot.OutputNames[$key]}
        if($snapshot.FormatChoices){foreach($key in $snapshot.FormatChoices.Keys){$script:formatChoices[$key]=$snapshot.FormatChoices[$key]}}
        foreach($nodeSnapshot in @($snapshot.Tree)){Restore-SnapshotNode $nodeSnapshot $nodes}
        Update-UI
    } finally {$script:restoringHistory=$false}
}

function Update-HistoryButtons {
    $UndoButton.IsEnabled=$script:undoStack.Count -gt 0;$RedoButton.IsEnabled=$script:redoStack.Count -gt 0
    $UndoButton.ToolTip=T 'undo';$RedoButton.ToolTip=T 'redo'
}

function Commit-History($before) {
    if($script:restoringHistory -or $null -eq $before){return}
    $script:undoStack.Add($before);if($script:undoStack.Count -gt 50){$script:undoStack.RemoveAt(0)};$script:redoStack.Clear();Update-HistoryButtons
}

function Undo-History {
    if(-not $script:undoStack.Count){return}
    $current=Get-StateSnapshot;$index=$script:undoStack.Count-1;$target=$script:undoStack[$index];$script:undoStack.RemoveAt($index);$script:redoStack.Add($current)
    Restore-StateSnapshot $target;Update-HistoryButtons;$StatusText.Text=T 'undone'
}

function Redo-History {
    if(-not $script:redoStack.Count){return}
    $current=Get-StateSnapshot;$index=$script:redoStack.Count-1;$target=$script:redoStack[$index];$script:redoStack.RemoveAt($index);$script:undoStack.Add($current)
    Restore-StateSnapshot $target;Update-HistoryButtons;$StatusText.Text=T 'redone'
}

function Format-Size([long]$bytes) {
    $culture=@{en='en-US';ru='ru-RU';zh='zh-CN';fr='fr-FR';ja='ja-JP';de='de-DE';es='es-ES'}[$script:language]
    $provider=[Globalization.CultureInfo]::GetCultureInfo($culture)
    if($bytes -ge 1GB){return '{0} {1}' -f (($bytes/1GB).ToString('N1',$provider)),(T 'gigabytes')}
    if($bytes -ge 1MB){return '{0} {1}' -f (($bytes/1MB).ToString('N1',$provider)),(T 'megabytes')}
    if($bytes -ge 1KB){return '{0} {1}' -f (($bytes/1KB).ToString('N0',$provider)),(T 'kilobytes')}
    return "$bytes $(T 'bytes')"
}

function Get-Category([string]$path) {
    $extension = [IO.Path]::GetExtension($path).ToLowerInvariant()
    if($imageExt -contains $extension){return 'image'}
    if($videoExt -contains $extension){return 'video'}
    if($audioExt -contains $extension){return 'audio'}
    return $null
}

function Get-ShortName([string]$name) {
    if([string]::IsNullOrWhiteSpace($name)){return ''}
    if($name.Length -le 10){return $name}
    return $name.Substring(0,10) + '...'
}

function Get-FormatOptions([string]$category) {
    if($category -eq 'image'){return @('JPG','JPEG','PNG','WEBP','AVIF','BMP','TIFF','GIF')}
    if($category -eq 'video'){return @('MP4','MOV','MKV','WEBM','AVI','WMV')}
    return @('MP3','WAV','FLAC','M4A','OGG','AAC','OPUS','WMA')
}

function Get-CategoryLabel([string]$category) { return T $category }

function Get-VideoThumbnail([string]$path) {
    $ffmpeg=Get-Command ffmpeg.exe -ErrorAction SilentlyContinue
    if(-not $ffmpeg){return $null}
    try {
        $info=Get-Item -LiteralPath $path
        $cacheFolder=Join-Path ([IO.Path]::GetTempPath()) 'MediaForge\previews'
        [void](New-Item -ItemType Directory -Path $cacheFolder -Force)
        $hash=[Security.Cryptography.SHA256]::Create()
        try{$keyBytes=[Text.Encoding]::UTF8.GetBytes("cover-v2|$($info.FullName)|$($info.Length)|$($info.LastWriteTimeUtc.Ticks)");$key=([BitConverter]::ToString($hash.ComputeHash($keyBytes))).Replace('-','').ToLowerInvariant()}finally{$hash.Dispose()}
        $thumbnailPath=Join-Path $cacheFolder ($key+'.jpg')
        if(Test-Path -LiteralPath $thumbnailPath){return $thumbnailPath}
        $start=New-Object Diagnostics.ProcessStartInfo;$start.FileName=$ffmpeg.Source
        $start.Arguments="-hide_banner -loglevel error -y -i `"$path`" -map 0:v:0 -frames:v 1 -vf `"scale=320:180:force_original_aspect_ratio=increase,crop=320:180`" -q:v 3 `"$thumbnailPath`""
        $start.UseShellExecute=$false;$start.CreateNoWindow=$true;$start.RedirectStandardError=$true
        $process=New-Object Diagnostics.Process;$process.StartInfo=$start;[void]$process.Start()
        if(-not $process.WaitForExit(12000)){try{$process.Kill()}catch{};$process.Dispose();return $null}
        $process.Dispose()
        if(Test-Path -LiteralPath $thumbnailPath){return $thumbnailPath}
    } catch {}
    return $null
}

function Get-VideoResolution([string]$path) {
    $ffprobe=Get-Command ffprobe.exe -ErrorAction SilentlyContinue
    if(-not $ffprobe){return ''}
    try {
        $start=New-Object Diagnostics.ProcessStartInfo;$start.FileName=$ffprobe.Source
        $start.Arguments="-v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 `"$path`""
        $start.UseShellExecute=$false;$start.CreateNoWindow=$true;$start.RedirectStandardOutput=$true;$start.RedirectStandardError=$true
        $process=New-Object Diagnostics.Process;$process.StartInfo=$start;[void]$process.Start()
        $output=$process.StandardOutput.ReadToEnd().Trim()
        if(-not $process.WaitForExit(8000)){try{$process.Kill()}catch{};$process.Dispose();return ''}
        $process.Dispose()
        if($output -match '^(\d{2,5})x(\d{2,5})'){return "$($matches[1]) × $($matches[2])"}
    } catch {}
    return ''
}

function New-FileNode([string]$path) {
    if(-not(Test-Path -LiteralPath $path -PathType Leaf)){return $null}
    $category = Get-Category $path
    if(-not $category){return $null}
    $info = Get-Item -LiteralPath $path
    $extension = $info.Extension.TrimStart('.').ToUpperInvariant()
    $thumbnail=if($category -eq 'image'){$info.FullName}elseif($category -eq 'video'){Get-VideoThumbnail $info.FullName}else{$null}
    $resolution=if($category -eq 'video'){Get-VideoResolution $info.FullName}else{''}
    $categoryLabel=Get-CategoryLabel $category
    return [pscustomobject]@{
        Name=$info.Name; DisplayName=(Get-ShortName $info.Name); Category=$category; Extension=$extension
        Details=$categoryLabel; Size=(Format-Size $info.Length); Bytes=$info.Length; Path=$info.FullName
        Thumbnail=$thumbnail; Resolution=$resolution; IsImage=($category -eq 'image'); IsVideo=($category -eq 'video'); IsAudio=($category -eq 'audio')
        AudioVariant=$(if($category -eq 'audio'){Get-Random -Minimum 1 -Maximum 4}else{0})
        IsFolder=$false; Children=$null; Number=''; FolderFormat=$null; FolderFormats=@{}; IsMarked=$false; DeleteTooltip=(T 'deleteItem'); AddToFolderTooltip=''
        CategoryDisplay=$categoryLabel;TypeLine="$(T 'typeLabel'): $categoryLabel";FormatLine="$(T 'formatLabel'): $extension";NameLine="$(T 'nameLabel'): $($info.Name)"
    }
}

function New-FolderNode([string]$name) {
    return [pscustomobject]@{
        Name=$name; DisplayName=(Get-ShortName $name); Category='folderType'; Extension='—'; Details=(T 'emptyFolder')
        Size=''; Path=$null; Thumbnail=$null; Resolution=''; IsImage=$false; IsVideo=$false; IsAudio=$false; AudioVariant=0; IsFolder=$true
        Children=(New-Object System.Collections.ObjectModel.ObservableCollection[object]); Number=''; FolderFormat=$null; FolderFormats=@{}; IsMarked=$false; DeleteTooltip=(T 'deleteItem'); AddToFolderTooltip=(T 'addToFolder')
    }
}

function Get-DescendantFileCount($item) {
    if(-not $item.IsFolder){return 1}
    $count=0
    foreach($child in @($item.Children)){$count += Get-DescendantFileCount $child}
    return $count
}

function Get-FileWord([int]$count) {
    if($script:language -ne 'ru'){if($count -eq 1){return T 'fileOne'};return T 'fileMany'}
    $lastTwo=$count%100;$last=$count%10
    if($lastTwo -ge 11 -and $lastTwo -le 14){return T 'fileMany'}
    if($last -eq 1){return T 'fileOne'}
    if($last -ge 2 -and $last -le 4){return T 'fileFew'}
    return T 'fileMany'
}

function Update-FolderDetails($collection) {
    $fileNumber=0
    foreach($node in @($collection)) {
        $node.DisplayName=Get-ShortName $node.Name
        $node.DeleteTooltip=T 'deleteItem'
        if($node.IsFolder){$node.AddToFolderTooltip=T 'addToFolder'}
        if($node.IsFolder) {
            $node.Number=''
            Update-FolderDetails $node.Children
            $count=Get-DescendantFileCount $node
            $node.Details=if($count){"$count $(Get-FileWord $count)"}else{T 'emptyFolder'}
        } else {$fileNumber++;$node.Number=[string]$fileNumber;$node.Details=Get-CategoryLabel $node.Category;$node.CategoryDisplay=$node.Details;$node.TypeLine="$(T 'typeLabel'): $($node.Details)";$node.FormatLine="$(T 'formatLabel'): $($node.Extension)";$node.NameLine="$(T 'nameLabel'): $($node.Name)";$node.Size=Format-Size $node.Bytes}
    }
}

function New-ConversionFileRow($file) {
    $options=New-Object System.Collections.ObjectModel.ObservableCollection[string]
    foreach($format in Get-FormatOptions $file.Category){$options.Add($format)}
    $chosen=if($script:formatChoices.ContainsKey($file.Path) -and $options.Contains($script:formatChoices[$file.Path])){$script:formatChoices[$file.Path]}elseif($options.Contains($file.Extension)){$file.Extension}else{$options[0]}
    $script:formatChoices[$file.Path]=$chosen
    $base=if($script:outputNames.ContainsKey($file.Path)){$script:outputNames[$file.Path]}else{[IO.Path]::GetFileNameWithoutExtension($file.Name)}
    $script:outputNames[$file.Path]=$base
    return [pscustomobject]@{
        Source=$file; Thumbnail=$file.Thumbnail; SourceDisplayName=(Get-ShortName $file.Name)
        SourceInfo="$(Get-CategoryLabel $file.Category) · $($file.Extension)"; Format=$chosen; Options=$options
            OutputBase=$base; OutputDisplayName=(Get-ShortName ($base+'.'+$chosen.ToLowerInvariant())); FutureFileLabel=(T 'future'); OutputTooltip=(T 'outputTip'); IsFolder=$false; Children=$null
    }
}

function Get-DescendantFiles($node) {
    if(-not $node.IsFolder){return ,$node}
    foreach($child in @($node.Children)){Get-DescendantFiles $child}
}

function New-ConversionNode($node) {
    if(-not $node.IsFolder){return New-ConversionFileRow $node}
    $children=New-Object System.Collections.ObjectModel.ObservableCollection[object]
    foreach($child in @($node.Children)){$children.Add((New-ConversionNode $child))}
    $descendants=@(Get-DescendantFiles $node)
    if(-not $node.FolderFormats){$node.FolderFormats=@{}}
    $imageOptions=New-Object System.Collections.ObjectModel.ObservableCollection[string];$videoOptions=New-Object System.Collections.ObjectModel.ObservableCollection[string];$audioOptions=New-Object System.Collections.ObjectModel.ObservableCollection[string]
    foreach($format in Get-FormatOptions 'image'){$imageOptions.Add($format)};foreach($format in Get-FormatOptions 'video'){$videoOptions.Add($format)};foreach($format in Get-FormatOptions 'audio'){$audioOptions.Add($format)}
    foreach($list in @($imageOptions,$videoOptions,$audioOptions)){$list.Add('...')}
    $imageFormat=if($node.FolderFormats.ContainsKey('image')){$node.FolderFormats.image}else{'...'}
    $videoFormat=if($node.FolderFormats.ContainsKey('video')){$node.FolderFormats.video}else{'...'}
    $audioFormat=if($node.FolderFormats.ContainsKey('audio')){$node.FolderFormats.audio}else{'...'}
    return [pscustomobject]@{
        Source=$node; Thumbnail=$null; SourceDisplayName=$node.DisplayName; SourceInfo=$node.Details
        OutputDisplayName=$node.DisplayName; IsFolder=$true; Children=$children
        HasImages=(@($descendants|Where-Object Category -eq 'image').Count -gt 0);HasVideos=(@($descendants|Where-Object Category -eq 'video').Count -gt 0);HasAudio=(@($descendants|Where-Object Category -eq 'audio').Count -gt 0)
        ImageOptions=$imageOptions;VideoOptions=$videoOptions;AudioOptions=$audioOptions;ImageFormat=$imageFormat;VideoFormat=$videoFormat;AudioFormat=$audioFormat
        ImageBulkLabel=(T 'allImages');VideoBulkLabel=(T 'allVideos');AudioBulkLabel=(T 'allAudio')
    }
}

function Set-BulkPickerItems($picker,[string]$category) {
    $picker.Items.Clear();foreach($format in Get-FormatOptions $category){[void]$picker.Items.Add($format)};[void]$picker.Items.Add('...');$picker.SelectedIndex=$picker.Items.Count-1
}

function Update-BulkControls {
    $hasImages=@($files|Where-Object Category -eq 'image').Count -gt 0;$hasVideos=@($files|Where-Object Category -eq 'video').Count -gt 0;$hasAudio=@($files|Where-Object Category -eq 'audio').Count -gt 0
    $GlobalImagePanel.Visibility=if($hasImages){'Visible'}else{'Collapsed'};$GlobalVideoPanel.Visibility=if($hasVideos){'Visible'}else{'Collapsed'};$GlobalAudioPanel.Visibility=if($hasAudio){'Visible'}else{'Collapsed'}
    $BulkPanel.Visibility=if($hasImages -or $hasVideos -or $hasAudio){'Visible'}else{'Collapsed'}
    $script:loadingBulkPicker=$true
    try{Set-BulkPickerItems $GlobalImagePicker 'image';Set-BulkPickerItems $GlobalVideoPicker 'video';Set-BulkPickerItems $GlobalAudioPicker 'audio'}finally{$script:loadingBulkPicker=$false}
}

function Build-ConversionRows {
    $script:buildingConversionRows=$true
    try {
        $conversionRows.Clear()
        foreach($node in @($nodes)){$conversionRows.Add((New-ConversionNode $node))}
    } finally {$script:buildingConversionRows=$false}
}

function Update-UI {
    Update-FolderDetails $nodes
    $hasNodes=$nodes.Count -gt 0
    $hasFiles=$files.Count -gt 0
    $EmptyAddButton.Visibility=if($hasNodes){'Collapsed'}else{'Visible'}
    $ActionPanel.Visibility='Visible'
    $RenameButton.IsEnabled=$hasNodes
    $ConversionExpander.IsEnabled=$hasFiles
    if(-not $hasFiles){$ConversionExpander.IsExpanded=$false}
    $ConvertButton.IsEnabled=$hasFiles
    Build-ConversionRows
    Update-BulkControls
    $FileList.Items.Refresh()
    $GalleryItems.Items.Refresh()
    Update-HistoryButtons
}

function Apply-ViewMode {
    $FileList.Visibility=if($script:viewMode -eq 'list'){'Visible'}else{'Collapsed'}
    $GalleryView.Visibility=if($script:viewMode -eq 'gallery'){'Visible'}else{'Collapsed'}
}

function Apply-Language {
    $script:updatingPreferences=$true
    try {
        $TaglineText.Text=T 'tagline';$ThemeCaption.Text=T 'theme';$LanguageCaption.Text=T 'language';$FilesCaption.Text=T 'files'
        $AddMoreButton.ToolTip=T 'addMore';$AddMoreText.Text=T 'addMedia';$EmptyAddText.Text=T 'empty';$FolderButtonText.Text=T 'folder';$RenameButton.Content=T 'rename';$UndoButton.ToolTip=T 'undo';$RedoButton.ToolTip=T 'redo'
        $ConversionHeaderText.Text=T 'conversion';$StatusText.Text=T 'statusDefault';$ConvertButton.Content=T 'convert'
        $GlobalImageLabel.Text=T 'allImages';$GlobalVideoLabel.Text=T 'allVideos';$GlobalAudioLabel.Text=T 'allAudio'
        $labels=$script:themeLabels[$script:language];$themeKeys=@('mono','editorial','grove','cobalt');$primary=@('#111111','#7B292C','#36533C','#174F8A');$secondary=@('#FFFFFF','#F6DDE3','#F1EBDD','#FFFFFF');$secondaryBorder=@('#D5D5D0','#E8C7CF','#D3C9B4','#B8CCE0')
        $ThemePicker.Items.Clear();for($index=0;$index -lt 4;$index++){[void]$ThemePicker.Items.Add([pscustomobject]@{Key=$themeKeys[$index];Label=$labels[$index];Primary=$primary[$index];Secondary=$secondary[$index];SecondaryBorder=$secondaryBorder[$index]})};$ThemePicker.SelectedIndex=[Array]::IndexOf($themeKeys,$script:theme)
        $ViewPicker.Items.Clear();[void]$ViewPicker.Items.Add((T 'listView'));[void]$ViewPicker.Items.Add((T 'galleryView'));$ViewPicker.SelectedIndex=if($script:viewMode -eq 'gallery'){1}else{0}
        $LanguagePicker.Items.Clear();foreach($choice in $script:languageChoices){[void]$LanguagePicker.Items.Add([string]$choice.Label)}
        $LanguagePicker.SelectedIndex=[Array]::FindIndex([object[]]$script:languageChoices,[Predicate[object]]{param($item)$item.Key -eq $script:language})
        Update-UI
        Apply-ViewMode
    } finally {$script:updatingPreferences=$false}
}

function Add-Files([string[]]$paths,$targetFolder=$null,[bool]$recordHistory=$true) {
    $before=if($recordHistory -and -not $script:restoringHistory){Get-StateSnapshot}else{$null}
    $container=$nodes
    if($targetFolder -and $targetFolder.IsFolder){$container=$targetFolder.Children}
    $added=0
    $newItems=New-Object Collections.Generic.List[object]
    foreach($path in $paths) {
        $resolved=$null
        try{$resolved=(Resolve-Path -LiteralPath $path -ErrorAction Stop).Path}catch{continue}
        if($files | Where-Object Path -eq $resolved){continue}
        $item=New-FileNode $resolved
        if($item){$files.Add($item);$container.Add($item);$newItems.Add($item);$added++}
    }
    Update-UI
    if($added){Animate-NewNodes @($newItems);Commit-History $before;$StatusText.Text=TF 'added' @($added)}
    return $added
}

function Remove-VisualNode($collection,$target) {
    if($collection.Contains($target)){$collection.Remove($target);return $true}
    foreach($node in @($collection)){if($node.IsFolder -and (Remove-VisualNode $node.Children $target)){return $true}}
    return $false
}

function Remove-LogicalFiles($item) {
    if($item.IsFolder){foreach($child in @($item.Children)){Remove-LogicalFiles $child}}
    else{[void]$files.Remove($item)}
}

function Find-ParentCollection($collection,$target) {
    if($collection.Contains($target)){return ,$collection}
    foreach($node in @($collection)) {
        if($node.IsFolder){$found=Find-ParentCollection $node.Children $target;if($found){return $found}}
    }
    return $null
}

function Contains-Node($folder,$candidate) {
    if(-not $folder.IsFolder){return $false}
    foreach($child in @($folder.Children)){if($child -eq $candidate){return $true};if($child.IsFolder -and (Contains-Node $child $candidate)){return $true}}
    return $false
}

function Find-VisualAncestor($start,[type]$wantedType) {
    $current=$start
    while($current) {
        if($wantedType.IsInstanceOfType($current)){return $current}
        try{$current=[Windows.Media.VisualTreeHelper]::GetParent($current)}catch{return $null}
    }
    return $null
}

function Find-NamedVisualAncestor($start,[string]$name) {
    $current=$start
    while($current) {
        if($current -is [Windows.FrameworkElement] -and $current.Name -eq $name){return $current}
        try{$current=[Windows.Media.VisualTreeHelper]::GetParent($current)}catch{return $null}
    }
    return $null
}

function Find-VisualDescendant($root,[type]$wantedType) {
    if($wantedType.IsInstanceOfType($root)){return $root}
    $count=0;try{$count=[Windows.Media.VisualTreeHelper]::GetChildrenCount($root)}catch{return $null}
    for($index=0;$index -lt $count;$index++){$found=Find-VisualDescendant ([Windows.Media.VisualTreeHelper]::GetChild($root,$index)) $wantedType;if($found){return $found}}
    return $null
}

function Find-NamedVisualDescendant($root,[string]$name) {
    if($root -is [Windows.FrameworkElement] -and $root.Name -eq $name){return $root}
    $count=0;try{$count=[Windows.Media.VisualTreeHelper]::GetChildrenCount($root)}catch{return $null}
    for($index=0;$index -lt $count;$index++){$found=Find-NamedVisualDescendant ([Windows.Media.VisualTreeHelper]::GetChild($root,$index)) $name;if($found){return $found}}
    return $null
}

function Animate-NewNodes([object[]]$items) {
    if(-not $items.Count){return}
    $captured=@($items);$action={
        $window.UpdateLayout();$sequence=0
        foreach($item in $captured){
            $surface=$null
            if($script:viewMode -eq 'gallery' -and -not $item.IsFolder){$surface=$GalleryItems.ItemContainerGenerator.ContainerFromItem($item)}
            if(-not $surface){$container=Get-NodeContainer $nodes $FileList.ItemContainerGenerator $item;if($container){$surface=Find-NamedVisualDescendant $container 'RowSurface'}}
            if(-not $surface){continue}
            $fileIndex=if($item.IsFolder){[Array]::IndexOf(@($nodes),$item)}else{$files.IndexOf($item)};$from=if(($fileIndex%2) -eq 0){-480}else{480}
            $surface.RenderTransform=New-Object Windows.Media.TranslateTransform;$delay=[TimeSpan]::FromMilliseconds($sequence*140);$duration=[Windows.Duration]::new([TimeSpan]::FromMilliseconds(420));$ease=New-Object Windows.Media.Animation.CubicEase;$ease.EasingMode='EaseOut'
            $move=New-Object Windows.Media.Animation.DoubleAnimation;$move.From=[double]$from;$move.To=0;$move.Duration=$duration;$move.BeginTime=$delay;$move.EasingFunction=$ease;$move.FillBehavior='Stop'
            $fade=New-Object Windows.Media.Animation.DoubleAnimation;$fade.From=0;$fade.To=1;$fade.Duration=$duration;$fade.BeginTime=$delay;$fade.EasingFunction=$ease;$fade.FillBehavior='Stop'
            $surface.RenderTransform.BeginAnimation([Windows.Media.TranslateTransform]::XProperty,$move);$surface.BeginAnimation([Windows.UIElement]::OpacityProperty,$fade);$sequence++
        }
    }.GetNewClosure();[void]$window.Dispatcher.BeginInvoke([Action]$action,[Windows.Threading.DispatcherPriority]::Loaded)
}

function Scroll-WithGesture($viewer,$event) {
    if(-not $viewer -or $viewer.ScrollableHeight -le 0){return}
    $key=[Runtime.CompilerServices.RuntimeHelpers]::GetHashCode($viewer)
    if(-not $script:scrollStates.ContainsKey($key)){
        $timer=New-Object Windows.Threading.DispatcherTimer;$timer.Interval=[TimeSpan]::FromMilliseconds(16)
        $state=[pscustomobject]@{Viewer=$viewer;Target=$viewer.VerticalOffset;Timer=$timer}
        $tick={
            $difference=$state.Target-$state.Viewer.VerticalOffset
            if([Math]::Abs($difference) -lt 0.35){$state.Viewer.ScrollToVerticalOffset($state.Target);$state.Timer.Stop();return}
            $state.Viewer.ScrollToVerticalOffset($state.Viewer.VerticalOffset+($difference*0.24))
        }.GetNewClosure();$timer.Add_Tick($tick);$script:scrollStates[$key]=$state
    }
    $state=$script:scrollStates[$key];$delta=if([Math]::Abs($event.Delta) -lt 120){$event.Delta*1.1}else{$event.Delta*0.9}
    $state.Target=[Math]::Max(0,[Math]::Min($viewer.ScrollableHeight,$state.Target-$delta));if(-not $state.Timer.IsEnabled){$state.Timer.Start()};$event.Handled=$true
}

function Get-TreeItemFromSource($source) {
    return Find-VisualAncestor $source ([Windows.Controls.TreeViewItem])
}

function Get-NodeContainer($collection,$generator,$target) {
    foreach($item in @($collection)) {
        $container=$generator.ContainerFromItem($item)
        if($item -eq $target){return $container}
        if($item.IsFolder -and $container){$found=Get-NodeContainer $item.Children $container.ItemContainerGenerator $target;if($found){return $found}}
    }
    return $null
}

function Get-VisibleNodes($collection=$nodes,$generator=$FileList.ItemContainerGenerator) {
    foreach($item in @($collection)) {
        $item
        if($item.IsFolder) {
            $container=$generator.ContainerFromItem($item)
            if($container -and $container.IsExpanded){Get-VisibleNodes $item.Children $container.ItemContainerGenerator}
        }
    }
}

function Refresh-FileSelection {
    foreach($item in @(Get-VisibleNodes)) {
        $container=Get-NodeContainer $nodes $FileList.ItemContainerGenerator $item
        if(-not $container){continue}
        $queue=New-Object Collections.Queue;$queue.Enqueue($container);$surface=$null
        while($queue.Count -and -not $surface) {
            $current=$queue.Dequeue()
            if($current -is [Windows.FrameworkElement] -and $current.Name -eq 'RowSurface'){$surface=$current;break}
            $childCount=0;try{$childCount=[Windows.Media.VisualTreeHelper]::GetChildrenCount($current)}catch{}
            for($index=0;$index -lt $childCount;$index++){$queue.Enqueue([Windows.Media.VisualTreeHelper]::GetChild($current,$index))}
        }
        if($surface) {
            if($item.IsMarked){$surface.Background=[Windows.Media.Brushes]::Gainsboro;$surface.BorderBrush=[Windows.Media.SolidColorBrush]::new([Windows.Media.Color]::FromRgb(169,169,162));$surface.BorderThickness=[Windows.Thickness]::new(1)}
            else{$surface.ClearValue([Windows.Controls.Border]::BackgroundProperty);$surface.ClearValue([Windows.Controls.Border]::BorderBrushProperty);$surface.ClearValue([Windows.Controls.Border]::BorderThicknessProperty)}
        }
    }
}

function Clear-MarkedItems {
    foreach($item in @($script:selectedItems)){$item.IsMarked=$false}
    $script:selectedItems=@()
}

function Mark-Item($item,[bool]$marked) {
    $item.IsMarked=$marked
    if($marked){if(-not($script:selectedItems -contains $item)){$script:selectedItems+=,$item}}else{$script:selectedItems=@($script:selectedItems|Where-Object{$_ -ne $item})}
}

function Select-ListItem($item,[Windows.Input.ModifierKeys]$modifiers) {
    if(($modifiers -band [Windows.Input.ModifierKeys]::Shift) -and $script:selectionAnchor) {
        $visible=@(Get-VisibleNodes);$start=[Array]::IndexOf($visible,$script:selectionAnchor);$end=[Array]::IndexOf($visible,$item)
        if($start -ge 0 -and $end -ge 0) {
            if(-not($modifiers -band [Windows.Input.ModifierKeys]::Control)){Clear-MarkedItems}
            $from=[Math]::Min($start,$end);$to=[Math]::Max($start,$end)
            for($index=$from;$index -le $to;$index++){Mark-Item $visible[$index] $true}
        }
    } elseif($modifiers -band [Windows.Input.ModifierKeys]::Control) {
        Mark-Item $item (-not $item.IsMarked);$script:selectionAnchor=$item
    } else {
        Clear-MarkedItems;Mark-Item $item $true;$script:selectionAnchor=$item
    }
    Refresh-FileSelection
}

function Clear-TreeSelection {
    $selected=$FileList.SelectedItem
    if(-not $selected){return}
    function Find-TreeContainer($items,$generator,$target) {
        foreach($item in @($items)) {
            $container=$generator.ContainerFromItem($item)
            if($item -eq $target){return $container}
            if($item.IsFolder -and $container){$found=Find-TreeContainer $item.Children $container.ItemContainerGenerator $target;if($found){return $found}}
        }
        return $null
    }
    $selectedContainer=Find-TreeContainer $nodes $FileList.ItemContainerGenerator $selected
    if($selectedContainer){$selectedContainer.IsSelected=$false}
}

function Show-FilePicker($targetFolder=$null) {
    $dialog=New-Object Microsoft.Win32.OpenFileDialog
    $dialog.Multiselect=$true
    $dialog.Filter="$(T 'mediaFilter')|*.jpg;*.jpeg;*.png;*.webp;*.bmp;*.gif;*.tif;*.tiff;*.avif;*.mp4;*.mov;*.mkv;*.avi;*.webm;*.wmv;*.m4v;*.mp3;*.wav;*.flac;*.m4a;*.aac;*.ogg;*.opus;*.wma|$(T 'allFiles')|*.*"
    if($dialog.ShowDialog()) { Add-Files $dialog.FileNames $targetFolder | Out-Null }
}

function Show-RenameDialog($item) {
    $p=$script:themes[$script:theme];$title=Xml-Escape (T 'renameTitle');$cancel=Xml-Escape (T 'cancel');$save=Xml-Escape (T 'save')
    [xml]$dialogXaml=@"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Width="440" Height="245" WindowStartupLocation="CenterOwner" ResizeMode="NoResize" WindowStyle="None" AllowsTransparency="True" Background="Transparent" FontFamily="Segoe UI Variable Text,Segoe UI" Foreground="$($p.Text)"><Border Background="$($p.Surface)" CornerRadius="18" BorderBrush="$($p.Border)" BorderThickness="1" Padding="25"><Grid><Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="18"/><RowDefinition Height="46"/><RowDefinition Height="20"/><RowDefinition Height="Auto"/></Grid.RowDefinitions><TextBlock Text="$title" FontSize="21" FontWeight="SemiBold"/><TextBox x:Name="NameBox" Grid.Row="2" Background="$($p.Card)" Foreground="$($p.Text)" BorderBrush="$($p.Border)" BorderThickness="1" Padding="12,10" FontSize="14"/><StackPanel Grid.Row="4" Orientation="Horizontal" HorizontalAlignment="Right"><Button x:Name="Cancel" Content="$cancel" Background="$($p.Soft)" Foreground="$($p.Text)" BorderThickness="0" Padding="16,10"/><Button x:Name="Save" Content="$save" Background="$($p.Primary)" Foreground="$($p.OnPrimary)" BorderThickness="0" Padding="19,10" Margin="8,0,0,0"/></StackPanel></Grid></Border></Window>
"@
    $dialog=[Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $dialogXaml));$dialog.Owner=$window
    $box=$dialog.FindName('NameBox');$box.Text=if($item.IsFolder){$item.Name}else{[IO.Path]::GetFileNameWithoutExtension($item.Name)}
    $dialog.FindName('Cancel').Add_Click({$dialog.DialogResult=$false})
    $dialog.FindName('Save').Add_Click({if($box.Text.Trim()){$dialog.Tag=$box.Text.Trim();$dialog.DialogResult=$true}})
    $box.Add_KeyDown({param($sender,$event)if($event.Key -eq [Windows.Input.Key]::Enter -and $box.Text.Trim()){$dialog.Tag=$box.Text.Trim();$dialog.DialogResult=$true;$event.Handled=$true}})
    $dialog.Add_ContentRendered({$box.Focus();$box.SelectAll()})
    if($dialog.ShowDialog()) {
        $newName=if($item.IsFolder){[string]$dialog.Tag}else{[string]$dialog.Tag+[IO.Path]::GetExtension($item.Name)}
        if($newName -eq $item.Name){return $false}
        $before=Get-StateSnapshot;$item.Name=$newName
        Update-UI
        Commit-History $before
        return $true
    }
    return $false
}

function Show-OutputRenameDialog($row) {
    $p=$script:themes[$script:theme];$title=Xml-Escape (T 'outputName');$cancel=Xml-Escape (T 'cancel');$save=Xml-Escape (T 'save')
    [xml]$dialogXaml=@"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Width="440" Height="245" WindowStartupLocation="CenterOwner" ResizeMode="NoResize" WindowStyle="None" AllowsTransparency="True" Background="Transparent" FontFamily="Segoe UI Variable Text,Segoe UI" Foreground="$($p.Text)"><Border Background="$($p.Surface)" CornerRadius="18" BorderBrush="$($p.Border)" BorderThickness="1" Padding="25"><Grid><Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="18"/><RowDefinition Height="46"/><RowDefinition Height="20"/><RowDefinition Height="Auto"/></Grid.RowDefinitions><TextBlock Text="$title" FontSize="21" FontWeight="SemiBold"/><TextBox x:Name="NameBox" Grid.Row="2" Background="$($p.Card)" Foreground="$($p.Text)" BorderBrush="$($p.Border)" BorderThickness="1" Padding="12,10" FontSize="14"/><StackPanel Grid.Row="4" Orientation="Horizontal" HorizontalAlignment="Right"><Button x:Name="Cancel" Content="$cancel" Background="$($p.Soft)" Foreground="$($p.Text)" BorderThickness="0" Padding="16,10"/><Button x:Name="Save" Content="$save" Background="$($p.Primary)" Foreground="$($p.OnPrimary)" BorderThickness="0" Padding="19,10" Margin="8,0,0,0"/></StackPanel></Grid></Border></Window>
"@
    $dialog=[Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $dialogXaml));$dialog.Owner=$window
    $box=$dialog.FindName('NameBox');$box.Text=$row.OutputBase
    $submit={if($box.Text.Trim()){$dialog.Tag=$box.Text.Trim();$dialog.DialogResult=$true}}
    $dialog.FindName('Cancel').Add_Click({$dialog.DialogResult=$false});$dialog.FindName('Save').Add_Click($submit)
    $box.Add_KeyDown({param($sender,$event)if($event.Key -eq [Windows.Input.Key]::Enter){&$submit;$event.Handled=$true}})
    $dialog.Add_ContentRendered({$box.Focus();$box.SelectAll()})
    if($dialog.ShowDialog()) {
        if([string]$dialog.Tag -eq $row.OutputBase){return $false}
        $before=Get-StateSnapshot
        $row.OutputBase=[string]$dialog.Tag;$script:outputNames[$row.Source.Path]=$row.OutputBase
        $row.OutputDisplayName=Get-ShortName ($row.OutputBase+'.'+$row.Format.ToLowerInvariant());$ConversionList.Items.Refresh();Commit-History $before;return $true
    }
    return $false
}

function Show-CreateFolderDialog {
    $p=$script:themes[$script:theme];$title=Xml-Escape (T 'createFolder');$hint=Xml-Escape (T 'createHint');$add=Xml-Escape (T 'addOptional');$none=Xml-Escape (T 'noneSelected');$cancel=Xml-Escape (T 'cancel');$create=Xml-Escape (T 'create')
    [xml]$dialogXaml=@"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation" xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml" Width="560" Height="350" WindowStartupLocation="CenterOwner" ResizeMode="NoResize" WindowStyle="None" AllowsTransparency="True" Background="Transparent" FontFamily="Segoe UI Variable Text,Segoe UI" Foreground="$($p.Text)"><Border Background="$($p.Surface)" CornerRadius="20" BorderBrush="$($p.Border)" BorderThickness="1" Padding="27"><Grid><Grid.RowDefinitions><RowDefinition Height="Auto"/><RowDefinition Height="8"/><RowDefinition Height="Auto"/><RowDefinition Height="18"/><RowDefinition Height="46"/><RowDefinition Height="16"/><RowDefinition Height="Auto"/><RowDefinition Height="*"/><RowDefinition Height="Auto"/></Grid.RowDefinitions><TextBlock Text="$title" FontSize="22" FontWeight="SemiBold"/><TextBlock Grid.Row="2" Text="$hint" Foreground="$($p.Muted)"/><TextBox x:Name="NameBox" Grid.Row="4" Background="$($p.Card)" Foreground="$($p.Text)" BorderBrush="$($p.Border)" BorderThickness="1" Padding="12,10" FontSize="14"/><Grid Grid.Row="6"><Button x:Name="AddFiles" Content="$add" Background="$($p.Soft)" Foreground="$($p.Text)" BorderThickness="0" Padding="14,9" HorizontalAlignment="Left"/><TextBlock x:Name="FileSummary" Text="$none" Foreground="$($p.Muted)" HorizontalAlignment="Right" VerticalAlignment="Center"/></Grid><StackPanel Grid.Row="8" Orientation="Horizontal" HorizontalAlignment="Right"><Button x:Name="Cancel" Content="$cancel" Background="Transparent" Foreground="$($p.Muted)" BorderThickness="0" Padding="16,10"/><Button x:Name="Create" Content="$create" Background="$($p.Primary)" Foreground="$($p.OnPrimary)" BorderThickness="0" Padding="21,10" Margin="8,0,0,0"/></StackPanel></Grid></Border></Window>
"@
    $dialog=[Windows.Markup.XamlReader]::Load((New-Object System.Xml.XmlNodeReader $dialogXaml));$dialog.Owner=$window
    $box=$dialog.FindName('NameBox');$summary=$dialog.FindName('FileSummary');$dialog.Tag=@()
    $dialog.FindName('AddFiles').Add_Click({
        $picker=New-Object Microsoft.Win32.OpenFileDialog;$picker.Multiselect=$true
        $picker.Filter="$(T 'mediaFilter')|*.jpg;*.jpeg;*.png;*.webp;*.bmp;*.gif;*.tif;*.tiff;*.avif;*.mp4;*.mov;*.mkv;*.avi;*.webm;*.wmv;*.m4v;*.mp3;*.wav;*.flac;*.m4a;*.aac;*.ogg;*.opus;*.wma|$(T 'allFiles')|*.*"
        if($picker.ShowDialog()){$dialog.Tag=$picker.FileNames;$summary.Text=TF 'selected' @($picker.FileNames.Count)}
    })
    $dialog.FindName('Cancel').Add_Click({$dialog.DialogResult=$false})
    $dialog.FindName('Create').Add_Click({if($box.Text.Trim()){$dialog.Resources['FolderName']=$box.Text.Trim();$dialog.DialogResult=$true}})
    $box.Add_KeyDown({param($sender,$event)if($event.Key -eq [Windows.Input.Key]::Enter -and $box.Text.Trim()){$dialog.Resources['FolderName']=$box.Text.Trim();$dialog.DialogResult=$true;$event.Handled=$true}})
    $dialog.Add_ContentRendered({$box.Focus()})
    if(-not $dialog.ShowDialog()){return}
    $before=Get-StateSnapshot
    $folder=New-FolderNode ([string]$dialog.Resources['FolderName'])
    $selected=$FileList.SelectedItem
    if($selected -and $selected.IsFolder){$selected.Children.Add($folder)}else{$nodes.Add($folder)}
    if(@($dialog.Tag).Count){Add-Files @($dialog.Tag) $folder $false | Out-Null}else{Update-UI}
    Animate-NewNodes @($folder)
    Commit-History $before
    $StatusText.Text=TF 'created' @($folder.Name)
}

function Safe-Base([string]$name) {
    $result=[IO.Path]::GetFileNameWithoutExtension($name)
    foreach($char in [IO.Path]::GetInvalidFileNameChars()){$result=$result.Replace([string]$char,'_')}
    if($result.Trim()){return $result.Trim()}
    return 'media'
}

function Unique-Path($folder,$base,$extension) {
    $path=Join-Path $folder "$base.$extension";$index=2
    while(Test-Path -LiteralPath $path){$path=Join-Path $folder "$base ($index).$extension";$index++}
    return $path
}

function Safe-FolderName([string]$name) {
    $result=$name
    foreach($char in [IO.Path]::GetInvalidFileNameChars()){$result=$result.Replace([string]$char,'_')}
    if($result.Trim()){return $result.Trim()}
    return T 'defaultFolder'
}

function Unique-FolderPath($parent,[string]$name) {
    $path=Join-Path $parent $name;$index=2
    while(Test-Path -LiteralPath $path){$path=Join-Path $parent "$name ($index)";$index++}
    return $path
}

function Add-ConversionJobs($collection,[string]$destination,[Collections.Generic.List[object]]$jobs) {
    foreach($node in @($collection)) {
        if($node.IsFolder) {
            $folderPath=Unique-FolderPath $destination (Safe-FolderName $node.Name)
            [void](New-Item -ItemType Directory -Path $folderPath -Force)
            Add-ConversionJobs $node.Children $folderPath $jobs
        } else {
            $format=$script:formatChoices[$node.Path]
            if(-not $format){$format=(Get-FormatOptions $node.Category)[0]}
            $spec=Get-Spec $format $node.Category
            $outputBase=if($script:outputNames.ContainsKey($node.Path)){$script:outputNames[$node.Path]}else{Safe-Base $node.Name}
            $jobs.Add([pscustomobject]@{i=$node.Path;o=(Unique-Path $destination (Safe-Base $outputBase) $spec.e);a=$spec.a;n=$node.Name})
        }
    }
}

function Get-Spec($format,$category) {
    if($category -eq 'audio') {
        switch($format){'WAV'{return @{e='wav';a='-vn -c:a pcm_s16le'}}'FLAC'{return @{e='flac';a='-vn -c:a flac'}}'M4A'{return @{e='m4a';a='-vn -c:a aac -b:a 192k'}}'OGG'{return @{e='ogg';a='-vn -c:a libopus -b:a 192k'}}'AAC'{return @{e='aac';a='-vn -c:a aac -b:a 192k'}}'OPUS'{return @{e='opus';a='-vn -c:a libopus -b:a 192k'}}'WMA'{return @{e='wma';a='-vn -c:a wmav2 -b:a 192k'}}default{return @{e='mp3';a='-vn -c:a libmp3lame -b:a 192k'}}}
    }
    if($category -eq 'image') {
        switch($format){'JPEG'{return @{e='jpeg';a='-frames:v 1 -q:v 5'}}'PNG'{return @{e='png';a='-frames:v 1 -compression_level 7'}}'WEBP'{return @{e='webp';a='-frames:v 1 -c:v libwebp -quality 82'}}'AVIF'{return @{e='avif';a='-frames:v 1 -c:v libaom-av1 -crf 23 -still-picture 1'}}'BMP'{return @{e='bmp';a='-frames:v 1'}}'TIFF'{return @{e='tiff';a='-frames:v 1 -c:v tiff'}}'GIF'{return @{e='gif';a='-frames:v 1'}}default{return @{e='jpg';a='-frames:v 1 -q:v 5'}}}
    }
    switch($format){'MOV'{return @{e='mov';a='-c:v libx264 -crf 23 -c:a aac'}}'MKV'{return @{e='mkv';a='-c:v libx264 -crf 23 -c:a aac'}}'WEBM'{return @{e='webm';a='-c:v libvpx-vp9 -crf 23 -b:v 0 -c:a libopus'}}'AVI'{return @{e='avi';a='-c:v mpeg4 -q:v 5 -c:a libmp3lame -b:a 192k'}}'WMV'{return @{e='wmv';a='-c:v wmv2 -q:v 5 -c:a wmav2 -b:a 192k'}}default{return @{e='mp4';a='-c:v libx264 -crf 23 -preset medium -c:a aac -b:a 192k -movflags +faststart'}}}
}

function Start-FFmpegProcess($inputPath,$outputPath,$arguments) {
    $start=New-Object Diagnostics.ProcessStartInfo;$start.FileName='ffmpeg.exe'
    $start.Arguments="-hide_banner -loglevel error -y -i `"$inputPath`" $arguments `"$outputPath`""
    $start.UseShellExecute=$false;$start.CreateNoWindow=$true;$start.RedirectStandardError=$true
    $process=New-Object Diagnostics.Process;$process.StartInfo=$start;[void]$process.Start();return $process
}

$EmptyAddButton.Add_Click({Show-FilePicker})
$AddMoreButton.Add_Click({Show-FilePicker})
$FolderButton.Add_Click({Show-CreateFolderDialog})
$RenameButton.Add_Click({
    $target=if($script:selectedItems.Count -eq 1){$script:selectedItems[0]}else{$FileList.SelectedItem}
    if($target){Show-RenameDialog $target | Out-Null}
})

function Remove-SelectedListItems {
    $targets=if($script:selectedItems.Count){@($script:selectedItems)}elseif($FileList.SelectedItem){@($FileList.SelectedItem)}else{@()}
    if(-not $targets.Count){return}
    $before=Get-StateSnapshot
    foreach($target in $targets){Remove-LogicalFiles $target;[void](Remove-VisualNode $nodes $target)}
    Clear-MarkedItems;$script:selectionAnchor=$null;Update-UI
    Commit-History $before
    $StatusText.Text=TF 'excluded' @($targets.Count)
}

$FileList.AddHandler([Windows.Controls.Button]::ClickEvent,[Windows.RoutedEventHandler]{param($sender,$event)
    $button=Find-VisualAncestor $event.OriginalSource ([Windows.Controls.Button])
    if(-not $button -or @('RowDeleteButton','FolderAddButton') -notcontains $button.Name){return}
    $container=Get-TreeItemFromSource $button
    if(-not $container -or -not $container.Header){return}
    if($button.Name -eq 'FolderAddButton'){$container.IsExpanded=$true;Show-FilePicker $container.Header;$event.Handled=$true;return}
    $before=Get-StateSnapshot;$target=$container.Header;Remove-LogicalFiles $target;[void](Remove-VisualNode $nodes $target)
    Clear-MarkedItems;$script:selectionAnchor=$null;Update-UI;Commit-History $before;$StatusText.Text=TF 'excluded' @(1);$event.Handled=$true
})
$GalleryItems.AddHandler([Windows.Controls.Button]::ClickEvent,[Windows.RoutedEventHandler]{param($sender,$event)
    $button=Find-VisualAncestor $event.OriginalSource ([Windows.Controls.Button]);if(-not $button -or $button.Name -ne 'GalleryDeleteButton' -or -not $button.DataContext){return}
    $before=Get-StateSnapshot;$target=$button.DataContext;Remove-LogicalFiles $target;[void](Remove-VisualNode $nodes $target);Update-UI;Commit-History $before;$StatusText.Text=TF 'excluded' @(1);$event.Handled=$true
})
$GalleryItems.Add_PreviewMouseLeftButtonDown({param($sender,$event)
    $pressedButton=Find-VisualAncestor $event.OriginalSource ([Windows.Controls.Button]);if($pressedButton){return}
    $current=$event.OriginalSource;$item=$null
    while($current){if($current -is [Windows.FrameworkElement] -and $current.DataContext -and $current.DataContext.PSObject.Properties['Path']){$item=$current.DataContext;break};try{$current=[Windows.Media.VisualTreeHelper]::GetParent($current)}catch{break}}
    if(-not $item){return};$now=[datetime]::UtcNow;$elapsed=($now-$script:lastListClickAt).TotalMilliseconds
    if($script:lastListClickItem -eq $item -and $elapsed -ge 100 -and $elapsed -le 300){$script:lastListClickItem=$null;$script:lastListClickAt=[datetime]::MinValue;$event.Handled=$true;Show-RenameDialog $item|Out-Null}else{$script:lastListClickItem=$item;$script:lastListClickAt=$now}
})
$UndoButton.Add_Click({Undo-History})
$RedoButton.Add_Click({Redo-History})
$FileList.Add_PreviewKeyDown({param($sender,$event)
    if($event.Key -eq [Windows.Input.Key]::Delete -or $event.Key -eq [Windows.Input.Key]::Back){Remove-SelectedListItems;$event.Handled=$true;return}
    if($event.Key -eq [Windows.Input.Key]::A -and ([Windows.Input.Keyboard]::Modifiers -band [Windows.Input.ModifierKeys]::Control)){
        Clear-MarkedItems;foreach($item in @(Get-VisibleNodes)){Mark-Item $item $true};Refresh-FileSelection;$event.Handled=$true
    }
})
$window.Add_PreviewKeyDown({param($sender,$event)
    if($event.Key -eq [Windows.Input.Key]::Z -and ([Windows.Input.Keyboard]::Modifiers -band [Windows.Input.ModifierKeys]::Control)){Undo-History;$event.Handled=$true;return}
    if($event.Key -eq [Windows.Input.Key]::X -and ([Windows.Input.Keyboard]::Modifiers -band [Windows.Input.ModifierKeys]::Control)){
        if([Windows.Input.Keyboard]::FocusedElement -is [Windows.Controls.TextBox]){return}
        Remove-SelectedListItems;$event.Handled=$true;return
    }
    if($event.Key -eq [Windows.Input.Key]::Y -and ([Windows.Input.Keyboard]::Modifiers -band [Windows.Input.ModifierKeys]::Control)){Redo-History;$event.Handled=$true}
})

$FileList.AddHandler([Windows.Controls.TreeViewItem]::ExpandedEvent,[Windows.RoutedEventHandler]{param($sender,$event)
    $container=$event.OriginalSource
    if($container -is [Windows.Controls.TreeViewItem] -and $container.Header -and $container.Header.IsFolder) {
        $container.ItemsSource=$container.Header.Children
    }
})

$ListSurface.Add_PreviewMouseLeftButtonDown({param($sender,$event)
    $pressedButton=Find-VisualAncestor $event.OriginalSource ([Windows.Controls.Button])
    if($pressedButton -and $pressedButton.Name -eq 'FolderAddButton'){$folderContainer=Get-TreeItemFromSource $pressedButton;if($folderContainer -and $folderContainer.Header){$folderContainer.ItemsSource=$folderContainer.Header.Children;$folderContainer.IsExpanded=$true;$event.Handled=$true;Show-FilePicker $folderContainer.Header};return}
    if($pressedButton -and $pressedButton.Name -eq 'RowDeleteButton'){return}
    $container=Get-TreeItemFromSource $event.OriginalSource
    if(-not $container){Clear-TreeSelection;Clear-MarkedItems;Refresh-FileSelection;$script:selectionAnchor=$null;$script:dragItem=$null;if($event.ClickCount -eq 2){Show-FilePicker};return}
    $item=$container.Header;$script:dragStart=$event.GetPosition($FileList);$script:dragItem=$item
    $now=[datetime]::UtcNow;$elapsed=($now-$script:lastListClickAt).TotalMilliseconds
    if($script:lastListClickItem -eq $item -and $elapsed -ge 100 -and $elapsed -le 300){$script:lastListClickItem=$null;$script:lastListClickAt=[datetime]::MinValue;$event.Handled=$true;Show-RenameDialog $item | Out-Null;return}
    $script:lastListClickItem=$item;$script:lastListClickAt=$now
    $modifiers=[Windows.Input.Keyboard]::Modifiers;Select-ListItem $item $modifiers
    $container.IsSelected=$true;[void]$container.Focus()
    $toggle=Find-VisualAncestor $event.OriginalSource ([Windows.Controls.Primitives.ToggleButton])
    if($item.IsFolder -and -not $toggle -and $modifiers -eq [Windows.Input.ModifierKeys]::None){$container.ItemsSource=$item.Children;$container.IsExpanded=-not $container.IsExpanded;$event.Handled=$true}
})

$ListSurface.Add_PreviewMouseMove({param($sender,$event)
    if($event.LeftButton -ne [Windows.Input.MouseButtonState]::Pressed -or -not $script:dragItem -or -not $script:dragStart){return}
    $position=$event.GetPosition($FileList)
    if([Math]::Abs($position.X-$script:dragStart.X) -lt 6 -and [Math]::Abs($position.Y-$script:dragStart.Y) -lt 6){return}
    $data=New-Object Windows.DataObject;$data.SetData('MediaForgeNode',$script:dragItem)
    [void][Windows.DragDrop]::DoDragDrop($FileList,$data,[Windows.DragDropEffects]::Move)
    $script:dragItem=$null;$script:dragStart=$null
})

$ListSurface.Add_DragOver({param($sender,$event)
    if($event.Data.GetDataPresent('MediaForgeNode')){$event.Effects='Move'}
    elseif($event.Data.GetDataPresent([Windows.DataFormats]::FileDrop)){$event.Effects='Copy'}
    else{$event.Effects='None'}
    $event.Handled=$true
})

$ListSurface.Add_Drop({param($sender,$event)
    $targetContainer=Get-TreeItemFromSource $event.OriginalSource
    $target=if($targetContainer -and $targetContainer.Header.IsFolder){$targetContainer.Header}else{$null}
    if($event.Data.GetDataPresent('MediaForgeNode')) {
        $moving=$event.Data.GetData('MediaForgeNode')
        if($moving -eq $target -or ($moving.IsFolder -and $target -and (Contains-Node $moving $target))){return}
        $destination=$nodes
        if($target){$destination=$target.Children}
        if(-not $destination.Contains($moving)){
            $before=Get-StateSnapshot
            [void](Remove-VisualNode $nodes $moving)
            $destination.Add($moving)
            if($target){$targetContainer.IsExpanded=$true}
            Update-UI
            Commit-History $before
        }
    } elseif($event.Data.GetDataPresent([Windows.DataFormats]::FileDrop)) {
        Add-Files $event.Data.GetData([Windows.DataFormats]::FileDrop) $target | Out-Null
        if($target){$targetContainer.IsExpanded=$true}
    }
    $event.Handled=$true
})

$window.Add_DragOver({param($sender,$event)if($event.Data.GetDataPresent([Windows.DataFormats]::FileDrop)){$event.Effects='Copy';$event.Handled=$true}})
$window.Add_Drop({param($sender,$event)if($event.Data.GetDataPresent([Windows.DataFormats]::FileDrop)){Add-Files $event.Data.GetData([Windows.DataFormats]::FileDrop) $null | Out-Null;$event.Handled=$true}})
$FileList.Add_PreviewMouseWheel({param($sender,$event)Scroll-WithGesture (Find-VisualDescendant $FileList ([Windows.Controls.ScrollViewer])) $event})
$GalleryView.Add_PreviewMouseWheel({param($sender,$event)Scroll-WithGesture $GalleryView $event})
$ConversionScrollViewer.Add_PreviewMouseWheel({param($sender,$event)Scroll-WithGesture $ConversionScrollViewer $event})

function Initialize-FormatPickers {
    if(-not $ConversionList.IsLoaded){return}
    $queue=New-Object Collections.Queue;$queue.Enqueue($ConversionList)
    while($queue.Count) {
        $current=$queue.Dequeue()
        if($current -is [Windows.Controls.ComboBox] -and @('FormatPicker','FolderImagePicker','FolderVideoPicker','FolderAudioPicker') -contains $current.Name -and $current.Tag -ne 'MediaForgeReady') {
            $row=$current.DataContext
            if($row) {
                $script:loadingFormatPicker=$true
                try {
                    $options=$row.Options;$selected=$row.Format
                    if($current.Name -eq 'FolderImagePicker'){$options=$row.ImageOptions;$selected=$row.ImageFormat}
                    elseif($current.Name -eq 'FolderVideoPicker'){$options=$row.VideoOptions;$selected=$row.VideoFormat}
                    elseif($current.Name -eq 'FolderAudioPicker'){$options=$row.AudioOptions;$selected=$row.AudioFormat}
                    $current.Items.Clear()
                    foreach($option in @($options)){[void]$current.Items.Add([string]$option)}
                    if(-not $current.Items.Count){[void]$current.Items.Add((T 'individual'));$current.IsEnabled=$false}else{$current.IsEnabled=$true}
                    $current.SelectedItem=[string]$selected;$current.Tag='MediaForgeReady'
                } finally {$script:loadingFormatPicker=$false}
            }
        }
        $childCount=0
        try{$childCount=[Windows.Media.VisualTreeHelper]::GetChildrenCount($current)}catch{}
        for($index=0;$index -lt $childCount;$index++){$queue.Enqueue([Windows.Media.VisualTreeHelper]::GetChild($current,$index))}
    }
}

$ConversionList.Add_LayoutUpdated({Initialize-FormatPickers})
$ConversionList.AddHandler([Windows.Controls.TreeViewItem]::ExpandedEvent,[Windows.RoutedEventHandler]{param($sender,$event)
    $container=$event.OriginalSource
    if($container -is [Windows.Controls.TreeViewItem] -and $container.Header -and $container.Header.IsFolder){$container.ItemsSource=$container.Header.Children}
})

$ConversionList.Add_PreviewMouseLeftButtonDown({param($sender,$event)
    if(Find-VisualAncestor $event.OriginalSource ([Windows.Controls.ComboBox])){return}
    $outputCard=Find-NamedVisualAncestor $event.OriginalSource 'OutputCard'
    if(-not $outputCard){return}
    $container=Find-VisualAncestor $outputCard ([Windows.Controls.TreeViewItem])
    if($container -and $container.Header -and -not $container.Header.IsFolder){$row=$container.Header;$now=[datetime]::UtcNow;$elapsed=($now-$script:lastOutputClickAt).TotalMilliseconds;if($script:lastOutputClickItem -eq $row -and $elapsed -ge 100 -and $elapsed -le 300){$script:lastOutputClickItem=$null;$script:lastOutputClickAt=[datetime]::MinValue;$event.Handled=$true;Show-OutputRenameDialog $row | Out-Null}else{$script:lastOutputClickItem=$row;$script:lastOutputClickAt=$now}}
})

$ConversionList.AddHandler([Windows.Controls.Primitives.Selector]::SelectionChangedEvent,[Windows.Controls.SelectionChangedEventHandler]{param($sender,$event)
    if($script:buildingConversionRows -or $script:loadingFormatPicker){return}
    $picker=if($event.OriginalSource -is [Windows.Controls.ComboBox]){$event.OriginalSource}else{Find-VisualAncestor $event.OriginalSource ([Windows.Controls.ComboBox])}
    if(-not $picker -or $null -eq $picker.SelectedItem){return}
    $row=$picker.DataContext
    if(-not $row -or -not $row.Source){return}
    if($row.IsFolder) {
        $category=@{FolderImagePicker='image';FolderVideoPicker='video';FolderAudioPicker='audio'}[$picker.Name];$format=[string]$picker.SelectedItem
        if(-not $category -or $format -eq '...'){return}
        if($row.Source.FolderFormats[$category] -eq $format){return};$before=Get-StateSnapshot
        $row.Source.FolderFormats[$category]=$format
        foreach($file in @(Get-DescendantFiles $row.Source)){if($file.Category -eq $category){$script:formatChoices[$file.Path]=$format}}
        Build-ConversionRows;Commit-History $before
    } else {
        if($script:formatChoices[$row.Source.Path] -eq [string]$picker.SelectedItem){return};$before=Get-StateSnapshot
        $row.Format=[string]$picker.SelectedItem
        $script:formatChoices[$row.Source.Path]=$row.Format
        $base=[IO.Path]::GetFileNameWithoutExtension($row.Source.Name)
        $row.OutputDisplayName=Get-ShortName ($base+'.'+$row.Format.ToLowerInvariant())
        Commit-History $before
    }
    $ConversionList.Items.Refresh()
})

function Apply-GlobalFormat([string]$category,$picker) {
    if($script:loadingBulkPicker -or $null -eq $picker.SelectedItem -or [string]$picker.SelectedItem -eq '...'){return}
    $format=[string]$picker.SelectedItem;$targets=@($files|Where-Object Category -eq $category);if(-not @($targets|Where-Object{$script:formatChoices[$_.Path] -ne $format}).Count){return};$before=Get-StateSnapshot
    foreach($file in $targets){$script:formatChoices[$file.Path]=$format}
    Build-ConversionRows;$ConversionList.Items.Refresh();Commit-History $before
}
$GlobalImagePicker.Add_SelectionChanged({Apply-GlobalFormat 'image' $GlobalImagePicker})
$GlobalVideoPicker.Add_SelectionChanged({Apply-GlobalFormat 'video' $GlobalVideoPicker})
$GlobalAudioPicker.Add_SelectionChanged({Apply-GlobalFormat 'audio' $GlobalAudioPicker})

$ConvertButton.Add_Click({
    if(-not(Get-Command ffmpeg.exe -ErrorAction SilentlyContinue)){[Windows.MessageBox]::Show((T 'ffmpegMissing'),'Media Forge')|Out-Null;return}
    $outputRoot=Join-Path $appRoot 'ready convertation';[void](New-Item -ItemType Directory -Path $outputRoot -Force)
    $outputFolder=Unique-FolderPath $outputRoot (Get-Date -Format 'dd.MM');[void](New-Item -ItemType Directory -Path $outputFolder -Force)
    $jobs=New-Object Collections.Generic.List[object];Add-ConversionJobs $nodes $outputFolder $jobs
    if(-not $jobs.Count){return}
    $ConvertButton.IsEnabled=$false;$ConvertButton.Content=T 'converting';$StatusText.Text=TF 'processing' @(1,$jobs.Count)
    $script:conversionState=[pscustomobject]@{Jobs=$jobs;Index=0;Process=$null;Errors=(New-Object Collections.Generic.List[string]);Folder=$outputFolder;Timer=$null}
    $timer=New-Object Windows.Threading.DispatcherTimer;$script:conversionState.Timer=$timer;$timer.Interval=[TimeSpan]::FromMilliseconds(140)
    $timer.Add_Tick({
        $state=$script:conversionState
        if($null -eq $state.Process){$job=$state.Jobs[$state.Index];$StatusText.Text=TF 'processingName' @($state.Index+1,$state.Jobs.Count,$job.n);try{$state.Process=Start-FFmpegProcess $job.i $job.o $job.a}catch{$state.Errors.Add("$($job.n): $($_.Exception.Message)");$state.Index++};return}
        if(-not $state.Process.HasExited){return}
        $errorText=$state.Process.StandardError.ReadToEnd();if($state.Process.ExitCode -ne 0){$state.Errors.Add("$($state.Jobs[$state.Index].n): $errorText")}
        $state.Process.Dispose();$state.Process=$null;$state.Index++
        if($state.Index -lt $state.Jobs.Count){return}
        $state.Timer.Stop();$ConvertButton.IsEnabled=$true;$ConvertButton.Content=T 'start'
        if($state.Errors.Count){$StatusText.Text=TF 'errors' @($state.Errors.Count);$state.Errors|Out-File -LiteralPath (Join-Path $state.Folder 'conversion-errors.log') -Encoding utf8}
        else{$StatusText.Text=TF 'done' @([IO.Path]::GetFileName($state.Folder));Start-Process explorer.exe -ArgumentList "`"$($state.Folder)`""}
    })
    $timer.Start()
})

$ThemePicker.Add_SelectionChanged({if($script:updatingPreferences -or $null -eq $ThemePicker.SelectedItem){return};$script:theme=[string]$ThemePicker.SelectedItem.Key;Apply-Theme;Save-Preferences})
$ViewPicker.Add_SelectionChanged({if($script:updatingPreferences -or $ViewPicker.SelectedIndex -lt 0){return};$script:viewMode=if($ViewPicker.SelectedIndex -eq 1){'gallery'}else{'list'};Apply-ViewMode;Save-Preferences})
$LanguagePicker.Add_SelectionChanged({
    if($script:updatingPreferences -or $LanguagePicker.SelectedIndex -lt 0){return}
    $script:language=[string]$script:languageChoices[$LanguagePicker.SelectedIndex].Key
    Apply-Language;Save-Preferences
})

Apply-Theme
Apply-Language
[void]$window.ShowDialog()
