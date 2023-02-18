@echo off

if "%~1" == "" (
    echo Usage: %0 file.txt
    exit /b 1
)

for /f "usebackq tokens=1,2,3*" %%A in (%1) do (
    echo %%A
    echo %%B
    echo %%C
)


