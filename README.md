# Optimized MiguVerse's Server Default Configuration

This is a fully optimized Minecraft server configuration template for **LeafMC** tested on a **Ryzen 9 5950X (16-core/32-thread)** with **10GB RAM allocation**. Can be used as a base for various server types including Survival, Creative, Mini-games, and more, also it can be adapted for any other CPU, by default it is optimized for all CPUs and minor adjustments may be needed for lower core count CPUs.

## Server Software

- **[LeafMC](https://www.leafmc.one/)** - High-performance fork of Paper with advanced optimization features
- Based on: Paper MC, Purpur, and Gale optimizations

## Hardware Specifications

- **CPU**: AMD Ryzen 9 5950X (16 cores / 32 threads)
- **RAM**: 10GB allocated to server
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

- **network-compression-threshold**: `256` → `512`
  - Reduces network overhead for more efficient bandwidth usage
- **region-file-compression**: `deflate` → `lz4`
  - Faster region file compression (better for high-activity servers)
- **simulation-distance**: `10` → `8`
  - Reduces entity simulation load while maintaining good gameplay feel
- **sync-chunk-writes**: `true` → `false`
  - Asynchronous chunk writes for better performance

### Bukkit Configuration

#### `bukkit.yml`

- **spawn-limits** - Reduced for better performance balance:

  - monsters: `70` → `50`
  - animals: `10` → `8`
  - water-animals: `5` → `3`
  - water-ambient: `20` → `10`
  - axolotls: `5` → `3`
  - ambient: `15` → `8`

- **chunk-gc period**: `600` → `400` ticks

  - More aggressive garbage collection for memory management

- **spawn tick rates** - Reduced for better optimization:
  - water-spawns: `1` → `400` ticks
  - water-ambient-spawns: `1` → `400` ticks
  - water-underground-creature-spawns: `1` → `400` ticks
  - axolotl-spawns: `1` → `400` ticks
  - ambient-spawns: `1` → `400` ticks
  - autosave: `6000` → `12000` ticks (20-minute intervals)

### Spigot Configuration

#### `spigot.yml`

- **netty-threads**: `4` → `8`

  - Better network handling for modern CPUs

- **mob-spawn-range**: `8` → `6`

  - Reduces mob spawning load

- **entity-activation-range** - Optimized distances:

  - animals: `32` → `16`
  - monsters: `32` → `24`
  - raiders: `64` → `48`
  - misc: `16` → `8`
  - water: `16` → `8`
  - villagers: `32` → `16`
  - flying-monsters: `32` → `24`

- **wake-up-inactive** - Reduced entity processing:

  - animals-max-per-tick: `4` → `2`
  - monsters-max-per-tick: `8` → `4`
  - villagers-max-per-tick: `4` → `2`
  - flying-monsters-max-per-tick: `8` → `4`

- **tick-inactive-villagers**: `true` → `false`

  - Disabled ticking for inactive villagers (major performance gain)

- **merge-radius** - Increased item/exp merging:

  - exp: `-1.0` → `4.0`
  - item: `0.5` → `3.5`

- **hopper-check**: `1` → `8`
  - Reduced hopper checking frequency for better performance

### Paper Global Configuration

#### `config/paper-global.yml`

- **chunk-loading-advanced**:

  - player-max-concurrent-chunk-generates: `0` → `8`
  - player-max-concurrent-chunk-loads: `0` → `8`

- **chunk-loading-basic**:

  - player-max-chunk-generate-rate: `-1.0` → `8.0`
  - player-max-chunk-load-rate: `100.0` → `150.0`
  - player-max-chunk-send-rate: `75.0` → `150.0`

- **chunk-system**:

  - io-threads: `-1` → `8`
  - worker-threads: `-1` → `12`

- **misc**:
  - chat-executor-core-size: `-1` → `8`
  - chat-executor-max-size: `-1` → `16`
  - compression-level: `default` → `6`
  - region-file-cache-size: `256` → `512`

### Paper World Defaults

#### `config/paper-world-defaults.yml`

- **chunks**:

  - delay-chunk-unloads-by: `10s` → `15s`
  - max-auto-save-chunks-per-tick: `24` → `8`
  - prevent-moving-into-unloaded-chunks: `false` → `true`
  - entity-per-chunk-save-limit: Limited individual entity types

- **entities**:

  - armor-stands do-collision-entity-lookups: `true` → `false`
  - experience-merge-max-value: `-1` → `25`
  - only-merge-items-horizontally: `false` → `true`

- **spawning**:

  - alt-item-despawn-rate: `false` → `true`
    - Specific items despawn faster (cobblestone, netherrack, dirt, sand, etc.)
  - creative-arrow-despawn-rate: `default` → `60` ticks
  - non-player-arrow-despawn-rate: `default` → `60` ticks

- **environment**:

  - optimize-explosions: `false` → `true`

- **hopper**:

  - ignore-occluding-blocks: `false` → `true`

- **misc**:

  - redstone-implementation: `VANILLA` → `ALTERNATE_CURRENT`
    - Much faster redstone processing

- **tick-rates** - Reduced update frequencies:
  - villager validatenearbypoi: `-1` → `60` ticks
  - grass-spread: `1` → `4` ticks
  - mob-spawner: `1` → `2` ticks
  - villager secondarypoisensor: `40` → `80` ticks

### Leaf Configuration

#### `config/leaf-global.yml`

- **async improvements** (enabled for high-performance):

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

- **network optimizations**:
  - OptimizeNonFlushPacketSending: `false` → `true`
  - async-switch-state: `false` → `true`

### Purpur Configuration

#### `purpur.yml`

- **lagging-threshold**: `19.0` → `17.5`

  - More aggressive lag detection

- **villager lobotomize** (optimization):

  - enabled: `false` → `true`
  - check-interval: `100` → `60` ticks
  - wait-until-trade-locked: `false` → `true`
  - Significantly reduces villager AI processing when inactive

- **squid immune-to-EAR**: `true` → `false`
  - Allows squids to properly be affected by entity activation range

### Plugin Configuration

#### `plugins/raytraced-antixray/config.yml`

- **threads**: `4` → `8`
  - Better antixray raytracing performance using available CPU cores
  - Supports more concurrent players with active antixray

---

## Recommended Plugins with Pre-Made Configs

### AntiXray Solution

- **[RayTracedAntiXray](https://builtbybit.com/resources/raytraceantixray-ores-entities-tiles.41896/)** - Ray-traced ore protection (8 threads allocated)
  - Addon: `raytraced-entity-culling` - Hides hidden entities
  - Addon: `raytraced-tile-culling` - Hides hidden tile entities
  - **Configuration Included**: ✅ `plugins/raytraced-antixray/config.yml`

### Performance Monitoring

- **[Spark](https://spark.lucko.me/)** - Server profiler and performance analyzer
  - **Configuration Included**: ✅ `plugins/spark/config.json`

### Library Dependencies

- **[Fairy-lib-plugin](https://builtbybit.com/resources/fairy-lib-plugin.50615/)** - Shared library for plugins
  - **Configuration Included**: ✅ `plugins/fairy-lib-plugin/`
  - **Used by**: RayTracedAntiXray and addons

---

## Performance Tuning Guide

### For Different Playstyles

**PvP/Combat-Heavy Server**:

- Keep aggressive mob-spawn limits (current config is good)
- Enable strict knockback settings if needed

**Creative/Building Server**:

- Can increase spawn limits slightly
- Reduce entity-activation-range further

**Survival/Vanilla Experience**:

- Current configuration is optimal
- Balanced between performance and gameplay feel

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

- **Single Player**: 20 TPS consistently
- **10-20 Players**: 19.5-20 TPS (minimal lag)
- **20-50 Players**: 18-20 TPS depending on activity
- **50+ Players**: Requires additional tuning based on activity

### 🔧 Further Optimization Tips

1. Use SSD for world storage
2. Enable `async-chunk-send` (already enabled)
3. Limit view-distance to 8-10 per player
4. Use Spark to identify lag sources
5. Consider async-safe plugins only

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
- **Configuration Date**: October 19, 2025

---

## Credits

Optimizations based on:

- [Paper Documentation](https://docs.papermc.io/)
- [PurpurMC Docs](https://purpurmc.org/docs/purpur/)
- [LeafMC Docs](https://www.leafmc.one/docs)
- [Paper Optimization Guide](https://paper-chan.moe/paper-optimization/)

---

**Last Updated**: October 19, 2025
**Optimized and Tested For**: Ryzen 9 5950X / 10GB RAM / LeafMC 1.21.4+
