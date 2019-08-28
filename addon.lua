local Regen = select(2, ...)

local addon = LibStub("AceAddon-3.0"):NewAddon("Regen", "AceConsole-3.0", "AceTimer-3.0", "AceHook-3.0", "AceEvent-3.0")



local L = Regen.L

-- local dewdrop = AceLibrary("Dewdrop-2.0")
-- local tablet = AceLibrary("Tablet-2.0")

-- addon = AceLibrary("AceAddon-2.0"):new("FuBarPlugin-2.0", "AceEvent-2.0", "AceConsole-2.0", "AceDB-2.0", "AceDebug-2.0", "CandyBar-2.0")


local LibQTip = LibStub('LibQTip-1.0')

local broker = {
	type = "data source",
	label = L.NAME,
	text = "",
	-- icon = "Interface\\Addons\\"..Prat.FolderLocation.."\\textures\\chat-bubble",
	-- OnClick = function(frame, button)
	-- 	Prat.ToggleOptionsWindow()
	-- end,
	OnEnter = function(frame) 
		local tooltip = LibQTip:Acquire("RegenTooltip", 2, "LEFT", "RIGHT")
		addon.tooltip = tooltip 

		local headerFont = CreateFont("RegenHeaderFont")
		headerFont:SetFont(GameTooltipText:GetFont(), 15)
		headerFont:SetTextColor(1,1,0)

		tooltip:SetHeaderFont(headerFont)

		addon:UpdateTooltip(tooltip)
		tooltip:SmartAnchorTo(frame)
		tooltip:Show()
	end,
	OnLeave = function(frame)
		LibQTip:Release(addon.tooltip)
		addon.tooltip = nil 
	end,
}

function addon:Debug(...)
	if addon.debug and Prat then
		Prat:PrintLiteral(...)
	end
end

function addon:SetDebugging(val) 
	addon.debug = val
end

function addon:Update()
	--- nop
	self:Debug(self.vars)

	self:OnDataUpdate()
	self:OnTextUpdate()
	if addon.tooltip then
		self:UpdateTooltip(self.tooltip)
	end
end

function addon:SetText(text)
	broker.text = text
end

function addon:StopCandyBar()
	--- nop
end
function addon:UnregisterCandyBar()
	--- nop
end
function addon:RegisterCandyBar()
	--- nop
end
function addon:SetCandyBarTexture()
	--- nop
end
function addon:SetCandyBarPoint()
	--- nop
end
function addon:SetCandyBarWidth()
	--- nop
end
function addon:IsCandyBarRegistered()
	return false
end

local addonFiveSec = {}

function addonFiveSec:ToggleActive()
	--- nop
end


 -- Get a reference to the lib
 local LibQTip = LibStub('LibQTip-1.0')
 
--  local function anchor_OnEnter(self)
   

   
--  end
 
--  local function anchor_OnLeave(self)
   
--    -- Release the tooltip
--    LibQTip:Release(self.tooltip)
--    self.tooltip = nil
   
--  end



local barTextures = { smooth = "Interface\\Addons\\FuBar_addon\\Textures\\smooth.tga" }
local barIcon = "Interface\\Addons\\FuBar_addon\\Textures\\5.tga"

addon.hasIcon = barIcon

