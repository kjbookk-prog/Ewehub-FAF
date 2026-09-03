-- ============================================================
--  EWEHUB UNIVERSAL LOADER
--  Version: 1.0.0
--  Description: Roblox Universal Loader dengan branding EWEHUB
--  Prioritas: Simple, Clean, Smooth, Easy to Edit, Easy to Update
-- ============================================================

-- ============================================================
--// CONFIG
--  Semua pengaturan utama berada di sini.
--  Developer dapat mengedit nama, versi, ukuran, durasi, dan
--  pengaturan penting lainnya dari bagian ini.
-- ============================================================

local Config = {
    -- Branding
    HUB_NAME = "EWEHUB",
    VERSION = "1.0.0",

    -- UI Dimensions
    UI_WIDTH = 280,
    UI_HEIGHT = 160,
    UI_CORNER_RADIUS = 12,
    UI_PADDING = 16,

    -- Animation Durations
    ANIMATION_DURATION = 0.35,
    FADE_DURATION = 0.4,
    SCALE_DURATION = 0.5,
    PROGRESS_DURATION = 0.6,
    POP_DURATION = 0.3,
    GLOW_DURATION = 0.8,

    -- Display Durations
    SUCCESS_DURATION = 1.5,
    UNSUPPORTED_DURATION = 2,

    -- Layer
    Z_INDEX = 100,

    -- Debug
    DEBUG_MODE = false,

    -- Fallback
    USE_PLACE_ID_FALLBACK = true,
}


-- ============================================================
--// THEME
--  Seluruh warna EWEHUB berada dalam satu table.
--  Developer cukup mengedit bagian ini untuk mengubah identitas visual.
-- ============================================================

local Theme = {
    Background = Color3.fromRGB(18, 18, 22),
    Panel = Color3.fromRGB(28, 28, 34),
    Accent = Color3.fromRGB(0, 200, 100),
    AccentGlow = Color3.fromRGB(0, 255, 130),
    Text = Color3.fromRGB(240, 240, 245),
    SubText = Color3.fromRGB(150, 150, 160),
    Success = Color3.fromRGB(0, 200, 100),
    Error = Color3.fromRGB(220, 60, 60),
    Warning = Color3.fromRGB(230, 180, 50),
    Border = Color3.fromRGB(45, 45, 55),
    ProgressBg = Color3.fromRGB(40, 40, 50),
    ProgressFill = Color3.fromRGB(0, 200, 100),
    Shadow = Color3.fromRGB(0, 0, 0),
}


-- ============================================================
--// SERVICES
--  Referensi ke Roblox services.
-- ============================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer


-- ============================================================
--// GAME DATABASE
--  Database game yang didukung EWEHUB.
--  Gunakan UniverseId sebagai key utama.
--  Developer dapat menambahkan game baru hanya dengan
--  menambahkan satu entry di bawah.
-- ============================================================

local Games = {
    -- Format: [UniverseId] = { Name = "...", URL = "..." }
    -- Tambahkan game baru di bawah ini:

    [286090429] = {
        Name = "Arsenal",
        URL = "",
    },
    [292439477] = {
        Name = "Phantom Forces",
        URL = "",
    },
    [3101667897] = {
        Name = "Blox Fruits",
        URL = "",
    },
    [537413528] = {
        Name = "Build A Boat",
        URL = "",
    },
    [189707] = {
        Name = "Natural Disaster Survival",
        URL = "",
    },
    [142823291] = {
        Name = "Murder Mystery 2",
        URL = "",
    },
    [1962086868] = {
        Name = "Tower of Hell",
        URL = "",
    },
    [2788229376] = {
        Name = "Da Hood",
        URL = "",
    },

    -- Tambahkan game baru di atas baris ini
}


-- ============================================================
--// UI VARIABLES
--  Referensi ke komponen UI yang akan dibuat.
-- ============================================================

