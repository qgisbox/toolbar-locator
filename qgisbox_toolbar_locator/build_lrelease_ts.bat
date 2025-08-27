@echo off
REM Get the directory where this batch script is located
set "SCRIPT_DIR=%~dp0"

REM Define the path to OSGeo4W and related tools
call find_osgeo4w.bat
if not defined OSGeo4W_PATH (
    echo OSGeo4W directory not found
    exit /b 1
)

set LRELEASE_PATH=%OSGeo4W_PATH%/apps/Qt5/bin/lrelease.exe
set PYTHONHOME=%OSGeo4W_PATH%/apps/Python312
set PATH=%PATH%;%OSGeo4W_PATH%/bin;%OSGeo4W_PATH%/apps/Qt5/bin

REM Check if lrelease.exe exists at the specified path
if not exist "%LRELEASE_PATH%" (
    echo Error: lrelease.exe not found at %LRELEASE_PATH%
    echo Please verify Qt5 is installed correctly or modify the OSGeo4W_PATH variable
    pause
    exit /b 1
)

REM Define the i18n directory path
set "I18N_DIR=%SCRIPT_DIR%i18n"

REM Check if i18n directory exists
if not exist "%I18N_DIR%" (
    echo Error: i18n directory not found at %I18N_DIR%
    echo Please create the directory and place your .ts files there
    pause
    exit /b 1
)

REM Switch to the script directory
echo Changing working directory to: %SCRIPT_DIR%
cd /d "%SCRIPT_DIR%" || (
    echo Error: Failed to switch to script directory: %SCRIPT_DIR%
    pause
    exit /b 1
)

REM Count number of .ts files found
set TS_COUNT=0

REM Process all .ts files in i18n directory
echo ==============================================
echo Starting compilation of .ts files in %I18N_DIR%
echo ==============================================

for %%f in ("%I18N_DIR%\*.ts") do (
    echo Processing: %%~nxf
    "%LRELEASE_PATH%" "%%f" -qm "%%~dpnf.qm"
    
    if %errorlevel% equ 0 (
        echo Successfully compiled: %%~nxf to %%~nf.qm
        set /a TS_COUNT+=1
    ) else (
        echo Error: Failed to compile %%~nxf, error code: %errorlevel%
        pause
        exit /b %errorlevel%
    )
    echo.
)

REM Check if any files were processed
if %TS_COUNT% equ 0 (
    echo Warning: No .ts files found in %I18N_DIR%
    pause
    exit /b 0
) else (
    echo ==============================================
    echo Successfully compiled %TS_COUNT% .ts files
    echo Output .qm files are in the same directory as source .ts files
    echo ==============================================
)

exit /b 0
    