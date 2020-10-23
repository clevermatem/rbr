require("common.log")
module("Ezreal", package.seeall, log.setup)



--  VARIABLES
local _SDK = _G.CoreEx
local ObjManager, EventManager, Input, Enums, Game, Geometry, Renderer = _SDK.ObjectManager, _SDK.EventManager, _SDK.Input, _SDK.Enums, _SDK.Game, _SDK.Geometry, _SDK.Renderer
local SpellSlots, SpellStates = Enums.SpellSlots, Enums.SpellStates
local Player = ObjManager.Player
local Prediction = _G.Libs.Prediction
local Orbwalker = _G.Libs.Orbwalker
local Version = 1.0
local DmgLib = _G.Libs.DamageLib
TS = _G.Libs.TargetSelector(Orbwalker.Menu)

--------------------------------------------------------------------------------------------------------------------------------------


--MENU
local UIMenu = require("lol/Modules/Common/Menu")
UIMenu:AddMenu("Ezreal_korean", "Ezreal_korean")

--   COMBO MENU:
UIMenu.Ezreal_korean:AddMenu("Ezreal_korean_Combo", "[+] Combo")
local Ezreal_korean_menuCastQBoolCombo = UIMenu.Ezreal_korean.Ezreal_korean_Combo:AddBool("Ezreal_korean_CastQ", "Cast [Q]?", true)
local Ezreal_korean_menuCastQHitChanceCombo = UIMenu.Ezreal_korean.Ezreal_korean_Combo:AddSlider("Ezreal_korean_QHC", "[Q] Hit Chance", 0.05, 1, 0.05, 0.5)
local Ezreal_korean_menuCastQ_ManaCombo = UIMenu.Ezreal_korean.Ezreal_korean_Combo:AddSlider("Ezreal_korean_QMANA", "[%] mana limit  ", 0, 100, 1, 30)

local Ezreal_korean_menuCastWBoolCombo = UIMenu.Ezreal_korean.Ezreal_korean_Combo:AddBool("Ezreal_korean_CastW", "Cast [W]?", true)
local Ezreal_korean_menuCastWHitChanceCombo = UIMenu.Ezreal_korean.Ezreal_korean_Combo:AddSlider("Ezreal_korean_WHC", "[W] Hit Chance", 0.05, 1, 0.05, 0.5)
local Ezreal_korean_menuCastW_ManaCombo = UIMenu.Ezreal_korean.Ezreal_korean_Combo:AddSlider("Ezreal_korean_WMANA", "[%] mana limit  ", 0, 100, 1, 30)

local Ezreal_korean_menuCastEBoolCombo = UIMenu.Ezreal_korean.Ezreal_korean_Combo:AddBool("Ezreal_korean_CastE", "Cast [E]?", true)
--local Ezreal_korean_menuCastEHitChanceCombo = UIMenu.Ezreal_korean.Ezreal_korean_Combo:AddSlider("Ezreal_korean_EHC", "[E] Hit Chance", 0.05, 1, 0.05, 0.5)
local Ezreal_korean_menuCastE_ManaCombo = UIMenu.Ezreal_korean.Ezreal_korean_Combo:AddSlider("Ezreal_korean_EMANA", "[%] mana limit ", 0, 100, 1, 30)

local Ezreal_korean_menuCastRBoolCombo = UIMenu.Ezreal_korean.Ezreal_korean_Combo:AddBool("Ezreal_korean_CastR", "Cast [R]?", true)
local Ezreal_korean_menuCastRHitChanceCombo = UIMenu.Ezreal_korean.Ezreal_korean_Combo:AddSlider("Ezreal_korean_RHC", "[R] Hit Chance", 0.05, 1, 0.05, 0.5)
local Ezreal_korean_menuCastR_ManaCombo = UIMenu.Ezreal_korean.Ezreal_korean_Combo:AddSlider("Ezreal_korean_RMANA", "[%] mana limit ", 0, 100, 1, 30)
local Ezreal_korean_menuCastWQBoolCombo = UIMenu.Ezreal_korean.Ezreal_korean_Combo:AddBool("Ezreal_korean_CastWQ", "wait [Q] before [W]", true)
local Ezreal_korean_menuCastRKillableBoolCombo = UIMenu.Ezreal_korean.Ezreal_korean_Combo:AddBool("Ezreal_korean_CastRKillable", "Cast [R] only if killable", true)