local ScreenGui = nil
local MainFrame = nil
local StatusLabel = nil
local InfoLabel = nil
local IconLabel = nil
local ProgressFill = nil
local ActiveTweens = {}


-- ============================================================
--// ANIMATION
--  Fungsi animasi menggunakan TweenService.
--  Semua animasi terpusat di sini agar konsisten dan mudah diubah.
-- ============================================================

local function CreateTween(instance, properties, duration, easingStyle, easingDirection, delay)
    local tweenInfo = TweenInfo.new(
        duration or Config.ANIMATION_DURATION,
        easingStyle or Enum.EasingStyle.Quart,
        easingDirection or Enum.EasingDirection.Out,
        0,
        false,
        delay or 0
    )

    local tween = TweenService:Create(instance, tweenInfo, properties)
    table.insert(ActiveTweens, tween)

    tween.Completed:Connect(function()
        for i, t in ipairs(ActiveTweens) do
            if t == tween then
                table.remove(ActiveTweens, i)
                break
            end
        end
    end)

    return tween
end

local function FadeIn(instance, duration)
    instance.BackgroundTransparency = 1
    instance.Visible = true
    local tween = CreateTween(instance, { BackgroundTransparency = 0 }, duration or Config.FADE_DURATION)
    tween:Play()
    return tween
end

local function FadeOut(instance, duration)
    local tween = CreateTween(instance, { BackgroundTransparency = 1 }, duration or Config.FADE_DURATION)
    tween:Play()
    return tween
end

local function ScaleIn(instance, duration)
    instance.Size = UDim2.new(0, 0, 0, 0)
    instance.Visible = true
    local targetSize = UDim2.new(0, Config.UI_WIDTH, 0, Config.UI_HEIGHT)
    local tween = CreateTween(instance, { Size = targetSize }, duration or Config.SCALE_DURATION, Enum.EasingStyle.Back)
    tween:Play()
    return tween
end

local function ScaleOut(instance, duration)
    local tween = CreateTween(instance, { Size = UDim2.new(0, 0, 0, 0) }, duration or Config.SCALE_DURATION, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    tween:Play()
    return tween
end

local function FadeAndScaleIn(instance, duration)
    instance.BackgroundTransparency = 1
    instance.Size = UDim2.new(0, Config.UI_WIDTH * 0.85, 0, Config.UI_HEIGHT * 0.85)
    instance.Visible = true

    local tween = CreateTween(instance, {
        BackgroundTransparency = 0,
        Size = UDim2.new(0, Config.UI_WIDTH, 0, Config.UI_HEIGHT)
    }, duration or Config.SCALE_DURATION, Enum.EasingStyle.Quart)

    tween:Play()
    return tween
end

local function FadeAndScaleOut(instance, duration)
    local tween = CreateTween(instance, {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, Config.UI_WIDTH * 0.85, 0, Config.UI_HEIGHT * 0.85)
    }, duration or Config.FADE_DURATION, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

    tween:Play()
    return tween
end

local function AnimateProgress(bar, percentage, duration)
    local tween = CreateTween(bar, { Size = UDim2.new(percentage / 100, 0, 1, 0) },
        duration or Config.PROGRESS_DURATION, Enum.EasingStyle.Quart)
    tween:Play()
    return tween
end

local function PopEffect(instance, duration)
    local originalSize = instance.Size
    local popSize = UDim2.new(
        originalSize.X.Scale * 1.25, originalSize.X.Offset * 1.25,
        originalSize.Y.Scale * 1.25, originalSize.Y.Offset * 1.25
    )

    local tween1 = CreateTween(instance, { Size = popSize }, (duration or Config.POP_DURATION) / 2, Enum.EasingStyle.Back)
    local tween2 = CreateTween(instance, { Size = originalSize }, (duration or Config.POP_DURATION) / 2, Enum.EasingStyle.Quart)

    tween1:Play()
    tween1.Completed:Connect(function()
        tween2:Play()
    end)

    return tween1
end

local function GlowEffect(instance, duration)
    local glow = Instance.new("ImageLabel")
    glow.Name = "GlowEffect"
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5028857084"
    glow.ImageColor3 = Theme.AccentGlow
    glow.ImageTransparency = 1
    glow.Size = UDim2.new(1.5, 0, 1.5, 0)
    glow.Position = UDim2.new(-0.25, 0, -0.25, 0)
    glow.ZIndex = instance.ZIndex - 1
    glow.Parent = instance

    local tweenIn = CreateTween(glow, { ImageTransparency = 0.25 }, (duration or Config.GLOW_DURATION) / 2)
    local tweenOut = CreateTween(glow, { ImageTransparency = 1 }, (duration or Config.GLOW_DURATION) / 2)

    tweenIn:Play()
    tweenIn.Completed:Connect(function()
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            glow:Destroy()
        end)
    end)

    return tweenIn
