@Echo off
SETLOCAL EnableDelayedExpansion

:: Edit this to tell the script anything that has been postpended to the filename of the exported files.  Default=_TCF
Set postpend=_TCF

:: Edit this to tell the script anything that has been prepended to the filename of the exported files.  Default=
set prepend=

:: Edit this no make a nested directory under the source file directory.  Default=TCF
set ExportPath=TCF

::========================================
:: Shouldn't need to edit below this line.
::========================================

:: Set the Source Video as Argument 1.
Set SourceVideo=%1

:: Set the Timecode as Argument 2.
Set tc=%2

:: Set the Source Script Directory so we know where to find ffmpeg.
Set SourceScriptDirectory=%~dp0

:: If argument 1 (Source video) isn't provided, ask for user input.
IF [%SourceVideo%]==[] Set /p SourceVideo=Source Video File with Path:

:: If argument 2 (Timecode) isn't provided, ask for user input.
IF [%tc%]==[] Set /p tc=Enter Video Timecode:

:: Remove "'s from the filename if needed.
Set SourceVideo=%SourceVideo:"=%
Set tc=%tc:"=%

:: Get the path information for the Source Video file.
SETLOCAL
set file=%SourceVideo%
FOR %%i IN ("%file%") DO (
Set SVfiledrive=%%~di
Set SVfilepath=%%~pi
Set SVfilename=%%~ni
Set SVfileextension=%%~xi
)

:: Set the Output Directory.
Set OutputDir=%SVfiledrive%%SVfilepath%%ExportPath%\

:: Set the Output Filename.
Set OutputFile=%OutputDir%%prepend%%SVFilename%%postpend%%SVFileextension%

::Create the Output Direcotry if needed.
If not exist "%OutputDir%" mkdir "%OutputDir%"

:: Run the Script.
START "" /WAIT "%SourceScriptDirectory%bin\ffmpeg.exe" -i "%SourceVideo%" -map_metadata 0:s:0 -metadata creation_time=%tc% -codec copy "%OutputFile%"

exit
