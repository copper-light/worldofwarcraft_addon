local L_HELP1 = "|cffffff00HDH - UnitFrame 도움말";
local L_HELP2 = "|cffffff00유닛 프레임(플레이어, 타겟)에 오른 클릭 시 나타나는 팝업 메뉴의 |cffffffff\"체력바 직업 색상\"|cffffff00을 통해 색상 설정 가능합니다.";
local L_SET_HEALTH_COLOR_CLASS = "직업에 따른 체력바 색상";
local L_SET_HEALTH_COLOR_TYPE = "유형에 따른 체력바 색상";
local L_SET_MOVE_PARTY = "위치 이동";

local HDH_UnitPopupButtons = {};
local HDH_MENU_VALUE_COLOR_OF_CLASS = 1;
local HDH_MENU_VALUE_COLOR_OF_TYPE = 2;
-- local HDH_MENU_VALUE_COLOR_OF_CLASS_FOR_PARTY = 3;
local HDH_MENU_VALUE_MOVE_PARTY = 3;
HDH_UnitPopupButtons[HDH_MENU_VALUE_COLOR_OF_CLASS] = { text = L_SET_HEALTH_COLOR_CLASS, dist = 0, isNotRadio  = 1, checkable = 1 };
HDH_UnitPopupButtons[HDH_MENU_VALUE_COLOR_OF_TYPE] = { text = L_SET_HEALTH_COLOR_TYPE, dist = 0, isNotRadio  = 1, checkable = 1 };
HDH_UnitPopupButtons[HDH_MENU_VALUE_MOVE_PARTY] = { text = L_SET_MOVE_PARTY, dist = 0, isNotRadio  = 1, checkable = 1 };

local f = CreateFrame("Frame",nil,UIParent);

DB_UF = {}
Frame = { player = {}, focus= {}, target = {}}
Frame.player = PlayerFrame
Frame.player.healthBar = PlayerFrameHealthBar
Frame.player.manaBar = PlayerFrameManaBar
Frame.player.bg = PlayerFrameBackground
Frame.player.border = PlayerFrameTexture
Frame.player.hpTextLeft = PlayerFrameHealthBarTextLeft
Frame.player.hpText = PlayerFrameHealthBarText
Frame.player.hpTextRight = PlayerFrameHealthBarTextRight
Frame.player.mpTextLeft = PlayerFrameManaBarTextLeft
Frame.player.mpText = PlayerFrameManaBarText
Frame.player.mpTextRight = PlayerFrameManaBarTextRight
--Frame.player.deadText = PlayerFrameDeadText;

Frame.focus = FocusFrame	
Frame.focus.healthBar = FocusFrameHealthBar
Frame.focus.manaBar = FocusFrameManaBar
Frame.focus.bg = FocusFrameBackground
Frame.focus.border = FocusFrame.borderTexture
Frame.focus.name= FocusFrameTextureFrameName
Frame.focus.hpTextLeft = FocusFrameTextureFrameHealthBarTextLeft
Frame.focus.hpText = FocusFrameTextureFrameHealthBarText
Frame.focus.hpTextRight = FocusFrameTextureFrameHealthBarTextRight
Frame.focus.mpTextLeft = FocusFrameTextureFrameManaBarTextLeft
Frame.focus.mpText = FocusFrameTextureFrameManaBarText
Frame.focus.mpTextRight = FocusFrameTextureFrameManaBarTextRight
Frame.focus.Threat = FocusFrameNumericalThreat;
Frame.focus.deadText = FocusFrameTextureFrameDeadText;
Frame.focus.unconsciousText = FocusFrameTextureFrameUnconsciousText;	
	
Frame.target = TargetFrame	
Frame.target.healthBar = TargetFrameHealthBar
Frame.target.manaBar = TargetFrameManaBar
Frame.target.bg = TargetFrameBackground
Frame.target.border = TargetFrame.borderTexture
Frame.target.name = TargetFrameTextureFrameName
Frame.target.hpTextLeft = TargetFrameTextureFrameHealthBarTextLeft
Frame.target.hpText = TargetFrameTextureFrameHealthBarText
Frame.target.hpTextRight = TargetFrameTextureFrameHealthBarTextRight
Frame.target.mpTextLeft = TargetFrameTextureFrameManaBarTextLeft
Frame.target.mpText = TargetFrameTextureFrameManaBarText
Frame.target.mpTextRight = TargetFrameTextureFrameManaBarTextRight
Frame.target.Threat = TargetFrameNumericalThreat;
Frame.target.deadText = TargetFrameTextureFrameDeadText;
Frame.target.unconsciousText = TargetFrameTextureFrameUnconsciousText;