addon.optionsTable = {
	type = 'group',
	args = {
		showHP = {
			order = 1,
			type = 'toggle',
			name = L["MENU_SHOW_HP"],
			desc = L["MENU_SHOW_HP"],
			set = "ToggleShowHP",
			get = "IsShowHP",
		},
		showMP = {
			order = 2,
			type = 'toggle',
			name = L["MENU_SHOW_MP"],
			desc = L["MENU_SHOW_MP"],
			set = "ToggleShowMP",
			get = "IsShowMP",
		},
		showFSRT = {
			order = 3,
			type = 'toggle',
			name = L["Show FSRT"],
			desc = L["Show FSRT"],
			set = "ToggleShowFSRT",
			get = "IsShowFSRT",
		},        
		fsrtGroup1 = {
			type = 'header',
			order = 10,
		},
		showPercent = {
			order = 11,
			type = 'toggle',
			name = L["MENU_SHOW_PERCENT"],
			desc = L["MENU_SHOW_PERCENT"],
			set = "ToggleShowPercent",
			get = "IsShowPercent",
		},
		showCurrent = {
			order = 12,
			type = 'toggle',
			name = L["MENU_SHOW_CURRENT"],
			desc = L["MENU_SHOW_CURRENT"],
			set = "ToggleShowCurrent",
			get = "IsShowCurrent",
		},
		showFightRegen = {
			order = 13,
			type = 'toggle',
			name = L["Show In Combat Regen Total"],
			desc = L["Show In Combat Regen Total"],
			set = "ToggleShowFightRegen",
			get = "IsShowFightRegen",
		},

		hideLabel = {
			order = 14,
			type = 'toggle',
			name = L["MENU_HIDE_LABEL"],
			desc = L["MENU_HIDE_LABEL"],
			set = "ToggleHideLabel",
			get = "IsHideLabel",
		},
		fsrtGroup2 = {
			type = 'header',
			order = 20,
			hidden = "IsHideFSRT",			
		},

		icr = {
		    type = 'range',
		    desc = L["Percent Regen While Casting"],
		    name = L["Percent Regen While Casting"],
			get  = "GetICR",
			set  = "SetICR",
		    min = 0,
		    max = 1, 
		    step = 0.05, 
		    isPercent = true,
   			order = 21,
			hidden = "IsHideFSRT",   			
		},

		mps = {
		    type = 'range',
		    desc = L["Mana Regen Forumula (Spirit/<value>)"],
		    name = L["Mana Regen Forumula (Spirit/<value>)"],
			get  = "GetMPS",
			set  = "SetMPS",
			min = 4,
		    max = 5, 
		    step = 0.5, 
			order = 22,
			hidden = "IsHideFSRT",
		},

		mpi = {
			type = "text",
			usage = "<number>",
			name = L["Mana Per Int"],
			desc = L["Mana Per Int"],
			get  = "GetMPI",
			set  = "SetMPI",
			validate = function(v)
        		return tonumber(v) ~= nil
    		end,
			order = 23,
			hidden = "IsHideFSRT",
		},

		fsrtGroup3 = {
			type = 'header',
			order = 30,
			hidden = "IsHideFSRT",			
		},
		
		
		showFSRB = {
			type = "toggle",
			name = L["FSR Countdown Bar"],
			desc = L["FSR Countdown Bar"],
			set = "ShowFSRBar",
			get = function() return addon.db.char.showFSRBar end,
			order = 31,
			hidden = "IsHideFSRT",
		},
		showOtherFSRB = {
			type = "toggle",
			name = L["FSR Movable Countdown Bar"],
			desc = L["FSR Movable Countdown Bar"],
			set = "SetShowOtherFSRBar",
			get = function() return addon.db.char.showOtherFSRBar end,
			order = 32,
			hidden = "IsHideFSRT",
		},		
		

		fsrtGroup4 = {
			type = 'header',
			order = 40,
			hidden = "IsHideFSRT",			
		},
		
		
		reset = {
			type = "execute",
			name = L["Reset FSR Data"],
			desc = L["Reset FSR Data"],
			func = "ResetFSRT",
			order = 41,
			hidden = "IsHideFSRT",
		},
	},	
}

addon.db = LibStub("AceDB-3.0"):New("RegenDB", {  
	profile = {
		showHP = true,
		showCurrent = false,
		showPercent = false, 
		showFightRegen = false, 
		hideLabel = false,
		-- debug = true
	},
	char = {
		mpi = 1.0/15,
		icr = 0,    
		showOtherFSRBar = false,
	},
	class = {
		mps = 0.0,
	} 
}, true)

	-- Methods
function addon:IsShowHP()
	return self.db.profile.showHP;
end
	
function addon:IsShowMP()
	return self.db.char.showMP;
end

function addon:IsShowFSRT()
	return self.db.char.showFSRT;
end
	
function addon:IsHideFSRT()
	return not self:IsShowFSRT()
end
	
function addon:IsShowCurrent()
	return self.db.profile.showCurrent;
end
	
function addon:IsShowPercent()
	return self.db.profile.showPercent;
end