end

local function ShakeEffect(instance, duration)
    local originalPos = instance.Position
    local intensity = 4

    for i = 1, 6 do
        local offsetX = math.random(-intensity, intensity)
        local offsetY = math.random(-intensity, intensity)
        local tween = CreateTween(instance, {
            Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset + offsetX,
                                 originalPos.Y.Scale, originalPos.Y.Offset + offsetY)
        }, (duration or 0.3) / 6)
        tween:Play()
        tween.Completed:Wait()
    end

    instance.Position = originalPos
end

local function CancelAllTweens()
    for _, tween in ipairs(ActiveTweens) do
        if tween then
            tween:Cancel()
        end
    end
    ActiveTweens = {}
end


-- ============================================================
--// FUNCTIONS
--  Fungsi-fungsi utama sistem.
-- ============================================================

-- Logging
local function Log(level, message)
    if not Config.DEBUG_MODE then return end
    local prefix = string.format("[%s v%s] [%s]", Config.HUB_NAME, Config.VERSION, level)
    print(prefix, message)
end

-- UI Creation
local function CreateUI()
    -- Hancurkan UI lama jika ada
    if ScreenGui then
        ScreenGui:Destroy()
        ScreenGui = nil
    end

    -- ScreenGui
    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = Config.HUB_NAME .. "_Loader"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 999
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- Main Frame
    MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, Config.UI_WIDTH, 0, Config.UI_HEIGHT)
    MainFrame.Position = UDim2.new(0.5, -Config.UI_WIDTH / 2, 0.5, -Config.UI_HEIGHT / 2)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BackgroundTransparency = 1
    MainFrame.BorderSizePixel = 0
    MainFrame.Visible = false
    MainFrame.ZIndex = Config.Z_INDEX
    MainFrame.Parent = ScreenGui

    -- Corner
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, Config.UI_CORNER_RADIUS)
    corner.Parent = MainFrame

    -- Stroke
    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Border
    stroke.Thickness = 1
    stroke.Transparency = 0.3
    stroke.Parent = MainFrame

    -- Shadow
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Image = "rbxassetid://1316045217"
    shadow.ImageColor3 = Theme.Shadow
    shadow.ImageTransparency = 0.6
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Size = UDim2.new(1, 24, 1, 24)
    shadow.Position = UDim2.new(0, -12, 0, -12)
    shadow.ZIndex = Config.Z_INDEX - 1
    shadow.Parent = MainFrame

    -- Header: Hub Name
    local hubName = Instance.new("TextLabel")
    hubName.Name = "HubName"
    hubName.Text = Config.HUB_NAME
    hubName.Font = Enum.Font.GothamBold
    hubName.TextSize = 14
    hubName.TextColor3 = Theme.Accent
    hubName.BackgroundTransparency = 1
    hubName.TextXAlignment = Enum.TextXAlignment.Left
    hubName.Size = UDim2.new(0.5, 0, 0, 20)
    hubName.Position = UDim2.new(0, Config.UI_PADDING, 0, Config.UI_PADDING)
    hubName.Parent = MainFrame
    hubName.ZIndex = Config.Z_INDEX + 1

    -- Header: Version
    local versionLabel = Instance.new("TextLabel")
    versionLabel.Name = "Version"
    versionLabel.Text = "v" .. Config.VERSION
    versionLabel.Font = Enum.Font.Gotham
    versionLabel.TextSize = 11
    versionLabel.TextColor3 = Theme.SubText
    versionLabel.BackgroundTransparency = 1
    versionLabel.TextXAlignment = Enum.TextXAlignment.Right
    versionLabel.Size = UDim2.new(0.5, 0, 0, 20)
    versionLabel.Position = UDim2.new(0.5, 0, 0, Config.UI_PADDING)
    versionLabel.Parent = MainFrame
    versionLabel.ZIndex = Config.Z_INDEX + 1

    -- Divider
    local divider = Instance.new("Frame")
    divider.Name = "Divider"
    divider.Size = UDim2.new(1, -Config.UI_PADDING * 2, 0, 1)
    divider.Position = UDim2.new(0, Config.UI_PADDING, 0, Config.UI_PADDING + 24)
    divider.BackgroundColor3 = Theme.Border
    divider.BackgroundTransparency = 0.5
    divider.BorderSizePixel = 0
    divider.Parent = MainFrame
    divider.ZIndex = Config.Z_INDEX + 1

    -- Icon Container
    local iconContainer = Instance.new("Frame")
    iconContainer.Name = "IconContainer"
    iconContainer.Size = UDim2.new(0, 36, 0, 36)
    iconContainer.Position = UDim2.new(0.5, -18, 0, Config.UI_PADDING + 38)
    iconContainer.BackgroundTransparency = 1
    iconContainer.Parent = MainFrame
    iconContainer.ZIndex = Config.Z_INDEX + 1

    -- Icon Label
    IconLabel = Instance.new("TextLabel")
    IconLabel.Name = "Icon"
    IconLabel.Text = "O"
    IconLabel.Font = Enum.Font.GothamBold
    IconLabel.TextSize = 24
    IconLabel.TextColor3 = Theme.SubText
    IconLabel.BackgroundTransparency = 1
    IconLabel.Size = UDim2.new(1, 0, 1, 0)
    IconLabel.Parent = iconContainer
    IconLabel.ZIndex = Config.Z_INDEX + 2

    -- Status Label
    StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "Status"
    StatusLabel.Text = "Initializing..."
    StatusLabel.Font = Enum.Font.GothamBold
    StatusLabel.TextSize = 12
    StatusLabel.TextColor3 = Theme.Text
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Center
    StatusLabel.Size = UDim2.new(1, -Config.UI_PADDING * 2, 0, 18)
    StatusLabel.Position = UDim2.new(0, Config.UI_PADDING, 0, Config.UI_PADDING + 78)
    StatusLabel.Parent = MainFrame
    StatusLabel.ZIndex = Config.Z_INDEX + 2

    -- Info Label
    InfoLabel = Instance.new("TextLabel")
    InfoLabel.Name = "Info"
    InfoLabel.Text = ""
    InfoLabel.Font = Enum.Font.Gotham
    InfoLabel.TextSize = 11
    InfoLabel.TextColor3 = Theme.SubText
    InfoLabel.BackgroundTransparency = 1
    InfoLabel.TextXAlignment = Enum.TextXAlignment.Center
    InfoLabel.Size = UDim2.new(1, -Config.UI_PADDING * 2, 0, 14)
    InfoLabel.Position = UDim2.new(0, Config.UI_PADDING, 0, Config.UI_PADDING + 96)
    InfoLabel.Parent = MainFrame
    InfoLabel.ZIndex = Config.Z_INDEX + 2

    -- Progress Background
    local progressBg = Instance.new("Frame")
    progressBg.Name = "ProgressBg"
    progressBg.Size = UDim2.new(1, -Config.UI_PADDING * 2, 0, 4)
    progressBg.Position = UDim2.new(0, Config.UI_PADDING, 1, -Config.UI_PADDING - 8)
    progressBg.BackgroundColor3 = Theme.ProgressBg
    progressBg.BorderSizePixel = 0
    progressBg.Parent = MainFrame
    progressBg.ZIndex = Config.Z_INDEX + 1

    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(0, 2)
    progressCorner.Parent = progressBg

    -- Progress Fill
    ProgressFill = Instance.new("Frame")
    ProgressFill.Name = "ProgressFill"
    ProgressFill.Size = UDim2.new(0, 0, 1, 0)
    ProgressFill.BackgroundColor3 = Theme.ProgressFill
    ProgressFill.BorderSizePixel = 0
    ProgressFill.Parent = progressBg
    ProgressFill.ZIndex = Config.Z_INDEX + 2

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 2)
    fillCorner.Parent = ProgressFill

    Log("INFO", "UI Created")