Frame.pet = PetFrame;
Frame.pet.healthBar = PetFrameHealthBar;
Frame.pet.manaBar = PetFrameManaBar;
Frame.pet.hpTextLeft = PetFrameHealthBarTextLeft
Frame.pet.hpText = PetFrameHealthBarText
Frame.pet.hpTextRight = PetFrameHealthBarTextRight
Frame.pet.mpTextLeft = PetFrameManaBarTextLeft
Frame.pet.mpText = PetFrameManaBarText
Frame.pet.mpTextRight = PetFrameManaBarTextRight
Frame.pet.name = PetName;
Frame.pet.flash = PetFrameFlash;
Frame.pet.texture = PetFrameTexture;

-- do
	-- for i =1 , 4 do
		-- Frame["PartyMemberFrame"..i].healthBar
	-- end
-- end

local function HDH_UpdateUnit(unit)
	if not UnitExists(unit) or not Frame[unit] then return end
	--Frame[unit].healthBar:SetStatusBarTexture([[Interface\AddOns\Skada\statusbar\Aluminium.tga]]);
	if unit == "player" then
		Frame[unit].healthBar:SetPoint("TOPLEFT",Frame[unit].healthBar:GetParent(), "TOPLEFT",106,-22)
		Frame[unit].healthBar:SetSize(119, 25)
		Frame[unit].hpTextLeft:SetPoint("LEFT",Frame[unit].healthBar,"LEFT",4,0);
		Frame[unit].hpText:SetPoint("CENTER",Frame[unit].healthBar,"CENTER",4,0);
		Frame[unit].hpTextRight:SetPoint("RIGHT",Frame[unit].healthBar,"RIGHT",1,0);
		
		Frame[unit].manaBar:SetPoint("TOPLEFT",Frame[unit].healthBar,"BOTTOMLEFT",0,-1);
		Frame[unit].manaBar:SetSize(119, 18)
		Frame[unit].manaBar.FullPowerFrame:SetHeight(18)
		Frame[unit].manaBar.FullPowerFrame.SpikeFrame:SetHeight(18)
		Frame[unit].manaBar.FeedbackFrame:SetHeight(18)

		Frame[unit].mpTextLeft:SetPoint("LEFT",Frame[unit].manaBar,"LEFT",4,2);
		Frame[unit].mpText:SetPoint("CENTER",Frame[unit].manaBar,"CENTER",4,2);
		Frame[unit].mpTextRight:SetPoint("RIGHT",Frame[unit].manaBar,"RIGHT",1,2);
		
		PlayerFrameGroupIndicator:SetPoint("BOTTOMLEFT", Frame[unit].bg, "TOPLEFT",0,3);
		
		--HDH_ChangeWidthPlayerFrame(DB_UF.player.width)
		if DB_UF.player and DB_UF.player.ClassColor then
			Frame[unit].healthBar.lockColor = true
			HDH_ChangeColorUnitFrameForClass(Frame[unit].healthBar, unit)
		else
			Frame[unit].healthBar.lockColor = false
			Frame[unit].healthBar:SetStatusBarColor(0,1,0)
		end
	else --if unit =="rewrawarr" then -- target focus
		Frame[unit].hpTextLeft:SetPoint("LEFT",Frame[unit].healthBar,"LEFT",2,0);
		Frame[unit].hpText:SetPoint("CENTER",Frame[unit].healthBar,"CENTER");
		Frame[unit].hpTextRight:SetPoint("RIGHT",Frame[unit].healthBar,"RIGHT",-3,0);

		Frame[unit].mpTextLeft:SetPoint("LEFT",Frame[unit].manaBar,"LEFT",2,2);
		Frame[unit].mpText:SetPoint("CENTER",Frame[unit].manaBar,"CENTER",0,2);
		Frame[unit].mpTextRight:SetPoint("RIGHT",Frame[unit].manaBar,"RIGHT",-3,2);
	
		Frame[unit].Threat:SetPoint("BOTTOM", Frame[unit].nameBackground, "TOP",0,2);
		if UnitClassification(unit) ~= "minus" then -- default frame
			Frame[unit].healthBar:SetPoint("TOPLEFT",Frame[unit].healthBar:GetParent(),"TOPLEFT", 6,-22);
			Frame[unit].healthBar:SetHeight(25)
			Frame[unit].nameBackground:ClearAllPoints();
			Frame[unit].nameBackground:SetTexture("Interface\\AddOns\\HDH_UnitFrame\\img\\Smooth.tga");
			Frame[unit].nameBackground:SetPoint("BOTTOMLEFT",Frame[unit].healthBar,"TOPLEFT");
			Frame[unit].nameBackground:SetHeight(14);
			Frame[unit].healthBar.lockColor = true
			Frame[unit].manaBar:SetHeight(18)
			Frame[unit].manaBar:SetPoint("TOPLEFT",Frame[unit].healthBar,"BOTTOMLEFT",0,-1);
			
			if DB_UF.target.ClassColor and UnitIsPlayer(unit) and UnitIsConnected(unit) then
				HDH_ChangeColorUnitFrameForClass(Frame[unit].healthBar, unit)
			else
				if DB_UF.target.TypeColor  then
					Frame[unit].healthBar:SetStatusBarColor(Frame[unit].nameBackground:GetVertexColor())
				else
					Frame[unit].healthBar:SetStatusBarColor(0,1,0)
				end
			end
		else -- minus frame
			Frame[unit].healthBar:SetPoint("TOPLEFT",Frame[unit].healthBar:GetParent(),"TOPLEFT",6,-42)
			Frame[unit].healthBar:SetHeight(12)
			Frame[unit].healthBar:SetStatusBarColor(Frame[unit].nameBackground:GetVertexColor())
		end
		Frame[unit].deadText:SetPoint("CENTER", Frame[unit].healthBar,"CENTER");
		Frame[unit].unconsciousText:SetPoint("CENTER", Frame[unit].healthBar,"CENTER");
	end
	Frame[unit].bg:SetPoint("TOPLEFT", Frame[unit].healthBar, "TOPLEFT", 0, 14)
	Frame[unit].bg:SetPoint("BOTTOMRIGHT", Frame[unit].manaBar, "BOTTOMRIGHT")
	
	Frame[unit].name:ClearAllPoints();
	Frame[unit].name:SetPoint("BOTTOM", Frame[unit].healthBar, "TOP", 0, 2);
