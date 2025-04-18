ESX = exports.es_extended:getSharedObject()

local oxmysql = exports.oxmysql

-- Function to get player's name from the database
local function getPlayerName(source, callback)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.getIdentifier()

    oxmysql:fetch('SELECT firstname, lastname FROM users WHERE identifier = ?', {identifier}, function(result)
        if result[1] then
            local fullName = result[1].firstname .. " " .. result[1].lastname
            callback(fullName)
        else
            callback(nil)
        end
    end)
end

-- Function to show the player's inventory to nearby players
local function showInventory(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventory()

    -- Only show items that the player actually has
    local itemsToShow = {}
    for i = 1, #inventory, 1 do
        if inventory[i].count > 0 or Config.IncludeEmptySlots then
            table.insert(itemsToShow, {label = inventory[i].label, count = inventory[i].count})
        end
    end

    -- If no items to show, return
    if #itemsToShow == 0 then
        TriggerClientEvent('chat:addMessage', source, {
            args = {"^3[Inventory]^0", Config.NoItemsMessage}
        })
        return
    end

    -- Get the player's name and send inventory to nearby players (excluding the source)
    getPlayerName(source, function(playerName)
        local playerCoords = GetEntityCoords(GetPlayerPed(source))
        local playersInRange = false

        for _, player in ipairs(GetPlayers()) do
            if player ~= tostring(source) then  -- Skip the player using the command
                local targetPed = GetPlayerPed(player)
                local targetCoords = GetEntityCoords(targetPed)

                if #(playerCoords - targetCoords) <= Config.ShowInventoryDistance then
                    -- Send inventory to nearby players
                    TriggerClientEvent('showNearbyInventory', player, itemsToShow, playerName)
                    playersInRange = true
                end
            end
        end

        -- Send a private message to the player if at least one other player is in range
        if playersInRange then
            TriggerClientEvent('chat:addMessage', source, {
                args = {"^2" .. playerName .. ", ^0you have shown your inventory to nearby players."}
            })
        else
            TriggerClientEvent('chat:addMessage', source, {
                args = {"^1" .. playerName .. ", ^0no nearby players to show your inventory to."}
            })
        end
    end)
end

-- Function to show a single item from the player's inventory
local function showSingleItem(source, slot)
    local xPlayer = ESX.GetPlayerFromId(source)
    local inventory = xPlayer.getInventory()

    -- Check if the slot is valid (1-5)
    if slot < 1 or slot > Config.MaxItemSlots then
        TriggerClientEvent('chat:addMessage', source, {
            args = {"^3[Item]^0", Config.InvalidSlotMessage}
        })
        return
    end

    -- Ensure the item in the specified slot exists and has a count > 0
    local item = inventory[slot]
    if item and item.count > 0 then
        -- Get the player's name and send the item to nearby players (excluding the source)
        getPlayerName(source, function(playerName)
            local playerCoords = GetEntityCoords(GetPlayerPed(source))
            local playersInRange = false

            for _, player in ipairs(GetPlayers()) do
                if player ~= tostring(source) then  -- Skip the player using the command
                    local targetPed = GetPlayerPed(player)
                    local targetCoords = GetEntityCoords(targetPed)

                    if #(playerCoords - targetCoords) <= Config.ShowInventoryDistance then
                        -- Send item to nearby players
                        TriggerClientEvent('showSingleItemNearby', player, {label = item.label, count = item.count}, playerName)
                        playersInRange = true
                    end
                end
            end

            -- Send a private message to the player if at least one other player is in range
            if playersInRange then
                TriggerClientEvent('chat:addMessage', source, {
                    args = {"^2" .. playerName .. ", ^0you have shown a item to nearby players."}
                })
            else
                TriggerClientEvent('chat:addMessage', source, {
                    args = {"^1" .. playerName .. ", ^0no nearby players to show your item."}
                })
            end
        end)
    else
        -- No item in the slot or count is 0
        TriggerClientEvent('chat:addMessage', source, {
            args = {"^3[Item]^0", Config.EmptySlotMessage}
        })
    end
end

-- Main command to show the entire inventory
RegisterCommand(Config.ShowInventoryCommand, function(source, args, rawCommand)
    showInventory(source)
end)

-- Alias command for showing inventory
RegisterCommand(Config.CommandAlias, function(source, args, rawCommand)
    showInventory(source)
end)

-- Command to show a single item from slot 1-5
RegisterCommand(Config.ShowItemCommand, function(source, args, rawCommand)
    local slot = tonumber(args[1])

    if not slot then
        TriggerClientEvent('chat:addMessage', source, {
            args = {"^3[Item]^0", "Please specify a slot number between 1 and " .. Config.MaxItemSlots .. "."}
        })
        return
    end

    showSingleItem(source, slot)
end)
