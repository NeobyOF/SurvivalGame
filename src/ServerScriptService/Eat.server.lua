-- SERVICES
local ProximityPromptService = game:GetService("ProximityPromptService")

-- CONSTANTS
local PROXIMITY_ACTION = "Eat"
local EATING_SOUND_ID = "rbxassetid://5546592140"

-- MEMBERS
local PlayerModule = require(game.ServerStorage.Modules.PlayerModule)
local PlayerHungerUpdated:RemoteEvent = game.ReplicatedStorage.Network.PlayerHungerUpdated

local function playEatingSound()
    local eatingSound = Instance.new("Sound")
    eatingSound.SoundId = EATING_SOUND_ID
    local random = Random.new()
    local Value = random:NextNumber(0.5, 1)

    eatingSound.Pitch = Value
    eatingSound.Parent = workspace
    eatingSound:Play()
end

-- Dectect when prompt is triggered
local function onPromptTriggered(promptObject:ProximityPrompt, player)
    -- Check if prompt triggered is an Eat action
    if promptObject.Name ~= PROXIMITY_ACTION then
        return
    end

    playEatingSound()

    local foodModel = promptObject.Parent
    local foodValue = foodModel.Food.Value

    local currentHunger = PlayerModule.GetHunger(player)
    PlayerModule.SetHunger(player, currentHunger + foodValue)
    PlayerHungerUpdated:FireClient(player, PlayerModule.GetHunger(player))

    foodModel:Destroy()
end

ProximityPromptService.PromptTriggered:Connect(onPromptTriggered)