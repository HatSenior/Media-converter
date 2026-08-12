# Media Forge

A minimalistic application for converting and compressing images, videos, and audio.

## Running

Open **`Media Forge.exe`** by double-clicking it. No PowerShell window is required.

The **`Запустить.cmd`** file is kept as a fallback option: it first launches the EXE and uses the legacy PowerShell launcher only if the EXE file is not available.

## Working with Folders

* In an empty list, click the gray **`+`** button to add your first media files.
* Click **"Создать папку"** to create a folder, enter its name, and optionally select files for it immediately.
* To create a nested folder, select the parent folder first.
* Single-click a folder row to collapse or expand its contents.
* Double-click a file or folder to rename it.
* Files can be dragged into folders and back to the main list.
* Adding the same file multiple times does not create duplicates.

The **"Параметры конвертации"** button at the bottom opens the conversion settings preview. The output format can be selected individually for each file.

Original files are not modified. Converted files are saved in the **`ready convertation`** folder next to the application.

FFmpeg must be installed and available as **`ffmpeg.exe`** to process media files.

- Русский

Минималистичное приложение для конвертации и сжатия изображений, видео и аудио.

## Запуск

Откройте **`Media Forge.exe`** двойным щелчком. Окно PowerShell больше не требуется.

Файл **`Запустить.cmd`** оставлен как запасной вариант: сначала он открывает EXE, а старый PowerShell-запуск использует только в том случае, если EXE отсутствует.

## Работа с папками

- В пустом списке нажмите серый **`+`**, чтобы добавить первые медиа.
- Нажмите **«Создать папку»**, введите название и при желании сразу выберите файлы для неё.
- Чтобы создать вложенную папку, сначала выделите родительскую папку.
- Один щелчок по строке папки сворачивает или раскрывает её содержимое.
- Двойной щелчок по файлу или папке открывает изменение названия.
- Файлы можно перетаскивать внутрь папки и обратно в основной список.
- Повторное добавление одного и того же файла не создаёт дубликат.

Нижняя кнопка **«Параметры конвертации»** раскрывает предварительный просмотр. Формат можно выбрать отдельно для каждого файла. Исходные файлы не изменяются, результаты сохраняются в папку **`ready convertation`** рядом с программой.

Для обработки медиа требуется установленный FFmpeg, доступный как `ffmpeg.exe`.
