--[[
DEV: testerhdre

CHAMP : teemo

v: 1.0.0

CONTENT (in order):{
Requirements
Variabls
SUPPORTED LANGUAGES
LANGUAGE MENU
LOAD LANGUAGE
COMBO MENU
HARRAS MENU
FARM MENU
LAST HIT MENU
FLEE MENU
DRAW MENU
INFO MENU
SPELL INFO
PLAYER CAN CAST
ADC List
CAST Q
CAST W
CAST R
COMBO LOGIC
HARASS LOGIC
FARM LOGIC
LAST HIT LOGIC
FLEE LOGIC
Q LOGIC ON MINIONS (FOR LAST HIT )
GET NEARBY MINIONS
Q LOGIC ON MINIONS (FOR WAVECLEAR )
R LOGIC ON MINIONS (FOR WAVECLEAR )
GET Q DAMAGE
USE ITEMS
ON TICK
ON GAP CLOSE
ON PROCESS SPELL
ON DRAW
ON LOAD
}



]]
---[Requirements]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

require("common.log")
module("Teemo", package.seeall, log.setup)
local UIMenu = require("lol/Modules/Common/Menu")
UIMenu:AddMenu("teemo", "[+] Teemo")

---[Variabls]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local _SDK = _G.CoreEx
local ObjManager, EventManager, Input, Enums, Game, Geometry, Renderer = _SDK.ObjectManager, _SDK.EventManager, _SDK.Input, _SDK.Enums, _SDK.Game, _SDK.Geometry, _SDK.Renderer
local SpellSlots, SpellStates = Enums.SpellSlots, Enums.SpellStates
local Player = ObjManager.Player
local Prediction = _G.Libs.Prediction
local Orbwalker = _G.Libs.Orbwalker
local Version = 1.0
local DmgLib = _G.Libs.DamageLib
TS = _G.Libs.TargetSelector(Orbwalker.Menu)

local insert, sort = table.insert, table.sort


---[SUPPORTED LANGUAGES]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local Menu_Language = UIMenu.teemo.Language:AddDropDown("Menu_Language", "Choose language", { "English" })

--[[
if you want to add a language follow this schema:
index  |||  value
_________________
1      ||| "[+] Language"
2      ||| "[+] Combo"
3      ||| "Cast [Q]?"
4      ||| "Cast [Q] to ADC only?"
5      ||| "[%] mana limit"
6      ||| "Cast [W] ?"
7      ||| "Cast [R] ?"
8      ||| "[§] nbr of shroom to use [R]  "
9      ||| "[+] Waveclear"
10     ||| "[+] Flee"
11     ||| "use items to flee?"
12     ||| "[+] Drawing"
13     ||| "disable all drawings?"
14     ||| "Draw [Q] Range?"
15     ||| "Draw [Q] Color"
16     ||| "Draw Top Blue Side postitions"
17     ||| "Color"
18     ||| "Draw Top Tri Bush postitions"
19     |||  "Draw Top Red Side postitions"
20     ||| "Draw Mid Lane positions"
21     ||| "Draw Dragon positions"
22     |||  "Draw Bot Lane Red Side postitions"
23     ||| "Draw Bot Lane Blue Side bushes positions"
24     ||| "Draw Bot Lane tri bushes postitions"
25     ||| "[+] LastHit"
26     ||| "Min minions to use [R]"
]]

local english = {
    "[+] Language",
    "[+] Combo",
    "Cast [Q]?",
    "Cast [Q] to ADC only?",
    "[%] mana limit",
    "Cast [W] to gap close?",
    "[%] mana limit  ",
    "Cast [R] ?",
    "[§] nbr of shroom to cast R  ",
    "[+] Waveclear",
    "[+] Flee",
    "use items to flee?",
    "[+] Drawing",
    "disable all drawings?",
    "Draw [Q] Range?",
    "Draw [Q] Color",
    "Draw Top Blue Side postitions",
    "Color",
    "Draw Top Tri Bush postitions",
    "Draw Top Red Side postitions",
    "Draw Mid Lane positions",
    "Draw Dragon positions",
    "Draw Bot Lane Red Side postitions",
    "Draw Bot Lane Blue Side bushes positions",
    "Draw Bot Lane tri bushes postitions",
    "[+] LastHit",
    "Min minions to use [R]"

}
---[LOAD LANGUAGE]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
returns the table of strings depending on the chosen language
]]


