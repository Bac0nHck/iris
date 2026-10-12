-- Set the raw-text URL to run this example independently.
-- For MCP/local use, load Iris.luau first and leave the placeholder unchanged.
local IRIS_URL = "https://raw.githubusercontent.com/Bac0nHck/iris/refs/heads/main/Iris.luau"
local env = if type(getgenv) == "function" then getgenv() else _G
if env.__IRIS_TABS_EXAMPLE then env.__IRIS_TABS_EXAMPLE.Stop() end
local Iris = if IRIS_URL ~= "YOUR_RAW_IRIS_URL"
    then loadstring(game:HttpGet(IRIS_URL))()
    else env.__IRIS_STANDALONE
assert(Iris and not Iris.Internal._shutdown, "Load Iris.luau first or set IRIS_URL")
Iris.ForceRefresh()

local demo = {Iris = Iris, Widgets = {}, Stopped = false}
env.__IRIS_TABS_EXAMPLE = demo
local selectedTab = Iris.State(1)
local windowSize = Iris.State(Vector2.new(640, 590))
local windowPosition = Iris.State(Vector2.new(110, 95))
local clicks = Iris.State(0)
local enabled = Iris.State(true)
local username = Iris.State("Player")
local theme = Iris.State("Dark")
local volume = Iris.State(65)
local progress = Iris.State(0.65)
local liveGraphs = Iris.State(true)
local graphValues = Iris.State({50, 60, 72, 83, 90, 82, 67, 49, 32, 18, 10, 20, 35, 50})
local barValues = Iris.State({14, 29, 40, 21, 65, 83, 51, 38, 72, 95, 62, 44})
local imageUrl = Iris.State("https://i.pinimg.com/736x/cc/90/b6/cc90b6d6da48076543366ed82dc94332.jpg")
local autoRotate = Iris.State(true)
local rotationSpeed = Iris.State(25)
local cameraRotation = Iris.State(Vector2.new(30, -15))
local cameraDistance = Iris.State(0)
local objectColor = Iris.State(Color3.fromRGB(80, 160, 255))
local modelRevision = Iris.State(0)
demo.State = {tab = selectedTab, clicks = clicks, enabled = enabled, theme = theme, volume = volume, liveGraphs = liveGraphs, graphValues = graphValues, imageUrl = imageUrl, rotation = cameraRotation, distance = cameraDistance}

local model = Instance.new("Model")
model.Name = "IrisTabsPreview"
demo.Model = model
local cube = Instance.new("Part")
cube.Name = "Cube"
cube.Size = Vector3.new(4, 4, 4)
cube.Anchored = true
cube.Color = objectColor:get()
cube.Material = Enum.Material.SmoothPlastic
cube.Parent = model
local sphere = Instance.new("Part")
sphere.Name = "Sphere"
sphere.Shape = Enum.PartType.Ball
sphere.Size = Vector3.new(2.4, 2.4, 2.4)
sphere.Position = Vector3.new(0, 3.1, 0)
sphere.Anchored = true
sphere.Color = Color3.fromRGB(255, 180, 70)
sphere.Material = Enum.Material.SmoothPlastic
sphere.Parent = model

local subscriptions = {}
table.insert(subscriptions, theme:onChange(function(value)
    local config = if value == "Light" then Iris.TemplateConfig.colorLight else Iris.TemplateConfig.colorDark
    Iris.UpdateGlobalConfig(config)
end))
table.insert(subscriptions, volume:onChange(function(value) progress:set(value / 100) end))
table.insert(subscriptions, objectColor:onChange(function(value)
    cube.Color = value
    modelRevision:set(modelRevision:get() + 1)
end))

local renderDisconnect
function demo.Stop()
    if demo.Stopped then return end
    demo.Stopped = true
    if renderDisconnect then renderDisconnect() end
    for _, disconnect in subscriptions do disconnect() end
    model:Destroy()
    if env.__IRIS_TABS_EXAMPLE == demo then env.__IRIS_TABS_EXAMPLE = nil end
end
local lastSampleTime = os.clock()
local function startTab(id, title)
    Iris.SetNextWidgetID("tabs_example_" .. id)
    local tab = Iris.Tab({title})
    tab.Instance.Name = "Tab_" .. id
    demo.Widgets[id] = tab
    return tab.active()
end