--------------------------------------------------------------------------------------------------------------------------------------

--   HARRAS MENU
UIMenu.Ezreal_korean:AddMenu("Ezreal_korean_Harass", "[+] Harass")

local Ezreal_korean_menuCastQBoolHarras = UIMenu.Ezreal_korean.Ezreal_korean_Harass:AddBool("Ezreal_korean_CastQ", "Cast [Q]?", true)
local Ezreal_korean_menuCastQHitChanceHarras = UIMenu.Ezreal_korean.Ezreal_korean_Harass:AddSlider("Ezreal_korean_QHC", "[Q] Hit Chance", 0.05, 1, 0.05, 0.5)
local Ezreal_korean_menuCastQ_ManaHarras = UIMenu.Ezreal_korean.Ezreal_korean_Harass:AddSlider("Ezreal_korean_QMANA", "[%] mana limit ", 0, 100, 1, 30)

local Ezreal_korean_menuCastWBoolHarras = UIMenu.Ezreal_korean.Ezreal_korean_Harass:AddBool("Ezreal_korean_CastW", "Cast [W]?", true)
local Ezreal_korean_menuCastWHitChanceHarras = UIMenu.Ezreal_korean.Ezreal_korean_Harass:AddSlider("Ezreal_korean_WHC", "[W] Hit Chance", 0.05, 1, 0.05, 0.5)
local Ezreal_korean_menuCastW_ManaHarras = UIMenu.Ezreal_korean.Ezreal_korean_Harass:AddSlider("Ezreal_korean_WMANA", "[%] mana limit ", 0, 100, 1, 30)

local Ezreal_korean_menuCastEBoolHarras = UIMenu.Ezreal_korean.Ezreal_korean_Harass:AddBool("Ezreal_korean_CastE", "Cast [E]?", true)
--local Ezreal_korean_menuCastEHitChanceHarras = UIMenu.Ezreal_korean.Ezreal_korean_Harass:AddSlider("Ezreal_korean_EHC", "[E] Hit Chance", 0.05, 1, 0.05, 0.5)
local Ezreal_korean_menuCastE_ManaHarras = UIMenu.Ezreal_korean.Ezreal_korean_Harass:AddSlider("Ezreal_korean_EMANA", "[%] mana limit ", 0, 100, 1, 30)

local Ezreal_korean_menuCastRBoolHarras = UIMenu.Ezreal_korean.Ezreal_korean_Harass:AddBool("Ezreal_korean_CastR", "Cast [R]?", false)
local Ezreal_korean_menuCastRHitChanceHarras = UIMenu.Ezreal_korean.Ezreal_korean_Harass:AddSlider("Ezreal_korean_RHC", "[R] Hit Chance", 0.05, 1, 0.05, 0.5)
local Ezreal_korean_menuCastR_ManaHarras = UIMenu.Ezreal_korean.Ezreal_korean_Harass:AddSlider("Ezreal_korean_RMANA", "[%] mana limit ", 0, 100, 1, 30)
local Ezreal_korean_menuCastWQBoolHarass = UIMenu.Ezreal_korean.Ezreal_korean_Harass:AddBool("Ezreal_korean_CastWQ", "wait [Q] before [W]", true)
local Ezreal_korean_menuCastRKillableBoolHarass = UIMenu.Ezreal_korean.Ezreal_korean_Harass:AddBool("Ezreal_korean_CastRKillable", "Cast [R] only if killable", true)





