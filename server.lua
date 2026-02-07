local RSGCore = exports['rsg-core']:GetCoreObject()


CreateThread(function()
    Wait(1000)
    
    RSGCore.Functions.CreateUseableItem(Config.ItemName, function(source, item)
        local src = source
        local Player = RSGCore.Functions.GetPlayer(src)
        
        if not Player then return end
        
       
        local hasItem = Player.Functions.GetItemByName(Config.ItemName)
        
        if not hasItem then
            return
        end
        
        
        
        
        TriggerClientEvent('seance:client:useOuijaBoard', src)
    end)
    
    
end)


-- Broadcast spirit messages (you already have this)
RegisterNetEvent('seance:server:broadcastMessage', function(data)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local coords = GetEntityCoords(GetPlayerPed(src))
    local players = RSGCore.Functions.GetPlayers()
    
    for _, playerId in ipairs(players) do
        if playerId ~= src then
            local targetPed = GetPlayerPed(playerId)
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(coords - targetCoords)
            
            if distance <= Config.GroupSeanceRadius then
                TriggerClientEvent('seance:client:receiveBroadcast', playerId, data)
            end
        end
    end
end)

-- Sync ghost spawn to nearby players
RegisterNetEvent('seance:server:syncGhost', function(data)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local coords = GetEntityCoords(GetPlayerPed(src))
    local players = RSGCore.Functions.GetPlayers()
    
    for _, playerId in ipairs(players) do
        if playerId ~= src then
            local targetPed = GetPlayerPed(playerId)
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(coords - targetCoords)
            
            if distance <= Config.GroupSeanceRadius then
                TriggerClientEvent('seance:client:syncGhost', playerId, data)
            end
        end
    end
end)

-- Sync ghost dismiss to nearby players
RegisterNetEvent('seance:server:dismissGhost', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local coords = GetEntityCoords(GetPlayerPed(src))
    local players = RSGCore.Functions.GetPlayers()
    
    for _, playerId in ipairs(players) do
        if playerId ~= src then
            local targetPed = GetPlayerPed(playerId)
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(coords - targetCoords)
            
            if distance <= Config.GroupSeanceRadius then
                TriggerClientEvent('seance:client:dismissSyncedGhost', playerId)
            end
        end
    end
end)

-- Sync light flicker to nearby players
RegisterNetEvent('seance:server:syncFlicker', function(pattern)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local coords = GetEntityCoords(GetPlayerPed(src))
    local players = RSGCore.Functions.GetPlayers()
    
    for _, playerId in ipairs(players) do
        if playerId ~= src then
            local targetPed = GetPlayerPed(playerId)
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(coords - targetCoords)
            
            if distance <= Config.GroupSeanceRadius then
                TriggerClientEvent('seance:client:syncFlicker', playerId, pattern)
            end
        end
    end
end)

-- Sync props to nearby players
RegisterNetEvent('seance:server:syncProps', function(data)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local coords = GetEntityCoords(GetPlayerPed(src))
    local players = RSGCore.Functions.GetPlayers()
    
    for _, playerId in ipairs(players) do
        if playerId ~= src then
            local targetPed = GetPlayerPed(playerId)
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(coords - targetCoords)
            
            if distance <= Config.GroupSeanceRadius then
                TriggerClientEvent('seance:client:syncProps', playerId, data)
            end
        end
    end
end)

-- Sync props cleanup
RegisterNetEvent('seance:server:cleanupProps', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    
    local coords = GetEntityCoords(GetPlayerPed(src))
    local players = RSGCore.Functions.GetPlayers()
    
    for _, playerId in ipairs(players) do
        if playerId ~= src then
            local targetPed = GetPlayerPed(playerId)
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(coords - targetCoords)
            
            if distance <= Config.GroupSeanceRadius then
                TriggerClientEvent('seance:client:cleanupSyncedProps', playerId)
            end
        end
    end
end)

---------------------------------
-- LOGGING
---------------------------------
RegisterNetEvent('seance:server:log', function(message)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if Player then
        local name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        
    end
end)