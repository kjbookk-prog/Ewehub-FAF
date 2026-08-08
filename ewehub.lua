-- Loading EWEHUB Library (v4.7.0)
local EWEHUB = loadstring(game:HttpGet("https://raw.githubusercontent.com/kjbookk-prog/Ewhub-repo/refs/heads/main/Library-1.lua"))()

local Window = EWEHUB:CreateWindow({
    Name = "EWEHUB | FAF",
    ToggleKey = Enum.KeyCode.RightControl,
    ForcePlayerGui = false,
    Watermark = true,
    Icon = "🚀",
    Notes = "Press the Minimize button (—) to hide the window into a draggable floating round icon.",
    Discord = {
        Enabled = false,
        Invite = "https://discord.gg/xxxx",
        Interval = 300,
    },
})

-- ==========================================
-- SETTINGS & NAME LIST VARIABLES
-- ==========================================
local Settings = {
    LoopTime = 0.1, 
    SelectedPlace = "",
    SelectedFoodTray = "",
    AutoPlaceEnabled = false,
    
    AutoOpenCrateEnabled = false,
    SelectedCrate = "",
    OpenCrateDelay = 11, -- Jeda waktu tetap 11 detik untuk auto open crate
    
    AutoBuyEventItemEnabled = false,
    SelectedEventItem = "",
    
    SelectedGears = {},
    AutoBuyGearEnabled = false,
    
    SelectedBaits = {},
    AutoBuyBaitEnabled = false,
    
    SelectedEggs = {},
    AutoBuyEggEnabled = false,
    
    SelectedTravelingItems = {},
    AutoBuyTravelingEnabled = false,
    
    SelectedCosmetics = {},
    AutoBuyCosmeticEnabled = false
}

-- Register custom variables to the v4.7.0 config system to save & load properly
EWEHUB:RegisterConfigField("LoopTime", function() return Settings.LoopTime end, function(v) Settings.LoopTime = v end)
EWEHUB:RegisterConfigField("SelectedPlace", function() return Settings.SelectedPlace end, function(v) Settings.SelectedPlace = v end)
EWEHUB:RegisterConfigField("SelectedFoodTray", function() return Settings.SelectedFoodTray end, function(v) Settings.SelectedFoodTray = v end)
EWEHUB:RegisterConfigField("SelectedCrate", function() return Settings.SelectedCrate end, function(v) Settings.SelectedCrate = v end)
EWEHUB:RegisterConfigField("OpenCrateDelay", function() return Settings.OpenCrateDelay end, function(v) Settings.OpenCrateDelay = v end)
EWEHUB:RegisterConfigField("SelectedEventItem", function() return Settings.SelectedEventItem end, function(v) Settings.SelectedEventItem = v end)
EWEHUB:RegisterConfigField("SelectedGears", function() return Settings.SelectedGears end, function(v) Settings.SelectedGears = v end)
EWEHUB:RegisterConfigField("SelectedBaits", function() return Settings.SelectedBaits end, function(v) Settings.SelectedBaits = v end)
EWEHUB:RegisterConfigField("SelectedEggs", function() return Settings.SelectedEggs end, function(v) Settings.SelectedEggs = v end)
EWEHUB:RegisterConfigField("SelectedTravelingItems", function() return Settings.SelectedTravelingItems end, function(v) Settings.SelectedTravelingItems = v end)
EWEHUB:RegisterConfigField("SelectedCosmetics", function() return Settings.SelectedCosmetics end, function(v) Settings.SelectedCosmetics = v end)

-- ==========================================
-- ITEM NAME LISTS (REAL & DISPLAY MAPPING)
-- *Ubah teks di bagian Daftar...Display sesuai keinginan Anda*
-- ==========================================