--------------------------------------------------------------------------------------------------------------------------------------


--  FARM MENU
UIMenu.Ezreal_korean:AddMenu("Ezreal_korean_Waveclear", "[+] Waveclear")


local Ezreal_korean_menuCastQBoolWaveClear = UIMenu.Ezreal_korean.Ezreal_korean_Waveclear:AddBool("Ezreal_korean_CastQ", "Cast [Q]?", true)
local Ezreal_korean_menuCastQHitChanceWaveClear = UIMenu.Ezreal_korean.Ezreal_korean_Waveclear:AddSlider("Ezreal_korean_QHC", "[Q] Hit Chance", 0.05, 1, 0.05, 0.75)
 local Ezreal_korean_menuCastQ_ManaWaveClear = UIMenu.Ezreal_korean.Ezreal_korean_Waveclear:AddSlider("Ezreal_korean_QMANA", "[%] mana limit ", 0, 100, 1, 60)



--------------------------------------------------------------------------------------------------------------------------------------

--  DRAWING MENU
UIMenu.Ezreal_korean:AddMenu("Ezreal_korean_Drawing", "[+] Drawing")
local Ezreal_koreanQBool = UIMenu.Ezreal_korean.Ezreal_korean_Drawing:AddBool("Ezreal_korean_DrawQ", "Draw [Q] Range?", true)
local Ezreal_koreanQColor = UIMenu.Ezreal_korean.Ezreal_korean_Drawing:AddRGBAMenu("Ezreal_korean_DrawQ_Color", "Draw [Q] Color", 0xEF476FFF)

local Ezreal_koreanWBool = UIMenu.Ezreal_korean.Ezreal_korean_Drawing:AddBool("Ezreal_korean_DrawW", "Draw [W] Range?", false)
local Ezreal_koreanWColor = UIMenu.Ezreal_korean.Ezreal_korean_Drawing:AddRGBAMenu("Ezreal_korean_DrawW_Color", "Draw [W] Color", 0xFFFFFFFF)

local Ezreal_koreanEBool = UIMenu.Ezreal_korean.Ezreal_korean_Drawing:AddBool("Ezreal_korean_DrawE", "Draw [E] Range?", false)
local Ezreal_koreanEColor = UIMenu.Ezreal_korean.Ezreal_korean_Drawing:AddRGBAMenu("Ezreal_korean_DrawE_Color", "Draw [E] Color", 0xFFFFFFFF)

UIMenu.Ezreal_korean.Ezreal_korean_Drawing:AddLabel("Ezreal_korean_DrawR", "[R] is global LMAO ")

--------------------------------------------------------------------------------------------------------------------------------------


--INFO MENU
UIMenu.Ezreal_korean:AddLabel("version", "version" .. string.format("%.1f", Version))
UIMenu.Ezreal_korean:AddLabel("dev", "dev: testerhdre ")




-- Ez Spell Info
local spellQ = { Range = 1200,
                 Radius = 120,
                 Speed = 2000,
                 Delay = 0.25,
                 Type = "Linear",
                 Collisions = { Heroes = true, Minions = true, WindWall = true },
}

local spellW = { Range = 1200,
                 Radius = 160,
                 Speed = 1700,
                 Delay = 0.25,
                 Collisions = { Heroes = true, WindWall = true },

                 Type = "Linear" }

local spellE = { Range = 475,
                 Radius = 750,
                 Speed = 2500,
                 Delay = 0.25,
}
local spellR = { Range = math.huge,
                 Radius = 320,
                 Speed = 2000,
                 Delay = 1,
                 Type = "Linear" }

--------------------------------------------------------------------------------------------------------------------------------------
-- use items




--PLAYMODE FUNCTION

local function PlayerCanCast()
    local gameAvailable = not (Game.IsChatOpen() or Game.IsMinimized())
    return gameAvailable and not (Player.IsDead or Player.IsRecalling) and Orbwalker.CanCast()