function addon:IsShowFightRegen()
	return self.db.profile.showFightRegen;
end		
	
function addon:IsHideLabel()
	return self.db.profile.hideLabel;
end
	
function addon:ToggleShowHP()
	self.db.profile.showHP = not self.db.profile.showHP;
	self:UpdateSettings();
end
	
function addon:ToggleShowMP()
	self.db.char.showMP = not self.db.char.showMP;
	self:UpdateSettings();
end

function addon:ToggleShowFSRT()
	self.db.char.showFSRT = not self.db.char.showFSRT;
	self:UpdateSettings();
end

function addon:ToggleShowCurrent()
	self.db.profile.showCurrent = not self.db.profile.showCurrent;
	self:UpdateSettings();
end
		
function addon:ToggleShowPercent()
	self.db.profile.showPercent = not self.db.profile.showPercent;
	self:Update();
end
	
function addon:ToggleHideLabel()
	self.db.profile.hideLabel = not self.db.profile.hideLabel;
	self:Update();
end

function addon:ToggleShowFightRegen()
	self.db.profile.showFightRegen = not self.db.profile.showFightRegen;
	self:Update();
end


function addon:ResetFSRT()
	self.vars.combatDurationTotal = 0
	self.vars.timeInFSRTotal = 0
	self:Update()
end

function addon:ResetLastCombatStats()
	self.vars.combatDurationLast = 0
	self.vars.timeInFSRLast = 0
	
	self.vars.regenMPDuringCombat = 0;
	self.vars.regenHPDuringCombat = 0;
	self.vars.usedMPDuringCombat = 0;
	
	self:Update()	
end

function addon:GetCombatDuration()
	return self.vars.combatDurationLast
end

function addon:SetCombatDuration(dur)
	self.vars.combatDurationTotal = self.vars.combatDurationTotal + ( dur- self.vars.combatDurationLast)
	self.vars.combatDurationLast = dur
end

function addon:GetFSRDuration()
	return self.vars.timeInFSRLast
end

function addon:SetFSRDuration(dur)
	self.vars.timeInFSRTotal = self.vars.timeInFSRTotal + ( dur- self.vars.timeInFSRLast)
	self.vars.timeInFSRLast = dur
end

function addon:GetICR()
	return self.db.char.icr
end
function addon:SetICR(val)
	self.db.char.icr = val
	self:Update()
end

function addon:GetMPS()
	return 1.0 / self.db.class.mps
end
function addon:SetMPS(val)
	self.db.class.mps = 1.0 / val
	self:Update()
end


function addon:GetMPI()
	return 1.0 / self.db.char.mpi 
end
function addon:SetMPI(val)
	self.db.char.mpi = 1.0 / val
	self:Update()
end

function addon:SetShowOtherFSRBar(val)
	self.db.char.showOtherFSRBar = val

	addonFiveSec:ToggleActive(val)
end

function addon:ShowFSRBar(val)
	-- local n,l = L["FSR"], L["FSR"]
	-- local c = "blue"
	-- local a = 0.8
	-- local t = barTextures["smooth"]

	-- self.db.char.showFSRBar = val
	
	-- if (val) then
	-- 	self:RegisterCandyBar(n, 5, l, barIcon, c) 
	-- 	self:SetCandyBarTexture(n, t)
	-- 	-- bwf = self:GetFrame()
	-- 	self:SetCandyBarWidth(n, bwf:GetWidth()) 
	-- 	if bwf:GetBottom() > 0 then 
	-- 		self:SetCandyBarPoint(n, "TOPLEFT", bwf, "BOTTOMLEFT")
	-- 	else
	-- 		self:SetCandyBarPoint(n, "BOTTOMLEFT", bwf, "TOPLEFT")
	-- 	end
					
	-- else
	-- 	self:StopCandyBar(n)
	-- 	self:UnregisterCandyBar(n)
	-- end 	
end


