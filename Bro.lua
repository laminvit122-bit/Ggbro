-- == KUKIRIN MENU v4 ==
-- Центрированное меню + рабочий скролл

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ================= НАСТРОЙКИ =================
local CONFIG = {
    AutoDriveSpeed = 120,
    BoostSpeed     = 400,
    FlySpeed       = 180,
}

local WalkSpeedValue = 16
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
    SpeedApply   = false,
    AutoFlip     = false,
}

-- ================= GUI =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KukirinMenuV4"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- МЕНЮ: меньше по высоте, чтобы точно влезло и было по центру
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 420)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(80, 80, 80)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- ================= ПЕРЕТАСКИВАНИЕ =================
local dragging = false
local dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

-- Верхняя панель (за неё таскаем)
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 42)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.BorderSizePixel = 0
TitleBar.Active = true
TitleBar.Parent = MainFrame

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateDrag(input)
    end
end)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⚡ KUKIRIN MENU"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 16
TitleLabel.Parent = TitleBar

-- ================= СКРОЛЛ =================
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, 0, 1, -42)
Scroll.Position = UDim2.new(0, 0, 0, 42)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 5
Scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 110)
Scroll.ScrollBarImageTransparency = 0
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollingDirection = Enum.ScrollingDirection.Y
Scroll.Parent = MainFrame

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 8)
ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
ListLayout.Parent = Scroll

local Pad = Instance.new("UIPadding")
Pad.PaddingTop = UDim.new(0, 10)
Pad.PaddingLeft = UDim.new(0, 10)
Pad.PaddingRight = UDim.new(0, 10)
Pad.PaddingBottom = UDim.new(0, 10)
Pad.Parent = Scroll

-- ================= ТУМБЛЕР =================
local function createToggle(text, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Size = UDim2.new(1, 0, 0, 46)
    Toggle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Toggle.Text = ""
    Toggle.AutoButtonColor = false
    Toggle.BorderSizePixel = 0
    Toggle.Parent = Scroll

    local C = Instance.new("UICorner")
    C.CornerRadius = UDim.new(0, 10)
    C.Parent = Toggle

    local S = Instance.new("UIStroke")
    S.Color = Color3.fromRGB(80, 80, 80)
    S.Thickness = 1
    S.Parent = Toggle

    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(0.7, 0, 1, 0)
    L.Position = UDim2.new(0.05, 0, 0, 0)
    L.BackgroundTransparency = 1
    L.Text = text
    L.TextColor3 = Color3.fromRGB(255, 255, 255)
    L.Font = Enum.Font.GothamBold
    L.TextSize = 13
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = Toggle

    local St = Instance.new("TextLabel")
    St.Size = UDim2.new(0.2, 0, 1, 0)
    St.Position = UDim2.new(0.75, 0, 0, 0)
    St.BackgroundTransparency = 1
    St.Text = "ВЫКЛ"
    St.TextColor3 = Color3.fromRGB(150, 150, 150)
    St.Font = Enum.Font.GothamBold
    St.TextSize = 11
    St.Parent = Toggle

    local state = false

    Toggle.MouseButton1Click:Connect(function()
        state = not state
        callback(state)

        if state then
            TweenService:Create(Toggle, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(240, 240, 240)
            }):Play()
            TweenService:Create(S, TweenInfo.new(0.3), {Color = Color3.fromRGB(0, 220, 120)}):Play()
            TweenService:Create(L, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(20,20,20)}):Play()
            St.Text = "ВКЛ"
            St.TextColor3 = Color3.fromRGB(0, 180, 100)
        else
            TweenService:Create(Toggle, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            }):Play()
            TweenService:Create(S, TweenInfo.new(0.3), {Color = Color3.fromRGB(80,80,80)}):Play()
            TweenService:Create(L, TweenInfo.new(0.3), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
            St.Text = "ВЫКЛ"
            St.TextColor3 = Color3.fromRGB(150, 150, 150)
        end
    end)
end

