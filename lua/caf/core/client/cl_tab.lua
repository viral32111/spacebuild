-- Custom Addon Framework Tab Module and Tool Helper

include("caf/core/shared/caf_tools.lua")

 -- Who decided it was a good idea to add a convar to toggle the entire spawnmenu tab on or off?

hook.Add("AddToolMenuTabs", "CAFTab", function()
	spawnmenu.AddToolTab("Spacebuild", "Spacebuild", "materials/icon16/spacebuild.png")
end)

function CAF_BuildCPanel(cp, toolname, listname, custom)
	cp:AddControl("CheckBox", {Label = "Don't Weld", Command = toolname .. "_DontWeld"})
	cp:AddControl("CheckBox", {Label = "Weld to World", Command = toolname .. "_AllowWorldWeld"})
	cp:AddControl("CheckBox", {Label = "Spawn Frozen", Command = toolname .. "_Frozen"})
	
	local ListControl = vgui.Create("CAFControl")
	cp:AddPanel(ListControl)
	ListControl:SetList(toolname, listname)
end