-- GEARS (Contoh: Beberapa diubah nama display-nya)
local DaftarGearsReal = {
    "BasicAutoFeeder", "FoodScoop", "BasicFoodTray", "NetMover", 
    "MagnifyingGlass", "AdvancedFoodTray", "AdvancedAutoFeeder", 
    "XpCookie", "SupremeFoodTray", "TeleportWand", "StarLock", "SupremeAutoFeeder", 
    "PetToy", "TradingTicket", "EggHatcher", "PetWhistle", 
    "GoldenCookie", "MutationBeacon", "EggIncubator", 
    "ExtremeAutoFeeder", "StormHorn", "GodlyAutoFeeder"
} 
local DaftarGearsDisplay = {
    "Auto Feeder Basic", "Food Scoop", "Basic Food Tray", "Move Tool", 
    "Magnifying Glass", "Advanced Food Tray", "Advanced Auto Feeder", 
    "Xp Cookie", "Supreme Food Tray", "Teleport Wand", "Star Lock", "Supreme Auto Feeder", 
    "Pet Toy", "Trading Ticket", "Egg Hatcher", "Pet Whistle", 
    "Golden Cookie", "Mutation Beacon", "Egg Incubator", 
    "Extreme Auto Feeder", "Storm Horn", "Godly Auto Feeder"
}

-- BAITS (Maja diubah jadi Maw di Display)
local DaftarBaitsReal = {
    "Starter", "Novice", "Reef", "DeepSea", "Koi", "River", 
    "Puffer", "Glo", "Seal", "Ray", "Octopus", "Axolotl", 
    "Jelly", "Whale", "Shark", "Squid", "Megalodon", 
    "Kraken", "Maja", "Bloop", "OceanEater", "Serpent", "DoomRex"
}
local DaftarBaitsDisplay = {
    "Starter", "Novice", "Reef", "DeepSea", "Koi", "River", 
    "Puffer", "Glo", "Seal", "Ray", "Octopus", "Axolotl", 
    "Jelly", "Whale", "Shark", "Squid", "Megalodon", 
    "Kraken", "Maw", "Bloop", "OceanEater", "Serpent", "DoomRex"
}

-- EGGS (Contoh: Starter diubah jadi Telur Awal)
local DaftarEggsReal = {
    "Starter", "Basic", "Forest", "Polar", "Tropical", "Exotic"
}
local DaftarEggsDisplay = {
    "starter", "Basic", "Forest", "Polar", "Tropical", "Exotic"
}

-- TRAVELING ITEMS
local DaftarTravelingItemsReal = {
    "Zoo", "Wild", "Boba", "Punk", "PetTag", "Ashen"
}
local DaftarTravelingItemsDisplay = {
    "Zoo", "Wild Egg", "Boba Egg", "Punk", "Pet Tag", "Ashen"
}

