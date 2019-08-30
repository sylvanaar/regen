Regen = select(2, ...)

local addon = LibStub("AceAddon-3.0"):NewAddon("FSRBar", "AceConsole-3.0", "AceTimer-3.0", "AceHook-3.0", "AceEvent-3.0")
local candybar = LibStub("LibCandyBar-3.0")

local L = Regen.L

Regen.FSRBar = addon

local regenBarName = "regenFiveSecBar"
local regenBarIcon = "Interface\\Addons\\Regen\\textures\\5.tga"
local regenBarTextures = { smooth = "Interface\\Addons\\Regen\\textures\\smooth.tga" }

local regenBarDefaultX = -1
local regenBarDefaultY = -1
local regenBarDefaultWidth = 150
local regenBarDefaultHeight = 16

local function UnitMana(unit)
	return UnitPower(unit, UnitPowerType("MANA"))
end

-----------------------------
-- OnInitialize / OnEnable --
-----------------------------

function addon:OnInitialize()	
    addon.db = LibStub("AceDB-3.0"):New("RegenFSRDB", {  
        profile = {
            locked = false,
            anchor = {
                x = regenBarDefaultX,
                y = regenBarDefaultY,
            },
            size = {
                width = regenBarDefaultWidth,
                height = regenBarDefaultHeight,
            }
        },
    }, true)

	self.options = {
		type = "group",
		args = {
			lock = {
				name = "Lock",
				desc = "Lock the FiveSec Bar",
				type = "toggle",
				get = function() return self.db.profile.locked end,
				set = "toggleFSBLock",
				map = {[false] = "Unlocked", [true] = "Locked"},
			},
			size = {
				name = "Size",
				desc = "Size of the FiveSec Bar",
				type = "group",
				args = {
					width = {
						name = "Width",
						desc = "Set the width of the FiveSec Bar",
						type = "text",
						usage = "<number>",
						get = function() return self.db.profile.size.width end,
						set = "setFSBWidth",
						validate = "numberValidation",
					},
					heigth = {
						name = "Height",
						desc = "Set the height of the FiveSec Bar",
						type = "text",
						usage = "<number>",
						get = function() return self.db.profile.size.height end,
						set = "setFSBHeight",
						validate = "numberValidation",
					},
				},
			},
			reset = {
				name = "Reset",
				desc = "Resets the FiveSec Bar back to the middle of the screen.",
				type = "execute",
				func = "resetFSB",
			}
		}
	}
	
	--self:RegisterChatCommand({ "/nfs", "/nfivesec", "/regenFiveSec", "/fs", "/fivesec" }, self.options )
end

local function barstopped( callback, bar )
	if addon.bar == bar then
		addon:Debug("Destroying FSRBar")
		addon.bar = nil
	end
end
  
candybar.RegisterCallback(addon, "LibCandyBar_Stop", barstopped)

function addon:OnEnable()
    self:CreateAnchorFrame()
    
	self.AnchorFrame:Show()
	self:LoadAnchorPosition()
	self:SetAnchorStyle(self.db.profile.locked)
	
	self:RegisterEvent("UNIT_POWER_UPDATE")
    
--@debug@ 
    self:SetDebugging(true)
--@end-debug@    
    self:Debug("OnEnable.Processed")
    
    self.currMana = UnitMana("player")
end


function addon:OnDisable()
	self.AnchorFrame:Hide()
end


----------------------
-- Option Functions --
----------------------

function addon:toggleFSBLock(v)
	self.db.profile.locked = v
	self:SetAnchorStyle(v)
end


function addon:setFSBWidth(v)
	self.db.profile.size.width = tonumber(v)
	self:UpdateSize()
end


function addon:setFSBHeight(v)
	self.db.profile.size.height = tonumber(v)
	self:UpdateSize()
end


function addon:resetFSB()
	self.db.profile.anchor.x = regenBarDefaultX
	self.db.profile.anchor.y = regenBarDefaultY 
	self.db.profile.size.width = regenBarDefaultWidth
	self.db.profile.size.height = regenBarDefaultHeight
	
	self:LoadAnchorPosition()
	self:UpdateSize()
end


function addon:numberValidation(v)
	return tonumber(v) ~= nil
end


-----------------------
-- General Functions --
-----------------------

function addon:UpdateSize()
	self.AnchorFrame:SetWidth(self.db.profile.size.width + self.db.profile.size.height)
	self.AnchorFrame:SetHeight(self.db.profile.size.height)

	self:Debug("UpdateSize.Processed")
end


function addon:Debug(...)
	if addon.debug and Prat then
		Prat:PrintLiteral("FSRBar: ", ...)
	end
end

function addon:SetDebugging(val) 
	addon.debug = val
end


function addon:ToggleLock()
	self.db.profile.locked = not self.db.profile.locked
	self:SetAnchorStyle(self.db.profile.locked)
