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
start cmd.exe /c "curl -A -L "https://download.sysinternals.com/files/PSTools.zip" -o C:\Temp\NTSysCMD\PSTools.zip"
echo Waiting for download to finish
timeout 5
cd C:\Temp\NTSysCMD\
tar -xf PSTools.zip
echo Extracting archive
echo Doing the magic..
psexec -nobanner -accepteula -sid %SYSTEMROOT%\System32\cmd.exe
cls
echo Magic done! Check new CMD window.
echo Cleaning up
REM  --> Files are being deleted and script is terminated.
cd C:\Temp\
@RD /S /Q "C:\Temp\NTSysCMD"
echo You can now exit this CMD Window by pressing any key! Have a nice day.
timeout 20
exit