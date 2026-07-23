-- Memuat Library EWEHUB (v4.3.2)
local EWEHUB = loadstring(game:HttpGet("https://raw.githubusercontent.com/kjbookk-prog/Ewhub-repo/refs/heads/main/Library-1.lua"))()

local Window = EWEHUB:CreateWindow({
    Name = "EWEHUB | FAF",
    ToggleKey = Enum.KeyCode.RightControl,
    ForcePlayerGui = false,
    Watermark = true,
    Discord = {
        Enabled = false,
        Invite = "https://discord.gg/xxxx",
        Interval = 300,
    },
})

-- ==========================================
-- VARIABEL PENGATURAN & LIST NAMA
-- ==========================================
local Settings = {
    LoopTime = 0.1, 
    SelectedPlace = "1",
    SelectedFoodTray = "SupremeFoodTray",
    AutoPlaceEnabled = false,
    
    FeedDrFalloutEnabled = false,
    FeedGeneralEnabled = false,
    AutoOpenNukeEnabled = false,
    
    SelectedGears = {},
    AutoBuyGearEnabled = false,
    
    SelectedBaits = {},
    AutoBuyBaitEnabled = false,
    
    SelectedEggs = {},
    AutoBuyEggEnabled = false
}

-- Daftarkan variabel kustom ke sistem config v4.3.x agar ikut tersimpan & dimuat
EWEHUB:RegisterConfigField("LoopTime", function() return Settings.LoopTime end, function(v) Settings.LoopTime = v end)
EWEHUB:RegisterConfigField("SelectedPlace", function() return Settings.SelectedPlace end, function(v) Settings.SelectedPlace = v end)
EWEHUB:RegisterConfigField("SelectedFoodTray", function() return Settings.SelectedFoodTray end, function(v) Settings.SelectedFoodTray = v end)
EWEHUB:RegisterConfigField("SelectedGears", function() return Settings.SelectedGears end, function(v) Settings.SelectedGears = v end)
EWEHUB:RegisterConfigField("SelectedBaits", function() return Settings.SelectedBaits end, function(v) Settings.SelectedBaits = v end)
EWEHUB:RegisterConfigField("SelectedEggs", function() return Settings.SelectedEggs end, function(v) Settings.SelectedEggs = v end)

-- DAFTAR NAMA ITEM 
local DaftarGears = {
    "BasicAutoFeeder", "FoodScoop", "BasicFoodTray", "MoveTool", 
    "MagnifyingGlass", "AdvancedFoodTray", "AdvancedAutoFeeder", 
    "XPCookie", "TeleportWand", "StarLock", "SupremeAutoFeeder", 
    "PetToy", "TradingTicket", "EggHatcher", "PetWhistle", 
    "GoldenCookie", "MutationBeacon", "EggIncubator", 
    "ExtremeAutoFeeder", "StormHorn", "GodlyAutoFeeder"
} 

local DaftarBaits = {
    "Starter", "Novice", "Reef", "DeepSea", "Koi", "River", 
    "Puffer", "Glo", "Seal", "Ray", "Octopus", "Axolotl", 
    "Jelly", "Whale", "Shark", "Squid", "Megalodon", 
    "Kraken", "Maw", "Bloop", "OceanEater", "Serpent"
}

local DaftarEggs = {
    "Starter", "Basic", "Forest", "Polar", "Tropical", "Exotic"
}

-- Koordinat sesuai remote spy terbaru
local PlaceCoordinates = {
    ["1"] = vector.create(-130.63699340820312, -0.012000083923339844, -355.5),
    ["2"] = vector.create(12.362998962402344, -0.012000083923339844, -300.5),
    ["3"] = vector.create(-131.63699340820312, -0.012000083923339844, -207.5),
    ["4"] = vector.create(28.362998962402344, -0.012000083923339844, -114.5),
    ["5"] = vector.create(-125.13700103759766, -0.012000083923339844, -13),
    ["6"] = vector.create(20.862998962402344, -0.012000083923339844, 32)
}

local function GetRemoteContainer()
    return game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include", 5):WaitForChild("node_modules", 5):WaitForChild("@rbxts", 5):WaitForChild("remo", 5):WaitForChild("src", 5):WaitForChild("container", 5)
end

