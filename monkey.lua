-- Pastikan menjalankan script ini pada executor yang mendukung Rayfield UI Library & File Functions (writefile/readfile)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Nama file penyimpanan berdasarkan UserId / HWID executor
local SaveFileName = "TeleportLocations_" .. tostring(LocalPlayer.UserId) .. ".json"

-- Data Table untuk Dunia 1, Dunia 2, Dunia 3, dan Dunia 4
local World1Locations = {
    { Name = "cp 1", Position = Vector3.new(-688.38, 24.79, -222.15) },
    { Name = "cp 2", Position = Vector3.new(-936.74, 24.79, -214.22) },
    { Name = "cp 3", Position = Vector3.new(-1222.44, 24.79, -220.22) },
    { Name = "cp 4", Position = Vector3.new(-1576.81, 24.79, -223.27) },
    { Name = "cp 5", Position = Vector3.new(-2191.47, 119.79, -221.63) },
    { Name = "cp 6", Position = Vector3.new(-3083.06, 119.79, -231.64) },
    { Name = "cp 7", Position = Vector3.new(-4323.19, 278.79, -214.20) },
    { Name = "cp 8", Position = Vector3.new(-6171.71, 278.79, -222.52) }
}

local World2Locations = {
    { Name = "w2 cp 1", Position = Vector3.new(-730.65, 24.79, -2529.23) },
    { Name = "w2 cp 2", Position = Vector3.new(-1102.74, 39.79, -2530.69) },
    { Name = "w2 cp 3", Position = Vector3.new(-1891.53, 50.21, -2531.25) },
    { Name = "w2 cp 4", Position = Vector3.new(-2420.33, 57.09, -2539.82) },
    { Name = "w2 cp 5", Position = Vector3.new(-3260.11, 57.09, -2534.85) },
    { Name = "w2 cp 6", Position = Vector3.new(-3636.08, 57.08, -3708.64) },
    { Name = "w2 cp 7", Position = Vector3.new(-3639.07, 57.08, -4619.43) },
    { Name = "w2 cp 8", Position = Vector3.new(-3632.12, 57.09, -4625.34) },
    { Name = "w2 cp 9", Position = Vector3.new(-3643.54, 57.08, -5831.49) },
    { Name = "w2 cp 10", Position = Vector3.new(-3635.07, 153.09, -9383.25) }
}

local World3Locations = {
    { Name = "w3 cp 1", Position = Vector3.new(-696.35, 24.29, 2775.28) },
    { Name = "w3 cp 2", Position = Vector3.new(-956.48, 24.29, 2790.45) },
    { Name = "w3 cp 3", Position = Vector3.new(-1303.27, 24.29, 2770.67) },
    { Name = "w3 cp 4", Position = Vector3.new(-1698.80, 24.29, 2778.86) },
    { Name = "w3 cp 5", Position = Vector3.new(-2248.62, 24.29, 2771.33) },
    { Name = "w3 cp 6", Position = Vector3.new(-2248.62, 24.29, 2771.33) },
    { Name = "w3 cp 7", Position = Vector3.new(-2579.24, 280.29, 2777.67) },
    { Name = "w3 cp 8", Position = Vector3.new(-4211.23, 280.29, 2780.61) },
    { Name = "w3 cp 9", Position = Vector3.new(-5425.62, 280.29, 2774.48) },
    { Name = "w3 cp 10", Position = Vector3.new(-8081.90, 280.29, 2764.19) }
}

local World4Locations = {
    { Name = "w4 cp 1", Position = Vector3.new(-691.90, 24.29, 5773.07) },
    { Name = "w4 cp 2", Position = Vector3.new(-892.58, 24.29, 5776.65) },
    { Name = "w4 cp 3", Position = Vector3.new(-1205.05, 24.29, 5774.31) },
    { Name = "w4 cp 4", Position = Vector3.new(-1599.13, 24.29, 5771.40) },
    { Name = "w4 cp 5", Position = Vector3.new(-1864.72, 174.29, 5769.39) },
    { Name = "w4 cp 6", Position = Vector3.new(-2709.29, 174.19, 5773.21) },
    { Name = "w4 cp 7", Position = Vector3.new() },
    { Name = "w4 cp 8", Position = Vector3.new() },
    { Name = "w4 cp 6", Position = Vector3.new() }
}

-- Data Table untuk Custom Locations (Disimpan permanen)
local CustomLocations = {}

