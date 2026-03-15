-- Build version control
table.insert(ctrls, {
  Name = "BuildVersion",
  Count = 1,
  ControlType = "Text",
  UserPin = false,
  PinStyle = "None",
})

-- Refresh button to rescan for components
table.insert(ctrls, {
  Name = "Refresh",
  ControlType = "Button",
  ButtonType = "Trigger",
  Count = 1,
  UserPin = true,
  PinStyle = "Input"
})

-- Status indicator
table.insert(ctrls, {
  Name = "Status",
  ControlType = "Indicator",
  IndicatorType = "Status",
  Count = 1,
  UserPin = true,
  PinStyle = "Output"
})

-- Component count display
table.insert(ctrls, {
  Name = "ComponentCount",
  ControlType = "Text",
  Count = 1,
  UserPin = true,
  PinStyle = "Output"
})

-- Create enable/disable toggles and component name displays for each possible component
local maxComponents = props["Max Components"].Value
for i = 1, maxComponents do
  table.insert(ctrls, {
    Name = "Enable" .. i,
    ControlType = "Button",
    ButtonType = "Toggle",
    Count = 1,
    UserPin = true,
    PinStyle = "Both"
  })
  
  table.insert(ctrls, {
    Name = "ComponentName" .. i,
    ControlType = "Text",
    Count = 1,
    UserPin = true,
    PinStyle = "Output"
  })
end
