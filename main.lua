--[[
    奶油 / Creamy UI Engine v2.0 + Autofarm Integration
    Reconstructed for absolute smoothness, reliability, and modern aesthetics.
]]

-- Universal Executor Compatibility Layer
local cRef = cloneref or function(obj) return obj end
local ts = cRef(game:GetService("TweenService"))
local ui = cRef(game:GetService("UserInputService"))

-- Safe Screen Parent Selector (Solara/Wave/Celery Friendly)
local screenParent
local hui = gethui or get_hidden_gui
local success, coregui = pcall(function() return game:GetService("CoreGui") end)
if hui then
    screenParent = hui()
elseif success and coregui then
    screenParent = coregui
else
    screenParent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
end

-- Creamy Espresso & Ivory Palette
local THEME = {
    Background = Color3.fromRGB(24, 22, 21),       -- Dark Cocoa Mocha
    Sidebar = Color3.fromRGB(32, 29, 28),          -- Warm Roasted Coffee
    Element = Color3.fromRGB(43, 39, 37),          -- Creamy Latte Base
    ElementHover = Color3.fromRGB(54, 49, 46),     -- Light Froth Highlight
    Accent = Color3.fromRGB(224, 175, 125),        -- Warm Caramel Accent
    AccentDim = Color3.fromRGB(180, 135, 95),       -- Smooth Tan Muted Accent
    Text = Color3.fromRGB(245, 240, 235),          -- Silky Milk White
    TextMuted = Color3.fromRGB(165, 155, 150),     -- Soft Creamy Gray
    Border = Color3.fromRGB(56, 51, 48)            -- Subtle Outline
}

