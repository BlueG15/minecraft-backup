@echo off
title Minecraft Server Launcher

:: Step 1: Already in command prompt

:: Step 2: Prompt for max RAM
set "DEFAULT_RAM=8G"
set /p "MAX_RAM=Enter max RAM (e.g. 4G, 8G, 16G) [default: %DEFAULT_RAM%]: "

:: Use default if nothing entered
if "%MAX_RAM%"=="" set "MAX_RAM=%DEFAULT_RAM%"

echo.
echo Starting Minecraft server with -Xms1G -Xmx%MAX_RAM% ...
echo.

:: Step 3: Start the Minecraft server in this window
start "Minecraft Server" cmd /k "java -Xms1G -Xmx%MAX_RAM% -jar minecraft_server.1.21.11.jar --nogui"

:: Brief pause to let server start initializing
timeout /t 3 /nobreak >nul

:: Step 4: Open new command prompt and run ngrok
start "ngrok Tunnel" cmd /k "ngrok tcp 25565"

:: Step 5: Wait for ngrok to initialize, then try to grab the URL and copy to clipboard
echo Waiting for ngrok to initialize...
timeout /t 5 /nobreak >nul

:: Fetch ngrok public URL via its local API and copy to clipboard
echo Attempting to copy ngrok URL to clipboard...

:: Use PowerShell to query the ngrok local API and extract the public URL
powershell -Command ^
  "try { ^
    $r = Invoke-RestMethod -Uri 'http://localhost:4040/api/tunnels' -ErrorAction Stop; ^
    $url = $r.tunnels[0].public_url; ^
    if ($url) { ^
      Set-Clipboard -Value $url; ^
      Write-Host ''; ^
      Write-Host '========================================'; ^
      Write-Host ' ngrok URL copied to clipboard!'; ^
      Write-Host ' URL: ' $url; ^
      Write-Host '========================================'; ^
      Write-Host ''; ^
      Write-Host 'Share this address with your friends.'; ^
      Write-Host 'Note: Replace ''tcp://'' with nothing and use as server address.'; ^
    } else { Write-Host 'Could not retrieve ngrok URL. Check the ngrok window manually.' } ^
  } catch { Write-Host 'ngrok API not reachable yet. Check the ngrok window for the URL.' }"

echo.
pause