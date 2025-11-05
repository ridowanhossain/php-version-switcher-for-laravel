@echo off
setlocal enabledelayedexpansion

set "BASE_DIR=D:\PHP"

if not exist "%BASE_DIR%" (
    echo Base directory "%BASE_DIR%" was not found.
    pause
    exit /b 1
)

:menu
cls
call :print_menu
set "choice="
set /p "choice=Enter your choice and press Enter: "

if "%choice%"=="1" (
    call :switch_version 5.6
    call :wait_and_return
    goto :menu
)
if "%choice%"=="2" (
    call :switch_version 7.0
    call :wait_and_return
    goto :menu
)
if "%choice%"=="3" (
    call :switch_version 7.1
    call :wait_and_return
    goto :menu
)
if "%choice%"=="4" (
    call :switch_version 7.2
    call :wait_and_return
    goto :menu
)
if "%choice%"=="5" (
    call :switch_version 7.3
    call :wait_and_return
    goto :menu
)
if "%choice%"=="6" (
    call :switch_version 7.4
    call :wait_and_return
    goto :menu
)
if "%choice%"=="7" (
    call :switch_version 8.0
    call :wait_and_return
    goto :menu
)
if "%choice%"=="8" (
    call :switch_version 8.1
    call :wait_and_return
    goto :menu
)
if "%choice%"=="9" (
    call :switch_version 8.2
    call :wait_and_return
    goto :menu
)
if "%choice%"=="10" (
    call :uninstall_php
    call :wait_and_return
    goto :menu
)
if "%choice%"=="11" (
    call :show_current_version
    call :wait_and_return
    goto :menu
)
if "%choice%"=="12" goto :exit

echo Invalid selection. Please try again.
call :wait_and_return
goto :menu

:exit
echo Exiting PHP Version Switcher.
endlocal
exit /b 0

:print_menu
set "MENU_VERSION_MSG=Unknown (php not detected)"
set "CURRENT_VERSION="
set "CURRENT_FULL="
call :detect_current_version
if errorlevel 1 (
    set "MENU_VERSION_MSG=Unavailable (php\php.exe missing)"
) else (
    set "MENU_VERSION_MSG=!CURRENT_FULL!"
)

echo ==========================================
echo.
echo PHP Version Switcher
echo.
echo ==========================================
echo.
echo.
echo Current Status: Ready to switch PHP versions
echo Current PHP version: !MENU_VERSION_MSG!  [Active folder: D:\PHP\php]
echo.
echo.
echo 1. Switch to PHP 5.6           2. Switch to PHP 7.0
echo.
echo.
echo 3. Switch to PHP 7.1           4. Switch to PHP 7.2
echo.
echo.
echo 5. Switch to PHP 7.3           6. Switch to PHP 7.4
echo.
echo.
echo 7. Switch to PHP 8.0           8. Switch to PHP 8.1
echo.
echo.
echo 9. Switch to PHP 8.2           10. Uninstall PHP
echo.
echo.
echo 11. Check PHP Version          12. Exit
echo.
goto :EOF

:wait_and_return
echo.
echo 
pause
goto :EOF

:uninstall_php
set "CURRENT_VERSION="
set "CURRENT_FULL="
call :detect_current_version
if errorlevel 1 (
    echo No active PHP installation found to uninstall.
    goto :EOF
)

pushd "%BASE_DIR%" >nul 2>&1
if errorlevel 1 (
    echo Failed to access base directory "%BASE_DIR%".
    goto :EOF
)

if not exist "php" (
    echo Active directory "%BASE_DIR%\php" was not found.
    popd >nul
    goto :EOF
)

set "TARGET_DIR=php-!CURRENT_VERSION!"
if exist "!TARGET_DIR!" (
    echo Target directory "%BASE_DIR%\!TARGET_DIR!" already exists. Cannot uninstall safely.
    popd >nul
    goto :EOF
)

echo Uninstalling PHP !CURRENT_VERSION! ...
ren "php" "!TARGET_DIR!"
if errorlevel 1 (
    echo Failed to uninstall the active PHP installation.
    popd >nul
    goto :EOF
)

