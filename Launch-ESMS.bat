@echo off
setlocal
cd /d "%~dp0"
title ESMS Website Launcher

echo ================================================
echo   EXAMINATION SCHEDULE AND MANAGEMENT SYSTEM
echo ================================================
echo.

where node >nul 2>nul
if errorlevel 1 (
  echo ERROR: Node.js is not installed or not on PATH.
  echo Install Node.js LTS from https://nodejs.org/ and restart this launcher.
  echo.
  pause
  exit /b 1
)
where npm >nul 2>nul
if errorlevel 1 (
  echo ERROR: npm was not found. Reinstall Node.js LTS and try again.
  pause
  exit /b 1
)

if not exist "node_modules\" (
  echo First launch: installing website dependencies. This may take a few minutes...
  call npm install
  if errorlevel 1 (
    echo.
    echo Dependency installation failed. Check your internet connection and try again.
    pause
    exit /b 1
  )
)

echo Starting ESMS server...
start "ESMS Website Server" /D "%~dp0" cmd /k "npm run dev"

echo Waiting for the website to start...
powershell -NoProfile -ExecutionPolicy Bypass -Command "$deadline=(Get-Date).AddSeconds(90); $ready=$false; while ((Get-Date) -lt $deadline) { try { $c=New-Object System.Net.Sockets.TcpClient; $c.Connect('127.0.0.1',3000); $c.Close(); $ready=$true; break } catch { Start-Sleep -Seconds 2 } }; if ($ready) { exit 0 } else { exit 1 }"
if errorlevel 1 (
  echo.
  echo The server did not respond on port 3000 within 90 seconds.
  echo Check the ESMS Website Server window for errors.
  pause
  exit /b 1
)

echo Opening ESMS in your default browser...
start "" "http://localhost:3000"
echo.
echo ESMS is running. Keep the ESMS Website Server window open while presenting.
echo To stop the website, close the ESMS Website Server window.
timeout /t 5 >nul
exit /b 0
