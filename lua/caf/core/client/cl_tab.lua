--
--	Custom Addon Framework Tab Module and Tool Helper
--

include("caf/core/shared/caf_tools.lua")

hook.Add("AddToolMenuTabs", "CAFTab",  function()
    spawnmenu.AddToolTab("Custom Addon Framework", "Spacebuild")
end)

function CAF_BuildCPanel(cp, toolname, listname, custom)
    cp:AddControl("CheckBox", { Label = "Don't Weld", Command = toolname .. "_DontWeld" })
    cp:AddControl("CheckBox", { Label = "Allow welding to world", Command = toolname .. "_AllowWorldWeld" })
    cp:AddControl("CheckBox", { Label = "Make Frozen", Command = toolname .. "_Frozen" })
    local ListControl = vgui.Create("CAFControl")
    cp:AddPanel(ListControl)
    ListControl:SetList(toolname, listname)
end