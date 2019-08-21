local net = net

--Variable Declarations
local CAF2 = {}
CAF = CAF2
local CAF3 = {}
CAF2.StartingUp = false
CAF2.HasInternet = false
CAF2.InternetEnabled = true --Change this to false if you crash when CAF2 loads clientside


surface.CreateFont( "GModCAFNotify", {font = "verdana", size = 15, weight = 600} ) 


--nederlands, english

local DEBUG = true
CAF3.DEBUG = DEBUG
local Addons = {}
CAF3.Addons = Addons

--Derma stuff
local MainInfoMenuData = nil
--local MainStatusMenuData = nil
--local TopFrame = nil
--local TopFrameHasText = false
--local TopLabel = nil
--End Derma stuff

local addonlevel = {}
CAF3.addonlevel = addonlevel
addonlevel[1] = {}
addonlevel[2] = {}
addonlevel[3] = {}
addonlevel[4] = {}
addonlevel[5] = {}

local hooks = {}
CAF3.hooks = hooks
hooks["think"] = {}
hooks["think2"] = {}
hooks["think3"] = {}
hooks["OnAddonDestruct"] = {}
hooks["OnAddonConstruct"] = {}
hooks["OnAddonExtraOptionChange"] = {}

local function ErrorOffStuff(String)
	Msg( "----------------------------------------------------------------------\n" )
	Msg("-----------Custom Addon Management Framework Error----------\n")
	Msg("----------------------------------------------------------------------\n")
	Msg(tostring(String).."\n")
end

CAF2.CAF3 = CAF3
include("caf/core/shared/sh_general_caf.lua")
CAF2.CAF3 = nil

-- Synchronize language with gmod interface
CAF2.SaveVar("CAF_LANGUAGE", GetConVar("gmod_language"):GetString())

local function OnAddonDestruct(name)
	if not name then return end
	if(CAF2.GetAddonStatus(name)) then
		local ok, err = pcall(Addons[name].__Destruct)
		if not ok then
			CAF2.WriteToDebugFile("CAF_Destruct", "Couldn't call destructor for "..name .. " error: " .. err .."\n")
			AddPopup(CAF.GetLangVar("Error unloading Addon")..": " .. CAF.GetLangVar(name), "top", CAF2.colors.red)
		else
			if err then
				AddPopup(CAF.GetLangVar("Addon")..": " .. CAF.GetLangVar(name) .. " "..CAF.GetLangVar("got disabled"),"top", CAF2.colors.green)
			else
				AddPopup(CAF.GetLangVar("An error occured when trying to disable Addon")..": " .. CAF.GetLangVar(name),"top", CAF2.colors.red)
			end
		end
	end
	if not CAF2.StartingUp then
		for k , v in pairs(hooks["OnAddonDestruct"]) do
			local ok, err = pcall(v, name)
			if not ok then
				CAF2.WriteToDebugFile("CAF_Hooks", "OnAddonDestruct Error " .. err .. "\n")
			end
		end
	end
end

local function OnAddonConstruct(name)
	if not name then return end
	if(not CAF2.GetAddonStatus(name)) then
		if Addons[name] then
			local test, err = pcall(Addons[name].__Construct)
			if not test then
				CAF2.WriteToDebugFile("CAF_Construct", "Couldn't call constructor for "..name .. " error: " .. err .."\n")
				AddPopup(CAF.GetLangVar("Error loading Addon")..": " .. CAF.GetLangVar(name), "top", CAF2.colors.red)
			else
				if not err then
					AddPopup(CAF.GetLangVar("An error occured when trying to enable Addon")..": " .. CAF.GetLangVar(name),"top", CAF2.colors.red)
				end
			end
		end
	end
	if not CAF2.StartingUp then
		for k , v in pairs(hooks["OnAddonConstruct"]) do
			local ok, err = pcall(v, name)
			if not ok then
				CAF2.WriteToDebugFile("CAF_Hooks", "OnAddonConstruct Error " .. err .. "\n")
			end
		end
	end
end

