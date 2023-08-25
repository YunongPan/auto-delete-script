@echo off
setlocal enabledelayedexpansion

REM Initialize logging
call init_logging_time.bat

REM Check Recycle Bin
echo Checking Recycle Bin... >> "%LOGFILE%"
FOR /F %%i IN ('powershell -command "(New-Object -ComObject shell.application).Namespace(0xa).items().count"') DO SET BINCOUNT=%%i
if %BINCOUNT% gtr 0 (
    echo Emptying Recycle Bin... >> "%LOGFILE%"
    powershell -command "Clear-RecycleBin -Confirm:$false" 2>$null
    echo Recycle Bin emptied. >> "%LOGFILE%"
) else (
    echo Recycle Bin is already empty. >> "%LOGFILE%"
)

echo Script execution completed. >> "%LOGFILE%"
echo. >> "%LOGFILE%"