-- COSMETICS
local DaftarCosmeticsReal = {
    "AtlantisLightPole", "AtlantisBanner", "TridentThrone", "KingThrone", "PixelLilypad", "PixelLotus", "PixelTree", "PixelArcade", "CandyCane", "ChristmasLamp", "IceFishing", "SnowGlobe", "Snowman", "SantaChair", "ChristmasTree", "Minicano", "RunePillar", "AshFlame", "Dragon", "LavaThrone", "Cannon", "PirayeFlag", "CrowNest", "Tower", "FlowerBush", "EasterEgg", "MarshmallowCane", "MarshmallowTree", "MrBunny", "DinoEgg", "DinoSkull", "DinoBones", "JurrasicTree", "MoonLamp", "AlienSign", "GloShrooms", "AlienPod", "AlienLamp", "AlienTree", "UfoStatue", "LilyPad", "Bamboo", "ZenRocks", "JapaneseLantern", "ZenLantern", "BlossomTree", "ZenTower", "HeroSign", "HeroBush", "HeroBanner", "TallBuilding", "Building", "HeroBase", "Teloporter", "TikiTorch", "Leafy", "TallLeafy", "TikiTotem", "PalmTree", "TikiHut", "TikiHouse", "ShadowGrass", "ShadowShroom", "ShadowTorch", "ShadowQueen", "HoloBanner", "RobotAntena", "RobotLighpole", "LaunchPad", "MechStatue"
}
local DaftarCosmeticsDisplay = {
    "AtlantisLightPole", "AtlantisBanner", "TridentThrone", "KingThrone", "PixelLilypad", "PixelLotus", "PixelTree", "PixelArcade", "CandyCane", "ChristmasLamp", "IceFishing", "SnowGlobe", "Snowman", "SantaChair", "ChristmasTree", "Minicano", "RunePillar", "AshFlame", "Dragon", "LavaThrone", "Cannon", "PirayeFlag", "CrowNest", "Tower", "FlowerBush", "EasterEgg", "MarshmallowCane", "MarshmallowTree", "MrBunny", "DinoEgg", "DinoSkull", "DinoBones", "JurrasicTree", "MoonLamp", "AlienSign", "GloShrooms", "AlienPod", "AlienLamp", "AlienTree", "UfoStatue", "LilyPad", "Bamboo", "ZenRocks", "JapaneseLantern", "ZenLantern", "BlossomTree", "ZenTower", "HeroSign", "HeroBush", "HeroBanner", "TallBuilding", "Building", "HeroBase", "Teloporter", "TikiTorch", "Leafy", "TallLeafy", "TikiTotem", "PalmTree", "TikiHut", "TikiHouse", "ShadowGrass", "ShadowShroom", "ShadowTorch", "ShadowQueen", "HoloBanner", "RobotAntena", "RobotLighpole", "LaunchPad", "MechStatue"
}

-- CRATES
local DaftarCratesReal = {
    "Nuke",
    "Cartoon"
}
local DaftarCratesDisplay = {
    "Nuke",
    "Cartoon"
}

-- EVENT ITEMS
local DaftarEventItemsReal = {
    "Cartoon", "egg:Cartoon"
}
local DaftarEventItemsDisplay = {
    "Cartoon create", "Cartoon egg"
}

-- Updated Coordinates
local PlaceCoordinates = {
    ["1"] = Vector3.new(-141.13600158691406, -0.012000083923339844, 361),
    ["2"] = Vector3.new(21.863998413085938, -0.012000083923339844, 306),
    ["3"] = Vector3.new(16.863998413085938, -0.012000083923339844, 127),
    ["4"] = Vector3.new(-135.13600158691406, -0.012000083923339844, 125),
    ["5"] = Vector3.new(14.863998413085938, -0.012000083923339844, 14),
    ["6"] = Vector3.new(-135.13600158691406, -0.012000083923339844, 14)
}

local EventAreaCoordinate = Vector3.new(0.53, 9.65, 13.83)

local function GetRemoteContainer()
    return game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include", 5):WaitForChild("node_modules", 5):WaitForChild("@rbxts", 5):WaitForChild("remo", 5):WaitForChild("src", 5):WaitForChild("container", 5)
end

-- Helper function untuk mencocokkan nama Display kembali ke nama Real
local function GetRealName(displayName, displayList, realList)
    for i, name in ipairs(displayList) do
        if name == displayName then
            return realList[i]
        end
    end
    return displayName
end

-- ==========================================
-- TAB 1: AUTO PLACE
-- ==========================================
local Tab1 = Window:CreateTab({ 
    Name = "Auto Place", 
    Icon = "🏠",
    Notes = "Note: This feature is still under development and currently only works fully on Codex executor. Support for other executors is being worked on."
})

local LoopTimeSlider = Tab1:CreateSlider({
    Name = "Loop Time (All Main Features)",
    Min = 0.01, Max = 10,
    Default = Settings.LoopTime,
    Round = false,
    Flag = "LoopTimeSlider",
    Callback = function(Value) 
        Settings.LoopTime = Value 
    end,
})

local HomePlaceDropdown = Tab1:CreateDropdown({
    Name = "Home Place",
    Options = {"1", "2", "3", "4", "5", "6"},
    Default = "",
    Multi = false,
    Flag = "HomePlaceDropdown",
    Callback = function(Selected) 
        Settings.SelectedPlace = Selected 
    end,
})

