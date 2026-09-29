-- == KUKIRIN PREMIUM SCRIPT v3 ==
-- С ползунком скорости
-- Вставь в инжектор (Roblox) и нажми Execute

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ================= НАСТРОЙКИ =================
local CONFIG = {
    AutoDriveSpeed = 80,
    StuntForce     = 150,
    BoostSpeed     = 200,
    FlySpeed       = 100,
}

-- Значение слайдера скорости
local WalkSpeedValue = 1  -- начинаем с 1
local WalkSpeedMin = 1
local WalkSpeedMax = 500

local State = {
    AutoDrive    = false,
    AutoStunt    = false,
    Boost        = false,
    Fly          = false,
    NoClip       = false,
    GodMode      = false,
    AntiAFK      = false,
    InfiniteJump = false,
    SpeedApply   = false,  -- применяется ли кастомная скорость
    AutoFlip     = false,
}

-- ================= GUI =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KukirinPremiumV3"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 500)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(80, 80, 80)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- Заголовок
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 42)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 14)
TitleCorner.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 15)
TitleFix.Position = UDim2.new(0, 0, 1, -15)
TitleFix.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⚡ KUKIRIN PREMIUM v3"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 15
TitleLabel.Parent = TitleBar

-- Скролл
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, 0, 1, -42)
Scroll.Position = UDim2.new(0, 0, 0, 42)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 6)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = Scroll

local Pad = Instance.new("UIPadding")
Pad.PaddingTop = UDim.new(0, 8)
Pad.PaddingLeft = UDim.new(0, 8)
Pad.PaddingRight = UDim.new(0, 8)
Pad.PaddingBottom = UDim.new(0, 8)
Pad.Parent = Scroll

-- ================= ФУНКЦИЯ ТУМБЛЕРА =================
local function createToggle(text, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(1, 0, 0, 42)
    Toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Toggle.Text = ""
    Toggle.AutoButtonColor = false
    Toggle.BorderSizePixel = 0
    Toggle.Parent = Scroll

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0, 10)
    C.Parent = Toggle

    local S = Instance.new("UIStroke")
    S.Color = Color3.fromRGB(200, 200, 200)
    S.Thickness = 1
    S.Parent = Toggle

    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(0.72, 0, 1, 0)
    L.Position = UDim2.new(0.05, 0, 0, 0)
    L.BackgroundTransparency = 1
    L.Text = text
    L.TextColor3 = Color3.fromRGB(30, 30, 30)
    L.Font = Enum.Font.GothamBold
    L.TextSize = 13
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = Toggle

    local St = Instance.new("TextLabel")
    St.Size = UDim2.new(0.2, 0, 1, 0)
    St.Position = UDim2.new(0.75, 0, 0, 0)
    St.BackgroundTransparency = 1
    St.Text = "ВЫКЛ"
    St.TextColor3 = Color3.fromRGB(120, 120, 120)
    St.Font = Enum.Font.GothamBold
    St.TextSize = 11
    St.Parent = Toggle

    local state = false

    Toggle.MouseButton1Click:Connect(function()
        state = not state
        callback(state)

        if state then
            TweenService:Create(Toggle, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            }):Play()
            TweenService:Create(S, TweenInfo.new(0.4), {Color = Color3.fromRGB(0, 200, 100)}):Play()
            TweenService:Create(L, TweenInfo.new(0.4), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
            St.Text = "ВКЛ"
            St.TextColor3 = Color3.fromRGB(0, 220, 120)
        else
            TweenService:Create(Toggle, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            TweenService:Create(S, TweenInfo.new(0.4), {Color = Color3.fromRGB(200,200,200)}):Play()
            TweenService:Create(L, TweenInfo.new(0.4), {TextColor3 = Color3.fromRGB(30,30,30)}):Play()
            St.Text = "ВЫКЛ"
            St.TextColor3 = Color3.fromRGB(120, 120, 120)
        end
    end)
end

-- ================= ФУНКЦИЯ СЛАЙДЕРА =================
local function createSlider(labelText, minVal, maxVal, defaultVal, callback)
    -- Контейнер
    local Box = Instance.new("Frame")
    Box.Size = UDim2.new(1, 0, 0, 60)
    Box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Box.BorderSizePixel = 0
    Box.Parent = Scroll

    local BC = Instance.new("UICorner")
    BC.CornerRadius = UDim.new(0, 10)
    BC.Parent = Box

    local BS = Instance.new("UIStroke")
    BS.Color = Color3.fromRGB(200, 200, 200)
    BS.Thickness = 1
    BS.Parent = Box

    -- Название
    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(0.6, 0, 0, 22)
    Lbl.Position = UDim2.new(0.05, 0, 0, 4)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = labelText
    Lbl.TextColor3 = Color3.fromRGB(30, 30, 30)
    Lbl.Font = Enum.Font.GothamBold
    Lbl.TextSize = 13
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Parent = Box

    -- Значение
    local ValLbl = Instance.new("TextLabel")
    ValLbl.Size = UDim2.new(0.3, 0, 0, 22)
    ValLbl.Position = UDim2.new(0.65, 0, 0, 4)
    ValLbl.BackgroundTransparency = 1
    ValLbl.Text = tostring(defaultVal)
    ValLbl.TextColor3 = Color3.fromRGB(0, 150, 80)
    ValLbl.Font = Enum.Font.GothamBold
    ValLbl.TextSize = 14
    ValLbl.TextXAlignment = Enum.TextXAlignment.Right
    ValLbl.Parent = Box

    -- Линия (фон)
    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(0.9, 0, 0, 6)
    Track.Position = UDim2.new(0.05, 0, 0, 38)
    Track.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
    Track.BorderSizePixel = 0
    Track.Parent = Box

    local TC = Instance.new("UICorner")
    TC.CornerRadius = UDim.new(1, 0)
    TC.Parent = Track

    -- Заполненная часть
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
    Fill.BorderSizePixel = 0
    Fill.Parent = Track

    local FC = Instance.new("UICorner")
    FC.CornerRadius = UDim.new(1, 0)
    FC.Parent = Fill

    -- Круглая точка
    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 18, 0, 18)
    Knob.Position = UDim2.new(0, -9, 0.5, -9)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.Parent = Track

    local KC = Instance.new("UICorner")
    KC.CornerRadius = UDim.new(1, 0)
    KC.Parent = Knob

    local KS = Instance.new("UIStroke")
    KS.Color = Color3.fromRGB(0, 150, 80)
    KS.Thickness = 2
    KS.Parent = Knob

    -- Обновление позиции точки/значения
    local function updateFromValue(val)
        val = math.clamp(val, minVal, maxVal)
        local percent = (val - minVal) / (maxVal - minVal)
        Fill.Size = UDim2.new(percent, 0, 1, 0)
        Knob.Position = UDim2.new(percent, -9, 0.5, -9)
        ValLbl.Text = tostring(math.floor(val))
        callback(math.floor(val))
    end

    -- Drag
    local dragging = false
    local function handleInput(input)
        local trackPos = Track.AbsolutePosition.X
        local trackSize = Track.AbsoluteSize.X
        local x = input.Position.X - trackPos
        local percent = math.clamp(x / trackSize, 0, 1)
        local val = minVal + (maxVal - minVal) * percent
        updateFromValue(val)
    end

    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            handleInput(input)
        end
    end)

    Knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            handleInput(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- Стартовое значение
    updateFromValue(defaultVal)
end

-- ================= СОЗДАЁМ ЭЛЕМЕНТЫ =================

createToggle("🚗 Авто-Езда", function(s) State.AutoDrive = s end)
createToggle("🔄 Авто-Стант", function(s) State.AutoStunt = s end)
createToggle("⚡ Ускорение x3", function(s)
    State.Boost = s
end)
createToggle("🕊️ Полёт", function(s) State.Fly = s end)
createToggle("👻 NoClip", function(s)
    State.NoClip = s
    local char = LocalPlayer.Character
    if char then
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then
                p.CanCollide = not s
            end
        end
    end
end)
createToggle("🛡️ God Mode", function(s)
    State.GodMode = s
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char.Humanoid.MaxHealth = s and math.huge or 100
        char.Humanoid.Health = s and math.huge or 100
    end
end)
createToggle("💤 Anti-AFK", function(s) State.AntiAFK = s end)
createToggle("🦘 Бесконечный прыжок", function(s) State.InfiniteJump = s end)

-- СЛАЙДЕР скорости
createSlider("💨 Скорость ходьбы", WalkSpeedMin, WalkSpeedMax, WalkSpeedValue, function(val)
    WalkSpeedValue = val
    if State.SpeedApply then
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid.WalkSpeed = val
        end
    end
end)

-- Тумблер "Применять скорость"
createToggle("✅ Применить скорость", function(s)
    State.SpeedApply = s
    local char = LocalPlayer.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char.Humanoid.WalkSpeed = s and WalkSpeedValue or 16
    end
end)

createToggle("🎪 Авто-Флип", function(s) State.AutoFlip = s end)

-- Обновление CanvasSize
ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 16)
end)

