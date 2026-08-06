@echo off
cd /d "%~dp0"
start "Media Forge" powershell.exe -STA -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command "try{$env:MEDIAFORGE_ROOT='%~dp0';$code=[IO.File]::ReadAllText('%~dp0MediaForge2.ps1',[Text.Encoding]::UTF8);[scriptblock]::Create($code).Invoke()}catch{Add-Type -AssemblyName PresentationFramework;[Windows.MessageBox]::Show($_.Exception.Message,'Media Forge — ошибка запуска')}"
