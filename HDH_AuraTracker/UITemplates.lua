local L = HDH_AT_L

local function hasValue (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end


---------------------------
---------------------------


HDH_AT_UITabBtnMixin = {}
function HDH_AT_UITabBtnMixin:SetActivate(bool)
    if bool then
        self.Active1:Show()
        self.Active2:Show()
    else
        self.Active1:Hide()
        self.Active2:Hide()
    end
end

HDH_AT_BottomTapMixin = {}

function HDH_AT_BottomTapMixin:SetActivate(bool)
    -- local name = self:GetName()
    if bool then
        self:Disable()
        self.Left:Hide()
        self.Middle:Hide()
        self.Right:Hide()
        self.LeftActive:Show()
        self.MiddleActive:Show()
        self.RightActive:Show()
        self.Text:SetPoint("CENTER",0,-3)
    else
        self:Enable()
        self.Left:Show()
        self.Middle:Show()
        self.Right:Show()
        self.LeftActive:Hide()
        self.MiddleActive:Hide()
        self.RightActive:Hide()
        self.Text:SetPoint("CENTER",0,3)
    end
end

-------------------------------------------------------------
-- Aura List
-------------------------------------------------------------
HDH_AT_AuraRowMixin = {}

HDH_AT_AuraRowMixin.MODE = {}
HDH_AT_AuraRowMixin.MODE.EMPTY = 1
HDH_AT_AuraRowMixin.MODE.DATA = 2

function HDH_AT_AuraRowMixin:Set(no, key, id, name, texture, always, glow, isItem)
	_G[self:GetName().."ButtonIcon"]:SetNormalTexture(texture or 0)
	_G[self:GetName().."ButtonIcon"]:GetNormalTexture():SetTexCoord(0.08, 0.92, 0.08, 0.92);
	_G[self:GetName().."TextNum"]:SetText(no)
	_G[self:GetName().."TextName"]:SetText(name)
	_G[self:GetName().."TextID"]:SetText(id.."")
	_G[self:GetName().."CheckButtonAlways"]:SetChecked(always)
    _G[self:GetName().."CheckButtonGlow"]:SetChecked(glow)
	_G[self:GetName().."EditBoxID"]:SetText(id or key or "")
	_G[self:GetName().."CheckButtonIsItem"]:SetChecked(isItem)
	-- _G[rowFrame:GetName().."ButtonAdd"]:SetText("삭제")
	-- _G[rowFrame:GetName().."ButtonAddAndDel"]:SetText("등록")
	_G[self:GetName().."EditBoxID"]:ClearFocus() -- ButtonAddAndDel 의 값때문에 순서 굉장히 중요함
	_G[self:GetName().."RowDesc"]:Hide()
    _G[self:GetName().."CheckButtonAlways"]:Show()
    _G[self:GetName().."CheckButtonGlow"]:Show()
    _G[self:GetName().."ButtonSet"]:Show()
    self.mode = HDH_AT_AuraRowMixin.MODE.DATA
end

function HDH_AT_AuraRowMixin:GetMode()
    return self.mode -- 0: data
end

function HDH_AT_AuraRowMixin:Get()
    local row_idx = _G[self:GetName().."TextNum"]:GetText()
	local key = _G[self:GetName().."EditBoxID"]:GetText()
	local always = _G[self:GetName().."CheckButtonAlways"]:GetChecked()
	local glow = _G[self:GetName().."CheckButtonGlow"]:GetChecked()
	--local showValue = _G[rowFrame:GetName().."CheckButtonShowValue"]:GetChecked()
    local name = _G[self:GetName().."TextName"]:GetName()
    local texture = _G[self:GetName().."ButtonIcon"]:GetNormalTexture()
    local isItem = _G[self:GetName().."CheckButtonIsItem"]:GetChecked()
    local id = _G[self:GetName().."TextID"]:GetText()

    return row_idx, key, id, name, texture, always, glow, isItem
end

function HDH_AT_AuraRowMixin:Clear()
	_G[self:GetName().."ButtonIcon"]:SetNormalTexture(0)
    _G[self:GetName().."ButtonIcon"]:GetNormalTexture():SetAtlas("ui-hud-minimap-zoom-in")
    _G[self:GetName().."ButtonIcon"]:GetNormalTexture():SetTexCoord(-0.09, 1.09, -0.09, 1.09)
	_G[self:GetName().."TextNum"]:SetText(nil)
	_G[self:GetName().."TextName"]:SetText(nil)
	_G[self:GetName().."RowDesc"]:Show()
	_G[self:GetName().."TextID"]:SetText(nil)
	_G[self:GetName().."CheckButtonAlways"]:SetChecked(true)
    _G[self:GetName().."CheckButtonGlow"]:SetChecked(false)
	_G[self:GetName().."EditBoxID"]:SetText("")
	_G[self:GetName().."ButtonAdd"]:SetText(L.SAVE)
	_G[self:GetName().."CheckButtonIsItem"]:SetChecked(false)
	_G[self:GetName().."EditBoxID"]:ClearFocus() -- ButtonAddAndDel 의 값때문에 순서 굉장히 중요함
    _G[self:GetName().."CheckButtonAlways"]:Hide()
    _G[self:GetName().."CheckButtonGlow"]:Hide()
    
    _G[self:GetName().."ButtonSet"]:Hide()
    self.mode = HDH_AT_AuraRowMixin.MODE.EMPTY
end
-- function HDH_AT_AuraRowMixin:SetHandler(func_OnEnterPressed, func_OnClick)
--     _G[self:GetName().."ButtonAdd"]:SetScript("OnClick", func_OnClick)
--     _G[self:GetName().."ButtonDel"]:SetScript("OnClick", func_OnClick)
-- end

function HDH_AT_OnEditFocusGained(self)
	local btn = _G[self:GetParent():GetName().."ButtonAdd"]
	local chk = _G[self:GetParent():GetName().."CheckButtonIsItem"]
	if(self:GetText() == "") then
		btn:SetText(L.SAVE)
	else
		btn:SetText(L.EDIT)
	end
	self.tmp_id = self:GetText()
	self.tmp_chk = chk:GetChecked()
	--self:SetWidth(EDIT_WIDTH_L)
    
    if self:GetParent().mode == HDH_AT_AuraRowMixin.MODE.DATA then
        _G[self:GetParent():GetName().."CheckButtonAlways"]:Hide()
        _G[self:GetParent():GetName().."CheckButtonGlow"]:Hide()
        _G[self:GetParent():GetName().."ButtonSet"]:Hide()
        _G[self:GetParent():GetName().."ButtonDel"]:Show()
    else
        _G[self:GetParent():GetName().."ButtonCancel"]:Show() 
    end
    _G[self:GetParent():GetName().."RowDesc"]:Hide()
    _G[self:GetParent():GetName().."ButtonAdd"]:Show() 
    
end

function HDH_AT_OnEditFocusLost(self)
	self.tmp_id = nil
	self.tmp_chk = false

    -- 버튼 클릭 이벤트보다 포커스 로스트 이벤트가 먼저 일어나서 버튼 이벤트가 발생하지 않는 문제로 인하여
    -- 이벤트를 지연시킴
    t = C_Timer.NewTimer(0.5, function(self)
        self = t.arg
        _G[self:GetParent():GetName().."EditBoxID"]:Hide()
        _G[self:GetParent():GetName().."TextID"]:Hide()

        if self:GetParent().mode == HDH_AT_AuraRowMixin.MODE.DATA then
            _G[self:GetParent():GetName().."CheckButtonAlways"]:Show()
            _G[self:GetParent():GetName().."CheckButtonGlow"]:Show()
            _G[self:GetParent():GetName().."ButtonSet"]:Show()
            _G[self:GetParent():GetName().."TextName"]:Show()
        else
            self:SetText("")
            _G[self:GetParent():GetName().."RowDesc"]:Show()
        end
        _G[self:GetParent():GetName().."CheckButtonIsItem"]:Hide()
        _G[self:GetParent():GetName().."ButtonAdd"]:Hide()
        _G[self:GetParent():GetName().."ButtonDel"]:Hide()
        _G[self:GetParent():GetName().."ButtonCancel"]:Hide() 
    end)
    
    t.arg = self
end

function HDH_AT_OnEditEscape(self)
	_G[self:GetParent():GetName().."CheckButtonIsItem"]:SetChecked(self.tmp_chk)
	self:SetText(self.tmp_id or "")
	self:ClearFocus()
end

-- function HDH_OnEnterPressed(self)
-- 	local index = GetTrackerIndex()
-- 	local db = HDH_AT_OP_GetTrackerInfo(index)
-- 	local name = db.name
-- 	local str = HDH_AT_UTIL.Trim(self:GetText()) or ""
-- 	self:SetText(str)
-- 	if tonumber(self:GetText()) and string.len(self:GetText()) > 7 then 
-- 		HDH_OP_AlertDlgShow(self:GetText().." 은(는) 알 수 없는 주문입니다.")
-- 		return
-- 	end
-- 	if string.len(self:GetText()) > 0 then
-- 		local ret = HDH_AddRow(self:GetParent()) -- 성공 하면 no 리턴
-- 		if ret then 
-- 			-- add 에 성공 했을 경우 다음 add 를 위해 가장 아래 공백 row 를 생성해야한다
-- 			local listFrame = self:GetParent():GetParent()
-- 			if ret == #(db.spell_list) then
-- 				local rowFrame = HDH_GetRowFrame(listFrame, ret+1, FLAG_ROW_CREATE)
-- 				HDH_ClearRowData(rowFrame)
-- 				rowFrame:Show() 
-- 			end
-- 			local t = HDH_AT_OP_GetTracker(index)
-- 			if t then t:InitIcons() end
-- 		else
-- 			self:SetText("") 
-- 		end
-- 	else
-- 		HDH_OP_AlertDlgShow("주문 ID/이름을 입력해주세요.")
-- 	end
-- end

-- function HDH_OnClickBtnAddAndDel(self, row)
-- 	local edBox= _G[self:GetParent():GetName().."EditBoxID"]
-- 	if self:GetText() == "등록" or self:GetText() == "수정" then
-- 		HDH_OnEnterPressed(edBox)
-- 	else
-- 		local text = _G[self:GetParent():GetName().."TextName"]:GetText()
-- 		if text then
-- 			HDH_DelRow(self:GetParent())
-- 		end
-- 	end
-- end

-- function HDH_OnClickBtnUp(self, row)
-- 	local name = HDH_AT_OP_GetTrackerInfo(GetTrackerIndex())
-- 	local aura = DB_AURA.Talent[HDH_GetSpec(name)][name]
-- 	row = tonumber(row)
-- 	if aura[row] and aura[row-1] then
-- 		local tmp_no = aura[row].No
-- 		aura[row].No = aura[row-1].No
-- 		aura[row-1].No = tmp_no
-- 		local tmp = aura[row]
-- 		aura[row] = aura[row-1]
-- 		aura[row-1] = tmp
-- 		--HDH_LoadAuraListFrame(CurUnit, row-1, row)
		
-- 		local f1 = HDH_GetRowFrame(ListFrame, row)
-- 		local f2 = HDH_GetRowFrame(ListFrame, row-1)
-- 		CrateAni(f1)
-- 		CrateAni(f2)
-- 		f2.ani.func = HDH_LoadAuraListFrame
-- 		f2.ani.args = {GetTrackerIndex(), row-1, row}
-- 		StartAni(f1, ANI_MOVE_UP)
-- 		StartAni(f2 , ANI_MOVE_DOWN)
-- 	end
-- 	local t = HDH_AT_OP_GetTracker(GetTrackerIndex())
-- 	if t then t:InitIcons() end
-- end

-- function HDH_OnClickBtnDown(self, row)
-- 	row = tonumber(row)
-- 	local name = HDH_AT_OP_GetTrackerInfo(GetTrackerIndex())
-- 	local aura = DB_AURA.Talent[HDH_GetSpec(name)][name]
-- 	if aura[row] and aura[row+1] then
-- 		local tmp_no = aura[row].No
-- 		aura[row].No = aura[row+1].No
-- 		aura[row+1].No = tmp_no
-- 		local tmp = aura[row]
-- 		aura[row]= aura[row+1]
-- 		aura[row+1] = tmp
		
-- 		local f1 = HDH_GetRowFrame(ListFrame, row)
-- 		local f2 = HDH_GetRowFrame(ListFrame, row+1)
-- 		CrateAni(f1)
-- 		CrateAni(f2)
-- 		f2.ani.func = HDH_LoadAuraListFrame
-- 		f2.ani.args = {GetTrackerIndex(), row, row+1}
-- 		StartAni(f1, ANI_MOVE_DOWN)
-- 		StartAni(f2 , ANI_MOVE_UP)
-- 		--HDH_LoadAuraListFrame(CurUnit, row, row+1)
-- 	end
-- 	local t = HDH_AT_OP_GetTracker(GetTrackerIndex())
-- 	if t then t:InitIcons() end
-- end

-------------------------------------------------------------
-- DropDown 
-------------------------------------------------------------

local TEXT_DD_MULTI_SELETED = "%d 개 선택됨"

HDH_AT_DropDownMixin = {
    globals= {"HDH_AT_DropDownMixin"}

}

function HDH_AT_DropDown_OnEnteredItem(self)
    local dropdownBtn = self:GetParent():GetParent()
    -- dropdownBtn:SetSelectIdx(self.idx, true)
    dropdownBtn.onEnterHandler(dropdownBtn, self, self.idx, self.value)
end

function HDH_AT_DropDown_OnSelectedItem(self)
    local dropdownBtn = self:GetParent():GetParent()
    dropdownBtn:SetSelectIdx(self.idx)
    dropdownBtn.onClickHandler(dropdownBtn, self, self.idx, self.value)
end

function HDH_AT_DropDown_OnCheckButon(self)
    local dropdownBtn = self:GetParent():GetParent():GetParent()
    dropdownBtn.selectedValueCount = dropdownBtn.selectedValueCount or 0
    if self:GetChecked() then
        dropdownBtn.selectedValueCount = dropdownBtn.selectedValueCount + 1
    else
        dropdownBtn.selectedValueCount = max(dropdownBtn.selectedValueCount - 1, 0)
    end

    _G[dropdownBtn:GetName().."Text"]:SetText(string.format(TEXT_DD_MULTI_SELETED, dropdownBtn.selectedValueCount))

    dropdownBtn.onClickHandler(dropdownBtn, self:GetParent(), self:GetParent().idx, self:GetParent().value)
end

function HDH_AT_DropDownMixin:GetSelectedValue()

    if self.multiSelector then
        local listFrame = _G[self:GetName().."List"]
        local items = self.item
        local ret = {}
        for i, item in ipairs(items) do
            if item.CheckButton and item.CheckButton:GetChecked() then
                ret[#ret + 1] = item.value
            end
        end
        return ret
    else
        if self.selectedIdx then
            return self.value
        else
            return nil
        end
    end
end

function HDH_AT_DropDownMixin:Size()
    local listFrame = _G[self:GetName().."List"]
    local items = self.item  or {}
    local size = 0
    for i, item in ipairs(items) do
        if item:IsShown() then
            size = size + 1
        end
    end

    return size
end

function HDH_AT_DropDownMixin:Reset()
    local listFrame = _G[self:GetName().."List"]
    local items = self.item or {}

    for _, item in ipairs(items) do
        item:Hide()
        item.idx = nil
        item.value = nil
        item.name = nil
        item.texture = nil
    end
    self:SelectClear()
end

function HDH_AT_DropDownMixin:SelectClear()
    local listFrame = _G[self:GetName().."List"]
    local items = self.item
    if self:Size() == 0 then
        _G[self:GetName().."Text"]:SetText(L.NOTHING_LIST)
        _G[self:GetName().."Text"]:SetFontObject("Font_GRAY_S")
        if _G[self:GetName().."Texture"] then
            _G[self:GetName().."Texture"]:SetTexture()
        end
        listFrame:SetHeight(1)
    else
        if self.multiSelector then
            for i, item in ipairs(items) do
                if item.CheckButton then
                    item.CheckButton:SetChecked(false)
                end
            end
            self.selectedValueCount = 0
            _G[self:GetName().."Text"]:SetText(string.format(TEXT_DD_MULTI_SELETED, selectedValueCount))
        else
            for i, child in ipairs(items) do
                _G[child:GetName().."On"]:Hide()
            end

            self.selectedIdx = nil
            self.value = nil
            _G[self:GetName().."Text"]:SetText(L.SELECT)
            _G[self:GetName().."Text"]:SetFontObject("Font_Gray_S")
        end
    end
end

function HDH_AT_DropDownMixin:GetValue(idx)
    local items = self.item
    print(items[idx], "idx", idx, items[idx].value)
    if items[idx] then
        return items[idx].value
    else
        return nil
    end
end

function HDH_AT_DropDownMixin:SetSelectValue(value)
    local listFrame = _G[self:GetName().."List"]
    local items = self.item
    if self.multiSelector then
        local selectedValueCount = 0
        for i, item in ipairs(items) do
            if item.CheckButton then
                if hasValue(value, item.value) then
                    item.CheckButton:SetChecked(true)
                    selectedValueCount = selectedValueCount + 1
                else
                    item.CheckButton:SetChecked(false)
                end
            end
        end
        self.selectedValueCount = selectedValueCount
       _G[self:GetName().."Text"]:SetText(string.format(TEXT_DD_MULTI_SELETED, selectedValueCount))
       return selectedValueCount
    else
        local idx = nil
        for i, item in ipairs(items) do
            if item.value == value then
                self:SetSelectIdx(i)
                idx = i
                break
            end
            
        end
        return idx
    end
end

function HDH_AT_DropDownMixin:SetSelectIdx(idx, show)
    local listFrame = _G[self:GetName().."List"]
    local items = self.item
    show = show or false

    if not multiSelector then
        if idx <= 0 or idx > #items then return end
        local seletedItemFrame = items[idx]
        for i, child in ipairs(items) do
            if i ~= idx then 
                _G[child:GetName().."On"]:Hide()
            else
                _G[child:GetName().."On"]:Show()
            end
        end

        if not show and not self.always_show_list then
            listFrame:Hide()
        end
        _G[self:GetName().."Text"]:SetText(seletedItemFrame.name)
        _G[self:GetName().."Text"]:SetFontObject("Font_White_S")
        if _G[self:GetName().."Texture"] then
            local t = _G[self:GetName().."Texture"]
            if self.useAtlasSize then
                t:SetAtlas(seletedItemFrame.texture)
            else
                t:SetTexture(seletedItemFrame.texture) 
            end
        end
        self.selectedIdx = idx
        self.value = seletedItemFrame.value
        -- self.handler(dropdownBtn, self, self.idx, dropdownBtn.value)
    end
end

function HDH_AT_DropDownMixin:SetText(name)
    self.Text:SetText(name)
end

function HDH_AT_DropDownMixin:UseAtlasSize(bool)
    self.useAtlasSize = bool
end

function HDH_AT_DropDownMixin:GetItem()
    return self.item
end

function HDH_AT_DropDown_Init(frame, itemValues, onClickHandler, onEnterHandler, template, multiSelector, always_show_list)
    local multiSelector = multiSelector or false
    local listFrame = _G[frame:GetName().."List"]
    local itemFrame
    template = template or "HDH_AT_DropDownOptionItemTemplate"
    itemValues = itemValues or {}
    frame.always_show_list = always_show_list or false
    local id, name, texture
    local totalHeight = 1
    frame.item = frame.item or {}
    local item = frame.item
    local template_name 
    if #itemValues > 0 then    
        for i = 1, #itemValues do
            id, name, texture, handler = unpack(itemValues[i])
            if type(template) == 'table' then
                template_name = template[i]
            else
                template_name = template
            end

            if item[i] then
                if template_name ~= item[i].template_name then
                    item[i]:Hide()
                    item[i]:SetParent(nil)
                    item[i] = nil
                    itemFrame = CreateFrame("Button", listFrame:GetName().."i"..time()..i, listFrame, template_name)
                    item[i] = itemFrame
                else
                    itemFrame = item[i]
                    itemFrame:Show()
                end
            else
                itemFrame = CreateFrame("Button", listFrame:GetName().."i"..time()..i, listFrame, template_name)
                item[i] = itemFrame
            end

            itemFrame:SetPoint("TOPLEFT", listFrame, "TOPLEFT", 1, -totalHeight)
            itemFrame:SetPoint("RIGHT", listFrame, "RIGHT", -1, 0)
            _G[itemFrame:GetName().."Text"]:SetText(name)
            if texture then
                local t = _G[itemFrame:GetName().."Texture"]
                if frame.useAtlasSize then
                    t:SetAtlas(texture)
                else
                    t:SetTexture(texture) 
                end
            end
            
            if onClickHandler then
                itemFrame:SetScript("OnClick", HDH_AT_DropDown_OnSelectedItem)
                frame.onClickHandler = onClickHandler
            end
            if onEnterHandler then
                itemFrame:SetScript("OnEnter", HDH_AT_DropDown_OnEnteredItem)
                frame.onEnterHandler = onEnterHandler
            end

            if itemFrame.CheckButton then
                itemFrame.CheckButton:SetScript("OnClick", HDH_AT_DropDown_OnCheckButon)
            end
            itemFrame.template_name= template_name
            itemFrame.idx = i
            itemFrame.value = id
            itemFrame.name = name
            itemFrame.texture = texture
            totalHeight = totalHeight + itemFrame:GetHeight()
        end

        -- if selectedIdx > 0 and selectedIdx == i then
        --     if icon then btn.ICON:SetTexture(icon) end
        --     btn.TEXT:SetText(name)
        --     _G[list.item[i]:GetName().."On"]:Show()
        -- else
        --     _G[list.item[i]:GetName().."On"]:Hide()
        -- end
        if(not always_show_list) then
            local height = totalHeight + 1
            listFrame:SetHeight(height) 
        else
            frame:SetHeight(totalHeight-2) 
            listFrame:SetHeight(totalHeight+1) 
            listFrame:Show()
            listFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
            listFrame:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, 0)
            frame.Text:Hide()
            if frame.RightText then
                frame.RightText:Hide()
                frame.BG:Hide()
            end
        end
    end

	if #item > #itemValues then
		for i = #itemValues+1, #item do
			item[i]:Hide()
		end
	end

    if #itemValues == 0 then
        _G[frame:GetName().."Text"]:SetText(L.NOTHING_LIST)
        listFrame:SetHeight(1)
    else
        frame.selectedIdx = nil
        frame.value = nil
        if multiSelector then
            _G[frame:GetName().."Text"]:SetText(string.format(TEXT_DD_MULTI_SELETED, 0))
            _G[frame:GetName().."Text"]:SetFontObject("Font_White_S")            
            
        else
            _G[frame:GetName().."Text"]:SetText(L.SELECT)
            _G[frame:GetName().."Text"]:SetFontObject("Font_Gray_S")
        end
    end

    if not always_show_list then
        listFrame:SetScript("OnShow", function(self)
            table.insert(UISpecialFrames, listFrame:GetName())
            -- table.insert(UIMenus, listFrame:GetName())
            listFrame:EnableKeyboard(1)
        end)
    end

    frame.multiSelector = multiSelector
end

function HDH_AT_DropDown_OnShow(self)
    _G[self:GetName().."Text"]:SetWidth(50)
end

function HDH_AT_DropDown_OnLoad(self)
    _G[self:GetName().."Text"]:SetText(L.SELECT)
    _G[self:GetName().."Text"]:SetFontObject("Font_Gray_S")

    -- local font = self:GetNormalFontObject()
    -- -- _G[self:GetName().."Text"]:ClearAllPoints()
    -- font:SetPoint("TOPLEFT", self, "TOPLEFT", 0,0)
    -- font:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", 0,0)
end


function HDH_AT_DropDown_OnLeave(self)
    if not self.always_show_list and not _G[self:GetName().."List"]:IsMouseOver() then
        -- _G[self:GetName().."List"]:Hide()
    end
end

local function CheckMouseOver(frame) 
    local children = frame:GetChildren()
    if #children >= 1 then
        for _, child in ipairs(children) do
            if CheckMouseOver(child) then
                return true
            end
            if child:IsMouseOver() then
                return true
            end
        end
    end
    return false
end


function HDH_AT_DropDownList_OnLeave(self)
    -- print("asdf")
    -- local parent = self:GetParent()
    -- if not parent.always_show_list and not self:GetParent():IsMouseOver() then
    --     local show = CheckMouseOver(self)
    --     if not show then
    --         self:Hide()
    --     end
    -- end
end

function HDH_AT_DropDownItem_OnLeave(self)
    -- local parent = self:GetParent()
    -- if not parent:GetParent().always_show_list and not parent:IsMouseOver() and not parent:GetParent():IsMouseOver() then
    --     local hide = true
    --     for _, child in ipairs(parent:GetParent().item) do
    --         if child:IsMouseOver() then
    --             hide = false
    --             break
    --         end
    --     end
    --     if hide then
    --         parent:Hide()
    --     end
    -- end
end


------------------------------------------------------------------
-- SLIDER
------------------------------------------------------------------

HDH_AT_SliderMixin = {}

local function SliderValueFormat(self, value)
    if (self.enableInt) then
        value = math.floor(value + 0.5)
    else
        value = math.floor( (value) * 10 ) / 10
    end
    return value
end

function HDH_AT_SliderMixin:UpdateMinMaxValues(value)
    local min, max
    if self.dynamic then
        min = value - self.range
        max = value + self.range
        max = math.min(max, self.max)
        min = math.max(min, self.min)
    else
        min = self.min
        max = self.max
    end
    self:SetMinMaxValues(min, max)
    self.MinValue:SetText(min)
    self.MaxValue:SetText(max)
    return self.dynamic
end

function HDH_AT_OnValueChanged_Slider(self, value)
    value = SliderValueFormat(self, value)
    -- local dy = UpdateMinMaxValues(self, value)
    -- if not dy then
    --     self.MinValue:SetText(min)
    --     self.MaxValue:SetText(max)
    -- end
    self:SetValue(value)
    self.Value:SetText(value)
end

function HDH_AT_OnMouseUp_Slider(self)
    local value = SliderValueFormat(self, self:GetValue())
    self:UpdateMinMaxValues(value)
    self.handler(self, value)
end

function HDH_AT_SliderMixin:UpdateValue(value)
    value = SliderValueFormat(self, value)
    self:UpdateMinMaxValues(value)
    self:SetValue(value)
    self.Value:SetText(value)
end

function HDH_AT_SliderMixin:Init(value, min, max, enableInt, dynamic, range)
    self.min = min or 0  
    self.max = max or 20
    self.enableInt = enableInt or false
    self.dynamic = dynamic or false
    self.range = range or 10
    self:UpdateMinMaxValues(value)
    self:SetValue(value)
    -- HDH_AT_OnMouseUp_Slider(self)
end

function HDH_AT_SliderMixin:SetHandler(handler)
    self.handler = handler
end

----------------------------------------------------------------
-- Color Picker 
----------------------------------------------------------------

HDH_AT_ColorPickerMixin = {}

function HDH_AT_ColorPickerMixin:SetColorRGBA(r, g, b, a)
    self.rgba = {r, g, b, a}
    self.Color:SetVertexColor(r, g, b, a)
end

function HDH_AT_ColorPickerMixin:GetColorRGBA()
    return unpack(self.rgba)
end

function HDH_AT_ColorPickerMixin:SetEnableAlpha(enable)
    self.enableAlpha = enable
end

function HDH_AT_ColorPickerMixin:SetHandler(handler)
    self.handler = handler
end

local function OnSelectedColorPicker()
    if ColorPickerFrame:IsShown() or ColorPickerFrame.buttonFrame == nil then return end
    self = ColorPickerFrame.buttonFrame
    local r, g, b  = ColorPickerFrame:GetColorRGB()
    self:SetColorRGBA(r, g, b, OpacitySliderFrame:GetValue())
    self.handler(self, r, g, b, OpacitySliderFrame:GetValue())
    ColorPickerFrame.buttonFrame = nil
end

local function OnCancelColorPicker()    
    ColorPickerFrame.buttonFrame:SetColorRGBA(unpack(ColorPickerFrame.previousValues))
end

function HDH_AT_OnClickColorPicker(self, enableAlpha)
	self.enableAlpha = self.enableAlpha or true;
	if ColorPickerFrame:IsShown() then return end
	ColorPickerFrame.colorButton = self
	local r, g, b, a = self:GetColorRGBA()
	a = a and a or 1;
	if self.enableAlpha then
		ColorPickerFrame.opacity = a
		OpacitySliderFrame:SetValue(a)
    end
    -- ColorPickerOkayButton:SetScript("OnClick", OnSelectedColorPicker)
    ColorPickerFrame.func = (function() end)
    ColorPickerFrame.cancelFunc = OnCancelColorPicker
    ColorPickerFrame.buttonFrame = self
	ColorPickerFrame.previousValues = {r, g, b, a};
	ColorPickerFrame.hasOpacity = self.enableAlpha;
	ColorPickerFrame:SetColorRGB(r, g, b);
	ColorPickerFrame:Show()
end

ColorPickerOkayButton:HookScript("OnClick", OnSelectedColorPicker)

-- hooksecurefunc(ColorPickerOkayButton, "OnClick", OnSelectedColorPicker)

------------------------------------------------------------------------
--
------------------------------------------------------------------------

HDH_AT_TrackerTapBtnTemplateMixin = {}

function HDH_AT_TrackerTapBtnTemplateMixin:SetActivate(bool)
    if bool then
        -- _G[self:GetName().."Border1"]:Show()
        -- _G[self:GetName().."Border2"]:Show()
        -- _G[self:GetName().."Border3"]:Show()
        -- _G[self:GetName().."Border4"]:Show()
        -- _G[self:GetName().."Border5"]:Show()
        -- _G[self:GetName().."Border6"]:Show()
        -- _G[self:GetName().."Border7"]:Show()
        -- _G[self:GetName().."BgLine1"]:Show()
        _G[self:GetName().."BgLine2"]:Show()
        _G[self:GetName().."On"]:Show()
        
        self.BG:SetColorTexture(0,0,0,0.5)
        self.Text:SetTextColor(1,0.8,0)
    else
        -- _G[self:GetName().."Border1"]:Hide()
        -- _G[self:GetName().."Border2"]:Hide()
        -- _G[self:GetName().."Border3"]:Hide()
        -- _G[self:GetName().."Border4"]:Hide()
        -- _G[self:GetName().."Border5"]:Hide()
        -- _G[self:GetName().."Border6"]:Hide()
        -- _G[self:GetName().."Border7"]:Hide()
        -- _G[self:GetName().."BgLine1"]:Hide()
        _G[self:GetName().."BgLine2"]:Hide()
        _G[self:GetName().."On"]:Hide()
        self.BG:SetColorTexture(0,0,0,0.3)
        self.Text:SetTextColor(0.8,0.8,0.8)
    end
end


-----------------------------------
-- dlalog
-----------------------------------

HDH_AT_DialogFrameTemplateMixin = {}
HDH_AT_DialogFrameTemplateMixin.DLG_TYPE = {OK =1, YES_NO=2, EDIT=3, NONE= 4};

function HDH_AT_DialogFrameTemplateMixin:AlertShow(msg, type, func, cancelFunc, ...)
    local main = self:GetParent()
    type = type or self.DLG_TYPE.OK
	if self:IsShown() then return end
	self.text = msg;
	self.dlg_type = type;
	self.func = func;
    self.cancelFunc = cancelFunc;
	self.arg = {...};
	self:Show();
end

function HDH_AT_DialogFrameTemplateMixin:Close()
	self:Hide();
end 