function loeadLanguage()
    if Menu_Language.language.Value == "English" then
        return english
    end

end

---[LANGUAGE MENU]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
draws the menu
]]
local languageTable = loeadLanguage()
UIMenu.teemo:AddMenu("Language", languageTable[1])




---[COMBO MENU]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
draws the menu
]]
UIMenu.teemo:AddMenu("combo", languageTable[2])
local Q_Combo = UIMenu.teemo.combo:AddBool("Q_Combo", languageTable[3], true)
local Q_ADC_Combo = UIMenu.teemo.combo:AddBool("Q_ADC_Combo", languageTable[4], false)
local Q_Mana_Combo = UIMenu.teemo.combo:AddSlider("Q_Mana_Combo", languageTable[5], 0, 100, 1, 30)

local W_Combo = UIMenu.teemo.combo:AddBool("W_Combo", languageTable[6], true)
local W_Mana_Combo = UIMenu.teemo.combo:AddSlider("W_Mana_Combo", languageTable[5], 0, 100, 1, 30)
local W_Type_Combo = UIMenu.teemo.combo:AddDropDown("W_Type_Combo", "When use [W]", { "Always", "Smart", "Never" })

local R_Combo = UIMenu.teemo.combo:AddBool("R_Combo", languageTable[7], true)
local R_Mana_Combo = UIMenu.teemo.combo:AddSlider("R_Mana_Combo", languageTable[5], 0, 100, 1, 30)
local R_Shroom_Combo = UIMenu.teemo.combo:AddSlider("R_Shroom_Combo", languageTable[8], 1, 3, 1, 1)

---[HARRAS MENU]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UIMenu.teemo:AddMenu("Harass", "[+] Harass")
local Q_Harass = UIMenu.teemo.Harass:AddBool("Q_Harass", languageTable[3], true)
local Q_ADC_Harass = UIMenu.teemo.Harass:AddBool(Q_ADC_Harass, languageTable[4], false)
local Q_Mana_Harass = UIMenu.teemo.Harass:AddSlider("Q_Mana_Harass", "[%] mana limit  ", 0, 100, 1, 30)

local W_Harass = UIMenu.teemo.Harass:AddBool("W_Harass", "Cast [W] to gap close?", true)
local W_Mana_Harass = UIMenu.teemo.Harass:AddSlider("W_Mana_Harass", languageTable[5], 0, 100, 1, 30)
local W_Type_Harass = UIMenu.teemo.Harass:AddDropDown("W_Type_Combo", "When use [W]", { "Always", "Smart", "Never" })

local R_Harass = UIMenu.teemo.Harass:AddBool("R_Harass", languageTable[7], true)
local R_Mana_Harass = UIMenu.teemo.Harass:AddSlider("R_Mana_Harass", languageTable[5], 0, 100, 1, 30)
local R_Shroom_Harass = UIMenu.teemo.Harass:AddSlider("R_Shroom_Harass", languageTable[8], 1, 3, 1, 1)

---[FARM MENU]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
draws the menu
]]

UIMenu.teemo:AddMenu("Waveclear", languageTable[9])

local Q_Waveclear = UIMenu.teemo.Waveclear:AddBool("Q_Waveclear", languageTable[3], true)
local Q_Mana_Waveclear = UIMenu.teemo.Waveclear:AddSlider("Q_Mana_Waveclear", languageTable[5], 0, 100, 1, 30)

