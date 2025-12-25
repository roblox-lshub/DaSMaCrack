print("Hi Skiddiddy")

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Stats = game:GetService("Stats")

local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)
if not success then
    warn("Failed to load Rayfield: " .. tostring(Rayfield))
    return
end

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local BallsFolder = Workspace:WaitForChild("Balls", 9e9)
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 9e9)
local AbilityButtonPress = Remotes:WaitForChild("AbilityButtonPress")
local ParryButtonPress = Remotes:WaitForChild("ParryButtonPress")

-- Konfigurasi
getgenv().Vico = {
    AutoParry = true,
    PingBased = true,
    PingBasedOffset = 0.05,
    BallSpeedCheck = true,
    ParryRangeMultiplier = 2,
}

local UseRage = false
local SliderValue = 2

local Window = Rayfield:CreateWindow({
    Name = "大司马脚本",
    LoadingTitle = "大司马脚本",
    LoadingSubtitle = "作者大司马",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BladeBallerlol",
        FileName = "VicoConfig"
    }
})

local AutoParryTab = Window:CreateTab("主要功能")
local MainTab = Window:CreateTab("其他功能", 13014546637)
local AutoOpenTab = Window:CreateTab("无", 13014546637)

-- Anticheat bypass
local success, bypass = pcall(function()
    loadstring(game:GetObjects("rbxassetid://15900013841")[1].Source)()
end)
if not success then
    warn("Failed to load anticheat bypass: " .. tostring(bypass))
end

local function initialize(dataFolder_name)
    local Vico_Data = Instance.new("Folder", game:GetService("CoreGui"))
    Vico_Data.Name = dataFolder_name
end

local function onCharacterAdded(newCharacter)
    Character = newCharacter
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

local function VerifyBall(Ball)
    return typeof(Ball) == "Instance" and Ball:IsA("BasePart") and Ball:IsDescendantOf(BallsFolder) and Ball:GetAttribute("realBall") == true
end

local function IsTheTarget()
    return Character and Character:FindFirstChild("Highlight")
end

local function FindBall()
    for _, v in pairs(BallsFolder:GetChildren()) do
        if v:GetAttribute("realBall") == true then
            return v
        end
    end
    return nil
end

local function getPing()
    local success, ping = pcall(function()
        return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 1000
    end)
    return success and math.max(0.05, math.min(0.5, ping)) or 0.1
end

   local function sendParryClick()    
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)        
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end
    
local function isStationary()
    local humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    return humanoid and humanoid.WalkSpeed == 0
end

local function Parry()
    pcall(function()
        local abilities = Character and Character:FindFirstChild("Abilities")
        if abilities and abilities:FindFirstChild("Raging Deflection") and abilities["Raging Deflection"].Enabled and UseRage then
            AbilityButtonPress:Fire()
            task.wait(0)
            if not isStationary() then
                sendParryClick()
            end
        else
            ParryButtonPress:Fire()
            sendParryClick()
        end
    end)
end

local function startAutoParry()
    RunService.PreRender:Connect(function()
        if not Vico.AutoParry or not Character or not Character.PrimaryPart then
            return
        end

        local Ball = FindBall()
        if not Ball or not Ball.Position then
            return
        end

        local BallPosition = Ball.Position
        local BallVelocity = Ball.AssemblyLinearVelocity.Magnitude
        local Distance = (BallPosition - Character.PrimaryPart.Position).Magnitude
        local ping = Vico.PingBased and getPing() or 0
        local ping_threshold = math.clamp(ping / 10, 10, 20)
        local parryRange = (ping_threshold + Vico.PingBasedOffset) + (BallVelocity / math.pi) * Vico.ParryRangeMultiplier

        if Vico.BallSpeedCheck and BallVelocity < 5 then
            return
        end

        if Distance <= parryRange and IsTheTarget() then
            Parry()
        end
    end)
end

local function equipAbility(abilityName)
    pcall(function()
        ReplicatedStorage.Remotes.Store.RequestEquipAbility:InvokeServer(abilityName)
        ReplicatedStorage.Remotes.Store.GetOwnedAbilities:InvokeServer()
    end)
end

local function sendNotif(title, text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = 3,
            Icon = "rbxassetid://14763355020"
        })
    end)
end

local function getExplosion()
    local success, explosion = pcall(function()
        local _, result = ReplicatedStorage.Remotes.Store.RequestOpenExplosionBox:InvokeServer()
        return result
    end)
    return success and explosion or "Error"
end

local function getSword()
    local success, sword = pcall(function()
        local _, result = ReplicatedStorage.Remotes.Store.RequestOpenSwordBox:InvokeServer()
        return result
    end)
    return success and sword or "Error"
end

AutoParryTab:CreateToggle({
    Name = "自动格挡",
    CurrentValue = false,
    Flag = "AutoParryFlag",
    Callback = function(Value)
        Vico.AutoParry = Value
        if Value then
            startAutoParry()
        end
    end
})

AutoParryTab:CreateToggle({
    Name = "|•自动狂暴格挡 (必须装备狂暴偏转)•|",
    CurrentValue = false,
    Flag = "AutoRagingDeflectFlag",
    Callback = function(Value)
        UseRage = Value
    end
})

AutoParryTab:CreateSlider({
    Name = "狂暴范围",
    Range = {0.5, 3},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = 2,
    Flag = "ParryRangeMultiplierSlider",
    Callback = function(Value)
        Vico.ParryRangeMultiplier = Value
    end
})

AutoParryTab:CreateToggle({
    Name = "|•抗 AFK•|",
    CurrentValue = false,
    Flag = "AntiAfk",
    Callback = function(Value)
        if Value then
            LocalPlayer.Idled:Connect(function()
                local vu = game:GetService("VirtualUser")
                pcall(function()
                    vu:Button2Down(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
                    task.wait(0.5)
                    vu:Button2Up(Vector2.new(0, 0), Workspace.CurrentCamera.CFrame)
                end)
            end)
        end
    end
})

MainTab:CreateButton({
    Name = "短划线",
    Callback = function()
        equipAbility("短划线")
    end
})

MainTab:CreateButton({
    Name = "磁场",
    Callback = function()
        equipAbility("磁场")
    end
})

MainTab:CreateButton({
    Name = "隐身",
    Callback = function()
        equipAbility("隐身")
    end
})

MainTab:CreateButton({
    Name = "平台",
    Callback = function()
        equipAbility("平台")
    end
})

MainTab:CreateButton({
    Name = "狂暴偏转",
    Callback = function()
        equipAbility("狂暴偏转")
    end
})

MainTab:CreateButton({
    Name = "阴影步骤",
    Callback = function()
        equipAbility("阴影步骤")
    end
})

MainTab:CreateButton({
    Name = "超级跳跃",
    Callback = function()
        equipAbility("超级跳跃")
    end
})

MainTab:CreateButton({
    Name = "心灵感应",
    Callback = function()
        equipAbility("心灵感应")
    end
})

MainTab:CreateButton({
    Name = "雷霆冲刺",
    Callback = function()
        equipAbility("雷霆冲刺")
    end
})

MainTab:CreateButton({
    Name = "狂喜",
    Callback = function()
        equipAbility("狂喜")
    end
})

-- Inisialisasi
initialize("vico_temp")
if Vico.AutoParry then
    startAutoParry()
end