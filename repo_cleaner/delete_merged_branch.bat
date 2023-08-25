@echo off
setlocal enabledelayedexpansion

call init_logging_time.bat

REM Fetch the latest data from the remote
echo Fetching the latest data from the remote... >> "%LOGFILE%"
git fetch -p >> "%LOGFILE%" 2>>&1

REM Delete local branches that have been merged into main
echo Deleting local branches merged into main... >> "%LOGFILE%"
for /f "tokens=*" %%i in ('git branch --merged ^| findstr /v /c:"*" ^| findstr /v /c:"main"') do (
   git branch -d %%i >> "%LOGFILE%" 2>>&1
)

REM For each remote branch that's been merged into main, check its last commit date
for /f "tokens=*" %%i in ('git branch -r --merged origin/main ^| findstr /v /c:"main" ^| findstr /c:"origin/"') do (

    REM Get the commit date for the branch
    Set "cmd=git show -s --format=%%ci refs/remotes/%%i"
    
    for /f "delims=" %%d in ('!cmd!') do set branchDate=%%d
    
    echo Last commit date for branch %%i: !branchDate! >> "%LOGFILE%"

    REM Use the Python script to check if the branchDate is more than 3 months old
    python date_compare.py "!branchDate:~0,19!" >> "%LOGFILE%" 2>>&1

    REM If the python script returns 1 (indicating the branch is old), delete it.
    if !errorlevel!==1 (
        echo Deleting branch: %%i >> "%LOGFILE%"
        
        REM Strip the 'origin/' prefix to get the actual branch name
        set branchName=%%i
        set branchName=!branchName:origin/=!

        REM Delete the branch both locally and remotely. Uncomment the line below to actually perform the deletion.
        git push origin --delete !branchName! >> "%LOGFILE%" 2>>&1
    )
)

echo All merged branches older than 3 months have been deleted. >> "%LOGFILE%"
echo Script execution completed. >> "%LOGFILE%"
echo. >> "%LOGFILE%"


