@echo off

REM Fetch the latest data from the remote
git fetch -p

REM Delete local branches that have been merged into main
for /f "tokens=*" %%i in ('git branch --merged ^| findstr /v /c:"*" ^| findstr /v /c:"main"') do (
    git branch -d %%i
)

REM For each remote branch that's been merged into main, check its last commit date
for /f "tokens=*" %%i in ('git branch -r --merged origin/main ^| findstr /v /c:"main" ^| findstr /c:"origin/"') do (
    REM Get the commit date for the branch
    for /f "delims=" %%d in ('git show -s --format="%%ci" %%i') do set branchDate=%%d

    REM Use the Python script to check if the branchDate is more than 3 months old
    python date_compare.py "%branchDate%"

    REM If the python script returns 1 (indicating the branch is old), delete it.
    if %errorlevel%==1 (
        echo Deleting remote branch: %%i
        REM Delete the branch remotely. Uncomment the line below to actually perform the deletion.
        REM git push origin --delete %%i
    )
)

REM Empty the Recycle Bin
echo Emptying the Recycle Bin...
powershell -command "Clear-RecycleBin -Confirm:$false"
echo Recycle Bin emptied.