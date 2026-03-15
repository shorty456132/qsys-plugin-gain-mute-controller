# Gain and Mute Controller

**Author:** Andrew Laiacano
**Version:** 1.0.0
**Platform:** QSC Q-SYS Designer

## Overview

The Gain and Mute Controller is a Q-SYS plugin that automatically manages the mute state of gain blocks based on their knob position. When a gain block's level is turned all the way down (position = 0), the plugin mutes that channel. When the gain is raised above its previous position, the channel is unmuted automatically.

This is useful for scenarios where a physical or UCI-based gain knob doubles as a mute control — pulling it to the floor mutes the channel, and raising it restores audio without requiring a separate mute button.

**Mute logic summary:**
- Gain at minimum (position = 0) → channel is **muted**
- Gain raised above last known position → channel is **unmuted**
- Gain lowered (but not to 0) while muted → channel **stays muted**

## Requirements

- Gain blocks must have **Script Access** set to `All` or `Script` in Q-SYS Designer.
- The plugin discovers all gain-type components available via script access at scan time.

## Setup

1. Drag the plugin into your Q-SYS design.
2. Configure the **Max Components** property to match the maximum number of gain blocks you expect to control (default: 16, max: 64).
3. Run the design. On the **Control** page, click **Refresh** to scan for gain components.
4. Use the **Enable** toggles to activate auto-mute behavior for each discovered component.

## Properties

| Property | Type | Default | Description |
|---|---|---|---|
| **Max Components** | Integer | 16 | Maximum number of gain components the plugin can track (1–64). |
| **Debug Print** | Enum | None | Controls script debug output. Options: `None`, `Tx/Rx`, `Tx`, `Rx`, `Function Calls`, `All`. |

## Controls

### Status Bar

| Control | Type | Pin | Description |
|---|---|---|---|
| **Refresh** | Button (Trigger) | Input | Rescans the design for gain components and rebuilds the component list. All found components are enabled by default. |
| **Status** | Indicator (LED) | Output | Shows the plugin's operational status. Green = one or more gain components found; Off/Red = no components found. |
| **Component Count** | Text | Output | Displays the number of gain components discovered during the last scan. |

### Gain Components (per slot, repeated up to Max Components)

| Control | Type | Pin | Description |
|---|---|---|---|
| **Enable N** | Button (Toggle) | Input/Output | Enables or disables the auto-mute logic for component slot N. When disabled, the gain block is monitored but no mute/unmute actions are taken. Enabled by default after a scan. |
| **Component Name N** | Text | Output | Displays the Q-SYS component name of the gain block assigned to slot N. Empty if no component occupies that slot. |

## Plugin Pages

- **Control** — Main runtime view showing the status bar, refresh button, and the full list of discovered gain components with their enable toggles and names.
- **Instructions** — A brief in-Designer reference covering setup steps.

## Notes

- Clicking **Refresh** clears the current component list and rescans. Any previously set enable states will be reset (all newly found components default to enabled).
- Only gain-type components with script access are discovered. Gain blocks without script access will not appear.
- The plugin uses no embedded components or external pins; it operates entirely through Q-SYS script-level component access.