end
--------------------------------------------------------------------------------------------------------------------------------------

--CAST Q
local function CastQ(target, castable, hitchance, mana)
    local targetAI = target.AsAI
    local position = nil
    if targetAI and castable then
        if Player.Position:Distance(target.Position) <= spellQ.Range and (Player.AsAttackableUnit.Mana >= (mana / 100) * Player.AsAttackableUnit.MaxMana)   then
            position = Prediction.GetPredictedPosition(targetAI, spellQ, Player.Position)
            if position then
                if position.HitChance >= hitchance then
                    position = position.CastPosition
                else
                    position = nil
                end
            end
        end
    end

    if Player:GetSpellState(SpellSlots.Q) == SpellStates.Ready
            and position then
        Input.Cast(SpellSlots.Q, position)
    end
end



--CAST W
local function CastW(target, castable, hitchance,mana)
    local targetAI = target.AsAI
    local position = nil
    if targetAI and castable then
        if Player.Position:Distance(target.Position) <= spellW.Range and (Player.AsAttackableUnit.Mana >= (mana / 100) * Player.AsAttackableUnit.MaxMana) then
            position = Prediction.GetPredictedPosition(targetAI, spellW, Player.Position)
            if position then
                if position.HitChance >= hitchance then
                    position = position.CastPosition
                else
                    position = nil
                end
            end
        end
    end

    if Player:GetSpellState(SpellSlots.W) == SpellStates.Ready
            and position then
        Input.Cast(SpellSlots.W, position)
    end
end



--CAST R
local function CastR(target, castable, hitchance , mana)

    local targetAI = target.AsAI
    local position = nil
    if targetAI and castable then
        if Player.Position:Distance(target.Position) <= spellR.Range and (Player.AsAttackableUnit.Mana >= (mana / 100) * Player.AsAttackableUnit.MaxMana) then
            position = Prediction.GetPredictedPosition(targetAI, spellR, Player.Position)
            if position then
                if position.HitChance >= hitchance then
                    position = position.CastPosition
                else
                    position = nil
                end
            end
        end
    end

    if Player:GetSpellState(SpellSlots.R) == SpellStates.Ready
            and position then
        Input.Cast(SpellSlots.R, position)
    end


end

--------------------------------------------------------------------------------------------------------------------------------------



--CAST E

local function CastE()


    if Player:GetSpellState(SpellSlots.E) == SpellStates.Ready then
        Input.Cast(SpellSlots.E, Renderer.GetMousePos())
    end
end



--------------------------------------------------------------------------------------------------------------------------------------


--COMBO FUNCTION
local function Combo(target)

    if Ezreal_korean_menuCastWQBoolCombo.Value then
        if Player:GetSpellState(SpellSlots.Q) == SpellStates.Ready then
            CastW(target, Ezreal_korean_menuCastWBoolCombo.Value, Ezreal_korean_menuCastWHitChanceCombo.Value, Ezreal_korean_menuCastW_ManaCombo.Value)
            CastQ(target, Ezreal_korean_menuCastQBoolCombo.Value, Ezreal_korean_menuCastQHitChanceCombo.Value, Ezreal_korean_menuCastQ_ManaCombo.Value)
        else
            -- CastR(target, Ezreal_korean_menuCastRBoolCombo.Value, Ezreal_korean_menuCastRHitChanceCombo.Value)
        end
    else
        CastW(target, Ezreal_korean_menuCastWBoolCombo.Value, Ezreal_korean_menuCastWHitChanceCombo.Value, Ezreal_korean_menuCastW_ManaCombo.Value)
        CastQ(target, Ezreal_korean_menuCastQBoolCombo.Value, Ezreal_korean_menuCastQHitChanceCombo.Value, Ezreal_korean_menuCastQ_ManaCombo.Value)

    end

end
--------------------------------------------------------------------------------------------------------------------------------------



