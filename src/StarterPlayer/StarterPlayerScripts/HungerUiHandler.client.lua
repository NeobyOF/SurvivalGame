local PlayerHungerUpdated:RemoteEvent = game.ReplicatedStorage.Network.PlayerHungerUpdated

-- SERVICES
local Players = game:GetService("Players")

-- CONSTANTS
local BAR_FULL_COLOR = Color3.fromRGB(0, 255, 0)
local BAR_LOW_COLOR = Color3.fromRGB(255, 154, 1)
local BAR_SUPERLOW_COLOR_COLOR = Color3.fromRGB(255, 0, 1)

-- MEMBERS
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local hud:ScreenGui = PlayerGui:WaitForChild("Hud")
local leftbar:Frame = hud:WaitForChild("LeftBar")
local hungerUi:Frame = leftbar:WaitForChild("Hunger")
local HungerBar:Frame = hungerUi:WaitForChild("Bar")

PlayerHungerUpdated.OnClientEvent:Connect(function(hunger: number)
    -- Updates das hunger bar size
    HungerBar.Size = UDim2.fromScale(hunger/100, HungerBar.Size.Y.Scale)

    if HungerBar.Size.X.Scale > 0.75 then
        HungerBar.BackgroundColor3 = BAR_FULL_COLOR
    else
        HungerBar.BackgroundColor3 = BAR_LOW_COLOR
    end
end)