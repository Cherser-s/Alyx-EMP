
local basic_handlers = {
	gmod_combine_lock={
		Handle_Mouse1=function(caller,ent)
			ent:Backdoor()
		end,
		Handle_Mouse2=function(ent)

		end
	},
	npc_rollermine={
		Handle_Mouse1=function(caller,ent)
			local hacked=ent:GetSaveTable().m_bHackedByAlyx
			if hacked then
				ent:SetSaveValue( "m_bHackedByAlyx", false )
				ent:SetSubMaterial(0,"models/roller/rollermine_sheet")
				ent:SetSubMaterial(1,"models/roller/rollermine_glow")
			else
				ent:SetSaveValue( "m_bHackedByAlyx", true )
				ent:SetSubMaterial(0,"models/Roller/rollermine_hacked")
				ent:SetSubMaterial(1,"models/roller/rollermine_gloworange")
			end
		end,
		Handle_Mouse2=function(caller,ent)
				--should explode here
		end
	},
	func_door={
		Handle_Mouse1=function(caller,ent)
			ent:Fire("Toggle","0")
		end,
		Handle_Mouse2=function(caller,ent)

		if ent:GetSaveTable().m_bLocked then
			ent:Fire("Unlock","0")
		else
			ent:Fire("Lock","0")
		end

	end},
	prop_dynamic={
		Handle_Mouse1=function(caller,ent)
      --check models
			local seq=ent:GetSaveTable().sequence
			if seq==2 then
				ent:Fire("setanimation","close",0)
			elseif (seq==3 or seq==0 or seq == 1) then
				ent:Fire("setanimation","open",0)
			end
		end,
		Handle_Mouse2=function(caller,ent)

		end
	},

	gmod_wire_combine_sensor_lock={
		Handle_Mouse1=function(caller,ent)
			ent:Backdoor()
		end,
		Handle_Mouse2=function(caller,ent)

		end
	},

	prop_door_rotating={
		Handle_Mouse1=function(caller,ent)
			ent:Fire("Toggle","0")
		end,
		Handle_Mouse2=function(caller,ent)

			if ent:GetSaveTable().m_bLocked then
				ent:Fire("Unlock","0")
			else
				ent:Fire("Lock","0")
			end

		end
	}
}
WEAPON_ALYX_EMP.EMPHandlers:AddHandlers(basic_handlers)
