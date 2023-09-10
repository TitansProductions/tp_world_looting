Config = {}

Config.Locale = 'en'

-- Printing spawn locations, entering & exiting entity zones.
Config.Debug  = true

-- Restock Loot Bags Timer, Default is every 30 minutes.
-- If you dont want to restock any items and only be restored after your server restart, you can set RestockLootTimeInMinutes to a high amount value such as 999 which is 16.65 hours.
Config.RestockLootTimeInMinutes = 30

-- ###############################################
-- LOOT INVENTORY
-- ###############################################

Config.Limit = 30000
Config.DefaultWeight = 10
Config.userSpeed = false

Config.localWeight = {
    bread = 50,
    water = 50,
}

-- You can change your custom / replacement weapon names in inventory when displayed.
Config.WeaponLabelNames = {

    ['WEAPON_ADVANCEDRIFLE']  = "AUG",
    ['WEAPON_ASSAULTRIFLE']   = "AK47",
    ['WEAPON_COMPACTRIFLE']   = "AKS-74U",
    ['WEAPON_CARBINERIFLE']   = "M4A1",
    ['WEAPON_SPECIALCARBINE'] = "SCAR",
    ['WEAPON_COMBATPDW']      = "UMP .45",
    ['WEAPON_MICROSMG']       = "UZI",
    ['WEAPON_SMG']            = "MP5",
}


-- math.random(min, max) - This is used in order to not place all the items in a bag.
-- If math.random contains "0" as first element and system creates random numbers between 0 - max and the random number is 0,
-- this item will not be placed.

-- Make sure to change all the item names before opening a bag, items will not be placed if your server does not contain them.
Config.Items = {

	['1'] = {
		[1]  = { name = "water",                label = "Water Bottle",       count = math.random(0,2)},
		[2]  = { name = "cigarette_pack",       label = "Cigarette Pack",     count = math.random(0,2)},
		[3]  = { name = "tuna_can",             label = "Tuna Can",           count = math.random(0,2)},
		[4]  = { name = "corn_can",             label = "Corn Can",           count = math.random(0,2)},
	},

	['2'] = {
		[1] = { name = "disc_ammo_smg",         label = "SMG Ammo",           count = math.random(0,3)},
		[2] = { name = "disc_ammo_shotgun",     label = "Shotgun Shells",     count = math.random(0,3)},
		[3] = { name = "disc_ammo_rifle",       label = "Rifle Ammo",         count = math.random(0,3)},
		[4] = { name = "disc_ammo_pistol",      label = "Pistol Ammo",        count = math.random(0,3)},
	},

	['3'] = {
		[1] = { name = "water",                 label = "Water Bottle",       count = math.random(0,2)},
		[2] = { name = "whey_protein_bar",      label = "Whey Protein Bar",   count = math.random(0,2)},
		[3] = { name = "maltesers",             label = "Maltesers",          count = math.random(0,2)},
		[4] = { name = "kitkat",                label = "Kit Kat",            count = math.random(0,2)},
		[5] = { name = "smarties",              label = "Smarties",           count = math.random(0,2)},
	},

}

-- Always make sure the Config.Weapons package will have the same name as Config.Items package if you want to include weapons.
Config.Weapons = {

	['2'] = {
		[1]  = {name = "WEAPON_MACHINEPISTOL", label = "Machine Pistol (Tec9)", count = math.random(0,1)},
		[2]  = {name = "WEAPON_BAT",           label = "Bat",                   count = math.random(0,1)},
	},

}

-- ###############################################
-- LOOT SPAWN LOCATIONS
-- ###############################################

-- Add entities which will be used in Config.LootObjects as entity element, if not, the entity will not be targeted by the player.
Config.TrackedEntities  = {
	'p_ld_heist_bag_s_1',
	'prop_box_ammo01a',
}

