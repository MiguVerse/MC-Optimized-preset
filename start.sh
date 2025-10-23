#!/usr/bin/env bash
# start.sh - Linux start script for the Minecraft server
#
# This mirrors the existing Windows `start.bat` JVM flags but uses a POSIX shell
# wrapper. It allocates 10G initial and max heap and includes Aikar's recommended
# G1GC flags present in the repository.
#
# Usage:
#   chmod +x start.sh
#   ./start.sh

set -euo pipefail

# Directory of the script (so it can be run from anywhere)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# JVM memory settings
XMS="10G"
XMX="10G"

# JVM flags (based on Aikar's flags and the Windows start.bat)
JVM_FLAGS=(
  "-Xms${XMS}"
  "-Xmx${XMX}"
  "-XX:+UseG1GC"
  "-XX:+ParallelRefProcEnabled"
  "-XX:MaxGCPauseMillis=200"
  "-XX:+UnlockExperimentalVMOptions"
  "-XX:+DisableExplicitGC"
  "-XX:+AlwaysPreTouch"
  "-XX:G1NewSizePercent=30"
  "-XX:G1MaxNewSizePercent=40"
  "-XX:G1HeapRegionSize=8M"
  "-XX:G1ReservePercent=20"
  "-XX:G1HeapWastePercent=5"
  "-XX:G1MixedGCCountTarget=4"
  "-XX:InitiatingHeapOccupancyPercent=15"
  "-XX:G1MixedGCLiveThresholdPercent=90"
  "-XX:G1RSetUpdatingPauseTimePercent=5"
  "-XX:SurvivorRatio=32"
  "-XX:+PerfDisableSharedMem"
  "-XX:MaxTenuringThreshold=1"
  "-Dusing.aikars.flags=https://mcflags.emc.gs"
  "-Daikars.new.flags=true"
  "-DLeaf.enableFMA=true"
)

# Default server jar (keep in sync with start.bat)
SERVER_JAR="server.jar"

# If a jar name is provided as first argument, use that
if [[ ${#} -ge 1 && ${1} != "" ]]; then
  SERVER_JAR="$1"
  shift || true
fi

if [[ ! -f "$SERVER_JAR" ]]; then
  echo "ERROR: Server jar '$SERVER_JAR' not found in $SCRIPT_DIR" >&2
  exit 1
fi

echo "Starting Minecraft server using $SERVER_JAR"
echo "JVM: ${JVM_FLAGS[*]}"

exec java "${JVM_FLAGS[@]}" -jar "$SERVER_JAR" nogui "$@"