renderDisconnect = Iris:Connect(function()
    if demo.Stopped then return end
    local now = os.clock()
    if liveGraphs:get() and now - lastSampleTime >= 0.15 then
        lastSampleTime = now
        local values = table.clone(graphValues:get())
        if #values >= 60 then table.remove(values, 1) end
        table.insert(values, 50 + math.sin(now * 1.8) * 35 + math.sin(now * 4.2) * 8)
        graphValues:set(values)
    end

    Iris.SetNextWidgetID("tabs_example_window")
    demo.Widgets.window = Iris.Window({"Iris • Tabbed Example"}, {size = windowSize, position = windowPosition})
        Iris.Text({"Home / Settings / Graphs / Images / 3D"})
        Iris.SetNextWidgetID("tabs_example_bar")
        demo.Widgets.tabbar = Iris.TabBar({}, {index = selectedTab})

            if startTab("home", "Home") then
                Iris.SeparatorText({"Welcome"})
                Iris.TextWrapped({"This interactive Iris example includes settings, live graphs, an external image, and a 3D preview. Switch tabs to try each feature."})
                Iris.SetNextWidgetID("tabs_example_click")
                demo.Widgets.click = Iris.Button({"Click me"})
                if demo.Widgets.click.clicked() then clicks:set(clicks:get() + 1) end
                Iris.Text({"Clicks: " .. clicks:get()})
                if Iris.Button({"Reset counter"}).clicked() then clicks:set(0) end
                Iris.Checkbox({"Demo enabled"}, {isChecked = enabled})
                Iris.Text({"UI parent: " .. Iris.Standalone.ParentMode})
                Iris.SeparatorText({"Controls"})
                Iris.TextWrapped({if Iris.Mobile.Enabled then "Drag the title to move the window. Swipe the tab strip to scroll it. Drag with one finger to rotate the 3D model, or pinch with two fingers to zoom." else "Drag the title or empty background to move the window. Inside the 3D preview, drag to rotate the model and use the wheel to zoom."})
                if Iris.Button({"Close example"}).clicked() then
                    task.defer(function() demo.Stop(); Iris.Shutdown() end)
                end
            end
            Iris.End()

            if startTab("settings", "Settings") then
                Iris.SeparatorText({"Preferences"})
                Iris.InputText({"Name", "Enter your name"}, {text = username})
                Iris.SetNextWidgetID("tabs_example_theme")
                demo.Widgets.theme = Iris.ComboArray({"Theme"}, {index = theme}, {"Dark", "Light"})
                Iris.Checkbox({"Demo enabled"}, {isChecked = enabled})
                Iris.SliderNum({"Level", 1, 0, 100, "%d%%"}, {number = volume})
                Iris.ProgressBar({"Progress"}, {progress = progress})
                Iris.Text({"Hello, " .. username:get() .. "!"})
                Iris.TextWrapped({"These settings update the interface and sample data."})
            end
            Iris.End()

            if startTab("graphs", "Graphs") then
                Iris.SeparatorText({"Live data"})
                Iris.Checkbox({"Update graph"}, {isChecked = liveGraphs})
                Iris.SetNextWidgetID("tabs_example_lines")
                demo.Widgets.lines = Iris.PlotLines({"Signal", 160, 0, 100, "Sample signal"}, {values = graphValues})
                Iris.SetNextWidgetID("tabs_example_bars")
                demo.Widgets.bars = Iris.PlotHistogram({"Bars", 150, 0, 100}, {values = barValues})
                if Iris.Button({"Randomize bars"}).clicked() then
                    local values = {}
                    for i = 1, 12 do values[i] = math.random(5, 95) end
                    barValues:set(values)
                end
                Iris.TextWrapped({if Iris.Mobile.Enabled then "Touch the graph to inspect its values." else "Hover over the graph to inspect its values."})
            end
            Iris.End()

            if startTab("images", "Images") then
                Iris.SeparatorText({"Image from an HTTPS URL"})
                Iris.InputText({"Image URL", "Direct PNG or JPEG URL"}, {text = imageUrl})
                Iris.SetNextWidgetID("tabs_example_image")
                demo.Widgets.image = Iris.Image({imageUrl:get(), UDim2.fromOffset(480, 300), [Iris.Args.Image.ScaleType] = Enum.ScaleType.Fit})
                local status, err = Iris.GetImageStatus(imageUrl:get())
                local readable = {not_requested = "Not requested", loading = "Loading…", ready = "Ready", error = "Load failed"}
                Iris.Text({"Status: " .. (readable[status] or status)})
                if status == "error" then Iris.TextWrapped({tostring(err)}) end
                if Iris.Button({"Retry download"}).clicked() and string.match(imageUrl:get(), "^https?://") then Iris.RetryImage(imageUrl:get()) end
                Iris.TextWrapped({"Paste another direct PNG or JPEG URL to load it. Images download in the background and are cached on disk."})
            end
            Iris.End()

            if startTab("viewport", "3D") then
                Iris.SeparatorText({"Interactive model"})
                Iris.Checkbox({"Auto rotate"}, {isChecked = autoRotate})
                Iris.SliderNum({"Speed", 1, 0, 90, "%d°/s"}, {number = rotationSpeed})
                Iris.InputColor3({"Cube color"}, {color = objectColor})
                Iris.SetNextWidgetID("tabs_example_viewport_frame")
                demo.Widgets.viewportFrame = Iris.Viewport({
                    model,
                    UDim2.new(1, 0, 0, 300),
                    if autoRotate:get() then rotationSpeed:get() else false,
                    [Iris.Args.Viewport.Revision] = modelRevision:get(),
                }, {rotation = cameraRotation, distance = cameraDistance})
                if Iris.Button({"Reset camera"}).clicked() then
                    cameraRotation:set(Vector2.new(30, -15))
                    cameraDistance:set(0)
                end
                Iris.TextWrapped({if Iris.Mobile.Enabled then "Drag with one finger to rotate. Pinch with two fingers to zoom, or use the − and + buttons." else "Drag with the left mouse button to rotate the model. Use the wheel to zoom."})
            end
            Iris.End()

        Iris.End()
    Iris.End()
end)
