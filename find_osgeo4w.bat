@echo off
:: Do not use setlocal to make variables global
set "OSGeo4W_PATH="

echo Searching for OSGeo4W directory...

:: Loop through drives
for %%d in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist "%%d:\OSGeo4W\" (
        set "OSGeo4W_PATH=%%d:/OSGeo4W"
        echo OSGeo4W directory found
        goto :endsearch  :: Exit after finding the first one
    )
)

:endsearch
echo OSGeo4W directory: %OSGeo4W_PATH%
if not defined OSGeo4W_PATH (
    echo OSGeo4W directory not found
)
    