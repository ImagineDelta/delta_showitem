local function getNearbyPlayers(playerId, distance)
    local players = GetActivePlayers()
    local nearbyPlayers = {}

    local playerPed = GetPlayerPed(playerId)
    local playerCoords = GetEntityCoords(playerPed)

    for _, player in ipairs(players) do
        local targetPed = GetPlayerPed(player)
        local targetCoords = GetEntityCoords(targetPed)

        if #(playerCoords - targetCoords) <= distance then
            table.insert(nearbyPlayers, player)
        end
    end

    return nearbyPlayers
end

RegisterNetEvent('showNearbyInventory')
AddEventHandler('showNearbyInventory', function(items, playerName)
    local nearbyPlayers = getNearbyPlayers(PlayerId(), Config.ShowInventoryDistance)

    -- Format inventory items as a string
    local inventoryMessage = "^3[Inventory]^0: "
    for i, item in ipairs(items) do
        inventoryMessage = inventoryMessage .. item.label .. " x" .. item.count
        if i < #items then
            inventoryMessage = inventoryMessage .. ", "
        end
    end

    -- Send inventory message to nearby players (excluding the source)
    for _, player in ipairs(nearbyPlayers) do
        if player ~= PlayerId() then
            TriggerEvent('chat:addMessage', {
                args = {"^2" .. playerName .. " ^0has shown their", inventoryMessage}
            })
        end
    end
end)

RegisterNetEvent('showSingleItemNearby')
AddEventHandler('showSingleItemNearby', function(item, playerName)
    local nearbyPlayers = getNearbyPlayers(PlayerId(), Config.ShowInventoryDistance)

    -- Format item message
    local itemMessage = "^3[Item]^0: " .. item.label .. " x" .. item.count

    -- Send item message to nearby players (excluding the source)
    for _, player in ipairs(nearbyPlayers) do
        if player ~= PlayerId() then
            TriggerEvent('chat:addMessage', {
                args = {"^2" .. playerName .. " ^0has shown an", itemMessage}
            })
        end
    end
end)
