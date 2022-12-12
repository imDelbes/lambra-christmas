Config = {}

Config.interactionCoords = vector3(196.84, -994.59, 30.09)

Config.helpHours = {min = 22, max = 5} --24 hour format ( This will only allow players to help between 22h night to 5h at morning at default settings)

Config.Socks = {min = 1, max = 3} --The amount of socks player will get for each help

Config.xmasHat = {
    forceUse = true, --if the players should be wearing the santa hat to interact
    maleHat = 22,
    femaleHat = 23
}

Config.SantaBoost = {
    socksRequired = 50,
    duration = 60, --time in minutes
    extraSocks = 10 -- How many extra socks player will get
}

Config.Trades = {
    --You can add more items
    ["phone"] = {socksRequired = 2, giveAmount = 1},
    ["rolex"] = {socksRequired = 3, giveAmount = 1},
    ["diamond_ring"] = {socksRequired = 5, giveAmount = 2},
    ["goldchain"] = {socksRequired = 8, giveAmount = 3},
    ["10kgoldchain"] = {socksRequired = 20, giveAmount = 1},
    ["goldbar"] = {socksRequired = 15, giveAmount = 1},
}

Config.Locations = {
    --You can add more Locations
    {ladderPos = vector3(-366.16, 346.61, 109.36),  roofPos = vector3(-366.12, 344.55, 113.78),  giftPos = vector3(-365.85, 337.99, 115.81)},
    {ladderPos = vector3(-466.06, 414.20, 103.12),  roofPos = vector3(-466.27, 415.26, 106.42),  giftPos = vector3(-464.34, 419.09, 106.99)},
    {ladderPos = vector3(-344.96, 368.29, 110.03),  roofPos = vector3(-344.39, 366.78, 114.14),  giftPos = vector3(-338.02, 358.62, 116.13)},
    {ladderPos = vector3(-84.15, 432.82, 113.13),   roofPos = vector3(-82.8, 434.21, 117.4),     giftPos = vector3(-70.19, 435.23, 120.64)},
    {ladderPos = vector3(-545.54, 548.46, 110.6),   roofPos = vector3(-546.81, 548.87, 114.03),  giftPos = vector3(-560.2, 542.91, 114.48)},
}



Locales = {
    ["bliptitle"] = "Santa Claus",
    ["talkWithSanta"] = "Press [~o~E~w~] to talk with ~r~Santa",
    ["notWearingHat"] = "Before you talk to me, go and get a Santa Hat",
    ["helpSanta"] = "[🎅] Help Santa with gifts",
    ["notAllowedHours"] = "Come back only at night time",
    ["alreadyStarted"] = "You have to finish your current request from Santa",
    ["goToLocation"] = "Go the house at your GPS, and drop a gift from the chimney",
    ["putLadder"] = "Press [~o~E~w~] to climb",
    ["noLadderHand"] = "You dont have a ladder in your hands",
    ["cantUseLadder"] = "You cant use this now",
    ["putGift"] = "Press [~o~E~w~] deliver the gift",
    ["receivedSocks"] = "You picked up the hanging socks that were for Santa.",
    ["goDown"] = "Press [~o~E~w~] to go down",
    ["santaGrateful"] = "Santa is grateful for your effort",
    ["santaBoostMenu"] = "[⭐] Get Santa's Boost",
    ["santaBoostDesc"] = "<br>🧦 Required: "..Config.SantaBoost.socksRequired.."<br>⏱️ Duration: "..Config.SantaBoost.duration.."min",
    ["boostAlreadyActive"] = "You already have the Santa boost active",
    ["noSocksBoost"] = "You dont have enough socks to get that",
    ["santaBoostActive"] = "You activated Santa Boost.",
    ["santaBoostOver"] = "Your Santa Boost has expired",
    ["tradeSocks"] = "[🧦] Trade Socks for rewards",
    ["tradingTitle"] = "[🧦] Trading list",
    ["tradingDescRequired"] = "<br>🧦 Socks Required: ",
    ["tradingDescAmount"] = "<br>👉 Amount given: ",
    ["successTrade"] = "You traded socks for an item"

}

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 170)
    ClearDrawOrigin()
end