local FoodTrayDropdown = Tab1:CreateDropdown({
    Name = "Select Food Tray",
    Options = {"SupremeFoodTray", "AdvancedFoodTray", "BasicFoodTray"},
    Default = "",
    Multi = false,
    Flag = "FoodTrayDropdown",
    Callback = function(Selected)
        Settings.SelectedFoodTray = Selected
    end,
})

Tab1:CreateToggle({
    Name = "Start Auto Place",
    Default = false,
    Flag = "AutoPlaceToggle",
    Callback = function(Value)
        Settings.AutoPlaceEnabled = Value
        if Value then
            task.spawn(function()
                while Settings.AutoPlaceEnabled do
                    local pos = PlaceCoordinates[Settings.SelectedPlace]
                    if pos then
                        pcall(function() 
                            local container = GetRemoteContainer()
                            if container and container:FindFirstChild("ponds.placeBuilding") then
                                container["ponds.placeBuilding"]:InvokeServer("booster", Settings.SelectedFoodTray, pos)
                            end
                        end)
                    end
                    task.wait(Settings.LoopTime)
                end
            end)
        end
    end,
})

-- ==========================================
-- TAB 2: EVENT
-- ==========================================
local TabEvent = Window:CreateTab({ 
    Name = "Event", 
    Icon = "⚡",
    Notes = "Automatic event features for opening crates and purchasing event items."
})

TabEvent:CreateButton({
    Name = "Teleport to Event Area",
    Callback = function()
        pcall(function()
            local player = game:GetService("Players").LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = CFrame.new(EventAreaCoordinate)
            end
        end)
    end,
})

local CrateDropdown = TabEvent:CreateDropdown({
    Name = "Select Crate",
    Options = DaftarCratesDisplay,
    Default = "",
    Multi = false,
    Flag = "CrateDropdown",
    Callback = function(Selected)
        Settings.SelectedCrate = GetRealName(Selected, DaftarCratesDisplay, DaftarCratesReal)
    end,
})

TabEvent:CreateToggle({
    Name = "Auto Open Crate",
    Default = false,
    Flag = "AutoOpenCrateToggle",
    Callback = function(Value)
        Settings.AutoOpenCrateEnabled = Value
        if Value then
            task.spawn(function()
                while Settings.AutoOpenCrateEnabled do
                    if Settings.SelectedCrate ~= "" then
                        local args = {
                            [1] = Settings.SelectedCrate .. ":normal"
                        }
                        pcall(function() 
                            local container = GetRemoteContainer()
                            if container and container:FindFirstChild("store.openBaitPack") then
                                container["store.openBaitPack"]:FireServer(unpack(args)) 
                            end
                        end)
                    end
                    task.wait(Settings.OpenCrateDelay)
                end
            end)
        end
    end,
})

local EventItemDropdown = TabEvent:CreateDropdown({
    Name = "Select Event Item",
    Options = DaftarEventItemsDisplay,
    Default = "",
    Multi = false,
    Flag = "EventItemDropdown",
    Callback = function(Selected)
        Settings.SelectedEventItem = GetRealName(Selected, DaftarEventItemsDisplay, DaftarEventItemsReal)
    end,
})

TabEvent:CreateToggle({
    Name = "Auto Buy Event Item",
    Default = false,
    Flag = "AutoBuyEventItemToggle",
    Callback = function(Value)
        Settings.AutoBuyEventItemEnabled = Value
        if Value then
            task.spawn(function()
                while Settings.AutoBuyEventItemEnabled do
                    if Settings.SelectedEventItem ~= "" then
                        local args = {
                            [1] = "baitpack:" .. Settings.SelectedEventItem
                        }
                        pcall(function() 
                            local container = GetRemoteContainer()
                            if container and container:FindFirstChild("shop.purchaseEventItem") then
                                container["shop.purchaseEventItem"]:FireServer(unpack(args)) 
                            end
                        end)
                    end
                    task.wait(Settings.LoopTime)
                end
            end)
        end
    end,
})