-- ================= ЛОГИКА =================

-- Anti-AFK
task.spawn(function()
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        if State.AntiAFK then
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end
    end)
end)

-- Бесконечный прыжок
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if State.InfiniteJump and input.KeyCode == Enum.KeyCode.Space then
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Основной цикл
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end

    -- Постоянно применяем скорость
    if State.SpeedApply then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed ~= WalkSpeedValue then
            hum.WalkSpeed = WalkSpeedValue
        end
    end

    if State.NoClip then
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end

    if State.GodMode then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.MaxHealth = math.huge
            hum.Health = math.huge
        end
    end

    local seat = char:FindFirstChildWhichIsA("VehicleSeat")
    if not seat then return end

    if State.AutoDrive then
        if seat.Velocity.Magnitude < CONFIG.AutoDriveSpeed then
            seat.Velocity = seat.CFrame.LookVector * CONFIG.AutoDriveSpeed
        end
    end

    if State.Boost then
        seat.Velocity = seat.CFrame.LookVector * CONFIG.BoostSpeed
    end

    if State.AutoStunt then
        local body = seat.Parent and seat.Parent:FindFirstChildWhichIsA("BasePart")
        if body then
            body.Velocity = body.Velocity + Vector3.new(0, CONFIG.StuntForce, 0)
            body.RotVelocity = body.RotVelocity + Vector3.new(0, 10, 0)
        end
    end

    if State.AutoFlip then
        local body = seat.Parent and seat.Parent:FindFirstChildWhichIsA("BasePart")
        if body then
            body.RotVelocity = body.RotVelocity + Vector3.new(15, 0, 0)
        end
    end

    if State.Fly then
        local body = seat.Parent and seat.Parent:FindFirstChildWhichIsA("BasePart")
        if body then
            local dir = Vector3.new(0, 0, 0)
            local cam = workspace.CurrentCamera
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                dir = dir + cam.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                dir = dir - cam.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                dir = dir + Vector3.new(0, 1, 0)
            end
            if dir.Magnitude > 0 then
                body.Velocity = dir.Unit * CONFIG.FlySpeed
            end
        end
    end
end)

print("✅ Kukirin Premium v3 загружено! Слайдер скорости готов.")
