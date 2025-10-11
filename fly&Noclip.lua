-- fly and noclip script 
-- if you no wanna copy that script here loadstring: 
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyNoclipGui"
screenGui.ResetOnSpawn = false
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 180, 0, 120)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui
local layout = Instance.new("UIListLayout")
layout.Parent = mainFrame
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.Padding = UDim.new(0, 10)
local flyButton = Instance.new("TextButton")
flyButton.Name = "FlyButton"
flyButton.Size = UDim2.new(0, 140, 0, 40)
flyButton.Text = "Fly: OFF"
flyButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
flyButton.TextColor3 = Color3.new(1,1,1)
flyButton.Font = Enum.Font.SourceSansBold
flyButton.TextSize = 22
flyButton.Parent = mainFrame
local noclipButton = Instance.new("TextButton")
noclipButton.Name = "NoclipButton"
noclipButton.Size = UDim2.new(0, 140, 0, 40)
noclipButton.Text = "Noclip: OFF"
noclipButton.BackgroundColor3 = Color3.fromRGB(34, 139, 34)
noclipButton.TextColor3 = Color3.new(1,1,1)
noclipButton.Font = Enum.Font.SourceSansBold
noclipButton.TextSize = 22
noclipButton.Parent = mainFrame
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local dragging = false
local dragInput = nil
local dragStart = nil
local startPos = nil
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        local delta = input.Position - dragStart
        local parent = mainFrame.Parent
        local viewportSize = parent.AbsoluteSize
        local newPos = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
        mainFrame.Position = newPos
    end
end)
local flying = false
local noclip = false
local bodyVelocity = nil
local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end
local function setFlying(enable)
    flying = enable
    flyButton.Text = "Fly: " .. (flying and "ON" or "OFF")
    local character = getCharacter()
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if flying then
        if not bodyVelocity then
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bodyVelocity.Velocity = Vector3.new(0,0,0)
            bodyVelocity.Parent = humanoidRootPart
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true
        end
    else
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end
local function setNoclip(enable)
    noclip = enable
    noclipButton.Text = "Noclip: " .. (noclip and "ON" or "OFF")
end
flyButton.MouseButton1Click:Connect(function()
    setFlying(not flying)
end)
noclipButton.MouseButton1Click:Connect(function()
    setNoclip(not noclip)
end)
local RunService = game:GetService("RunService")
local moveKeys = {
    [Enum.KeyCode.W] = false,
    [Enum.KeyCode.A] = false,
    [Enum.KeyCode.S] = false,
    [Enum.KeyCode.D] = false,
    [Enum.KeyCode.Space] = false,
    [Enum.KeyCode.LeftControl] = false,
}
local moveSpeed = 50
local function getMoveDirection()
    local cam = workspace.CurrentCamera
    local forward = cam.CFrame.LookVector
    local right = cam.CFrame.RightVector
    local up = Vector3.new(0,1,0)
    local dir = Vector3.new(0,0,0)
    if moveKeys[Enum.KeyCode.W] then dir = dir + forward end
    if moveKeys[Enum.KeyCode.S] then dir = dir - forward end
    if moveKeys[Enum.KeyCode.A] then dir = dir - right end
    if moveKeys[Enum.KeyCode.D] then dir = dir + right end
    if moveKeys[Enum.KeyCode.Space] then dir = dir + up end
    if moveKeys[Enum.KeyCode.LeftControl] then dir = dir - up end
    if dir.Magnitude > 0 then
        dir = dir.Unit
    end
    return dir
end
RunService.RenderStepped:Connect(function()
    if flying and bodyVelocity then
        local character = getCharacter()
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            bodyVelocity.Parent = humanoidRootPart
            bodyVelocity.Velocity = getMoveDirection() * moveSpeed
        end
    end
    if noclip then
        local character = getCharacter()
        for _, part in character:GetDescendants() do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if moveKeys[input.KeyCode] ~= nil then
        moveKeys[input.KeyCode] = true
    end
end)
UserInputService.InputEnded:Connect(function(input, processed)
    if moveKeys[input.KeyCode] ~= nil then
        moveKeys[input.KeyCode] = false
    end
end)
LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(1)
    if flying then
        setFlying(true)
    end
    if noclip then
        setNoclip(true)
    end
end)
