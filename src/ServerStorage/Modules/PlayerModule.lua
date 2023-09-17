local PlayerModule = {}

-- SERVICES
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

-- CONSTANTS
local PLAYER_DEFAULT_DATA = {
    hunger = 100;
    inventory = {};
    level = 1;
}

-- MEMBERS
local PlayersChached = {} -- Dictionary with all players in the game
local database = DataStoreService:GetDataStore("Survival")
local PlayerLoaded:BindableEvent = game.ServerStorage.BindableEvents.PlayerLoaded
local PlayerUnloaded:BindableEvent = game.ServerStorage.BindableEvents.PlayerUnloaded

--  Normalizes the hunger value
local function normalizerHunger(hunger:number):number
    if hunger < 0 then
        hunger = 0
    end

    if hunger > 100 then
        hunger = 100
    end

    return hunger
end

function PlayerModule.IsLoaded(player: Player): boolean
    local isLoaded = PlayersChached[player.UserId] and true or false
        return isLoaded
    end

--- Sets the hunger of given player
function PlayerModule.SetHunger(player: Player, hunger: number)
    hunger = normalizerHunger(hunger)
    PlayersChached[player.UserId].hunger = hunger
end

--- Gets the hunger of given player
function PlayerModule.GetHunger(player: Player): number
    local hunger = normalizerHunger(PlayersChached[player.UserId].hunger)
    return hunger
end

local function onPlayerAdded(player:Player)
    player.CharacterAdded:Connect(function(_)
        local data = database:GetAsync(player.UserId)
        if not data then
            data = PLAYER_DEFAULT_DATA
        end
        PlayersChached[player.UserId] = data

        -- Players is fully loaded
        PlayerLoaded:Fire(player)
    end)
end

local function onPlayerRemoving(player:Player)
    PlayerUnloaded:Fire(player)
    database:SetAsync(player.UserId, PlayersChached[player.UserId])
    PlayersChached[player.UserId] = nil
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

return PlayerModule