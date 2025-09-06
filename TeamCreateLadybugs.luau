--[[

	Created by Opuqide.

]]

local RunService = game:GetService("RunService")
local CustomizationWindow = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float,false,false,630,420,0,0)
local PluginToolbar = plugin:CreateToolbar("Opuqide's Plugins")
local PluginButton = PluginToolbar:CreateButton("Customize Ladybug","Choose how your Ladybug looks!","rbxassetid://75239544032160")
local GuiWindow = plugin:CreateDockWidgetPluginGui("Team Create Ladybugs",CustomizationWindow)
local Gui = script.Resources.ChangeAppearanceGui.Content
local ImageToUse
local ColorToUse
local Bug = script.Resources.Ladybug

local PreivewImages = {
	{
		Name = "Red",
		Preview = "rbxassetid://136858460585883",
		Color = Color3.fromRGB(192,0,0)
	},
	{
		Name = "Orange",
		Preview = "rbxassetid://114326873915018",
		Color = Color3.fromRGB(255,150,0)
	},
	{
		Name = "Yellow",
		Preview = "rbxassetid://93056429479340",
		Color = Color3.fromRGB(255,255,0)
	},
	{
		Name = "Green",
		Preview = "rbxassetid://88718227488652",
		Color = Color3.fromRGB(0,150,0)
	},
	{
		Name = "Blue",
		Preview = "rbxassetid://140375402453480",
		Color = Color3.fromRGB(0,0,255)
	},
	{
		Name = "Purple",
		Preview = "rbxassetid://114072644083584",
		Color = Color3.fromRGB(192,0,255)
	},
	{
		Name = "Pink",
		Preview = "rbxassetid://77209480026734",
		Color = Color3.fromRGB(255,0,255)
	}
}

local ShellColors = {
	["Red"] = 98198286884722,
	["Orange"] = 74667870234001,
	["Yellow"] = 118909862616215,
	["Green"] = 87279046902131,
	["Blue"] = 97616816534400,
	["Purple"] = 120774678188723,
	["Pink"] = 103417535391283
}

RunService.PreRender:Connect(function()
	assert(plugin,"Plugin isn't available. Stop the game, and disable this script.")
	assert(Bug,"Ladybug model doesn't exist...")
	Bug.Parent = workspace.Terrain
	
	Bug.Archivable = false
	
	local name = game:GetService("Players"):GetNameFromUserIdAsync(game:GetService("StudioService"):GetUserId())
	
	Bug.Name = "Ladybug_"..name
	
	for _,obj in pairs(Bug:GetDescendants()) do
		if obj:IsA("BasePart") or obj:IsA("Decal") then
			obj.LocalTransparencyModifier = 1
		end
		
		if obj:IsA("BasePart") or obj:IsA("MeshPart") then
			obj.Archivable = false

			obj.Locked = true
			obj.CastShadow = false
			obj.CollisionGroup = "StudioUnselectable"

			if obj.Parent:IsA("Accessory") or obj:IsA("SurfaceAppearance") then
				continue
			end

			obj.CanCollide = false
			obj.CanQuery = false
			obj.CanTouch = false
			obj.Anchored = true
			obj.EnableFluidForces = false
		end
		
		if obj:IsA("LocalScript") or obj:IsA("Script") then
			obj:Destroy()
		end
	end
	
	Bug:PivotTo(workspace.CurrentCamera.CFrame)
end)

PluginButton.Click:Connect(function()
	GuiWindow.Enabled = not GuiWindow.Enabled
	Gui.Parent = GuiWindow
	
	for i,button in pairs(PreivewImages) do
		local ButtonClone = script.Resources.Elements.Color:Clone()
		ButtonClone.Parent = Gui.ColorChoice
		ButtonClone.ColorPreview.BackgroundColor3 = button.Color
		ButtonClone.ColorName.Text = button.Name
		
		ButtonClone.MouseButton1Click:Connect(function()
			ColorToUse = ButtonClone.ColorName.Text
			ImageToUse = ShellColors[ColorToUse]
			
			Gui.Preview.Image = button.Preview
		end)
	end
	
	Gui.DoneButton.MouseButton1Click:Connect(function()
		if ImageToUse == 0 or not ImageToUse then
			ImageToUse = ShellColors.Red
		end
		
		Bug.ShellL.SurfaceAppearance.ColorMapContent = Content.fromUri("rbxassetid://"..ImageToUse)
		Bug.ShellR.SurfaceAppearance.ColorMapContent = Content.fromUri("rbxassetid://"..ImageToUse)
	end)
end)

GuiWindow:BindToClose(function()
	for i,button in ipairs(Gui.ColorChoice:GetChildren()) do
		if button:IsA("TextButton") then
			button:Destroy()
		end
	end
	
	Gui.Preview.Image = ShellColors.Red
	
	Gui.Parent = script.Resources.ChangeAppearanceGui
end)
