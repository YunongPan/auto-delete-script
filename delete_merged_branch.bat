@echo off
setlocal enabledelayedexpansion

REM Fetch the latest data from the remote
git fetch -p

REM Delete local branches that have been merged into main
for /f "tokens=*" %%i in ('git branch --merged ^| findstr /v /c:"*" ^| findstr /v /c:"main"') do (
   git branch -d %%i
)

REM For each remote branch that's been merged into main, check its last commit date
for /f "tokens=*" %%i in ('git branch -r --merged origin/main ^| findstr /v /c:"main" ^| findstr /c:"origin/"') do (
    echo Processing branch: %%i

    REM Get the commit date for the branch
    Set "cmd=git show -s --format=%%ci refs/remotes/%%i"
    
    for /f "delims=" %%d in ('!cmd!') do set branchDate=%%d
    
    echo Last commit date for branch %%i: !branchDate!

    REM Use the Python script to check if the branchDate is more than 3 months old
    python date_compare.py "!branchDate:~0,19!"

    REM If the python script returns 1 (indicating the branch is old), delete it.
    if !errorlevel!==1 (
        echo Deleting branch: %%i
        
        REM Strip the 'origin/' prefix to get the actual branch name
        set branchName=%%i
        set branchName=!branchName:origin/=!

        REM Delete the branch both locally and remotely. Uncomment the line below to actually perform the deletion.
        git push origin --delete !branchName!
    )
)

REM Empty the Recycle Bin
echo Emptying the Recycle Bin...
powershell -command "Clear-RecycleBin -Confirm:$false"
echo Recycle Bin emptied.

timeout /t 10