local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(char)
	character = char
	hrp = char:WaitForChild("HumanoidRootPart")
end)

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "TeamTPGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,220,0,170)
frame.Position = UDim2.new(0.5,-110,0.5,-85)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

-- Mobile + PC Dragging
local dragging = false
local dragStart
local startPos

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
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

UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- Speed Button
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0.9,0,0,35)
speedButton.Position = UDim2.new(0.05,0,0.05,0)
speedButton.Text = "TP Speed: 0.25s"
speedButton.TextScaled = true
speedButton.BackgroundColor3 = Color3.fromRGB(120,120,120)
speedButton.TextColor3 = Color3.new(1,1,1)
speedButton.Parent = frame
Instance.new("UICorner", speedButton).CornerRadius = UDim.new(0,12)

-- Blue Button
local blueButton = Instance.new("TextButton")
blueButton.Size = UDim2.new(0.9,0,0,45)
blueButton.Position = UDim2.new(0.05,0,0.35,0)
blueButton.Text = "Blue Team TP"
blueButton.TextScaled = true
blueButton.BackgroundColor3 = Color3.fromRGB(0,120,255)
blueButton.TextColor3 = Color3.new(1,1,1)
blueButton.Parent = frame
Instance.new("UICorner", blueButton).CornerRadius = UDim.new(0,12)

-- Red Button
local redButton = Instance.new("TextButton")
redButton.Size = UDim2.new(0.9,0,0,45)
redButton.Position = UDim2.new(0.05,0,0.68,0)
redButton.Text = "Red Team TP"
redButton.TextScaled = true
redButton.BackgroundColor3 = Color3.fromRGB(220,50,50)
redButton.TextColor3 = Color3.new(1,1,1)
redButton.Parent = frame
Instance.new("UICorner", redButton).CornerRadius = UDim.new(0,12)

-- Correct Coordinates
local bluePos1 = CFrame.new(-35.60, 11.00, 111.82)
local bluePos2 = CFrame.new(-56.82, 11.55, 169.13)

local redPos1 = CFrame.new(-56.00, 11.55, -175.00)
local redPos2 = CFrame.new(-74.84, 11.00, -117.71)

-- Speed Settings
local speeds = {0.01, 0.25, 0.5, 1}
local speedIndex = 2
local tpDelay = speeds[speedIndex]

speedButton.MouseButton1Click:Connect(function()
	speedIndex = speedIndex + 1
	if speedIndex > #speeds then
		speedIndex = 1
	end
	tpDelay = speeds[speedIndex]
	speedButton.Text = "TP Speed: " .. tpDelay .. "s"
end)

local blueRunning = false
local redRunning = false

blueButton.MouseButton1Click:Connect(function()
	blueRunning = not blueRunning
	redRunning = false

	blueButton.Text = blueRunning and "Stop Blue TP" or "Blue Team TP"
	redButton.Text = "Red Team TP"

	if blueRunning then
		task.spawn(function()
			local toggle = true
			while blueRunning do
				if hrp then
					hrp.CFrame = toggle and bluePos1 or bluePos2
				end
				toggle = not toggle
				task.wait(tpDelay)
			end
		end)
	end
end)

redButton.MouseButton1Click:Connect(function()
	redRunning = not redRunning
	blueRunning = false

	redButton.Text = redRunning and "Stop Red TP" or "Red Team TP"
	blueButton.Text = "Blue Team TP"

	if redRunning then
		task.spawn(function()
			local toggle = true
			while redRunning do
				if hrp then
					hrp.CFrame = toggle and redPos1 or redPos2
				end
				toggle = not toggle
				task.wait(tpDelay)
			end
		end)
	end
end)
