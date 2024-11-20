@echo off
setlocal enabledelayedexpansion

:: Set source directory and target directory
set "sourceDir=E:\"
set "targetDir=D:\BackupMusic"

:: Check if the target directory exists, create it if it does not
if not exist "%targetDir%" (
    mkdir "%targetDir%"
    echo Target directory created: %targetDir%
)

:: Copy mp3, wav, flac files
for /r "%sourceDir%" %%f in (*.mp3 *.wav *.flac) do (
    set "fileName=%%~nxf"
    set "filePath=%%f"
    set "fileExt=%%~xf"
    set "baseName=%%~nf"
    set "targetFilePath=%targetDir%\!fileName!"

    :: Check if the target file already exists
    if exist "!targetFilePath!" (
        set "counter=1"
        :loop
        set "newFileName=!baseName!_!counter!!fileExt!"
        set "newTargetFilePath=%targetDir%\!newFileName!"
        if exist "!newTargetFilePath!" (
            set /a counter+=1
            goto loop
        )
        set "targetFilePath=!newTargetFilePath!"
    )

    echo Copying !filePath! to !targetFilePath!
    copy "!filePath!" "!targetFilePath!"
)

echo File copying completed.
pause