popd >nul
echo PHP !CURRENT_VERSION! has been removed. No active PHP installation is currently available.
goto :EOF

:show_current_version
set "CURRENT_VERSION="
set "CURRENT_FULL="
call :detect_current_version
if errorlevel 1 (
    echo Unable to determine the active PHP version. Ensure "%BASE_DIR%\php\php.exe" exists.
) else (
    echo Current PHP version: !CURRENT_FULL!  [Active folder: %BASE_DIR%\php]
)
goto :EOF

:switch_version
set "TARGET_VERSION=%~1"
set "TARGET_DIR=%BASE_DIR%\php-%TARGET_VERSION%"

if not exist "%TARGET_DIR%" (
    echo Target directory "%TARGET_DIR%" was not found.
    goto :EOF
)

set "HAS_ACTIVE=0"
set "CURRENT_VERSION="
set "CURRENT_FULL="
call :detect_current_version
if errorlevel 1 (
    if exist "%BASE_DIR%\php" (
        echo Unable to determine the current PHP version. Aborting switch.
        goto :EOF
    )
) else (
    set "HAS_ACTIVE=1"
)

if /I "!CURRENT_VERSION!"=="%TARGET_VERSION%" if "%HAS_ACTIVE%"=="1" (
    echo PHP %TARGET_VERSION% is already active.
    goto :EOF
)

pushd "%BASE_DIR%" >nul 2>&1
if errorlevel 1 (
    echo Failed to access base directory "%BASE_DIR%".
    goto :EOF
)

if "%HAS_ACTIVE%"=="1" (
    if not exist "php" (
        echo Active directory "%BASE_DIR%\php" was not found.
        popd >nul
        goto :EOF
    )

    set "CURRENT_DIR=php-!CURRENT_VERSION!"
    if exist "!CURRENT_DIR!" (
        echo Directory "%BASE_DIR%\!CURRENT_DIR!" already exists. Resolve this conflict before switching.
        popd >nul
        goto :EOF
    )

    echo Deactivating PHP !CURRENT_VERSION! ...
    ren "php" "!CURRENT_DIR!"
    if errorlevel 1 (
        echo Failed to rename the active PHP directory.
        popd >nul
        goto :EOF
    )
) else (
    if exist "php" (
        echo An unexpected "php" directory already exists but could not be identified. Aborting switch.
        popd >nul
        goto :EOF
    )
)

echo Activating PHP %TARGET_VERSION% ...
ren "php-%TARGET_VERSION%" "php"
if errorlevel 1 (
    echo Failed to activate PHP %TARGET_VERSION%.
    if "%HAS_ACTIVE%"=="1" (
        echo Restoring previous version...
        ren "!CURRENT_DIR!" "php" >nul 2>&1
    )
    popd >nul
    goto :EOF
)

popd >nul
echo Successfully switched to PHP %TARGET_VERSION%.

set "CURRENT_VERSION="
set "CURRENT_FULL="
call :detect_current_version
if not errorlevel 1 (
    echo New active version: !CURRENT_FULL!
)

goto :EOF

:detect_current_version
set "CURRENT_VERSION="
set "CURRENT_FULL="
pushd "%BASE_DIR%" >nul 2>&1
if errorlevel 1 goto :detect_fail_nopop

if not exist "php\php.exe" (
    popd >nul
    goto :detect_fail
)

for /f "tokens=2 delims= " %%a in ('php\php.exe -v 2^>nul ^| findstr /B "PHP "') do (
    set "CURRENT_FULL=%%a"
    goto :detect_parse
)

popd >nul
goto :detect_fail

:detect_parse
popd >nul
for /f "tokens=1,2 delims=." %%a in ("!CURRENT_FULL!") do (
    set "CURRENT_VERSION=%%a.%%b"
)
if not defined CURRENT_VERSION set "CURRENT_VERSION=!CURRENT_FULL!"
exit /b 0

:detect_fail
exit /b 1

:detect_fail_nopop
exit /b 1

