
-- #########  �׼ǹ� �Ÿ��� ���� ������ ������ ����   ##########

-- ��ų  ��� ���� ���θ� �Ǵ��Ͽ� ������ ��ü ������ �����ϴ� �Լ���, 
-- ��ȿ���������� ��¿�� ���� ���ʿ� ������ ������ �����ؾ���
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
