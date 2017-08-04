

local EMP = {}
EMP.__index = EMP

function EMP:New()
  local instance = {}
  instance.Handlers = {}
  setmetatable(instance,EMP)
  return instance
end

function EMP:AddHandler(enttype,handler)
  if self.Handlers[enttype] then
    return
  end

  if not (isfunction(handler.Handle_Mouse1) and isfunction(handler.Handle_Mouse2)) then
    error("Entity handler must contain two methods Handle_Mouse1 and Handle_Mouse2.")
  end

  self.Handlers[enttype] = table.Copy(handler)
end

function EMP:AddHandlers(handlertable)
  for K,V in pairs(handlertable) do
    self:AddHandler(K,V)
  end
end

function EMP:CanTrigger(caller,ent)
  return istable(self.Handlers[ent:GetClass()])
end

function EMP:Trigger(caller,ent,mode)
  local handle = self.Handlers[ent:GetClass()]
  if not handle then
    return
  end

  if (mode==1) then
    handle.Handle_Mouse1(caller,ent)
  elseif (mode==2) then
    handle.Handle_Mouse2(caller,ent)
  end

end

setmetatable(EMP,{
  __call = EMP.New
})
WEAPON_ALYX_EMP = WEAPON_ALYX_EMP or {}
WEAPON_ALYX_EMP.EMPHandlers = EMP:New()
