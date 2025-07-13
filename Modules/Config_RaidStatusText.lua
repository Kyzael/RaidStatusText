--[[
	Function: CreateConfigs
	Purpose: Create and attach options page for RaidStatusText
]]--
function RaidStatusText:CreateConfigs()

	RSTdb = RaidStatusText.RSTdb
	local options = {
		name = 'RaidStatusText',
		type = 'group',
		childGroups = 'tab',
		args = {
			desc2 = {
				order = 10,
				type = 'description',
				width = 'full',
				name = 'Raid Status Text for MoP Classic\nShows defensive cooldowns and buffs on raid frames.\n'
			},
			button0 = {
				order = 20,
				type = 'execute',
				name = 'Reset addon to defaults',
				confirm = true,
				func = function() RSTdb:ResetDB() end
			}
		},
	}
	
	-- Basic Settings Tab
	options.args['basicSettings'] = {
		name = 'Basic Settings',
		type = 'group',
		order = 10,
		args = {
			header0 = {
				order = 10,
				type = 'header',
				name = 'General Settings',
			},
			useSimple = {
				order = 20,
				type = 'toggle',
				name = 'Use Simple Status Text',
				desc = 'Use simplified status text display, familiar standard names for categorized abilities like Last Stand, Shield Wall, etc.',
				get = function() return RSTdb.global.useSimpleStatusText end,
				set = function(_, value) RSTdb.global.useSimpleStatusText = value end,
			},
			fontSize = {
				order = 30,
				type = 'range',
				name = 'Status Text Font Size',
				desc = 'Set the font size for status text',
				min = 6,
				max = 20,
				step = 1,
				get = function() return RSTdb.global.statusTextFontSize end,
				set = function(_, value) RSTdb.global.statusTextFontSize = value end,
			}
		}
	}
	
	-- Status Text Configuration Tab
	options.args['statusTexts'] = {
		name = 'Status Texts',
		type = 'group',
		order = 20,
		args = {
			header1 = {
				order = 10,
				type = 'header',
				name = 'Enable/Disable Status Text Types',
			},
			desc1 = {
				order = 15,
				type = 'description',
				width = 'full',
				name = 'Configure which defensive abilities should display status text on raid frames.\n'
			}
		}
	}
	
	-- Add status text toggles
	local order = 20
	
	-- Last Stand type abilities (Priority 11-15)
	options.args['statusTexts'].args['lastStandHeader'] = {
		order = order,
		type = 'header',
		name = 'Last Stand Abilities (Health & Survival Cooldowns)',
	}
	order = order + 10
	
	for key, desc in pairs(RaidStatusText.lastStandStatusTextConfigList) do
		options.args['statusTexts'].args[key] = {
			order = order,
			type = 'toggle',
			name = desc,
			width = 'full',
			get = function() return RSTdb.global.enabledStatusTexts[key] end,
			set = function(_, value) RSTdb.global.enabledStatusTexts[key] = value end,
		}
		order = order + 1
	end
	
	-- Shield Wall type abilities (Priority 6-10)
	order = order + 10
	options.args['statusTexts'].args['shieldHeader'] = {
		order = order,
		type = 'header',
		name = 'Shield Wall Abilities (40%+ Damage Reduction)',
	}
	order = order + 10
	
	for key, desc in pairs(RaidStatusText.shieldWallStatusTextConfigList) do
		options.args['statusTexts'].args[key] = {
			order = order,
			type = 'toggle',
			name = desc,
			width = 'full',
			get = function() return RSTdb.global.enabledStatusTexts[key] end,
			set = function(_, value) RSTdb.global.enabledStatusTexts[key] = value end,
		}
		order = order + 1
	end
	
	-- Defensive abilities (Priority 21-25)
	order = order + 10
	options.args['statusTexts'].args['defensiveHeader'] = {
		order = order,
		type = 'header',
		name = 'Defensive Abilities (20-30% Damage Reduction)',
	}
	order = order + 10
	
	for key, desc in pairs(RaidStatusText.defensiveStatusTextConfigList) do
		options.args['statusTexts'].args[key] = {
			order = order,
			type = 'toggle',
			name = desc,
			width = 'full',
			get = function() return RSTdb.global.enabledStatusTexts[key] end,
			set = function(_, value) RSTdb.global.enabledStatusTexts[key] = value end,
		}
		order = order + 1
	end
	
	-- Spell immunity abilities (Priority 26-30)
	order = order + 10
	options.args['statusTexts'].args['spellHeader'] = {
		order = order,
		type = 'header',
		name = 'Spell Wall Abilities (Magic Damage Reduction/Reflection)',
	}
	order = order + 10
	
	for key, desc in pairs(RaidStatusText.spellWallStatusTextConfigList) do
		options.args['statusTexts'].args[key] = {
			order = order,
			type = 'toggle',
			name = desc,
			width = 'full',
			get = function() return RSTdb.global.enabledStatusTexts[key] end,
			set = function(_, value) RSTdb.global.enabledStatusTexts[key] = value end,
		}
		order = order + 1
	end
	
	-- Immunity abilities (Priority 1-5)
	order = order + 10
	options.args['statusTexts'].args['immunityHeader'] = {
		order = order,
		type = 'header',
		name = 'Immunity Abilities (Complete/Near-Complete Immunity)',
	}
	order = order + 10
	
	for key, desc in pairs(RaidStatusText.immunityStatusTextConfigList) do
		options.args['statusTexts'].args[key] = {
			order = order,
			type = 'toggle',
			name = desc,
			width = 'full',
			get = function() return RSTdb.global.enabledStatusTexts[key] end,
			set = function(_, value) RSTdb.global.enabledStatusTexts[key] = value end,
		}
		order = order + 1
	end
	
	-- Raid defensive abilities (Priority 16-20)
	order = order + 10
	options.args['statusTexts'].args['raidHeader'] = {
		order = order,
		type = 'header',
		name = 'Raid Cooldowns (Group-Wide Protection)',
	}
	order = order + 10
	
	for key, desc in pairs(RaidStatusText.raidDefensiveStatusTextConfigList) do
		options.args['statusTexts'].args[key] = {
			order = order,
			type = 'toggle',
			name = desc,
			width = 'full',
			get = function() return RSTdb.global.enabledStatusTexts[key] end,
			set = function(_, value) RSTdb.global.enabledStatusTexts[key] = value end,
		}
		order = order + 1
	end
	
	-- Miscellaneous abilities (Priority 31+)
	order = order + 10
	options.args['statusTexts'].args['miscHeader'] = {
		order = order,
		type = 'header',
		name = 'Miscellaneous Abilities (Specialized Effects)',
	}
	order = order + 10
	
	for key, desc in pairs(RaidStatusText.miscStatusTextConfigList) do
		options.args['statusTexts'].args[key] = {
			order = order,
			type = 'toggle',
			name = desc,
			width = 'full',
			get = function() return RSTdb.global.enabledStatusTexts[key] end,
			set = function(_, value) RSTdb.global.enabledStatusTexts[key] = value end,
		}
		order = order + 1
	end

	LibStub("AceConfig-3.0"):RegisterOptionsTable('RSTOptions', options)
end
