@echo off
setlocal enabledelayedexpansion

REM Set log file path to Desktop with the current date and time in the name
for /f "delims=" %%a in ('wmic OS Get localdatetime ^| find "."') do set datetime=%%a
set datetimeformatted=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%_%datetime:~8,2%-%datetime:~10,2%-%datetime:~12,2%
set LOGFILE=%userprofile%\Desktop\empty_recycle_bin_log_%datetimeformatted%.txt

REM Redirect all output (stdout and stderr) to the log file
if "%~1"=="_logging_" goto :logging
call "%~f0" _logging_ > "%LOGFILE%" 2>&1
exit /b

:logging

REM Check Recycle Bin
echo Checking Recycle Bin...
FOR /F %%i IN ('powershell -command "(New-Object -ComObject shell.application).Namespace(0xa).items().count"') DO SET BINCOUNT=%%i
if %BINCOUNT% gtr 0 (
    echo Emptying Recycle Bin...
    powershell -command "Clear-RecycleBin -Confirm:$false" 2>$null
    echo Recycle Bin emptied.
) else (
    echo Recycle Bin is already empty.
)

echo Script execution completed.