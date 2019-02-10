TOOL.Name = "Resource Node"
TOOL.Category = "Resource Distribution"

TOOL.DeviceName = "Resource Node"
TOOL.DeviceNamePlural = "Resource Nodes"
TOOL.ClassName	 = "resourcenodes"

TOOL.DevSelect = true
TOOL.CCVar_type = "resource_node"
TOOL.CCVar_sub_type = "small_node"
TOOL.CCVar_model = "models/SnakeSVx/small_res_node.mdl"

TOOL.Limited = true
TOOL.LimitName = "resourcenodes"
TOOL.Limit = 30

CAFToolSetup.SetupLanguage(TOOL.Name, "Resource nodes are a central point for your resources, all other devices connect back to these.", "Spawn a resource node", "View devices connected to the node", "Repair a resource node")

TOOL.ExtraCCVars = {
	auto_link = 0,
	custom = "My Resource Node",
}

function TOOL.ExtraCCVarsCP(tool, panel)
	panel:CheckBox("Auto Link", "resourcenodes_auto_link")
	panel:TextEntry("Custom Name", "resourcenodes_custom")
end

function TOOL:GetExtraCCVars()
	local extra_data = {}

	extra_data.auto_link = self:GetClientNumber("auto_link") == 1
	extra_data.custom_name = self:GetClientInfo("custom")

	return extra_data
end

local function autoLink(ent, range)
	if (ent ~= NULL) and (IsValid(ent)) then
		for k, v in pairs(ents.FindInSphere(ent:GetPos(), range)) do
			local enttable = CAF.GetAddon("Resource Distribution").GetEntityTable(v)

			if (IsValid(v)) and (table.Count(enttable) > 0) and (enttable.network == 0) then
				if (CPPI and CPPI.GetOwner and CPPI.GetOwner(ent) ~= CPPI.GetOwner(v)) or (ent.GetPlayerName and v.GetPlayerName and ent:GetPlayerName() == v:GetPlayerName()) then
					CAF.GetAddon("Resource Distribution").Link(v, ent.netid)
				end
			end
		end
	end
end

local function createResourceNode(ent, type, sub_type, devinfo, extra_data, ent_extras)
	print("Spawning resource node: " .. tostring(ent) .. ". (" .. tostring(type) .. ") (" .. tostring(sub_type) .. ")")

	-- Physics object
	local volume_mul = 1
	local base_volume = 2958
	local phys = ent:GetPhysicsObject()
	if phys:IsValid() and phys.GetVolume then
		local vol = phys:GetVolume()
		vol = math.Round(vol)
		volume_mul = vol/base_volume
	end

	-- Range calculation
	local range = 128
	if (type == "resource_node_256") then
		range = 256
	elseif (type == "resource_node_512") then
		range = 512
	elseif (type == "resource_node_1024") then
		range = 1024
	end
	ent:SetRange(range)

	-- Custom node name
	if (extra_data) and (extra_data.custom_name != "") then
		ent:SetCustomNodeName(extra_data.custom_name)
	end

	-- Auto link
	if (extra_data) and (extra_data.auto_link) then
		timer.Simple(0.1, function()
			autoLink(ent, range)
		end)
	end

	-- Mass and max health
	local base_mass = 20
	local base_health = 300
	local mass = math.Round(base_mass * volume_mul)
	local maxhealth = math.Round(base_health * volume_mul)

	return mass, maxhealth
end

local function viewNodeInfo(ent)
	local netid = ent:GetNWInt("netid")
	local nettable = CAF.GetAddon("Resource Distribution").GetNetTable(netid)
	local range = ent:GetNWInt("range")
	local nodename = ent:GetNWString("rd_node_name")
	local playername = ent:GetPlayerName()
	if (playername == "") then
		playername = "World"
	end

	--PrintTable(nettable)
	--[[
	cons:
	netid	=	15
	resources:
	]]

	local frame = vgui.Create("DFrame")
	frame:SetSize(400, 200)
	frame:SetTitle(nodename)
	frame:SetDraggable(true)
	frame:Center()
	frame:SetIcon("icon16/information.png")
	frame:MakePopup()

	local label = vgui.Create("DLabel", frame)
	label:Dock(FILL)
	label:SetText("Owner: " .. playername .. "\nRange: " .. range .. "\nNetwork ID: #" .. netid .. "\nResources: " .. table.ToString(nettable.resources,"Resources", true))
end

-- Not sure if this is the proper way todo it, since CAF has it's tool base and all (CAFTool.RightClick), but it works :/
function TOOL:RightClick(trace)
	if (trace == nil) or (trace.Entity == nil) or (not IsFirstTimePredicted()) then return false end

	--[[local enttable = CAF.GetAddon("Resource Distribution").GetEntityTable(trace.Entity)
	print(tostring(enttable))
	for k, v in pairs(enttable) do
		print(tostring(k) .. ": " .. tostring(v))
	end]]

	if (CLIENT) then
		viewNodeInfo(trace.Entity)
	end

	return true
end

