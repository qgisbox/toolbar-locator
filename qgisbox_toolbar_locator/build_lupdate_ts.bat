@echo off
REM Get the directory where this batch script is located
set "SCRIPT_DIR=%~dp0"

REM Define the path to pylupdate5.exe as a variable
set OSGeo4W_PATH=D:/OSGeo4W
set TRANSLATIONS_PRO=translations.pro

set PY_LUPDATE_PATH=%OSGeo4W_PATH%/apps/Python312/Scripts/pylupdate5.exe
set PYTHONHOME=%OSGeo4W_PATH%/apps/Python312
set PATH=%PATH%;%OSGeo4W_PATH%/bin;%OSGeo4W_PATH%/apps/Qt5/bin

REM Check if %PY_LUPDATE_PATH% exists at the specified path
if not exist %PY_LUPDATE_PATH% (
    echo Error: %PY_LUPDATE_PATH% not found
    echo Please verify pyqt is installed correctly or modify the path variable
    pause
    exit /b 1
)

REM Switch to the directory where this batch script is located
echo Changing working directory to: %SCRIPT_DIR%
cd /d "%SCRIPT_DIR%" || (
    echo Error: Failed to switch to script directory: %SCRIPT_DIR%
    pause
    exit /b 1
)

REM Check if %TRANSLATIONS_PRO% exists (required for pylupdate5 command in build.sh)
if not exist "%TRANSLATIONS_PRO%" (
    echo Error: resources.qrc file not found in script directory
    echo This file is required for the pylupdate5 compilation step
    pause
    exit /b 1
)

REM compile resources using pylupdate5
echo compile resources using pylupdate5...
%PY_LUPDATE_PATH% %TRANSLATIONS_PRO%

REM Check the execution result and display appropriate message
if %errorlevel% equ 0 (
    echo ==============================================
    echo Resources compiled with pylupdate5 completed
    echo ==============================================
) else (
    echo =======================================================
    echo pylupdate5 execution failed, error code: %errorlevel%
    echo =======================================================
    pause
    exit /b %errorlevel%
)
    