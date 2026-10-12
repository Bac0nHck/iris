# Iris Standalone

A single-file distribution of [SirMallard/Iris](https://github.com/SirMallard/Iris), an immediate-mode UI library for Roblox. This distribution includes the upstream widget API and demo, external PNG/JPEG loading, interactive 3D previews, and touch controls for phones and tablets.

**Version:** `2.5.1+standalone.4`, based on Iris `2.5.1` at commit `2bcb21dfe3682890402e6b5428feb811cd317c32`.

This is a modified distribution of Iris. It runs inside a Roblox client with an executor that provides `loadstring` and HTTP access. It uses Roblox GUI objects and services; it cannot run in a standalone Lua interpreter.

## Files

| File | Purpose |
| --- | --- |
| [Iris.luau](Iris.luau) | Complete library; the only file required at runtime |
| [Example.luau](Example.luau) | Buttons, a toggle, a dropdown, plots, an image, and a 3D model |
| [TabbedExample.luau](TabbedExample.luau) | Home, Settings, Graphs, Images, and 3D tabs |
| [API_REFERENCE.md](API_REFERENCE.md) | Widget arguments, states, events, and standalone extensions |
| [build-info.json](build-info.json) | Upstream revision, bundle version, module list, and SHA-256 |
| [LICENSE.txt](LICENSE.txt) | Upstream MIT license |

## Quick start

Upload these files to your repository. Open `Iris.luau`, select **Raw**, and copy the URL. Replace `https://raw.githubusercontent.com/Bac0nHck/iris/refs/heads/main/Iris.luau` below with that URL. A typical URL is `https://raw.githubusercontent.com/Bac0nHck/iris/refs/heads/main/Iris.luau`.

```lua
local Iris = loadstring(game:HttpGet("https://raw.githubusercontent.com/Bac0nHck/iris/refs/heads/main/Iris.luau"))()

local enabled = Iris.State(false)
local selected = Iris.State("First")

Iris:Connect(function()
    Iris.Window({"My window"})
        Iris.Text({"Hello from Iris!"})
        if Iris.Button({"Click me"}).clicked() then
            print("Button clicked")
        end
        Iris.Toggle({"Enabled"}, {isChecked = enabled})
        Iris.Dropdown({"Choose"}, {index = selected}, {"First", "Second", "Third"})
    Iris.End()
end)
```

The loader returns an initialized `Iris` table. Keep this return value in a variable to use the library below the loader. Calling `.Init()` again is allowed for compatibility with upstream examples. No Studio setup, ModuleScripts, Rojo project, or additional module downloads are required.

To run a complete sample, copy [Example.luau](Example.luau) or [TabbedExample.luau](TabbedExample.luau) and replace its URL placeholder. The tabbed example also supports an already loaded standalone instance when the placeholder is unchanged.

## Where the interface lives

The library uses the container returned by `gethui()` when the function is available and returns a supported GUI container. Otherwise, it uses `game:GetService("CoreGui")`. Your executor must permit access to the selected container.

When `gethui()` returns a `ScreenGui` or `Frame`, Iris creates frame-based windows inside it. With `CoreGui`, it creates `ScreenGui` windows with `ResetOnSpawn = false`.

```lua
print(Iris.Standalone.ParentMode) -- "gethui" or "CoreGui"
print(Iris.Internal.parentInstance) -- Selected container; internal API
```

Loading the standalone bundle again shuts down the previously loaded standalone instance before creating a new one.

## Render callbacks and state

`Iris:Connect(callback)` runs your callback each UI cycle. Declare widgets inside it and check events such as `button.clicked()` there. Create persistent state, models, subscriptions, and other resources outside the callback. Keep callbacks free of waits, HTTP requests, and other operations that yield.

```lua
local count = Iris.State(0)

local disconnect = Iris:Connect(function()
    Iris.Window({"Counter"})
        if Iris.Button({"Add one"}).clicked() then
            count:set(count:get() + 1)
        end
        Iris.Text({"Count: " .. count:get()})
    Iris.End()
end)
```

State objects expose `get()`, `set(value)`, `onChange(callback)`, and `changed()`. Register `onChange` subscriptions once, outside the render callback; the returned function disconnects the subscription. Other state helpers include `WeakState`, `VariableState`, `TableState`, and `ComputedState`.

Arguments are positional; widget states use named fields. Use `Iris.Args.Widget.Argument` as a numeric key when skipping optional arguments:

```lua
Iris.Image({
    "rbxasset://textures/face.png",
    UDim2.fromOffset(96, 96),
    [Iris.Args.Image.ScaleType] = Enum.ScaleType.Fit,
})
```

Close every container with `Iris.End()`: for example, `Window`, `Group`, `Tree`, `TabBar`, `Tab`, and a manually built `Combo`. `ComboArray` and `ComboEnum` close their own combo containers. Images, plots, and `Viewport` do not open containers.

Use stable widget IDs for dynamic lists or reused helper functions:

```lua
for _, item in items do
    Iris.PushId(tostring(item.id))
    Iris.Button({item.name})
    Iris.PopId()
end
```

`SetNextWidgetID` assigns an explicit ID to the next widget. Give different widgets different IDs, including a tab and a viewport inside that tab.

## Buttons, toggles, and dropdowns

The added aliases are `Toggle = Checkbox`, `Dropdown = ComboArray`, and `Viewport3D = Viewport`. A toggle uses Iris's checkbox appearance.

For `ComboArray`, the state named `index` stores the selected **value**, such as `"Second"`. A `TabBar` uses a numeric selected-tab index instead.

```lua
local choice = Iris.State("first") -- Create once, outside the callback

-- Inside a render callback:
Iris.Combo({"Mode"}, {index = choice})
    Iris.Selectable({"First mode", "first"}, {index = choice})
    Iris.Selectable({"Second mode", "second"}, {index = choice})
Iris.End()
```

## Tabs

```lua
local selectedTab = Iris.State(1) -- Create once, outside the callback

-- Inside a render callback and an open window:
Iris.TabBar({}, {index = selectedTab})
    if Iris.Tab({"Home"}).active() then
        Iris.Text({"Welcome!"})
    end
    Iris.End()

    if Iris.Tab({"Settings"}).active() then
        Iris.Text({"Your settings go here."})
    end
    Iris.End()
Iris.End()
```

Always declare the tab itself each cycle, then optionally generate its contents only while `active()` is true. Keep persistent state outside those conditional contents. See [TabbedExample.luau](TabbedExample.luau) for a complete five-tab interface.

## Graphs

`PlotLines` draws a uniformly spaced numeric series. `PlotHistogram` draws the supplied values as bars; it does not calculate histogram bins. Both accept an optional height, minimum, maximum, and overlay text. `PlotHistogram` also accepts a baseline.

```lua
local samples = Iris.State({2, 5, 3, 8, 6}) -- Create once

-- Inside a render callback:
Iris.PlotLines({"Signal", 120}, {values = samples})
Iris.PlotHistogram({"Bars", 120, -10, 10, "Units", 0}, {values = samples})
```

Omit the bounds for automatic scaling. Empty arrays and constant-value arrays are supported. Provide finite numbers. Replace the array with `samples:set(newValues)` when updating it, or force an update with `samples:set(existingArray, true)` after an in-place change. Limit the length of continuously sampled data. Hover a graph with a mouse, or touch it in mobile mode, to inspect values.

## Images and external URLs

`Image` and `ImageButton` accept Roblox content IDs, built-in textures, local custom asset IDs, and direct HTTP/HTTPS image URLs.

```lua
-- Inside a render callback:
Iris.Image({"rbxasset://textures/face.png", UDim2.fromOffset(64, 64)})
Iris.Image({"rbxassetid://YOUR_IMAGE_ID", UDim2.fromOffset(180, 100)})

local url = "https://i.pinimg.com/736x/cc/90/b6/cc90b6d6da48076543366ed82dc94332.jpg"
Iris.Image({url, UDim2.fromOffset(240, 300), [Iris.Args.Image.ScaleType] = Enum.ScaleType.Fit})

local status, err = Iris.GetImageStatus(url)
if status == "error" then
    Iris.TextWrapped({tostring(err)})
end
```

External images load asynchronously and are cached on disk. The widget retains its requested size while loading. This feature requires `writefile` and either `getcustomasset` or `getsynasset`. Requests use `request`, `http_request`, or `syn.request` when available, with `game:HttpGet` as a fallback.

Supported downloaded formats are **PNG and JPEG**, up to **12 MiB** per response. The URL must return image bytes directly. HTML gallery pages, SVG, GIF, and video are not converted. Public URLs from Pinterest, Discord CDN, or other hosts work when the executor can access them; authentication, blocked requests, and expired signed URLs can prevent loading.

| Helper | Result |
| --- | --- |
| `Iris.LoadImage(url)` | Starts preloading without waiting; returns current ContentId and status |
| `Iris.GetImageStatus(url)` | Returns `not_requested`, `loading`, `ready`, or `error`, plus an error message when available |
| `Iris.RetryImage(url)` | Retries an image and bypasses its disk cache; an existing pending request is left running |

`ready` means a custom ContentId has been prepared. Check `imageWidget.Instance.IsLoaded` if you need to confirm Roblox has decoded the image. For an existing local file, pass `getcustomasset("image.png")` directly.

## Interactive 3D previews

`Viewport` uses a `ViewportFrame`, `WorldModel`, and its own `Camera`. Pass a client-accessible `Model` or `BasePart`, including a `MeshPart`, with `Archivable = true`. The widget clones it, removes scripts from the clone, anchors its parts, and fits the camera to its bounds. The original object is unchanged.

```lua
-- Create once, using your existing model:
local rotation = Iris.State(Vector2.new(30, -15))
local distance = Iris.State(0)

-- Inside a render callback:
local preview = Iris.Viewport({
    model,
    UDim2.new(1, 0, 0, 240),
    true,
    [Iris.Args.Viewport.FieldOfView] = 45,
}, {rotation = rotation, distance = distance})
```

Rotation is a `Vector2` containing yaw and pitch in degrees. A distance of `0` selects automatic fitting; a positive distance requests a camera distance in studs. `preview` exposes `Instance`/`Viewport`, `Camera`, `WorldModel`, the cloned `Model`, and `hovered()`.

| Position | Argument | Default / meaning |
| --- | --- | --- |
| 1 | `Model` | `nil`; source `Model` or `BasePart` |
| 2 | `Size` | `UDim2.fromOffset(300, 220)` |
| 3 | `AutoRotate` | Off; `true` uses 25 degrees per second, a number sets the speed |
| 4 | `FieldOfView` | `45`; clamped to 1–120 degrees |
| 5 | `BackgroundColor` | Current theme background |
| 6 | `Ambient` | `Color3.fromRGB(170, 170, 170)` |
| 7 | `LightColor` | `Color3.new(1, 1, 1)` |
| 8 | `LightDirection` | `Vector3.new(-1, -1, -1)` |
| 9 | `Revision` | `0`; change it to refresh the clone of the same source object |
| 10 | `Interactive` | `true`; enables rotation and zoom controls |

Drag with the left mouse button to rotate, and use the wheel to zoom. On touch screens, drag with one finger to rotate and pinch with two fingers to zoom. Mobile mode also provides zoom and reset buttons. Auto-rotation pauses during a drag. A gesture inside the preview does not drag the UI window.

Change `Revision` after modifying the source model to refresh its clone. The preview is a rendering container, not a full physics simulation.

## Phones and tablets

Mobile mode activates automatically when `UserInputService.TouchEnabled` is true. It uses the same widget API as desktop mode, with larger text, padding, touch targets, and resize handles. Windows fit the available screen and safe areas; long tab strips, rows, tables, and numeric inputs can scroll horizontally. Window contents and dropdowns scroll vertically.

| Action | Desktop | Touch mode |
| --- | --- | --- |
| Move window | Drag title or empty background | Drag title |
| Scroll contents | Wheel / scrollbar | Vertical swipe |
| Resize window | Drag resize corner | Drag the larger `◢` corner |
| Change slider / drag input | Drag horizontally | Drag horizontally; vertical movement scrolls |
| Secondary click event | Right mouse button | Long press |
| Double-click event | Double-click | Double tap |
| Ctrl-click event | Ctrl + click | Two-finger tap |
| Inspect plot value | Hover | Touch |
| Rotate / zoom 3D | Drag / wheel | One-finger drag / pinch, or zoom buttons |

Where the widget exposes them, these gestures map to `clicked()`, `rightClicked()`, `doubleClicked()`, and `ctrlClicked()`. Holding a finger still can expose hover tooltips. Active gestures are canceled when focus is lost, the widget is removed, the theme is refreshed, or the library shuts down.

The keyboard handling reduces the available window area and scrolls the focused text field into view. The previous bounds are restored after the keyboard closes.

```lua
Iris.Mobile.SetMode("auto") -- Default: use TouchEnabled

-- Preview the mobile layout on a desktop:
Iris.Mobile.SetMode("touch")
Iris.Mobile.SetViewportSize(Vector2.new(390, 844))

-- Restore the actual viewport and automatic mode:
Iris.Mobile.SetViewportSize(nil)
Iris.Mobile.SetMode("auto")

-- Or force desktop mode:
Iris.Mobile.SetMode("desktop")
```

`Iris.Mobile.Enabled` reports the current mode. `Iris.Mobile.GetViewportSize()` returns the current viewport size or your preview override. `SetViewportSize` overrides that size for layout previews; it does not turn a PC into a mobile Roblox device.

## Widget coverage

All upstream library modules are included, together with the built-in demo, Style Editor, and Runtime Info.

| Category | Widgets / helpers |
| --- | --- |
| Windows and menus | `Window`, `Tooltip`, `MenuBar`, `Menu`, `MenuItem`, `MenuToggle` |
| Layout | `Separator`, `SeparatorText`, `Indent`, `SameLine`, `Group`, `Tree`, `CollapsingHeader`, `TabBar`, `Tab`, `Table` |
| Text and selection | `Text`, `TextWrapped`, `TextColored`, `InputText`, `Button`, `SmallButton`, `Checkbox`, `RadioButton`, `Selectable`, `Combo`, `ComboArray`, `ComboEnum`, `InputEnum` |
| Numeric input | `InputNum`, `InputVector2`, `InputVector3`, `InputUDim`, `InputUDim2`, `InputRect` |
| Drag input | `DragNum`, `DragVector2`, `DragVector3`, `DragUDim`, `DragUDim2`, `DragRect` |
| Sliders | `SliderNum`, `SliderVector2`, `SliderVector3`, `SliderUDim`, `SliderUDim2`, `SliderRect` |
| Color | `InputColor3`, `InputColor4` |
| Media and graphs | `Image`, `ImageButton`, `PlotLines`, `PlotHistogram`, `ProgressBar`, `Viewport` |
| Standalone aliases | `Toggle`, `Dropdown`, `Viewport3D` |

Table helpers include `NextColumn`, `NextRow`, `SetColumnIndex`, `SetRowIndex`, `NextHeaderColumn`, `SetHeaderColumnIndex`, and `SetColumnWidth`. See [API_REFERENCE.md](API_REFERENCE.md) for individual widget schemas. Separate Dear ImGui ecosystem libraries such as ImPlot and ImGuizmo are not included.

## Themes, full demo, and cleanup

```lua
Iris.UpdateGlobalConfig(Iris.TemplateConfig.colorDark)
Iris.UpdateGlobalConfig(Iris.TemplateConfig.sizeClear)

-- Full upstream demo; open Style Editor and Runtime Info from its Tools menu:
local disconnectDemo = Iris:Connect(Iris.ShowDemoWindow)
```

Use `PushConfig({...})` and `PopConfig()` for scoped style overrides. `Iris.Disabled = true` pauses UI updates. Call the function returned by `Connect` to disconnect that callback. Disconnect your own subscriptions and destroy your source models when they are no longer needed.

`Iris.Shutdown()` destroys the interface and ends that library instance. Load the bundle again to create a new instance. When closing the UI from inside a render callback, defer shutdown until the callback finishes:

```lua
if Iris.Button({"Close UI"}).clicked() then
    task.defer(function()
        disconnect()
        Iris.Shutdown()
    end)
end
```

## Verification

The underlying bundle was checked through roblox-mcp in a normal Roblox client with `RunService:IsStudio() == false`. The upstream demo, Style Editor, Runtime Info, graphs, external image loading, and 3D previews were exercised.

The mobile checks passed **22 integration checks** using `VirtualInputManager.SendTouchEvent` and Roblox `Touch` InputObjects on a PC. Coverage included all six numeric data types, buttons and selection, text input, menus, table resizing, scrolling, 3D rotation and pinch zoom, gesture cancellation, and these UI areas: 320×568, 360×800, 390×844, 844×390, 768×1024, and 1024×768. Desktop mouse regression checks also passed.

**Physical Android/iOS devices and their system keyboards were not tested in that session.** Keyboard avoidance was checked with a modeled keyboard height. Executor capabilities and device behavior should be verified on the devices you intend to support.

## Credits and license

Based on [SirMallard/Iris](https://github.com/SirMallard/Iris), pinned to commit `2bcb21dfe3682890402e6b5428feb811cd317c32`. The upstream MIT copyright and permission notice are preserved in [LICENSE.txt](LICENSE.txt) and the bundle. Retain these notices when redistributing the library.
