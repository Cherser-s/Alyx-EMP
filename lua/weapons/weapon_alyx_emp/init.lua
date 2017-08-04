AddCSLuaFile('shared.lua')
AddCSLuaFile('cl_init.lua')

include("includes/EMP_Handler/EMPHandler.lua")
include("includes/EMP_Handler/basic_handlers.lua")
include('shared.lua')


function SWEP:Initialize()
  self:SetHoldType(self.HoldType)
end

function SWEP:Think()
  local function checkContinueFire()
    local trace = util.TraceLine( {
      start = self.Owner:EyePos(),
    endpos = self.Owner:EyePos() + self.Owner:EyeAngles():Forward() * self.FireRange,
      filter = function(ent)
        if ent==self.Owner then
          return false
        end
        return true
      end
      } )
    if self:GetTargetEntity()!=trace.Entity then
      self:SetFiring(false)
    end
  end
  if self:GetFiring() then
    if self:LastShootTime() + self.WaitTime < CurTime() then
      if self:GetPrimaryAttack() then
        WEAPON_ALYX_EMP.EMPHandlers:Trigger(self,self:GetTargetEntity(),1)
      else
        WEAPON_ALYX_EMP.EMPHandlers:Trigger(self,self:GetTargetEntity(),2)
      end
      self:SetFiring(false)
    else
      checkContinueFire()
    end
  end
end

function SWEP:PrimaryAttack()
  local trace = util.TraceLine( {
  start = self.Owner:EyePos(),
endpos = self.Owner:EyePos() + self.Owner:EyeAngles():Forward() * self.FireRange,
  filter = function(ent)
    if ent==self.Owner then return false end
    return true
  end
  } )
  if (trace.Entity and trace.Entity:IsValid()) then

    if (WEAPON_ALYX_EMP.EMPHandlers:CanTrigger(self,trace.Entity)) then
      self:EmitSound(FireSound or Sound("weapons/stunstick/alyx_stunner2.wav"))
      self:SetTargetEntity(trace.Entity)
      self:SetFiring(true)
      self:SetPrimaryAttack(true)
      self:SetLastShootTime()
    else

    end
    self:SetNextPrimaryFire(CurTime()+1.5)
    self:SetNextSecondaryFire(CurTime()+1.5)
  end
end

function SWEP:SecondaryAttack()
    --if game.SinglePlayer() then self:CallOnClient("SecondaryAttack") end

  local trace = util.TraceLine( {
  start = self.Owner:EyePos(),
  endpos = self.Owner:EyePos() + self.Owner:EyeAngles():Forward() * self.FireRange,
  filter = function(ent) if ent==self.Owner then return false end return true end
  } )
  if (trace.Entity and trace.Entity:IsValid()) then

    if (WEAPON_ALYX_EMP.EMPHandlers:CanTrigger(self,trace.Entity)) then
      self:EmitSound(FireSound or Sound("weapons/stunstick/alyx_stunner2.wav"))
      self:SetTargetEntity(trace.Entity)
      self:SetFiring(true)
      self:SetPrimaryAttack(false)
      self:SetLastShootTime()
    else

    end
    self:SetNextPrimaryFire(CurTime()+1.5)
    self:SetNextSecondaryFire(CurTime()+1.5)
  end
end

function SWEP:Deploy()
	if game.SinglePlayer() then
    self:CallOnClient("Deploy")
  end
  return true
end

function SWEP:Holster(wep)
	if game.SinglePlayer() then
		self:CallOnClient("Holster")
	end
  return true
end