addon.OnMenuRequest = addon.optionsTable


	
function addon:OnInitialize()
	self:SetDebugging(self.db.profile.debug)
	
	-- self:RegisterChatCommand( L["AceConsole-commands"], addon.optionsTable )
	


	self.vars = {
		currHealth = 0,
		currMana = 0,
		regenHP = 0,
		regenMP = 0,
		checkedManaState = 0,
		maxHPRate = 0,
		minHPRate = 9999,
		maxMPRate = 0,
		minMPRate = 9999,
		regenCombatTrack = 0,
		regenMPDuringCombat = 0,
		regenHPDuringCombat = 0,
        
        timeTillRegen = 0,
		usedMPDuringCombat = 0,
        combatDurationLast = 0,
        combatDurationTotal = 0,
        timeInFSRLast = 0,
        timeInFSRTotal = 0,
        lastUpdate = time(),
        secondEventID = 0;
	}
	
	self.data = {}

	LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("Regen", broker)
	self:Update()
end

function addon:OnEnable()
	self:RegisterEvent("UNIT_POWER_UPDATE");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("PLAYER_REGEN_DISABLED");
	self:RegisterEvent("PLAYER_REGEN_ENABLED");
	

	self:Setup()
	self:ShowFSRBar(self.db.char.showFSRBar)
	self:SetShowOtherFSRBar(self.db.char.showOtherFSRBar)
    self.vars.secondEventID = self:ScheduleRepeatingTimer("OnUpdateInternal", 0.5)
end

function addon:OnDisable()
	addonFiveSec:ToggleActive(false)
    self:CancelTimer(self.vars.secondEventID)
end    
    
		
function addon:PLAYER_ENTERING_WORLD()
	if self.vars.regenCombatTrack == 1 and not UnitAffectingCombat("player")  then
		self.vars.regenCombatTrack = 0
	end
	self:Update()
end
	
local function UnitManaMax(unit)
	return UnitPowerMax(unit, UnitPowerType("MANA"))
end

function addon:Setup()
	local _, class = UnitClass("player");
	self:Debug("Setup() - "..class)
	
	if self.db.char.showMP == nil then
		if UnitManaMax("player") == 0 then
			self.db.char.showMP = false
			self.db.char.showFSRT = false
			self.db.char.showFSRBar = false
		else 
			self.db.char.showMP = true
			self.db.char.showFSRT = true
			self.db.char.showFSRBar = false		
		end

		if 	( class == "PRIEST" ) or ( class == "DRUID" ) then
			self.db.char.showFSRT = true
			self.db.char.showFSRBar = true
		end					
	end
	    

	if self.db.class.mps == 0.0 then 
		if ( class == "PRIEST" ) or ( class == "MAGE" ) then
			self.db.class.mps = 0.25;
		else
			self.db.class.mps = 0.2;
		end    
	end    
end	
	
	
function addon:PLAYER_REGEN_DISABLED()
	self.vars.regenCombatTrack = 1;

    self:ResetLastCombatStats()
end

function addon:PLAYER_REGEN_ENABLED()
	self.vars.regenCombatTrack = 0;	
	self:Update()
end

function addon:UNIT_POWER_UPDATE(_, unit, type)
	self:Debug("UNIT_POWER_UPDATE - "..unit.." "..type)
	if type == "MANA" then 
		self:UNIT_MANA(unit)
	elseif type == "HEALTH" then
		self:UNIT_HEALTH(unit)
	end  
end

function addon:UNIT_HEALTH()
	if self:IsShowHP() then
		local currHealth = UnitHealth("player");
		if ( currHealth > self.vars.currHealth and self.vars.currHealth  ~= 0 ) then
			self.vars.regenHP  = currHealth - self.vars.currHealth ;
			
			if ( self.vars.regenCombatTrack == 1) then
				self.vars.regenHPDuringCombat = self.vars.regenHPDuringCombat + self.vars.regenHP;
			end 
			
			if (self.vars.regenHP > self.vars.maxHPRate) then 
				self.vars.maxHPRate = self.vars.regenHP ;
			end
			if (self.vars.regenHP < self.vars.minHPRate or self.vars.minHPRate == 9999) then 
				self.vars.minHPRate = self.vars.regenHP;
			end				
		end
		self.vars.currHealth = currHealth;
		self:Update();
	end
end

local function UnitMana(unit)
	return UnitPower(unit, UnitPowerType("MANA"))
end

