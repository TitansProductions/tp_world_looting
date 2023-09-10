local objectData             = {}

local isSpawningStartedStock = true

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end

	Wait(2000)

	local spawnedObjects = 0

	local keysetItems, keysetWeapons = {}, {}

	for k in pairs(Config.Items) do
		table.insert(keysetItems, k)
	end

	if Config.Debug then
		print("----------------------------------------------------------")
		print("|Count| |X Coords| |Y Coords| |Z Coords| |Chance|")
		print("----------------------------------------------------------")
	end

	for i, v in pairs(Config.LootObjects) do

		for id = 1, #Config.LootObjects[i].locations do

			local lc = Config.LootObjects[i].locations[id]

			if lc.spawnChance >= 50 then

				local lootItemsInventory, lootWeaponsInventory   = {}, {}
				local randomItems                                = keysetItems[math.random(#keysetItems)] 
	
				for i, v in pairs(Config.Items[randomItems]) do
					
					table.insert(lootItemsInventory,{
						name  = v.name,
						label = v.label,
						count = v.count
					})
				end
	
				if Config.Weapons[randomItems] then
					for i, v in pairs(Config.Weapons[randomItems]) do
			
						table.insert(lootWeaponsInventory,{
							name  = v.name,
							label = v.label,
							count = v.count
						})
					end
				end
	
				Wait(1000)
		
				spawnedObjects = spawnedObjects + 1

				local newCoords = vector3(lc.x, lc.y, lc.z)
		
				local object = CreateObjectNoOffset(GetHashKey(lc.entity), newCoords.x, newCoords.y, newCoords.z, true, false)
				FreezeEntityPosition(object, true)

				if Config.Debug then
					print("("..spawnedObjects ..")", lc.x,  lc.y , lc.z, lc.spawnChance .. "%")
				end
		
				local data = {entityName = lc.entity, entity = object, inventory = lootItemsInventory, weapons = lootWeaponsInventory}
		
				objectData[round(newCoords.x, 1) .. round(newCoords.y, 1)] = data
		
				TriggerClientEvent('tp-worldlooting:onNewLootObjectInfo', -1, object, newCoords, data)
	
			end
		end
	end
  
	Citizen.Wait(5000)
	print("Currently spawned: " .. spawnedObjects .. " Loot Objects in all the selected locations.")
	isSpawningStartedStock = false

end)

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end

	for k, v in pairs(objectData) do
		if v then
			DeleteEntity(v.entity)
			objectData[k] = nil
		end
		
    end

end)

-- Restocking Update Timer.
Citizen.CreateThread(function()
    while true do
        Wait(60000 * Config.RestockLootTimeInMinutes)

		if not isSpawningStartedStock then

			for k, v in pairs(objectData) do
				if v then
					DeleteEntity(v.entity)
					objectData[k] = nil
				end
			end

			objectEntityNames, objectEntityNames = nil, {}

			Wait(1000)
	
			local spawnedObjects = 0

			local keysetItems, keysetWeapons = {}, {}

			for k in pairs(Config.Items) do
				table.insert(keysetItems, k)
			end

			if Config.Debug then
				print("----------------------------------------------------------")
				print("|Count| |X Coords| |Y Coords| |Z Coords| |Chance|")
				print("----------------------------------------------------------")
			end
		
			for i, v in pairs(Config.LootObjects) do

				for id = 1, #Config.LootObjects[i].locations do
		
					local lc = Config.LootObjects[i].locations[id]

					if lc.spawnChance >= 50 then

						local lootItemsInventory, lootWeaponsInventory   = {}, {}
						local randomItems                                = keysetItems[math.random(#keysetItems)] 
			
						for i, v in pairs(Config.Items[randomItems]) do
							
							table.insert(lootItemsInventory,{
								name  = v.name,
								label = v.label,
								count = v.count
							})
						end
			
						if Config.Weapons[randomItems] then
							for i, v in pairs(Config.Weapons[randomItems]) do
					
								table.insert(lootWeaponsInventory,{
									name  = v.name,
									label = v.label,
									count = v.count
								})
							end
						end
	
			
						Wait(1000)
			
						spawnedObjects = spawnedObjects + 1

						local newCoords = vector3(lc.x, lc.y, lc.z)
				
						local object = CreateObjectNoOffset(GetHashKey(lc.entity), newCoords.x, newCoords.y, newCoords.z, true, false)
						FreezeEntityPosition(object, true)

						if Config.Debug then
							print("("..spawnedObjects ..")", lc.x,  lc.y , lc.z, lc.spawnChance .. "%")
						end

						local data = {entityName = lc.entity, entity = object, inventory = lootItemsInventory, weapons = lootWeaponsInventory}
				
						objectData[round(newCoords.x, 1) .. round(newCoords.y, 1)] = data
				
						TriggerClientEvent('tp-worldlooting:onNewLootObjectInfo', -1, object, newCoords, data)
				
			
					end
				end
			end
		  
			Citizen.Wait(5000)
			print("Currently restocked: " .. spawnedObjects .. " Loot Objects in all the available locations.")
		end
	end
end)

RegisterServerEvent("tp-worldlooting:tradePlayerItem")
AddEventHandler("tp-worldlooting:tradePlayerItem", function(coords, type, itemName, itemCount, clickedItemCount)
	local _source = source

	local targetXPlayer = ESX.GetPlayerFromId(_source)

	if type == "item_standard" then

		local targetItem = targetXPlayer.getInventoryItem(itemName)

		if itemCount > 0 and clickedItemCount >= itemCount then

			targetXPlayer.addInventoryItem(itemName, itemCount)

			local inventory = objectData[coords].inventory

			for key, value in pairs(inventory) do
				if value.name == itemName then
					value.count = value.count - itemCount
				end
			end

		else
			TriggerClientEvent('esx:showNotification', _source, "~r~You cannot get more than the available amount.")
		end

	elseif type == "item_money" then
		if itemCount > 0 and clickedItemCount >= itemCount then

			targetXPlayer.addMoney(itemCount)

			objectData[coords].money = objectData[coords].money - itemCount
		else
			TriggerClientEvent('esx:showNotification', _source, "~r~You cannot get more than the available amount.")

		end
	elseif type == "item_black_money" then
		if itemCount > 0 and clickedItemCount >= itemCount then

			targetXPlayer.addAccountMoney("black_money", itemCount)

			objectData[coords].black_money = objectData[coords].black_money - itemCount
		else
			TriggerClientEvent('esx:showNotification', _source, "~r~You cannot get more than the available amount.")
		end
	elseif type == "item_weapon" then
		if not targetXPlayer.hasWeapon(itemName) then

			targetXPlayer.addWeapon(itemName, itemCount)

			local inventory = objectData[coords].weapons

			for key, value in pairs(inventory) do
				if value.name == itemName then
					value.label = "NOT_AVAILABLE"
				end
			end
		else
			TriggerClientEvent('esx:showNotification', _source, "~r~You already carrying this weapon.")
		end
	end
end)

ESX.RegisterServerCallback("tp-worldlooting:getOtherInventory", function(source, cb, coords)

	if objectData[coords] and objectData[coords].entity ~= nil then
		cb(objectData[coords])
	else

		local data = {entityName = nil, entity = 0, inventory = nil, money = 0, black_money = 0, weapons = nil}
		cb(data)
	end

end)

ESX.RegisterServerCallback("tp-worldlooting:fetchObjectsData", function(source, cb)
	cb(objectData)
end)

function round(number, decimals)
    local power = 10^decimals
    return math.floor(number * power) / power
end