--HARASS FUNCTION
local function Harass(target)

    if Ezreal_korean_menuCastWQBoolHarass.Value then
        if Player:GetSpellState(SpellSlots.Q) == SpellStates.Ready then
            CastW(target, Ezreal_korean_menuCastWBoolHarras.Value, Ezreal_korean_menuCastWHitChanceHarras.Value, Ezreal_korean_menuCastW_ManaHarras.Value)
            CastQ(target, Ezreal_korean_menuCastQBoolHarras.Value, Ezreal_korean_menuCastQHitChanceHarras.Value, Ezreal_korean_menuCastQ_ManaHarras.Value)
        else
            -- CastR(target, Ezreal_korean_menuCastRBoolCombo.Value, Ezreal_korean_menuCastRHitChanceCombo.Value)

        end
    else
        CastW(target, Ezreal_korean_menuCastWBoolHarras.Value, Ezreal_korean_menuCastWHitChanceHarras.Value,Ezreal_korean_menuCastW_ManaHarras.Value)
        CastQ(target, Ezreal_korean_menuCastQBoolHarras.Value, Ezreal_korean_menuCastQHitChanceHarras.Value, Ezreal_korean_menuCastQ_ManaHarras.Value)

    end

end



--------------------------------------------------------------------------------------------------------------------------------------

--FARM FUNCTION

local function Farm()

		for k, v in pairs(ObjManager.Get("enemy", "minions")) do
			local minion = v.AsAI
            local pos = minion:FastPrediction(spellQ.Delay)
			if   pos:Distance(Player.Position) < spellQ.Range and minion.IsTargetable then

		         CastQ(minion,Ezreal_korean_menuCastQBoolWaveClear.Value,  Ezreal_korean_menuCastQHitChanceWaveClear.Value, Ezreal_korean_menuCastQ_ManaWaveClear.Value)

			end
		end

end
--------------------------------------------------------------------------------------------------------------------------------------


--FLEE FUNCTION
local function Flee(target)

    CastE()
end



--------------------------------------------------------------------------------------------------------------------------------------

--GET R DAMAGE FUNCTION

local function GetRDamage()
    return 200 + Player:GetSpell(Enums.SpellSlots.R).Level * 150 + 0.9 * Player.BonusAP + Player.BonusAD
end
--------------------------------------------------------------------------------------------------------------------------------------


--R COMBO LOGIC FUNCTION
local function RlogicCombo(targetR)


    if Ezreal_korean_menuCastRKillableBoolCombo.Value then
        local rDmg = DmgLib.CalculateMagicalDamage(Player, targetR, GetRDamage())

        if rDmg > (targetR.Health + targetR.ShieldAll) then
            CastR(targetR, Ezreal_korean_menuCastRBoolCombo.Value, Ezreal_korean_menuCastRHitChanceCombo.Value, Ezreal_korean_menuCastR_ManaCombo.Value)

        end

    else


        CastR(targetR, Ezreal_korean_menuCastRBoolCombo.Value, Ezreal_korean_menuCastRHitChanceCombo.Value,Ezreal_korean_menuCastR_ManaCombo.Value)
    end
end






--------------------------------------------------------------------------------------------------------------------------------------




--R HARASS LOGIC FUNCTION

local function RlogicHarass(targetR)


    if Ezreal_korean_menuCastRKillableBoolHarass.Value then
        local rDmg = DmgLib.CalculateMagicalDamage(Player, targetR, GetRDamage())

        if rDmg > (targetR.Health + targetR.ShieldAll) then
            CastR(targetR, Ezreal_korean_menuCastRBoolHarras.Value, Ezreal_korean_menuCastRHitChanceHarras.Value, Ezreal_korean_menuCastR_ManaHarras.Value)

        end

    else


        CastR(targetR, Ezreal_korean_menuCastRBoolHarras.Value, Ezreal_korean_menuCastRHitChanceHarras.Value,Ezreal_korean_menuCastR_ManaHarras.Value)
    end