local R_Waveclear = UIMenu.teemo.Waveclear:AddBool("R_Waveclear", languageTable[7], true)
local R_Mana_Waveclear = UIMenu.teemo.Waveclear:AddSlider("Q_Mana_Waveclear", languageTable[5], 0, 100, 1, 30)
local R_NMinions_Waveclear = UIMenu.teemo.Waveclear:AddSlider("R_NMinions_Waveclear", languageTable[26], 1, 3, 1, 1)
local R_Shroom_Waveclear = UIMenu.teemo.Waveclear:AddSlider("R_Shroom_Waveclear", languageTable[8], 1, 3, 1, 1)









---[LAST HIT MENU]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
draws the menu
]]
UIMenu.teemo:AddMenu("LastHit", languageTable[25])

local Q_LastHit = UIMenu.teemo.LastHit:AddBool("Q_LastHit", languageTable[3], true)
local Q_Mana_LastHit = UIMenu.teemo.LastHit:AddSlider("Q_Mana_LastHit", languageTable[5], 0, 100, 1, 30)

---[FLEE MENU]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
draws the menu
]]
UIMenu.teemo:AddMenu("Flee", languageTable[10])
local W_Flee = UIMenu.teemo.Flee:AddBool("W_Flee", languageTable[6], true)
local W_Flee_Mana = UIMenu.teemo.Flee:AddSlider("W_Flee_Mana", languageTable[5], 0, 100, 1, 30)
local Items_Flee = UIMenu.teemo.Flee:AddBool("Items_Flee", languageTable[11], true)




---[DRAWING MENU]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
draws the menu
]]


--  DRAWING MENU
UIMenu.teemo:AddMenu("Drawing", languageTable[12])
--DISABLE ALL DRAWINGS
local Disable_Drawings = UIMenu.teemo.Drawing:AddBool("Disable_items", languageTable[13], true)

--DRAW Q RANGE
local Q_Drawing = UIMenu.teemo.Drawing:AddBool("Q_Drawing", languageTable[14], true)
local Q_Color_Drawing = UIMenu.teemo.Drawing:AddRGBAMenu("Q_Color_Drawing", languageTable[15], 0xEF476FFF)

-- DRAW COMMON SHROOM POSITIONS IN TOP BLUE SIDE
local Top_Blue_Side = UIMenu.teemo.Drawing:AddBool("Top_Blue_Side", languageTable[16], true)
local Top_Blue_Side_Color = UIMenu.teemo.Drawing:AddRGBAMenu("Top_Blue_Side_Color", languageTable[17], 0xEF476FFF)

-- DRAW COMMON SHROOM POSITIONS IN TOP TRI BUSH SIDE
local Top_Tri_Bush_Side = UIMenu.teemo.Drawing:AddBool("Top_Tri_Bush_Side", languageTable[18], true)
local Top_Tri_Bush_Color = UIMenu.teemo.Drawing:AddRGBAMenu("Top_Blue_Side_Color", languageTable[17], 0xEF476FFF)

-- DRAW COMMON SHROOM POSITIONS IN TOP RED SIDE
local Top_Red_Side = UIMenu.teemo.Drawing:AddBool("Top_Red_Side", languageTable[19], true)
local Top_Red_Color = UIMenu.teemo.Drawing:AddRGBAMenu("Top_Red_Color", languageTable[17], 0xEF476FFF)

-- DRAW COMMON SHROOM POSITIONS IN MID LANE SIDE
local Mid_Lane = UIMenu.teemo.Drawing:AddBool("Mid_Lane", languageTable[20], true)
local Mid_Lane_Color = UIMenu.teemo.Drawing:AddRGBAMenu("Mid_Lane_Color", languageTable[17], 0xEF476FFF)

-- DRAW COMMON SHROOM POSITIONS IN TOP DRAGON  SIDE
local Dragon = UIMenu.teemo.Drawing:AddBool("Dragon", languageTable[21], true)
local Dragon_Color = UIMenu.teemo.Drawing:AddRGBAMenu("Dragon_Color", languageTable[17], 0xEF476FFF)

-- DRAW COMMON SHROOM POSITIONS IN BOT RED  SIDE
local Bot_Red_Side = UIMenu.teemo.Drawing:AddBool("Bot_Red_Side", languageTable[22], true)
local Bot_Red_Side_Color = UIMenu.teemo.Drawing:AddRGBAMenu("Bot_Red_Side_Color", languageTable[17], 0xEF476FFF)