end

local function ShowUI()
    if not MainFrame then return end
    FadeAndScaleIn(MainFrame)
end

local function HideUI(onComplete)
    if not MainFrame then
        if onComplete then onComplete() end
        return
    end

    local tween = FadeAndScaleOut(MainFrame)
    tween.Completed:Connect(function()
        if ScreenGui then
            ScreenGui:Destroy()
            ScreenGui = nil
            MainFrame = nil
            StatusLabel = nil
            InfoLabel = nil
            IconLabel = nil
            ProgressFill = nil
        end
        CancelAllTweens()
        if onComplete then onComplete() end
    end)
end

local function UpdateStatus(text, icon, iconColor)
    if StatusLabel then
        StatusLabel.Text = text
    end
    if IconLabel and icon then
        IconLabel.Text = icon
        if iconColor then
            IconLabel.TextColor3 = iconColor
        end
    end
end

local function UpdateInfo(text)
    if InfoLabel then
        InfoLabel.Text = text
    end
end

local function UpdateProgress(percentage, animate)
    if not ProgressFill then return end
    if animate then
        AnimateProgress(ProgressFill, percentage)
    else
        ProgressFill.Size = UDim2.new(percentage / 100, 0, 1, 0)
    end
end

-- Game Detection
local function DetectGame()
    local info = {
        GameId = game.GameId,
        PlaceId = game.PlaceId,
        UniverseId = nil,
        JobId = game.JobId,
        Name = nil,
    }

    -- Get game name
    local success, result = pcall(function()
        local productInfo = MarketplaceService:GetProductInfo(info.PlaceId, Enum.InfoType.Asset)
        if productInfo then
            info.Name = productInfo.Name
        end
        return productInfo
    end)

    if not success then
        Log("WARN", "Failed to fetch game info: " .. tostring(result))
    end

    -- Get UniverseId
    local universeSuccess, universeResult = pcall(function()
        local url = string.format("https://apis.roblox.com/universes/v1/places/%d/universe", info.PlaceId)
        local response = HttpService:GetAsync(url)
        local data = HttpService:JSONDecode(response)
        return data.universeId
    end)

    if universeSuccess and universeResult then
        info.UniverseId = universeResult
        Log("INFO", "UniverseId detected: " .. tostring(info.UniverseId))
    else
        Log("WARN", "Could not detect UniverseId")
        if Config.USE_PLACE_ID_FALLBACK then
            info.UniverseId = info.PlaceId
        end
    end

    return info
