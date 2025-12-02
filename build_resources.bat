@echo off
REM Get the directory where this batch script is located
set "SCRIPT_DIR=%~dp0"

REM Define the path to pyrcc5.exe as a variable
call find_osgeo4w.bat
if not defined OSGeo4W_PATH (
    echo OSGeo4W directory not found
    exit /b 1
)

set RESOURCES_QRC=resources.qrc
set PYRCC_PATH=%OSGeo4W_PATH%/apps/Python312/Scripts/pyrcc5.exe
set PYTHONHOME=%OSGeo4W_PATH%/apps/Python312
set PATH=%PATH%;%OSGeo4W_PATH%/bin;%OSGeo4W_PATH%/apps/Qt5/bin

REM Check if %PYRCC_PATH% exists at the specified path
if not exist %PYRCC_PATH% (
    echo Error: %PYRCC_PATH% not found
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

REM Check if %RESOURCES_QRC% exists (required for pyrcc5 command in build.sh)
if not exist "%RESOURCES_QRC%" (
    echo Error: resources.qrc file not found in script directory
    echo This file is required for the pyrcc5 compilation step
    pause
    exit /b 1
)

REM compile resources using pyrcc5
echo compile resources using pyrcc5...
%PYRCC_PATH% %RESOURCES_QRC% -o resources.py

REM Check the execution result and display appropriate message
if %errorlevel% equ 0 (
    echo ==============================================
    echo Resources compiled with pyrcc5 completed
    echo ==============================================
) else (
    echo =======================================================
    echo pyrcc5 execution failed, error code: %errorlevel%
    echo =======================================================
    pause
    exit /b %errorlevel%
)
    