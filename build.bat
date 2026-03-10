@echo off
setlocal

set "SCRIPT_DIR=%~dp0"
set "BUILD_PRESET=release"
set "TEST_PRESET=release"
set "RUN_TESTS=0"

for %%A in (%*) do (
    if /I "%%~A"=="release" (
        set "BUILD_PRESET=release"
        set "TEST_PRESET=release"
    ) else if /I "%%~A"=="debug" (
        set "BUILD_PRESET=debug"
        set "TEST_PRESET=debug"
    ) else if /I "%%~A"=="--test" (
        set "RUN_TESTS=1"
    ) else (
        goto :usage
    )
)

pushd "%SCRIPT_DIR%" >nul || exit /b 1

echo Configuring with preset vs2022-x64...
cmake --preset vs2022-x64
if errorlevel 1 goto :fail

echo Building DLL with preset %BUILD_PRESET%...
cmake --build --preset %BUILD_PRESET% --target Toolscreen
if errorlevel 1 goto :fail

echo Building EXE package with preset %BUILD_PRESET%...
cmake --build --preset %BUILD_PRESET% --target installer_exe
if errorlevel 1 goto :fail

echo Building JAR package with preset %BUILD_PRESET%...
cmake --build --preset %BUILD_PRESET% --target jar
if errorlevel 1 goto :fail

if "%RUN_TESTS%"=="1" (
    echo Running tests with preset %TEST_PRESET%...
    ctest --preset %TEST_PRESET%
    if errorlevel 1 goto :fail
)

popd >nul
exit /b 0

:usage
echo Usage: build.bat [release^|debug] [--test]
popd >nul 2>nul
exit /b 1

:fail
popd >nul
exit /b 1