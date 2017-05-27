-- Add contour when civilian is tied
if RequiredScript == "lib/units/civilians/logics/civilianlogicsurrender" then
local on_tied_original = CivilianLogicSurrender.on_tied
function CivilianLogicSurrender.on_tied(data, aggressor_unit, not_tied, can_flee)
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
	return on_tied_original(data, aggressor_unit, not_tied, can_flee)
end

-- Remove contour when civilian is freed
local exit_original = CivilianLogicSurrender.exit
function CivilianLogicSurrender.exit(data, new_logic_name, enter_params)
	if data.internal_data.is_hostage then
		local contour = data.unit:contour()
		if contour then
			contour:remove("medic_heal", true)
		end
	end
	return exit_original(data, new_logic_name, enter_params)
end
end

-- Remove contour when civilian is killed
if RequiredScript == "lib/units/civilians/civiliandamage" then
local die_original = CivilianDamage.die
function CivilianDamage:die(variant)
	if self._unit:brain():is_tied() then
		local contour = self._unit:contour()
		if contour then
			contour:remove("medic_heal", true)
		end
	end
	return die_original(self, variant)
end
end

-- Add contour when civilian lies down after moving
if RequiredScript == "lib/managers/group_ai_states/groupaistatebase" then
local on_hostage_follow_original = GroupAIStateBase.on_hostage_follow
function GroupAIStateBase:on_hostage_follow(owner, follower, state)
	if not state then
		local contour = follower:contour()
		if contour then
			contour:add("medic_heal", true, 86400)
		end
	end
	return on_hostage_follow_original(self, owner, follower, state)
end
end