-- Loading Obsidian Library & Addons
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true

local Window = Library:CreateWindow({
    Title = "EWEHUB | FAF",
    Footer = "version: obsidian",
    Icon = 95816097006870,
    NotifySide = "Right",
    ShowCustomCursor = true,
})

-- ==========================================
-- SETTINGS & NAME LIST VARIABLES
-- ==========================================
local Settings = {
    LoopTime = 0.1, 
    SelectedFoodTray = "SupremeFoodTray",
    AutoPlaceEnabled = false,
    
    AutoOpenCrateEnabled = false,
    SelectedCrate = "",
    OpenCrateDelay = 11,
    
    AutoBuyEventItemEnabled = false,
    SelectedEventItem = "",
    
    FloatingTeleportEnabled = false,
    FloatingSellEnabled = false,
    
    AutoSubmitBee1 = false,
    AutoSubmitBee2 = false,
    AutoSubmitBee3 = false,
    
    AutoSellFishEnabled = false,
    
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

-- ==========================================
-- ITEM NAME LISTS
-- ==========================================
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

local DaftarEggsReal = { "Starter", "Basic", "Forest", "Polar", "Tropical", "Exotic" }
local DaftarEggsDisplay = { "starter", "Basic", "Forest", "Polar", "Tropical", "Exotic" }

local DaftarTravelingItemsReal = { "Zoo", "Wild", "Boba", "Punk", "PetTag", "Ashen" }
local DaftarTravelingItemsDisplay = { "Zoo", "Wild Egg", "Boba Egg", "Punk", "Pet Tag", "Ashen" }

local DaftarCosmeticsReal = {
    "AtlantisLightPole", "AtlantisBanner", "TridentThrone", "KingThrone", "PixelLilypad", "PixelLotus", "PixelTree", "PixelArcade", "CandyCane", "ChristmasLamp", "IceFishing", "SnowGlobe", "Snowman", "SantaChair", "ChristmasTree", "Minicano", "RunePillar", "AshFlame", "Dragon", "LavaThrone", "Cannon", "PirayeFlag", "CrowNest", "Tower", "FlowerBush", "EasterEgg", "MarshmallowCane", "MarshmallowTree", "MrBunny", "DinoEgg", "DinoSkull", "DinoBones", "JurrasicTree", "MoonLamp", "AlienSign", "GloShrooms", "AlienPod", "AlienLamp", "AlienTree", "UfoStatue", "LilyPad", "Bamboo", "ZenRocks", "JapaneseLantern", "ZenLantern", "BlossomTree", "ZenTower", "HeroSign", "HeroBush", "HeroBanner", "TallBuilding", "Building", "HeroBase", "Teloporter", "TikiTorch", "Leafy", "TallLeafy", "TikiTotem", "PalmTree", "TikiHut", "TikiHouse", "ShadowGrass", "ShadowShroom", "ShadowTorch", "ShadowQueen", "HoloBanner", "RobotAntena", "RobotLighpole", "LaunchPad", "MechStatue"
}
local DaftarCosmeticsDisplay = DaftarCosmeticsReal

local DaftarCratesReal = { "Nuke", "Cartoon", "Bee"}
local DaftarCratesDisplay = { "Nuke", "Cartoon", "Bee"}

local DaftarEventItemsReal = { "baitpack:Bee"}
local DaftarEventItemsDisplay = { "Bee create"}

local EventAreaCoordinate = Vector3.new(0.53, 9.65, 13.83)
local AutoPlaceTargetPosition = Vector3.new(67.86299896240234, -0.012000083923339844, -11)

local function GetRemoteContainer()
    return game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include", 5):WaitForChild("node_modules", 5):WaitForChild("@rbxts", 5):WaitForChild("remo", 5):WaitForChild("src", 5):WaitForChild("container", 5)
end

local function GetRealName(displayName, displayList, realList)
    for i, name in ipairs(displayList) do
        if name == displayName then
            return realList[i]
        end
    end
    return displayName
end

-- ==========================================
-- FLOATING BUTTONS SYSTEM (TELEPORT & SELL)
-- ==========================================
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local FloatingGui = Instance.new("ScreenGui")
FloatingGui.Name = "Obsidian_FloatingButtons"
FloatingGui.Parent = CoreGui
FloatingGui.ResetOnSpawn = false
FloatingGui.Enabled = true

local TeleButton = Instance.new("TextButton")
TeleButton.Name = "TeleportButton"
TeleButton.Parent = FloatingGui
TeleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TeleButton.BorderColor3 = Color3.fromRGB(0, 170, 255)
TeleButton.BorderSizePixel = 2
TeleButton.Position = UDim2.new(0.1, 0, 0.2, 0)
TeleButton.Size = UDim2.new(0, 55, 0, 55)
TeleButton.Font = Enum.Font.SourceSansBold
TeleButton.Text = "TELE"
TeleButton.TextColor3 = Color3.fromRGB(0, 170, 255)
TeleButton.TextSize = 14
TeleButton.Visible = false

local TeleCorner = Instance.new("UICorner")
TeleCorner.CornerRadius = UDim.new(1, 0)
TeleCorner.Parent = TeleButton

TeleButton.MouseButton1Click:Connect(function()
    pcall(function()
        if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(EventAreaCoordinate)
        end
    end)
end)

local SellButton = Instance.new("TextButton")
SellButton.Name = "SellButton"
SellButton.Parent = FloatingGui
SellButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SellButton.BorderColor3 = Color3.fromRGB(255, 170, 0)
SellButton.BorderSizePixel = 2
SellButton.Position = UDim2.new(0.1, 0, 0.32, 0)
SellButton.Size = UDim2.new(0, 55, 0, 55)
SellButton.Font = Enum.Font.SourceSansBold
SellButton.Text = "SELL"
SellButton.TextColor3 = Color3.fromRGB(255, 170, 0)
SellButton.TextSize = 14
SellButton.Visible = false

local SellCorner = Instance.new("UICorner")
SellCorner.CornerRadius = UDim.new(1, 0)
SellCorner.Parent = SellButton

-- Floating Sell Button menggunakan remote update (sellFish.sellAllFish)
SellButton.MouseButton1Click:Connect(function()
    pcall(function()
        local container = GetRemoteContainer()
        if container and container:FindFirstChild("sellFish.sellAllFish") then
            container["sellFish.sellAllFish"]:FireServer()
        end
    end)
end)

local UserInputService = game:GetService("UserInputService")
local function MakeDraggable(btn)
    local dragging, dragInput, dragStart, startPos
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = btn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    btn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
MakeDraggable(TeleButton)
MakeDraggable(SellButton)

-- ==========================================
-- TABS & GROUPBOXES SETUP
-- ==========================================
local Tabs = {
    AutoPlace = Window:AddTab("Auto Place", "home"),
    Event = Window:AddTab("Event", "zap"),
    Shop = Window:AddTab("Shop", "shopping-bag"),
    Merch = Window:AddTab("Merch", "store"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

-- ==========================================
-- TAB 1: AUTO PLACE 
-- ==========================================
local LeftGroupAutoPlace = Tabs.AutoPlace:AddLeftGroupbox("Auto Place Settings", "settings")
local RightGroupDiscord = Tabs.AutoPlace:AddRightGroupbox("Community & Support", "users")

LeftGroupAutoPlace:AddSlider("LoopTimeSlider", {
    Text = "Loop Time (All Main Features)",
    Default = Settings.LoopTime,
    Min = 0.01,
    Max = 300,
    Rounding = 2,
    Callback = function(Value) 
        Settings.LoopTime = Value 
    end,
})

LeftGroupAutoPlace:AddDropdown("FoodTrayDropdown", {
    Values = {"SupremeFoodTray", "AdvancedFoodTray", "BasicFoodTray"},
    Default = 1,
    Multi = false,
    Text = "Select Food Tray",
    Callback = function(Selected)
        Settings.SelectedFoodTray = Selected
    end,
})

LeftGroupAutoPlace:AddToggle("AutoPlaceToggle", {
    Text = "Start Auto Place",
    Default = false,
    Callback = function(Value)
        Settings.AutoPlaceEnabled = Value
        if Value then
            task.spawn(function()
                while Settings.AutoPlaceEnabled do
                    local args = {
                        [1] = "booster",
                        [2] = Settings.SelectedFoodTray,
                        [3] = AutoPlaceTargetPosition
                    }
                    pcall(function() 
                        local container = GetRemoteContainer()
                        if container and container:FindFirstChild("ponds.placeBuilding") then
                            container["ponds.placeBuilding"]:InvokeServer(unpack(args))
                        end
                    end)
                    task.wait(Settings.LoopTime)
                end
            end)
        end
    end,
})

RightGroupDiscord:AddLabel("Join Discord for updates & key!")
RightGroupDiscord:AddButton({
    Text = "Copy Discord Link",
    Func = function()
        pcall(function()
            setclipboard("https://discord.gg/xeyVYZkME6")
            Library:Notify("Discord link copied!", 3)
        end)
    end,
})

-- ==========================================
-- TAB 2: EVENT
-- ==========================================
local LeftGroupTeleport = Tabs.Event:AddLeftGroupbox("Area Teleport", "navigation")
local LeftGroupEventItem = Tabs.Event:AddLeftGroupbox("Buy Event Item", "shopping-cart")
local LeftGroupTaskBee = Tabs.Event:AddLeftGroupbox("Auto Submit Task Bee", "check-circle")
local RightGroupCrate = Tabs.Event:AddRightGroupbox("Open Crate", "box")

LeftGroupTeleport:AddButton({
    Text = "Teleport to Event Area",
    Func = function()
        pcall(function()
            if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(EventAreaCoordinate)
            end
        end)
    end,
})

LeftGroupTeleport:AddToggle("FloatingTeleportToggle", {
    Text = "Show Floating Teleport Button",
    Default = false,
    Callback = function(Value)
        Settings.FloatingTeleportEnabled = Value
        TeleButton.Visible = Value
    end,
})

LeftGroupEventItem:AddDropdown("EventItemDropdown", {
    Values = DaftarEventItemsDisplay,
    Default = 1,
    Multi = false,
    Text = "Select Event Item",
    Callback = function(Selected)
        Settings.SelectedEventItem = GetRealName(Selected, DaftarEventItemsDisplay, DaftarEventItemsReal)
    end,
})

LeftGroupEventItem:AddToggle("AutoBuyEventItemToggle", {
    Text = "Auto Buy Event Item",
    Default = false,
    Callback = function(Value)
        Settings.AutoBuyEventItemEnabled = Value
        if Value then
            task.spawn(function()
                while Settings.AutoBuyEventItemEnabled do
                    if Settings.SelectedEventItem ~= "" then
                        local args = { [1] = Settings.SelectedEventItem }
                        pcall(function() 
                            local container = GetRemoteContainer()
                            if container and container:FindFirstChild("shop.purchaseEventItem") then
                                container["shop.purchaseEventItem"]:FireServer(unpack(args)) 
                            end
                        end)
                    end
                    task.wait()
                end
            end)
        end
    end,
})

LeftGroupTaskBee:AddToggle("AutoSubmitBee1Toggle", {
    Text = "Auto Submit Task Bee 1",
    Default = false,
    Callback = function(Value)
        Settings.AutoSubmitBee1 = Value
        if Value then
            task.spawn(function()
                while Settings.AutoSubmitBee1 do
                    pcall(function()
                        local container = GetRemoteContainer()
                        if container and container:FindFirstChild("bee.submitToDispenser") then
                            container["bee.submitToDispenser"]:FireServer(1)
                        end
                    end)
                    task.wait(Settings.LoopTime)
                end
            end)
        end
    end,
})

LeftGroupTaskBee:AddToggle("AutoSubmitBee2Toggle", {
    Text = "Auto Submit Task Bee 2",
    Default = false,
    Callback = function(Value)
        Settings.AutoSubmitBee2 = Value
        if Value then
            task.spawn(function()
                while Settings.AutoSubmitBee2 do
                    pcall(function()
                        local container = GetRemoteContainer()
                        if container and container:FindFirstChild("bee.submitToDispenser") then
                            container["bee.submitToDispenser"]:FireServer(2)
                        end
                    end)
                    task.wait(Settings.LoopTime)
                end
            end)
        end
    end,
})

LeftGroupTaskBee:AddToggle("AutoSubmitBee3Toggle", {
    Text = "Auto Submit Task Bee 3",
    Default = false,
    Callback = function(Value)
        Settings.AutoSubmitBee3 = Value
        if Value then
            task.spawn(function()
                while Settings.AutoSubmitBee3 do
                    pcall(function()
                        local container = GetRemoteContainer()
                        if container and container:FindFirstChild("bee.submitToDispenser") then
                            container["bee.submitToDispenser"]:FireServer(3)
                        end
                    end)
                    task.wait(Settings.LoopTime)
                end
            end)
        end
    end,
})

RightGroupCrate:AddDropdown("CrateDropdown", {
    Values = DaftarCratesDisplay,
    Default = 1,
    Multi = false,
    Text = "Select Crate",
    Callback = function(Selected)
        Settings.SelectedCrate = GetRealName(Selected, DaftarCratesDisplay, DaftarCratesReal)
    end,
})

RightGroupCrate:AddToggle("AutoOpenCrateToggle", {
    Text = "Auto Open Crate",
    Default = false,
    Callback = function(Value)
        Settings.AutoOpenCrateEnabled = Value
        if Value then
            task.spawn(function()
                while Settings.AutoOpenCrateEnabled do
                    if Settings.SelectedCrate ~= "" then
                        local args = { [1] = Settings.SelectedCrate .. ":normal" }
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

-- ==========================================
-- TAB 3: SHOP
-- ==========================================
local LeftGroupGear = Tabs.Shop:AddLeftGroupbox("Gear Shop", "shield")
local LeftGroupBait = Tabs.Shop:AddLeftGroupbox("Bait Shop", "anchor")
local RightGroupEgg = Tabs.Shop:AddRightGroupbox("Egg Shop", "circle")

LeftGroupGear:AddDropdown("GearDropdown", {
    Values = DaftarGearsDisplay,
    Default = {},
    Multi = true,
    Text = "Select Gear (Stackable)",
    Callback = function(SelectedArray) 
        local realArray = {}
        for dispName, state in pairs(SelectedArray) do
            if state then table.insert(realArray, GetRealName(dispName, DaftarGearsDisplay, DaftarGearsReal)) end
        end
        Settings.SelectedGears = realArray 
    end,
})

LeftGroupGear:AddToggle("AutoBuyGearToggle", {
    Text = "Auto Buy Gear",
    Default = false,
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
                        task.wait()
                    end
                    task.wait(0.05)
                end
            end)
        end
    end,
})

LeftGroupBait:AddDropdown("BaitDropdown", {
    Values = DaftarBaitsDisplay,
    Default = {},
    Multi = true,
    Text = "Select Bait (Stackable)",
    Callback = function(SelectedArray) 
        local realArray = {}
        for dispName, state in pairs(SelectedArray) do
            if state then table.insert(realArray, GetRealName(dispName, DaftarBaitsDisplay, DaftarBaitsReal)) end
        end
        Settings.SelectedBaits = realArray 
    end,
})

LeftGroupBait:AddToggle("AutoBuyBaitToggle", {
    Text = "Auto Buy Bait",
    Default = false,
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
                        task.wait()
                    end
                    task.wait(0.05)
                end
            end)
        end
    end,
})

RightGroupEgg:AddDropdown("EggDropdown", {
    Values = DaftarEggsDisplay,
    Default = {},
    Multi = true,
    Text = "Select Egg (Stackable)",
    Callback = function(SelectedArray) 
        local realArray = {}
        for dispName, state in pairs(SelectedArray) do
            if state then table.insert(realArray, GetRealName(dispName, DaftarEggsDisplay, DaftarEggsReal)) end
        end
        Settings.SelectedEggs = realArray 
    end,
})

RightGroupEgg:AddToggle("AutoBuyEggToggle", {
    Text = "Auto Buy Egg",
    Default = false,
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
                        task.wait()
                    end
                    task.wait(0.05)
                end
            end)
        end
    end,
})

-- ==========================================
-- TAB 4: MERCH
-- ==========================================
local LeftGroupTraveling = Tabs.Merch:AddLeftGroupbox("Traveling Merchant", "truck")
local RightGroupCosmetic = Tabs.Merch:AddRightGroupbox("Cosmetic Merchant", "gift")
local LeftGroupSellFish = Tabs.Merch:AddLeftGroupbox("Sell Fish", "dollar-sign")

LeftGroupTraveling:AddDropdown("TravelingDropdown", {
    Values = DaftarTravelingItemsDisplay,
    Default = {},
    Multi = true,
    Text = "Select Traveling Item (Stackable)",
    Callback = function(SelectedArray) 
        local realArray = {}
        for dispName, state in pairs(SelectedArray) do
            if state then table.insert(realArray, GetRealName(dispName, DaftarTravelingItemsDisplay, DaftarTravelingItemsReal)) end
        end
        Settings.SelectedTravelingItems = realArray 
    end,
})

LeftGroupTraveling:AddToggle("AutoBuyTravelingToggle", {
    Text = "Auto Buy Traveling Merchant",
    Default = false,
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
                        task.wait()
                    end
                    task.wait(0.05)
                end
            end)
        end
    end,
})

RightGroupCosmetic:AddDropdown("CosmeticDropdown", {
    Values = DaftarCosmeticsDisplay,
    Default = {},
    Multi = true,
    Text = "Select Cosmetic (Stackable)",
    Callback = function(SelectedArray) 
        local realArray = {}
        for dispName, state in pairs(SelectedArray) do
            if state then table.insert(realArray, GetRealName(dispName, DaftarCosmeticsDisplay, DaftarCosmeticsReal)) end
        end
        Settings.SelectedCosmetics = realArray 
    end,
})

RightGroupCosmetic:AddToggle("AutoBuyCosmeticToggle", {
    Text = "Auto Buy Cosmetic",
    Default = false,
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
                        task.wait()
                    end
                    task.wait(0.05)
                end
            end)
        end
    end,
})

-- Manual Sell Fish button menggunakan sellFish.sellAllFish:FireServer()
LeftGroupSellFish:AddButton({
    Text = "Sell Fish (Manual UI)",
    Func = function()
        pcall(function()
            local container = GetRemoteContainer()
            if container and container:FindFirstChild("sellFish.sellAllFish") then
                container["sellFish.sellAllFish"]:FireServer()
            end
        end)
    end,
})

-- Auto Sell Fish loop menggunakan sellFish.sellAllFish:FireServer()
LeftGroupSellFish:AddToggle("AutoSellFishToggle", {
    Text = "Auto Sell Fish (Timed Loop)",
    Default = false,
    Callback = function(Value)
        Settings.AutoSellFishEnabled = Value
        if Value then
            task.spawn(function()
                while Settings.AutoSellFishEnabled do
                    pcall(function()
                        local container = GetRemoteContainer()
                        if container and container:FindFirstChild("sellFish.sellAllFish") then
                            container["sellFish.sellAllFish"]:FireServer()
                        end
                    end)
                    task.wait(Settings.LoopTime)
                end
            end)
        end
    end,
})

LeftGroupSellFish:AddToggle("FloatingSellToggle", {
    Text = "Show Floating Sell Button",
    Default = false,
    Callback = function(Value)
        Settings.FloatingSellEnabled = Value
        SellButton.Visible = Value
    end,
})

-- ==========================================
-- TAB 5: UI SETTINGS
-- ==========================================
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu", "wrench")

MenuGroup:AddToggle("KeybindMenuOpen", {
    Default = Library.KeybindFrame.Visible,
    Text = "Open Keybind Menu",
    Callback = function(value)
        Library.KeybindFrame.Visible = value
    end,
})

MenuGroup:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor",
    Default = true,
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end,
})

MenuGroup:AddDropdown("NotificationSide", {
    Values = { "Left", "Right" },
    Default = "Right",
    Text = "Notification Side",
    Callback = function(Value)
        Library:SetNotifySide(Value)
    end,
})

MenuGroup:AddDropdown("DPIDropdown", {
    Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default = "100%",
    Text = "DPI Scale",
    Callback = function(Value)
        Value = Value:gsub("%%", "")
        local DPI = tonumber(Value)
        Library:SetDPIScale(DPI)
    end,
})

MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind")
    :AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })

MenuGroup:AddButton("Unload", function()
    Library:Unload()
end)

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

ThemeManager:SetFolder("EWEHUB_FAF")
SaveManager:SetFolder("EWEHUB_FAF/settings")

SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])

SaveManager:LoadAutoloadConfig()
