@echo off
REM Get the current date and time in YYYY-MM-DD_HH-MM-SS format
for /f "delims=" %%a in ('wmic OS Get localdatetime ^| find "."') do set datetime=%%a
set datetimeformatted=%datetime:~0,4%-%datetime:~4,2%-%datetime:~6,2%_%datetime:~8,2%-%datetime:~10,2%-%datetime:~12,2%

REM Set log file path to Desktop
set LOGFILE=%userprofile%\Desktop\repo_clean_log.txt

REM Print the current date-time to the log file
echo [%datetimeformatted%] >> "%LOGFILE%"
