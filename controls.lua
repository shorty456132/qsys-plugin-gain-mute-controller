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

-- Navigation controls
table.insert(ctrls, {
  Name = "PageUp",
  ControlType = "Button",
  ButtonType = "Trigger",
  Count = 1,
  UserPin = true,
  PinStyle = "Input"
})

table.insert(ctrls, {
  Name = "PageDown",
  ControlType = "Button",
  ButtonType = "Trigger",
  Count = 1,
  UserPin = true,
  PinStyle = "Input"
})

-- Page indicator
table.insert(ctrls, {
  Name = "PageInfo",
  ControlType = "Text",
  Count = 1,
  UserPin = true,
  PinStyle = "Output"
})

-- Create 12 static display slots for components
for i = 1, 12 do
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
