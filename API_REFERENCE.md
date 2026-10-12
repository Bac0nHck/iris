# Iris API Reference

Widget schemas from Iris 2.5.1 at commit `2bcb21dfe3682890402e6b5428feb811cd317c32`, with standalone additions documented below.

`Arguments` are positional. `States` are passed by name and may contain `Iris.State` objects. `Events` are methods on the returned widget and are checked inside a render callback. `hasChildren = true` means the widget opens a container that must be closed with `Iris.End()`; `ComboArray` and `ComboEnum` close their own containers.

The blocks below describe API types and defaults; they are **reference schemas, not executable Lua code**. `Table.hasState` follows the implementation. The `TabBar` schema is supplied from its implementation because it is absent from the extracted upstream documentation.

## Window

```lua
hasChildren = true
hasState = true
Arguments = {
    Title: string,
    NoTitleBar: boolean? = false,
    NoBackground: boolean? = false, -- the background behind the widget container.
    NoCollapse: boolean? = false,
    NoClose: boolean? = false,
    NoMove: boolean? = false,
    NoScrollbar: boolean? = false, -- the scrollbar if the window is too short for all widgets.
    NoResize: boolean? = false,
    NoNav: boolean? = false, -- unimplemented.
    NoMenu: boolean? = false -- whether the menubar will show if created.
}
Events = {
    opened: () -> boolean, -- once when opened.
    closed: () -> boolean, -- once when closed.
    collapsed: () -> boolean, -- once when collapsed.
    uncollapsed: () -> boolean, -- once when uncollapsed.
    hovered: () -> boolean -- fires when the mouse hovers over any of the window.
}
States = {
    size: State<Vector2>? = Vector2.new(400, 300),
    position: State<Vector2>?,
    isUncollapsed: State<boolean>? = true,
    isOpened: State<boolean>? = true,
    scrollDistance: State<number>? -- vertical scroll distance, if too short.
}
```

## Tooltip

```lua
hasChildren = false
hasState = false
Arguments = {
    Text: string
}
```

## MenuBar

```lua
hasChildren = true
hasState = false
```

## Menu

```lua
hasChildren = true
hasState = true
Arguments = {
    Text: string -- menu text.
}
Events = {
    clicked: () -> boolean,
    opened: () -> boolean, -- once when opened.
    closed: () -> boolean, -- once when closed.
    hovered: () -> boolean
}
States = {
    isOpened: State<boolean>? -- whether the menu is open, including any sub-menus within.
}
```

## MenuItem

```lua
hasChildren = false
hasState = false
Arguments = {
    Text: string,
    KeyCode: Enum.KeyCode? = nil, -- an optional keycode, does not actually connect an event.
    ModifierKey: Enum.ModifierKey? = nil -- an optional modifer key for the key code.
}
Events = {
    clicked: () -> boolean,
    hovered: () -> boolean
}
```

## MenuToggle

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string,
    KeyCode: Enum.KeyCode? = nil, -- an optional keycode, does not actually connect an event.
    ModifierKey: Enum.ModifierKey? = nil -- an optional modifer key for the key code.
}
Events = {
    checked: () -> boolean, -- once on check.
    unchecked: () -> boolean, -- once on uncheck.
    hovered: () -> boolean
}
States = {
    isChecked: State<boolean>?
}
```

## Separator

```lua
hasChildren = false
hasState = false
```

## Indent

```lua
hasChildren = true
hasState = false
Arguments = {
    Width: number? = Iris._config.IndentSpacing -- indent width ammount.
}
```

## SameLine

```lua
hasChildren = true
hasState = false
Arguments = {
    Width: number? = Iris._config.ItemSpacing.X, -- horizontal spacing between child widgets.
    VerticalAlignment: Enum.VerticalAlignment? = Enum.VerticalAlignment.Center -- how widgets vertically to each other.
    HorizontalAlignment: Enum.HorizontalAlignment? = Enum.HorizontalAlignment.Center -- how widgets are horizontally.
}
```

## Group

```lua
hasChildren = true
hasState = false
```

## Text

```lua
hasChildren = false
hasState = false
Arguments = {
    Text: string,
    Wrapped: boolean? = [CONFIG] = false, -- whether the text will wrap around inside the parent container. If not specified, then equal to the config
    Color: Color3? = Iris._config.TextColor, -- the colour of the text.
    RichText: boolean? = [CONFIG] = false -- enable RichText. If not specified, then equal to the config
}
Events = {
    hovered: () -> boolean
}
```

## TextWrapped

```lua
hasChildren = false
hasState = false
Arguments = {
    Text: string,
}
Events = {
    hovered: () -> boolean
}
```

## TextColored

```lua
hasChildren = false
hasState = false
Arguments = {
    Text: string,
    Color: Color3 -- the colour of the text.
}
Events = {
    hovered: () -> boolean
}
```

## SeparatorText

```lua
hasChildren = false
hasState = false
Arguments = {
    Text: string
}
```

## InputText

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string? = "InputText",
    TextHint: string? = "", -- a hint to display when the text box is empty.
    ReadOnly: boolean? = false,
    MultiLine: boolean? = false
}
Events = {
    textChanged: () -> boolean, -- whenever the textbox looses focus and a change was made.
    hovered: () -> boolean
}
States = {
    text: State<string>?
}
```

