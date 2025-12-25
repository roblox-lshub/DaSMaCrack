local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()local Confirmed = false

WindUI:Popup({
    Title = "大司马脚本付费版 V2",
    IconThemed = true,
    Content = "欢迎尊贵的用户" .. game.Players.LocalPlayer.Name .. "使用大司马脚本付费版 当前版本型号:V2",
    Buttons = {
        {
            Title = "取消",
            Callback = function() end,
            Variant = "Secondary",
        },
        {
            Title = "执行",
            Icon = "arrow-right",
            Callback = function() 
                Confirmed = true
                createUI()
            end,
            Variant = "Primary",
        }
    }
})
function createUI()
    local Window = WindUI:CreateWindow({
        Title = "大司马脚本付费版",
        Icon = "palette",
    Author = "尊贵的"..game.Players.localPlayer.Name.."欢迎使用大司马脚本付费版", 
        Folder = "Premium",
        Size = UDim2.fromOffset(550, 320),
        Theme = "Light",
        User = {
            Enabled = true,
            Anonymous = true,
            Callback = function()
            end
        },
        SideBarWidth = 200,
        HideSearchBar = false,  
    })

    Window:Tag({
        Title = "植物VS脑红",
        Color = Color3.fromHex("#00ffff") 
    })

    Window:EditOpenButton({
        Title = "大司马脚本付费版V2",
        Icon = "crown",
        CornerRadius = UDim.new(0, 8),
        StrokeThickness = 3,
        Color = ColorSequence.new(
            Color3.fromRGB(255, 255, 0),  
            Color3.fromRGB(255, 165, 0),  
            Color3.fromRGB(255, 0, 0),    
            Color3.fromRGB(139, 0, 0)     
        ),
        Draggable = true,
    })
local MainTab = Window:Tab({Title = "主要功能", Icon = "settings"})
local DefaultKillAuraDistance = 20
if not DistanceForKillAura then
    DistanceForKillAura = DefaultKillAuraDistance
end

MainTab:Toggle({
    Title = "杀戮光环",
    Icon = "check",
    Default = false,
    Callback = function(Value)
        _G.AutoAttack = Value
        if Value then
            local RS = game:GetService("ReplicatedStorage")
            local Event = RS.Remotes.AttacksServer.WeaponAttack
            local Players = game:GetService("Players")
            local Player = Players.LocalPlayer
            local Char = Player.Character or Player.CharacterAdded:Wait()
            local HRP = Char:WaitForChild("HumanoidRootPart")

            Player.CharacterAdded:Connect(function(c)
                Char = c
                HRP = c:WaitForChild("HumanoidRootPart")
            end)

            task.spawn(function()
                while _G.AutoAttack do
                    local targets = {}
                    for _, mob in ipairs(workspace.ScriptedMap.Brainrots:GetChildren()) do
                        local pp = mob.PrimaryPart or mob:FindFirstChild("HumanoidRootPart")
                        if pp and (pp.Position - HRP.Position).Magnitude <= DistanceForKillAura then
                            table.insert(targets, mob.Name)
                        end
                    end
                    if #targets > 0 then
                        Event:FireServer(targets)
                    end
                    task.wait()
                end
            end)
        end
    end
})

MainTab:Input({
    Title = "攻击范围[20默认]",
    Value = tostring(DefaultKillAuraDistance),
    Callback = function(value)
        local numValue = tonumber(value)
        if numValue then
            DistanceForKillAura = numValue
        else
        end
    end
})

local autoSell = false  
MainTab:Section({Title = "出售脑红"})
MainTab:Toggle({
    Title = "自动出售脑红",
    Default = false,
    Callback = function(state)
        autoSell = state
        if autoSell then
            task.spawn(function()
                while autoSell do
             
                    local success, errorMsg = pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.ItemSell:FireServer()
                    end)
                    
                    if not success then
                       
                    end
                    
                  
                    task.wait(0.1)  
                end
            end)
        end
    end
})
local sellInterval = 0.1
MainTab:Slider({
    Title = "出售间隔",
    Value = {
        Min = 0.05,
        Max = 1,
        Default = 0.1
    },
    Callback = function(Value)
        sellInterval = Value
    end
})

