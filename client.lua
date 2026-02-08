local RSGCore = exports['rsg-core']:GetCoreObject()


local isInSeance = false
local seanceStartTime = 0
local canCancel = false
local currentSpirit = nil
local currentTimecycle = nil
local spawnedProps = {}
local isFlickering = false
local targetLightState = false
local ghostPed = nil 
local ghostBlip = nil
local syncedGhostPed = nil
local syncedProps = {}
local currentGhostModel = nil
local ghostVisible = false
local weatherOverrideActive = false 
local weatherChanged = false        
local awaitingCooldownCheck = false

local GhostConfig = {
    enabled = true,
    
    models = {
        female = {
            "female_skeleton",
            "rcsp_formyart_females_01",
        },
        male = {
            "casp_coachrobbery_lenny_males_01", 
            "gc_lemoynecaptive_males_01",
            "rcsp_hunting1_males_01",
        },
        spooky = {
            "mes_sadie4_males_01", 
        }
    },
    
    fadeInTime = 3000,
    fadeOutTime = 2000,
    stayTime = 8000,
    transparency = 200,
    distance = 2.0,
    useAnimation = true,
    animDict = "script_common@other@unapproved",
    animName = "cry_loop",
    flickerWithLights = false,
}



local function LoadAnimDict(dict)
    if not DoesAnimDictExist(dict) then
        return false
    end
    
    RequestAnimDict(dict)
    local timeout = 0
    while not HasAnimDictLoaded(dict) do
        Wait(10)
        timeout = timeout + 10
        if timeout > 5000 then
            return false
        end
    end
    return true
end

local function LoadModel(model)
    local modelHash = GetHashKey(model)
    
    if not IsModelValid(modelHash) then
        return nil
    end
    
    RequestModel(modelHash)
    local timeout = 0
    while not HasModelLoaded(modelHash) do
        Wait(10)
        timeout = timeout + 10
        if timeout > 10000 then
            return nil
        end
    end
    
    return modelHash
end



local fogThread = false


local function StartFogOverride()
    if not Config.Weather.extraFog then return end
    if fogThread then return end

    fogThread = true

    CreateThread(function()
        while fogThread and isInSeance do
           
            local density = Config.Weather.fogDensity or 0.005
            local distance = Config.Weather.fogDistance or 100.0

            
            Citizen.InvokeNative(0x29B487C359E19889, density) 

            Wait(0)
        end
        fogThread = false
    end)
end

local function StopFogOverride()
    fogThread = false
end


local function SetLocalWeather(weatherType)
    if weatherOverrideActive then return end

    local weatherHash = GetHashKey(weatherType)
    weatherOverrideActive = true

    CreateThread(function()
        while weatherOverrideActive and isInSeance do
            Citizen.InvokeNative(0x59174F1AFE095B5A, weatherHash, true, false, true, true, false)
            Wait(500)
        end
    end)
end

local function ClearLocalWeatherOverride()
    weatherOverrideActive = false
end


local function SetLocalTime(hour, minute)
    if not Config.Weather.changeTime then return end

    CreateThread(function()
        while weatherOverrideActive and isInSeance do
            Citizen.InvokeNative(0x3A52C59FFB2DEED8, hour, minute, 0, 0, true)
            Wait(1000)
        end
    end)
end

local function SetSeanceWeather(enabled)
    if not Config.Weather or not Config.Weather.enabled then 
        
        return 
    end

    if enabled then
        if weatherChanged then 
            
            return 
        end
        weatherChanged = true
       

        if Config.Weather.useWeatherSync then
            TriggerServerEvent('seance:server:setHalloweenWeather')
        else
            local weatherType = Config.Weather.type or 'FOG'
            SetLocalWeather(weatherType)

            if Config.Weather.changeTime then
                SetLocalTime(Config.Weather.hour or 2, Config.Weather.minute or 0)
            end
        end

        StartFogOverride()

        if Config.Weather.transitionDelay and Config.Weather.transitionDelay > 0 then
            Wait(Config.Weather.transitionDelay)
        end
    else
        if not weatherChanged then 
            
            return 
        end
        
       
        weatherChanged = false

        StopFogOverride()

        if Config.Weather.useWeatherSync then
            print('[Séance Client] Triggering server resetWeather')
            TriggerServerEvent('seance:server:resetWeather')
        else
            ClearLocalWeatherOverride()
        end
    end
end



local effectsActive = false
local shakeActive = false
local timecycleActive = false

local shakeTypes = {
    "VIBRATE_SHAKE",
    "SMALL_EXPLOSION_SHAKE",
    "MEDIUM_EXPLOSION_SHAKE",
    "HAND_SHAKE",
    "JOLT_SHAKE",
    "DRUNK_SHAKE",
}