Config.LootObjects = { 
	Palmer = {
		locations = {
			[1]  = { x = 2666.08, y = 1423.44, z = 24.52, entity = "p_ld_heist_bag_s_1", spawnChance = math.random(1, 99) },
			[2]  = { x = 2661.24, y = 1464.6,  z = 20.84, entity = "p_ld_heist_bag_s_1", spawnChance = math.random(1, 99) },
			[3]  = { x = 2763.92, y = 1480.24, z = 24.52, entity = "p_ld_heist_bag_s_1", spawnChance = math.random(1, 99) },
			[4]  = { x = 2715.64, y = 1541.96, z = 20.84, entity = "p_ld_heist_bag_s_1", spawnChance = math.random(1, 99) },
			[5]  = { x = 2677.0,  y = 1575.64, z = 24.68, entity = "p_ld_heist_bag_s_1", spawnChance = math.random(1, 99) },
			[6]  = { x = 2664.12, y = 1642.08, z = 24.88, entity = "p_ld_heist_bag_s_1", spawnChance = math.random(1, 99) },
			[7]  = { x = 2703.04, y = 1716.28, z = 24.6,  entity = "p_ld_heist_bag_s_1", spawnChance = math.random(1, 99) },
			[8]  = { x = 2833.2,  y = 1511.88, z = 24.72, entity = "p_ld_heist_bag_s_1", spawnChance = math.random(1, 99) },
			[9]  = { x = 2617.16, y = 1693.32, z = 31.88, entity = "p_ld_heist_bag_s_1", spawnChance = math.random(1, 99) },
			[10] = { x = 2740.48, y = 1513.24, z = 24.52, entity = "p_ld_heist_bag_s_1", spawnChance = math.random(1, 99) },
			[11] = { x = 2780.36, y = 1553.32, z = 24.52, entity = "p_ld_heist_bag_s_1", spawnChance = math.random(1, 99) },
			[12] = { x = 2829.2,  y = 1717.04, z = 24.56, entity = "p_ld_heist_bag_s_1", spawnChance = math.random(1, 99) },
			[13] = { x = 2706.56, y = 1451.08, z = 35.08, entity = "p_ld_heist_bag_s_1", spawnChance = math.random(1, 99) },
			[14] = { x = 2786.48, y = 1412.88, z = 24.44, entity = "p_ld_heist_bag_s_1", spawnChance = math.random(1, 99) },
			[15] = { x = 2805.24, y = 1447.44, z = 34.36, entity = "p_ld_heist_bag_s_1", spawnChance = math.random(1, 99) },
			[16] = { x = 2866.76, y = 1506.0,  z = 24.56, entity = "p_ld_heist_bag_s_1", spawnChance = math.random(1, 99) },
			[17] = { x = 2752.04, y = 1564.52, z = 40.32, entity = "p_ld_heist_bag_s_1", spawnChance = math.random(1, 99) },
			[18] = { x = 2729.48, y = 1577.12, z = 66.52, entity = "p_ld_heist_bag_s_1", spawnChance = math.random(1, 99) },

			[19] = { x = 60.84,   y = 3695.72, z = 39.76, entity = "p_ld_heist_bag_s_1", spawnChance = math.random(1, 99) },
			[20] = { x = 95.36,   y = 3655.44, z = 39.76, entity = "p_ld_heist_bag_s_1", spawnChance = math.random(1, 99) },
			[21] = { x = 19.24,   y = 3694.16, z = 39.68, entity = "p_ld_heist_bag_s_1", spawnChance = math.random(1, 99) },
			[22] = { x = 41.56,   y = 3747.04, z = 39.68, entity = "p_ld_heist_bag_s_1", spawnChance = math.random(1, 99) },
			[23] = { x = 29.32,   y = 3634.64, z = 39.88, entity = "p_ld_heist_bag_s_1", spawnChance = math.random(1, 99) },
			[24] = { x = 129.88,  y = 3659.28, z = 33.0,  entity = "p_ld_heist_bag_s_1", spawnChance = math.random(1, 99) },
		},
	},

}