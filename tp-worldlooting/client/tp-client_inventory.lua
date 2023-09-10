local isInInventory    = false
local poid		       = 0

local currentBagCoords = nil

local inventory, money, weapons

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		SetNuiFocus(false,false)
    end
end)

AddEventHandler('esx:onPlayerDeath', function(data)

	if guiEnabled then
		EnableGui(false, uiType)
	end
end)

function EnableGui(state, ui)
	SetNuiFocus(state, state)
	guiEnabled = state

	SendNUIMessage({
		type = ui,
		enable = state
	})

    if state == false then
        currentBagCoords = nil

    end

end

function isGuiEnabled()
	return guiEnabled
end

RegisterNUICallback('closeNUI', function()
	EnableGui(false, uiType)
end)

function closeBagUI()
    if isInInventory then
        EnableGui(false, uiType)
    end
end


function closeBagUIOnRemoval(entityCoords)

    if isInInventory and entityCoords == currentBagCoords then
        EnableGui(false, uiType)
    end
end

RegisterNetEvent('tp-worldlooting:openBasedUI')
AddEventHandler('tp-worldlooting:openBasedUI', function(_data, coords)

	if not isDead then

        currentBagCoords = coords
        
        uiType = "enable_loading"

        EnableGui(true, uiType)
    
        loadPlayerInventory()
        loadOtherInventory(_data)

        DisableControlAction(0, 57)
    
        isInInventory = true
    
        Wait(250)
        
        SendNUIMessage(
            {
                action = "addOtherInventoryInformation",
            }
        )

        uiType = "enable_inventory_otherInventory"
        
        EnableGui(true, uiType)
			 
	end
end)


RegisterNUICallback("nodrag",function(data, cb)  
    SendNUIMessage({action = "nodrag"})
end)

function loadPlayerInventory(targetSource)

    local isOtherSource = false

    if targetSource == nil then
        targetSource = GetPlayerServerId(PlayerId())
    else
        isOtherSource = true
    end

    ESX.TriggerServerCallback("tp-worldlooting:getPlayerInventory",function(data)
            items = {}
            inventory = data.inventory
            money = data.money
            black_money = data.black_money
            weapons = data.weapons
            DisableControlAction(0, 57)
            
            if money ~= nil and money > 0 then
                moneyData = {
                    label = "Cash",
                    name = "cash",
                    type = "item_money",
                    count = money,
                    usable = false,
                    rare = false,
                    limit = -1,
                    canRemove = true
                }

                table.insert(items, moneyData)
            end

            if black_money > 0 then
                blackMoneyData = {
                    label = "Black Money",
                    name = "black_money",
                    type = "item_black_money",
                    count = black_money,
                    usable = false,
                    rare = false,
                    limit = -1,
                    canRemove = true
                }

                table.insert(items, blackMoneyData)
            end


            if inventory ~= nil then
                for key, value in pairs(inventory) do
                    if inventory[key].count <= 0 then
                        inventory[key] = nil
                    else
                        inventory[key].type = "item_standard"
                        table.insert(items, inventory[key])
                    end
                end
            end

            if weapons ~= nil then
                for key, value in pairs(weapons) do
                    local weaponHash = GetHashKey(weapons[key].name)
                    local playerPed = PlayerPedId()
                    -- if HasPedGotWeapon(playerPed, weaponHash, false) and weapons[key].name ~= "WEAPON_UNARMED" then
                    if weapons[key].name ~= "WEAPON_UNARMED" then
                        local ammo = GetAmmoInPedWeapon(playerPed, weaponHash)

                        local weaponLabel = weapons[key].label

                        if Config.WeaponLabelNames[weapons[key].name] then
                            weaponLabel = Config.WeaponLabelNames[weapons[key].name]
                        end

                        table.insert(
                            items,
                            {
                                label = weaponLabel,
                                count = ammo,
                                limit = -1,
                                type = "item_weapon",
                                name = weapons[key].name,
                                usable = false,
                                rare = false,
                                canRemove = true
                            }
                        )
                    end
                end
            end

            SendNUIMessage(
                {
                    action = "setItems",
                    itemList = items,
                    isTarget = isOtherSource
                }
            )
        end,
        targetSource
    )
end

