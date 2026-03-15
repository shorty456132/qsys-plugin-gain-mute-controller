local CurrentPage = PageNames[props["page_index"].Value]

if CurrentPage == "Control" then
  -- Plugin background
  table.insert(graphics, {
    Type = "GroupBox",
    Fill = { 35, 35, 35 },
    StrokeColor = { 35, 35, 35 },
    StrokeWidth = 0,
    CornerRadius = 0,
    Position = { 0, 0 },
    Size = { 500, 500 },
    ZOrder = -10
  })

  -- Build version display (bottom left)
  table.insert(graphics, {
    Type = "Label",
    Text = "Build Version: " .. PluginInfo.BuildVersion,
    Size = { 200, 16 },
    Position = { 5, 480 },
    HTextAlign = "Left",
    Color = { 180, 180, 180 },
    FontSize = 9
  })

  -- Status section
  table.insert(graphics, {
    Type = "GroupBox",
    Text = "Status",
    Fill = { 55, 55, 55 },
    Color = { 221, 221, 221 },
    StrokeColor = { 80, 80, 80 },
    StrokeWidth = 1,
    CornerRadius = 8,
    Font = "Roboto",
    FontSize = 11,
    Position = { 10, 10 },
    Size = { 480, 60 },
    ZOrder = -5
  })

  -- Refresh button
  layout["Refresh"] = {
    PrettyName = "Control~Refresh Components",
    Style = "Button",
    ButtonStyle = "Trigger",
    ButtonVisualStyle = "Flat",
    Position = { 20, 35 },
    Size = { 100, 24 },
    Color = { 100, 150, 255 },
    Legend = "Refresh",
    FontSize = 11,
    CornerRadius = 4
  }

  -- Status LED
  layout["Status"] = {
    PrettyName = "Control~Status",
    Style = "Led",
    Position = { 130, 39 },
    Size = { 16, 16 },
    Color = { 0, 255, 0 },
    OffColor = { 100, 0, 0 },
    UnlinkOffColor = true
  }

  -- Component count display
  table.insert(graphics, {
    Type = "Label",
    Text = "Components Found:",
    Color = { 200, 200, 200 },
    FontSize = 11,
    Font = "Roboto",
    HTextAlign = "Left",
    Position = { 160, 35 },
    Size = { 120, 24 }
  })

  layout["ComponentCount"] = {
    PrettyName = "Control~Component Count",
    Style = "Text",
    Position = { 280, 35 },
    Size = { 50, 24 },
    FontSize = 11,
    Color = { 255, 255, 255 },
    CornerRadius = 4
  }

  -- Components section
  table.insert(graphics, {
    Type = "GroupBox",
    Text = "Gain Components",
    Fill = { 55, 55, 55 },
    Color = { 221, 221, 221 },
    StrokeColor = { 80, 80, 80 },
    StrokeWidth = 1,
    CornerRadius = 8,
    Font = "Roboto",
    FontSize = 11,
    Position = { 10, 80 },
    Size = { 480, 400 },
    ZOrder = -5
  })

  -- Navigation section
  table.insert(graphics, {
    Type = "Label",
    Text = "Navigation:",
    Color = { 200, 200, 200 },
    Font = "Roboto",
    FontSize = 11,
    HTextAlign = "Left",
    Position = { 25, 105 },
    Size = { 80, 20 }
  })

  -- Page Up button
  layout["PageUp"] = {
    PrettyName = "Control~Page Up",
    Style = "Button",
    ButtonStyle = "Trigger",
    ButtonVisualStyle = "Flat",
    Position = { 110, 105 },
    Size = { 30, 20 },
    Color = { 100, 150, 255 },
    Legend = "▲",
    FontSize = 12,
    CornerRadius = 4
  }

  -- Page Down button
  layout["PageDown"] = {
    PrettyName = "Control~Page Down",
    Style = "Button",
    ButtonStyle = "Trigger",
    ButtonVisualStyle = "Flat",
    Position = { 145, 105 },
    Size = { 30, 20 },
    Color = { 100, 150, 255 },
    Legend = "▼",
    FontSize = 12,
    CornerRadius = 4
  }

  -- Page info display
  layout["PageInfo"] = {
    PrettyName = "Control~Page Info",
    Style = "Text",
    Position = { 180, 105 },
    Size = { 100, 20 },
    FontSize = 10,
    Color = { 255, 255, 255 },
    CornerRadius = 4
  }

  -- Headers
  table.insert(graphics, {
    Type = "Label",
    Text = "Enable",
    Color = { 221, 221, 221 },
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Bold",
    HTextAlign = "Center",
    Position = { 25, 135 },
    Size = { 60, 20 }
  })

  table.insert(graphics, {
    Type = "Label",
    Text = "Component Name",
    Color = { 221, 221, 221 },
    Font = "Roboto",
    FontSize = 12,
    FontStyle = "Bold",
    HTextAlign = "Left",
    Position = { 95, 135 },
    Size = { 380, 20 }
  })

  -- Create 12 static display slots
  for i = 1, 12 do
    local yPos = 160 + (i - 1) * 25

    -- Enable toggle button
    layout["Enable" .. i] = {
      PrettyName = string.format("Control~Enable Slot %i", i),
      Style = "Button",
      ButtonStyle = "Toggle",
      ButtonVisualStyle = "Flat",
      Position = { 30, yPos },
      Size = { 50, 22 },
      Color = { 0, 180, 80 },
      OffColor = { 80, 80, 80 },
      UnlinkOffColor = true,
      Legend = "ON",
      FontSize = 9,
      CornerRadius = 4
    }

    -- Component name display
    layout["ComponentName" .. i] = {
      PrettyName = string.format("Control~Component Name Slot %i", i),
      Style = "Text",
      Position = { 95, yPos },
      Size = { 380, 22 },
      FontSize = 10,
      Color = { 255, 255, 255 },
      CornerRadius = 4
    }
  end

