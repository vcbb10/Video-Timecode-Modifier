@echo off
SETLOCAL EnableDelayedExpansion

:: Edit this to tell the script anything that has been postpended to the filename of the DaVinci Resolve exported files.
set postpend=_TCF

:: Edit this to tell the script anything that has been prepended to the filename of the DaVinci Resolve exported files.
set prepend=

:: This is the name of the nested directory under the source file directory that contains the DaVinci Resolve files
set ExportPath=

:: Edit this if you want to change the output directory for the video file
Set OutputDir=%~dp1

:: Shouldn't need to edit below this line.

Set SourceScriptDirectory=%~dp0

REM set inputfile="%SourceScriptDirectory%metaorig.txt"
REM set outputfile="%SourceScriptDirectory%meta.txt"

set /p tc=Enter Video Timecode:


REM call :FindReplace "timecodeoverwrite" "%tc%" %inputfile%

START "" /WAIT "%SourceScriptDirectory%bin\ffmpeg.exe" -i %1 -map_metadata 0:s:0 -metadata creation_time=%tc% -codec copy "%OutputDir%%prepend%%~n1%postpend%%~x1"

exit