-- Fungsi untuk memuat lokasi kustom yang tersimpan di executor
local function LoadSavedLocations()
    if readfile and isfile and isfile(SaveFileName) then
        local Success, Result = pcall(function()
            return readfile(SaveFileName)
        end)
        if Success then
            local DecodedSuccess, DecodedData = pcall(function()
                return HttpService:JSONDecode(Result)
            end)
            if DecodedSuccess and type(DecodedData) == "table" then
                for _, SavedLoc in ipairs(DecodedData) do
                    if SavedLoc.Name and SavedLoc.Position and type(SavedLoc.Position) == "table" then
                        local PosVector = Vector3.new(SavedLoc.Position.X, SavedLoc.Position.Y, SavedLoc.Position.Z)
                        table.insert(CustomLocations, { Name = SavedLoc.Name, Position = PosVector })
                    end
                end
            end
        end
    end
end

-- Fungsi untuk menyimpan lokasi kustom ke file lokal
local function SaveCustomLocations()
    if writefile then
        local SerializableData = {}
        for _, Loc in ipairs(CustomLocations) do
            table.insert(SerializableData, {
                Name = Loc.Name,
                Position = { X = Loc.Position.X, Y = Loc.Position.Y, Z = Loc.Position.Z }
            })
        end
        
        local Success, EncodedData = pcall(function()
            return HttpService:JSONEncode(SerializableData)
        end)
        
        if Success then
            pcall(function()
                writefile(SaveFileName, EncodedData)
            end)
        end
    end
end

-- Muat data tersimpan saat script dijalankan
LoadSavedLocations()

-- Membuat Window Utama (Tanpa watermark, hub name, atau discord)
local Window = Rayfield:CreateWindow({
    Name = "+1 Speed Monkey",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "by EWEHUB",
    ConfigurationSaving = { Enabled = false },
    Discord = { Enabled = false },
    KeySystem = false,
})

-- Fungsi helper untuk mengambil nama lokasi dari sebuah table
local function GetLocationNames(LocationTable)
    local Names = {}
    for _, Location in ipairs(LocationTable) do
        table.insert(Names, Location.Name)
    end
    if #Names == 0 then
        table.insert(Names, "No Locations Available")
    end
    return Names
end

-- Fungsi untuk melakukan teleport dengan pengecekan keamanan karakter
local function TeleportToLocation(TargetName, LocationTable)
    if not LocalPlayer then return end
    
    local Character = LocalPlayer.Character
    if not Character then 
        Rayfield:Notify({Title = "Error", Content = "Character not spawned yet!", Duration = 3})
        return 
    end
    
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    
    if not Humanoid or not HumanoidRootPart then
        Rayfield:Notify({Title = "Error", Content = "Humanoid or RootPart not found!", Duration = 3})
        return
    end
    
    if Humanoid.Health <= 0 then
        Rayfield:Notify({Title = "Error", Content = "Character is dead!", Duration = 3})
        return
    end
    
    for _, Location in ipairs(LocationTable) do
        if Location.Name == TargetName then
            HumanoidRootPart.CFrame = CFrame.new(Location.Position)
            Rayfield:Notify({
                Title = "Teleport Successful", 
                Content = "Teleported to: " .. Location.Name, 
                Duration = 2
            })
            return
        end
    end
    
    Rayfield:Notify({Title = "Error", Content = "Location not found!", Duration = 3})
end

-- ================= TAB 1: WORLD 1 =================
local World1Tab = Window:CreateTab("World 1", 4483362458)
local SelectedWorld1 = World1Locations[1] and World1Locations[1].Name or ""

local World1Dropdown = World1Tab:CreateDropdown({
    Name = "Select World 1 Location",
    Options = GetLocationNames(World1Locations),
    CurrentOption = SelectedWorld1,
    Flag = "World1Flag",
    Callback = function(Option)
        if type(Option) == "table" then
            SelectedWorld1 = Option[1]
        else
            SelectedWorld1 = Option
        end
    end,
})

World1Tab:CreateButton({
    Name = "Teleport",
    Callback = function()
        TeleportToLocation(SelectedWorld1, World1Locations)
    end,
})

-- ================= TAB 2: WORLD 2 =================
local World2Tab = Window:CreateTab("World 2", 4483362458)
local SelectedWorld2 = World2Locations[1] and World2Locations[1].Name or ""

local World2Dropdown = World2Tab:CreateDropdown({
    Name = "Select World 2 Location",
    Options = GetLocationNames(World2Locations),
    CurrentOption = SelectedWorld2,
    Flag = "World2Flag",
    Callback = function(Option)
        if type(Option) == "table" then
            SelectedWorld2 = Option[1]
        else
            SelectedWorld2 = Option
        end
    end,
})

