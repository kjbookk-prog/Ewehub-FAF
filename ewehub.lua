-- Memuat Library EWEHUB (v4.2.0)
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

-- DAFTAR NAMA ITEM 
local DaftarGears = {
    "BasicAutoFeeder", "FoodScoop", "BasicFoodTray", "NetMover", 
    "MagnifyingGlass", "AdvancedFoodTray", "AdvancedAutoFeeder", 
    "XpCookie", "TeleportWand", "StarLock", "SupremeAutoFeeder","SupremeFoodTray",
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

local FolderName = "AutoHubConfigs"
if not isfolder(FolderName) then makefolder(FolderName) end

-- Fungsi untuk mengambil daftar config
local function GetSavedConfigs()
    local configs = {}
    if isfolder(FolderName) then
        for _, file in ipairs(listfiles(FolderName)) do
            local fileName = file:match("([^/\\]+)%.json$")
            if fileName then table.insert(configs, fileName) end
        end
    end
    return #configs == 0 and {"Kosong"} or configs
end

-- Koordinat baru sesuai remote spy terbaru
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

-- ==========================================
-- TAB 6: KONFIG
-- ==========================================
local TabKonfig = Window:CreateTab({ Name = "Konfig", Icon = "💾" })

local NewConfigName = ""
local SelectedDropdownConfig = ""

TabKonfig:CreateTextbox({
    Name = "Nama Config Baru",
    Placeholder = "Ketik nama...",
    Default = "",
    Flag = "NewConfigTextbox",
    Callback = function(Text) 
        NewConfigName = Text 
    end,
})

local ConfigDropdown

TabKonfig:CreateButton({
    Name = "Create SC (Buat Baru)",
    Callback = function()
        if NewConfigName == "" or NewConfigName == "Kosong" then return end
        local HttpService = game:GetService("HttpService")
        local dataToSave = {
            SavedLoopTime = Settings.LoopTime,
            SavedPlace = Settings.SelectedPlace,
            SavedFoodTray = Settings.SelectedFoodTray,
            SavedGears = Settings.SelectedGears,
            SavedBaits = Settings.SelectedBaits,
            SavedEggs = Settings.SelectedEggs
        }
        writefile(FolderName .. "/" .. NewConfigName .. ".json", HttpService:JSONEncode(dataToSave))
        EWEHUB:Notify({Title = "Berhasil!", Content = "Config dibuat.", Duration = 3})
        ConfigDropdown.SetOptions(GetSavedConfigs())
    end,
})

local InitialConfigs = GetSavedConfigs()
ConfigDropdown = TabKonfig:CreateDropdown({
    Name = "Pilih Config",
    Options = InitialConfigs,
    Default = InitialConfigs[1],
    Multi = false,
    Flag = "SavedConfigs",
    Callback = function(Selected) 
        SelectedDropdownConfig = Selected 
    end,
})

TabKonfig:CreateButton({
    Name = "Overwrite Terpilih",
    Callback = function()
        if SelectedDropdownConfig == "" or SelectedDropdownConfig == "Kosong" then return end
        local HttpService = game:GetService("HttpService")
        local dataToSave = {
            SavedLoopTime = Settings.LoopTime,
            SavedPlace = Settings.SelectedPlace,
            SavedFoodTray = Settings.SelectedFoodTray,
            SavedGears = Settings.SelectedGears,
            SavedBaits = Settings.SelectedBaits,
            SavedEggs = Settings.SelectedEggs
        }
        writefile(FolderName .. "/" .. SelectedDropdownConfig .. ".json", HttpService:JSONEncode(dataToSave))
        EWEHUB:Notify({Title = "Overwritten!", Content = "Config diperbarui.", Duration = 3})
    end,
})

TabKonfig:CreateButton({
    Name = "Muat (Load) Terpilih",
    Callback = function()
        if SelectedDropdownConfig == "" or SelectedDropdownConfig == "Kosong" then return end
        local filePath = FolderName .. "/" .. SelectedDropdownConfig .. ".json"
        if isfile(filePath) then
            local decodedData = game:GetService("HttpService"):JSONDecode(readfile(filePath))
            
            Settings.LoopTime = decodedData.SavedLoopTime or 0.1
            Settings.SelectedPlace = decodedData.SavedPlace or "1"
            Settings.SelectedFoodTray = decodedData.SavedFoodTray or "SupremeFoodTray"
            Settings.SelectedGears = decodedData.SavedGears or {}
            Settings.SelectedBaits = decodedData.SavedBaits or {}
            Settings.SelectedEggs = decodedData.SavedEggs or {}
            
            LoopTimeSlider.Set(Settings.LoopTime)
            HomePlaceDropdown.Set(Settings.SelectedPlace)
            FoodTrayDropdown.Set(Settings.SelectedFoodTray)
            GearDropdownUI.Set(Settings.SelectedGears)
            BaitDropdownUI.Set(Settings.SelectedBaits)
            EggDropdownUI.Set(Settings.SelectedEggs)
            
            EWEHUB:Notify({Title = "Berhasil Dimuat!", Content = "Config digunakan.", Duration = 3})
        end
    end,
})
