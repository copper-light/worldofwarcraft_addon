
local DB = HDH_AT_ConfigDB

--------------------------------------------
-- TRACKER Class 
--------------------------------------------
HDH_TRACKER = {}
HDH_TRACKER.objList = {}
HDH_TRACKER.__index = HDH_TRACKER
HDH_TRACKER.className = "HDH_TRACKER"

HDH_TRACKER.CLASSLIST = {}
HDH_TRACKER.TYPE = {}

--------------------------------------------
-- Properties
--------------------------------------------

HDH_TRACKER.ENABLE_MOVE = false
HDH_TRACKER.ANI_SHOW = 1
HDH_TRACKER.ANI_HIDE = 2
HDH_TRACKER.FONT_STYLE = "fonts\\2002.ttf";
HDH_TRACKER.MAX_ICONS_COUNT = 10

--------------------------------------------
do -- TRACKER Static function
--------------------------------------------

	-- function HDH_TRACKER.ReLoad()
	-- 	HDH_TRACKER.objListx
	-- end

    function HDH_TRACKER.GetClass(type)
        return HDH_TRACKER.CLASSLIST[type]
    end

    function HDH_TRACKER.RegClass(type, class)
        HDH_TRACKER.CLASSLIST[type] = class
    end

	function HDH_TRACKER.New(id, name, type, unit)
		local obj = nil;
        local class = HDH_TRACKER.GetClass(type)
		if class then
			obj = {};
			setmetatable(obj, class)
			obj:Init(id, name, type, unit)
			HDH_TRACKER.AddList(obj)
		end
		return obj
	end

	function HDH_TRACKER.Delete(trackerId)
		if trackerId then
			HDH_TRACKER.Release(trackerId)
		else
			for k, v in pairs(HDH_TRACKER.objList) do
				HDH_TRACKER.Release(v.id)
			end
		end
	end
	
	function HDH_TRACKER.Release(trackerId) -- t = (number) or (tracker obj)
		local obj = HDH_TRACKER.Get(trackerId)
		if not obj then return end
		obj:Release()
		HDH_TRACKER.objList[trackerId] = nil
	end

	function HDH_TRACKER.AddList(tracker)
		HDH_TRACKER.objList[tracker.id] = tracker
	end

	function HDH_TRACKER.ModifyList(oldId, newId)
		if oldId == newId then return end
		HDH_TRACKER.objList[newId] = HDH_TRACKER.objList[oldId]
		HDH_TRACKER.objList[oldId] = nil
	end

	function HDH_TRACKER.Get(id)
		return HDH_TRACKER.objList[id] or nil
	end

	function HDH_TRACKER.GetList()
		return HDH_TRACKER.objList
	end

	function HDH_TRACKER.Update(trackerId)
		if trackerId then
			local t= HDH_TRACKER.Get(trackerId)
			if t then
				t:Update()
			end
		else
			-- local curTalentId = select(1, GetSpecializationInfo(GetSpecialization()))
			-- local curTransit = C_ClassTalents.GetLastSelectedSavedConfigID(curTalentId)
			local ids = DB:GetTrackerIdsByTransits(curTalentId, curTransit)
			for _, t in pairs(HDH_TRACKER.GetList()) do
				if t then
					t:Update()
				end
			end
		end

		return HDH_TRACKER.objList
	end

	-- function HDH_TRACKER.is()

	function HDH_TRACKER.InitVaribles(trackerId)
		local id, name, type, unit
		if trackerId then
			id, name, type, unit, _, _, _ = DB:GetTrackerInfo(trackerId)
			tracker = HDH_TRACKER.Get(trackerId)
			tracker:Init(id, name, type, unit)
			-- print(trackerId, tracker)
			-- if not tracker then
			-- 	print('asdf')
			-- 	HDH_TRACKER.New(id, name, type, unit);
			-- else
				
			-- end
		else
			HDH_TRACKER.Delete()
			local talentID, _, _ = GetSpecializationInfo(GetSpecialization())
			local currentTransitValue = C_ClassTalents.GetLastSelectedSavedConfigID(talentID)
			local trackerIds = DB:GetTrackerIdsByTransits(talentID, currentTransitValue)
			if not trackerIds or #trackerIds == 0 then return end

			-- local trackerId = trackerList[1]
			-- local tracker = DB:GetTracker(trackerId)

			-- local trackers =  DB:GetTrackerList()

			
			for _, trackerId in pairs(trackerIds) do
				id, name, type, unit = DB:GetTrackerInfo(trackerId)
				tracker = HDH_TRACKER.Get(id)
				if not tracker then
					HDH_TRACKER.New(id, name, type, unit);
				else
					tracker:Init(id, name, type, unit);
				end
			end
		end
	end

	function HDH_TRACKER.InitIcons(trackerId)
		if trackerId then
			local t = HDH_TRACKER.Get(trackerId)
			if t then
				t:InitIcons()
			end
		else
			for idx, t in pairs(HDH_TRACKER.GetList()) do
				t:InitIcons()
			end
		end
	end

	function HDH_TRACKER.UpdateSetting(trackerId)
		if trackerId and DB:HasUI(trackerId) then
			local t = HDH_TRACKER.Get(trackerId)
			if t then
				t:UpdateSetting()
				t:Update()
			end
		else
			for k, t in pairs(HDH_TRACKER.GetList()) do
				t:UpdateSetting()
				t:Update()
			end
		end
	end

	-- 바 프레임 이동시키는 플래그 및 이동바 생성+출력
	function HDH_TRACKER.SetMoveAll(lock)
		if lock then
			HDH_TRACKER.ENABLE_MOVE = true
			for k, tracker in pairs(HDH_TRACKER.GetList()) do
				tracker:SetMove(true)
			end
		else
			HDH_TRACKER.ENABLE_MOVE = false
			for k, tracker in pairs(HDH_TRACKER.GetList()) do
				tracker:SetMove(false)
				
			end
		end
	end

	-- function HDH_TRACKER.IsEqualClass(type, className)
	-- 	local ret= false;
	-- 	if type and HDH_GET_CLASS_NAME[type] == className then ret = true; end
	-- 	return ret;
	-- end
	