end

-- Support Check
local function CheckSupport(universeId)
    if not universeId then return nil end
    return Games[universeId]
end

-- Show Supported
local function ShowSupported(gameData, universeId)
    UpdateStatus("Game Supported", "OK", Theme.Success)
    UpdateInfo(gameData.Name or "Unknown Game")
    UpdateProgress(100, true)

    if IconLabel then
        PopEffect(IconLabel)
    end

    GlowEffect(MainFrame)

    -- Change border to success color
    for _, child in ipairs(MainFrame:GetChildren()) do
        if child:IsA("UIStroke") then
            CreateTween(child, { Color = Theme.Success }, 0.3):Play()
        end
    end
end

-- Show Unsupported
local function ShowUnsupported(universeId, placeId)
    UpdateStatus("Game Not Supported", "X", Theme.Error)
    UpdateInfo(string.format("Universe: %s | Place: %s", tostring(universeId or "N/A"), tostring(placeId)))

    if MainFrame then
        local iconContainer = MainFrame:FindFirstChild("IconContainer")
        if iconContainer then
            ShakeEffect(iconContainer, 0.3)
        end
    end

    -- Change border to error color
    for _, child in ipairs(MainFrame:GetChildren()) do
        if child:IsA("UIStroke") then
            CreateTween(child, { Color = Theme.Error }, 0.3):Play()
        end
    end