local function OnAddonExtraOptionChange(AddonName, OptionName, NewStatus)
	if not AddonName or not OptionName then return nil, CAF.GetLangVar("Missing Argument") end
	for k , v in pairs(hooks["OnAddonExtraOptionChange"]) do
		local ok, err = pcall(v, AddonName, OptionName, NewStatus)
		if not ok then
			CAF2.WriteToDebugFile("CAF_Hooks", "OnAddonExtraOptionChange Error " .. err .. "\n")
		end
	end
end

--Global function

function CAF2.WriteToDebugFile(filename, message)
	if not filename or not message then return nil , CAF.GetLangVar("Missing Argument") end
	if DEBUG then
		ErrorNoHalt("Filename: "..tostring(filename)..", Message: "..tostring(message).."\n")
	end
	local contents = file.Read("CAF_Debug/client/"..filename..".txt")
	contents = contents or "" 
	contents = contents .. message
	file.Write("CAF_Debug/client/"..filename..".txt", contents)
end

function CAF2.ClearDebugFile(filename)
	if not filename then return nil , CAF.GetLangVar("Missing Argument") end
	local contents = file.Read("CAF_Debug/client/"..filename..".txt")
	contents = contents or "" 
	file.Write("CAF_Debug/client/"..filename..".txt", "")
	return content
end

--Server-Client Synchronisation
function CAF2.ConstructAddon(len, client)
    local name = net.ReadString()
    OnAddonConstruct(name)
    --RunConsoleCommand("Main_CAF_Menu")
end
net.Receive("CAF_Addon_Construct", CAF2.ConstructAddon)

function CAF2.DestructAddon(len, client)
	local name = net.ReadString()
	OnAddonDestruct(name)
	--RunConsoleCommand("Main_CAF_Menu")
end
net.Receive("CAF_Addon_Destruct", CAF2.DestructAddon)

function CAF2.Start(len, client)
	CAF2.StartingUp = true
end
net.Receive("CAF_Start_true", CAF2.Start)

function CAF2.endStart(len, client)
	CAF2.StartingUp = false
end
net.Receive("CAF_Start_false", CAF2.endStart)

local displaypopups = {}
local popups = {}

--PopupSettings
local Font	= "GModCAFNotify"
--End popupsettings

local function DrawPopups()
	if GetConVarString('cl_hudversion') == "" then
		if displaypopups["top"] then
			local obj = displaypopups["top"]
			surface.SetFont( Font )
			local width, height = surface.GetTextSize(obj.message)
			if width == nil or height == nil then return end
			width = width + 16
			height = height + 16
			local left = (ScrW()/2)- (width/2)
			local top = 0
			draw.RoundedBox( 4, left-1 , top, width+2, height+2, obj.color)
			draw.RoundedBox( 4, left , top+1, width, height, Color(0, 0, 0, 150))
			draw.DrawText(obj.message,	Font, left + 8, top + 9, obj.color, 0 )
		end
		if displaypopups["left"] then
			local obj = displaypopups["left"]
			surface.SetFont( Font )
			local width, height = surface.GetTextSize(obj.message)
			if width == nil or height == nil then return end
			width = width + 16
			height = height + 16
			local left = 0
			local top = ScrH() * 2/3
			draw.RoundedBox( 4, left , top-1, width+2, height+2, obj.color)
			draw.RoundedBox( 4, left+1 , top, width, height, Color(0, 0, 0, 150))
			draw.DrawText(obj.message,	Font, left + 9, top + 8, obj.color, 0 )
		end
		if displaypopups["right"] then
			local obj = displaypopups["right"]
			surface.SetFont( Font )
			local width, height = surface.GetTextSize(obj.message)
			if width == nil or height == nil then return end
			width = width + 16
			height = height + 16
			local left = ScrW()- width
			local top = ScrH() * 2/3
			draw.RoundedBox( 4, left-1 , top-1, width + 2, height + 2, obj.color)
			draw.RoundedBox( 4, left , top, width, height, Color(0, 0, 0, 150))
			draw.DrawText(obj.message,	Font, left + 8, top + 8, obj.color, 0 )
		end
		if displaypopups["bottom"] then
			local obj = displaypopups["bottom"]
			surface.SetFont( Font )
			local width, height = surface.GetTextSize(obj.message)
			if width == nil or height == nil then return end
			width = width + 16
			height = height + 16
			local left = (ScrW()/2)- (width/2)
			local top = ScrH() - height
			draw.RoundedBox( 4, left-1 , top-2, width+2, height+2, obj.color)
			draw.RoundedBox( 4, left , top - 1, width, height, Color(0, 0, 0, 150))
			draw.DrawText(obj.message,	Font, left + 8, top + 7, obj.color, 0 )
		end
	end