------------------------------------------
end -- TRACKER Static function 
------------------------------------------


------------------------------------------
do -- TRACKER interface function
------------------------------------------

    function HDH_TRACKER:Init(...)
		
    end

	function HDH_TRACKER:GetClassName()
		return self.className
	end

------------------------------------------
end -- TRACKER interface function
------------------------------------------


------------------------------------------
-- TRACKER Event
------------------------------------------

local function PLAYER_ENTERING_WORLD()
	if not HDH_TRACKER.IsLoaded then 
		print('|cffffff00HDH - AuraTracking |cffffffff(Setting: /at, /auratracking, /ㅁㅅ)')
		HDH_TRACKER.startTime = GetTime();
		HDH_AT_ADDON_FRAME:RegisterEvent('VARIABLES_LOADED')
		HDH_AT_ADDON_FRAME:RegisterEvent('PLAYER_REGEN_DISABLED')
		HDH_AT_ADDON_FRAME:RegisterEvent('PLAYER_REGEN_ENABLED')
		HDH_AT_ADDON_FRAME:RegisterEvent('ACTIVE_TALENT_GROUP_CHANGED')
		HDH_AT_ADDON_FRAME:RegisterEvent('TRAIT_TREE_CHANGED') -- 특성 빌드 설정 업데이트 하려고 할때 
		HDH_AT_ADDON_FRAME:RegisterEvent('TRAIT_CONFIG_UPDATED') -- 특성 빌드 설정 변경 완료 됐을때
		HDH_AT_ADDON_FRAME:RegisterEvent('TRAIT_CONFIG_DELETED') -- 특성 빌드 설정 변경 완료 됐을때
		-- HDH_AT_ADDON_FRAME:RegisterEvent('TRAIT_CONFIG_CREATED') -- 특성 빌드 설정 변경 완료 됐을때
		
	end

	HDH_TRACKER.InitVaribles()
	local trackerList = HDH_TRACKER.GetList()
	for _, t in pairs(trackerList) do
		t:PLAYER_ENTERING_WORLD()
	end
	HDH_TRACKER.IsLoaded = true;
end

-- 이벤트 콜백 함수
local function OnEvent(self, event, ...)
	-- print( event, ...)
	if event =='ACTIVE_TALENT_GROUP_CHANGED' then
		-- HDH_AT_UTIL.IsTalentSpell(nil,nil,true);
		HDH_TRACKER.InitVaribles()
		HDH_TRACKER.Update()

		if HDH_AT_ConfigFrame and HDH_AT_ConfigFrame:IsShown() then 
			HDH_AT_ConfigFrame:UpdateFrame()
		end
		-- HDH_cashTalentSpell = nil
	
	elseif event == 'PLAYER_REGEN_ENABLED' then	
		if not HDH_TRACKER.ENABLE_MOVE then
			HDH_TRACKER.Update()
		end
	
	elseif event == 'PLAYER_REGEN_DISABLED' then
		if not HDH_TRACKER.ENABLE_MOVE then
			HDH_TRACKER.Update()
		end
	
	elseif event == "PLAYER_ENTERING_WORLD" then
		-- self:UnregisterEvent('PLAYER_ENTERING_WORLD')
		PLAY_SOUND = false
		C_Timer.After(3, PLAYER_ENTERING_WORLD)
		C_Timer.After(6, function() PLAY_SOUND = true end)
	elseif event =="GET_ITEM_INFO_RECEIVED" then
	elseif event == "TRAIT_CONFIG_UPDATED" then
		HDH_TRACKER.InitVaribles()
		HDH_TRACKER.Update()
		if HDH_AT_ConfigFrame:IsShown() then
			HDH_AT_ConfigFrame:UpdateFrame()
		end
	elseif event == "TRAIT_CONFIG_DELETED" then
		DB:CheckTransitDB()
		HDH_TRACKER.InitVaribles()
		if HDH_AT_ConfigFrame:IsShown() then
			HDH_AT_ConfigFrame:UpdateFrame()
		end
	elseif event == "TRAIT_CONFIG_CREATED" then -- 현재 사용 안함
		HDH_TRACKER.InitVaribles()
		if HDH_AT_ConfigFrame:IsShown() then
			HDH_AT_ConfigFrame:UpdateFrame()
		end
	end
end

-- 애드온 로드 시 가장 먼저 실행되는 함수
local function OnLoad(self)
	self:RegisterEvent('PLAYER_ENTERING_WORLD')
	--self:RegisterEvent("GET_ITEM_INFO_RECEIVED")
end
	
HDH_AT_ADDON_FRAME = CreateFrame("Frame", "HDH_AT_iconframe", UIParent) -- 애드온 최상위 프레임
HDH_AT_ADDON_FRAME:SetScript("OnEvent", OnEvent)
OnLoad(HDH_AT_ADDON_FRAME)