end

function HDH_ChangeColorUnitFrameForClass(bar, unit)
	if unit then
		local c = RAID_CLASS_COLORS[select(2,UnitClass(unit))]
		if c then
			bar:SetStatusBarColor(c.r,c.g,c.b)
		else
			bar:SetStatusBarColor(0,1,0)
		end
	else
		bar:SetStatusBarColor(0,1,0)
	end
end

local function SetColor(unit, flag)
	flag = flag and true or false;
	if unit == "target" or unit == "focus" then
		HDH_UpdateUnit('target')
		HDH_UpdateUnit('focus')
	else
		HDH_UpdateUnit('player')
	end
end

hooksecurefunc("TargetFrame_CheckClassification", function(self, forceNormalTexture)
	local classification = UnitClassification(self.unit);
	if ( forceNormalTexture ) then
		self.borderTexture:SetTexture("Interface\\AddOns\\HDH_UnitFrame\\img\\UI-TargetingFrame"); -- 노말
	elseif ( classification == "worldboss" or classification == "elite" ) then
		self.borderTexture:SetTexture("Interface\\AddOns\\HDH_UnitFrame\\img\\UI-TargetingFrame-Elite"); -- 정예
	elseif ( classification == "rareelite" ) then
		self.borderTexture:SetTexture("Interface\\AddOns\\HDH_UnitFrame\\img\\UI-TargetingFrame-Rare-Elite"); -- 정예 희귀
	elseif ( classification == "rare" ) then
		self.borderTexture:SetTexture("Interface\\AddOns\\HDH_UnitFrame\\img\\UI-TargetingFrame-Rare"); -- 일반 희귀
	elseif ( classification == "minus") then
	
	else
		self.borderTexture:SetTexture("Interface\\AddOns\\HDH_UnitFrame\\img\\UI-TargetingFrame"); -- 노말
	end
end)

hooksecurefunc("PlayerFrame_ToPlayerArt", function()
	Frame.player.border:SetTexture("Interface\\AddOns\\HDH_UnitFrame\\img\\UI-TargetingFrame");
	HDH_UpdateUnit('player');
end)

hooksecurefunc("PlayerFrame_ToVehicleArt", function()
	PlayerFrame_HideVehicleTexture();
	Frame.player.border:Show();
	HDH_UpdateUnit('player');
end)

