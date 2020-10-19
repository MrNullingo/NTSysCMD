@echo off
:: BatchGotAdmin
:-------------------------------------
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
:--------------------------------------
REM  --> Check if directory exists, if yes don't create another, if no, create temp directory for the files. (Not working)
if not exist "C:\Temp\NTSysCMD" mkdir C:\Temp\NTSysCMD 
echo Created Directory
REM  --> Copy CMD into TEMP and rename it for later use
copy "C:\Windows\System32\cmd.exe" "C:\Temp\"
ren C:\Temp\cmd.exe NTSysCMD.exe
echo Starting download of files in new CMD Window
REM  --> Start download of the archive in new CMD.. starting in current CMD does not work. echo Directory already exists! Assuming it has all needed files... skipping download.
:FilesDontExist
start cmd.exe /c "curl -A -L "https://download.sysinternals.com/files/PSTools.zip" -o C:\Temp\NTSysCMD\PSTools.zip"
echo Waiting for download to finish
timeout 5
:FilesExist
cd C:\Temp\NTSysCMD\
tar -xf PSTools.zip
echo Extracting archive
echo Doing the magic..
psexec -nobanner -sid C:\Temp\NTSysCMD.exe /k "echo Who am I? I am nt authority\system! If something went wrong and you are not, contact me on Discord: Cube46#8163"
cls
echo Magic done! Check new CMD window.
echo Cleaning up
REM  --> Files are being deleted and script is terminated.
cd C:\Temp\
@RD /S /Q "C:\Temp\NTSysCMD"
echo You can now exit this CMD Window by pressing any key! Have a nice day.
timeout 20
exit