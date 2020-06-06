--[[
	Dont Fall Module
	Created by PlayAsync
--]]

-- Services
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")

-- Player
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character.HumanoidRootPart
local Humanoid = Character.Humanoid

-- Other Variables
local ActivationTime = 0.8
local InstantTeleport = false
local Enabled 
local LastTick
local PreviousCFrames = {}
local Info = TweenInfo.new(
	0.8, 
	Enum.EasingStyle.Sine, 
	Enum.EasingDirection.Out, 
	0, 
	false, 
	0 
)

local function start()
	while Enabled do
		wait(0.05)
		local HumanoidState = Humanoid:GetState()
		if HumanoidState == Enum.HumanoidStateType.Freefall then
			if not LastTick then
				LastTick = tick()
			elseif LastTick then
				local NewTick = tick()
				if NewTick - LastTick > ActivationTime and HumanoidRootPart.CFrame.Position.Y < 0 and HumanoidState == Enum.HumanoidStateType.Freefall then
					for i = #PreviousCFrames,1,-1 do
						HumanoidRootPart.Anchored = true
						if not InstantTeleport then
							local RestorePosition = TweenService:Create(HumanoidRootPart, Info, {CFrame = PreviousCFrames[i]})
							RestorePosition:Play()
							RestorePosition.Completed:Wait()
						else
							HumanoidRootPart.CFrame = PreviousCFrames[i]
						end
						HumanoidRootPart.Anchored = false
						local NewState = Humanoid:GetState()
						if NewState ~= Enum.HumanoidStateType.Freefall then
							break
						end
					end
				end
			end
		elseif HumanoidState == Enum.HumanoidStateType.RunningNoPhysics or HumanoidState == Enum.HumanoidStateType.Landed or HumanoidState == Enum.HumanoidStateType.Running then
			LastTick = nil
			if #PreviousCFrames > 1000 then
				PreviousCFrames = {}
			end
			PreviousCFrames[#PreviousCFrames+1] = HumanoidRootPart.CFrame
		elseif HumanoidState == Enum.HumanoidStateType.Jumping then
			LastTick = nil
		end
	end
end

local antifall = {}
	function antifall.Enable()
		Enabled = true
		spawn(start)
	end
	
	function antifall.Disable()
		Enabled = false
	end
	
	function antifall.InstantTeleport(value)
		InstantTeleport = value
	end
	
	function antifall.EditActivationTime(value)
		ActivationTime = value
	end
	
	function antifall.EditTweenTime(value)
		Info = TweenInfo.new(
			value, 
			Enum.EasingStyle.Sine, 
			Enum.EasingDirection.Out, 
			0, 
			false, 
			0)
	end
return antifall