end







--------------------------------------------------------------------------------------------------------------------------------------

--ONTICK
local function OnTick()
    if not PlayerCanCast() then
        return
    end

    local target = Orbwalker.GetTarget() or TS:GetTarget(1250, true)
    local targetR = Orbwalker.GetTarget() or TS:GetTarget(math.huge, true)





    --R LOGIC
    if targetR and Orbwalker.GetMode() == "Combo" then
        RlogicCombo(targetR)

    elseif targetR and Orbwalker.GetMode() == "Harass" then
        RlogicHarass(targetR)


    end





    --COMBO
    if target and Orbwalker.GetMode() == "Combo" then

        Combo(target)

        --HARRAS
    elseif target and Orbwalker.GetMode() == "Harass" then
        Harass(target)

        --FARM
    elseif   Orbwalker.GetMode() == "Waveclear" then
            Farm()

        --FLEE
    elseif   Orbwalker.GetMode() == "Flee" then
        Flee()
    end
end

--------------------------------------------------------------------------------------------------------------------------------------

--DRAW MENU
local function OnDraw()

    --DRAW Q
    if Player:GetSpellState(SpellSlots.Q) == SpellStates.Ready and Ezreal_koreanQBool.Value then
        Renderer.DrawCircle3D(Player.Position, spellQ.Range, 30, 1.0, Ezreal_koreanQColor.Value)
    end

    --DRAW W

    if Player:GetSpellState(SpellSlots.W) == SpellStates.Ready and Ezreal_koreanWBool.Value then
        Renderer.DrawCircle3D(Player.Position, spellW.Range, 30, 1.0, Ezreal_koreanWColor.Value)
    end

    --DRAW E
    if Player:GetSpellState(SpellSlots.E) == SpellStates.Ready and Ezreal_koreanEBool.Value then
        Renderer.DrawCircle3D(Player.Position, spellE.Range, 30, 1.0, Ezreal_koreanEColor.Value)
    end


end



--------------------------------------------------------------------------------------------------------------------------------------

--ONPROCESSSPELL
local function OnProcessSpell(obj,spell)

    --COMBO
if Orbwalker.GetMode() == "Combo"  and Ezreal_korean_menuCastEBoolCombo.Value and
        ((Player.AsAttackableUnit.Mana >= (Ezreal_korean_menuCastE_ManaCombo.Value / 100) * Player.AsAttackableUnit.MaxMana)) then
    	if obj.IsHero and obj.IsEnemy then
		if not spell.IsBasicAttack then

 			if spell.Target == Player.AsAttackableUnit   then
				CastE()
			end
		end
	end
end



  --HARRAS

if Orbwalker.GetMode() == "Harass"  and Ezreal_korean_menuCastEBoolHarras.Value and
        ((Player.AsAttackableUnit.Mana >= (Ezreal_korean_menuCastE_ManaHarras.Value / 100) * Player.AsAttackableUnit.MaxMana)) then
    	if obj.IsHero and obj.IsEnemy then
		if not spell.IsBasicAttack then

			if spell.Target == Player.AsAttackableUnit   then
				CastE()
			end
		end
	end
end
end

--------------------------------------------------------------------------------------------------------------------------------------
function OnLoad()
    if Player.CharName ~= "Ezreal" then
        return false
    end
    print("logging: Ezreal_korean loaded version: " .. string.format("%.1f", Version))
    --game printchat disabled atm
    --Game.PrintChat('<font color="#0066cc">></font> <font color="#FFFFFF">Ezreal_korean loaded</font> <font color="#0066cc"> ty</font><font color="#FFFFFF">!</font>')

    EventManager.RegisterCallback(Enums.Events.OnTick, OnTick)
    EventManager.RegisterCallback(Enums.Events.OnDraw, OnDraw)
	EventManager.RegisterCallback(Enums.Events.OnProcessSpell, OnProcessSpell)
    return true
end

