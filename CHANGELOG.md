# Changelog

## [1.0.0] - Initial RaidStatusText Release

### Major Changes
- **Complete Redesign**: Removed all heal prediction functionality since MoP Classic has built-in heal prediction
- **Renamed**: Changed from HealBarsClassic-MoP to RaidStatusText-MoP to reflect new focus
- **Simplified**: Now focuses solely on displaying defensive cooldown status text on raid frames
- **Lightweight**: Removed LibHealComm dependencies and healing-related code

### New Features
- Dedicated status text configuration interface
- Comprehensive MoP defensive ability tracking
- Simplified slash commands (`/rst`, `/raidstatus`)
- Monk defensive abilities support (Fortifying Brew, Diffuse Magic, etc.)


### Technical Changes
- Removed LibHealComm-4.0 and LibHealComm-2.0-Classic dependencies
- Simplified codebase from ~900 lines to ~300 lines
- Updated TOC file with new addon name and version
- New configuration structure focused on status text only

