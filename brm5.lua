-- [[ BRM5 ELITE HUB - FIXED VERSION ]] --
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local camera = workspace.CurrentCamera
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- UI SETUP
local sg = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 250, 0, 350)
frame.Position = UDim2.new(0.5, -125, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Visible = false
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame)

local title = Instance.new("TextLabel", frame)
title.Text = "BRM5 ADMIN HUB [P]"
title.Size = UDim2.new(1, 0, 0, 40)
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold

-- SETTINGS
local _G = {
    fly = false,
    noclip = false,
    esp = false,
    aim = false,
    speed = 3
}

-- BUTTON FUNCTION
local function createBtn(txt, y, cb)
    local b = Instance.new("TextButton", frame)
    b.Text = txt
    b.Size = UDim2.new(0.9, 0, 0, 35)
    b.Position = UDim2.new(0.05, 0, 0, y)
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    b.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(cb)
end

-- BUTTONS
createBtn("TOGGLE FLY", 50, function() _G.fly = not _G.fly player.Character.Humanoid.PlatformStand = _G.fly end)
createBtn("TOGGLE NOCLIP", 100, function() _G.noclip = not _G.noclip end)
createBtn("TOGGLE ESP", 150, function() _G.esp = not _G.esp end)
createBtn("TOGGLE SILENT AIM", 200, function() _G.aim = not _G.aim end)
createBtn("SPEED UP (+)", 250, function() _G.speed = _G.speed + 1 end)
createBtn("SPEED DOWN (-)", 300, function() _G.speed = math.max(1, _G.speed - 1) end)

-- TOGGLE KEY
UIS.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.P then frame.Visible = not frame.Visible end
end)

-- CORE LOGIC
RunService.RenderStepped:Connect(function()
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    -- FLY & NOCLIP
    if _G.fly then
        hrp.Velocity = Vector3.new(0, 0.1, 0)
        local dir = Vector3.new(0,0,0)
        if UIS:IsKeyDown("W") then dir += camera.CFrame.LookVector end
        if UIS:IsKeyDown("S") then dir -= camera.CFrame.LookVector end
        if UIS:IsKeyDown("A") then dir -= camera.CFrame.RightVector end
        if UIS:IsKeyDown("D") then dir += camera.CFrame.RightVector end
        hrp.CFrame = hrp.CFrame + (dir * _G.speed)
        
        if _G.noclip then
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end
    end

    -- ESP & AIM
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
            -- ESP
            local hl = v.Character:FindFirstChild("AdminESP")
            if _G.esp then
                if not hl then 
                    hl = Instance.new("Highlight", v.Character) 
                    hl.Name = "AdminESP" 
                    hl.DepthMode = 0
                end
            elseif hl then hl:Destroy() end

            -- SILENT AIM (Klik Kanan)
            if _G.aim and UIS:IsMouseButtonPressed(2) then
                local _, vis = camera:WorldToViewportPoint(v.Character.Head.Position)
                if vis then camera.CFrame = CFrame.new(camera.CFrame.Position, v.Character.Head.Position) end
            end
        end
    end
end)
print("BRM5 HUB LOADED! PRESS P")
