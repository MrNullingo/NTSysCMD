@echo off
:: BatchGotAdmin
:-------------------------------------
REM  --> THIS PART IS NOT MADE BY ME
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
REM  --> THIS PART IS NOT MADE BY ME
:--------------------------------------
REM  --> Create temp directory for the files
mkdir C:\Temp\NTSysCMD
echo Created Directory
echo Starting download of files in new CMD Window
REM  --> Start download of the archive in new CMD.. starting in current CMD does not work May fix in newer versions.
REM  --> Any way to actually hide the CMD window?
start cmd.exe /c "curl -A -L "https://download.sysinternals.com/files/PSTools.zip" -o C:\Temp\NTSysCMD\PSTools.zip"
echo Waiting for download to finish
REM  --> Waiting for curl to finish - I want to make it detect when download is finished in newer versions.
timeout 5
cd C:\Temp\NTSysCMD\
REM  --> Extracts the archive
tar -xf PSTools.zip
echo Extracting archive
echo Doing the magic..
REM  --> Starts CMD under nt authority/system user
psexec -nobanner -accepteula -sid %SYSTEMROOT%\System32\cmd.exe
cls
echo Magic done! Check new CMD window.
echo Cleaning up
REM  --> Deletes files it downloaded and also deletes the folder
cd C:\Temp\
@RD /S /Q "C:\Temp\NTSysCMD"
echo You can now exit this CMD Window by pressing any key! Have a nice day.
REM  --> Debug timeout below.. will probably remove.
timeout 20
exit