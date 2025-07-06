if not (game.PlaceId == 2753915549 or game.PlaceId == 4442272183 or game.PlaceId == 7449423635) then return end

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local TweenSvc = game:GetService("TweenService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local Enemies = workspace:FindFirstChild("Enemies")
local Bosses = workspace:FindFirstChild("Bosses")
local CommF = RS:FindFirstChild("CommF_")
if not Enemies then return end
if not Bosses then return end
if not CommF then return end

local gui = Instance.new("ScreenGui")
gui.Name = "DiegohubGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,360)
frame.Position = UDim2.new(0, 20, 0, 60)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local layout = Instance.new("UIListLayout", frame)
layout.Padding = UDim.new(0,4)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local toggles = {}

local function safeInvoke(...)
    local ok, err = pcall(function() CommF:InvokeServer(...) end)
end

local function safeTP(cf)
    TweenSvc:Create(hrp, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = cf}):Play()
end

local function CreateBtn(text, onClick)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -8, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Text = text
    btn.MouseButton1Click:Connect(function() onClick(btn) end)
    btn.LayoutOrder = table.getn(frame:GetChildren())
    return btn
end

CreateBtn("Auto Farm: Off", function(btn)
    toggles.farm = not toggles.farm
    btn.Text = "Auto Farm: " .. (toggles.farm and "On" or "Off")
    if toggles.farm then
        spawn(function()
            while toggles.farm do
                for _, mob in ipairs(Enemies:GetChildren()) do
                    if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                        safeTP(mob.HumanoidRootPart.CFrame * CFrame.new(0,5,0))
                        safeInvoke("Attack", "Normal")
                        task.wait(0.2)
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end)

CreateBtn("Auto Boss: Off", function(btn)
    toggles.boss = not toggles.boss
    btn.Text = "Auto Boss: " .. (toggles.boss and "On" or "Off")
    if toggles.boss then
        spawn(function()
            local bossNames = {"Arlong", "Terrorshark", "SeaBeast", "Tyrant"}
            while toggles.boss do
                for _, name in ipairs(bossNames) do
                    local b = Bosses:FindFirstChild(name)
                    if b and b:FindFirstChild("HumanoidRootPart") and b:FindFirstChild("Humanoid") and b.Humanoid.Health > 0 then
                        safeTP(b.HumanoidRootPart.CFrame * CFrame.new(0,5,0))
                        safeInvoke("Attack", "Normal")
                        task.wait(0.5)
                    end
                end
                task.wait(1)
            end
        end)
    end
end)

CreateBtn("Auto Quest: Off", function(btn)
    toggles.quest = not toggles.quest
    btn.Text = "Auto Quest: " .. (toggles.quest and "On" or "Off")
    if toggles.quest then
        spawn(function()
            local questNPCs = {"PirateNPC", "MarineNPC", "DojoMaster"}
            while toggles.quest do
                for _, npc in ipairs(questNPCs) do
                    safeInvoke("StartQuest", npc, 1)
                    task.wait(6)
                end
                task.wait(10)
            end
        end)
    end
end)

CreateBtn("Fruit Sniper: Off", function(btn)
    toggles.sniper = not toggles.sniper
    btn.Text = "Fruit Sniper: " .. (toggles.sniper and "On" or "Off")
    if toggles.sniper then
        spawn(function()
            while toggles.sniper do
                local ok, fruits = pcall(function() return CommF:InvokeServer("GetFruits") end)
                if ok and type(fruits) == "table" then
                    for _, fn in ipairs(fruits) do
                        local f = workspace:FindFirstChild(fn)
                        if f and f:FindFirstChild("Handle") then
                            safeTP(f.Handle.CFrame)
                            task.wait(0.5)
                        end
                    end
                end
                task.wait(2)
            end
        end)
    end
end)