local function quickTween(obj, props, duration, style)
    local tweenInfo = TweenInfo.new(duration or 0.25, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local t = ts:Create(obj, tweenInfo, props)
    t:Play()
    return t
end

-- Injected Variable to match your script's calls perfectly
local CalmLib = {}

function CalmLib:win(title)
    local screen = Instance.new("ScreenGui")
    screen.Name = "CreamyUI_Engine"
    screen.ResetOnSpawn = false
    screen.Parent = screenParent

    -- Main Window Frame
    local mainFrame = Instance.new("CanvasGroup")
    mainFrame.Name = "MainWindow"
    mainFrame.Size = UDim2.new(0, 480, 0, 330)
    mainFrame.Position = UDim2.new(0.5, -240, 0.5, -165)
    mainFrame.BackgroundColor3 = THEME.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screen

    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)
    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = THEME.Border
    mainStroke.Thickness = 1

    -- Topbar
    local topbar = Instance.new("Frame", mainFrame)
    topbar.Name = "Topbar"
    topbar.Size = UDim2.new(1, 0, 0, 40)
    topbar.BackgroundColor3 = THEME.Sidebar
    topbar.BorderSizePixel = 0

    local topbarBottomLine = Instance.new("Frame", topbar)
    topbarBottomLine.Size = UDim2.new(1, 0, 0, 1)
    topbarBottomLine.Position = UDim2.new(0, 0, 1, -1)
    topbarBottomLine.BackgroundColor3 = THEME.Border
    topbarBottomLine.BorderSizePixel = 0

    local windowTitle = Instance.new("TextLabel", topbar)
    windowTitle.Size = UDim2.new(1, -100, 1, 0)
    windowTitle.Position = UDim2.new(0, 15, 0, 0)
    windowTitle.BackgroundTransparency = 1
    windowTitle.Text = title -- Normal layout casing
    windowTitle.TextColor3 = THEME.Text
    windowTitle.Font = Enum.Font.GothamBold
    windowTitle.TextSize = 13
    windowTitle.TextXAlignment = Enum.TextXAlignment.Left

    -- Window Controls
    local btns = Instance.new("Frame", topbar)
    btns.Size = UDim2.new(0, 70, 1, 0)
    btns.Position = UDim2.new(1, -75, 0, 0)
    btns.BackgroundTransparency = 1

    local function createTopBtn(text, posX, color)
        local b = Instance.new("TextButton", btns)
        b.Size = UDim2.new(0, 24, 0, 24)
        b.Position = UDim2.new(0, posX, 0.5, -12)
        b.BackgroundColor3 = THEME.Element
        b.Text = text
        b.TextColor3 = color
        b.Font = Enum.Font.GothamBold
        b.TextSize = 12
        b.AutoButtonColor = false
        Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
        local s = Instance.new("UIStroke", b)
        s.Color = THEME.Border
        s.Thickness = 1

        b.MouseEnter:Connect(function()
            quickTween(b, {BackgroundColor3 = THEME.ElementHover})
            quickTween(s, {Color = THEME.Accent})
        end)
        b.MouseLeave:Connect(function()
            quickTween(b, {BackgroundColor3 = THEME.Element})
            quickTween(s, {Color = THEME.Border})
        end)
        return b
    end

    local miniBtn = createTopBtn("-", 10, THEME.TextMuted)
    local closeBtn = createTopBtn("×", 40, Color3.fromRGB(230, 100, 100))

    -- Navigation Container
    local tabsContainer = Instance.new("ScrollingFrame", mainFrame)
    tabsContainer.Size = UDim2.new(0, 140, 1, -40)
    tabsContainer.Position = UDim2.new(0, 0, 0, 40)
    tabsContainer.BackgroundColor3 = THEME.Sidebar
    tabsContainer.BorderSizePixel = 0
    tabsContainer.ScrollBarThickness = 0
    tabsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    
    local tabsLayout = Instance.new("UIListLayout", tabsContainer)
    tabsLayout.Padding = UDim.new(0, 4)
    tabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local tabsPadding = Instance.new("UIPadding", tabsContainer)
    tabsPadding.PaddingTop = UDim.new(0, 10)

    local sidebarDivider = Instance.new("Frame", mainFrame)
    sidebarDivider.Size = UDim2.new(0, 1, 1, -40)
    sidebarDivider.Position = UDim2.new(0, 140, 0, 40)
    sidebarDivider.BackgroundColor3 = THEME.Border
    sidebarDivider.BorderSizePixel = 0

    -- Section Holder
    local sectionsholder = Instance.new("Frame", mainFrame)
    sectionsholder.Size = UDim2.new(1, -155, 1, -55)
    sectionsholder.Position = UDim2.new(0, 148, 0, 48)
    sectionsholder.BackgroundTransparency = 1

    -- Smooth Dragging Mechanism
    local dragging, dragInput, mousePos, framePos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = mainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    ui.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            mainFrame.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)

    -- Window Interactions
    local toggleCon = nil
    local isOpen = true

    local function togglewin(isIn)
        isOpen = isIn
        mainFrame.Interactable = isOpen
        quickTween(mainFrame, {GroupTransparency = isOpen and 0 or 1}, 0.3)
        quickTween(mainFrame, {Size = isOpen and UDim2.new(0, 480, 0, 330) or UDim2.new(0, 480, 0, 310)}, 0.3)
    end

    closeBtn.MouseButton1Click:Connect(function()
        screen:Destroy()
        if toggleCon then toggleCon:Disconnect() end
    end)

    miniBtn.MouseButton1Click:Connect(function()
        togglewin(false)
    end)

    toggleCon = ui.InputBegan:Connect(function(keyc, gamep)
        if not gamep and keyc.KeyCode == Enum.KeyCode.K then
            togglewin(not isOpen)
        end
    end)

    -- Element Engine
    local sections = {}
    local curSelected = nil
    local firstTab = true

    function sections:tab(title, ico)
        local newBtn = Instance.new("TextButton", tabsContainer)
        newBtn.Size = UDim2.new(0, 120, 0, 32)
        newBtn.BackgroundColor3 = THEME.Sidebar
        newBtn.Text = "  " .. title
        newBtn.TextColor3 = THEME.TextMuted
        newBtn.Font = Enum.Font.GothamMedium
        newBtn.TextSize = 12
        newBtn.TextXAlignment = Enum.TextXAlignment.Left
        newBtn.AutoButtonColor = false
        
        Instance.new("UICorner", newBtn).CornerRadius = UDim.new(0, 6)
        local btnStroke = Instance.new("UIStroke", newBtn)
        btnStroke.Color = Color3.new(0,0,0)
        btnStroke.Transparency = 1

        if ico and ico ~= "" then
            newBtn.Text = "        " .. title
            local iconImg = Instance.new("ImageLabel", newBtn)
            iconImg.Size = UDim2.new(0, 16, 0, 16)
            iconImg.Position = UDim2.new(0, 8, 0.5, -8)
            iconImg.BackgroundTransparency = 1
            iconImg.Image = ico
            iconImg.ImageColor3 = THEME.TextMuted
        end

        local newSect = Instance.new("ScrollingFrame", sectionsholder)
        newSect.Size = UDim2.new(1, 0, 1, 0)
        newSect.BackgroundTransparency = 1
        newSect.Visible = false
        newSect.ScrollBarThickness = 2
        newSect.ScrollBarImageColor3 = THEME.Border
        newSect.CanvasSize = UDim2.new(0, 0, 0, 0)
        newSect.AutomaticCanvasSize = Enum.AutomaticCanvasSize.Y

        local listLayout = Instance.new("UIListLayout", newSect)
        listLayout.Padding = UDim.new(0, 6)
        
        local sectPadding = Instance.new("UIPadding", newSect)
        sectPadding.PaddingRight = UDim.new(0, 6)
        sectPadding.PaddingLeft = UDim.new(0, 2)

        local function selectTab(active)
            if active then
                quickTween(newBtn, {BackgroundColor3 = THEME.Element, TextColor3 = THEME.Accent})
                quickTween(btnStroke, {Transparency = 0, Color = THEME.Border})
                if newBtn:FindFirstChild("ImageLabel") then
                    quickTween(newBtn.ImageLabel, {ImageColor3 = THEME.Accent})
                end
                newSect.Visible = true
            else
                quickTween(newBtn, {BackgroundColor3 = THEME.Sidebar, TextColor3 = THEME.TextMuted})
                quickTween(btnStroke, {Transparency = 1})
                if newBtn:FindFirstChild("ImageLabel") then
                    quickTween(newBtn.ImageLabel, {ImageColor3 = THEME.TextMuted})
                end
                newSect.Visible = false
            end
        end

        newBtn.MouseEnter:Connect(function()
            if curSelected ~= newSect then quickTween(newBtn, {TextColor3 = THEME.Text}) end
        end)
        
        newBtn.MouseLeave:Connect(function()
            if curSelected ~= newSect then quickTween(newBtn, {TextColor3 = THEME.TextMuted}) end
        end)

        newBtn.MouseButton1Click:Connect(function()
            if curSelected == newSect then return end
            if curSelected ~= nil then
                for _, b in pairs(tabsContainer:GetChildren()) do
                    if b:IsA("TextButton") and b.Name == curSelected.Name then
                        quickTween(b, {BackgroundColor3 = THEME.Sidebar, TextColor3 = THEME.TextMuted})
                        quickTween(b:FindFirstChild("UIStroke"), {Transparency = 1})
                        if b:FindFirstChild("ImageLabel") then quickTween(b.ImageLabel, {ImageColor3 = THEME.TextMuted}) end
                    end
                end
                curSelected.Visible = false
            end

            curSelected = newSect
            newSect.Name = title
            selectTab(true)
        end)

        if firstTab then
            firstTab = false
            curSelected = newSect
            newSect.Name = title
            selectTab(true)
        end

        local contents = {}

        local function createBaseElement(sizeY)
            local base = Instance.new("Frame", newSect)
            base.Size = UDim2.new(1, 0, 0, sizeY)
            base.BackgroundColor3 = THEME.Sidebar
            Instance.new("UICorner", base).CornerRadius = UDim.new(0, 6)
            local s = Instance.new("UIStroke", base)
            s.Color = THEME.Border
            s.Thickness = 1
            return base, s
        end

        function contents:label(lblTitle)
            local base = Instance.new("Frame", newSect)
            base.Size = UDim2.new(1, 0, 0, 24)
            base.BackgroundTransparency = 1

            local l = Instance.new("TextLabel", base)
            l.Size = UDim2.new(1, 0, 1, 0)
            l.BackgroundTransparency = 1
            l.Text = lblTitle
            l.TextColor3 = THEME.Accent
            l.Font = Enum.Font.GothamBold
            l.TextSize = 11
            l.TextXAlignment = Enum.TextXAlignment.Left
        end

        function contents:button(btnTitle, cb)
            local base, stroke = createBaseElement(36)
            local b = Instance.new("TextButton", base)
            b.Size = UDim2.new(1, 0, 1, 0)
            b.BackgroundTransparency = 1
            b.Text = "   " .. btnTitle
            b.TextColor3 = THEME.Text
            b.Font = Enum.Font.GothamMedium
            b.TextSize = 12
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.AutoButtonColor = false

            b.MouseEnter:Connect(function()
                quickTween(base, {BackgroundColor3 = THEME.Element})
                quickTween(stroke, {Color = THEME.AccentDim})
            end)
            b.MouseLeave:Connect(function()
                quickTween(base, {BackgroundColor3 = THEME.Sidebar})
                quickTween(stroke, {Color = THEME.Border})
            end)
            b.MouseButton1Click:Connect(cb)
        end

        function contents:toggle(togTitle, default, cb)
            local toggled = default
            local base, stroke = createBaseElement(38)

            local titleLabel = Instance.new("TextLabel", base)
            titleLabel.Size = UDim2.new(1, -60, 1, 0)
            titleLabel.Position = UDim2.new(0, 12, 0, 0)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Text = togTitle
            titleLabel.TextColor3 = THEME.Text
            titleLabel.Font = Enum.Font.GothamMedium
            titleLabel.TextSize = 12
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left

            local switchBg = Instance.new("Frame", base)
            switchBg.Size = UDim2.new(0, 34, 0, 18)
            switchBg.Position = UDim2.new(1, -44, 0.5, -9)
            switchBg.BackgroundColor3 = toggled and THEME.Accent or THEME.Element
            Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)
            
            local switchStroke = Instance.new("UIStroke", switchBg)
            switchStroke.Color = THEME.Border
            switchStroke.Thickness = 1

            local knob = Instance.new("Frame", switchBg)
            knob.Size = UDim2.new(0, 12, 0, 12)
            knob.Position = toggled and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
            knob.BackgroundColor3 = toggled and THEME.Background or THEME.TextMuted
            Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

            local triggerBtn = Instance.new("TextButton", base)
            triggerBtn.Size = UDim2.new(1, 0, 1, 0)
            triggerBtn.BackgroundTransparency = 1
            triggerBtn.Text = ""

            local function updateToggleVisuals()
                quickTween(switchBg, {BackgroundColor3 = toggled and THEME.Accent or THEME.Element})
                quickTween(knob, {
                    Position = toggled and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
                    BackgroundColor3 = toggled and THEME.Background or THEME.TextMuted
                })
            end

            if toggled then task.defer(cb, toggled) end

            triggerBtn.MouseEnter:Connect(function() quickTween(stroke, {Color = THEME.AccentDim}) end)
            triggerBtn.MouseLeave:Connect(function() quickTween(stroke, {Color = THEME.Border}) end)
            triggerBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateToggleVisuals()
                cb(toggled)
            end)
        end

        return contents
    end
    return sections