-- DRAW COMMON SHROOM POSITIONS IN BOT BLUE SIDE
local Bot_Blue_Side = UIMenu.teemo.Drawing:AddBool("Bot_Blue_Side", languageTable[23], true)
local Bot_Blue_Side_Color = UIMenu.teemo.Drawing:AddRGBAMenu("Bot_Blue_Side_Color", languageTable[17], 0xEF476FFF)

-- DRAW COMMON SHROOM POSITIONS IN BOT TRIE BUSHES SIDE
local Bot_Tri_Bushes = UIMenu.teemo.Drawing:AddBool("Bot_Tri_Bushes", languageTable[24], true)
local Bot_Tri_Bushes_Color = UIMenu.teemo.Drawing:AddRGBAMenu("Bot_Tri_Bushes_Color", languageTable[17], 0xEF476FFF)






---[INFO MENU]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
draws the menu
]]

UIMenu.teemo:AddLabel("version", "version" .. string.format("%.1f", Version))
UIMenu.teemo:AddLabel("dev", "dev: testerhdre ")


---[SPELL INFO]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




--  Spell Info
local spellQ = { Range = 680,
                 Speed = 2000,
                 Delay = 0.2,
                 Type = "Linear",
                 Collisions = { Heroes = true, Minions = true, WindWall = true },
}

local spellR = { Range = 400,
                 Radius = 320,
                 Delay = 0.25,
                 Collisions = { WindWall = true }
}

---[PLAYER CAN CAST]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
checks if the player can cast spells (not chatting, recalling , dead...)
]]

function PlayerCanCast()
    local gameAvailable = not (Game.IsChatOpen() or Game.IsMinimized())
    return gameAvailable and not (Player.IsDead or Player.IsRecalling) and Orbwalker.CanCast()

end


---[ADC List]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
checks if the target is an adc
]]
function ADCList()
    ADCtable = { "Aphelios", "Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Jhin", "Jinx", "Kai'Sa", "Kalista",
                 "KogMaw", "Lucian", "MissFortune", "Mordekaiser", "Quinn", "Sivir", "Teemo", "Tristana", "Twitch", "Urgot", "Varus",
                 "Vayne", "Xayah" }
    return ADCtable
end

function IsTargetADC(target)
    found = false
    for k2, v2 in pairs(ADCList()) do

        if (target.CharName) == v2 then
            found = true
        end

    end

    return found
end






---[CAST Q]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



--[[CAST Q  :
+arguments : target , useOnADCOnly? ,useInCombo? , manaPercent
]]

function CastQ(target, useOnADCOnly, isUsable, manaPercent)
    local targetAI = target.AsAI
    if targetAI and isUsable
            and Player.Position:Distance(target.Position) <= spellQ.Range and (Player.AsAttackableUnit.Mana >= (manaPercent / 100) * Player.AsAttackableUnit.MaxMana) then
        if useOnADCOnly and IsTargetADC(targetAI) then
            Input.Cast(SpellSlots.Q, targetAI)
        elseif not useOnADCOnly then
            Input.Cast(SpellSlots.Q, targetAI)


        end

    end

end

---[CAST W ]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[CAST W  :
+arguments :  ,isUsable , manaPercent
]]

function CastW(isUsable, manaPercent)

    if isUsable and (Player.AsAttackableUnit.Mana >= (manaPercent / 100) * Player.AsAttackableUnit.MaxMana) then
        Input.Cast(SpellSlots.W)
    end

end

---[CAST R ]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[CAST R :
+arguments : target  ,isUsable , manaPercent ,numberOfShrooms
]]
function CastR(target, isUsable, manaPercent, numberOfShrooms)

    local targetAI = target.AsAI
    local position = nil
    if targetAI and castable then
        if isUsable and Player.Position:Distance(target.Position) <= spellR.Range and (Player.AsAttackableUnit.Mana >= (manaPercent / 100) * Player.AsAttackableUnit.MaxMana) then
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



