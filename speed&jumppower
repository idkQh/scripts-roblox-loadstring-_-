-- loadstring:
local player = game:GetService("Players").LocalPlayer
local gui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local speedSlider = Instance.new("TextBox")
local jumpSlider = Instance.new("TextBox")
local speedLabel = Instance.new("TextLabel")
local jumpLabel = Instance.new("TextLabel")
local drag = Instance.new("TextButton")

gui.Parent = player.PlayerGui
gui.ResetOnSpawn = false

frame.Parent = gui
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.new(1, 0, 0)

drag.Parent = frame
drag.Size = UDim2.new(1, 0, 0, 20)
drag.Position = UDim2.new(0, 0, 0, 0)
drag.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
drag.Text = "Drag Me"
drag.TextColor3 = Color3.new(1, 1, 1)
drag.BorderSizePixel = 0

speedLabel.Parent = frame
speedLabel.Size = UDim2.new(1, -20, 0, 20)
speedLabel.Position = UDim2.new(0, 10, 0, 30)
speedLabel.Text = "WALKSPEED: 16"
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.BackgroundTransparency = 1

speedSlider.Parent = frame
speedSlider.Size = UDim2.new(1, -20, 0, 30)
speedSlider.Position = UDim2.new(0, 10, 0, 55)
speedSlider.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
speedSlider.Text = "16"
speedSlider.TextColor3 = Color3.new(1, 1, 1)
speedSlider.PlaceholderText = "Enter speed (1-INFINITY)"

jumpLabel.Parent = frame
jumpLabel.Size = UDim2.new(1, -20, 0, 20)
jumpLabel.Position = UDim2.new(0, 10, 0, 100)
jumpLabel.Text = "JUMP POWER: 50"
jumpLabel.TextColor3 = Color3.new(1, 1, 1)
jumpLabel.BackgroundTransparency = 1

jumpSlider.Parent = frame
jumpSlider.Size = UDim2.new(1, -20, 0, 30)
jumpSlider.Position = UDim2.new(0, 10, 0, 125)
jumpSlider.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
jumpSlider.Text = "50"
jumpSlider.TextColor3 = Color3.new(1, 1, 1)
jumpSlider.PlaceholderText = "Enter jump power (1-INFINITY)"

local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

drag.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

drag.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

speedSlider.FocusLost:Connect(function(enterPressed)
    local speed = tonumber(speedSlider.Text)
    if speed and speed >= 1 then
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = speed
            speedLabel.Text = "WALKSPEED: " .. speed
        end
    else
        speedSlider.Text = "16"
        speedLabel.Text = "WALKSPEED: 16"
    end
end)

jumpSlider.FocusLost:Connect(function(enterPressed)
    local jump = tonumber(jumpSlider.Text)
    if jump and jump >= 1 then
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.JumpPower = jump
            jumpLabel.Text = "JUMP POWER: " .. jump
        end
    else
        jumpSlider.Text = "50"
        jumpLabel.Text = "JUMP POWER: 50"
    end
end)
