if not string.match(GetCurrentResourceName(), "lambra") then
    print("Resource can not be started. Reason: lambra prefix not found")
    return
end
local QBCore = exports["qb-core"]:GetCoreObject()

local menuOpened = false
local inMission = false
local routeBlip
local ladderinHand = false

RegisterNetEvent("lambra-christmas:notify", function(text, tipo)
    QBCore.Functions.Notify(text, tipo)
end)

CreateThread(function()

    local santaBlip = AddBlipForCoord(Config.interactionCoords)
    SetBlipSprite (santaBlip, 486)
    SetBlipDisplay(santaBlip, 2)
    SetBlipScale(santaBlip, 1.4)
    SetBlipAsShortRange(santaBlip, true)
    SetBlipColour(santaBlip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Locales["bliptitle"])
    EndTextCommandSetBlipName(santaBlip)


    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local dist = #(coords - Config.interactionCoords)
        local inRange = false
        if dist <= 20.0 then
            inRange = true
            if dist <= 3.0 then
                if not menuOpened then
                    DrawText3D(Config.interactionCoords.x, Config.interactionCoords.y, Config.interactionCoords.z, Locales["talkWithSanta"])
                    if IsControlJustReleased(0, 38) then
                        if isWearingHat() then 
                            openMenu()
                        else
                            TriggerEvent("lambra-christmas:notify", Locales["notWearingHat"], "error") 
                        end
                        Wait(2000)
                    end
                end
            end
        end
        if not inRange then Wait(3000) end
        Wait(1)
    end
end)

RegisterNetEvent("lambra-christmas:client:helpSanta", function(generatedLoc)
    if not inMission then
        TriggerEvent("lambra-christmas:notify", Locales["goToLocation"])
        inMission = true
        local Location = Config.Locations[generatedLoc]
        
        routeBlip = AddBlipForCoord(Location.ladderPos)
	    SetBlipRoute(routeBlip, true)
	    SetBlipRouteColour(routeBlip, 1)

        CreateThread(function()
            local ped = PlayerPedId()
            while inMission do
                local coords = GetEntityCoords(ped)
                local dist = #(coords - Location.ladderPos)

                if dist <= 50.0 then
                    DrawMarker(22 , Location.ladderPos.x, Location.ladderPos.y, Location.ladderPos.z + 1 ,0.0,0.0,0.0, 0.0,0.0,0.0, 2.0,1.0,2.0, 255,0,0,25, 1,0,0,1)
                    if dist <= 1.5 then
                        DrawText3D(Location.ladderPos.x, Location.ladderPos.y, Location.ladderPos.z + 1, Locales["putLadder"])
                        if IsControlJustReleased(0, 38) then
                            if ladderinHand then
                                RemoveBlip(routeBlip)
                                DoScreenFadeOut(500)
                                Wait(2000)
                                SetEntityCoords(ped, Location.roofPos)
                                TriggerServerEvent("lambra-christmas:server:climbLadder")
                                DoScreenFadeIn(2000)
                                threadOnRoof(generatedLoc)
                                return
                            else
                                TriggerEvent("lambra-christmas:notify", Locales["noLadderHand"], "error")
                            end
                            Wait(1000)
                        end
                    end
                else
                    Wait(2000)
                end
                Wait(1)
            end
        end)
    end
end)

function threadOnRoof(generatedLoc)
    local placedGift = false
    local Location = Config.Locations[generatedLoc]

    CreateThread(function()
        local ped = PlayerPedId()
        while inMission do
            local coords = GetEntityCoords(ped)
            local dist = #(coords - Location.giftPos)
            if dist <= 50.0 then
                if not placedGift then
                    DrawMarker(20 , Location.giftPos.x, Location.giftPos.y, Location.giftPos.z + 1 ,0.0,0.0,0.0, 0.0,0.0,0.0, 2.0,1.0,2.0, 0,255,0,50, 1,0,0,1)
                    if dist <= 1.5 then
                        DrawText3D(Location.giftPos.x, Location.giftPos.y, Location.giftPos.z + 1, Locales["putGift"])
                        if IsControlJustReleased(0, 38) then
                            placedGift = true
                            DoScreenFadeOut(500)
                            Wait(2000)
                            FreezeEntityPosition(ped, true)
                            NetworkSetEntityInvisibleToNetwork(ped, true)
                            TriggerServerEvent("lambra-christmas:server:deliverGift", generatedLoc)
                            DoScreenFadeIn(2000)
                            FreezeEntityPosition(ped, false)
                            NetworkSetEntityInvisibleToNetwork(ped, false)
                            threadGoDown(generatedLoc)
                            return
                        end
                    end
                end
            end

            Wait(1)
        end
    end)
end