---[COMBO LOGIC]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



function Combo(target)

    CastQ(target, Q_ADC_Combo.Value, Q_Combo.Value, Q_Mana_Combo.Value)
    if W_Type_Combo.Value == "Always" then
        CastW(W_Combo, W_Mana_Combo)
    end
    CastR(target, R_Combo.Value, R_Mana_Combo.Value, R_Shroom_Combo.Value)

end
---[HARASS LOGIC]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Harass(target)


    CastQ(target, Q_ADC_Harass.Value, Q_Harass.Value, Q_Mana_Harass.Value)
    if W_Type_Harass.Value == "Always" then
        CastW(W_Harass, W_Mana_Harass)
    end
    CastR(target, R_Harass.Value, R_Mana_Harass.Value, R_Shroom_Harass.Value)
end



---[FARM LOGIC ]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



function Farm()


    CastQMinionsF(Q_Waveclear.Value, Q_Mana_Waveclear.Value)
    CastRMinions(R_Waveclear.Value, R_Mana_Waveclear.Value, R_Shroom_Waveclear.Value, R_NMinions_Waveclear.Value)

end

---[LAST HIT LOGIC ]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




function LastHit()


    CastQMinionsLH(Q_LastHit.Value, Q_Mana_LastHit.Value)

end


------[FLEE LOGIC ]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



function Flee(target)

    CastW(W_Flee, W_Flee_Mana)
end



---[Q LOGIC ON MINIONS (FOR LAST HIT )]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
contains the logic when temmo should use Q to last hit
]]

function CastQMinionsLH(isUsable, mana)

    if isUsable

            and Player.Position:Distance(target.Position) <= spellQ.Range and (Player.AsAttackableUnit.Mana >= (mana / 100) * Player.AsAttackableUnit.MaxMana)

    then
        local minionsInRange = {}
        do
            GetMinions(minionsInRange, "neutral")
            GetMinions(minionsInRange, "enemy")
            sort(minionsInRange, function(a, b)
                return a.MaxHealth > b.MaxHealth
            end)
        end

        for k, minion in ipairs(minions) do
            local healthPred = spellQ:GetHealthPred(minion)
            local qDmg = DmgLib.CalculatePhysicalDamage(Player, minion, GetQDamage())
            if healthPred > 0 and healthPred < qDmg
            then
                Input.Cast(SpellSlots.Q, minion)

            end
        end


    end


end






---[GET NEARBY MINIONS ]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


function GetMinions(table, type)
    for k, v in pairs(ObjManager.Get(type, "minions")) do
        local minion = v.AsAI
        local minionInRange = minion and minion.MaxHealth > 6 and spells.Q:IsInRange(minion)
        local shouldIgnoreMinion = minion and (Orbwalker.IsLasthitMinion(minion) or Orbwalker.IsIgnoringMinion(minion))
        if minionInRange and not shouldIgnoreMinion and minion.IsTargetable then
            insert(table, minion)
        end
    end
end


------[Q LOGIC ON MINIONS (FOR WAVECLEAR )]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
contains the logic when temmo should use Q to waveclear
]]


function CastQMinionsF(isUsable, mana)

    if isUsable

            and Player.Position:Distance(target.Position) <= spellQ.Range and (Player.AsAttackableUnit.Mana >= (mana / 100) * Player.AsAttackableUnit.MaxMana)
    then
        for k, v in pairs(ObjManager.Get("enemy", "minions")) do
            local minion = v.AsAI
            if isUsable and pos:Distance(Player.Position) < spellQ.Range and minion.IsTargetable then

                Input.Cast(SpellSlots.Q, minion)
            end
        end
    end


end


------[R LOGIC ON MINIONS (FOR WAVECLEAR )]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
contains the logic when temmo should use R to WAVECLEAR
]]