end

-- Continue Process (jika game didukung)
local function ContinueProcess(gameData)
    Log("INFO", "Continuing process for: " .. (gameData.Name or "Unknown"))

    -- Developer dapat menambahkan kode di sini
    -- untuk melanjutkan ke proses berikutnya.
    -- Contoh: loadstring(game:HttpGet(gameData.URL))()
end


-- ============================================================
--// MAIN
--  Alur utama sistem.
--  Sangat mudah dibaca dan dipahami.
-- ============================================================

local function Main()
    Log("INFO", Config.HUB_NAME .. " v" .. Config.VERSION .. " - Starting...")

    -- 1. Create UI
    CreateUI()

    -- 2. Show UI
    ShowUI()
    task.wait(Config.ANIMATION_DURATION + 0.1)

    -- 3. Initializing
    UpdateStatus("Initializing " .. Config.HUB_NAME .. "...", "O", Theme.SubText)
    UpdateProgress(10, true)
    task.wait(0.5)

    -- 4. Detecting Game
    UpdateStatus("Detecting Game...", "O", Theme.SubText)
    UpdateProgress(30, true)

    local gameInfo = DetectGame()
    Log("INFO", string.format("Detected - GameId: %s, PlaceId: %s, UniverseId: %s",
        tostring(gameInfo.GameId), tostring(gameInfo.PlaceId), tostring(gameInfo.UniverseId)))

    task.wait(0.4)

    -- 5. Checking Support
    UpdateStatus("Checking Support...", "O", Theme.SubText)
    UpdateProgress(60, true)
    task.wait(0.4)

    -- 6. Verifying
    UpdateStatus("Verifying...", "O", Theme.SubText)
    UpdateProgress(85, true)
    task.wait(0.3)

    -- 7. Check Database
    local gameData = CheckSupport(gameInfo.UniverseId)

    if not gameData and Config.USE_PLACE_ID_FALLBACK then
        gameData = CheckSupport(gameInfo.PlaceId)
    end

    local isSupported = gameData ~= nil

    if isSupported then
        -- Game Supported
        Log("INFO", "Game supported: " .. gameData.Name)
        ShowSupported(gameData, gameInfo.UniverseId)

        task.wait(Config.SUCCESS_DURATION)

        -- Hide UI
        HideUI(function()
            -- Continue to next process
            ContinueProcess(gameData)
        end)
    else
        -- Game Not Supported
        Log("WARN", "Game not supported")
        ShowUnsupported(gameInfo.UniverseId, gameInfo.PlaceId)

        task.wait(Config.UNSUPPORTED_DURATION)

        -- Hide UI
        HideUI(function()
            -- End process, do not continue
            Log("INFO", "Execution halted - Game not supported")
        end)
    end
end


-- ============================================================
--// AUTO START
--  Sistem akan otomatis berjalan saat script dieksekusi.
-- ============================================================

Main()