end


----------------------------
-- Anchor Frame Functions --
----------------------------

function addon:CreateAnchorFrame()
	if regenFiveSecAnchor then 
		self.AnchorFrame = regenFiveSecAnchor
		return
	end
	
	self.AnchorFrame = CreateFrame("Frame","RegenFiveSecAnchor",UIParent)
	self.AnchorFrame:SetWidth(self.db.profile.size.width + self.db.profile.size.height)
	self.AnchorFrame:SetHeight(self.db.profile.size.height)
	self.AnchorFrame:SetFrameStrata("BACKGROUND")
	self.AnchorFrame:SetClampedToScreen(true)
	
	self.AnchorFrame:SetScript("OnMouseDown",	function(this) 
													if not self.db.profile.locked then 
														this:StartMoving() 
													end 
												end )

	self.AnchorFrame:SetScript("OnMouseUp",	function(this)
												this:StopMovingOrSizing()
												if not self.db.profile.locked then
													self:SaveAnchorPosition(this)
												end
											end )
											
	local gameFont, _, _ = GameFontHighlightSmall:GetFont()										
	self.AnchorFrame.Range = self.AnchorFrame:CreateFontString("AnchorBarName", "OVERLAY")
	self.AnchorFrame.Range:SetJustifyH("CENTER")
	self.AnchorFrame.Range:SetFont(gameFont, 12)
	self.AnchorFrame.Range:SetTextColor(1, 1, 1)
	self.AnchorFrame.Range:SetText("FiveSec Bar")
	self.AnchorFrame.Range:ClearAllPoints()
	self.AnchorFrame.Range:SetPoint("BOTTOM", self.AnchorFrame, "TOP", 0, 2)
							

end


function addon:SaveAnchorPosition(this)
	self.db.profile.anchor.x = floor(this:GetLeft() * self.AnchorFrame:GetEffectiveScale() + .5)
	self.db.profile.anchor.y = floor(this:GetTop() * self.AnchorFrame:GetEffectiveScale() + .5)
	
	self:Debug("SaveAnchorPosition: x=", self.db.profile.anchor.x, ", y=", self.db.profile.anchor.y)
end


function addon:LoadAnchorPosition()
	self.AnchorFrame:ClearAllPoints()
	if self.db.profile.anchor.x > -1 then
		local s = self.AnchorFrame:GetEffectiveScale()
		self.AnchorFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", floor(self.db.profile.anchor.x/s + .5), floor(self.db.profile.anchor.y/s + .5))
	else
		self.AnchorFrame:SetPoint("CENTER", UIParent, "CENTER")
	end
	
	self:Debug(
		"LoadAnchorPosition: x=", floor(self.db.profile.anchor.x/self.AnchorFrame:GetEffectiveScale() + .5),
		", y=", floor(self.db.profile.anchor.y/self.AnchorFrame:GetEffectiveScale() + .5),
		", width=", (self.db.profile.size.width),
		", height=", (self.db.profile.size.height)
	)
end


function addon:SetAnchorStyle(locked)
	if locked then
		self.AnchorFrame:EnableMouse(false)
		self.AnchorFrame:SetMovable(false)
		
		self.AnchorFrame:SetBackdrop(nil)
		self.AnchorFrame:SetBackdropBorderColor(nil)
		self.AnchorFrame:SetBackdropColor(nil)
		
		self.AnchorFrame.Range:Hide()
	else
		self.AnchorFrame:EnableMouse(true)
		self.AnchorFrame:SetMovable(true)
		
		self.AnchorFrame:SetBackdrop({
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 8,
		})
		self.AnchorFrame:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b)
		self.AnchorFrame:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b)
		
		self.AnchorFrame.Range:Show()
	end
end


---------------------------
-- FiveSec Bar Functions --
---------------------------



function addon:StartFSRBar()
	if self.bar then self.bar:Stop() end

	self.bar = candybar:New(regenBarTextures["smooth"], self.db.profile.size.width, self.db.profile.size.height)
	self.bar:SetColor(0,0,1)
	self.bar:SetDuration(5)
	self.bar:SetPoint("CENTER", self.AnchorFrame, "CENTER")

	self.bar:Start()

	self:Debug("Started FSRBar")
end

function addon:UNIT_POWER_UPDATE(_, unit, type)
	-- self:Debug("UNIT_POWER_UPDATE - "..unit.." "..type)
	if type == "MANA" then 
		self:UNIT_MANA(unit)
	end  
end

function addon:UNIT_MANA(unit)
	if ( unit == "player" ) and ( UnitPowerType("player") == 0 ) then
		local currMana = UnitMana("player")
		if ( currMana < self.currMana) then
            self:StartFSRBar()
		end
		self.currMana = currMana
	end
end