function CastRMinions(isUsable, mana, nShroom, nMinions)

    if isUsable
            and Player.Position:Distance(target.Position) <= spellR.Range and (Player.AsAttackableUnit.Mana >= (mana / 100) * Player.AsAttackableUnit.MaxMana)
    then

        local points = {}
        local minionCount = nMinions
        local minions = ObjectManager.Get("enemy", "minions")

        for i, minion in pairs(minions) do
            local minion = minion.AsAI
            if minion then
                local predPos = minion:FastPrediction(QR.Delay)
                local dist = predPos:Distance(Player.Position)
                if dist < QR.Range then
                    points[#points + 1] = predPos
                end
            end
        end

        local bestPos, hitCount = Geometry.BestCoveringCircle(points, 85)
        if bestPos and hitCount >= minionCount then
            Input.Cast(SpellSlots.R, bestPos)
        end

    end


end

---[GET Q DAMAGE ]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


function GetQDamage()
    return (35 + spellQ:GetLevel() * 45) + (0.8 * Player.TotalAP)
end



---[USE ITEMS ]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



function UseItems(target)
    for i = SpellSlots.Item1, SpellSlots.Item6 do
        local item = Player:GetSpell(i)
        if item ~= nil and item then


            if item.Name == "ItemSwordOfFeastAndFamine" or item.Name == "BilgewaterCutlass" then
                if Player:GetSpellState(i) == SpellStates.Ready
                        -- and Ezreal_korean_menuCastBOTRKBoolCombo.Value
                        and Player.Position:Distance(target.Position) <= Player:GetSpellState(i).Range
                then
                    Input.Cast(i, target)
                end
                break
            end
        end
    end
end

---[ON TICK]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


function OnTick()
    if not PlayerCanCast() then
        return
    end

    local target = Orbwalker.GetTarget() or TS:GetTarget(1250, true)


    --COMBO
    if target and Orbwalker.GetMode() == "Combo" then

        Combo(target)
        UseItems(target)
        --HARRAS
    elseif target and Orbwalker.GetMode() == "Harass" then
        Harass(target)

        --FARM
    elseif Orbwalker.GetMode() == "Waveclear" then
        Farm()


        --Lasthit
    elseif Orbwalker.GetMode() == "Lasthit" then
        LastHit()

        --FLEE
    elseif Orbwalker.GetMode() == "Flee" then
        Flee()
    end
end


---[ON GAP CLOSE]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function OnGapclose(source, dash)


    if Orbwalker.GetMode() == "Combo" and not (W_Type_Combo.Value == "Never") then
        if not (source.IsEnemy and W_Combo.Value) then
            return
        end

        local paths = dash:GetPaths()
        local endPos = paths[#paths].EndPos
        local pPos = Player.Position
        local pDist = pPos:Distance(endPos)

        if pDist < 400 and pDist < pPos:Distance(dash.StartPos) and source:IsFacing(pPos) then
            CastW()
        end


    end

end





---[ON PROCESS SPELL ]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


function OnProcessSpell(obj, spell)

    --COMBO
    if Orbwalker.GetMode() == "Combo" and not (W_Type_Combo.Value == "Never") then
        if obj.IsHero and obj.IsEnemy then
            if not spell.IsBasicAttack then

                if spell.Target == Player.AsAttackableUnit then
                    CastW(W_Combo, W_Mana_Combo.Value)
                end
            end
        end
    end


    --HARASS
    if Orbwalker.GetMode() == "Harass" and not (W_Type_Harass.Value == "Never") then
        if obj.IsHero and obj.IsEnemy then
            if not spell.IsBasicAttack then

                if spell.Target == Player.AsAttackableUnit then
                    CastW(W_Harass, W_Mana_Harass)
                end
            end
        end
    end


end


---[ON DRAW]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
specify what to show on player's  screen ]]


function OnDraw()


    --draw important shroom places

    --  Top Lane Blue Side + Baron
    if self.Top_Lane_Blue_Side then
        DrawCircleGame(2790, 50.16358, 7278, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(3700.708, -11.22648, 9294.094, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(2314, 53.165, 9722, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(3090, -68.03732, 10810, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(4722, -71.2406, 10010, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(5208, -71.2406, 9114, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(4400, 52.53909, 7240, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(4564, 51.83786, 6060, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(2760, 52.96445, 5178, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(4440, 56.8484, 11840, 149, Lua_ARGB(255, 0, 250, 154))

    end
    --Top Lane Tri Bush

    if self.Top_Lane_Tri_Bush then
        DrawCircleGame(2420, 52.8381, 13482, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(1630, 52.8381, 13008, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(1172, 52.8381, 12302, 149, Lua_ARGB(255, 0, 250, 154))

        DrawCircleGame(3020, 52.8381, 12182, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(2472, 52.8381, 11702, 149, Lua_ARGB(255, 0, 250, 154))


    end
    --Top Lane Red Side

    if self.Top_Lane_Red_Side then
        DrawCircleGame(5666, 52.8381, 12722, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(8004, 56.4768, 11782, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(9194, 53.35013, 11368, 149, Lua_ARGB(255, 0, 250, 154))

        DrawCircleGame(8280, 50.06194, 10254, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(6728, 53.82967, 11450, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(5980, 53.82967, 11150, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(6242, 54.09851, 10270, 149, Lua_ARGB(255, 0, 250, 154))


    end




    -- Mid Lane

    if self.Mid_Lane then
        DrawCircleGame(6484, -71.2406, 8380, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(8380, -71.2406, 6502, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(9099.75, 52.95337, 7376.637, 149, Lua_ARGB(255, 0, 250, 154))

        DrawCircleGame(7376, 52.8726, 8802, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(5776, 52.8726, 7402, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(7602, 52.56985, 5928, 149, Lua_ARGB(255, 0, 250, 154))


    end




    --Dragon
    if self.Dragon then
        DrawCircleGame(9372, -71.2406, 5674, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(10148, -71.2406, 4801.525, 149, Lua_ARGB(255, 0, 250, 154))

    end




    --Bot Lane Red Side
    if self.Both_Lane_Red_Side then
        DrawCircleGame(9772, 9.031885, 6458, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(9938, 51.62378, 7900, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(11465, 51.72557, 7157.772, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(12481, 51.7294, 5232.559, 149, Lua_ARGB(255, 0, 250, 154))

        DrawCircleGame(11266, -7.897567, 5542, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(11290, 64.39886, 8694, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(12676, 51.6851, 7310.818, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(12022, 9154, 51.25105, 149, Lua_ARGB(255, 0, 250, 154))


    end




    -- Bot Lane Blue Side+bushes
    if self.Both_Lane_Blue_Side_bushes then
        DrawCircleGame(6544, 48.257, 4732, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(5576, 51.42581, 3512, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(6888, 51.94016, 3082, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(8070, 51.5508, 3472, 149, Lua_ARGB(255, 0, 250, 154))

        DrawCircleGame(8594, 51.73177, 4668, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(10388, 49.81641, 3046, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(9160, 59.97022, 2122, 149, Lua_ARGB(255, 0, 250, 154))


    end



    -- Bot Lane tri bushes++
    if self.Both_Lane_tri_bushes then

        DrawCircleGame(12518, 53.66707, 1504, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(13404, 51.3669, 2482, 149, Lua_ARGB(255, 0, 250, 154))
        DrawCircleGame(11854, -68.06037, 3922, 149, Lua_ARGB(255, 0, 250, 154))


    end

end




---[ON LOAD]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[]]

function OnLoad()
    if Player.CharName ~= "Teemo" then
        return false
    end
    print("logging: Teemo_korean loaded version: " .. string.format("%.1f", Version))
    --game printchat disabled atm
    --Game.PrintChat('<font color="#0066cc">></font> <font color="#FFFFFF">Teemo_korean loaded</font> <font color="#0066cc"> ty</font><font color="#FFFFFF">!</font>')

    EventManager.RegisterCallback(Enums.Events.OnTick, OnTick)
    EventManager.RegisterCallback(Enums.Events.OnDraw, OnDraw)
    EventManager.RegisterCallback(Enums.Events.OnProcessSpell, OnProcessSpell)
    EventManager.RegisterCallback(Enums.Events.OnGapclose, OnGapclose)
    return true
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
