include('shared.lua')

SWEP.VElements = {
	["emp"] = { type = "Model", model = "models/alyx_emptool_prop.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 1.2, 0), angle = Angle(-80, 16, -5.844), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["el1"] = { type = "Model", model = "models/alyx_emptool_prop.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.599, 1.5, -0.519), angle = Angle(-80, 16, -5.844), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
util.PrecacheModel("models/alyx_emptool_prop.mdl")

function SWEP:Initialize()
  self:SetHoldType(self.HoldType)
  local EMPModel=ClientsideModel("models/alyx_emptool_prop.mdl")

  self.EMP=EMPModel --model
	if IsValid(self.Owner) then
	  local vm = self.Owner:GetViewModel()
	  if IsValid(vm) then
	    self:ResetView(vm)
		else
			self:UpdateWorldModel()
		end
		--open it
		self.EMP:SetSequence(2)
	else
		--stay closed
		self.EMP:SetSequence(1)
	end
  self.EMP:SetNoDraw(true) --will draw it in Draw()
  self.EMP:SetParent(self)
  self.EMP:Spawn()
end


local material=Material("cable/blue_elec")
function SWEP:DrawWorldModel()
  self:UpdateWorldModel()
  self.EMP:DrawModel()
  if self:GetFiring() then
    local trace=util.TraceLine(util.GetPlayerTrace(self.Owner))
    if trace.Hit then
      render.SetMaterial(material)
      render.DrawBeam( self.EMP:LocalToWorld(Vector(4,0,0)), trace.HitPos, 5, -math.random(0.3,1),math.random(0.3,1) , Color(255,255,255,180))
    end
  end
end



function SWEP:ViewModelDrawn()
  local vm = self.Owner:GetViewModel()
  if IsValid(vm) then
    self:ResetView(vm)
  end
  self.EMP:DrawModel()
  if self:GetFiring() then
    local trace=util.TraceLine(util.GetPlayerTrace(self.Owner))
    if trace.Hit then
      render.SetMaterial(material)
      render.DrawBeam( self.EMP:LocalToWorld(Vector(4,0,0)), trace.HitPos, 5, -math.random(0.3,1),math.random(0.3,1) , Color(255,255,255,180))
    end
  end
end

function SWEP:Deploy()
  self.EMP:SetSequence(2)
  local vm = self.Owner:GetViewModel()
  if IsValid(vm) then
    self:ResetView(vm)
  end
  return true
end

function SWEP:UpdateWorldModel()
	--dropped
	if not IsValid(self.Owner) then
		self.EMP:SetPos(self:GetPos())
		self.EMP:SetAngles(self:GetAngles())
	else
		--holding
	  local PosW,AngW=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")) //world model
	  self.EMP:SetPos(PosW+AngW:Right()*(self.WElements.el1.pos.y)+AngW:Forward()*(self.WElements.el1.pos.x)+AngW:Up()*(self.WElements.el1.pos.z))
	  AngW:RotateAroundAxis(AngW:Up(),self.WElements.el1.angle.y)
	  AngW:RotateAroundAxis(AngW:Right(),self.WElements.el1.angle.p)
	  AngW:RotateAroundAxis(AngW:Forward(),self.WElements.el1.angle.r)
	  self.EMP:SetAngles(AngW)
	end
end

function SWEP:ResetView(vm)
  local ind1=vm:LookupBone("ValveBiped.Bip01_R_Hand")
  vm:ManipulateBoneScale(vm:LookupBone("ValveBiped.base"),Vector(0.01,0.01,0.01))
  vm:ManipulateBoneScale(vm:LookupBone("ValveBiped.clip"),Vector(0.01,0.01,0.01))
  vm:ManipulateBoneScale(vm:LookupBone("ValveBiped.square"),Vector(0.01,0.01,0.01))
  vm:ManipulateBoneScale(vm:LookupBone("ValveBiped.hammer"),Vector(0.01,0.01,0.01))

  local PosV,AngV=vm:GetBonePosition(vm:LookupBone("ValveBiped.Bip01_R_Hand"))//view model
  self.EMP:SetPos(PosV+AngV:Forward()*(self.VElements["emp"].pos.x)+
        AngV:Right()*(self.VElements["emp"].pos.y)+
                AngV:Up()*(self.VElements["emp"].pos.z))
  AngV:RotateAroundAxis(AngV:Up(),self.VElements["emp"].angle.y)
  AngV:RotateAroundAxis(AngV:Right(),self.VElements["emp"].angle.p)
  AngV:RotateAroundAxis(AngV:Forward(),self.VElements["emp"].angle.r)
  self.EMP:SetAngles(AngV)
end

function SWEP:OnRemove()
  if  self.EMP:IsValid() then
    self.EMP:Remove()
  end
end

function SWEP:Holster(wep)
  self.EMP:SetSequence(1)
  return true
end
