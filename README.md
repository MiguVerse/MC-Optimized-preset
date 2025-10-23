# Optimized MiguVerse's Server Default Configuration

This is a fully optimized Minecraft server configuration template for **LeafMC** with **10GB RAM allocation**. Designed to work efficiently on any modern multi-core processor. Can be used as a base for various server types including Survival, Creative, Mini-games, and more.

## Server Software

- **[LeafMC](https://www.leafmc.one/)** - High-performance fork of Paper with advanced optimization features
- Based on: Paper MC, Purpur, and Gale optimizations

## Recommended Specifications

- **CPU**: Any modern multi-core processor (4+ cores recommended)
- **RAM**: 10GB allocated to server (adjustable based on player count)
- **Java**: JDK 21 (recommended for Virtual Thread support)

---

## Files Modified

### Start Scripts

#### `start.bat` (Windows)

**Purpose**: Launch the Minecraft server on Windows with optimized JVM settings.

**Features**:

- Allocates **10G initial and maximum heap** (`-Xms10G -Xmx10G`)
- Uses **G1GC garbage collector** with Aikar's recommended flags for low-latency performance
- Supports custom jar names via command-line argument
- Includes error checking (verifies jar file exists before starting)
- Displays startup information with color-coded errors
- Keeps terminal open on crash for debugging
- Includes **DLeaf.enableFMA** for LeafMC math optimizations, improving performance on compatible CPUs (If your CPU doesn't support it, worse performance may occur but to be real, who uses CPUs that don't support FMA in 2025?)

**Usage**:

```bash
# Run with default server.jar
start.bat

# Run with custom jar name
start.bat custom-server.jar
```

#### `start.sh` (Linux/macOS)

**Purpose**: Launch the Minecraft server on Linux/macOS with optimized JVM settings.

**Features**:

- Allocates **10G initial and maximum heap** (`-Xms10G -Xmx10G`)
- Uses **G1GC garbage collector** with Aikar's recommended flags for low-latency performance
- Supports custom jar names via command-line argument
- Includes error checking (verifies jar file exists before starting)
- Proper POSIX shell script with safety flags (`set -euo pipefail`)
- Works from any directory (changes to script directory automatically)
- Includes **DLeaf.enableFMA** for LeafMC math optimizations, improving performance on compatible CPUs (If your CPU doesn't support it, worse performance may occur but to be real, who uses CPUs that don't support FMA in 2025?)

**Usage**:

```bash
# Make the script executable (first time only)
chmod +x start.sh

# Run with default server.jar
./start.sh

# Run with custom jar name
./start.sh custom-server.jar
```

#### Server JAR File Requirements

⚠️ **Important**: The server jar file **must be named `server.jar`** and placed in the same directory as the start scripts.

- Default jar name: `server.jar`
- Location: Root directory of this configuration (alongside `start.bat` and `start.sh`)
- Override: Pass a different jar name as the first argument to either script

**Example directory structure**:

```
MC-Optimized-preset/
├── start.bat
├── start.sh
├── server.jar           ← Required here
├── server.properties
├── bukkit.yml
├── config/
└── plugins/
```

If your jar has a different name (e.g., `leafmc-1.21.4.jar`), either:

1. Rename it to `server.jar`, or
2. Pass it as an argument: `./start.sh leafmc-1.21.4.jar` or `start.bat leafmc-1.21.4.jar`

### Core Server Configuration

#### `server.properties`

- **allow-flight**: `false` → `true` (prevents false kicks on horses/scaffolding)
- **network-compression-threshold**: `256` (optimal default)
- **simulation-distance**: `10` → `8` (reduces entity load)
- **view-distance**: `10` (balanced terrain view)

### Bukkit Configuration

#### `bukkit.yml`

- **spawn-limits** - Balanced for performance:

  - monsters: `50` (reduced from 70)
  - animals: `8` (reduced from 10)
  - water-animals: `3` (reduced from 5)
  - water-ambient: `10` (reduced from 20)
  - axolotls: `3` (reduced from 5)
  - ambient: `8` (reduced from 15)

- **ticks-per**:
  - monster-spawns: `10` (balanced spawn rate)
  - autosave: `6000` (5-minute intervals)

### Spigot Configuration

#### `spigot.yml`

- **mob-spawn-range**: `6` (optimized from vanilla 8)

- **entity-activation-range** - Vanilla parity maintained:

  - animals: `32` (increased from default 16)
  - monsters: `32` (increased from default 24)
  - villagers: `32` (balanced performance)
  - misc: `16` (default)
  - water: `16` (default)

- **merge-radius**:
  - exp: `4.0` (vanilla merging enabled)
  - item: `3.5` (vanilla merging enabled)

### Paper Global Configuration

#### `config/paper-global.yml`

- **chunk-loading-advanced**:

  - player-max-concurrent-chunk-generates: `0` → `8`
  - player-max-concurrent-chunk-loads: `0` → `8`

- **chunk-loading-basic**:

  - player-max-chunk-generate-rate: `-1.0` → `10.0`
  - player-max-chunk-load-rate: `100.0` → `200.0`
  - player-max-chunk-send-rate: `75.0` → `200.0`

- **chunk-system**:

  - io-threads: `-1` → `8`
  - worker-threads: `-1` → `12`

- **misc**:

  - chat-executor-core-size: `-1` → `8`
  - chat-executor-max-size: `-1` → `16`
  - compression-level: `default` → `6`
  - max-joins-per-tick: `5` → `3`
  - region-file-cache-size: `256` → `512`

- **packet-limiter**:
  - max-packet-rate: `500.0` → `300.0`

### Paper World Defaults

#### `config/paper-world-defaults.yml`

- **chunks**:

  - delay-chunk-unloads-by: `10s` (default balanced)

- **entities**:

  - experience-merge-max-value: `-1` (vanilla XP merging preserved)
  - only-merge-items-horizontally: `false` (vanilla behavior)

- **spawning**:

  - alt-item-despawn-rate: `enabled` with expanded item list:
    - cobblestone, netherrack, sand, dirt, grass, leaves, bamboo, kelp, sugar_cane, etc. (300 ticks)
    - scaffolding (600 ticks)

- **environment**:

  - treasure-maps.villager-trade: `true` (prevents lag from treasure map searches)

- **tick-rates**:
  - All set to vanilla defaults (`-1` or `1`) for maximum compatibility

### Leaf Configuration

#### `config/leaf-global.yml`

- **async improvements** (enabled for high-performance):

  - parallel-world-ticking: `false` → `true` (experimental, 8 threads)
  - async-entity-tracker: `false` → `true` (8 max threads)
  - async-target-finding: `false` → `true`
  - async-playerdata-save: `false` → `true`
  - async-pathfinding: `false` → `true` (6 max threads)
  - async-locator: `false` → `true` (4 threads)
  - async-chunk-send: `false` → `true`

- **performance optimizations** (enabled):

  - use-virtual-thread-for-profile-executor: `false` → `true`
  - use-virtual-thread-for-async-scheduler: `false` → `true`
  - create-snapshot-on-retrieving-blockstate: `true` → `false`
  - throttle-mob-spawning: `false` → `true` (20% spawn chance)
  - throttle-hopper-when-full: `false` → `true`
  - optimized-powered-rails: `false` → `true`
  - optimise-random-tick: `false` → `true`
  - only-tick-items-in-hand: `false` → `true`
  - cache-biome: `false` → `true` (all modes enabled)
  - faster-random-generator: `false` → `true` (Xoroshiro128PlusPlus)
  - use-direct-implementation: `false` → `true`
  - cache-eye-fluid-status: `false` → `true`
  - check-survival-before-growth: `false` → `true` (cactus)

- **network optimizations**:
  - OptimizeNonFlushPacketSending: `false` → `true`
  - async-switch-state: `false` → `true`
  - cache-profile-lookup: `false` → `true`
  - secure-seed: `false` → `true`

### Purpur Configuration

#### `purpur.yml`

- **lagging-threshold**: `19.0` (default)

- **villager lobotomize** (major performance optimization):

  - enabled: `true`
  - check-interval: `100` ticks
  - Reduces villager AI when stuck in 1x1 trading halls

- **villager search-radius**:

  - acquire-poi: `16` (reduced from 48 - **HUGE performance gain**)
  - nearest-bed-sensor: `16` (reduced from 48)

- **zombie**:
  - aggressive-towards-villager-when-lagging: `false` (prevents lag spikes)

### Plugin Configuration - RayTracedAntiXray

#### Global Configuration (`config.yml`)

| Setting   | Default | Optimized | Reason                                                              |
| --------- | ------- | --------- | ------------------------------------------------------------------- |
| `threads` | 4       | 8         | Better multi-core utilization - Adjust based on your CPU core count |

#### Overworld Configuration (`default-overworld.yml`)

| Setting                | Default   | Optimized      | Impact                                      |
| ---------------------- | --------- | -------------- | ------------------------------------------- |
| `tracePlacedBlock`     | true      | **false**      | 🔥 **More CPU efficient**                   |
| `revealStopRaytracing` | false     | **true**       | 🔥 **CPU savings & better user-experience** |
| `fakeConfig.ores`      | 0 configs | **16 configs** | 🔥 **Fake ore generation**                  |

#### Nether Configuration (`default-nether.yml`)

| Setting                | Default   | Optimized     | Impact                                      |
| ---------------------- | --------- | ------------- | ------------------------------------------- |
| `tracePlacedBlock`     | true      | **false**     | 🔥 **More CPU efficient**                   |
| `revealStopRaytracing` | false     | **true**      | 🔥 **CPU savings & better user-experience** |
| `fakeConfig.ores`      | 0 configs | **3 configs** | 🔥 **Fake ore generation**                  |

#### Entity Culling Configuration (`entity-culling/default.yml`)

| Setting        | Default  | Optimized     | Impact                             |
| -------------- | -------- | ------------- | ---------------------------------- |
| `entityTypes`  | 13 types | **48+ types** | 🔥 **Comprehensive ESP blocking**  |
| `rotatingRate` | 3        | **1**         | 🔥 **Instant updates on rotation** |

#### Performance Impact Summary

| Optimization                 | Description                                            |
| ---------------------------- | ------------------------------------------------------ |
| `revealStopRaytracing: true` | Stops raytracing legitimately revealed ores            |
| `tracePlacedBlock: false`    | Disables intensive block placement tracking            |
| `rotatingRate: 1`            | More efficient but responsive culling                  |
| `threads: 8`                 | Better load distribution (no savings, better capacity) |
| **Total Estimated**          | Combined CPU reduction vs defaults                     |

#### Anti-Cheat Coverage Comparison

| Protection Type       | Default                | Optimized                  | Effectiveness |
| --------------------- | ---------------------- | -------------------------- | ------------- |
| Ore X-Ray (Overworld) | ✅ Basic               | ✅ **+ 16 Fake Ores**      | ⭐⭐⭐⭐⭐    |
| Ore X-Ray (Nether)    | ✅ Basic               | ✅ **+ 3 Fake Ores**       | ⭐⭐⭐⭐⭐    |
| Player ESP            | ✅ Basic (13 entities) | ✅ **48+ Entities**        | ⭐⭐⭐⭐⭐    |
| Mob ESP               | ✅ Limited             | ✅ **All Mobs + Variants** | ⭐⭐⭐⭐⭐    |
| Chest ESP             | ✅ 44 types            | ✅ **43 Vanilla Types**    | ⭐⭐⭐⭐⭐    |

---

## Recommended Plugins with Pre-Made Configs

### AntiXray & ESP Prevention Suite

- **[RayTracedAntiXray](https://builtbybit.com/resources/raytraceantixray-ores-entities-tiles.41896/)** - Ray-traced ore protection (8 threads allocated)
  - Addon: `raytraced-entity-culling` - Hides hidden entities
  - Addon: `raytraced-tile-culling` - Hides hidden tile entities
  - **Configuration Included**: ✅ `plugins/raytraced-antixray/` and `plugins/raytraced-entity-culling/`

### AntiCheat Solutions

- **[Lightning GrimAC](https://modrinth.com/plugin/lightning-grim-anticheat)** - Free, open-source anticheat (recommended)

  - Modern prediction-based anticheat with excellent accuracy
  - Works perfectly with default configuration
  - Compatible with other anticheats for layered protection

- **[Vulcan AntiCheat](https://vulcanac.net/)** - Premium anticheat (paid)
  - Professional-grade cheat detection based on packet analysis
  - Works alongside GrimAC for comprehensive protection
  - Default config works well with this server configuration

Both together provide robust cheat detection with minimal false positives, cause Lighting GrimAC handles prediction checks while Vulcan focuses on packet anomalies, but remember, the best anticheat is a well-informed community and vigilant staff, just add this anticheat layer in servers where cheating is a real concern.

### Performance Monitoring

- **[Spark](https://spark.lucko.me/)** - Server profiler and performance analyzer
  - **Configuration Included**: ❌ (default config is sufficient)

---

## Performance Tuning Guide

Depends on your server hardware, player count and use case. Adjust settings as needed.

### Monitoring Performance

```bash
# Use Spark for real-time profiling
/spark profiler start
/spark profiler stop
/spark viewer
```

---

## Important Notes

### ⚠️ Before Deploying

1. **Backup your worlds** before using this configuration
2. **Test with few players** first to verify performance
3. **Monitor TPS** using `/tps` command (should stay 20 TPS)
4. **Check RAM usage** - aim for 60-80% of allocated heap

### 📊 Expected Performance

Varies based on player count, activity, and environment.

### 🔧 Further Optimization Tips

1. Use SSD for world storage
2. Limit view-distance to 8-10 per player
3. Use Spark to identify lag sources
4. Consider async-safe plugins only

### 🐛 Troubleshooting

**Low TPS?**

- Check Spark profiler for lag sources
- Reduce spawn limits further
- Increase entity-activation-range reduction
- Check for plugin conflicts

**High RAM Usage?**

- Reduce max-players
- Decrease chunk-loading rates
- Enable more aggressive chunk unloading

**Crashed/Unstable?**

- Revert async features one by one
- Use vanilla Leaf defaults and re-apply optimizations gradually

---

## Configuration Versions

- **LeafMC**: Latest stable (1.21.4+)
- **Paper Version**: Latest compatible
- **Purpur Version**: Latest compatible
- **Configuration Date**: October 20, 2025

---

## Credits

Optimizations based on:

- [Paper Documentation](https://docs.papermc.io/)
- [PurpurMC Docs](https://purpurmc.org/docs/purpur/)
- [LeafMC Docs](https://www.leafmc.one/docs)
- [Paper Optimization Guide](https://paper-chan.moe/paper-optimization/)

---

---

## Key Configuration Philosophy

✅ **Vanilla Parity Maintained** - No gameplay-breaking changes
✅ **Performance Optimized** - Balanced for modern multi-core processors
✅ **Professional Setup** - Based on paper-chan.moe, PurpurMC, and LeafMC official docs

**Last Updated**: October 23, 2025
**Optimized For**: Any modern CPU / 10GB RAM / LeafMC 1.21.4+