end

-- =========================================================================
-- YOUR AUTOFARM EXECUTION PIPELINE
-- =========================================================================

local window = CalmLib:win("sub 2 vaehz")
local section1 = window:tab("Autofarm", "rbxassetid://109121102062195")
local section2 = window:tab("Settings", "rbxassetid://99579688577014")

local plr = game:GetService("Players").LocalPlayer

getgenv().farming = false
getgenv().farmsettings = {
    purchase = true,
    upgrade = true,
    collect = true,
    cashdrop = true,
    fruit = true
}

local tycoon
for _, v in pairs(workspace:GetChildren()) do
    if v.Name:find("Tycoon") and v:FindFirstChild("Owner").Value == plr then
        tycoon = v
    end
end

local suffixes = {
    K   = 1e3,
    M   = 1e6,
    B   = 1e9,
    T   = 1e12,
    Qd  = 1e15,
    Qn  = 1e18,
    Sx  = 1e21,
    Sxd = 1e21,
    Sp  = 1e24,
    Oc  = 1e27,
    No  = 1e30,
    Dc  = 1e33,
}

function decodeValue(str)
    local clean = str:gsub("[\226\128\128-\226\128\143]", "")

    local numStr, suffix = clean:match("%$([%d%,%.]+)(%a*)")
    if not numStr then
        return nil
    end

    local num = tonumber((numStr:gsub(",", "")))
    if not num then
        return nil
    end

    if suffix == "" then
        return num
    end

    local multiplier = suffixes[suffix]

    if not multiplier then
        suffix = suffix:sub(1,1):upper() .. suffix:sub(2):lower()
        multiplier = suffixes[suffix]
    end

    if multiplier then
        return num * multiplier
    end

    return num
