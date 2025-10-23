@echo off
REM start.bat - Windows start script for the Minecraft server
REM
REM This batch script starts the Minecraft server with optimized JVM flags.
REM It allocates 10G initial and max heap and includes Aikar's recommended
REM G1GC flags for low-latency performance.
REM
REM Usage:
REM   start.bat                    (runs server.jar)
REM   start.bat custom-server.jar  (runs custom-server.jar)

setlocal enabledelayedexpansion

REM Get the directory where this script is located
set "SCRIPT_DIR=%~dp0"
cd /d "%SCRIPT_DIR%"

REM JVM memory settings
set "XMS=10G"
set "XMX=10G"

REM Default server jar
set "SERVER_JAR=server.jar"

REM If a jar name is provided as first argument, use that
if not "%~1"=="" (
  set "SERVER_JAR=%~1"
)

REM Check if the jar file exists
if not exist "!SERVER_JAR!" (
  color 0c
  echo.
  echo ERROR: Server jar '!SERVER_JAR!' not found in !SCRIPT_DIR!
  echo.
  pause
  exit /b 1
)

REM Display startup information
echo.
echo ============================================
echo Starting Minecraft server using !SERVER_JAR!
echo Memory: !XMS! initial, !XMX! maximum
echo ============================================
echo.

REM Run the server with optimized JVM flags
java ^
  -Xms!XMS! ^
  -Xmx!XMX! ^
  -XX:+UseG1GC ^
  -XX:+ParallelRefProcEnabled ^
  -XX:MaxGCPauseMillis=200 ^
  -XX:+UnlockExperimentalVMOptions ^
  -XX:+DisableExplicitGC ^
  -XX:+AlwaysPreTouch ^
  -XX:G1NewSizePercent=30 ^
  -XX:G1MaxNewSizePercent=40 ^
  -XX:G1HeapRegionSize=8M ^
  -XX:G1ReservePercent=20 ^
  -XX:G1HeapWastePercent=5 ^
  -XX:G1MixedGCCountTarget=4 ^
  -XX:InitiatingHeapOccupancyPercent=15 ^
  -XX:G1MixedGCLiveThresholdPercent=90 ^
  -XX:G1RSetUpdatingPauseTimePercent=5 ^
  -XX:SurvivorRatio=32 ^
  -XX:+PerfDisableSharedMem ^
  -XX:MaxTenuringThreshold=1 ^
  -Dusing.aikars.flags=https://mcflags.emc.gs ^
  -Daikars.new.flags=true ^
  -DLeaf.enableFMA=true ^
  -jar !SERVER_JAR! nogui

REM Keep the window open if the server crashes
pause