end
hook.Add("HUDPaint", "CAF_Core_POPUPS", DrawPopups)

local function MessageOfTheDay()
	return "Welcome to CAF\nYou are using version "..CAF2.version
end

--local function ShowNextTopMessage()
local function ShowNextPopupMessage()
	local ply = LocalPlayer()
	local locations = {"top", "left", "right", "bottom"};	
	for k, v in pairs(locations) do
		if displaypopups[v] == nil and popups[v] and table.Count(popups[v]) > 0 then
			local obj = popups[v][1]
			table.remove(popups[v], 1)
			displaypopups[v] = obj
			timer.Simple(obj.time, function() ClearPopup(obj) end)
		end
	end
end

--function ClearTopTextMessage(obj)
function ClearPopup(obj)
	if obj then
		displaypopups[obj.location] = nil
	end
	if table.Count(popups[obj.location]) > 0 then
		ShowNextPopupMessage()
	end
end

local MessageLog = {}

--function AddTopInfoMessage(message)
function AddPopup(message, location, color, displaytime)
	local obj = {}
	local allowedlocations = {"top", "left", "right", "bottom"}
	location = location or "top"
	if not table.HasValue(allowedlocations, location) then
		location = "top"
	end
	obj.message = message or "Corrupt Message"
	obj.location = location or "top"
	obj.time = displaytime or 1
	obj.color = color or CAF2.colors.white
	if not popups[location] then
		popups[location] = {}
	end
	table.insert(popups[location], obj)
	table.insert(MessageLog, obj)
	ShowNextPopupMessage()
end

function CAF2.POPUP(msg, location, color, displaytime)
	if msg then
		AddPopup(msg, location, color, displaytime)
	end
end

local function ProccessMessage(len, client)
	local msg = net.ReadString()
	local location = net.ReadString()
	local r = net.ReadUInt( 8 )
	local g = net.ReadUInt( 8 )
	local b = net.ReadUInt( 8 )
	local a = net.ReadUInt( 8 )
	local displaytime = net.ReadUInt( 16 )
	local color = Color(r, g, b, a)
	CAF2.POPUP(msg, location, color, displaytime)
end
net.Receive("CAF_Addon_POPUP", ProccessMessage)

--CAF = CAF2

--Include clientside files

--Core

local Files = file.Find( "caf/core/client/*.lua" , "LUA")
for k, File in ipairs(Files) do
	Msg(CAF.GetLangVar("Loading") .. ": " .. File .. "...")
	local ErrorCheck, PCallError = pcall(include, "caf/core/client/"..File)
	if(not ErrorCheck) then
		ErrorOffStuff(PCallError)
	else
		Msg(" Done.\n")
	end
end

Files = file.Find("caf/languagevars/*.lua", "LUA")
for k, File in ipairs(Files) do
	Msg(CAF.GetLangVar("Loading") .. ": " .. File .. "...")
	local ErrorCheck, PCallError = pcall(include, "caf/languagevars/"..File)
	if(not ErrorCheck) then
		ErrorOffStuff(PCallError)
	else
		Msg(" Done.\n")
	end
end

--Addons
local Files = file.Find( "caf/addons/client/*.lua" , "LUA")
for k, File in ipairs(Files) do
	Msg(CAF.GetLangVar("Loading") .. ": " .. File .. "...")
	local ErrorCheck, PCallError = pcall(include, "caf/addons/client/"..File)
	if(not ErrorCheck) then
		ErrorOffStuff(PCallError)
	else
		Msg(" Done.\n")
	end
end