-- ==========================================
-- TAB 3: GEAR SHOP
-- ==========================================
local TabGear = Window:CreateTab({ 
    Name = "Gear Shop", 
    Icon = "⚙️",
    Notes = "Select multiple gears simultaneously using the Multi-select dropdown."
})

local GearDropdownUI = TabGear:CreateDropdown({
    Name = "Select Gear (Stackable)",
    Options = DaftarGearsDisplay,
    Default = {},
    Multi = true,
    Flag = "GearDropdown",
    Callback = function(SelectedArray) 
        local realArray = {}
        for _, dispName in ipairs(SelectedArray) do
            table.insert(realArray, GetRealName(dispName, DaftarGearsDisplay, DaftarGearsReal))
        end
        Settings.SelectedGears = realArray 
    end,
})

TabGear:CreateToggle({
    Name = "Auto Buy Gear",
    Default = false,
    Flag = "AutoBuyGearToggle",
    Callback = function(Value)
        Settings.AutoBuyGearEnabled = Value
        if Value then
            task.spawn(function()
                while Settings.AutoBuyGearEnabled do
                    for _, gearName in ipairs(Settings.SelectedGears) do
                        pcall(function() 
                            local container = GetRemoteContainer()
                            if container and container:FindFirstChild("shop.purchaseGear") then
                                container["shop.purchaseGear"]:FireServer(gearName) 
                            end
                        end)
                        task.wait(0.01)
                    end
                    task.wait(Settings.LoopTime)
                end
            end)
        end
    end,
})

-- ==========================================
-- TAB 4: BAIT SHOP
-- ==========================================
local TabBait = Window:CreateTab({ 
    Name = "Bait Shop", 
    Icon = "🪱",
    Notes = "Select multiple baits simultaneously using the Multi-select dropdown."
})

local BaitDropdownUI = TabBait:CreateDropdown({
    Name = "Select Bait (Stackable)",
    Options = DaftarBaitsDisplay,
    Default = {},
    Multi = true,
    Flag = "BaitDropdown",
    Callback = function(SelectedArray) 
        local realArray = {}
        for _, dispName in ipairs(SelectedArray) do
            table.insert(realArray, GetRealName(dispName, DaftarBaitsDisplay, DaftarBaitsReal))
        end
        Settings.SelectedBaits = realArray 
    end,
})

TabBait:CreateToggle({
    Name = "Auto Buy Bait",
    Default = false,
    Flag = "AutoBuyBaitToggle",
    Callback = function(Value)
        Settings.AutoBuyBaitEnabled = Value
        if Value then
            task.spawn(function()
                while Settings.AutoBuyBaitEnabled do
                    for _, baitName in ipairs(Settings.SelectedBaits) do
                        pcall(function() 
                            local container = GetRemoteContainer()
                            if container and container:FindFirstChild("shop.purchaseBait") then
                                container["shop.purchaseBait"]:FireServer(baitName) 
                            end
                        end)
                        task.wait(0.01)
                    end
                    task.wait(Settings.LoopTime)
                end
            end)
        end
    end,
})

-- ==========================================
-- TAB 5: EGG SHOP
-- ==========================================
local TabEgg = Window:CreateTab({ 
    Name = "Egg Shop", 
    Icon = "🥚",
    Notes = "Select multiple eggs simultaneously using the Multi-select dropdown."
})

local EggDropdownUI = TabEgg:CreateDropdown({
    Name = "Select Egg (Stackable)",
    Options = DaftarEggsDisplay,
    Default = {},
    Multi = true,
    Flag = "EggDropdown",
    Callback = function(SelectedArray) 
        local realArray = {}
        for _, dispName in ipairs(SelectedArray) do
            table.insert(realArray, GetRealName(dispName, DaftarEggsDisplay, DaftarEggsReal))
        end
        Settings.SelectedEggs = realArray 
    end,
})

