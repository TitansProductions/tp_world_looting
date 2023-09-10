local objectData            = {}

local searchTime, canSearch = 5000, true
local isDead                = false

local CurrentAction         = nil
local CurrentActionCoords   = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData, isNew) 
	ESX.PlayerLoaded = true
	ESX.PlayerData = playerData

    Wait(2000)
    ESX.TriggerServerCallback('tp-worldlooting:fetchObjectsData', function(data)
        objectData = data
    end)

end)

AddEventHandler('esx:onPlayerDeath', function(data)
    isDead = true
end)

AddEventHandler('playerSpawned', function()
    isDead = false
end)

AddEventHandler('disc-death:onPlayerRevive', function(data)
    isDead = false
end)

RegisterNetEvent("tp-worldlooting:onNewLootObjectInfo")
AddEventHandler("tp-worldlooting:onNewLootObjectInfo", function(object, entityCoords, data)

    local newCoords = round(entityCoords.x, 1) .. round(entityCoords.y, 1)
    
    objectData[newCoords] = data
     
end)

-- Zone Events (Entity Enter & Exit)
AddEventHandler('tp-worldlooting:hasEnteredEntityZone', function(entity)
    CurrentAction                            = 'search_entity'

    if Config.Debug then
        print("Entered Entity Zone")
    end
end)

AddEventHandler('tp-worldlooting:hasExitedEntityZone', function(entity)
    CurrentAction                            = nil
    CurrentActionCoords, CurrentActionCoords = nil, {}

    if Config.Debug then
        print("Left Entity Zone")
    end
end)


-- Enter / Exit entity zone events
Citizen.CreateThread(function()

	while true do
		Citizen.Wait(1000)

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		local closestDistance = -1
		local closestEntity   = nil

		for i=1, #Config.TrackedEntities, 1 do

			local object = GetClosestObjectOfType(coords, 1.5, GetHashKey(Config.TrackedEntities[i]), false, false, false)

			if DoesEntityExist(object) then
				local objCoords = GetEntityCoords(object)
				local distance  = GetDistanceBetweenCoords(coords, objCoords, true)

				if closestDistance == -1 or closestDistance > distance then
					closestDistance     = distance
					closestEntity       = object
                    CurrentActionCoords = objCoords
				end
			end
		end

		if closestDistance ~= -1 and closestDistance <= 1.5 then
			if LastEntity ~= closestEntity then
				TriggerEvent('tp-worldlooting:hasEnteredEntityZone', closestEntity)
				LastEntity = closestEntity
			end
		else
			if LastEntity then
				TriggerEvent('tp-worldlooting:hasExitedEntityZone', LastEntity)
				LastEntity = nil
			end
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction == "search_entity" and not isDead then

            local newCoords = round(CurrentActionCoords.x, 1) .. round(CurrentActionCoords.y, 1)

            DrawText3Ds(CurrentActionCoords.x,CurrentActionCoords.y,CurrentActionCoords.z + 0.5, _U("search_loot"))

            if IsControlJustReleased(0, 38)  then
    
                RequestAnimDict('random@domestic')
                while not HasAnimDictLoaded('random@domestic') do
                    Wait(100)
                    RequestAnimDict('random@domestic')
                end

                TaskPlayAnim(PlayerPedId(), "random@domestic", "pickup_low", 8.0, -8, 1500, 2, 0, 0, 0, 0)

                Wait(1500)

                if objectData[newCoords] then

                    ESX.TriggerServerCallback("tp-worldlooting:getOtherInventory",function(data)
                        TriggerEvent('tp-worldlooting:openBasedUI', data, newCoords)
                    end, newCoords)
                end
            end

		else
            Citizen.Wait(1000)
        end
	end
end)


function round(number, decimals)
    local power = 10^decimals
    return math.floor(number * power) / power
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.005+ factor, 0.03, 0, 0, 0, 100)
end

