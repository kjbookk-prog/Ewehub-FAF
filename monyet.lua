-- Pastikan menjalankan script ini pada executor yang mendukung Rayfield UI Library & File Functions (writefile/readfile)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Nama file penyimpanan berdasarkan UserId / HWID executor
local SaveFileName = "TeleportLocations_" .. tostring(LocalPlayer.UserId) .. ".json"

-- Data Table Default untuk Lokasi
local Locations = {
    { Name = "Spawn", Position = Vector3.new(0, 10, 0) },
    { Name = "Shop", Position = Vector3.new(100, 15, -50) },
    { Name = "Arena PvP", Position = Vector3.new(-200, 10, 200) },
    { Name = "Gunung Tinggi", Position = Vector3.new(500, 150, 500) }
}

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
                        -- Konversi tabel posisi kembali ke Vector3
                        local PosVector = Vector3.new(SavedLoc.Position.X, SavedLoc.Position.Y, SavedLoc.Position.Z)
                        
                        -- Cek apakah nama lokasi sudah ada agar tidak duplikat
                        local Exist = false
                        for _, Loc in ipairs(Locations) do
                            if Loc.Name == SavedLoc.Name then
                                Exist = true
                                break
                            end
                        end
                        
                        if not Exist then
                            table.insert(Locations, { Name = SavedLoc.Name, Position = PosVector })
                        end
                    end
                end
            end
        end
    end
end

-- Fungsi untuk menyimpan lokasi kustom ke file lokal
local function SaveCustomLocations()
    if writefile then
        -- Format data Vector3 agar bisa di-encode ke JSON
        local SerializableData = {}
        for _, Loc in ipairs(Locations) do
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

-- Membuat Window Utama
local Window = Rayfield:CreateWindow({
    Name = "Teleport Panel & Custom Save",
    LoadingTitle = "Memuat Sistem...",
    LoadingSubtitle = "Oleh Luau Script",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false,
})

-- Variabel lokal
local SelectedLocationName = Locations[1].Name
local CustomLocationNameInput = ""

-- Fungsi untuk mengambil semua nama lokasi dari table Locations
local function GetLocationNames()
    local Names = {}
    for _, Location in ipairs(Locations) do
        table.insert(Names, Location.Name)
    end
    return Names
end

-- Fungsi untuk melakukan teleport dengan pengecekan keamanan karakter
local function TeleportToLocation(Name)
    if not LocalPlayer then return end
    
    local Character = LocalPlayer.Character
    if not Character then 
        Rayfield:Notify({Title = "Error", Content = "Karakter belum spawn!", Duration = 3})
        return 
    end
    
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    
    if not Humanoid or not HumanoidRootPart then
        Rayfield:Notify({Title = "Error", Content = "Humanoid atau RootPart tidak ditemukan!", Duration = 3})
        return
    end
    
    if Humanoid.Health <= 0 then
        Rayfield:Notify({Title = "Error", Content = "Karakter sedang mati!", Duration = 3})
        return
    end
    
    for _, Location in ipairs(Locations) do
        if Location.Name == Name then
            HumanoidRootPart.CFrame = CFrame.new(Location.Position)
            Rayfield:Notify({
                Title = "Teleport Berhasil", 
                Content = "Berpindah ke: " .. Location.Name, 
                Duration = 2
            })
            return
        end
    end
    
    Rayfield:Notify({Title = "Error", Content = "Lokasi tidak ditemukan!", Duration = 3})
end

-- Membuat Tab khusus bernama "Teleport"
local TeleportTab = Window:CreateTab("Teleport", 4483362458)

local LocationDropdown

-- Fungsi memperbarui dropdown secara otomatis setelah ada penambahan lokasi baru
local function RefreshDropdownOptions()
    if LocationDropdown then
        LocationDropdown:Refresh(GetLocationNames(), GetLocationNames()[1])
        SelectedLocationName = GetLocationNames()[1]
    end
end

-- Dropdown Lokasi
LocationDropdown = TeleportTab:CreateDropdown({
    Name = "Pilih Lokasi Tujuan",
    Options = GetLocationNames(),
    CurrentOption = SelectedLocationName,
    Flag = "LocationDropdownFlag",
    Callback = function(Option)
        if type(Option) == "table" then
            SelectedLocationName = Option[1]
        else
            SelectedLocationName = Option
        end
    end,
})

-- Tombol Eksekusi Teleport
TeleportTab:CreateButton({
    Name = "Teleport Sekarang",
    Callback = function()
        TeleportToLocation(SelectedLocationName)
    end,
})

-- Section untuk Penambahan Lokasi Kustom
TeleportTab:CreateDivider()
TeleportTab:CreateLabel("Simpan Posisi Karakter Saat Ini")

-- Input Nama Lokasi Baru
TeleportTab:CreateInput({
    Name = "Nama Lokasi Baru",
    PlaceholderText = "Contoh: Base Rahasia",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        CustomLocationNameInput = Text
    end,
})

-- Tombol Simpan Lokasi Berdasarkan Posisi Karakter Sekarang
TeleportTab:CreateButton({
    Name = "Simpan Posisi Saat Ini",
    Callback = function()
        if not CustomLocationNameInput or CustomLocationNameInput == "" then
            Rayfield:Notify({Title = "Gagal", Content = "Masukkan nama lokasi terlebih dahulu!", Duration = 3})
            return
        end
        
        local Character = LocalPlayer.Character
        if not Character then
            Rayfield:Notify({Title = "Gagal", Content = "Karakter belum spawn!", Duration = 3})
            return
        end
        
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        if not HumanoidRootPart then
            Rayfield:Notify({Title = "Gagal", Content = "RootPart tidak ditemukan!", Duration = 3})
            return
        end
        
        -- Ambil koordinat posisi karakter saat ini
        local CurrentPos = HumanoidRootPart.Position
        
        -- Cek duplikat nama
        local AlreadyExists = false
        for _, Loc in ipairs(Locations) do
            if Loc.Name == CustomLocationNameInput then
                AlreadyExists = true
                break
            end
        end
        
        if AlreadyExists then
            Rayfield:Notify({Title = "Gagal", Content = "Nama lokasi sudah ada!", Duration = 3})
            return
        end
        
        -- Tambahkan ke table lokal
        table.insert(Locations, { Name = CustomLocationNameInput, Position = CurrentPos })
        
        -- Simpan permanen ke file (tersimpan antar session/HWID)
        SaveCustomLocations()
        
        -- Update dropdown secara otomatis
        RefreshDropdownOptions()
        
        Rayfield:Notify({
            Title = "Berhasil", 
            Content = "Lokasi '" .. CustomLocationNameInput .. "' berhasil disimpan!", 
            Duration = 3
        })
    end,
})

-- Notifikasi sukses dimuat
Rayfield:Notify({
    Title = "Script Berhasil Dimuat",
    Content = "Sistem penyimpanan lokasi kustom aktif.",
    Duration = 4,
})