function addon:UNIT_MANA(unit)
	self:Debug("UNIT_MANA - "..unit)
	if ( unit == "player" ) and ( UnitPowerType("player") == 0 ) then
		if self:IsShowMP() or self:IsShowFSRT() then
			local currMana = UnitMana("player");
			if ( currMana  > self.vars.currMana and self.vars.currMana ~= 0 ) then
				self.vars.regenMP  = currMana - self.vars.currMana  ;
	
				if ( self.vars.regenCombatTrack == 1) then
					self.vars.regenMPDuringCombat = self.vars.regenMPDuringCombat + self.vars.regenMP;
				end 
	
				if (self.vars.regenMP > self.vars.maxMPRate) then 
					self.vars.maxMPRate = self.vars.regenMP;
				end
				if (self.vars.regenMP < self.vars.minMPRate or self.vars.minMPRate == 9999) then 
					self.vars.minMPRate = self.vars.regenMP;
				end	 
			else
				self.vars.timeTillRegen = 5;
				if self:IsCandyBarRegistered(L["FSR"]) then
					local bwf = self:GetFrame()
					self:SetCandyBarWidth(L["FSR"], bwf:GetWidth()) 
					self:StartCandyBar(L["FSR"], false) 
				end
--			self.vars.regenMP = 0;
	
				if (self.vars.regenCombatTrack == 1) then
					self.vars.usedMPDuringCombat = self.vars.usedMPDuringCombat + currMana - self.vars.currMana;
				end
			end            
			
			self.vars.currMana = currMana;
			self:Update();
		end
	end
end

function addon:OnUpdateInternal()
	local tm = time()
	local elapsed = tm - self.vars.lastUpdate 
	self.vars.lastUpdate = tm
--	self.timeSinceUpdate = self.timeSinceUpdate + elapsed;

	local update = nil
	
	if self.vars.timeTillRegen > 0 then
		self.vars.timeTillRegen = self.vars.timeTillRegen - elapsed;
		update = true
	end

	if (UnitMana("player") < UnitManaMax("player")) and self.vars.regenCombatTrack == 1 then
		self:SetCombatDuration(self:GetCombatDuration() + elapsed)

		if self.vars.timeTillRegen > 0 then
			self:SetFSRDuration(self:GetFSRDuration() + elapsed)
		end
		
		update = true
	end

	if (update) then
	   self:Update()
	end
end


function addon:OnDataUpdate()
    self.data.regenHP = self.vars.regenHP
    self.data.regenMP = self.vars.regenMP
    self.data.regenHPCombat = self.vars.regenHPDuringCombat
    self.data.regenMPCombat = self.vars.regenMPDuringCombat
    
    self.data.maxHPRate = self.vars.maxHPRate
    self.data.minHPRate = self.vars.minHPRate
    self.data.maxMPRate = self.vars.maxMPRate
    self.data.minMPRate = self.vars.minMPRate
    
    self.data.usedMPCombat = self.vars.usedMPDuringCombat

    self.data.combatDurationTotal = self.vars.combatDurationTotal
    self.data.combatDurationLast = self.vars.combatDurationLast
    self.data.timeTillRegen = self.vars.timeTillRegen

    self.data.inCombat = self.vars.regenCombatTrack

    self.data.fsrpLast = self.vars.timeInFSRLast / (self.data.combatDurationLast + 0.001);
    self.data.fsrpTotal = self.vars.timeInFSRTotal / (self.data.combatDurationTotal + 0.001);

    self.data.playerHP = UnitHealth("player")
    self.data.playerMaxHP = UnitHealthMax("player")
    self.data.playerMP = UnitMana("player")
    self.data.playerMaxMP = UnitManaMax("player")

    self.data.regenMPPercent = (self.data.regenMP/self.data.playerMaxMP)*100
    self.data.regenHPPercent = (self.data.regenHP/self.data.playerMaxHP)*100
    self.data.regenHPPercentCombat = (self.data.regenHPCombat/self.data.playerMaxHP)*100
    self.data.regenMPPercentCombat  = (self.data.regenMPCombat/self.data.playerMaxMP)*100


	if self.data.minHPRate == 9999 then self.data.minHPRate = 0 end
	if self.data.minMPRate == 9999 then self.data.minMPRate = 0 end	

	if self.data.playerHP == self.data.playerMaxHP then
		self.data.regenHP = 0;
	end

	if self.data.playerMP == self.data.playerMaxMP then
		self.data.regenMP = 0;
	end	
