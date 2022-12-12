if not string.match(GetCurrentResourceName(), "lambra") then
    print("Resource can not be started. Reason: lambra prefix not found")
    return
end
local QBCore = exports["qb-core"]:GetCoreObject()

local inMission = {}
local ladders = {}
local availableReward = {}
local playersBoosted = {}

QBCore.Functions.CreateUseableItem("santaladder", function(source, item)
  local src = source

  if not inMission[src] then TriggerClientEvent("lambra-christmas:notify", src, Locales["cantUseLadder"], "error") return end

  if not ladders[src] then
    local coords = GetEntityCoords(GetPlayerPed(src))
    local entity = CreateObjectNoOffset(GetHashKey("prop_byard_ladder01"), vector3(coords.x, coords.y, coords.z), true, true, false)
    ladders[src] = NetworkGetNetworkIdFromEntity(entity)
    Wait(100)
    TriggerClientEvent("lambra-christmas:client:attachLadder", src, ladders[src])
  else
    local entity = NetworkGetEntityFromNetworkId(ladders[src])
    DeleteEntity(entity)
    ladders[src] = nil
    TriggerClientEvent("lambra-christmas:client:dettachLadder", src)
  end
end)

RegisterNetEvent("lambra-christmas:server:helpSanta", function()
  local src = source
  local Player = QBCore.Functions.GetPlayer(src)

  if inMission[src] then TriggerClientEvent("lambra-christmas:notify", src, Locales["alreadyStarted"], "error") return end
  math.randomseed(os.time())
  local generatedLoc = math.random(1, #Config.Locations)
  inMission[src] = generatedLoc

  local haveLadder = Player.Functions.GetItemByName("santaladder")
  if not haveLadder then
    Player.Functions.AddItem("santaladder", 1)
  end

  TriggerClientEvent("lambra-christmas:client:helpSanta", src, generatedLoc)
end)

RegisterNetEvent("lambra-christmas:server:climbLadder", function()
  local src = source
  
  if ladders[src] then
    local entity = NetworkGetEntityFromNetworkId(ladders[src])
    DeleteEntity(entity)
    ladders[src] = nil
    availableReward[src] = true
    TriggerClientEvent("lambra-christmas:client:dettachLadder", src)
  end
end)

RegisterNetEvent("lambra-christmas:server:deliverGift", function(locInteracted)
  local src = source
  if not availableReward[src] then return end
  if locInteracted ~= inMission[src] then return end

  inMission[src] = nil
  availableReward[src] = nil

  local Player = QBCore.Functions.GetPlayer(src)
  local isPlayerBoosted = playersBoosted[src] or false

  math.randomseed(os.time())
  local amount = math.random(Config.Socks.min, Config.Socks.max)
  if isPlayerBoosted then amount = amount + Config.SantaBoost.extraSocks end
  playersBoosted[src] = nil

  Player.Functions.AddItem("santasocks", amount)
  TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items["santasocks"], "add")
  TriggerClientEvent("lambra-christmas:notify", src , Locales["receivedSocks"])
end)

RegisterNetEvent("lambra-christmas:server:menu:checkSantaBoost", function()
  local src = source
  if playersBoosted[src] then TriggerClientEvent("lambra-christmas:notify", src , Locales["boostAlreadyActive"], "error") return end

  local Player = QBCore.Functions.GetPlayer(src)

  if Player.Functions.RemoveItem("santasocks", Config.SantaBoost.socksRequired) then
    local duration = Config.SantaBoost.duration * 60000
    playersBoosted[src] = true
    TriggerClientEvent("lambra-christmas:notify", src, Locales["santaBoostActive"], "success")
    SetTimeout(duration, function()
      playersBoosted[src] = nil
      TriggerClientEvent("lambra-christmas:notify", src , Locales["santaBoostOver"], "error")
    end)
  else
    TriggerClientEvent("lambra-christmas:notify", src , Locales["noSocksBoost"], "error")
  end
end)

RegisterNetEvent("lambra-christmas:server:tradeSocks", function(data)
  local src = source
  local item = Config.Trades[data.selected]
  if not item then return end

  local Player = QBCore.Functions.GetPlayer(src)

  if Player.Functions.RemoveItem("santasocks", item.socksRequired) then
    Player.Functions.AddItem(data.selected, item.giveAmount)
    TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[data.selected], "add")
    TriggerClientEvent("lambra-christmas:notify", src , Locales["successTrade"])
  else
    TriggerClientEvent("lambra-christmas:notify", src , Locales["noSocksBoost"], "error")
  end
end)