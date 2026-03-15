--[[ Summary:
    Enhanced script that controls the mute status of selected mic gain blocks on a UCI. 
    If the gain is all the way down, the mute will trigger. When the knob moves above where it currently is, it will unmute. 
    If the gain block is muted and the knob moves lower, the mute will still stay muted.
  
    Enhanced Features:
    - Finds ALL gain components with script access (no name restrictions)
    - Individual enable/disable toggles for each gain component
    - Navigation through found components using Up/Down buttons
    - Static 12-slot display with paging system for unlimited components
    - Dynamic component discovery and display
  
    Requirements:
      - The gain block needs to have script access set to all or script
]]

--------------------
-- Components ------
--------------------
local AllComponents = {}
-- End Components --

--------------------
-- Variables -------
--------------------
local gainComponents = {}                 -- holds all the gain component references
local foundComponents = {}                -- holds metadata for all found components
local newGainPosition = {}               -- tracks last known position for each gain
local enabledStates = {}                 -- tracks enabled state for each component
local componentCount = 0                 -- number of found components
local currentPage = 1                    -- current display page (1-based)
local maxDisplaySlots = 12              -- fixed number of display slots
local componentsPerPage = 12            -- components shown per page
-- End Variables ---

--------------------
-- Functions -------
--------------------

--[[ Summary:
    Loops through all components and finds ALL gain blocks with script access.
    No longer filters by name - finds any gain component.
    Creates component references and stores metadata.
]]
function ScanForComponents()
  print("Scanning for all gain components with script access...")

  -- Clear existing data
  gainComponents = {}
  foundComponents = {}
  newGainPosition = {}
  enabledStates = {}
  componentCount = 0
  currentPage = 1

  -- Get all components with script access
  AllComponents = Component.GetComponents()

  -- Find ALL gain components (removed name restriction)
  for _, component in pairs(AllComponents) do
    for control, option in pairs(component) do
      if control == "Type" and option == "gain" then 
        componentCount = componentCount + 1
        print(string.format("Found gain component: %s", component.Name))
        
        -- Store component metadata
        foundComponents[componentCount] = {
          name = component.Name,
          componentRef = Component.New(component.Name)
        }
        
        -- Initialize tracking data
        newGainPosition[componentCount] = 1 -- set initial position to check against at its highest point
        enabledStates[componentCount] = true -- Default to enabled
        
        -- Store component reference for easy access
        gainComponents[componentCount] = foundComponents[componentCount].componentRef
      end 
    end 
  end

  print("Total gain components found: ", componentCount)

  -- Update component count display
  Controls["ComponentCount"].String = tostring(componentCount)

  -- Update the display
  UpdateDisplayPage()

  -- Set up event handlers for all found components
  SetupEventHandlers()

  -- Update status
  if componentCount > 0 then
    Controls["Status"].Value = 0  -- OK
  else
    Controls["Status"].Value = 3  -- Not Present (no gain components found)
  end
end

--[[ Summary:
    Updates the 12 display slots to show components from the current page
]]
function UpdateDisplayPage()
  local startIndex = (currentPage - 1) * componentsPerPage + 1
  local endIndex = math.min(startIndex + componentsPerPage - 1, componentCount)
  
  -- Clear all display slots first
  for i = 1, maxDisplaySlots do
    Controls["ComponentName" .. i].String = ""
    Controls["Enable" .. i].Boolean = false
    Controls["Enable" .. i].IsInvisible = true
  end
  
  -- Fill display slots with current page data
  local slotIndex = 1
  for componentIndex = startIndex, endIndex do
    if slotIndex <= maxDisplaySlots then
      Controls["ComponentName" .. slotIndex].String = foundComponents[componentIndex].name
      Controls["Enable" .. slotIndex].Boolean = enabledStates[componentIndex]
      Controls["Enable" .. slotIndex].IsInvisible = false
      slotIndex = slotIndex + 1
    end
  end
  
  -- Update page info
  local totalPages = math.ceil(componentCount / componentsPerPage)
  if componentCount > 0 then
    Controls["PageInfo"].String = string.format("Page %d of %d", currentPage, totalPages)
  else
    Controls["PageInfo"].String = "No components"
  end
  
  -- Update navigation button visibility
  Controls["PageUp"].IsInvisible = (currentPage <= 1)
  Controls["PageDown"].IsInvisible = (currentPage >= totalPages)
  
  print(string.format("Updated display: Page %d of %d, showing components %d-%d", 
        currentPage, totalPages, startIndex, math.min(endIndex, componentCount)))