end


function addon:OnTextUpdate()
	local labelTextHP = "";
	local valueTextHP = "";
	local labelTextMP = "";
	local valueTextMP = "";
    local labelTextFSRT = ""
    local valueTextFSRT = ""
	
    -- safety in case both are off, then cant ever turn em on
	if ( not self:IsShowHP() and not self:IsShowMP() ) then
		self:ToggleShowHP();
	end
	
	if ( self:IsShowHP() ) then
		if not self:IsHideLabel() then
			labelTextHP = L.HP_LABEL;
		end
		
		if self:IsShowPercent() then
			valueTextHP = string.format("%.2f%%", self.data.regenHPPercent);
		else
			valueTextHP = string.format("%d", self.data.regenHP);	
		end	

		if self:IsShowFightRegen() and self.data.inCombat == 1 then 
			valueTextHP = string.format("|cff00ff00%s|r / |cff00ff00%s|r", valueTextHP, self.data.regenHPCombat);
		else
			valueTextHP = string.format("|cff00ff00%s|r", valueTextHP);
		end

		if self:IsShowCurrent() then
			valueTextHP = string.format("|cff00ff00%s|r/|cff00ff00%s|r(%s)", 
                  self.data.playerHP, self.data.playerMaxHP, valueTextHP);
		end
		
	end
	
	if ( self:IsShowMP() ) then
		if not self:IsHideLabel() then
			labelTextMP = L.MP_LABEL;
		end
		
		if self:IsShowPercent() then
			valueTextMP = string.format("%.2f%%", self.data.regenMPPercent);
		else
			valueTextMP = string.format("%d", self.data.regenMP);	
		end
		
		if self:IsShowFightRegen() and self.data.inCombat == 1 then 
			valueTextMP = string.format("|cff3399ff%s|r / |cff3399ff%s|r", valueTextMP, self.data.regenMPCombat);
		else
			valueTextMP = string.format("|cff3399ff%s|r", valueTextMP);
		end
	
		if self:IsShowCurrent() then
			valueTextMP = string.format("|cff3399ff%s|r/|cff3399ff%s|r(%s)", 
               self.data.playerMP, self.data.playerMaxMP, valueTextMP)
		end

	end

   	if ( self:IsShowFSRT() ) then
   		if not self:IsHideLabel() then
			labelTextFSRT = L.FSR_LABEL
		end
			valueTextFSRT = string.format("%d%%", self.data.fsrpTotal*100)
    	end
	self:SetText(labelTextHP..valueTextHP.." "..labelTextMP..valueTextMP.." "..labelTextFSRT..valueTextFSRT);
	
	if self:IsCandyBarRegistered(L["FSR"]) then
		local bwf = self:GetFrame()
		self:SetCandyBarWidth(L["FSR"], bwf:GetWidth()) 
		self:Debug(bwf:GetBottom(), GetScreenHeight())
		if bwf:GetBottom() > 0 then 
			self:SetCandyBarPoint(L["FSR"], "TOPLEFT", bwf, "BOTTOMLEFT")
		else
			self:SetCandyBarPoint(L["FSR"], "BOTTOMLEFT", bwf, "TOPLEFT")
		end
	end	
end
	