elseif CurrentPage == "Instructions" then
  -- Plugin background
  table.insert(graphics, {
    Type = "GroupBox",
    Fill = { 35, 35, 35 },
    StrokeColor = { 35, 35, 35 },
    StrokeWidth = 0,
    CornerRadius = 0,
    Position = { 0, 0 },
    Size = { 500, 300 },
    ZOrder = -10
  })

  -- Build version display (bottom left)
  table.insert(graphics, {
    Type = "Label",
    Text = "Build Version: " .. PluginInfo.BuildVersion,
    Size = { 200, 16 },
    Position = { 5, 280 },
    HTextAlign = "Left",
    Color = { 180, 180, 180 },
    FontSize = 9
  })

  -- Instructions
  table.insert(graphics, {
    Type = "Header",
    Text = "Setup Instructions",
    Color = { 221, 221, 221 },
    Font = "Roboto",
    FontSize = 16,
    FontStyle = "Bold",
    HTextAlign = "Left",
    Position = { 20, 20 },
    Size = { 460, 25 }
  })

  table.insert(graphics, {
    Type = "Label",
    Text = "1. Any Gain controls will need script access enabled",
    Size = { 460, 30 },
    Position = { 20, 60 },
    VTextAlign = "Top",
    HTextAlign = "Left",
    Color = { 200, 200, 200 },
    FontSize = 12
  })

  table.insert(graphics, {
    Type = "Label",
    Text = "2. Go to the Control page and click 'Refresh' to scan for all gain components",
    Size = { 460, 30 },
    Position = { 20, 95 },
    VTextAlign = "Top",
    HTextAlign = "Left",
    Color = { 200, 200, 200 },
    FontSize = 12
  })

  table.insert(graphics, {
    Type = "Label",
    Text = "3. Use Up/Down arrows to navigate through found components if more than 12 exist",
    Size = { 460, 30 },
    Position = { 20, 130 },
    VTextAlign = "Top",
    HTextAlign = "Left",
    Color = { 200, 200, 200 },
    FontSize = 12
  })

  table.insert(graphics, {
    Type = "Label",
    Text = "4. Enable the components you want to auto-control by clicking their toggle buttons",
    Size = { 460, 30 },
    Position = { 20, 165 },
    VTextAlign = "Top",
    HTextAlign = "Left",
    Color = { 200, 200, 200 },
    FontSize = 12
  })

  table.insert(graphics, {
    Type = "Label",
    Text = "5. Enabled components will auto-mute when gain reaches 0 and unmute when raised above previous position",
    Size = { 460, 30 },
    Position = { 20, 200 },
    VTextAlign = "Top",
    HTextAlign = "Left",
    Color = { 200, 200, 200 },
    FontSize = 12
  })
end
