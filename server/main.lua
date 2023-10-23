-- Do not edit anything if you have no clue!

local deleteTimer = 59 -- Time in minutes.
local checkRadius = 100.0 -- Radius within which player vehicles are not towed.

-----------------------------------------

function isVehicleOccupied(veh)
    for seat = -1, 6 do
        if GetPedInVehicleSeat(veh, seat) ~= 0 then
            return true
        end
    end
    return false
end

function isPlayerNearby(veh, radius, playerCoords)
    local vehicleCoords = GetEntityCoords(veh)
    local distanceSquared = (vehicleCoords.x - playerCoords.x)^2 + (vehicleCoords.y - playerCoords.y)^2 + (vehicleCoords.z - playerCoords.z)^2
    return distanceSquared < (radius * radius)
end

Citizen.CreateThread(function()
    while true do
        Wait(deleteTimer * 60000)
        TriggerClientEvent('chat:addMessage', -1, { color = { 117, 94, 170 }, args = {'TOWING YARD', 'Inactive vehicles will be towed in 1 MINUTE'}})
        Wait(45000) -- Time in MS
        TriggerClientEvent('chat:addMessage', -1, { color = { 117, 94, 170 }, args = {'TOWING YARD', 'Inactive vehicles will be towed in 15 SECONDS'}})
        Wait(10000) -- Time in MS
        TriggerClientEvent('chat:addMessage', -1, { color = { 117, 94, 170 }, args = {'TOWING YARD', 'Inactive vehicles will be towed in 5 SECONDS'}})
        Wait(5000) -- Time in MS

        local deletedCount = 0 

        local players = GetPlayers() 

        for i, veh in pairs(GetAllVehicles()) do
            if HasVehicleBeenOwnedByPlayer(veh) then
                local isOccupied = isVehicleOccupied(veh)
                for _, player in ipairs(players) do
                    local playerPed = GetPlayerPed(player)
                    local playerCoords = GetEntityCoords(playerPed)
                    if not isOccupied and not isPlayerNearby(veh, checkRadius, playerCoords) then
                        DeleteEntity(veh)
                        deletedCount = deletedCount + 1
                        break 
                    end
                end
            end
        end

        if deletedCount > 0 then
            TriggerClientEvent('chat:addMessage', -1, { color = { 117, 94, 170 }, args = {'TOWING YARD', 'A total of ' .. deletedCount .. ' inactive vehicles have been towed'}})
        end
    end
end)