-- ================= СЛАЙДЕР =================
local function createSlider(labelText, minVal, maxVal, defaultVal, callback)
    local Box = Instance.new("Frame")
    Box.Size = UDim2.new(1, 0, 0, 68)
    Box.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Box.BorderSizePixel = 0
    Box.Parent = Scroll

    local BC = Instance.new("UICorner")
    BC.CornerRadius = UDim.new(0, 10)
    BC.Parent = Box

    local BS = Instance.new("UIStroke")
    BS.Color = Color3.fromRGB(80, 80, 80)
    BS.Thickness = 1
    BS.Parent = Box

    local Lbl = Instance.new("TextLabel")
    Lbl.Size = UDim2.new(0.6, 0, 0, 25)
    Lbl.Position = UDim2.new(0.05, 0, 0, 5)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = labelText
    Lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    Lbl.Font = Enum.Font.GothamBold
    Lbl.TextSize = 13
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.Parent = Box

    local ValLbl = Instance.new("TextLabel")
    ValLbl.Size = UDim2.new(0.3, 0, 0, 25)
    ValLbl.Position = UDim2.new(0.65, 0, 0, 5)
    ValLbl.BackgroundTransparency = 1
    ValLbl.Text = tostring(defaultVal)
    ValLbl.TextColor3 = Color3.fromRGB(0, 220, 120)
    ValLbl.Font = Enum.Font.GothamBold
    ValLbl.TextSize = 15
    ValLbl.TextXAlignment = Enum.TextXAlignment.Right
    ValLbl.Parent = Box

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(0.9, 0, 0, 8)
    Track.Position = UDim2.new(0.05, 0, 0, 43)
    Track.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Track.BorderSizePixel = 0
    Track.Parent = Box

    local TC = Instance.new("UICorner")
    TC.CornerRadius = UDim.new(1, 0)
    TC.Parent = Track

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(0, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 200, 110)
    Fill.BorderSizePixel = 0
    Fill.Parent = Track

    local FC = Instance.new("UICorner")
    FC.CornerRadius = UDim.new(1, 0)
    FC.Parent = Fill

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 22, 0, 22)
    Knob.Position = UDim2.new(0, -11, 0.5, -11)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.Parent = Track

    local KC = Instance.new("UICorner")
    KC.CornerRadius = UDim.new(1, 0)
    KC.Parent = Knob

    local KS = Instance.new("UIStroke")
    KS.Color = Color3.fromRGB(0, 200, 110)
    KS.Thickness = 3
    KS.Parent = Knob

    local function updateFromValue(val)
        val = math.clamp(val, minVal, maxVal)
        local percent = (val - minVal) / (maxVal - minVal)
        Fill.Size = UDim2.new(percent, 0, 1, 0)
        Knob.Position = UDim2.new(percent, -11, 0.5, -11)
        ValLbl.Text = tostring(math.floor(val))
        callback(math.floor(val))
    end

    local draggingSlider = false
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
            draggingSlider = true
            handleInput(input)
        end
    end)

    Knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            handleInput(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end)

    updateFromValue(defaultVal)
end

-- ================= СОЗДАЁМ ЭЛЕМЕНТЫ =================
createToggle("🚗 Авто-Езда", function(s) State.AutoDrive = s end)
createToggle("🔄 Авто-Стант", function(s) State.AutoStunt = s end)
createToggle("⚡ Ускорение x3", function(s) State.Boost = s end)
createToggle("🕊️ Полёт", function(s) State.Fly = s end)
createToggle("👻 NoClip", function(s) State.NoClip = s end)
createToggle("🛡️ God Mode", function(s) State.GodMode = s end)
createToggle("💤 Anti-AFK", function(s) State.AntiAFK = s end)
createToggle("🦘 Бесконечный прыжок", function(s) State.InfiniteJump = s end)

createSlider("💨 Скорость ходьбы", WalkSpeedMin, WalkSpeedMax, WalkSpeedValue, function(val)
    WalkSpeedValue = val
    State.SpeedApply = true
end)

createToggle("🎪 Авто-Флип", function(s) State.AutoFlip = s end)

-- Автоматически обновляем высоту скролла
ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 20)
end)

-- ================= ЛОГИКА =================

task.spawn(function()
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        if State.AntiAFK then
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end
    end)
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if State.InfiniteJump and input.KeyCode == Enum.KeyCode.Space then
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Поиск транспорта
local function getVehicle()
    local char = LocalPlayer.Character
    if not char then return nil, nil end
    local seat = char:FindFirstChildWhichIsA("VehicleSeat")
    if not seat then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local closest, dist = nil, 30
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("VehicleSeat") then
                    local d = (obj.Position - hrp.Position).Magnitude
                    if d < dist then dist = d; closest = obj end
                end
            end
            seat = closest
        end
    end
    if not seat then return nil, nil end
    local body = seat.Parent and seat.Parent:FindFirstChildWhichIsA("BasePart")
    return seat, body
end

RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")

    if State.SpeedApply and hum then
        if hum.WalkSpeed ~= WalkSpeedValue then
            hum.WalkSpeed = WalkSpeedValue
        end
    end

    if State.NoClip then
        for _, p in pairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
        local seat, body = getVehicle()
        if seat and seat.Parent then
            for _, p in pairs(seat.Parent:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end

    if State.GodMode and hum then
        hum.MaxHealth = math.huge
        hum.Health = math.huge
    end

    if State.InfiniteJump and hum and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        if hum:GetState() ~= Enum.HumanoidStateType.Jumping then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end

    local seat, body = getVehicle()
    if not seat or not body then return end

    if State.AutoDrive then
        if seat.Velocity.Magnitude < CONFIG.AutoDriveSpeed then
            seat.Velocity = seat.CFrame.LookVector * CONFIG.AutoDriveSpeed
        end
    end

    if State.Boost then
        seat.Velocity = seat.CFrame.LookVector * CONFIG.BoostSpeed
    end

    if State.AutoStunt then
        body.Velocity = body.Velocity + Vector3.new(0, 100, 0)
        body.RotVelocity = body.RotVelocity + Vector3.new(0, 15, 0)
    end

    if State.AutoFlip then
        body.RotVelocity = body.RotVelocity + Vector3.new(20, 0, 0)
    end

    if State.Fly then
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
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            dir = dir - Vector3.new(0, 1, 0)
        end
        if dir.Magnitude > 0 then
            body.Velocity = dir.Unit * CONFIG.FlySpeed
        end
    end
end)

print("✅ Kukirin Menu v4 загружено! Скролл справа работает.")
