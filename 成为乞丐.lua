local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Confirmed = false

WindUI:Popup({
    Title = "大司马脚本付费版V2",
    IconThemed = true,
    Content = "欢迎尊贵的用户" .. game.Players.LocalPlayer.Name .. "使用大司马脚本付费版",
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
        Title = "成为乞丐",
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
    
    local LanguageTab = Window:Tab({Title = "语言设置", Icon = "globe"})

local Translations = {
    -- 标签页标题
    ["功能"] = "Features",
    ["语言设置"] = "Language Settings",
    
    -- 功能设置
    ["自动乞讨"] = "Auto Beg",
    ["自动购买员工"] = "Auto Buy Employees", 
    ["自动升级"] = "Auto Upgrade",
    ["金钱光环"] = "Money Aura",
    
    -- 语言设置
    ["当前语言"] = "Current Language",
    ["中文"] = "Chinese",
    ["英文"] = "English",
    ["应用语言"] = "Apply Language",
    ["语言更改"] = "Language Change",
    ["成功"] = "Success",
    ["语言"] = "Language",
    ["当前语言已经是"] = "Current language is already",
    ["请重启脚本以使更改生效"] = "Please restart the script for changes to take effect"
}

local currentLanguage = "Chinese"
local languageChanged = false

LanguageTab:Dropdown({
    Title = "当前语言",
    Values = {"中文", "English"},
    Value = "中文",
    Callback = function(option)
        if option == "English" then
            currentLanguage = "English"
        else
            currentLanguage = "Chinese"
        end
        languageChanged = true
    end
})

LanguageTab:Button({
    Title = "应用语言",
    Callback = function()
        if languageChanged then
            WindUI:Notify({
                Title = "语言更改",
                Content = "请重启脚本以使更改生效",
                Duration = 5,
                Icon = "info"
            })
            languageChanged = false
        else
            WindUI:Notify({
                Title = "语言",
                Content = "当前语言已经是 " .. currentLanguage,
                Duration = 3,
                Icon = "info"
            })
        end
    end
})

local function translateText(text)
    if not text or type(text) ~= "string" then return text end
    
    if currentLanguage == "English" then
        return Translations[text] or text
    else
        for cn, en in pairs(Translations) do
            if text == en then
                return cn
            end
        end
        return text
    end
end

local function translateGUI(gui)
    if (gui:IsA("TextLabel") or gui:IsA("TextButton") or gui:IsA("TextBox")) then
        pcall(function()
            local text = gui.Text
            if text and text ~= "" then
                local translatedText = translateText(text)
                if translatedText ~= text then
                    gui.Text = translatedText
                end
            end
        end)
    end
end

local function scanAndTranslate()
    for _, gui in ipairs(game:GetService("CoreGui"):GetDescendants()) do
        translateGUI(gui)
    end
    local player = game:GetService("Players").LocalPlayer
    if player and player:FindFirstChild("PlayerGui") then
        for _, gui in ipairs(player.PlayerGui:GetDescendants()) do
            translateGUI(gui)
        end
    end
end

local function setupDescendantListener(parent)
    parent.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
            task.wait(0.1)
            translateGUI(descendant)
        end
    end)
end

local function setupTranslationEngine()
    pcall(setupDescendantListener, game:GetService("CoreGui"))
    local player = game:GetService("Players").LocalPlayer
    if player and player:FindFirstChild("PlayerGui") then
        pcall(setupDescendantListener, player.PlayerGui)
    end
    scanAndTranslate()
    while true do
        scanAndTranslate()
        task.wait(3)
    end
end

task.spawn(function()
    task.wait(2)
    setupTranslationEngine()
end)
    
        local FeaturesTab = Window:Tab({Title = "功能", Icon = "settings"})

_G.AutoFastMoney = false
_G.AutoBuyEmployees = false
_G.AutoBuyUpgrades = false
_G.MoneyAura = false

FeaturesTab:Toggle({
    Title = "自动乞讨",
    Icon = "check",
    Default = false,
    Callback = function(Value)
        _G.AutoFastMoney = Value
        if Value then
            local plrs = game:GetService("Players")
            local rs = game:GetService("ReplicatedStorage")
            local me = plrs.LocalPlayer
            local char = me.Character or me.CharacterAdded:Wait()
            local hrp = char:WaitForChild("HumanoidRootPart")
            local bases = workspace:WaitForChild("Bases")
            local ev = rs.Remotes:WaitForChild("MinigameEvent")
            local run = game:GetService("RunService")

            local function findBase()
                for _,b in pairs(bases:GetChildren()) do
                    local o = b:FindFirstChild("Owner")
                    if o then
                        local v = o.Value
                        if v == me or tostring(v) == me.Name or tonumber(v) == me.UserId then
                            return b
                        end
                    end
                end
            end

            local b = findBase()
            if b then
                local beg = b:WaitForChild("BegPrompt")
                local prompt = beg:WaitForChild("ProximityPrompt")
                
                hrp.CFrame = beg.CFrame + Vector3.new(0,3,0)
                fireproximityprompt(prompt)
                
                while _G.AutoFastMoney do
                    run.RenderStepped:Wait()
                    ev:FireServer(true)
                end
            end
        end
    end
})

FeaturesTab:Toggle({
    Title = "自动购买员工",
    Icon = "check",
    Default = false,
    Callback = function(Value)
        _G.AutoBuyEmployees = Value
        if Value then
            local Replicate = game:GetService("ReplicatedStorage")
            local BuyEmployee = Replicate.Remotes.BuyEmployee
            task.spawn(function()
                while _G.AutoBuyEmployees do 
                    for i = 1, 75 do 
                        if i ~= 13 and i ~= 14 then 
                            BuyEmployee:FireServer(i)
                            task.wait(0.3)
                        end 
                    end 
                end 
            end)
        end
    end
})

FeaturesTab:Toggle({
    Title = "自动升级",
    Icon = "check",
    Default = false,
    Callback = function(Value)
        _G.AutoBuyUpgrades = Value
        if Value then
            local Replicate = game:GetService("ReplicatedStorage")
            local Upgrade = Replicate.Remotes.Upgrade
            task.spawn(function()
                while _G.AutoBuyUpgrades do 
                    task.wait(0.1)
                    Upgrade:FireServer("Beg Power")
                    Upgrade:FireServer("Income")
                    Upgrade:FireServer("Box Tier")
                    Upgrade:FireServer("Alley Tier")
                end 
            end)
        end
    end
})

FeaturesTab:Toggle({
    Title = "金钱光环",
    Icon = "check",
    Default = false,
    Callback = function(Value)
        _G.MoneyAura = Value
        if Value then
            local Money = workspace:WaitForChild("Money")
            local HRP = player.Character:WaitForChild("HumanoidRootPart")
            task.spawn(function()
                while _G.MoneyAura do
                    local OldCFrame = HRP.CFrame
                    for _,v in pairs(Money:GetDescendants()) do
                        if v:IsA("ProximityPrompt") and v.Parent:IsA("BasePart") then
                            HRP.CFrame = v.Parent.CFrame + Vector3.new(0,3,0)
                            fireproximityprompt(v,0,true)
                        end
                    end
                    HRP.CFrame = OldCFrame
                    task.wait(0.5)
                end 
            end)
        end
    end
})
end