local autoSell = false  
MainTab:Section({Title = "出售植物"})
MainTab:Toggle({
    Title = "自动出售植物",
    Default = false,
    Callback = function(state)
        autoSell = state
        if autoSell then
            task.spawn(function()
                while autoSell do
                    local success, errorMsg = pcall(function()
                        local args = {
                            [2] = true
                        }
                        game:GetService("ReplicatedStorage").Remotes.ItemSell:FireServer(unpack(args))
                    end)
                    
                    if not success then
                  
                    end
                    
                    task.wait(sellInterval)  
                end
            end)
        end
    end
})

local sellInterval = 0.1
MainTab:Slider({
    Title = "出售间隔",
    Value = {
        Min = 0.05,
        Max = 1,
        Default = 0.1
    },
    Callback = function(Value)
        sellInterval = Value
    end
})

local AutoBuySeeds = Window:Tab({Title = "购买功能", Icon = "settings"})
local seedList = {
    "Cactus Seed",
    "Strawberry Seed", 
    "Pumpkin Seed",
    "Sunflower Seed",
    "Dragon Fruit Seed",
    "Eggplant Seed",
    "Watermelon Seed",
    "Grape Seed",
    "Cocotank Seed",
    "Carnivorous Plant Seed",
    "Mr Carrot Seed",
    "Tomatrio Seed",
    "Shroombino Seed",
    "Mango Seed",
    "King Limone Seed"
}

local chineseNames = {
    ["Cactus Seed"] = "仙人掌种子",
    ["Strawberry Seed"] = "草莓种子",
    ["Pumpkin Seed"] = "南瓜种子",
    ["Sunflower Seed"] = "向日葵种子",
    ["Dragon Fruit Seed"] = "火龙果种子",
    ["Eggplant Seed"] = "茄子种子",
    ["Watermelon Seed"] = "西瓜种子",
    ["Grape Seed"] = "葡萄种子",
    ["Cocotank Seed"] = "可可坦克种子",
    ["Carnivorous Plant Seed"] = "食人植物种子",
    ["Mr Carrot Seed"] = "胡萝卜先生种子",
    ["Tomatrio Seed"] = "番茄三重奏种子",
    ["Shroombino Seed"] = "蘑菇宾诺种子",
    ["Mango Seed"] = "芒果种子",
    ["King Limone Seed"] = "柠檬王种子"
}
local chineseSeedOptions = {}
for engName, chsName in pairs(chineseNames) do
    chineseSeedOptions[chsName] = engName
end
local chineseSeedList = {}
for _, chsName in pairs(chineseNames) do
    table.insert(chineseSeedList, chsName)
end
local selectedSeeds = {}
AutoBuySeeds:Dropdown({
    Title = "选择要购买的种子",
    Values = chineseSeedList,
    Value = {},
    Multi = true,
    Callback = function(selectedChineseNames)
        selectedSeeds = {}
        for _, chsName in ipairs(selectedChineseNames) do
            local engName = chineseSeedOptions[chsName]
            if engName then
                table.insert(selectedSeeds, engName)
            end
        end
    end
})
AutoBuySeeds:Button({
    Title = "购买一次选中种子",
    Callback = function()
        for _, seedName in ipairs(selectedSeeds) do
            local args = {
                [1] = seedName,
                [2] = true
            }
            game:GetService("ReplicatedStorage").Remotes.BuyItem:FireServer(unpack(args))
            
            WindUI:Notify({
                Title = "购买成功",
                Content = "已购买: " .. chineseNames[seedName],
                Duration = 2,
                Icon = "shopping-cart"
            })
            
            task.wait(0.1)
        end
    end
})

local autoBuyEnabled = false
local buyConnection

AutoBuySeeds:Toggle({
    Title = "自动购买选中种子",
    Value = false,
    Callback = function(state)
        autoBuyEnabled = state
        
        if buyConnection then
            buyConnection:Disconnect()
            buyConnection = nil
        end
        
        if state then
            buyConnection = RunService.Heartbeat:Connect(function()
            
                for _, seedName in ipairs(selectedSeeds) do
                    local args = {
                        [1] = seedName,
                        [2] = true
                    }
                    game:GetService("ReplicatedStorage").Remotes.BuyItem:FireServer(unpack(args))
                    task.wait(0.2)
                end
            end)
        end
    end
})

AutoBuySeeds:Button({
    Title = "强制停止自动购买[防bug可不用]",
    Callback = function()
        autoBuyEnabled = false
        if buyConnection then
            buyConnection:Disconnect()
            buyConnection = nil
        end
        WindUI:Notify({
            Title = "已停止",
            Content = "已停止自动购买",
            Duration = 2,
            Icon = "stop-circle"
        })
    end
})
end