local function UpdatePartyMemberFrame(self)
	local prefix = self:GetName();
	local texture = _G[prefix.."Texture"];
	local portrait = _G[prefix.."Portrait"];
	local healthbar = _G[prefix.."HealthBar"];
	local manabar = _G[prefix.."ManaBar"];
	local bg = _G[prefix.."Background"];
	local name = _G[prefix.."Name"];
	
	local hpTextLeft = _G[prefix.."HealthBarTextLeft"];
	local hpText = _G[prefix.."HealthBarText"];
	local hpTextRight = _G[prefix.."HealthBarTextRight"];
	
	local mpTextLeft = _G[prefix.."ManaBarTextLeft"];
	local mpText = _G[prefix.."ManaBarText"];
	local mpTextRight = _G[prefix.."ManaBarTextRight"];
	
	local disconnect = _G[prefix.."Disconnect"];
	local roleicon = _G[prefix.."RoleIcon"];
	
	local flash = _G[prefix.."Flash"];
	local debuff = _G[prefix.."Debuff1"];
	
	local unit = "party"..self:GetID();
	
	flash:SetAlpha(0);
	
	self:SetWidth(232);
	-- texture:ClearAllPoints();
	texture:SetTexture("Interface\\AddOns\\HDH_UnitFrame\\img\\UI-PartyFrame");
	if healthbar.t2 == nil then
		healthbar.t2 = texture:GetParent():CreateTexture(nil,"BORDER");
		healthbar.t2:SetTexture("Interface\\AddOns\\HDH_UnitFrame\\img\\UI-PartyFrame2");
		healthbar.t2:SetPoint("LEFT",texture,"RIGHT",0,0);
	end
	
	healthbar:SetPoint("TOPLEFT",47,-3)
	healthbar:SetSize(116,27);
	
	if DB_UF.party.ClassColor and UnitIsPlayer(unit) and UnitIsConnected(unit) then
		healthbar.lockColor = true
		HDH_ChangeColorUnitFrameForClass(healthbar, unit);
	elseif UnitIsConnected(unit) then
		healthbar.lockColor = false
		healthbar:SetStatusBarColor(0,1,0);
	else
		healthbar:SetStatusBarColor(0.5, 0.5, 0.5);
	end
	
	manabar:ClearAllPoints();
	manabar:SetPoint("TOPLEFT", healthbar, "BOTTOMLEFT", 0, -2);
	manabar:SetWidth(116,12)
	
	bg:SetPoint("TOPLEFT", healthbar, "TOPLEFT", 0, 0)
	bg:SetPoint("BOTTOMRIGHT", manabar, "BOTTOMRIGHT")
	
	name:ClearAllPoints();
	name:SetPoint("BOTTOMLEFT", healthbar, "TOPLEFT", 0, 2);
	
	hpTextLeft:SetPoint("LEFT",healthbar,"LEFT",4,0);
	hpText:SetPoint("CENTER",healthbar,"CENTER",4,0);
	hpTextRight:SetPoint("RIGHT",healthbar,"RIGHT",1,0);

	mpTextLeft:SetPoint("LEFT",manabar,"LEFT",4,0);
	mpText:SetPoint("CENTER",manabar,"CENTER",4,0);
	mpTextRight:SetPoint("RIGHT",manabar,"RIGHT",1,0);
	
	debuff:SetPoint("TOPLEFT", healthbar, "RIGHT",5,0);
	-- debuff:Show();
end

hooksecurefunc("PartyMemberFrame_ToPlayerArt", function(self)
	UpdatePartyMemberFrame(self);
end)

-- override blizz function
function PartyMemberFrame_ToVehicleArt(self, vehicleType)
	self.state = "vehicle";
	local prefix = self:GetName();
	self.overrideName = "party"..self:GetID();
	UnitFrame_SetUnit(self, "partypet"..self:GetID(), _G[prefix.."HealthBar"], _G[prefix.."ManaBar"]);
	UnitFrame_SetUnit(_G[prefix.."PetFrame"], "party"..self:GetID(), _G[prefix.."PetFrameHealthBar"], nil);
	PartyMemberFrame_UpdateMember(self);
	UnitFrame_Update(self, true)
	
	UpdatePartyMemberFrame(self);
end

hooksecurefunc("PartyMemberFrame_UpdatePet", function(self, id)
	if ( not id ) then
		id = self:GetID();
	end
	local frameName = "PartyMemberFrame"..id;
	local petFrame = _G["PartyMemberFrame"..id.."PetFrame"];
	petFrame:ClearAllPoints();
	petFrame:SetPoint("TOPLEFT",frameName,"BOTTOMLEFT",30,12);
	-- petFrame:Show();
end);

function HDH_UF_PartyFrame_OnDragStart(self)
	PartyMemberFrame1:StartMoving();
	PartyMemberFrame1:SetUserPlaced(true);
	PartyMemberFrame1:SetClampedToScreen(true);