TabEgg:CreateToggle({
    Name = "Auto Buy Egg",
    Default = false,
    Flag = "AutoBuyEggToggle",
    Callback = function(Value)
        Settings.AutoBuyEggEnabled = Value
        if Value then
            task.spawn(function()
                while Settings.AutoBuyEggEnabled do
                    for _, eggName in ipairs(Settings.SelectedEggs) do
                        pcall(function() 
                            local container = GetRemoteContainer()
                            if container and container:FindFirstChild("shop.purchaseEgg") then
                                container["shop.purchaseEgg"]:FireServer(eggName) 
                            end
                        end)
                        task.wait(0.01)
                    end
                    task.wait(Settings.LoopTime)
                end
            end)
        end
    end,
})

-- ==========================================
-- TAB 6: TRAVELING MERCHANT
-- ==========================================
local TabTraveling = Window:CreateTab({ 
    Name = "TravMerch", 
    Icon = "🛒",
    Notes = "Select multiple items simultaneously using the Multi-select dropdown."
})

local TravelingDropdownUI = TabTraveling:CreateDropdown({
    Name = "Select Traveling Item (Stackable)",
    Options = DaftarTravelingItemsDisplay,
    Default = {},
    Multi = true,
    Flag = "TravelingDropdown",
    Callback = function(SelectedArray) 
        local realArray = {}
        for _, dispName in ipairs(SelectedArray) do
            table.insert(realArray, GetRealName(dispName, DaftarTravelingItemsDisplay, DaftarTravelingItemsReal))
        end
        Settings.SelectedTravelingItems = realArray 
    end,
})

TabTraveling:CreateToggle({
    Name = "Auto Buy Traveling Merchant",
    Default = false,
    Flag = "AutoBuyTravelingToggle",
    Callback = function(Value)
        Settings.AutoBuyTravelingEnabled = Value
        if Value then
            task.spawn(function()
                while Settings.AutoBuyTravelingEnabled do
                    for _, itemName in ipairs(Settings.SelectedTravelingItems) do
                        pcall(function() 
                            local container = GetRemoteContainer()
                            if container and container:FindFirstChild("merchant.purchaseItem") then
                                container["merchant.purchaseItem"]:FireServer("travelling", itemName) 
                            end
                        end)
                        task.wait(0.01)
                    end
                    task.wait(Settings.LoopTime)
                end
            end)
        end
    end,
})

-- ==========================================
-- TAB 7: COSMETIC MERCHANT
-- ==========================================
local TabCosmetic = Window:CreateTab({ 
    Name = "CosMerch", 
    Icon = "✨",
    Notes = "Select multiple cosmetics simultaneously using the Multi-select dropdown."
})

local CosmeticDropdownUI = TabCosmetic:CreateDropdown({
    Name = "Select Cosmetic (Stackable)",
    Options = DaftarCosmeticsDisplay,
    Default = {},
    Multi = true,
    Flag = "CosmeticDropdown",
    Callback = function(SelectedArray) 
        local realArray = {}
        for _, dispName in ipairs(SelectedArray) do
            table.insert(realArray, GetRealName(dispName, DaftarCosmeticsDisplay, DaftarCosmeticsReal))
        end
        Settings.SelectedCosmetics = realArray 
    end,
})

TabCosmetic:CreateToggle({
    Name = "Auto Buy Cosmetic",
    Default = false,
    Flag = "AutoBuyCosmeticToggle",
    Callback = function(Value)
        Settings.AutoBuyCosmeticEnabled = Value
        if Value then
            task.spawn(function()
                while Settings.AutoBuyCosmeticEnabled do
                    for _, cosmeticName in ipairs(Settings.SelectedCosmetics) do
                        pcall(function() 
                            local container = GetRemoteContainer()
                            if container and container:FindFirstChild("cosmeticsMerchant.purchase") then
                                container["cosmeticsMerchant.purchase"]:FireServer(cosmeticName, true) 
                            end
                        end)
                        task.wait(0.01)
                    end
                    task.wait(Settings.LoopTime)
                end
            end)
        end
    end,
})
