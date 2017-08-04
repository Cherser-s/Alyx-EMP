
SWEP.ClassName = "weapon_alyx_emp"
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.PrintName="Alyx EMP tool"
SWEP.Author = "Cherser"
SWEP.HoldType = "pistol"
SWEP.ViewModelFOV = 70
SWEP.ViewModelFlip = false
SWEP.UseHands = false --true
SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.Primary.Automatic= false
SWEP.Primary.Ammo= "none"
SWEP.Secondary.Automatic= false
SWEP.Secondary.Ammo= "none"

SWEP.FireRange = 120
SWEP.FireSound=Sound("weapons/stunstick/alyx_stunner2.wav")
SWEP.WaitTime=0.7
SWEP.Slot=5
SWEP.SlotPos=15
SWEP.DrawAmmo=false

function SWEP:SetupDataTables()
	self:NetworkVar( "Bool" , 0 , "Firing" )
	self:NetworkVar( "Bool" , 1 , "PrimaryAttack" )
	self:NetworkVar("Entity", 0 , "TargetEntity" )
end