end

--[[ Summary:
    Gets the actual component index from a display slot index
]]
function GetComponentIndexFromSlot(slotIndex)
  local startIndex = (currentPage - 1) * componentsPerPage + 1
  return startIndex + slotIndex - 1
end

--[[ Summary:
    Sets up EventHandlers for all found gain components
]]
function SetupEventHandlers()
  for i = 1, #gainComponents do
    local componentIndex = i  -- Capture loop variable
    if gainComponents[componentIndex] and gainComponents[componentIndex].gain then
      gainComponents[componentIndex].gain.EventHandler = function(e)
        CheckGain(componentIndex, e.Position)
      end 
    end
  end
end

--[[ Summary:
    Checks to see if the actively controlled mic gain's position.
    Only applies logic if the component is enabled.
    If at bottom, mute that channel, else unmute if position increased
]]
function CheckGain(componentIndex, position)
  -- Only process if this component is enabled
  if not enabledStates[componentIndex] then
    return  -- Skip processing for disabled components
  end

  local debugPrint = Properties["Debug Print"].Value

  if debugPrint == "Function Calls" or debugPrint == "All" then
    print(string.format("CheckGain called for component %i (%s): position = %.3f", 
          componentIndex, foundComponents[componentIndex].name, position))
  end

  -- Unmute if position increased above last known position
  if position > newGainPosition[componentIndex] then 
    gainComponents[componentIndex].mute.Boolean = false
    if debugPrint == "All" then
      print(string.format("Unmuting %s - position increased to %.3f", 
            foundComponents[componentIndex].name, position))
    end
  end 

  -- Mute if at the bottom of the gain range
  if position == 0 then
    gainComponents[componentIndex].mute.Boolean = true 
    if debugPrint == "All" then
      print(string.format("Muting %s - gain at minimum", 
            foundComponents[componentIndex].name))
    end
  end 

  -- Update the tracked position
  newGainPosition[componentIndex] = position
end

--[[ Summary:
    Navigates to the previous page of components
]]
function NavigateUp()
  if currentPage > 1 then
    currentPage = currentPage - 1
    UpdateDisplayPage()
    print("Navigated to page " .. currentPage)
  end
end

--[[ Summary:
    Navigates to the next page of components
]]
function NavigateDown()
  local totalPages = math.ceil(componentCount / componentsPerPage)
  if currentPage < totalPages then
    currentPage = currentPage + 1
    UpdateDisplayPage()
    print("Navigated to page " .. currentPage)
  end
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

-- Navigation button handlers
Controls["PageUp"].EventHandler = function()
  NavigateUp()
end

Controls["PageDown"].EventHandler = function()
  NavigateDown()
end

-- Enable/disable toggle handlers for the 12 display slots
for i = 1, maxDisplaySlots do
  local slotIndex = i  -- Capture loop variable
  Controls["Enable" .. slotIndex].EventHandler = function(ctl)
    local componentIndex = GetComponentIndexFromSlot(slotIndex)
    
    if componentIndex <= componentCount and foundComponents[componentIndex] then
      -- Update the stored enabled state
      enabledStates[componentIndex] = ctl.Boolean
      
      local componentName = foundComponents[componentIndex].name
      if ctl.Boolean then
        print(string.format("Enabled auto-mute for: %s (Component %d)", componentName, componentIndex))
      else
        print(string.format("Disabled auto-mute for: %s (Component %d)", componentName, componentIndex))
      end
    end
  end
end

--End Eventhandlers-

-- Initialize --
print("GainMuteController starting...")
Controls["Status"].Value = 5  -- Initializing

-- Hide navigation buttons initially
Controls["PageUp"].IsInvisible = true
Controls["PageDown"].IsInvisible = true

-- Initial scan for components
ScanForComponents()

print("GainMuteController initialized")
