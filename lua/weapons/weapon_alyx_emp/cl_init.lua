include('shared.lua')

SWEP.VElements = {
	["emp"] = { type = "Model", model = "models/alyx_emptool_prop.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 1.2, 0), angle = Angle(-90, 75.973, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

SWEP.WElements = {
	["el1"] = { type = "Model", model = "models/alyx_emptool_prop.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.599, 1.5, -0.519), angle = Angle(-90, 106.363, -5.844), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
util.PrecacheModel("models/alyx_emptool_prop.mdl")

function SWEP:Initialize()
  self:SetHoldType(self.HoldType)
  local vm = self.Owner:GetViewModel()

  self:SetNoDraw(true)
  local tab=self:GetTable()
  local vm=self.Owner:GetViewModel()
  local EMPModel=ClientsideModel("models/alyx_emptool_prop.mdl")
  local ind1=vm:LookupBone("ValveBiped.Bip01_R_Hand")
  vm:ManipulateBoneScale(vm:LookupBone("ValveBiped.base"),Vector(0.01,0.01,0.01))
  vm:ManipulateBoneScale(vm:LookupBone("ValveBiped.clip"),Vector(0.01,0.01,0.01))
  vm:ManipulateBoneScale(vm:LookupBone("ValveBiped.square"),Vector(0.01,0.01,0.01))
  vm:ManipulateBoneScale(vm:LookupBone("ValveBiped.hammer"),Vector(0.01,0.01,0.01))
  local PosV,AngV=vm:GetBonePosition(ind1)//view model
  EMPModel:SetPos(PosV+AngV:Forward()*(self.VElements["emp"].pos.x)+
    AngV:Right()*(self.VElements["emp"].pos.y)+
      AngV:Up()*(self.VElements["emp"].pos.z))
  EMPModel:SetAngles(AngV)
  EMPModel:SetNoDraw(true) --will draw it in Draw()

  EMPModel:SetParent(self)
  EMPModel:SetAngles(AngV)

  local EMPModel2=ents.CreateClientProp("models/alyx_emptool_prop.mdl")
  EMPModel2:SetNoDraw(true) --will draw it in Draw()
  EMPModel2:SetParent(self)

  local ind2=self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")
  local PosW,AngW=self.Owner:GetBonePosition(ind2)//world model
  EMPModel2:SetPos(PosW+AngW:Forward()*(self.WElements["el1"].pos.x)+
    AngW:Right()*(self.WElements["el1"].pos.y)+
      AngW:Up()*(self.WElements["el1"].pos.z))
  EMPModel2:SetAngles(AngW)
  EMPModel:Spawn()
  EMPModel2:Spawn()
  tab.EMP=EMPModel --view model
  tab.EMPW=EMPModel2 -- world model
  self.VDrawn=false
  self:SetTable(tab)
  self.EMP:SetSequence(2)
  self.EMPW:SetSequence(2)
end


local material=Material("cable/blue_elec")
function SWEP:DrawWorldModel()
  local PosW,AngW=self.Owner:GetBonePosition(self.Owner:LookupBone("ValveBiped.Bip01_R_Hand")) //world model
  self.EMPW:SetPos(PosW+AngW:Right()*(self.WElements.el1.pos.y)+AngW:Forward()*(self.WElements.el1.pos.x)+AngW:Up()*(self.WElements.el1.pos.z))
  AngW:RotateAroundAxis(AngW:Up(),self.WElements.el1.angle.y)
  AngW:RotateAroundAxis(AngW:Right(),self.WElements.el1.angle.p)
  AngW:RotateAroundAxis(AngW:Forward(),self.WElements.el1.angle.r)
  self.EMPW:SetAngles(AngW)
  self.EMPW:DrawModel()
  self.VDrawn=false
  if self:GetFiring() then
    local trace=util.TraceLine(util.GetPlayerTrace(self.Owner))
    if trace.Hit then
      render.SetMaterial(material)
      render.DrawBeam( self.EMPW:LocalToWorld(Vector(4,0,0)), trace.HitPos, 5, -math.random(0.3,1),math.random(0.3,1) , Color(255,255,255,180))
    end
  end
end



function SWEP:ViewModelDrawn()
  local PosV,AngV=self.Owner:GetViewModel():GetBonePosition(self.Owner:GetViewModel():LookupBone("ValveBiped.Bip01_R_Hand"))//view model
  self.EMP:SetPos(PosV+AngV:Forward()*(self.VElements["emp"].pos.x)+
        AngV:Right()*(self.VElements["emp"].pos.y)+
                AngV:Up()*(self.VElements["emp"].pos.z))
  AngV:RotateAroundAxis(AngV:Up(),self.VElements["emp"].angle.y)
  AngV:RotateAroundAxis(AngV:Right(),self.VElements["emp"].angle.p)
  AngV:RotateAroundAxis(AngV:Forward(),self.VElements["emp"].angle.r)
  self.EMP:SetAngles(AngV)
  self.EMP:DrawModel()
  self.VDrawn=true
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
  self.EMPW:SetSequence(2)
  return true
end

function SWEP:OnRemove()
  if  self.EMP:IsValid() then
    self.EMP:Remove()
  end
  if  self.EMPW:IsValid() then
    self.EMPW:Remove()
  end
end

function SWEP:Holster(wep)
  self.EMP:SetSequence(1)
  self.EMPW:SetSequence(1)

  return true
end
