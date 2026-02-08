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


local previousWeather = nil
local activeWeatherSeances = 0

RegisterNetEvent('seance:server:setHalloweenWeather', function()
    local src = source

    if not Config.Weather or not Config.Weather.enabled then
        return
    end

    

    if activeWeatherSeances == 0 then
        
        pcall(function()
            previousWeather = exports.weathersync:getWeather()
            
        end)

       
        local weatherType = Config.Weather.type or 'thunderstorm'
        
        local ok, err = pcall(function()
            exports.weathersync:setWeather(weatherType, true, 0.0)
        end)
        
        if ok then
            
        else
            
        end
    end

    activeWeatherSeances = activeWeatherSeances + 1
    
end)

RegisterNetEvent('seance:server:resetWeather', function()
    local src = source

    if not Config.Weather or not Config.Weather.enabled then
        return
    end

    

    activeWeatherSeances = activeWeatherSeances - 1
    if activeWeatherSeances < 0 then activeWeatherSeances = 0 end

    

    if activeWeatherSeances == 0 then
        
        local restoreWeather = previousWeather or 'sunny'
        
        local ok, err = pcall(function()
            exports.weathersync:setWeather(restoreWeather, false, 0.0)
        end)
        
        if ok then
            
        else
            
        end

        previousWeather = nil
        
    end
end)


RegisterNetEvent('seance:server:globalNotify', function(notifyType)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    
    if not Config.GlobalNotification or not Config.GlobalNotification.enabled then
        return
    end
    
    local message = nil
    
    if notifyType == 'start' and Config.GlobalNotification.onStart then
        message = Config.GlobalNotification.messages.start
       
    elseif notifyType == 'ended' and Config.GlobalNotification.onEnd then
        message = Config.GlobalNotification.messages.ended
        
    end
    
    if not message then return end
    
   
    local players = RSGCore.Functions.GetPlayers()
    
    for _, playerId in ipairs(players) do
        if playerId ~= src then
            TriggerClientEvent('seance:client:globalNotify', playerId, {
                message = message,
                title = Config.GlobalNotification.title,
                icon = Config.GlobalNotification.icon,
                iconColor = Config.GlobalNotification.iconColor,
                duration = Config.GlobalNotification.duration,
            })
        end
    end
end)


AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if activeWeatherSeances > 0 or previousWeather then
            
            
            local restoreWeather = previousWeather or 'sunny'
            pcall(function() 
                exports.weathersync:setWeather(restoreWeather, false, 0.0) 
            end)
            
            activeWeatherSeances = 0
            previousWeather = nil
        end
    end
end)




local playerCooldowns = {}

RegisterNetEvent('seance:server:checkCooldown', function()
    local src = source
    
    if not Config.Cooldown or not Config.Cooldown.enabled then
        TriggerClientEvent('seance:client:cooldownResult', src, false, 0)
        return
    end
    
    local lastSeance = playerCooldowns[src]
    
    if not lastSeance then
        TriggerClientEvent('seance:client:cooldownResult', src, false, 0)
        return
    end
    
    local currentTime = os.time()
    local timePassed = currentTime - lastSeance
    local cooldownDuration = Config.Cooldown.duration or 600
    
    if timePassed < cooldownDuration then
        local remaining = cooldownDuration - timePassed
        TriggerClientEvent('seance:client:cooldownResult', src, true, remaining)
    else
        playerCooldowns[src] = nil
        TriggerClientEvent('seance:client:cooldownResult', src, false, 0)
    end
end)

RegisterNetEvent('seance:server:setCooldown', function()
    local src = source
    
    if not Config.Cooldown or not Config.Cooldown.enabled then
        return
    end
    
    playerCooldowns[src] = os.time()
   
end)


AddEventHandler('playerDropped', function(reason)
    local src = source
    if playerCooldowns[src] then
        playerCooldowns[src] = nil
    end
end)


AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if activeWeatherSeances > 0 or previousWeather or timeWasFrozen then
            print('[Séance] Resource stopping, cleaning up weather')
            activeWeatherSeances = 0
            
            ExecuteCommand('timescale 1')
            ExecuteCommand('synctime')
            
            if previousWeather then
                ExecuteCommand('weather ' .. previousWeather)
            else
                ExecuteCommand('weather SUNNY')
            end
            
            previousWeather = nil
            timeWasFrozen = false
        end
    end
end)


RegisterNetEvent('seance:server:log', function(message)
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if Player then
        local name = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        
    end
end)