## Button

```lua
hasChildren = false
hasState = false
Arguments = {
    Text: string,
    Size: UDim2? = UDim2.fromOffset(0, 0),
}
Events = {
    clicked: () -> boolean,
    rightClicked: () -> boolean,
    doubleClicked: () -> boolean,
    ctrlClicked: () -> boolean, -- when the control key is down and clicked.
    hovered: () -> boolean
}
```

## SmallButton

```lua
hasChildren = false
hasState = false
Arguments = {
    Text: string,
    Size: UDim2? = 0,
}
Events = {
    clicked: () -> boolean,
    rightClicked: () -> boolean,
    doubleClicked: () -> boolean,
    ctrlClicked: () -> boolean, -- when the control key is down and clicked.
    hovered: () -> boolean
}
```

## Checkbox

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string
}
Events = {
    checked: () -> boolean, -- once when checked.
    unchecked: () -> boolean, -- once when unchecked.
    hovered: () -> boolean
}
States = {
    isChecked = State<boolean>? -- whether the box is checked.
}
```

## RadioButton

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string,
    Index: any -- the state object is set to when clicked.
}
Events = {
    selected: () -> boolean,
    unselected: () -> boolean,
    active: () -> boolean, -- if the state index equals the RadioButton's index.
    hovered: () -> boolean
}
States = {
    index = State<any>? -- the state set by the index of a RadioButton.
}
```

## Image

```lua
hasChildren = false
hasState = false
Arguments = {
    Image: string, -- the texture asset id
    Size: UDim2,
    Rect: Rect? = Rect.new(), -- Rect structure which is used to determine the offset or size. An empty, zeroed rect is equivalent to nil
    ScaleType: Enum.ScaleType? = Enum.ScaleType.Stretch, -- used to determine whether the TileSize, SliceCenter and SliceScale arguments are used
    ResampleMode: Enum.ResampleMode? = Enum.ResampleMode.Default,
    TileSize: UDim2? = UDim2.fromScale(1, 1), -- only used if the ScaleType is set to Tile
    SliceCenter: Rect? = Rect.new(), -- only used if the ScaleType is set to Slice
    SliceScale: number? = 1 -- only used if the ScaleType is set to Slice
}
Events = {
    hovered: () -> boolean
}
```

## ImageButton

```lua
hasChildren = false
hasState = false
Arguments = {
    Image: string, -- the texture asset id
    Size: UDim2,
    Rect: Rect? = Rect.new(), -- Rect structure which is used to determine the offset or size. An empty, zeroed rect is equivalent to nil
    ScaleType: Enum.ScaleType? = Enum.ScaleType.Stretch, -- used to determine whether the TileSize, SliceCenter and SliceScale arguments are used
    ResampleMode: Enum.ResampleMode? = Enum.ResampleMode.Default,
    TileSize: UDim2? = UDim2.fromScale(1, 1), -- only used if the ScaleType is set to Tile
    SliceCenter: Rect? = Rect.new(), -- only used if the ScaleType is set to Slice
    SliceScale: number? = 1 -- only used if the ScaleType is set to Slice
}
Events = {
    clicked: () -> boolean,
    rightClicked: () -> boolean,
    doubleClicked: () -> boolean,
    ctrlClicked: () -> boolean, -- when the control key is down and clicked.
    hovered: () -> boolean
}
```

## Tree