function threadGoDown(generatedLoc)
    local Location = Config.Locations[generatedLoc]

    CreateThread(function()
        local ped = PlayerPedId()
        while inMission do
            local coords = GetEntityCoords(ped)
            local dist = #(coords - Location.roofPos)

            if dist <= 50.0 then
                DrawMarker(22 , Location.roofPos.x, Location.roofPos.y, Location.roofPos.z + 1 ,0.0,0.0,0.0, 0.0,0.0,0.0, 2.0,1.0,2.0, 255,0,0,25, 1,0,0,1)
                if dist <= 1.5 then
                    DrawText3D(Location.roofPos.x, Location.roofPos.y, Location.roofPos.z + 1, Locales["goDown"])
                    if IsControlJustReleased(0, 38) then
                        DoScreenFadeOut(500)
                        Wait(2000)
                        SetEntityCoords(ped, Location.ladderPos)
                        DoScreenFadeIn(2000)
                        inMission = false
                        TriggerEvent("lambra-christmas:notify", Locales["santaGrateful"], "success")
                        return
                    end
                end
            else
                TriggerEvent("lambra-christmas:notify", Locales["santaGrateful"], "success")
                inMission = false
                return
            end
            Wait(1)
        end
    end)
end

RegisterNetEvent("lambra-christmas:client:attachLadder", function(netid)
    local entity = NetworkGetEntityFromNetworkId(netid)
    ladderinHand = true
    StartAnim('amb@world_human_muscle_free_weights@male@barbell@idle_a', 'idle_a')
    AttachEntityToEntity(entity, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 28422), 0.05, 0.1, -0.3, 300.0, 100.0, 20.0, true, true, false, true, 1, true)
end)

RegisterNetEvent("lambra-christmas:client:dettachLadder", function()
    ladderinHand = false
    ClearPedTasks(PlayerPedId())
end)

--[[MENU]]
function openMenu()
    menuOpened = true

    local menu = {
        {
            header = Locales["helpSanta"],
            params = {
                event = "lambra-christmas:client:menu:helpSanta",
            }
        }
    }

    menu[#menu+1] = {
        header = Locales["tradeSocks"],
        params = {
            event = "lambra-christmas:client:menu:tradeSocks",
        }
    }

    menu[#menu+1] = {
        header = Locales["santaBoostMenu"],
        txt = Locales["santaBoostDesc"],
        params = {
            isServer = true,
            event = "lambra-christmas:server:menu:checkSantaBoost",
        }
    }

    exports["qb-menu"]:openMenu(menu)

    CreateThread(function()
        while IsNuiFocused() do Wait(500) end
        menuOpened = false
    end)
end
RegisterNetEvent("lambra-christmas:client:menu:helpSanta", function()
    if isHoursAllowed() then
        TriggerServerEvent("lambra-christmas:server:helpSanta")
    else
        TriggerEvent("lambra-christmas:notify", Locales["notAllowedHours"], "error") 
    end
end)
RegisterNetEvent("lambra-christmas:client:menu:tradeSocks", function()
    Wait(500)
    menuOpened = true

    local menu = {
        {
            header = Locales["tradingTitle"],
            isMenuHeader = true
        }
    }

    for item, data in pairs(Config.Trades) do
        menu[#menu+1] = {
            header = "<img src=nui://qb-inventory/html/images/"..QBCore.Shared.Items[item].image.." width=35px style='margin-right: 10px'> "..QBCore.Shared.Items[item].label,
            txt = Locales["tradingDescRequired"]..data.socksRequired..Locales["tradingDescAmount"]..data.giveAmount,
            params = {
                isServer = true,
                event = "lambra-christmas:server:tradeSocks",
                args = {
                    selected = item
                }
            }
        }
    end

    exports["qb-menu"]:openMenu(menu)

    CreateThread(function()
        while IsNuiFocused() do Wait(500) end
        menuOpened = false
    end)
end)


--[[FUNCTIONS]]
function isHoursAllowed()
    if GetClockHours() >= Config.helpHours.min or GetClockHours() <= Config.helpHours.max then return true end
    return false
end
function isWearingHat()
    if not Config.xmasHat.forceUse then return true end

    local curHat = GetPedPropIndex(PlayerPedId(), 0)
    if curHat == Config.xmasHat.maleHat or curHat == Config.xmasHat.femaleHat then return true end

    return false
end
function StartAnim(lib, anim)
    while not HasAnimDictLoaded(lib) do
        RequestAnimDict(lib)
        Wait(100)
    end
    CreateThread(function()
        while ladderinHand do
            if not IsEntityPlayingAnim(PlayerPedId(), lib, anim, 3) then
                TaskPlayAnim(PlayerPedId(), lib, anim ,8.0, -8.0, -1, 50, 0, false, false, false)
            end
            Wait(1000)
        end
    end)
end