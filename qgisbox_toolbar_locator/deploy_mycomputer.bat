@echo off
REM Get the directory where this batch script is located
set "SCRIPT_DIR=%~dp0"

REM Define paths and plugin name
call find_osgeo4w.bat
if not defined OSGeo4W_PATH (
    echo OSGeo4W directory not found
    exit /b 1
)

set "PYTHONHOME=%OSGeo4W_PATH%/apps/Python312"
set "PATH=%PATH%;%OSGeo4W_PATH%/bin;%OSGeo4W_PATH%/apps/Qt5/bin"

set "PLUGINNAME=qgisbox_toolbar_locator"
set "QGIS_PLUGINS_DIR=%AppData%/QGIS/QGIS3/profiles/default/python/plugins"
set "DEST_DIR=%QGIS_PLUGINS_DIR%/%PLUGINNAME%"
set "SOURCE_I18N_DIR=%SCRIPT_DIR%i18n\"
set "DEST_I18N_DIR=%DEST_DIR%/i18n"
REM 新增：定义libs文件夹路径
set "SOURCE_LIBS_DIR=%SCRIPT_DIR%libs\"
set "DEST_LIBS_DIR=%DEST_DIR%/libs"

REM Display configuration information
echo ==============================================
echo Plugin Deployment Configuration
echo ==============================================
echo Source directory:      %SCRIPT_DIR%
echo Plugin name:           %PLUGINNAME%
echo Destination directory: %DEST_DIR%
echo ==============================================
echo.

REM Remove existing destination directory if it exists
if exist "%DEST_DIR%" (
    @REM echo Removing existing plugin directory: %DEST_DIR%
    @REM rmdir /S /Q "%DEST_DIR%"
) else (
    REM Create fresh destination directory
    echo.
    echo Creating new destination directory: %DEST_DIR%
    mkdir "%DEST_DIR%"
)

REM Create i18n subdirectory in destination if source exists
if exist "%SOURCE_I18N_DIR%" (
    echo.
    echo Creating i18n subdirectory in destination
    mkdir "%DEST_I18N_DIR%"
)

REM 新增：创建libs子目录并拷贝文件
if exist "%SOURCE_LIBS_DIR%" (
    echo.
    echo Creating libs subdirectory in destination
    mkdir "%DEST_LIBS_DIR%"
    echo Copying library files from libs directory...
    REM 递归拷贝libs下所有文件和子目录
    xcopy /E /Y "%SOURCE_LIBS_DIR%*" "%DEST_LIBS_DIR%\" >nul
    if %errorlevel% equ 0 (
        echo Successfully copied libs directory
    ) else (
        echo Warning: Failed to copy libs directory
    )
) else (
    echo.
    echo Warning: libs directory not found in source directory
)

REM Copy metadata.txt
echo.
echo Copying metadata.txt...
if exist "%SCRIPT_DIR%metadata.txt" (
    copy /Y "%SCRIPT_DIR%metadata.txt" "%DEST_DIR%" >nul
) else (
    echo Warning: metadata.txt not found in source directory
)

REM Copy icon.png
echo.
echo Copying icon.png...
if exist "%SCRIPT_DIR%icon.png" (
    copy /Y "%SCRIPT_DIR%icon.png" "%DEST_DIR%" >nul
) else (
    echo Warning: icon.png not found in source directory
)

REM Copy all .py files
echo.
echo Copying Python files (.py)...
copy /Y "%SCRIPT_DIR%*.py" "%DEST_DIR%" >nul

REM Copy all .ui files
echo.
echo Copying UI files (.ui)...
copy /Y "%SCRIPT_DIR%*.ui" "%DEST_DIR%" >nul

REM Copy .qm files from i18n directory
echo.
echo Copying translation files (%SOURCE_I18N_DIR%*.qm)...
copy /Y "%SOURCE_I18N_DIR%*.qm" "%DEST_I18N_DIR%" >nul
if %errorlevel% equ 0 (
    echo Successfully copied .qm files to i18n subdirectory
) else (
    echo Warning: Failed to copy .qm files
)

REM Verify deployment
echo.
echo ==============================================
echo Deployment verification
echo ==============================================
echo Main plugin files:
dir /B "%DEST_DIR%" *.py *.ui metadata.txt icon.png 2>nul

REM 新增：验证libs文件夹部署
if exist "%DEST_LIBS_DIR%" (
    echo.
    echo Library files in libs:
    dir /B "%DEST_LIBS_DIR%" 2>nul
)

if exist "%DEST_I18N_DIR%" (
    echo.
    echo Translation files in i18n:
    dir /B "%DEST_I18N_DIR%" *.qm 2>nul
)
echo.
echo Deployment completed. Plugin available at:
echo %DEST_DIR%
echo ==============================================

exit /b 0