```lua
hasChildren: true
hasState: true
Arguments = {
    Text: string,
    SpanAvailWidth: boolean? = false, -- the tree title will fill all horizontal space to the end its parent container.
    NoIndent: boolean? = false, -- the child widgets will not be indented underneath.
    DefaultOpen: boolean? = false -- initially opens the tree if no state is provided
}
Events = {
    collapsed: () -> boolean,
    uncollapsed: () -> boolean,
    hovered: () -> boolean
}
States = {
    isUncollapsed: State<boolean>? -- whether the widget is collapsed.
}
```

## CollapsingHeader

```lua
hasChildren: true
hasState: true
Arguments = {
    Text: string,
    DefaultOpen: boolean? = false -- initially opens the tree if no state is provided
}
Events = {
    collapsed: () -> boolean,
    uncollapsed: () -> boolean,
    hovered: () -> boolean
}
States = {
    isUncollapsed: State<boolean>? -- whether the widget is collapsed.
}
```

## TabBar

```lua
hasChildren = true -- only Tab widgets can be direct children
hasState = true
Arguments = {}
Events = {}
States = {
    index: number = 1 -- selected tab's 1-based index; 0 if all tabs are closed
}
```

Declare each tab on every render cycle. Use `tab.active()` to conditionally generate its contents. Close every `Tab` and the `TabBar` with `Iris.End()`.

## Tab

```lua
hasChildren: true
hasState: true
Arguments = {
    Text: string,
    Hideable: boolean? = nil -- determines whether a tab can be closed/hidden
}
Events = {
    clicked: () -> boolean,
    hovered: () -> boolean
    selected: () -> boolean
    unselected: () -> boolean
    active: () -> boolean
    opened: () -> boolean
    closed: () -> boolean
}
States = {
    isOpened: State<boolean>?
}
```

## InputNum

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string? = "InputNum",
    Increment: number? = nil,
    Min: number? = nil,
    Max: number? = nil,
    Format: string? | { string }? = [DYNAMIC], -- Iris will dynamically generate an approriate format.
    NoButtons: boolean? = false -- whether to display + and - buttons next to the input box.
}
Events = {
    numberChanged: () -> boolean,
    hovered: () -> boolean
}
States = {
    number: State<number>?,
    editingText: State<boolean>?
}
```

## InputVector2

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string? = "InputVector2",
    Increment: Vector2? = nil,
    Min: Vector2? = nil,
    Max: Vector2? = nil,
    Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
}
Events = {
    numberChanged: () -> boolean,
    hovered: () -> boolean
}
States = {
    number: State<Vector2>?,
    editingText: State<boolean>?
}
```

## InputVector3

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string? = "InputVector3",
    Increment: Vector3? = nil,
    Min: Vector3? = nil,
    Max: Vector3? = nil,
    Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
}
Events = {
    numberChanged: () -> boolean,
    hovered: () -> boolean
}
States = {
    number: State<Vector3>?,
    editingText: State<boolean>?
}
```

## InputUDim

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string? = "InputUDim",
    Increment: UDim? = nil,
    Min: UDim? = nil,
    Max: UDim? = nil,
    Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
}
Events = {
    numberChanged: () -> boolean,
    hovered: () -> boolean
}
States = {
    number: State<UDim>?,
    editingText: State<boolean>?
}
```

## InputUDim2

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string? = "InputUDim2",
    Increment: UDim2? = nil,
    Min: UDim2? = nil,
    Max: UDim2? = nil,
    Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
}
Events = {
    numberChanged: () -> boolean,
    hovered: () -> boolean
}
States = {
    number: State<UDim2>?,
    editingText: State<boolean>?
}
```

## InputRect

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string? = "InputRect",
    Increment: Rect? = nil,
    Min: Rect? = nil,
    Max: Rect? = nil,
    Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
}
Events = {
    numberChanged: () -> boolean,
    hovered: () -> boolean
}
States = {
    number: State<Rect>?,
    editingText: State<boolean>?
}
```

## DragNum

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string? = "DragNum",
    Increment: number? = nil,
    Min: number? = nil,
    Max: number? = nil,
    Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
}
Events = {
    numberChanged: () -> boolean,
    hovered: () -> boolean
}
States = {
    number: State<number>?,
    editingText: State<boolean>?
}
```

## DragVector2

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string? = "DragVector2",
    Increment: Vector2? = nil,
    Min: Vector2? = nil,
    Max: Vector2? = nil,
    Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
}
Events = {
    numberChanged: () -> boolean,
    hovered: () -> boolean
}
States = {
    number: State<Vector2>?,
    editingText: State<boolean>?
}
```