World2Tab:CreateButton({
    Name = "Teleport",
    Callback = function()
        TeleportToLocation(SelectedWorld2, World2Locations)
    end,
})

-- ================= TAB 3: WORLD 3 =================
local World3Tab = Window:CreateTab("World 3", 4483362458)
local SelectedWorld3 = World3Locations[1] and World3Locations[1].Name or ""

local World3Dropdown = World3Tab:CreateDropdown({
    Name = "Select World 3 Location",
    Options = GetLocationNames(World3Locations),
    CurrentOption = SelectedWorld3,
    Flag = "World3Flag",
    Callback = function(Option)
        if type(Option) == "table" then
            SelectedWorld3 = Option[1]
        else
            SelectedWorld3 = Option
        end
    end,
})

World3Tab:CreateButton({
    Name = "Teleport",
    Callback = function()
        TeleportToLocation(SelectedWorld3, World3Locations)
    end,
})

-- ================= TAB 4: WORLD 4 =================
local World4Tab = Window:CreateTab("World 4", 4483362458)
local SelectedWorld4 = World4Locations[1] and World4Locations[1].Name or ""

local World4Dropdown = World4Tab:CreateDropdown({
    Name = "Select World 4 Location",
    Options = GetLocationNames(World4Locations),
    CurrentOption = SelectedWorld4,
    Flag = "World4Flag",
    Callback = function(Option)
        if type(Option) == "table" then
            SelectedWorld4 = Option[1]
        else
            SelectedWorld4 = Option
        end
    end,
})

World4Tab:CreateButton({
    Name = "Teleport",
    Callback = function()
        TeleportToLocation(SelectedWorld4, World4Locations)
    end,
})

-- ================= TAB 5: CUSTOM LOCATIONS =================
local CustomTab = Window:CreateTab("Custom Locations", 4483362458)
local SelectedCustom = (#CustomLocations > 0) and CustomLocations[1].Name or "No Locations Available"
local CustomNameInput = ""

local CustomDropdown

local function RefreshCustomDropdown()
    if CustomDropdown then
        local names = GetLocationNames(CustomLocations)
        CustomDropdown:Refresh(names, names[1])
        SelectedCustom = names[1]
    end
end

CustomDropdown = CustomTab:CreateDropdown({
    Name = "Select Saved Custom Location",
    Options = GetLocationNames(CustomLocations),
    CurrentOption = SelectedCustom,
    Flag = "CustomFlag",
    Callback = function(Option)
        if type(Option) == "table" then
            SelectedCustom = Option[1]
        else
            SelectedCustom = Option
        end
    end,
})

CustomTab:CreateButton({
    Name = "Teleport",
    Callback = function()
        TeleportToLocation(SelectedCustom, CustomLocations)
    end,
})

CustomTab:CreateDivider()
CustomTab:CreateLabel("Save Current Character Position")

CustomTab:CreateInput({
    Name = "Custom Location Name",
    PlaceholderText = "Enter location name...",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        CustomNameInput = Text
    end,
})

CustomTab:CreateButton({
    Name = "Save Current Position",
    Callback = function()
        if not CustomNameInput or CustomNameInput == "" then
            Rayfield:Notify({Title = "Failed", Content = "Please enter a location name first!", Duration = 3})
            return
        end
        
        local Character = LocalPlayer.Character
        if not Character then
            Rayfield:Notify({Title = "Failed", Content = "Character not spawned yet!", Duration = 3})
            return
        end
        
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        if not HumanoidRootPart then
            Rayfield:Notify({Title = "Failed", Content = "RootPart not found!", Duration = 3})
            return
        end
        
        local CurrentPos = HumanoidRootPart.Position
        
        -- Cek duplikat nama
        local AlreadyExists = false
        for _, Loc in ipairs(CustomLocations) do
            if Loc.Name == CustomNameInput then
                AlreadyExists = true
                break
            end
        end
        
        if AlreadyExists then
            Rayfield:Notify({Title = "Failed", Content = "Location name already exists!", Duration = 3})
            return
        end
        
        table.insert(CustomLocations, { Name = CustomNameInput, Position = CurrentPos })
        SaveCustomLocations()
        RefreshCustomDropdown()
        
        Rayfield:Notify({
            Title = "Success", 
            Content = "Location '" .. CustomNameInput .. "' saved successfully!", 
            Duration = 3
        })
    end,
})