end

function HDH_UF_PartyFrame_OnDragStop(self)
	PartyMemberFrame1:StopMovingOrSizing();
end

hooksecurefunc("TargetFrame_Update", function(self)
	if self.unit =="boss1" or self.unit =="boss2" or self.unit =="boss3" or self.unit =="boss4" or self.unit =="boss5" then
		local healthBar = _G[self:GetName().."HealthBar"];
		
		if DB_UF.target and DB_UF.target.TypeColor then
			healthBar.lockColor = true;
			healthBar:SetStatusBarColor(self.nameBackground:GetVertexColor())
		else
			healthBar.lockColor = false;
			healthBar:SetStatusBarColor(0,1,0)
		end
	end
end);

function HDH_UF_BossFrame_OnDragStart(self)
	Boss1TargetFrame:StartMoving();
	Boss1TargetFrame:SetUserPlaced(true);
	Boss1TargetFrame:SetClampedToScreen(true);
end

function HDH_UF_BossFrame_OnDragStop(self)
	Boss1TargetFrame:StopMovingOrSizing();
end

function HDH_UF_LoadBossFrame()
	local texture;
	local f
	local deadText, unconsciousText;
	local healthBar;
	local bg;
	local name;
	local hpTextLeft, hpText, hpTextRight;
	
	local prefix
	for i=1, 5 do
		f = _G["Boss"..i.."TargetFrame"];
		prefix = f:GetName();
		texture = _G[prefix.."TextureFrameTexture"];
		healthBar = _G[prefix.."HealthBar"];
		manaBar = _G[prefix.."ManaBar"];
		name = _G[prefix.."TextureFrameName"];
		deadText = _G[prefix.."TextureFrameDeadText"];
		unconsciousText = _G[prefix.."TextureFrameUnconsciousText"];
		hpTextLeft = _G[prefix.."TextureFrameHealthBarTextLeft"];
		hpText = _G[prefix.."TextureFrameHealthBarText"];
		hpTextRight = _G[prefix.."TextureFrameHealthBarTextRight"];
		
		healthBar:SetPoint("TOPLEFT",8,-26);
		healthBar:SetPoint("BOTTOMRIGHT",manaBar,"TOPRIGHT", 0,0);
		
		f.nameBackground:SetPoint("TOPLEFT",8,-6);
		f.nameBackground:SetPoint("BOTTOMRIGHT",healthBar,"TOPRIGHT", 0,0);
		-- name:ClearAllPoints();
		name:SetPoint("CENTER",f.nameBackground,"CENTER",0,0);
		
		hpTextLeft:SetPoint("LEFT",healthBar,"LEFT",2,0);
		hpText:SetPoint("CENTER",healthBar,"CENTER");
		hpTextRight:SetPoint("RIGHT",healthBar,"RIGHT",-3,0);
		
		texture:SetTexture("Interface\\AddOns\\HDH_UnitFrame\\img\\UI-UnitFrame-Boss");
		
		deadText:SetPoint("CENTER", healthBar,"CENTER");
		unconsciousText:SetPoint("CENTER", healthBar,"CENTER");
		
		f.threatNumericIndicator:SetPoint("BOTTOM", f, "TOP", -85, -6);
		f:SetScript("OnDragStart", HDH_UF_BossFrame_OnDragStart)
		f:SetScript("OnDragStop", HDH_UF_BossFrame_OnDragStop)
		f:SetScale(1.0);
		-- f:SetMovable(true);
		-- f:Show();
	end
end
	
local function HDH_PLAYER_ENTERING_WORLD()
	if DB_UF.target == nil then
		DB_UF.target= {}
		DB_UF.target.ClassColor = true
		DB_UF.target.TypeColor = true
		DB_UF.target.width = 0
	end
	
	if DB_UF.player == nil then
		DB_UF.player = {}
		DB_UF.player.ClassColor = true
		DB_UF.player.width = 0
	end
	
	if DB_UF.party == nil then
		DB_UF.party = {}
		DB_UF.party.ClassColor = true;
		DB_UF.party.Move = false;
	end
	
	if DB_UF.boss == nil then
		DB_UF.boss = {}
		DB_UF.boss.Move = false;
	end
	
	f:RegisterEvent("PLAYER_TARGET_CHANGED")
	f:RegisterEvent("PLAYER_FOCUS_CHANGED")
	HDH_UpdateUnit('player')
	HDH_UpdateUnit('target')
	HDH_UpdateUnit('focus')
	
	for i = 1, 4 do
		local f = _G["PartyMemberFrame"..i];
		local pet = _G["PartyMemberFrame"..i.."PetFrame"];
		if i > 1 then
			f:SetPoint("TOPLEFT", _G["PartyMemberFrame"..(i-1)],"BOTTOMLEFT",0, -23);
		end
		f:SetScript("OnDragStart", HDH_UF_PartyFrame_OnDragStart)
		f:SetScript("OnDragStop", HDH_UF_PartyFrame_OnDragStop)
		UpdatePartyMemberFrame(f)
	end
	
	-- HDH_UF_LoadBossFrame();
