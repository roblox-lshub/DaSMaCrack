local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()local Confirmed = false

WindUI:Popup({
    Title = "大司马脚本付费版V2",
    IconThemed = true,
    Content = "尊贵的用户" .. game.Players.LocalPlayer.Name .. "使用大司马脚本付费版V2",
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
        Title = "建造基地",
        Color = Color3.fromHex("#00ffff") 
    })

    Window:EditOpenButton({
    Title = "大司马脚本付费版",
    Icon = "crown",
    CornerRadius = UDim.new(0, 8),
    StrokeThickness = 3,
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromHex("#FF0000")),
        ColorSequenceKeypoint.new(0.2, Color3.fromHex("#FFA500")),
        ColorSequenceKeypoint.new(0.4, Color3.fromHex("#FFFF00")),
        ColorSequenceKeypoint.new(0.6, Color3.fromHex("#00FF00")),
        ColorSequenceKeypoint.new(0.65, Color3.fromHex("#00FFFF")),
        ColorSequenceKeypoint.new(0.8, Color3.fromHex("#0000FF")),
        ColorSequenceKeypoint.new(0.9, Color3.fromHex("#8A2BE2")),
        ColorSequenceKeypoint.new(1, Color3.fromHex("#FFFFFF"))
    }),
    Draggable = true,
})

        local Main = Window:Tab({Title = "战斗", Icon = "settings"})
local rangeAttackEnabled = false
Main:Toggle({
    Title = "自动挥舞拳头",
    Value = false,
    Callback = function(value)
        rangeAttackEnabled = value
        if rangeAttackEnabled then
           
            while rangeAttackEnabled do
                local args = {
                    [1] = true,
                    [2] = Vector3.new(0, 0, 0),  
                    [3] = 50,                  
                    [4] = Enum.Material.Water,    
                    [5] = "RangeAttack"        
                }
                
                game:GetService("ReplicatedStorage").Remotes.Events.ToolState:FireServer(unpack(args))
                wait()
            end
        end
    end
})

local rangeAttackEnabled = false

Main:Toggle({
    Title = "范围攻击",
    Value = false,
    Callback = function(value)
        rangeAttackEnabled = value
        if value then
            spawn(function()
                while rangeAttackEnabled do
                  
                    for _, enemy in next, workspace.Characters:GetChildren() do
                        if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") then
                            if enemy ~= game.Players.LocalPlayer.Character and enemy.Humanoid.Health > 0 then
                               
                                local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).Magnitude
                                if distance <= 999 then 
                                    local args = {
                                        [1] = true,
                                        [2] = enemy.HumanoidRootPart.Position,  
                                        [3] = 50,                    
                                        [4] = Enum.Material.Water,   
                                        [5] = "RangeAttack"          
                                    }
                                    
                                    pcall(function()
                                        game:GetService("ReplicatedStorage").Remotes.Events.ToolState:FireServer(unpack(args))
                                    end)
                                end
                            end
                        end
                    end
                    
                    wait()
                end
            end)
        end
    end
})
end