## DragVector3

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string? = "DragVector3",
    Increment: Vector3? = nil,
    Min: Vector3? = nil,
    Max: Vector3? = nil,
    Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
}
Events = {
    numberChanged: () -> boolean,
    hovered: () -> boolean
}
States = {
    number: State<Vector3>?,
    editingText: State<boolean>?
}
```

## DragUDim

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string? = "DragUDim",
    Increment: UDim? = nil,
    Min: UDim? = nil,
    Max: UDim? = nil,
    Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
}
Events = {
    numberChanged: () -> boolean,
    hovered: () -> boolean
}
States = {
    number: State<UDim>?,
    editingText: State<boolean>?
}
```

## DragUDim2

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string? = "DragUDim2",
    Increment: UDim2? = nil,
    Min: UDim2? = nil,
    Max: UDim2? = nil,
    Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
}
Events = {
    numberChanged: () -> boolean,
    hovered: () -> boolean
}
States = {
    number: State<UDim2>?,
    editingText: State<boolean>?
}
```

## DragRect

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string? = "DragRect",
    Increment: Rect? = nil,
    Min: Rect? = nil,
    Max: Rect? = nil,
    Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
}
Events = {
    numberChanged: () -> boolean,
    hovered: () -> boolean
}
States = {
    number: State<Rect>?,
    editingText: State<boolean>?
}
```

## InputColor3

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string? = "InputColor3",
    UseFloats: boolean? = false, -- constrain the values between floats 0 and 1 or integers 0 and 255.
    UseHSV: boolean? = false, -- input using HSV instead.
    Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
}
Events = {
    numberChanged: () -> boolean,
    hovered: () -> boolean
}
States = {
    color: State<Color3>?,
    editingText: State<boolean>?
}
```

## InputColor4

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string? = "InputColor4",
    UseFloats: boolean? = false, -- constrain the values between floats 0 and 1 or integers 0 and 255.
    UseHSV: boolean? = false, -- input using HSV instead.
    Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
}
Events = {
    numberChanged: () -> boolean,
    hovered: () -> boolean
}
States = {
    color: State<Color3>?,
    transparency: State<number>?,
    editingText: State<boolean>?
}
```

## SliderNum

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string? = "SliderNum",
    Increment: number? = 1,
    Min: number? = 0,
    Max: number? = 100,
    Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
}
Events = {
    numberChanged: () -> boolean,
    hovered: () -> boolean
}
States = {
    number: State<number>?,
    editingText: State<boolean>?
}
```

## SliderVector2

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string? = "SliderVector2",
    Increment: Vector2? = { 1, 1 },
    Min: Vector2? = { 0, 0 },
    Max: Vector2? = { 100, 100 },
    Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
}
Events = {
    numberChanged: () -> boolean,
    hovered: () -> boolean
}
States = {
    number: State<Vector2>?,
    editingText: State<boolean>?
}
```

## SliderVector3

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string? = "SliderVector3",
    Increment: Vector3? = { 1, 1, 1 },
    Min: Vector3? = { 0, 0, 0 },
    Max: Vector3? = { 100, 100, 100 },
    Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
}
Events = {
    numberChanged: () -> boolean,
    hovered: () -> boolean
}
States = {
    number: State<Vector3>?,
    editingText: State<boolean>?
}
```

## SliderUDim

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string? = "SliderUDim",
    Increment: UDim? = { 0.01, 1 },
    Min: UDim? = { 0, 0 },
    Max: UDim? = { 1, 960 },
    Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
}
Events = {
    numberChanged: () -> boolean,
    hovered: () -> boolean
}
States = {
    number: State<UDim>?,
    editingText: State<boolean>?
}
```

## SliderUDim2

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string? = "SliderUDim2",
    Increment: UDim2? = { 0.01, 1, 0.01, 1 },
    Min: UDim2? = { 0, 0, 0, 0 },
    Max: UDim2? = { 1, 960, 1, 960 },
    Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
}
Events = {
    numberChanged: () -> boolean,
    hovered: () -> boolean
}
States = {
    number: State<UDim2>?,
    editingText: State<boolean>?
}
```

## SliderRect

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string? = "SliderRect",
    Increment: Rect? = { 1, 1, 1, 1 },
    Min: Rect? = { 0, 0, 0, 0 },
    Max: Rect? = { 960, 960, 960, 960 },
    Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
}
Events = {
    numberChanged: () -> boolean,
    hovered: () -> boolean
}
States = {
    number: State<Rect>?,
    editingText: State<boolean>?
}
```