end

function HDH_OnEvent(self, e)
	if e == "PLAYER_TARGET_CHANGED" then
		HDH_UpdateUnit('target')
	elseif e == "PLAYER_FOCUS_CHANGED" then
		HDH_UpdateUnit('focus')
	elseif e == "PLAYER_ENTERING_WORLD" then
		HDH_PLAYER_ENTERING_WORLD()
	end
end

f:SetScript("OnEvent",HDH_OnEvent)
f:RegisterEvent("PLAYER_ENTERING_WORLD")
print('|cffffff00HDH - UnitFrame |cffffffff(help: /hdh_uf)')
SLASH_HDH_UF1 = '/hdh_uf'
SlashCmdList["HDH_UF"] = function (msg, editbox)
	if msg == "target on" then
		SetColor('target', true);
	elseif msg == "target off" then
		SetColor('target', false);
	elseif msg =="player on" then
		SetColor('player', true);
	elseif msg =="player off" then
		SetColor('player', false);
	else
		print(L_HELP1) 
		print(L_HELP2);
	end
end

hooksecurefunc("UnitPopup_ShowMenu", function(dropdownMenu, which, unit, name, userData)
	local info, value;
	if unit == 'player' or unit == 'target' or unit == "party1" or unit == "party2" or unit == "party3" or unit == "party4" then
		if unit:find("party") then
			unit = "party";
		end
		value = HDH_MENU_VALUE_COLOR_OF_CLASS;
		if ( UIDROPDOWNMENU_MENU_LEVEL == 1 ) then
			info = UIDropDownMenu_CreateInfo();
			info.owner = UIDROPDOWNMENU_MENU_VALUE;
			if (DB_UF[unit].ClassColor) then info.checked = 1;
			else info.checked = nil; end
			
			info.value = value;
			info.text = HDH_UnitPopupButtons[value].text;
			info.isNotRadio = HDH_UnitPopupButtons[value].isNotRadio;
			info.func = UnitPopup_OnClick;
			UIDropDownMenu_AddButton(info, level);	
		end
	end
	if unit == 'target' then
		value = HDH_MENU_VALUE_COLOR_OF_TYPE;
		if ( UIDROPDOWNMENU_MENU_LEVEL == 1 ) then
			info = UIDropDownMenu_CreateInfo();
			info.owner = UIDROPDOWNMENU_MENU_VALUE;
			if (DB_UF[unit].TypeColor) then info.checked = 1;
			else info.checked = nil; end
			
			info.value = value;
			info.text = HDH_UnitPopupButtons[value].text;
			info.isNotRadio = HDH_UnitPopupButtons[value].isNotRadio;
			info.func = UnitPopup_OnClick;
			UIDropDownMenu_AddButton(info, level);	
		end
	end
	
	if unit == "party" then -- 위에서 party 로 보정 한다 or unit =="boss1" or unit =="boss2" or unit =="boss3" or unit =="boss4" or unit =="boss5" 
		if unit:find("boss") then
			unit = "boss";
		end
		value = HDH_MENU_VALUE_MOVE_PARTY;
		if ( UIDROPDOWNMENU_MENU_LEVEL == 1 ) then
			info = UIDropDownMenu_CreateInfo();
			info.owner = UIDROPDOWNMENU_MENU_VALUE;
			if (DB_UF[unit].Move) then info.checked = 1;
			else info.checked = nil; end
			
			info.value = value;
			info.text = HDH_UnitPopupButtons[value].text;
			info.isNotRadio = HDH_UnitPopupButtons[value].isNotRadio;
			info.func = UnitPopup_OnClick;
			UIDropDownMenu_AddButton(info, level);	
		end
	end
end);

