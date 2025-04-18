Config = {}

-- Command to show the entire inventory
Config.ShowInventoryCommand = 'showinventory'

-- Alias command for showing inventory
Config.CommandAlias = 'showinv'

-- Command to show a single item from inventory
Config.ShowItemCommand = 'showitem'

-- Maximum number of item slots available for showing single items
Config.MaxItemSlots = 5

-- Distance within which nearby players can see the inventory or item
Config.ShowInventoryDistance = 10.0

-- Message to display if there are no items in the inventory
Config.NoItemsMessage = "You have no items to show."

-- Message to display if the specified slot is invalid
Config.InvalidSlotMessage = "Invalid slot number. Please use a number between 1 and " .. Config.MaxItemSlots .. "."

-- Message to display if the specified slot is empty
Config.EmptySlotMessage = "The selected slot is empty or invalid."

TriggerEvent('chat:addSuggestion', '/showinventory', 'Show a player your inventory.')
TriggerEvent('chat:addSuggestion', '/showinv', 'Show a player your inventory.')
TriggerEvent('chat:addSuggestion', '/showitem', 'Show a player a item in your inventory.', {{ name="slot", help="Choose a slot between 1 and " .. Config.MaxItemSlots .. "."}})

return Config