function addon:UpdateTooltip(tooltip)
	tooltip:Clear()

	if self:IsShowHP() then
		tooltip:AddHeader(
			L.TOOLTIP1_LEFT, 
			string.format("%s |cffffffff/|r %s |cffffffff(|r|cffff0000%s|cffffffff)|r", 
               self.data.playerHP, self.data.playerMaxHP, self.data.playerMaxHP-self.data.playerHP )
		);

		tooltip:AddLine(
			L.TOOLTIP3_LEFT, 
			self.data.maxHPRate
		);
		tooltip:AddLine(
			L.TOOLTIP4_LEFT, 
			self.data.minHPRate
		);
		tooltip:AddLine(
			L.TOOLTIP8_LEFT, 
			string.format("%s (%.2f%%)", 
                self.data.regenHPCombat, self.data.regenHPPercentCombat )
		);			
	end
	
	if self:IsShowMP() then
		tooltip:AddHeader(
			L.TOOLTIP2_LEFT, 
			string.format("%s |cffffffff/|r %s |cffffffff(|r|cffff0000%s|cffffffff)|r", 
                 self.data.playerMP, self.data.playerMaxMP, self.data.playerMaxMP-self.data.playerMP)
		);
		
		tooltip:AddLine(
			L.TOOLTIP5_LEFT, 
			self.data.maxMPRate
		);
		tooltip:AddLine(
			L.TOOLTIP6_LEFT, 
			self.data.minMPRate
		);
		tooltip:AddLine(
			L.TOOLTIP7_LEFT, 
			string.format("%s (%.2f%%)", 
					self.data.regenMPCombat, self.data.regenMPPercentCombat)
		);
		tooltip:AddLine(
			L.TOOLTIP9_LEFT, 
			string.format("%s MP/5s", 
					self:GetCombatDuration() > 0 and math.floor((self.data.regenMPCombat/self:GetCombatDuration())*5) or 0)
		);
	end		
    
	if self:IsShowFSRT() then
--		usedMPDuringCombat = 0,
--        combatDuration = 0,
--        timeInFSR = 0,
        
        local fsrp = self.data.fsrpLast
        local str = string.format("%0.2f", 2/(5*self.db.class.mps*(1 - fsrp + self.db.char.icr*fsrp)));
        
        local combatTag
        local timeFormat
        
        if self.data.inCombat == 1 then 
        	combatTag = L["(This Fight)"]
        	timeFormat = string.format("|cff00ff00%s|r", self:FormatDurationString(self.data.combatDurationLast))
        else  
        	combatTag = L["(Last Fight)"]      
        	timeFormat = self:FormatDurationString(self.data.combatDurationLast)   	
        end
        
        tooltip:AddHeader(
            L["Time Spent In Regen"].." "..combatTag,
            timeFormat
        )
        
		tooltip:AddLine(
			L["% Of That Time In FSR"], 
			string.format("%0.1f%%", fsrp*100)
		)
		tooltip:AddLine(
			L["Spirit Needed To Equal 1mp5"], 
			str
		)
		tooltip:AddLine(
			L["Int Needed To Equal 1mp5"], 
			string.format("%0.2f", self.data.combatDurationLast/5*self.db.char.mpi)
		)

 		fsrp = self.data.fsrpTotal
        str = string.format("%0.2f", 2/(5*self.db.class.mps*(1 - fsrp + self.db.char.icr*fsrp)));
 		
        tooltip:AddHeader(
            L["Total Regen Time Observed"],
            self:FormatDurationString(self.data.combatDurationTotal)
        )
        tooltip:AddLine(
            L["% Of That Time In FSR"], 
            string.format("%0.1f%%", fsrp*100)
        )
        tooltip:AddLine(
            L["Spirit Needed To Equal 1mp5"], 
            str
        )
    end
    
    -- if addonFiveSec and addonFiveSec:IsActive() then 
	--     tablet:AddLine(L["|cffeda55fShift-Click|r to lock/unlock the movable 5-second bar"])    
	-- else
	--    -- tablet:SetHint("")    
	-- end	


end

function addon:FormatDurationString(duration)
	return string.format("%d:%04.1f" , floor(duration/60), floor(mod(duration*10, 600))/10)
end
	
	
function addon:UpdateSettings()
	-- safety in case both are off, then cant ever turn em on
	if ( not self:IsShowHP() and not self:IsShowMP() ) then
		self:ToggleShowHP();
	end
	self:Update();
end
function addon:OnProfileEnable(oldName, _, copyFrom)
	self:Debug("OnProfileEnable()")
	self:Setup()
	
	local function func()
		self:Update()
	end
	self:ScheduleEvent(func, 0.01)
end



function addon:OnClick()
	if IsShiftKeyDown() then 
		if addonFiveSec:IsActive() then
			addonFiveSec:toggleFSBLock(not addonFiveSec.db.profile.locked)
		end
	end
end