hooksecurefunc("UnitPopup_OnClick", function(self) 
	local dropdownFrame = UIDROPDOWNMENU_INIT_MENU;
	local button = self.value;
	local unit = dropdownFrame.unit;
	-- local name = dropdownFrame.name;
	-- local server = dropdownFrame.server;
	-- local fullname = name;
	if button == HDH_MENU_VALUE_COLOR_OF_CLASS then
		if unit:find("party") then
			unit = "party";
			DB_UF[unit].ClassColor = not DB_UF[unit].ClassColor;
			for i = 1, 4 do
				local f = _G["PartyMemberFrame"..i];
				UpdatePartyMemberFrame(f)
			end
		else
			DB_UF[unit].ClassColor = not DB_UF[unit].ClassColor;
			SetColor(unit, (DB_UF[unit].ClassColor));
		end
	elseif button == HDH_MENU_VALUE_COLOR_OF_TYPE then
		DB_UF[unit].TypeColor = not DB_UF[unit].TypeColor;
		SetColor(unit, (DB_UF[unit].TypeColor));
		
		for i=1, 5 do
			local f = _G["Boss"..i.."TargetFrame"];
			TargetFrame_Update(f);
		end
	elseif button == HDH_MENU_VALUE_MOVE_PARTY then
		if unit:find("party") then
			unit = "party";
			DB_UF[unit].Move = not DB_UF[unit].Move;
			for i = 1, 4 do
				local f = _G["PartyMemberFrame"..i];
				if ( DB_UF[unit].Move ) then
					f:RegisterForDrag("LeftButton");
				else
					f:RegisterForDrag();
				end
			end
		else
			unit = "boss";
			DB_UF[unit].Move = not DB_UF[unit].Move;
			for i = 1, 5 do
				local f = _G["Boss"..i.."TargetFrame"];
				if ( DB_UF[unit].Move ) then
					f:RegisterForDrag("LeftButton");
				else
					f:RegisterForDrag();
				end
			end
		end
		
	end
end);

hooksecurefunc("PlayerFrame_UpdateStatus", function(self)
	if ( PlayerStatusTexture:IsShown() ) then PlayerStatusTexture:Hide(); end 
end);

hooksecurefunc("PetFrame_Update", function(self)
	if Frame.pet.bg == nil then
		Frame.pet.bg = Frame.pet:CreateTexture();
		Frame.pet.bg:SetTexture(1,1,1);
		Frame.pet.bg:SetVertexColor(0,0,0);
		Frame.pet.bg:SetAlpha(0.5);
		Frame.pet.bg:SetPoint("TOPLEFT", Frame.pet.healthBar, "TOPLEFT",0,0);
		Frame.pet.bg:SetPoint("BOTTOMRIGHT", Frame.pet.manaBar, "BOTTOMRIGHT", 0, 0);
	end
	Frame.pet.flash:SetAlpha(0);
	Frame.pet.texture:SetTexture("Interface\\AddOns\\HDH_UnitFrame\\img\\UI-SmallTargetingFrame")
	
	Frame.pet.healthBar:SetPoint("TOPLEFT",46,-16);
	Frame.pet.healthBar:SetSize(70, 13);
	Frame.pet.hpTextLeft:ClearAllPoints();
	Frame.pet.hpTextLeft:SetPoint("RIGHT",Frame.pet.healthBar,"RIGHT");
	Frame.pet.hpTextRight:SetPoint("RIGHT",Frame.pet.healthBar,"RIGHT",-2,0);
	Frame.pet.hpText:SetPoint("CENTER",Frame.pet.healthBar,"CENTER");
	Frame.pet.hpTextRight:SetAlpha(0);
	
	Frame.pet.mpTextLeft:ClearAllPoints();
	Frame.pet.mpTextLeft:SetPoint("LEFT",Frame.pet.manaBar,"RIGHT",0,-3);
	Frame.pet.mpTextLeft:SetAlpha(0);
	-- Frame.pet.mpText:Hide();
	-- Frame.pet.mpTextRight:Hide();
	
	Frame.pet.name:ClearAllPoints();
	Frame.pet.name:SetPoint("LEFT",Frame.pet.healthBar,"LEFT",2,-22);
end);

