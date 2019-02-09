TOOL.Name = "Resource Debugger"
TOOL.Tab = "Spacebuild"
TOOL.Category = "Debugging/Admin"

if (CLIENT) then
	language.Add("tool.rd3_resdebug.name", "Resource Debugger")
	language.Add("tool.rd3_resdebug.desc", "Spams an entity's resource table to the console.")
	language.Add("tool.rd3_resdebug.0", "Primary: Serverside | Secondary: Clientside")
end

function TOOL:LeftClick(trace)
	if (trace.Entity == nil) or (CLIENT) then return false end

	if (not self:GetOwner():IsAdmin()) then
		self:GetOwner():ChatPrint("This tool is admin only!")
		return false
	end

	CAF.GetAddon("Resource Distribution").PrintDebug(trace.Entity)

	return true
end

function TOOL:RightClick( trace )
	if (trace.Entity == nil) or (SERVER) then return false end

	if (not self:GetOwner():IsAdmin()) then
		self:GetOwner():ChatPrint("This tool is admin only!")
		return false
	end

	CAF.GetAddon("Resource Distribution").PrintDebug(trace.Entity)

	return true
end