--[[
    奶油 / Creamy UI Engine v2.0
    Reconstructed for absolute smoothness, reliability, and modern aesthetics.
    完全独立 - Drop-in replacement with maximum visual polish.
]]

local module = {}
local ts = cloneref(game:GetService("TweenService"))
local cg = cloneref(game:GetService("CoreGui"))
local ui = cloneref(game:GetService("UserInputService"))

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

function module:win(title)
    local screen = Instance.new("ScreenGui")
    screen.Name = "CreamyUI_Engine"
    screen.ResetOnSpawn = false
    
    local hui = gethui or get_hidden_gui or nil
    screen.Parent = hui and hui() or cg

    -- Main Window Window Frame
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
    windowTitle.Text = title:upper()
    windowTitle.TextColor3 = THEME.Text
    windowTitle.Font = Enum.Font.GothamBold
    windowTitle.TextSize = 13
    windowTitle.TextXAlignment = Enum.TextXAlignment.Left

    -- Window Controls Window Button Frame
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

    -- Section Holder Canvas Window
    local sectionsholder = Instance.new("Frame", mainFrame)
    sectionsholder.Size = UDim2.new(1, -155, 1, -55)
    sectionsholder.Position = UDim2.new(0, 148, 0, 48)
    sectionsholder.BackgroundTransparency = 1

    -- Core Interaction Logic
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

    -- Draggable Feature Smooth Engine
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

    -- Tabs and Elements Logic Loop Frame Factory
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

        -- Smooth handling for Optional Icons
        if ico and ico ~= "" then
            newBtn.Text = "       " .. title
            local iconImg = Instance.new("ImageLabel", newBtn)
            iconImg.Size = UDim2.new(0, 16, 0, 16)
            iconImg.Position = UDim2.new(0, 8, 0.5, -8)
            iconImg.BackgroundTransparency = 1
            iconImg.Image = ico
            iconImg.ImageColor3 = THEME.TextMuted
        end

        -- Main Content Scrolling Elements Frame Canvas Template
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
            if curSelected ~= newSect then
                quickTween(newBtn, {TextColor3 = THEME.Text})
            end
        end)
        
        newBtn.MouseLeave:Connect(function()
            if curSelected ~= newSect then
                quickTween(newBtn, {TextColor3 = THEME.TextMuted})
            end
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

        -- Element Generator Helper Base Layout Module
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

            -- Smooth Capsule Custom Switch Setup
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

            if toggled then
                task.defer(cb, toggled)
            end

            triggerBtn.MouseEnter:Connect(function()
                quickTween(stroke, {Color = THEME.AccentDim})
            end)
            triggerBtn.MouseLeave:Connect(function()
                quickTween(stroke, {Color = THEME.Border})
            end)

            triggerBtn.MouseButton1Click:Connect(function()
                toggled = not toggled
                updateToggleVisuals()
                cb(toggled)
            end)
        end

        function contents:textbox(boxTitle, default, cb)
            local base, stroke = createBaseElement(38)

            local titleLabel = Instance.new("TextLabel", base)
            titleLabel.Size = UDim2.new(0.5, 0, 1, 0)
            titleLabel.Position = UDim2.new(0, 12, 0, 0)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Text = boxTitle
            titleLabel.TextColor3 = THEME.Text
            titleLabel.Font = Enum.Font.GothamMedium
            titleLabel.TextSize = 12
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left

            local boxFrame = Instance.new("Frame", base)
            boxFrame.Size = UDim2.new(0.4, 0, 0, 24)
            boxFrame.Position = UDim2.new(0.6, -12, 0.5, -12)
            boxFrame.BackgroundColor3 = THEME.Element
            Instance.new("UICorner", boxFrame).CornerRadius = UDim.new(0, 4)
            local bfStroke = Instance.new("UIStroke", boxFrame)
            bfStroke.Color = THEME.Border

            local inp = Instance.new("TextBox", boxFrame)
            inp.Size = UDim2.new(1, -10, 1, 0)
            inp.Position = UDim2.new(0, 5, 0, 0)
            inp.BackgroundTransparency = 1
            inp.Text = default
            inp.TextColor3 = THEME.Text
            inp.Font = Enum.Font.Gotham
            inp.TextSize = 11
            inp.ClipsDescendants = true

            if default ~= "" then
                task.defer(cb, default)
            end

            inp.Focused:Connect(function()
                quickTween(bfStroke, {Color = THEME.Accent})
            end)

            inp.FocusLost:Connect(function(ep)
                quickTween(bfStroke, {Color = THEME.Border})
                if ep then
                    cb(inp.Text)
                end
            end)
        end

        function contents:slider(slTitle, min, max, default, cb)
            local base, stroke = createBaseElement(44)

            local titleLabel = Instance.new("TextLabel", base)
            titleLabel.Size = UDim2.new(1, -20, 0, 20)
            titleLabel.Position = UDim2.new(0, 12, 0, 4)
            titleLabel.BackgroundTransparency = 1
            titleLabel.Text = slTitle .. " : " .. tostring(default)
            titleLabel.TextColor3 = THEME.Text
            titleLabel.Font = Enum.Font.GothamMedium
            titleLabel.TextSize = 11
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left

            local slbtn = Instance.new("TextButton", base)
            slbtn.Size = UDim2.new(1, -24, 0, 6)
            slbtn.Position = UDim2.new(0, 12, 0, 28)
            slbtn.BackgroundColor3 = THEME.Element
            slbtn.Text = ""
            slbtn.AutoButtonColor = false
            Instance.new("UICorner", slbtn).CornerRadius = UDim.new(1, 0)

            local prog = Instance.new("Frame", slbtn)
            prog.Size = UDim2.new(0, 0, 1, 0)
            prog.BackgroundColor3 = THEME.Accent
            Instance.new("UICorner", prog).CornerRadius = UDim.new(1, 0)

            local lastval = default
            local draggingSlider = false

            local function setFromAlpha(alpha)
                alpha = math.clamp(alpha, 0, 1)
                local value = math.floor(min + (max - min) * alpha + 0.5)
                quickTween(prog, {Size = UDim2.new(alpha, 0, 1, 0)}, 0.1)
                lastval = value
                titleLabel.Text = slTitle .. " : " .. tostring(lastval)
            end

            local function updateFromInput(x)
                local rel = (x - slbtn.AbsolutePosition.X) / slbtn.AbsoluteSize.X
                setFromAlpha(rel)
            end

            setFromAlpha((default - min) / (max - min))

            slbtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    draggingSlider = true
                    updateFromInput(input.Position.X)
                    quickTween(stroke, {Color = THEME.AccentDim})
                end
            end)

            ui.InputChanged:Connect(function(input)
                if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    updateFromInput(input.Position.X)
                end
            end)

            ui.InputEnded:Connect(function(input)
                if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                    draggingSlider = false
                    quickTween(stroke, {Color = THEME.Border})
                    if cb then
                        pcall(cb, lastval)
                    end
                end
            end)
        end

        return contents
    end

    return sections
end

return module
