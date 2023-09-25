@Echo off
setlocal EnableDelayedExpansion
:: *** Usage ***
:: This script will automatically apply timestamps to multiple .MP4 video files in the same directory.
:: The video files in the directory must be named in ascending order.
::   Recommend you name the files with a prepended number sequence.  Example:
::   001_<Filename>, 002_<Filename>, 003_<Filename), etc.
::   Video files MUST be .MP4.  Other filenames are ignored.
::   ALL video files in that directory will be processed.
:: Export a "Time Conversion.csv" file in the same directory as "Batch Timecode Process.bat"
:: CSV Should be in this format:
::   FileNumber,Calcualated Time:
::   1,2023-09-22T17:11:30.000000Z
::   2,2023-09-22T17:26:26.000000Z

:: Drag and drop the first video file to process onto the "Batch Timecode Process.bat" file to begin.
:: *** Usage ***

:: Source directory of the scripts.
Set SourceScriptDirectory=%~dp0

:: The "Video Timecode Modifier.bat" file.
:: This should be in the same directory as this script and named "Video Timecode Modifier.bat"
Set SourceScript=%SourceScriptDirectory%Video Timecode Modifier.bat

:: The input CSV file.
:: This should be in the same directory as this script and named "Time Conversion.csv".
Set CSVFile=%~dp0Time Conversion.csv

:: You can change this to the line below to call "Time Conversion.csv" that is located in the_
:: video file's directory.  This lets you store the CSV file with your video files instead of in_
:: the script directory.
REM Set CSVFile=%~dp1Time Conversion.csv

:: This is used as a counter to call the next line of the CSV.
:: It starts at "2" to skip reading the CSV header.
Set LineNum=2

:: Start with a clean "TC" var.
Set TC=

 for %%f in (*.MP4) do (
			cls
			ECHO.
			ECHO *** Processing file: ***
			ECHO *** "%~dp1%%~f" ***
			
			:: Find the Timecode to use from the .CSV file by calling the "FindCSVTC" Function
			Call:FindCSVTC tc
			
			:: Print useful output in the CMD window
			ECHO %Counter%
			ECHO *** LineNum=%LineNum% ***
			ECHO *** TC=!tc! ***
			ECHO.
			Echo SourceScript=%SourceScript%
			ECHO Input File="%~dp1%%~f"
			:: Uncomment the "pause" line below to stop the process for debugging.
			REM pause

			:: Calls the external timecode "Video Timecode Modifier.bat" script to sync.
			:: Format of call: 
			:: <"Video Timecode Modifier.bat"> <"Video File to Sync"> <"Timecode to sync">
			START "" /WAIT CALL "%SourceScript%" "%~dp1%%~f" !tc!

			:: Increment the "LineNum" Var so when "FindCSVTC" function is called again,
			:: it pulls the next line of the CSV.
			Set /a LineNum+=1
		)
	)

:: This Function finds the Timecode from the .CSV file.
:FindCSVTC

::Find the CSV Var 1
for /f "tokens=1* delims=:" %%a in ('findstr /n .* "%CSVFile%"') do (
  if "%%a"=="%LineNum%" set FullLine=%%b
)

:: Sets FLine = to the first string of the CSV line.
for /f "tokens=1* delims=," %%a in ("%FullLine%") do (
  set FLine=%%a
)

:: Sets SLine = to the Second string of the CSV line.
:: This is normally the timecode that is used.
for /f "tokens=2* delims=," %%a in ("%FullLine%") do (
  set SLine=%%a
)

:: Sets TLine = to the third string of the CSV line.
for /f "tokens=3* delims=," %%a in ("%FullLine%") do (
  set TLine=%%a
)

:: Makes sure the function returns the Timecode
Set "%~1=%SLine%"

:: Exits the function
exit /b 0