## Selectable

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string,
    Index: any, -- index of selectable value.
    NoClick: boolean? = false -- prevents the selectable from being clicked by the user.
}
Events = {
    selected: () -> boolean,
    unselected: () -> boolean,
    active: () -> boolean,
    clicked: () -> boolean,
    rightClicked: () -> boolean,
    doubleClicked: () -> boolean,
    ctrlClicked: () -> boolean,
    hovered: () -> boolean,
}
States = {
    index: State<any> -- a shared state between all selectables.
}
```

## Combo

```lua
hasChildren = true
hasState = true
Arguments = {
    Text: string,
    NoButton: boolean? = false, -- hide the dropdown button.
    NoPreview: boolean? = false -- hide the preview field.
}
Events = {
    opened: () -> boolean,
    closed: () -> boolean,
    changed: () -> boolean,
    clicked: () -> boolean,
    hovered: () -> boolean
}
States = {
    index: State<any>,
    isOpened: State<boolean>?
}
```

## ComboArray

```lua
hasChildren = true
hasState = true
Arguments = {
    Text: string,
    NoButton: boolean? = false, -- hide the dropdown button.
    NoPreview: boolean? = false -- hide the preview field.
}
Events = {
    opened: () -> boolean,
    closed: () -> boolean,
    clicked: () -> boolean,
    hovered: () -> boolean
}
States = {
    index: State<any>,
    isOpened: State<boolean>?
}
Extra = {
    selectionArray: { any } -- the array to generate a combo from.
}
```

## ComboEnum

```lua
hasChildren = true
hasState = true
Arguments = {
    Text: string,
    NoButton: boolean? = false, -- hide the dropdown button.
    NoPreview: boolean? = false -- hide the preview field.
}
Events = {
    opened: () -> boolean,
    closed: () -> boolean,
    clicked: () -> boolean,
    hovered: () -> boolean
}
States = {
    index: State<any>,
    isOpened: State<boolean>?
}
Extra = {
    enumType: Enum -- the enum to generate a combo from.
}
```

## InputEnum

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string? = "InputEnum",
    Increment: number? = 1,
    Min: number? = 0,
    Max: number? = 100,
    Format: string? | { string }? = [DYNAMIC] -- Iris will dynamically generate an approriate format.
}
Events = {
    numberChanged: () -> boolean,
    hovered: () -> boolean
}
States = {
    number: State<number>?,
    editingText: State<boolean>?,
    enumItem: EnumItem
}
```

## ProgressBar

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string? = "Progress Bar",
    Format: string? = nil -- optional to override with a custom progress such as `29/54`
}
Events = {
    hovered: () -> boolean,
    changed: () -> boolean
}
States = {
    progress: State<number>?
}
```

## PlotLines

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string? = "Plot Lines",
    Height: number? = 0,
    Min: number? = min, -- Iris will use the minimum value from the values
    Max: number? = max, -- Iris will use the maximum value from the values
    TextOverlay: string? = ""
}
Events = {
    hovered: () -> boolean
}
States = {
    values: State<{number}>?,
    hovered: State<{number}>? -- read-only property
}
```

## PlotHistogram

```lua
hasChildren = false
hasState = true
Arguments = {
    Text: string? = "Plot Histogram",
    Height: number? = 0,
    Min: number? = min, -- Iris will use the minimum value from the values
    Max: number? = max, -- Iris will use the maximum value from the values
    TextOverlay: string? = "",
    BaseLine: number? = 0 -- by default, blocks swap side at 0
}
Events = {
    hovered: () -> boolean
}
States = {
    values: State<{number}>?,
    hovered: State<{number}>? -- read-only property
}
```

## Table

