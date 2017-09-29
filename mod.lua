-- Add contour when civilian is tied
if RequiredScript == "lib/units/civilians/logics/civilianlogicsurrender" then
Hooks:PreHook(CivilianLogicSurrender, "on_tied", "HostageOutlines_CivilianLogicSurrender.on_tied", function(data, aggressor_unit, not_tied, can_flee)
		if not data.is_tied and not not_tied then
			local contour = data.unit:contour()
			if contour then
				contour:add("medic_heal", true, 86400)
			end
		else
			local contour = data:contour()
			if contour then
				contour:remove("medic_heal", true)
			end
		end
end)

-- Remove contour when civilian is freed
Hooks:PreHook(CivilianLogicSurrender, "exit", "HostageOutlines_CivilianLogicSurrender.exit", function(data, new_logic_name, enter_params)
	if data.internal_data.is_hostage then
		local contour = data.unit:contour()
		if contour then
			contour:remove("medic_heal", true)
		end
	end
end)
end

-- Remove contour when civilian is killed
if RequiredScript == "lib/units/civilians/civiliandamage" then
Hooks:PreHook(CivilianDamage, "die", "HostageOutlines_CivilianDamage.die", function (self, ...)
	if self._unit:brain():is_tied() then
		local contour = self._unit:contour()
		if contour then
			contour:remove("medic_heal", true)
		end
	end
end)
end

-- Add contour when civilian lies down after moving
if RequiredScript == "lib/managers/group_ai_states/groupaistatebase" then
Hooks:PreHook(GroupAIStateBase, "on_hostage_follow", "HostageOutlines_GroupAIStateBase.on_hostage_follow", function(self, owner, follower, state)
	if not state then
		local contour = follower:contour()
		if contour then
			contour:add("medic_heal", true, 86400)
		end
	end
end)
end