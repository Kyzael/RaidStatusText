-- Version Detection
local ADDON_VERSION = GetAddOnMetadata("RaidStatusText", "Version") or "1.0.0"
local GAME_VERSION = select(4, GetBuildInfo())
local isMoP = GAME_VERSION >= 50500 and GAME_VERSION < 60000
local isCompatible = isMoP

-- Ensure we're running on MoP Classic
if not isCompatible then
    print("|cFFFF0000RaidStatusText|r: This version is designed for Mists of Pandaria Classic only!")
end

RaidStatusText = LibStub("AceAddon-3.0"):NewAddon("RaidStatusText", "AceEvent-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceConsole = LibStub("AceConsole-3.0")
local statusGUIDs = {}
local RSTdb = {}

-- Status Text Configuration Lists
RaidStatusText.lastStandStatusTextConfigList = { 
  ['LASTSTAND'] = 'Last Stand - LASTSTAND',
  ['VAMPIRIC'] = 'Vampiric Blood - VAMPIRIC',
  ['ARDENT'] = 'Ardent Defender - ARDENT',
  ['GUARDIAN'] = 'Guardian Spirit - GUARDIAN',
  ['FORTIFY'] = 'Fortifying Brew - FORTIFY',
  ['URSOC'] = 'Might of Ursoc - URSOC'
}
RaidStatusText.shieldWallStatusTextConfigList = { 
  ['SHLDWALL'] = 'Shield Wall - SHLDWALL',
  ['SURVIVAL'] = 'Survival Instincts - SURVIVAL',
  ['RESOLVE'] = 'Unending Resolve - RESOLVE',
  ['PAINSUP'] = 'Pain Suppression - PAINSUP',
  ['ASTRAL'] = 'Astral Shift - ASTRAL'
}
RaidStatusText.defensiveStatusTextConfigList = {
  ['BARKSKIN'] = 'Barkskin - BARKSKIN',
  ['IRONBARK'] = 'Ironbark - IRONBARK',
  ['ICEBOUND'] = 'Icebound Fortitude - ICEBOUND',
  ['DAMPEN'] = 'Dampen Harm - DAMPEN',
  ['DIVPROT'] = 'Divine Protection - DIVPROT'
}
RaidStatusText.spellWallStatusTextConfigList = { 
  ['CLOAK'] = 'Cloak of Shadows - CLOAK',
  ['SPELLREFL'] = 'Spell Reflection - SPELLREFL',
  ['DIFFUSE'] = 'Diffuse Magic - DIFFUSE',
  ['ANTISHELL'] = 'Anti-Magic Shell - ANTISHELL'
}
RaidStatusText.immunityStatusTextConfigList = { 
  ['DIVSHIELD'] = 'Divine Shield - DIVSHIELD', 
  ['ICEBLOCK'] = 'Ice Block - ICEBLOCK',
  ['DETERENCE'] = 'Deterrence - DETERENCE',
  ['ZENMED'] = 'Zen Meditation - ZENMED',
  ['DISPERS'] = 'Dispersion - DISPERS',
  ['DARKBARGN'] = 'Dark Bargain - DARKBARGN',
  ['EVASION'] = 'Evasion - EVASION',
  ['DIVPROT'] = 'Divine Protection - DIVPROT',
  ['HANDPROT'] = 'Hand of Protection - HANDPROT',
  ['DIEBYSWD'] = 'Die by the Sword - DIEBYSWD'
}
RaidStatusText.raidDefensiveStatusTextConfigList = {
  ['DEVOTION'] = 'Devotion Aura - DEVOTION',
  ['AVERT'] = 'Avert Harm - AVERT',
  ['SPIRLINK'] = 'Spirit Link Totem - SPIRLINK',
  ['BARRIER'] = 'Power Word: Barrier - BARRIER',
  ['ANTIMAGIC'] = 'Anti-Magic Zone - ANTIMAGIC'
}
RaidStatusText.miscStatusTextConfigList = {
  ['SHAMRAGE'] = 'Shamanistic Rage - SHAMRAGE',
  ['FEINT'] = 'Feint - FEINT',
  ['ROAR'] = 'Roar of Sacrifice - ROAR'
}

-- MoP Defensive Spell Database
local defensiveSpells = {
  -- IMMUNITY ABILITIES (Priority 1-5) - Complete damage immunity or near-immunity
  [642] = { name = 'DIVSHIELD', duration = 8, priority = 1 },                         -- Divine Shield (MoP: 8 seconds)
  [45438] = { name = 'ICEBLOCK', duration = 10, priority = 2 },                      -- Ice Block (MoP: 10 seconds)
  [19263] = { name = 'DETERENCE', duration = 5, priority = 3 },                      -- Deterrence (MoP: 5 seconds)
  [131523] = { name = 'ZENMED', duration = 8, priority = 4 },                        -- Zen Meditation (MoP: 8 seconds, damage immunity from spells)
  [47585] = { name = 'DISPERS', duration = 6, priority = 5 },                        -- Dispersion (MoP: 6 seconds)
  
  -- SHIELD WALL ABILITIES (Priority 6-10) - 40%+ damage reduction
  [871] = { name = 'SHLDWALL', duration = 12, priority = 6 },                        -- Shield Wall (MoP: 12 seconds)
  [61336] = { name = 'SURVIVAL', duration = 6, priority = 7 },                       -- Survival Instincts (MoP: 6 seconds)
  [108416] = { name = 'RESOLVE', duration = 8, priority = 8 },                       -- Unending Resolve (MoP: 8 seconds)
  [33206] = { name = 'PAINSUP', duration = 8, priority = 9 },                        -- Pain Suppression (MoP: 8 seconds)
  [108271] = { name = 'ASTRAL', duration = 8, priority = 10 },                       -- Astral Shift (MoP: 8 seconds)
  
  -- LAST STAND ABILITIES (Priority 11-20) - 30%+ damage reduction + healing buffs
  [12975] = { name = 'LASTSTAND', duration = 20, priority = 11 },                    -- Last Stand (MoP: 20 seconds)
  [55233] = { name = 'VAMPIRIC', duration = 10, priority = 12 },                     -- Vampiric Blood (MoP: 10 seconds)
  [31850] = { name = 'ARDENT', duration = 8, priority = 13 },                        -- Ardent Defender (MoP: 8 seconds)
  [47788] = { name = 'GUARDIAN', duration = 10, priority = 14 },                     -- Guardian Spirit (MoP: 10 seconds)
  [115203] = { name = 'FORTIFY', duration = 20, priority = 15 },                     -- Fortifying Brew (MoP: 20 seconds)
  [120954] = { name = 'FORTIFY', duration = 20, priority = 15 },                     -- Fortifying Brew (Tank version, MoP: 20 seconds)
  [106922] = { name = 'URSOC', duration = 20, priority = 16 },                       -- Might of Ursoc (MoP: 20 seconds)
  
  -- RAID DEFENSIVE ABILITIES (Priority 16-20) - Raid-wide damage reduction
  [105809] = { name = 'DEVOTION', duration = 6, priority = 16 },                     -- Devotion Aura (MoP: 6 seconds, raid-wide)
  [114030] = { name = 'VIGILANCE', duration = 30, priority = 17 },                   -- Vigilance (MoP: 30 seconds, damage transfer)
  [115213] = { name = 'AVERT', duration = 8, priority = 18 },                        -- Avert Harm (MoP: 8 seconds, raid-wide)
  [98008] = { name = 'SPIRLINK', duration = 6, priority = 19 },                      -- Spirit Link Totem (MoP: 6 seconds)
  [62618] = { name = 'BARRIER', duration = 10, priority = 20 },                      -- Power Word: Barrier (MoP: 10 seconds)
  
  -- DEFENSIVE ABILITIES (Priority 21-25) - 20-30% damage reduction
  [22812] = { name = 'BARKSKIN', duration = 12, priority = 21 },                     -- Barkskin (MoP: 12 seconds)
  [102342] = { name = 'IRONBARK', duration = 12, priority = 22 },                    -- Ironbark (MoP: 12 seconds)
  [48792] = { name = 'ICEBOUND', duration = 8, priority = 23 },                      -- Icebound Fortitude (MoP: 8 seconds)
  [122278] = { name = 'DAMPEN', duration = 10, priority = 24 },                      -- Dampen Harm (MoP: 10 seconds)
  [498] = { name = 'DIVPROT', duration = 10, priority = 25 },                        -- Divine Protection (MoP: 10 seconds)
  
  -- SPELL WALL ABILITIES (Priority 26-30) - Magic damage reduction/reflection
  [31224] = { name = 'CLOAK', duration = 5, priority = 26 },                         -- Cloak of Shadows (MoP: 5 seconds)
  [23920] = { name = 'SPELLREFL', duration = 5, priority = 27 },                     -- Spell Reflection (MoP: 5 seconds)
  [122783] = { name = 'DIFFUSE', duration = 6, priority = 28 },                      -- Diffuse Magic (MoP: 6 seconds)
  [115080] = { name = 'DIFFUSE', duration = 6, priority = 28 },                      -- Diffuse Magic (Alternative ID for MoP)
  [48707] = { name = 'ANTISHELL', duration = 5, priority = 29 },                     -- Anti-Magic Shell (MoP: 5 seconds)
  [110909] = { name = 'HANDPROT', duration = 10, priority = 30 },                    -- Hand of Protection (MoP: 10 seconds)
  
  -- MISCELLANEOUS ABILITIES (Priority 31-35) - Various defensive effects
  [30823] = { name = 'SHAMRAGE', duration = 30, priority = 31 },                     -- Shamanistic Rage (MoP: 30 seconds)
  [1966] = { name = 'FEINT', duration = 6, priority = 32 },                          -- Feint (MoP: 6 seconds)
  [53480] = { name = 'ROAR', duration = 12, priority = 33 },                         -- Roar of Sacrifice (MoP: 12 seconds)
  [118038] = { name = 'DIEBYSWD', duration = 8, priority = 34 },                     -- Die by the Sword (MoP: 8 seconds)
  [51271] = { name = 'DARKBARGN', duration = 8, priority = 35 },                     -- Dark Bargain (MoP: 8 seconds)
  [5277] = { name = 'EVASION', duration = 15, priority = 36 },                       -- Evasion (MoP: 15 seconds)
  [51755] = { name = 'ANTIMAGIC', duration = 10, priority = 37 }                     -- Anti-Magic Zone (MoP: 10 seconds)
}

-- Default configuration
local RSTdefault = { 
  global = { 
    defensiveIndicator = true, 
    statusTextFontSize = 10,
    useSimpleStatusText = false,
    enabledStatusTexts = { 
      ['DIVSHIELD'] = true, ['ICEBLOCK'] = true, ['DETERENCE'] = true, ['ZENMED'] = true, ['DISPERS'] = true,
      ['SHLDWALL'] = true, ['SURVIVAL'] = true, ['RESOLVE'] = true, ['PAINSUP'] = true, ['ASTRAL'] = true,
      ['LASTSTAND'] = true, ['VAMPIRIC'] = true, ['ARDENT'] = true, ['GUARDIAN'] = true, ['FORTIFY'] = true, ['URSOC'] = true,
      ['DEVOTION'] = true, ['VIGILANCE'] = true, ['AVERT'] = true, ['SPIRLINK'] = true, ['BARRIER'] = true,
      ['BARKSKIN'] = true, ['IRONBARK'] = true, ['ICEBOUND'] = true, ['DAMPEN'] = true, ['DIVPROT'] = true,
      ['CLOAK'] = true, ['SPELLREFL'] = true, ['DIFFUSE'] = true, ['ANTISHELL'] = true, ['HANDPROT'] = true,
      ['SHAMRAGE'] = true, ['FEINT'] = true, ['ROAR'] = true, ['DIEBYSWD'] = true, ['DARKBARGN'] = true, ['EVASION'] = true, ['ANTIMAGIC'] = true
    } 
  } 
}

-- Function to get frame info
function RaidStatusText:GetFrameInfo(unitFrame)
  local displayedUnit, healthBar
  if not unitFrame then return end
  if unitFrame.displayedUnit ~= nil then
    displayedUnit = unitFrame.displayedUnit
  else
    displayedUnit = unitFrame.unit
  end
  if unitFrame.healthBar ~= nil then
    healthBar = unitFrame.healthBar
  else
    healthBar = unitFrame.healthbar
  end
  return displayedUnit, healthBar
end

-- UpdateAuras function
function RaidStatusText:UpdateAuras(unitFrame)
  local index = 1
  local statusUpdate = false
  local unitId = RaidStatusText:GetFrameInfo(unitFrame)
  if not unitId then return end
  local targetGUID = UnitGUID(unitId)
  if not targetGUID then return end
  if not statusGUIDs[targetGUID] then statusGUIDs[targetGUID] = {} end
  wipe(statusGUIDs[targetGUID])
  
  repeat
    local name, icon, count, debuffType, duration, expirationTime, source, isStealable, nameplateShowPersonal, spellId = UnitBuff(unitId, index)
    if spellId then
      if RSTdb.global.defensiveIndicator then
        local spell = defensiveSpells[spellId]
        if spell and RSTdb.global.enabledStatusTexts[spell.name] then
          statusGUIDs[targetGUID][spell] = true
          statusUpdate = true
        end
      end
      index = index + 1
    end
  until (not spellId)
end

-- Global hook function
function CompactUnitFrame_UpdateStatusTextRSTHook(unitFrame)
  if not unitFrame.statusText or not unitFrame.optionTable.displayStatusText or not UnitIsConnected(unitFrame.displayedUnit) or UnitIsDeadOrGhost(unitFrame.displayedUnit) then
    return
  end
  
  if RSTdb.global.defensiveIndicator then
    local guid = UnitGUID(unitFrame.displayedUnit)
    local statusEffects = statusGUIDs[guid] or {}
    local priorityEffect = {}
    for effect, _ in pairs(statusEffects) do
      if not priorityEffect.priority or (priorityEffect.priority > effect.priority) then
        priorityEffect.name = effect.name
        priorityEffect.priority = effect.priority
      end
    end
    if priorityEffect.name then
      -- Use configurable font size for status text visibility on raid frames
      local font, size, flags = unitFrame.statusText:GetFont()
      local targetSize = RSTdb.global.statusTextFontSize or 10
      if font then
        unitFrame.statusText:SetFont(font, targetSize, flags)
      end
      
      -- Use simple status text if option is enabled
      local displayText = priorityEffect.name
      if RSTdb.global.useSimpleStatusText then
        displayText = RaidStatusText:GetSimpleStatusText(priorityEffect.name)
      end
      
      unitFrame.statusText:SetFormattedText("%s", displayText)
      unitFrame.statusText:Show()
      return
    else
      -- Clear status text when no defensive buffs are active
      unitFrame.statusText:SetText("")
      unitFrame.statusText:Hide()
    end
  end
end

-- Function to get simple status text
function RaidStatusText:GetSimpleStatusText(spellName)
  -- Only simplify text for these 4 categories: Last Stand, Shield Wall, Defensive, and Spell Wall
  if RaidStatusText.lastStandStatusTextConfigList[spellName] then
    return "LASTSTAND"
  elseif RaidStatusText.shieldWallStatusTextConfigList[spellName] then
    return "SHLDWALL"
  elseif RaidStatusText.defensiveStatusTextConfigList[spellName] then
    return "DEFENSIVE"
  elseif RaidStatusText.spellWallStatusTextConfigList[spellName] then
    return "SPELLWALL"
  else
    -- For immunity, raid defensives, and misc - always use original spell name
    return spellName
  end
end

function RaidStatusText:OnInitialize()
  RSTdb = LibStub("AceDB-3.0"):New("RaidStatusTextDB", RSTdefault, true)
  self.RSTdb = RSTdb
  
  -- Register slash commands  
  AceConsole:RegisterChatCommand('rst', function (args)
    RaidStatusText:ChatCommand(args)
  end)
end

function RaidStatusText:OnEnable()
  -- Initialize configuration (loaded from separate file)
  if self.CreateConfigs then
    self:CreateConfigs()
    AceConfigDialog:AddToBlizOptions('RSTOptions', 'RaidStatusText')
  end
  
  -- Hook status text function
  hooksecurefunc("CompactUnitFrame_UpdateStatusText", CompactUnitFrame_UpdateStatusTextRSTHook)
  
  -- Register for UNIT_AURA events to update when buffs change
  self:RegisterEvent("UNIT_AURA")
end

-- UNIT_AURA event handler that calls UpdateAuras
function RaidStatusText:UNIT_AURA(event, unitId)
  -- Update auras for the specific unit
  local unitFrame = _G["CompactRaidFrame1"]
  local num = 1
  while unitFrame do
    if unitFrame.displayedUnit == unitId then
      self:UpdateAuras(unitFrame)
      CompactUnitFrame_UpdateStatusText(unitFrame)
    end
    num = num + 1
    unitFrame = _G["CompactRaidFrame" .. num]
  end
  
  -- Check party frames
  for i = 1, 4 do
    local frame = _G["CompactPartyFrameMember" .. i]
    if frame and frame.displayedUnit == unitId then
      self:UpdateAuras(frame)
      CompactUnitFrame_UpdateStatusText(frame)
    end
  end
  
  -- Check raid group frames
  for i = 1, 8 do
    local grpHeader = "CompactRaidGroup" .. i
    if _G[grpHeader] then
      for k = 1, 5 do
        unitFrame = _G[grpHeader .. "Member" .. k]
        if unitFrame and unitFrame.displayedUnit == unitId then
          self:UpdateAuras(unitFrame)
          CompactUnitFrame_UpdateStatusText(unitFrame)
        end
      end
    end
  end
end

function RaidStatusText:ChatCommand(args)
  if args ~= nil then arg = AceConsole:GetArgs(args, 1) end
  if arg == nil then
    AceConfigDialog:Open('RSTOptions')
  elseif arg == 'version' or arg == 'v' then
    AceConsole:Print('|cFF00FF00RaidStatusText|r Version ' .. ADDON_VERSION)
    AceConsole:Print('Game Version: ' .. GAME_VERSION)
    AceConsole:Print('Detected Version: ' .. (isCompatible and 'Mists of Pandaria Classic' or 'Other'))
  end
end
