# Changelog

## [1.0.0] - 2025-07-14

### 🎉 Initial Release
- **RaidStatusText**: Dedicated addon for displaying defensive cooldowns on MoP Classic raid frames
- **Lightweight**: Focused purely on status text functionality - no heal bars, no heal prediction
- **37 Defensive Abilities**: Complete coverage of all major defensive cooldowns in Mists of Pandaria Classic

### ✨ Features
- **Status Text Display**: Shows defensive ability names directly on raid frames
- **Priority System**: Higher priority abilities (immunities) override lower priority ones
- **Six Categories**: Immunity, Shield Wall, Last Stand, Raid Defensives, Defensive, Spell Wall
- **Configurable**: Individual toggles for each ability, font size control, simple text mode
- **Monk Support**: Full support for Monk defensive abilities (Fortifying Brew, Diffuse Magic, Zen Meditation)
- **Performance**: Optimized for minimal resource usage

### 🛠️ Technical Details
- **MoP Classic Compatible**: Interface version 50500
- **Ace3 Framework**: Uses AceAddon-3.0, AceConfig-3.0, AceDB-3.0, AceConsole-3.0, AceEvent-3.0
- **Event-Driven**: Responds to UNIT_AURA events for real-time updates
- **Hook Integration**: Seamless integration with Blizzard's CompactUnitFrame_UpdateStatusText

### 📋 Supported Abilities
**Immunity (Priority 1-5)**: Divine Shield, Ice Block, Deterrence, Zen Meditation, Dispersion  
**Shield Wall (Priority 6-10)**: Shield Wall, Survival Instincts, Unending Resolve, Pain Suppression, Astral Shift  
**Last Stand (Priority 11-16)**: Last Stand, Vampiric Blood, Ardent Defender, Guardian Spirit, Fortifying Brew, Might of Ursoc  
**Raid Defensives (Priority 17-20)**: Devotion Aura, Vigilance, Avert Harm, Spirit Link Totem, Power Word: Barrier  
**Defensive (Priority 21-25)**: Barkskin, Ironbark, Icebound Fortitude, Dampen Harm, Divine Protection  
**Spell Wall (Priority 26-30)**: Cloak of Shadows, Spell Reflection, Diffuse Magic, Anti-Magic Shell, Hand of Protection  
**Miscellaneous (Priority 31-37)**: Shamanistic Rage, Feint, Roar of Sacrifice, Evasion, Die by the Sword, Dark Bargain, Anti-Magic Zone

### 💬 Commands
- `/rst` - Open configuration menu
- `/rst version` - Show version information