```lua
hasChildren = true
hasState = true
Arguments = {
    NumColumns: number, -- number of columns in the table, cannot be changed
    Header: boolean? = false, -- display a header row for each column
    RowBackground: boolean? = false, -- alternating row background colours
    OuterBorders: boolean? = false, -- outer border on the entire table
    InnerBorders: boolean? = false, -- inner bordres on the entire table
    Resizable: boolean? = false, -- the columns can be resized by dragging or state
    FixedWidth: boolean? = false, -- columns takes up a fixed pixel width, rather than a proportion of the total available
    ProportionalWidth: boolean? = false, -- minimises the width of each column individually
    LimitTableWidth: boolean? = false, -- when a fixed width, cut of any unused space
}
Events = {
    hovered: () -> boolean
}
States = {
    widths: State<{ number }>? -- the widths of each column if Resizable
}
```

## Viewport (standalone extension)

```lua
hasChildren = false
hasState = true
Arguments = {
    Model: Instance? = nil, -- an Archivable Model or BasePart
    Size: UDim2 = UDim2.fromOffset(300, 220),
    AutoRotate: (boolean | number)? = nil, -- true: 25 degrees/second; number: custom speed
    FieldOfView: number = 45, -- clamped to 1–120 degrees
    BackgroundColor: Color3?, -- current theme background by default
    Ambient: Color3 = Color3.fromRGB(170, 170, 170),
    LightColor: Color3 = Color3.new(1, 1, 1),
    LightDirection: Vector3 = Vector3.new(-1, -1, -1),
    Revision: number = 0, -- change to refresh the clone of the same source
    Interactive: boolean = true
}
States = {
    rotation: Vector2 = Vector2.new(30, -15), -- yaw and pitch in degrees
    distance: number = 0 -- 0: fit automatically; positive: requested distance in studs
}
Events = {
    hovered: () -> boolean
}
```

The returned widget exposes `Instance`/`Viewport`, `Camera`, `WorldModel`, and its cloned `Model`. It clones the source, removes scripts from the clone, and anchors cloned parts. See [3D previews](README.md#interactive-3d-previews) for input controls and refresh behavior.

## Aliases

| Name | Equivalent API |
| --- | --- |
| `Toggle` | `Checkbox` |
| `Dropdown` | `ComboArray` |
| `Viewport3D` | `Viewport` |

Aliases use the same arguments, states, and events as their target widgets. `Toggle` uses the checkbox appearance. `Dropdown`'s `index` state stores the selected value, not its position in the option array.

## External image helpers

| Function | Behavior |
| --- | --- |
| `LoadImage(url)` | Starts an asynchronous direct HTTP/HTTPS image load; returns ContentId and status. ContentId is empty while pending. |
| `GetImageStatus(url)` | Returns status and optional error. Status: `not_requested`, `loading`, `ready`, or `error`. |
| `RetryImage(url)` | Starts a fresh download bypassing the disk cache, unless a request is already pending. |

`Image` and `ImageButton` call this loader automatically for HTTP/HTTPS arguments. See [image requirements](README.md#images-and-external-urls) for supported formats, executor functions, and cache behavior.

## Mobile API

| Member | Behavior |
| --- | --- |
| `Iris.Mobile.Enabled` | Whether the touch layout is currently active |
| `Iris.Mobile.SetMode(mode)` | `"auto"`, `"touch"`, or `"desktop"`; auto is the default |
| `Iris.Mobile.SetViewportSize(size)` | Override available UI area with a `Vector2`; pass `nil` to restore the actual viewport |
| `Iris.Mobile.GetViewportSize()` | Return the viewport size or explicit preview override as a `Vector2` |

The viewport override is a layout preview. It does not emulate mobile hardware or a system keyboard. See [mobile controls and test coverage](README.md#phones-and-tablets).

## Core APIs and table helpers

The upstream core APIs are preserved: `Init`, `Connect`, `Shutdown`, `State`, `WeakState`, `VariableState`, `TableState`, `ComputedState`, `End`, `PushId`, `PopId`, `SetNextWidgetID`, `UpdateGlobalConfig`, `PushConfig`, `PopConfig`, `ForceRefresh`, and `ShowDemoWindow`. `Disabled`, `Args`, and `TemplateConfig` are also available.

Table positioning and sizing helpers: `NextColumn`, `NextRow`, `SetColumnIndex`, `SetRowIndex`, `NextHeaderColumn`, `SetHeaderColumnIndex`, and `SetColumnWidth`.

`Connect` returns a disconnect function. `Shutdown` ends the instance; load the standalone bundle again to start a new one. The standalone loader initializes automatically and exposes the chosen GUI parent mode through `Iris.Standalone.ParentMode`.