function loadOtherInventory(_data)

    local data = _data

    items = {}
    inventory = data.inventory

    weapons = data.weapons
    DisableControlAction(0, 57)

    if inventory ~= nil then
        for key, value in pairs(inventory) do


            if value.count > 0 then

                inventory[key].type = "item_standard"
                table.insert(items, inventory[key])

            end
        end
    end

    if weapons ~= nil then
        for key, value in pairs(weapons) do

            if weapons[key].count > 0 then

                if  weapons[key].label ~= "NOT_AVAILABLE" then

                    local weaponHash = GetHashKey(weapons[key].name)
                    local playerPed = PlayerPedId()
    
                    local weaponLabel = weapons[key].label
    
                    if Config.WeaponLabelNames[weapons[key].name] then
                        weaponLabel = Config.WeaponLabelNames[weapons[key].name]
                    end
    
                    table.insert(
                        items,
                        {
                            label = weaponLabel,
                            count = 0,
                            limit = -1,
                            type = "item_weapon",
                            name = weapons[key].name,
                            usable = false,
                            rare = false,
                            canRemove = true
                        }
                    )
                end
            end
        end
    end

    SendNUIMessage(
        {
            action = "setOtherInventoryItems",
            itemList = items
        }
    )

end

RegisterNUICallback(
    "TakeFromOtherInventory",
    function(data, cb)
        if IsPedSittingInAnyVehicle(playerPed) then
            return
        end

        if type(data.number) == "number" and math.floor(data.number) == data.number then
            local count = tonumber(data.number)

            if data.item.type == "item_weapon" then
                count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
            end

            TriggerServerEvent("tp-worldlooting:tradePlayerItem", currentBagCoords, data.item.type, data.item.name, count, data.item.count)
        end
    
        Wait(250)
        ESX.TriggerServerCallback("tp-worldlooting:getOtherInventory",function(bag_data)

            loadPlayerInventory()
            loadOtherInventory(bag_data)
    
            cb("ok")
    
        end, currentBagCoords)
    end
)


CreateThread(function()
    while isInInventory do
        local playerPed = PlayerPedId()
        
        if IsEntityDead(playerPed) then
            closeBagUI()
        end
        DisableControlAction(0, 1, true) -- Disable pan
        DisableControlAction(0, 2, true) -- Disable tilt
        DisableControlAction(0, 24, true) -- Attack
        DisableControlAction(0, 257, true) -- Attack 2
        DisableControlAction(0, 25, true) -- Aim
        DisableControlAction(0, 263, true) -- Melee Attack 1
        DisableControlAction(0, Keys["W"], true) -- W
        DisableControlAction(0, Keys["A"], true) -- A
        DisableControlAction(0, 31, true) -- S (fault in Keys table!)
        DisableControlAction(0, 30, true) -- D (fault in Keys table!)

        DisableControlAction(0, Keys["R"], true) -- Reload
        DisableControlAction(0, Keys["SPACE"], true) -- Jump
        DisableControlAction(0, Keys["Q"], true) -- Cover
        DisableControlAction(0, Keys["TAB"], true) -- Select Weapon
        DisableControlAction(0, Keys["F"], true) -- Also 'enter'?

        DisableControlAction(0, Keys["F1"], true) -- Disable phone
        DisableControlAction(0, Keys["F2"], true) -- Inventory
        DisableControlAction(0, Keys["F3"], true) -- Animations
        DisableControlAction(0, Keys["F6"], true) -- Job

        DisableControlAction(0, Keys["V"], true) -- Disable changing view
        DisableControlAction(0, Keys["C"], true) -- Disable looking behind
        DisableControlAction(0, Keys["X"], true) -- Disable clearing animation
        DisableControlAction(2, Keys["P"], true) -- Disable pause screen
       
        DisableControlAction(0, 59, true) -- Disable steering in vehicle
        DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
        DisableControlAction(0, 72, true) -- Disable reversing in vehicle

        DisableControlAction(2, Keys["LEFTCTRL"], true) -- Disable going stealth

        DisableControlAction(0, 47, true) -- Disable weapon
        DisableControlAction(0, 264, true) -- Disable melee
        DisableControlAction(0, 257, true) -- Disable melee
        DisableControlAction(0, 140, true) -- Disable melee
        DisableControlAction(0, 141, true) -- Disable melee
        DisableControlAction(0, 142, true) -- Disable melee
        DisableControlAction(0, 143, true) -- Disable melee
        DisableControlAction(0, 75, true) -- Disable exit vehicle
        DisableControlAction(27, 75, true) -- Disable exit vehicle
        Wait(0)
    end
end)  