end

local PurchasesFold = tycoon.Purchases

tycoon.Remotes.PhoneOffer.OnClientEvent:Connect(function()
    if not getgenv().farming then return end
    local Event = tycoon.Remotes.PhoneOffer
    Event:FireServer(
        "Accept"
    )
end)

section1:toggle("Autofarm", false, function(bool)
    local stands = tycoon.Values.Income.Streams
    getgenv().farming = bool
    if not getgenv().farming then return end
    task.spawn(function()
        while getgenv().farming do
            if not getgenv().farmsettings.collect then task.wait(1) continue end
            -- Step 1. Collect money
            for i, v in pairs(stands:GetChildren()) do
                local Event = tycoon.Remotes.WakeIncomeStream
                Event:InvokeServer(
                    v.Name
                )
            end
            task.wait()
        end
    end)

    while getgenv().farming do
        -- Step 2. Buy cool stuff
        pcall(function()
            if not getgenv().farmsettings.purchase then return end
            for _, fold in pairs(PurchasesFold:GetChildren()) do
                if fold:FindFirstChild("Buttons") then
                    for i, nFold in pairs(fold.Buttons:GetChildren()) do
                        if nFold:IsA("Folder") then
                            for _,btn in pairs(nFold:GetChildren()) do
                                if btn:GetAttribute("Shown") and btn:GetAttribute("Enabled") and not btn:GetAttribute("Purchased") then
                                    local price = decodeValue(btn.Button.Gui.Price.Text)
                                    local curbalance = decodeValue(plr.leaderstats.Cash.Value)

                                    if price <= curbalance then
                                        firetouchinterest(plr.Character.Head, btn.Button, true)
                                        task.wait()
                                        firetouchinterest(plr.Character.Head, btn.Button, false)
                                    end
                                end
                            end
                        elseif nFold:IsA("Model") then
                            if nFold:GetAttribute("Shown") and nFold:GetAttribute("Enabled") and not nFold:GetAttribute("Purchased") then
                                local price = decodeValue(nFold.Button.Gui.Price.Text)
                                local curbalance = decodeValue(plr.leaderstats.Cash.Value)

                                if price <= curbalance then
                                    firetouchinterest(plr.Character.Head, nFold.Button, true)
                                    task.wait()
                                    firetouchinterest(plr.Character.Head, nFold.Button, false)
                                end
                            end
                        end
                    end
                end
            end
        end)

        -- Step 3. Upgrade everything
        pcall(function()
            if not getgenv().farmsettings.upgrade then return end
            for _, fold in pairs(PurchasesFold:GetChildren()) do
                if fold:FindFirstChild(fold.Name) then
                    if not fold:FindFirstChild(fold.Name):GetAttribute("Enabled") then
                        continue
                    end
                    fold:FindFirstChild(fold.Name):FindFirstChild(fold.Name).Upgrade:InvokeServer(1)
                end
            end
        end)

        -- Step 4. Cash drops
        pcall(function()
            if not getgenv().farmsettings.cashdrop then return end
            for i, v in pairs(workspace.CashDrops:GetChildren()) do
                firetouchinterest(plr.Character.Head, v, true)
                task.wait()
                firetouchinterest(plr.Character.Head, v, false)
            end
        end)

        -- Step 5. Collect fruit
        pcall(function()
            if not getgenv().farmsettings.fruit then return end
            for i, v in pairs(tycoon.Constant.Trees:GetChildren()) do
                for _, lemon in pairs(v:GetChildren()) do
                    if not lemon.Name == "Fruit" then continue end
                    if not lemon:FindFirstChild("ClickPart") then continue end
                    fireclickdetector(lemon.ClickPart.ClickDetector)
                    task.wait()
                end
            end
        end)

        task.wait(1)
    end
end)

section1:label("Settings:")

section1:toggle("Auto Purchase", true, function(v)
    getgenv().farmsettings.purchase = v
end)
section1:toggle("Auto Collect", true, function(v)
    getgenv().farmsettings.collect = v
end)
section1:toggle("Auto Upgrade", true, function(v)
    getgenv().farmsettings.upgrade = v
end)
section1:toggle("Auto Cash Drop", true, function(v)
    getgenv().farmsettings.cashdrop = v
end)
section1:toggle("Auto Pickup Fruit", true, function(v)
    getgenv().farmsettings.fruit = v
end)

getgenv().antiafk = true

plr.Idled:Connect(function()
    if not getgenv().antiafk then return end
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- Settings
section2:toggle("Disable 3D Rendering", false, function(v)
    game:GetService("RunService"):Set3dRenderingEnabled(not v)
end)

section2:toggle("Anti AFK", true, function(v)
    getgenv().antiafk = v
end)
