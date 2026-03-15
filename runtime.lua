--[[ Summary:
    Enhanced script that controls the mute status of selected mic gain blocks on a UCI. 
    if the gain is all the way down, the mute will trigger. When the knob moves above where it currently is, it will unmute. 
    if the gain block is muted and the knob moves lower, the mute will still stay muted.
    
    New Features:
    - Individual enable/disable toggles for each gain component
    - Only applies mute logic to enabled components
    - Dynamic component discovery and display
    
    Requirements:
      - the gain block needs to have script access set to all or script
      - the block's component name needs to have 'Mic' or 'Program' in it. 
        - if using custom components, use the 'gain - mic' component and the 'gain - program' component. 
          it has the name and script access built in
]]

--------------------
-- Components ------
--------------------
local AllComponents = {}
-- End Components --

--------------------
-- Variables -------
--------------------
local gainComponents = {}                 -- holds all the gains in the design
local newGainPosition = {}               -- tracks last known position for each gain
local componentCount = 0                 -- number of found components
local maxComponents = Properties["Max Components"].Value
-- End Variables ---

--------------------
-- Functions -------
--------------------

--[[ Summary:
    Loops through all components and finds the gain blocks that contain the name 'Mic' or 'Program'
    creates a new component and adds it to the gain components table
    Updates the UI with found component names
]]
function ScanForComponents()
  print("Scanning for gain components...")
  
  -- Clear existing data
  gainComponents = {}
  newGainPosition = {}
  componentCount = 0
  
  -- Get all components with script access
  AllComponents = Component.GetComponents()
  
  -- Find gain components
  for _, component in pairs(AllComponents) do
    for control, option in pairs(component) do
      if control == "Type" and option == "gain" then 
        -- if component.Name:match("Mic") or component.Name:match("Program") then 
          componentCount = componentCount + 1
          if componentCount <= maxComponents then
            print(string.format("Adding %s to the gainComponents table", component.Name))
            table.insert(gainComponents, Component.New(component.Name))
            newGainPosition[componentCount] = 1 -- set initial position to check against at its highest point
            
            -- Update UI controls
            Controls["ComponentName" .. componentCount].String = component.Name
            Controls["Enable" .. componentCount].Boolean = true -- Enable by default
          end
        -- end 
      end 
    end 
  end
  
  -- Clear unused component name displays
  for i = componentCount + 1, maxComponents do
    Controls["ComponentName" .. i].String = ""
    Controls["Enable" .. i].Boolean = false
  end
  
  -- Update component count display
  Controls["ComponentCount"].String = tostring(componentCount)
  
  print("Number of gain components found: ", componentCount)
  
  -- Set up event handlers for all found components
  SetupEventHandlers()
  
  -- Update status
  if componentCount > 0 then
    Controls["Status"].Value = 1  -- Good status
  else
    Controls["Status"].Value = 0  -- No components found
  end
end

--[[ Summary:
    Sets up EventHandlers for all found gain components
]]
function SetupEventHandlers()
  for i = 1, componentCount do 
    local componentIndex = i  -- Capture loop variable
    gainComponents[componentIndex].gain.EventHandler = function(e)
      CheckGain(componentIndex, e.Position)
    end 
  end
end

--[[ Summary:
    Checks to see if the actively controlled mic gain's position.
    Only applies logic if the component is enabled.
    If at bottom, mute that channel, else unmute if position increased
]]
function CheckGain(instance, position)
  -- Only process if this component is enabled
  if not Controls["Enable" .. instance].Boolean then
    return  -- Skip processing for disabled components
  end
  
  local debugPrint = Properties["Debug Print"].Value
  
  if debugPrint == "Function Calls" or debugPrint == "All" then
    print(string.format("CheckGain called for component %i (%s): position = %.3f", 
          instance, Controls["ComponentName" .. instance].String, position))
  end
  
  -- Unmute if position increased above last known position
  if position > newGainPosition[instance] then 
    gainComponents[instance].mute.Boolean = false
    if debugPrint == "All" then
      print(string.format("Unmuting %s - position increased to %.3f", 
            Controls["ComponentName" .. instance].String, position))
    end
  end 
  
  -- Mute if at the bottom of the gain range
  if position == 0 then
    gainComponents[instance].mute.Boolean = true 
    if debugPrint == "All" then
      print(string.format("Muting %s - gain at minimum", 
            Controls["ComponentName" .. instance].String))
    end
  end 
  
  -- Update the tracked position
  newGainPosition[instance] = position
end
-- End Functions ---

--------------------
-- EventHandlers ---
--------------------

-- Refresh button handler
Controls["Refresh"].EventHandler = function()
  print("Refreshing component list...")
  ScanForComponents()
end

-- Enable/disable toggle handlers
for i = 1, maxComponents do
  local componentIndex = i  -- Capture loop variable
  Controls["Enable" .. componentIndex].EventHandler = function(ctl)
    local componentName = Controls["ComponentName" .. componentIndex].String
    if componentName ~= "" then
      if ctl.Boolean then
        print(string.format("Enabled auto-mute for: %s", componentName))
      else
        print(string.format("Disabled auto-mute for: %s", componentName))
      end
    end
  end
end

--End Eventhandlers-

-- Initialize --
print("GainMuteController starting...")
Controls["Status"].Value = 0  -- Initialize as disconnected/not ready

-- Initial scan for components
ScanForComponents()

print("GainMuteController initialized")
