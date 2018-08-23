
-- #########  액션바 거리에 따른 아이콘 빨간색 변경   ##########

-- 스킬  사용 가능 여부를 판단하여 아이콘 전체 색상을 조율하는 함수라서, 
-- 비효율적이지만 어쩔수 없이 이쪽에 아이콘 색상을 변경해야함
hooksecurefunc("ActionButton_UpdateUsable", function(self)
	if (IsActionInRange(self.action) == false) then
		self.icon:SetVertexColor(1.0,0.1,0.1)
	end
end)

hooksecurefunc("ActionButton_OnEvent", function(self, event, ...)
	if(event == "PLAYER_TARGET_CHANGED") then
		self.tmpTimer = self.rangeTimer
	end
end)

hooksecurefunc("ActionButton_OnUpdate", function(self, elapsed)
	if(self.tmpTimer) then
		self.tmpTimer = self.tmpTimer - elapsed
		
		if (self.tmpTimer <= 0) then
			ActionButton_UpdateUsable(self)
			self.tmpTimer = TOOLTIP_UPDATE_TIME
		end
	end
end)