local function ApplyTimecycle(spiritType)
    if not Config.Effects or not Config.Effects.useTimecycle then return end
    
    local timecycleName = Config.Effects.defaultTimecycle
    local strength = Config.Effects.defaultStrength
    
    if spiritType and Config.SpiritEffects and Config.SpiritEffects[spiritType] then
        timecycleName = Config.SpiritEffects[spiritType].timecycle or timecycleName
        strength = Config.SpiritEffects[spiritType].strength or strength
    end
    
    SetTimecycleModifier(timecycleName)
    SetTimecycleModifierStrength(strength)
    timecycleActive = true
    currentTimecycle = timecycleName
end

local function ClearTimecycle()
    if timecycleActive then
        ClearTimecycleModifier()
        timecycleActive = false
        currentTimecycle = nil
    end
end

local function SetScreenEffect(enabled, spiritType)
    if enabled then
        ApplyTimecycle(spiritType)
        
        if effectsActive then return end
        effectsActive = true
        
        local baseShakeStrength = 0.3
        local shakeType = "VIBRATE_SHAKE"
        local intensityVariation = true
        local useMultipleShakes = false
        
        if spiritType then
            if spiritType == "demonic" or spiritType == "malevolent" or spiritType == "angry" then
                baseShakeStrength = 0.6
                shakeType = "MEDIUM_EXPLOSION_SHAKE"
                useMultipleShakes = true
            elseif spiritType == "tormented" or spiritType == "vengeful" then
                baseShakeStrength = 0.5
                shakeType = "SMALL_EXPLOSION_SHAKE"
                useMultipleShakes = true
            elseif spiritType == "trickster" then
                baseShakeStrength = 0.4
                shakeType = "JOLT_SHAKE"
            elseif spiritType == "mysterious" or spiritType == "ancient" then
                baseShakeStrength = 0.3
                shakeType = "VIBRATE_SHAKE"
            elseif spiritType == "friendly" or spiritType == "child" or spiritType == "peaceful" then
                baseShakeStrength = 0.15
                shakeType = "HAND_SHAKE"
                intensityVariation = false
            end
        end
        
        shakeActive = true
        
        CreateThread(function()
            while shakeActive and isInSeance do
                local currentStrength = baseShakeStrength
                
                if intensityVariation then
                    currentStrength = baseShakeStrength + (math.random(-20, 30) / 100)
                    if currentStrength < 0.1 then currentStrength = 0.1 end
                    if currentStrength > 1.0 then currentStrength = 1.0 end
                end
                
                local currentShakeType = shakeType
                if useMultipleShakes and math.random(1, 10) == 1 then
                    currentShakeType = shakeTypes[math.random(1, #shakeTypes)]
                end
                
                ShakeGameplayCam(currentShakeType, currentStrength)
                
                local waitTime = math.random(50, 150)
                Wait(waitTime)
            end
        end)
        
        CreateThread(function()
            while shakeActive and isInSeance do
                Wait(math.random(5000, 15000))
                
                if shakeActive and isInSeance then
                    ShakeGameplayCam("MEDIUM_EXPLOSION_SHAKE", baseShakeStrength + 0.3)
                    Wait(200)
                    ShakeGameplayCam("JOLT_SHAKE", baseShakeStrength + 0.2)
                end
            end
        end)
        
    else
        effectsActive = false
        shakeActive = false
        StopGameplayCamShaking(true)
        ClearTimecycle()
    end
end

local function StopScreenShake()
    shakeActive = false
    StopGameplayCamShaking(true)
end



local function SelectRandomSpirit()
    if #Config.Spirits == 0 then
        return nil
    end
    return Config.Spirits[math.random(1, #Config.Spirits)]
end

local function GetGhostModel(spiritType)
    local modelList
    
    if spiritType == "malevolent" or spiritType == "dark" then
        modelList = GhostConfig.models.spooky
    elseif spiritType == "female" or spiritType == "benevolent" then
        modelList = GhostConfig.models.female
    else
        if math.random(1, 2) == 1 then
            modelList = GhostConfig.models.male
        else
            modelList = GhostConfig.models.female
        end
    end
    
    return modelList[math.random(1, #modelList)]
end



local function SetLightsOff(state)
    targetLightState = state
    SetArtificialLightsState(state)
end

CreateThread(function()
    while true do
        if isInSeance and not isFlickering then
            SetArtificialLightsState(targetLightState)
        end
        Wait(100)
    end
end)

local function FlickerLightsBlocking(patternName)
    if not Config.Flicker or not Config.Flicker.enabled then 
        return 
    end
    
    if isFlickering then 
        return 
    end
    
    if ghostVisible then
        return
    end
    
    isFlickering = true
    
    local pattern = Config.Flicker.patterns[patternName]
    if not pattern then
        pattern = Config.Flicker.patterns.gentle
    end
    
    if not pattern then
        isFlickering = false
        return
    end
    
    for i, timing in ipairs(pattern) do
        if not isInSeance then break end
        if ghostVisible then break end
        
        SetArtificialLightsState(false)
        Wait(timing[1])
        
        if not isInSeance then break end
        if ghostVisible then break end
        
        SetArtificialLightsState(true)
        Wait(timing[2])
    end
    
    if isInSeance then
        targetLightState = true
        SetArtificialLightsState(true)
    end
    
    isFlickering = false
end

local function FlickerLights(patternName)
    if not Config.Flicker or not Config.Flicker.enabled then return end
    if isFlickering then return end
    if ghostVisible then return end
    
    CreateThread(function()
        FlickerLightsBlocking(patternName)
    end)
end

local function QuickFlicker(times)
    if ghostVisible then return end
    
    times = times or 3
    isFlickering = true
    
    for i = 1, times do
        if ghostVisible then break end
        SetArtificialLightsState(false)
        Wait(100)
        SetArtificialLightsState(true)
        Wait(100)
    end
    
    if isInSeance then
        SetArtificialLightsState(targetLightState)
    else
        SetArtificialLightsState(false)
    end
    
    isFlickering = false
end



local function GetGhostSpawnPosition()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    
    local rad = math.rad(heading)
    
    local x = coords.x - (GhostConfig.distance * math.sin(rad))
    local y = coords.y + (GhostConfig.distance * math.cos(rad))
    
    local foundGround, groundZ = GetGroundZFor_3dCoord(x, y, coords.z + 10.0, true)
    local z = foundGround and groundZ or coords.z
    
    local ghostHeading = heading + 180.0
    if ghostHeading >= 360.0 then
        ghostHeading = ghostHeading - 360.0
    end
    
    return vector3(x, y, z), ghostHeading
end

local function SpawnGhost(spiritType)
    if not GhostConfig.enabled then return nil end
    
    if ghostPed and DoesEntityExist(ghostPed) then
        DeleteEntity(ghostPed)
        ghostPed = nil
    end
    
    currentGhostModel = GetGhostModel(spiritType)
    local modelHash = LoadModel(currentGhostModel)
    
    if not modelHash then
        return nil
    end

    local spawnPos, spawnHeading = GetGhostSpawnPosition()
    
    ghostPed = CreatePed(modelHash, spawnPos.x, spawnPos.y, spawnPos.z, spawnHeading, false, false, false, false)
    
    if not ghostPed or not DoesEntityExist(ghostPed) then
        return nil
    end
    
    Citizen.InvokeNative(0x283978A15512B2FE, ghostPed, true) 
    SetEntityInvincible(ghostPed, true)
    FreezeEntityPosition(ghostPed, true)
    SetBlockingOfNonTemporaryEvents(ghostPed, true)
    SetPedCanBeTargetted(ghostPed, false)
    
    SetEntityAlpha(ghostPed, 0, false)
    
    Citizen.InvokeNative(0x9587913B9E772D29, ghostPed, true)
    
    if GhostConfig.useAnimation then
        if LoadAnimDict(GhostConfig.animDict) then
            TaskPlayAnim(ghostPed, GhostConfig.animDict, GhostConfig.animName, 8.0, -8.0, -1, 1, 0, false, false, false)
        end
    end
    
    SetModelAsNoLongerNeeded(modelHash)
    
    return ghostPed
end

local function FadeGhostIn(duration)
    if not ghostPed or not DoesEntityExist(ghostPed) then return end
    
    duration = duration or GhostConfig.fadeInTime
    local steps = 20
    local stepTime = duration / steps
    local alphaStep = GhostConfig.transparency / steps
    
    for i = 1, steps do
        if not isInSeance or not ghostPed or not DoesEntityExist(ghostPed) then break end
        
        local alpha = math.floor(alphaStep * i)
        if alpha > GhostConfig.transparency then alpha = GhostConfig.transparency end
        
        SetEntityAlpha(ghostPed, alpha, false)
        Wait(stepTime)
    end
    
    if ghostPed and DoesEntityExist(ghostPed) then
        SetEntityAlpha(ghostPed, GhostConfig.transparency, false)
    end
end

local function FadeGhostOut(duration)
    if not ghostPed or not DoesEntityExist(ghostPed) then return end
    
    duration = duration or GhostConfig.fadeOutTime
    local currentAlpha = GetEntityAlpha(ghostPed)
    local steps = 20
    local stepTime = duration / steps
    local alphaStep = currentAlpha / steps
    
    for i = 1, steps do
        if not ghostPed or not DoesEntityExist(ghostPed) then break end
        
        local alpha = math.floor(currentAlpha - (alphaStep * i))
        if alpha < 0 then alpha = 0 end
        
        SetEntityAlpha(ghostPed, alpha, false)
        Wait(stepTime)
    end
end

local function DeleteGhost()
    if ghostPed and DoesEntityExist(ghostPed) then
        DeleteEntity(ghostPed)
        ghostPed = nil
    end
    currentGhostModel = nil
end

local function StartGhostFlickerEffect()
    CreateThread(function()
        while isInSeance and ghostPed and DoesEntityExist(ghostPed) do
            Wait(math.random(2000, 5000))
            
            if not isInSeance or not ghostPed or not DoesEntityExist(ghostPed) then break end
            
            local currentAlpha = GetEntityAlpha(ghostPed)
            
            SetEntityAlpha(ghostPed, math.floor(currentAlpha * 0.3), false)
            Wait(100)
            
            if ghostPed and DoesEntityExist(ghostPed) then
                SetEntityAlpha(ghostPed, currentAlpha, false)
            end
        end
    end)
end

local function ShowGhostAppearance(spiritType)
    if not GhostConfig.enabled then return end
    
    FlickerLightsBlocking('slow')
    
    if Config.EnableGroupSeance then
        TriggerServerEvent('seance:server:syncFlicker', 'slow')
    end
    
    Wait(500)
    
    local ghost = SpawnGhost(spiritType)
    
    if not ghost then
        return
    end
    
    StopScreenShake()
    
    ghostVisible = true
    
    if Config.EnableGroupSeance then
        local spawnPos, spawnHeading = GetGhostSpawnPosition()
        
        TriggerServerEvent('seance:server:syncGhost', {
            model = currentGhostModel,
            coords = spawnPos,
            heading = spawnHeading,
            transparency = GhostConfig.transparency,
            fadeTime = GhostConfig.fadeInTime,
            animDict = GhostConfig.animDict,
            animName = GhostConfig.animName
        })
    end
    
    StartGhostFlickerEffect()
    
    FadeGhostIn(GhostConfig.fadeInTime)
end

local function DismissGhost()
    if not ghostPed or not DoesEntityExist(ghostPed) then 
        ghostVisible = false
        return 
    end
    
    ghostVisible = false
    effectsActive = false
    
    FlickerLightsBlocking('slow')
    
    if Config.EnableGroupSeance then
        TriggerServerEvent('seance:server:syncFlicker', 'slow')
    end
    
    FadeGhostOut(GhostConfig.fadeOutTime)
    
    DeleteGhost()
    
    if Config.EnableGroupSeance then
        TriggerServerEvent('seance:server:dismissGhost')
    end
end



local function SpawnSeanceProps()
    if not Config.Props or not Config.Props.enabled then return end
    
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    
    local candlePositions = {}
    
    if Config.Props.candles and Config.Props.candles.enabled then
        local candleModel = GetHashKey(Config.Props.candles.model)
        
        Citizen.InvokeNative(0xFA28FE3A6246FC30, candleModel)
        
        local timeout = 0
        while not Citizen.InvokeNative(0x1283B8B89DD5D1B6, candleModel) and timeout < 5000 do
            Wait(10)
            timeout = timeout + 10
        end
        
        if Citizen.InvokeNative(0x1283B8B89DD5D1B6, candleModel) then
            for i = 1, Config.Props.candles.count do
                local angle = (i - 1) * (360 / Config.Props.candles.count)
                local rad = math.rad(angle + heading)
                local x = coords.x + (Config.Props.candles.radius * math.cos(rad))
                local y = coords.y + (Config.Props.candles.radius * math.sin(rad))
                local z = coords.z - 1.0
                
                local candle = CreateObject(candleModel, x, y, z, false, false, false)
                Citizen.InvokeNative(0x58A850EAEE20FAA3, candle)
                FreezeEntityPosition(candle, true)
                table.insert(spawnedProps, candle)
                table.insert(candlePositions, vector3(x, y, z))
            end
        end
        
        if Config.EnableGroupSeance and #candlePositions > 0 then
            TriggerServerEvent('seance:server:syncProps', {
                model = Config.Props.candles.model,
                candles = candlePositions
            })
        end
    end
end

local function DeleteSeanceProps()
    for _, prop in ipairs(spawnedProps) do
        if DoesEntityExist(prop) then
            DeleteObject(prop)
        end
    end
    spawnedProps = {}
    
    if Config.EnableGroupSeance then
        TriggerServerEvent('seance:server:cleanupProps')
    end
end



local function StartSeanceAnimation()
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), -1, true, false, false, false)
    return true
end

local function StopSeanceAnimation()
    local ped = PlayerPedId()
    ClearPedTasks(ped)
end

local function PlayHandsUpAnimation()
    local ped = PlayerPedId()
    local animDict = "amb_misc@world_human_drunk_dancing@male@male_b@idle_a"
    local animName = "idle_b"

    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(10)
    end

    TaskPlayAnim(
        ped,
        animDict,
        animName,
        8.0,
        -8.0,
        -1,
        1,
        0.0,
        false,
        false,
        false
    )

    Wait(10000)

    StopAnimTask(ped, animDict, animName, 1.0)

    return true
end



local function SetPlayerFrozen(frozen)
    local ped = PlayerPedId()
    SetEntityInvincible(ped, frozen and not Config.CanBeDamaged)
end



local function SendNotify(message, notifyType, icon, color, duration, title)
    lib.notify({
        title = title or Config.Notification.title,
        description = message,
        type = notifyType or 'info',
        duration = duration or 5000,
        icon = icon or Config.Notification.icons.board,
        iconColor = color or Config.Notification.colors.board,
        position = Config.Notification.position
    })
end

local function SendSpiritNotify(message, spiritTitle, icon, color, duration)
    local notifyDuration = duration or Config.Timing.messageDuration
    
    lib.notify({
        title = spiritTitle or Config.Notification.spiritTitle,
        description = message,
        type = 'info',
        duration = notifyDuration,
        icon = icon or Config.Notification.icons.spirit,
        iconColor = color or Config.Notification.colors.spirit,
        position = Config.Notification.position
    })
    
    return notifyDuration
end

local function BroadcastToNearby(message, spiritTitle, icon, color, duration)
    if Config.EnableGroupSeance then
        TriggerServerEvent('seance:server:broadcastMessage', {
            message = message,
            title = spiritTitle,
            icon = icon,
            color = color,
            duration = duration
        })
    end
end

local function EndSeance(forced)
    if not isInSeance then return end
    
    
    local wasInSeance = isInSeance
    
    isInSeance = false
    
    
    if Config.Cooldown and Config.Cooldown.enabled then
        TriggerServerEvent('seance:server:setCooldown')
    end
    
    canCancel = false
    currentSpirit = nil
    isFlickering = false
    targetLightState = false
    ghostVisible = false
    
    DismissGhost()
    
    if Config.Flicker and Config.Flicker.onEnd then
        QuickFlicker(5)
    end
    
    Wait(500)
    
    StopSeanceAnimation()
    SetArtificialLightsState(false)
    SetScreenEffect(false)
    
    if Config.FreezePlayer then
        SetPlayerFrozen(false)
    end
    
    DeleteSeanceProps()
    
   
    if wasInSeance then
        
        SetSeanceWeather(false)
    end
    
    Wait(500)
    if forced then
        SendNotify(
            Config.Messages.forcedEnd,
            'warning',
            Config.Notification.icons.end_icon,
            Config.Notification.colors.end_icon,
            4000
        )
    else
        SendNotify(
            Config.Messages.seanceEnd,
            'info',
            Config.Notification.icons.end_icon,
            Config.Notification.colors.end_icon,
            5000
        )
    end
	
	if Config.GlobalNotification and Config.GlobalNotification.enabled then
        TriggerServerEvent('seance:server:globalNotify', 'ended')
    end
end

local function RunSpiritCommunication()
    if not isInSeance then return end
    
    local availableTime = Config.SeanceDuration - Config.Timing.initialDelay - 8000
    local timePerMessage = Config.Timing.messageDuration + Config.Timing.pauseBetweenMessages
    local maxMessages = math.floor(availableTime / timePerMessage)
    
    currentSpirit = SelectRandomSpirit()
    
    if not currentSpirit then
        SendNotify('No spirits answer your call...', 'warning', Config.Notification.icons.warning, Config.Notification.colors.warning, 5000)
        return
    end
    
    SetScreenEffect(true, currentSpirit.type)
    
    -- WEATHER: Change weather at spirit contact if configured
    if Config.Weather and Config.Weather.enabled and Config.Weather.setDuringContact then
        SetSeanceWeather(true)
    end
    
    local flickerPattern = 'slow'
    
    SendNotify(
        Config.Messages.contact,
        'info',
        Config.Notification.icons.contact,
        Config.Notification.colors.contact,
        3000
    )
    
    Wait(3500)
    if not isInSeance then return end
    
    ShowGhostAppearance(currentSpirit.type)
    
    Wait(1000)
    if not isInSeance then return end
    
    local introDuration = SendSpiritNotify(
        currentSpirit.introduction,
        currentSpirit.title,
        currentSpirit.icon,
        currentSpirit.iconColor,
        Config.Timing.messageDuration
    )
    BroadcastToNearby(currentSpirit.introduction, currentSpirit.title, currentSpirit.icon, currentSpirit.iconColor, Config.Timing.messageDuration)
    
    Wait(introDuration)
    if not isInSeance then return end
    
    Wait(Config.Timing.pauseBetweenMessages)
    if not isInSeance then return end
    
    local messagesShown = 0
    local messageIndex = 1
    
    while isInSeance and messagesShown < maxMessages and messageIndex <= #currentSpirit.messages do
        local message = currentSpirit.messages[messageIndex]
        
        if message then
            if Config.Flicker and Config.Flicker.onSpiritSpeak and Config.Timing.flickerDuringMessage then
                FlickerLightsBlocking(flickerPattern)
            end
            
            local duration = SendSpiritNotify(
                message,
                currentSpirit.title,
                currentSpirit.icon,
                currentSpirit.iconColor,
                Config.Timing.messageDuration
            )
            BroadcastToNearby(message, currentSpirit.title, currentSpirit.icon, currentSpirit.iconColor, Config.Timing.messageDuration)
            
            messagesShown = messagesShown + 1
            
            Wait(duration)
            if not isInSeance then break end
            
            Wait(Config.Timing.pauseBetweenMessages)
            if not isInSeance then break end
            
            messageIndex = messageIndex + 1
            
            if messageIndex > #currentSpirit.messages and messagesShown < maxMessages - 2 then
                DismissGhost()
                
                SendNotify(
                    Config.Messages.spiritChanges,
                    'info',
                    Config.Notification.icons.spirit,
                    Config.Notification.colors.spirit,
                    3000
                )
                
                FlickerLightsBlocking('slow')
                
                Wait(4000)
                if not isInSeance then break end
                
                local newSpirit = SelectRandomSpirit()
                if newSpirit and newSpirit.name ~= currentSpirit.name then
                    currentSpirit = newSpirit
                    messageIndex = 1
                    
                    SetScreenEffect(true, currentSpirit.type)
                    
                    ShowGhostAppearance(currentSpirit.type)
                    
                    Wait(1000)
                    if not isInSeance then break end
                    
                    local introD = SendSpiritNotify(
                        currentSpirit.introduction,
                        currentSpirit.title,
                        currentSpirit.icon,
                        currentSpirit.iconColor,
                        Config.Timing.messageDuration
                    )
                    BroadcastToNearby(currentSpirit.introduction, currentSpirit.title, currentSpirit.icon, currentSpirit.iconColor, Config.Timing.messageDuration)
                    
                    Wait(introD)
                    if not isInSeance then break end
                    
                    Wait(Config.Timing.pauseBetweenMessages)
                else
                    break
                end
            end
        else
            break
        end
    end
    
    if isInSeance then
        DismissGhost()
        
        FlickerLightsBlocking('slow')
        
        SendNotify(
            Config.Messages.spiritLeaves,
            'info',
            Config.Notification.icons.spirit,
            Config.Notification.colors.spirit,
            4000
        )
        
        Wait(4500)
    end
end

local function StartSeance()
    local ped = PlayerPedId()
    
    if isInSeance then
        SendNotify(Config.Messages.alreadyInSeance, 'error', Config.Notification.icons.warning, Config.Notification.colors.warning, 3000)
        return
    end
    
    if IsPedInAnyVehicle(ped, false) then
        SendNotify(Config.Messages.cannotHere, 'error', Config.Notification.icons.warning, Config.Notification.colors.warning, 3000)
        return
    end
    
    if IsPedSwimming(ped) or IsPedSwimmingUnderWater(ped) then
        SendNotify(Config.Messages.cannotHere, 'error', Config.Notification.icons.warning, Config.Notification.colors.warning, 3000)
        return
    end
    
    if IsEntityDead(ped) then
        SendNotify(Config.Messages.cannotHere, 'error', Config.Notification.icons.warning, Config.Notification.colors.warning, 3000)
        return
    end
    
    isInSeance = true
    seanceStartTime = GetGameTimer()
    canCancel = false
    currentSpirit = nil
    isFlickering = false
    targetLightState = false
    ghostVisible = false
    weatherChanged = false
    
    SendNotify(
        Config.Messages.preparing,
        'info',
        Config.Notification.icons.board,
        Config.Notification.colors.board,
        3000
    )
    
    Wait(2000)
    if not isInSeance then return end
    
    if not StartSeanceAnimation() then
        isInSeance = false
        SendNotify('Something went wrong...', 'error', Config.Notification.icons.warning, Config.Notification.colors.warning, 3000)
        return
    end
    
    Wait(1500)
    if not isInSeance then return end
    
    SpawnSeanceProps()
    
    StopSeanceAnimation()
    
    PlayHandsUpAnimation()
    
    if not isInSeance then return end
    
    SendNotify(
        Config.Messages.lighting,
        'info',
        Config.Notification.icons.candle,
        Config.Notification.colors.candle,
        3000
    )
    
    if Config.Flicker and Config.Flicker.onStart then
        FlickerLightsBlocking('gentle')
    end
    
    Wait(2000)
    if not isInSeance then return end
    
    if Config.FreezePlayer then
        SetPlayerFrozen(true)
    end
    
    SendNotify(
        Config.Messages.beginning,
        'info',
        Config.Notification.icons.board,
        Config.Notification.colors.board,
        3000
    )
    
    Wait(3500)
    if not isInSeance then return end
    
    SetLightsOff(true)
    SetScreenEffect(true, 'mysterious')
	
	if Config.GlobalNotification and Config.GlobalNotification.enabled then
        TriggerServerEvent('seance:server:globalNotify', 'start')
    end
    
    -- WEATHER: Change weather at séance start if configured (not during contact)
    if Config.Weather and Config.Weather.enabled and not Config.Weather.setDuringContact then
        SetSeanceWeather(true)
    end
    
    SendNotify(
        Config.Messages.calling,
        'info',
        Config.Notification.icons.spirit,
        Config.Notification.colors.spirit,
        4000
    )
    
    FlickerLightsBlocking('slow')
    
    Wait(2000)
    if not isInSeance then return end
    
    FlickerLightsBlocking('slow')
    
    SendNotify(
        Config.Messages.presence,
        'info',
        Config.Notification.icons.spirit,
        Config.Notification.colors.spirit,
        3000
    )
    
    Wait(Config.Timing.initialDelay - 4500)
    if not isInSeance then return end
    
    CreateThread(function()
        local elapsedTime = 0
        while isInSeance do
            Wait(1000)
            elapsedTime = elapsedTime + 1000
            
            if not canCancel and elapsedTime >= Config.MinTimeBeforeCancel then
                canCancel = true
                if Config.AllowCancel then
                    SendNotify(
                        Config.Messages.cancelHint,
                        'info',
                        'circle-info',
                        '#7f8c8d',
                        5000
                    )
                end
            end
            
            local ped = PlayerPedId()
            if IsEntityDead(ped) then
                EndSeance(true)
                break
            end
        end
    end)
    
    if Config.AllowCancel then
        CreateThread(function()
            while isInSeance do
                Wait(0)
                if canCancel and IsControlJustPressed(0, Config.CancelKey) then
                    FlickerLightsBlocking('slow')
                    
                    SendNotify(
                        'You break the circle...',
                        'warning',
                        Config.Notification.icons.warning,
                        Config.Notification.colors.warning,
                        2000
                    )
                    
                    Wait(2000)
                    EndSeance(true)
                    break
                end
            end
        end)
    end
    
    RunSpiritCommunication()
    
    if isInSeance then
        EndSeance(false)
    end
end

---------------------------------
-- EVENTS
---------------------------------

RegisterNetEvent('seance:client:useOuijaBoard', function()
    if awaitingCooldownCheck then return end
    
    if isInSeance then
        SendNotify(Config.Messages.alreadyInSeance, 'error', Config.Notification.icons.warning, Config.Notification.colors.warning, 3000)
        return
    end
    
   
    if Config.Cooldown and Config.Cooldown.enabled then
        awaitingCooldownCheck = true
        TriggerServerEvent('seance:server:checkCooldown')
    else
        StartSeance()
    end
end)

RegisterNetEvent('seance:client:cooldownResult', function(onCooldown, remainingSeconds)
    awaitingCooldownCheck = false
    
    if onCooldown then
        local minutes = math.floor(remainingSeconds / 60)
        local seconds = remainingSeconds % 60
        local timeStr = ""
        
        if minutes > 0 then
            timeStr = minutes .. " minute" .. (minutes > 1 and "s" or "")
            if seconds > 0 then
                timeStr = timeStr .. " and " .. seconds .. " second" .. (seconds > 1 and "s" or "")
            end
        else
            timeStr = seconds .. " second" .. (seconds > 1 and "s" or "")
        end
        
        SendNotify(
            'The spirits need rest. Try again in ' .. timeStr .. '.',
            'error',
            Config.Notification.icons.warning,
            Config.Notification.colors.warning,
            5000
        )
    else
        StartSeance()
    end
end)

RegisterNetEvent('seance:client:receiveBroadcast', function(data)
    if isInSeance then return end
    
    lib.notify({
        title = data.title or Config.Notification.spiritTitle,
        description = data.message,
        type = 'info',
        duration = data.duration or Config.Timing.messageDuration,
        icon = data.icon or Config.Notification.icons.spirit,
        iconColor = data.color or Config.Notification.colors.spirit,
        position = Config.Notification.position
    })
    
    if Config.Flicker and Config.Flicker.enabled then
        QuickFlicker(3)
    end
end)

---------------------------------
-- SYNCED EVENTS FOR NEARBY PLAYERS
---------------------------------

RegisterNetEvent('seance:client:syncGhost', function(data)
    if isInSeance then return end
    
    if syncedGhostPed and DoesEntityExist(syncedGhostPed) then
        DeleteEntity(syncedGhostPed)
        syncedGhostPed = nil
    end
    
    local modelHash = GetHashKey(data.model)
    if not IsModelValid(modelHash) then return end
    
    RequestModel(modelHash)
    local timeout = 0
    while not HasModelLoaded(modelHash) do
        Wait(10)
        timeout = timeout + 10
        if timeout > 10000 then return end
    end
    
    syncedGhostPed = CreatePed(modelHash, data.coords.x, data.coords.y, data.coords.z, data.heading, false, false, false, false)
    
    if not syncedGhostPed or not DoesEntityExist(syncedGhostPed) then return end
    
    Citizen.InvokeNative(0x283978A15512B2FE, syncedGhostPed, true)
    SetEntityInvincible(syncedGhostPed, true)
    FreezeEntityPosition(syncedGhostPed, true)
    SetBlockingOfNonTemporaryEvents(syncedGhostPed, true)
    SetPedCanBeTargetted(syncedGhostPed, false)
    Citizen.InvokeNative(0x9587913B9E772D29, syncedGhostPed, true)
    
    SetEntityAlpha(syncedGhostPed, 0, false)
    
    if data.animDict and data.animName then
        if LoadAnimDict(data.animDict) then
            TaskPlayAnim(syncedGhostPed, data.animDict, data.animName, 8.0, -8.0, -1, 1, 0, false, false, false)
        end
    end
    
    SetModelAsNoLongerNeeded(modelHash)
    
    CreateThread(function()
        local steps = 20
        local stepTime = data.fadeTime / steps
        local alphaStep = data.transparency / steps
        
        for i = 1, steps do
            if not syncedGhostPed or not DoesEntityExist(syncedGhostPed) then break end
            
            local alpha = math.floor(alphaStep * i)
            if alpha > data.transparency then alpha = data.transparency end
            
            SetEntityAlpha(syncedGhostPed, alpha, false)
            Wait(stepTime)
        end
        
        if syncedGhostPed and DoesEntityExist(syncedGhostPed) then
            SetEntityAlpha(syncedGhostPed, data.transparency, false)
        end
    end)
    
    CreateThread(function()
        while syncedGhostPed and DoesEntityExist(syncedGhostPed) do
            Wait(math.random(2000, 5000))
            
            if not syncedGhostPed or not DoesEntityExist(syncedGhostPed) then break end
            
            local currentAlpha = GetEntityAlpha(syncedGhostPed)
            
            SetEntityAlpha(syncedGhostPed, math.floor(currentAlpha * 0.3), false)
            Wait(100)
            
            if syncedGhostPed and DoesEntityExist(syncedGhostPed) then
                SetEntityAlpha(syncedGhostPed, currentAlpha, false)
            end
        end
    end)
end)

RegisterNetEvent('seance:client:dismissSyncedGhost', function()
    if not syncedGhostPed or not DoesEntityExist(syncedGhostPed) then return end
    
    local currentAlpha = GetEntityAlpha(syncedGhostPed)
    local steps = 20
    local stepTime = 100
    local alphaStep = currentAlpha / steps
    
    for i = 1, steps do
        if not syncedGhostPed or not DoesEntityExist(syncedGhostPed) then break end
        
        local alpha = math.floor(currentAlpha - (alphaStep * i))
        if alpha < 0 then alpha = 0 end
        
        SetEntityAlpha(syncedGhostPed, alpha, false)
        Wait(stepTime)
    end
    
    if syncedGhostPed and DoesEntityExist(syncedGhostPed) then
        DeleteEntity(syncedGhostPed)
        syncedGhostPed = nil
    end
end)

RegisterNetEvent('seance:client:syncFlicker', function(pattern)
    if isInSeance then return end
    QuickFlicker(3)
end)

RegisterNetEvent('seance:client:syncProps', function(data)
    if isInSeance then return end
    
    for _, prop in ipairs(syncedProps) do
        if DoesEntityExist(prop) then
            DeleteObject(prop)
        end
    end
    syncedProps = {}
    
    if data.candles then
        local candleModel = GetHashKey(data.model)
        
        Citizen.InvokeNative(0xFA28FE3A6246FC30, candleModel)
        
        local timeout = 0
        while not Citizen.InvokeNative(0x1283B8B89DD5D1B6, candleModel) and timeout < 5000 do
            Wait(10)
            timeout = timeout + 10
        end
        
        if Citizen.InvokeNative(0x1283B8B89DD5D1B6, candleModel) then
            for _, candlePos in ipairs(data.candles) do
                local candle = CreateObject(candleModel, candlePos.x, candlePos.y, candlePos.z, false, false, false)
                Citizen.InvokeNative(0x58A850EAEE20FAA3, candle)
                FreezeEntityPosition(candle, true)
                table.insert(syncedProps, candle)
            end
        end
    end
end)

RegisterNetEvent('seance:client:cleanupSyncedProps', function()
    for _, prop in ipairs(syncedProps) do
        if DoesEntityExist(prop) then
            DeleteObject(prop)
        end
    end
    syncedProps = {}
end)

RegisterNetEvent('seance:client:globalNotify', function(data)
    lib.notify({
        title = data.title or '🌙 The Spirit World',
        description = data.message,
        type = 'info',
        duration = data.duration or 8000,
        icon = data.icon or 'ghost',
        iconColor = data.iconColor or '#8b0000',
        position = Config.Notification.position
    })
end)

---------------------------------
-- CLEANUP
---------------------------------

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        if isInSeance then
            isInSeance = false
            canCancel = false
            currentSpirit = nil
            isFlickering = false
            targetLightState = false
            ghostVisible = false
            StopSeanceAnimation()
            SetScreenEffect(false)
            SetPlayerFrozen(false)
            SetArtificialLightsState(false)
            DeleteSeanceProps()
            DeleteGhost()
        end
        
        -- WEATHER: Always clean up weather on resource stop
        if weatherChanged then
            weatherChanged = false
            weatherOverrideActive = false
            if Config.Weather and Config.Weather.useWeatherSync then
                TriggerServerEvent('seance:server:resetWeather')
            end
        end
        ClearLocalWeatherOverride()
        ClearTimecycle()
        
        if syncedGhostPed and DoesEntityExist(syncedGhostPed) then
            DeleteEntity(syncedGhostPed)
            syncedGhostPed = nil
        end
        
        for _, prop in ipairs(syncedProps) do
            if DoesEntityExist(prop) then
                DeleteObject(prop)
            end
        end
        syncedProps = {}
    end
end)

AddEventHandler('gameEventTriggered', function(event, data)
    if event == 'CEventNetworkEntityDamage' then
        local victim = data[1]
        if victim == PlayerPedId() and IsEntityDead(victim) then
            if isInSeance then
                EndSeance(true)
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(1000)
        if isInSeance then
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped, false) then
                EndSeance(true)
            end
        end
    end
end)