-- ==========================================
-- TAB 1: AUTO PLACE
-- ==========================================
local Tab1 = Window:CreateTab({ Name = "Auto Place", Icon = "🏠" })

local LoopTimeSlider = Tab1:CreateSlider({
    Name = "Waktu Loop (Semua Fitur Utama)",
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
    Default = "1",
    Multi = false,
    Flag = "HomePlaceDropdown",
    Callback = function(Selected) 
        Settings.SelectedPlace = Selected 
    end,
})

local FoodTrayDropdown = Tab1:CreateDropdown({
    Name = "Pilih Food Tray",
    Options = {"SupremeFoodTray", "AdvancedFoodTray", "BasicFoodTray"},
    Default = "SupremeFoodTray",
    Multi = false,
    Flag = "FoodTrayDropdown",
    Callback = function(Selected)
        Settings.SelectedFoodTray = Selected
    end,
})

Tab1:CreateToggle({
    Name = "Mulai Auto Place",
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
local TabEvent = Window:CreateTab({ Name = "Event", Icon = "⚡" })

TabEvent:CreateToggle({
    Name = "Feed DrFallout",
    Default = false,
    Flag = "FeedDrFalloutToggle",
    Callback = function(Value)
        Settings.FeedDrFalloutEnabled = Value
        if Value then
            task.spawn(function()
                while Settings.FeedDrFalloutEnabled do
                    pcall(function() 
                        local container = GetRemoteContainer()
                        if container and container:FindFirstChild("nuke.feedDrFalloutAll") then
                            container["nuke.feedDrFalloutAll"]:FireServer() 
                        end
                    end)
                    task.wait(Settings.LoopTime)
                end
            end)
        end
    end,
})

TabEvent:CreateToggle({
    Name = "Feed General",
    Default = false,
    Flag = "FeedGeneralToggle",
    Callback = function(Value)
        Settings.FeedGeneralEnabled = Value
        if Value then
            task.spawn(function()
                while Settings.FeedGeneralEnabled do
                    pcall(function() 
                        local container = GetRemoteContainer()
                        if container and container:FindFirstChild("nuke.feedGeneralChadAll") then
                            container["nuke.feedGeneralChadAll"]:FireServer() 
                        end
                    end)
                    task.wait(Settings.LoopTime)
                end
            end)
        end
    end,
})

TabEvent:CreateToggle({
    Name = "Auto Open Nuke",
    Default = false,
    Flag = "AutoOpenNukeToggle",
    Callback = function(Value)
        Settings.AutoOpenNukeEnabled = Value
        if Value then
            task.spawn(function()
                local args = {
                    [1] = "Nuke:normal"
                }
                while Settings.AutoOpenNukeEnabled do
                    pcall(function() 
                        local container = GetRemoteContainer()
                        if container and container:FindFirstChild("store.openBaitPack") then
                            container["store.openBaitPack"]:FireServer(unpack(args)) 
                        end
                    end)
                    task.wait(12)
                end
            end)
        end
    end,
})

-- ==========================================
-- TAB 3: GEAR SHOP
-- ==========================================
local TabGear = Window:CreateTab({ Name = "Gear Shop", Icon = "⚙️" })

local GearDropdownUI = TabGear:CreateDropdown({
    Name = "Pilih Gear (Bisa Tumpuk)",
    Options = DaftarGears,
    Default = {},
    Multi = true,
    Flag = "GearDropdown",
    Callback = function(SelectedArray) 
        Settings.SelectedGears = SelectedArray 
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
local TabBait = Window:CreateTab({ Name = "Bait Shop", Icon = "🪱" })

local BaitDropdownUI = TabBait:CreateDropdown({
    Name = "Pilih Bait (Bisa Tumpuk)",
    Options = DaftarBaits,
    Default = {},
    Multi = true,
    Flag = "BaitDropdown",
    Callback = function(SelectedArray) 
        Settings.SelectedBaits = SelectedArray 
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
local TabEgg = Window:CreateTab({ Name = "Egg Shop", Icon = "🥚" })

local EggDropdownUI = TabEgg:CreateDropdown({
    Name = "Pilih Egg (Bisa Tumpuk)",
    Options = DaftarEggs,
    Default = {},
    Multi = true,
    Flag = "EggDropdown",
    Callback = function(SelectedArray) 
        Settings.SelectedEggs = SelectedArray 
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