TOOL.Devices = {
	-- Range: 128
	resource_node_128 = {
		Name = "Tiny (128)",
		type = "resource_node_128",
		class = "resource_node",
		func	 = createResourceNode,
		devices = {
			tiny_resource_node = {
				Name = "SnakeSVx - Resource Node",
				model = "models/snakesvx/node_s.mdl",
				hasScreen = false
			},
			s_small_node = {
				Name = "SnakeSVx - Box",
				model = "models/SnakeSVx/s_small_res_node_128.mdl",
				hasScreen = false
			},
			small_pipe_straight_128 = {
				Name = "SnakeSVx - Strait Pipe",
				model = "models/SnakeSVx/small_res_pipe_straight_128.mdl",
				hasScreen = true
			},
			small_pipe_curve1_128 = {
				Name = "SnakeSVx - L Pipe (Left, Up)",
				model = "models/SnakeSVx/small_res_pipe_curve1_128.mdl",
				hasScreen = true
			},
			small_pipe_curve2_128 = {
				Name = "SnakeSVx - L Pipe (Right, Up)",
				model = "models/SnakeSVx/small_res_pipe_curve2_128.mdl",
				hasScreen = true
			},
			small_pipe_curve3_128 = {
				Name = "SnakeSVx - L Pipe (Right, Down)",
				model = "models/SnakeSVx/small_res_pipe_curve3_128.mdl",
				hasScreen = true
			},
			small_pipe_curve4_128 = {
				Name = "SnakeSVx - L Pipe (Left, Down)",
				model = "models/SnakeSVx/small_res_pipe_curve4_128.mdl",
				hasScreen = true
			},
			small_pipe_T_128 = {
				Name = "SnakeSVx - T Pipe (Up)",
				model = "models/SnakeSVx/small_res_pipe_T_128.mdl",
				hasScreen = true
			},
			small_pipe_T2_128 = {
				Name = "SnakeSVx - T Pipe (Down)",
				model = "models/SnakeSVx/small_res_pipe_T2_128.mdl",
				hasScreen = true
			},
			CS_small_pipe_curve_1 = {
				Name = "Chipstiks - L Pipe (Left, Up)",
				model = "models/chipstiks_ls3_zodels/Pipes/small_res_pipe_curve1_128.mdl",
				hasScreen = true
			},
			CS_small_pipe_128 = {
				Name = "Chipstiks - Strait Pipe",
				model = "models/chipstiks_ls3_models/Pipes/small_res_pipe_straight_128.mdl",
				hasScreen = true
			},
			CS_small_pipe_curve_3 = {
				Name = "Chipstiks - L Pipe (Right, Down)",
				model = "models/chipstiks_ls3_models/Pipes/small_res_pipe_curve3_128.mdl",
				hasScreen = true
			},
			CS_small_pipe_curve_4 = {
				Name = "Chipstiks - L Pipe (Left, Down)",
				model = "models/chipstiks_ls3_models/Pipes/small_res_pipe_curve4_128.mdl",
				hasScreen = true
			}
		}
	},

	-- Range: 256
	resource_node_256 = {
		Name = "Small (256)",
		type = "resource_node_256",
		class = "resource_node",
		func	 = createResourceNode,
		devices = {
			small_resource_node = {
				Name = "SnakeSVx - Resource Node",
				model = "models/snakesvx/resource_node_small.mdl",
				hasScreen = false
			},
			s_small_node2 = {
				Name = "SnakeSVx",
				model = "models/SnakeSVx/s_small_res_node_256.mdl",
				hasScreen = false
			},
			small_pipe_straight_256 = {
				Name = "SnakeSVx - Strait Pipe",
				model = "models/SnakeSVx/small_res_pipe_straight_256.mdl",
				hasScreen = true
			},
			CS_small_pipe_256 = {
				Name = "Chipstiks - Strait Pipe",
				model = "models/chipstiks_ls3_models/Pipes/small_res_pipe_straight_256.mdl",
				hasScreen = true
			}
		}
	},

	-- Range: 512
	resource_node_512 = {
		Name = "Medium (512)",
		type = "resource_node_512",
		class = "resource_node",
		func	 = createResourceNode,
		devices = {
			medium_resource_node = {
				Name = "SnakeSVx - Resource Node",
				model = "models/snakesvx/resource_node_medium.mdl",	
				hasScreen = false
			},
			CS_small_pipe_512 = {
				Name = "Chipstiks - Strait Pipe",
				model = "models/chipstiks_ls3_models/Pipes/small_res_pipe_straight_512.mdl",
				hasScreen = true
			},
			small_node = {
				Name = "SnakeSVx",
				model = "models/SnakeSVx/small_res_node.mdl",
				hasScreen = true
			},
			small_pipe_straight_512 = {
				Name = "SnakeSVx - Strait Pipe",
				model = "models/SnakeSVx/small_res_pipe_straight_512.mdl",
				hasScreen = true
			}
		}
	},

	-- Range: 1024
	resource_node_1024 = {
		Name = "Large (1024)",
		type	= "resource_node_1024",
		class = "resource_node",
		func	 = createResourceNode,
		devices = {
			large_resource_node = {
				Name = "SnakeSVx - Resource Node",
				model = "models/snakesvx/resource_node_large.mdl",
				hasScreen = false	
			},
			medium_node = {
				Name = "SnakeSVx",
				model = "models/SnakeSVx/medium_res_node.mdl",
				hasScreen = true
			},
			small_pipe_straight_1024 = {
				Name = "SnakeSVx - Strait Pipe",
				model = "models/SnakeSVx/small_res_pipe_straight_1024.mdl",
				hasScreen = true
			},
			CS_small_pipe_1024 = {
				Name = "Chipstiks - Strait Pipe",
				model = "models/chipstiks_ls3_models/Pipes/small_res_pipe_straight_1024.mdl",
				hasScreen = true
			},
		}
	}

	-- Range: 2048
	--[[ 2048 range was sort of OP
	resource_node_2048 = {
		Name = "Huge (2048)",
		type	= "resource_node_2048",
		class = "resource_node",
		func	 = createResourceNode,
		devices = {
			large_node = {
				Name = "SnakeSVx",
				model = "models/SnakeSVx/large_res_node.mdl",
			}
		}
	}]]
}