-------------------
--override blizz funtion --
-------------------
function TargetFrame_UpdateBuffAnchor(self, buffName, index, numDebuffs, anchorIndex, size, offsetX, offsetY, mirrorVertically)
	--For mirroring vertically
	local point, relativePoint;
	local startY, auraOffsetY;
	if ( mirrorVertically ) then
		point = "BOTTOM";
		relativePoint = "TOP";
		startY = -1; -- -15
		if ( self.threatNumericIndicator:IsShown() ) then
			startY = startY + self.threatNumericIndicator:GetHeight();
		end
		offsetY = - offsetY;
		auraOffsetY = -3; -- -AURA_OFFSET_Y
	else
		point = "TOP";
		relativePoint="BOTTOM";
		startY = 32; -- AURA_START_Y
		auraOffsetY = 3; --  AURA_OFFSET_Y
	end
	
	local buff = _G[buffName..index];
	if ( index == 1 ) then
		if ( UnitIsFriend("player", self.unit) or numDebuffs == 0 ) then
			-- unit is friendly or there are no debuffs...buffs start on top
			buff:SetPoint(point.."LEFT", self, relativePoint.."LEFT", 5, startY);  -- AURA_START_X -> 5
		else
			-- unit is not friendly and we have debuffs...buffs start on bottom
			buff:SetPoint(point.."LEFT", self.debuffs, relativePoint.."LEFT", 0, -offsetY);
		end
		self.buffs:SetPoint(point.."LEFT", buff, point.."LEFT", 0, 0);
		self.buffs:SetPoint(relativePoint.."LEFT", buff, relativePoint.."LEFT", 0, -auraOffsetY);
		self.spellbarAnchor = buff;
	elseif ( anchorIndex ~= (index-1) ) then
		-- anchor index is not the previous index...must be a new row
		buff:SetPoint(point.."LEFT", _G[buffName..anchorIndex], relativePoint.."LEFT", 0, -offsetY);
		self.buffs:SetPoint(relativePoint.."LEFT", buff, relativePoint.."LEFT", 0, -auraOffsetY);
		self.spellbarAnchor = buff;
	else
		-- anchor index is the previous index
		buff:SetPoint(point.."LEFT", _G[buffName..anchorIndex], point.."RIGHT", offsetX, 0);
	end

	-- Resize
	buff:SetWidth(size);
	buff:SetHeight(size);
end

-------------------
-- blizz funtion --
-------------------
function TargetFrame_UpdateDebuffAnchor(self, debuffName, index, numBuffs, anchorIndex, size, offsetX, offsetY, mirrorVertically)
	local buff = _G[debuffName..index];
	local isFriend = UnitIsFriend("player", self.unit);
	
	--For mirroring vertically
	local point, relativePoint;
	local startY, auraOffsetY;
	if ( mirrorVertically ) then
		point = "BOTTOM";
		relativePoint = "TOP";
		startY = -1 ; -- -15
		if ( self.threatNumericIndicator:IsShown() ) then
			startY = startY + self.threatNumericIndicator:GetHeight();
		end
		offsetY = - offsetY;
		auraOffsetY = -3; --  -AURA_OFFSET_Y
	else
		point = "TOP";
		relativePoint="BOTTOM";
		startY = 32; -- AURA_START_Y
		auraOffsetY = 3; --  AURA_OFFSET_Y
	end
	
	if ( index == 1 ) then
		if ( isFriend and numBuffs > 0 ) then
			-- unit is friendly and there are buffs...debuffs start on bottom
			buff:SetPoint(point.."LEFT", self.buffs, relativePoint.."LEFT", 0, -offsetY);
		else
			-- unit is not friendly or there are no buffs...debuffs start on top
			buff:SetPoint(point.."LEFT", self, relativePoint.."LEFT", 5, startY); -- AURA_START_X -> 5
		end
		self.debuffs:SetPoint(point.."LEFT", buff, point.."LEFT", 0, 0);
		self.debuffs:SetPoint(relativePoint.."LEFT", buff, relativePoint.."LEFT", 0, -auraOffsetY);
		if ( ( isFriend ) or ( not isFriend and numBuffs == 0) ) then
			self.spellbarAnchor = buff;
		end
	elseif ( anchorIndex ~= (index-1) ) then
		-- anchor index is not the previous index...must be a new row
		buff:SetPoint(point.."LEFT", _G[debuffName..anchorIndex], relativePoint.."LEFT", 0, -offsetY);
		self.debuffs:SetPoint(relativePoint.."LEFT", buff, relativePoint.."LEFT", 0, -auraOffsetY);
		if ( ( isFriend ) or ( not isFriend and numBuffs == 0) ) then
			self.spellbarAnchor = buff;
		end
	else
		-- anchor index is the previous index
		buff:SetPoint(point.."LEFT", _G[debuffName..(index-1)], point.."RIGHT", offsetX, 0);
	end

	-- Resize
	buff:SetWidth(size);
	buff:SetHeight(size);
	local debuffFrame =_G[debuffName..index.."Border"];
	debuffFrame:SetWidth(size+2);
	debuffFrame:SetHeight(size+2);
end
