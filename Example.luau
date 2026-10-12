-- Host Iris.luau at a raw-text URL, then replace this URL.
local Iris = loadstring(game:HttpGet("https://raw.githubusercontent.com/Bac0nHck/iris/refs/heads/main/Iris.luau"))()

-- Create state and resources once, outside the per-frame callback.
local enabled = Iris.State(false)
local choice = Iris.State("First")
local samples = Iris.State({2, 5, 3, 8, 6, 9, 4})
local clicks = Iris.State(0)
local spin = Iris.State(true)
local rotation = Iris.State(Vector2.new(30, -15))
local distance = Iris.State(0)
local windowSize = Iris.State(Vector2.new(540, 740))

-- Any Model or BasePart can be previewed. The widget clones it.
local model = Instance.new("Model")
model.Name = "PreviewModel"
local cube = Instance.new("Part")
cube.Name = "Cube"
cube.Size = Vector3.new(4, 4, 4)
cube.Color = Color3.fromRGB(80, 160, 255)
cube.Material = Enum.Material.SmoothPlastic
cube.Anchored = true
cube.Parent = model
local cap = Instance.new("Part")
cap.Name = "Cap"
cap.Shape = Enum.PartType.Ball
cap.Size = Vector3.new(2, 2, 2)
cap.Position = Vector3.new(0, 3, 0)
cap.Color = Color3.fromRGB(255, 180, 70)
cap.Anchored = true
cap.Parent = model

local disconnect
disconnect = Iris:Connect(function()
    Iris.Window({"Iris Standalone Example"}, {size = windowSize})
        Iris.Text({"Button, toggle, dropdown, graphs, image and 3D"})
        if Iris.Button({"Click me"}).clicked() then
            clicks:set(clicks:get() + 1)
        end
        Iris.Text({"Clicks: " .. clicks:get()})
        Iris.Toggle({"Enabled"}, {isChecked = enabled})
        Iris.Dropdown({"Choose"}, {index = choice}, {"First", "Second", "Third"})
        Iris.Text({"Selected: " .. choice:get()})
        Iris.InputText({"Enter text"})
        Iris.SeparatorText({"Graphs"})
        Iris.PlotLines({"Line", 90}, {values = samples})
        Iris.PlotHistogram({"Bars", 90}, {values = samples})
        if Iris.Button({"New data"}).clicked() then
            local nextSamples = {}
            for i = 1, 12 do nextSamples[i] = math.random(-5, 10) end
            samples:set(nextSamples)
        end
        Iris.SeparatorText({"Image"})
        Iris.Image({"rbxasset://textures/face.png", UDim2.fromOffset(64, 64)})
        Iris.SeparatorText({"3D preview"})
        Iris.Checkbox({"Auto rotate"}, {isChecked = spin})
        Iris.Viewport({model, UDim2.new(1, 0, 0, 200), spin:get()}, {rotation = rotation, distance = distance})
        if Iris.Button({"Reset camera"}).clicked() then
            rotation:set(Vector2.new(30, -15))
            distance:set(0)
        end
        if Iris.Button({"Close UI"}).clicked() then
            -- Defer shutdown until the current render callback finishes.
            task.defer(function()
                disconnect()
                model:Destroy()
                Iris.Shutdown()
            end)
        end
    Iris.End()
end)
