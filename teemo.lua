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
if Player.CharName ~= "Teemo" then
    return false
end
require("common.log")
module("Teemo", package.seeall, log.setup)
local UIMenu = require("lol/Modules/Common/Menu")
UIMenu:AddMenu("teemo", "[+] Teemo")

---[Variabls]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

local _SDK = _G.CoreEx
local ObjManager, EventManager, Input, Enums, Game, Geometry, Renderer = _SDK.ObjectManager, _SDK.EventManager, _SDK.Input, _SDK.Enums, _SDK.Game, _SDK.Geometry, _SDK.Renderer
local Vector, HealthPred = _SDK.Geometry.Vector, _G.Libs.HealthPred
local SpellSlots, SpellStates = Enums.SpellSlots, Enums.SpellStates
local Player = ObjManager.Player
local ObjectManager = _SDK.ObjectManager
local Prediction = _G.Libs.Prediction
local Orbwalker = _G.Libs.Orbwalker
local Version = 1.0
local DmgLib = _G.Libs.DamageLib
TS = _G.Libs.TargetSelector(Orbwalker.Menu)

local insert, sort = table.insert, table.sort
deltashroom = 0
nowhshroom = 0

---[SUPPORTED LANGUAGES]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
if you want to add a language follow this schema:
index  |||  value
_________________
1      ||| "[+] Language"
2      ||| "[+] Combo"
3      ||| "Cast [Q]?"
4      ||| "Cast [Q] to ADC only?"
5      ||| "[%] mana limit"
6      ||| "Cast [W] to gap close?"
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
26     ||| "Nbr minions"
27     ||| "Draw [R] Range?"
28     ||| "Draw [R] Color"
29     ||| "[+] Harass"


]]

local english = {
    "[+] Language",
    "[+] Combo",
    "Cast [Q]?",
    "Cast [Q] to ADC only?",
    "[%] mana limit",
    "Cast [W] ?",
    "Cast [R] ?",
    "use when >= to",
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
    "Nbr minions",
    "Draw [R] Range?",
    "Draw [R] Color",
    "[+] Harass"
}
local Espagnol = {

"[+] Idioma",
     "[+] Combo",
     "¿Emitir [Q]?",
     "¿Transmitir [Q] solo a ADC?",
     "[%] límite de maná",
     "¿Emitir [W]?",
     "¿Emitir [R]?",
     "usar cuando> = para",
     "[+] Waveclear",
     "[+] Huye",
     "usar elementos para huir?",
     "[+] Dibujo",
     "¿Deshabilitar todos los dibujos?",
     "¿Dibujar rango [Q]?",
     "Dibujar [Q] Color",
     "Dibujar posiciones del lado azul superior",
     "Color",
     "Dibujar las posiciones superiores de Tri Bush",
     "Dibujar las posiciones del lado rojo superior",
     "Dibujar posiciones en el carril central",
     "Dibujar posiciones de dragón",
     "Dibujar posiciones laterales rojas del carril inferior",
     "Dibujar las posiciones de los arbustos del lado azul del carril inferior",
     "Dibujar posiciones de tres arbustos de Bot Lane",
     "[+] Último hit",
     "Número de esbirros",
     "¿Dibujar rango [R]?",
     "Dibujar [R] Color",
    "[+] Acoso"
}

local Turkish = {

 "[+] Dil",
     "[+] Kombo",
     "[Q]?",
     "[Q] yalnızca ADC'ye gönderilsin mi?",
     "[%] mana sınırı",
     "[W]?",
     "Cast [R]?",
     "> = ile ne zaman kullan",
    "[+] Waveclear",
     "[+] Kaç",
     "kaçmak için eşya kullanmak?",
     "[+] Çizim",
     "tüm çizimler devre dışı bırakılsın mı?",
     "[Q] Aralığı çizilsin mi?",
     "[Q] Rengi Çiz",
     "En İyi Mavi Taraf konumlarını çizin",
     "Renk",
     "En İyi Üç Bush pozisyonlarını çizin",
     "En İyi Kırmızı Taraf konumlarını çizin",
     "Orta Şerit konumlarını çizin",
     "Ejderha pozisyonlarını çizin",
     "Bot Lane Red Side postitions'ı çizin",
     "Alt Şerit Mavi Yan burç konumlarını çizin",
     "Bot Lane üç çalı pozisyonlarını çizin",
     "[+] Son Vuruş",
     "Minyon sayısı",
     "[R] Aralığı çizilsin mi?",
     "[R] Rengi Çiz",
  "[+] Taciz"
}
---[LOAD LANGUAGE]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
returns the table of strings depending on the chosen language
]]


UIMenu.teemo:AddMenu("Language", "[+] Language")
local Menu_Language = UIMenu.teemo.Language:AddDropDown("Menu_Language", "Choose language", { "English" ,"Espagnol", "Turkish"})

function loadLanguage()
    if Menu_Language.Value == "English" then
        return english
    elseif Menu_Language.Value == "Espagnol" then
        return Espagnol
    elseif Menu_Language.Value == "Turkish" then
        return Turkish
    end

end
---[LANGUAGE MENU]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
draws the menu
]]


local languageTable = loadLanguage()



---[COMBO MENU]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
draws the menu
]]
UIMenu.teemo:AddMenu("combo", languageTable[2])
local Q_Combo = UIMenu.teemo.combo:AddBool("Q_Combo", english[3], true)
local Q_ADC_Combo = UIMenu.teemo.combo:AddBool("Q_ADC_Combo", english[4], false)
local Q_Mana_Combo = UIMenu.teemo.combo:AddSlider("Q_Mana_Combo", english[5], 0, 100, 1, 30)

UIMenu.teemo.combo:AddLabel("s1", "--------------------")

local W_Combo = UIMenu.teemo.combo:AddBool("W_Combo", english[6], true)
local W_Type_Combo = UIMenu.teemo.combo:AddDropDown("W_Type_Combo", "When use [W]", { "Smart"  , "Always",  "Never" })
local W_Mana_Combo = UIMenu.teemo.combo:AddSlider("W_Mana_Combo", english[5], 0, 100, 1, 30)

UIMenu.teemo.combo:AddLabel("s2", "--------------------")

local R_Combo = UIMenu.teemo.combo:AddBool("R_Combo", english[7], false)
local R_Mana_Combo = UIMenu.teemo.combo:AddSlider("R_Mana_Combo", english[5], 0, 100, 1, 30)
local R_Shroom_Combo = UIMenu.teemo.combo:AddSlider("R_Shroom_Combo", english[8], 1, 3, 1, 3)

---[HARRAS MENU]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UIMenu.teemo:AddMenu("Harass",languageTable[29] )
local Q_Harass = UIMenu.teemo.Harass:AddBool("Q_Harass", english[3], true)
local Q_ADC_Harass = UIMenu.teemo.Harass:AddBool("Q_ADC_Harass", english[4], false)
local Q_Mana_Harass = UIMenu.teemo.Harass:AddSlider("Q_Mana_Harass", english[5], 0, 100, 1, 30)

UIMenu.teemo.Harass:AddLabel("s3", "--------------------")

local W_Harass = UIMenu.teemo.Harass:AddBool("W_Harass", english[6], true)
local W_Type_Harass = UIMenu.teemo.Harass:AddDropDown("W_Type_Harass", "When use [W]", { "Smart"  , "Always",  "Never"})
local W_Mana_Harass = UIMenu.teemo.Harass:AddSlider("W_Mana_Harass", english[5], 0, 100, 1, 30)
UIMenu.teemo.Harass:AddLabel("s4", "--------------------")

local R_Harass = UIMenu.teemo.Harass:AddBool("R_Harass", english[7], false)
local R_Mana_Harass = UIMenu.teemo.Harass:AddSlider("R_Mana_Harass", english[5], 0, 100, 1, 30)
local R_Shroom_Harass = UIMenu.teemo.Harass:AddSlider("R_Shroom_Harass", english[8], 1, 3, 1, 3)

---[FARM MENU]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
draws the menu
]]

UIMenu.teemo:AddMenu("Waveclear", languageTable[9])

local Q_Waveclear = UIMenu.teemo.Waveclear:AddBool("Q_Waveclear", english[3], false)
local Q_Mana_Waveclear = UIMenu.teemo.Waveclear:AddSlider("Q_Mana_Waveclear", english[5], 0, 100, 1, 50)
UIMenu.teemo.Waveclear:AddLabel("s5", "--------------------")

local R_Waveclear = UIMenu.teemo.Waveclear:AddBool("R_Waveclear", english[7], false)
local R_Mana_Waveclear = UIMenu.teemo.Waveclear:AddSlider("R_Mana_Waveclear", english[5], 0, 100, 1, 50)
local R_NMinions_Waveclear = UIMenu.teemo.Waveclear:AddSlider("R_NMinions_Waveclear", english[26], 1, 3, 1, 3)
local R_Shroom_Waveclear = UIMenu.teemo.Waveclear:AddSlider("R_Shroom_Waveclear", english[8], 1, 3, 1, 3)









---[LAST HIT MENU]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--[[
draws the menu
]]
UIMenu.teemo:AddMenu("LastHit", languageTable[25])

local Q_LastHit = UIMenu.teemo.LastHit:AddBool("Q_LastHit", english[3], false)
local Q_Mana_LastHit = UIMenu.teemo.LastHit:AddSlider("Q_Mana_LastHit", english[5], 0, 100, 1, 50)

---[FLEE MENU]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
draws the menu
]]
UIMenu.teemo:AddMenu("Flee", languageTable[10])
local W_Flee = UIMenu.teemo.Flee:AddBool("W_Flee", english[6], true)
local W_Flee_Mana = UIMenu.teemo.Flee:AddSlider("W_Flee_Mana", english[5], 0, 100, 1, 10)




---[DRAWING MENU]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
draws the menu
]]


--  DRAWING MENU
UIMenu.teemo:AddMenu("Drawing", languageTable[12])
--DISABLE ALL DRAWINGS
local Disable_Drawings = UIMenu.teemo.Drawing:AddBool("Disable_items", english[13], false)

--DRAW Q RANGE
local Q_Drawing = UIMenu.teemo.Drawing:AddBool("Q_Drawing", english[14], true)
local Q_Color_Drawing = UIMenu.teemo.Drawing:AddRGBAMenu("Q_Color_Drawing", english[15], 0xEF476FFF)

--DRAW R RANGE
local R_Drawing = UIMenu.teemo.Drawing:AddBool("R_Drawing", english[27], false)
local R_Color_Drawing = UIMenu.teemo.Drawing:AddRGBAMenu("R_Color_Drawing", english[28], 0xEF476FFF)


-- DRAW COMMON SHROOM POSITIONS IN TOP BLUE SIDE
local Top_Blue_Side = UIMenu.teemo.Drawing:AddBool("Top_Blue_Side", english[16], false)
local Top_Blue_Side_Color = UIMenu.teemo.Drawing:AddRGBAMenu("Top_Blue_Side_Color", english[17], 0xEF476FFF)

-- DRAW COMMON SHROOM POSITIONS IN TOP TRI BUSH SIDE
local Top_Tri_Bush_Side = UIMenu.teemo.Drawing:AddBool("Top_Tri_Bush_Side", english[18], false)
local Top_Tri_Bush_Color = UIMenu.teemo.Drawing:AddRGBAMenu("Top_Tri_Bush_Color", english[17], 0xEF476FFF)

-- DRAW COMMON SHROOM POSITIONS IN TOP RED SIDE
local Top_Red_Side = UIMenu.teemo.Drawing:AddBool("Top_Red_Side", english[19], false)
local Top_Red_Color = UIMenu.teemo.Drawing:AddRGBAMenu("Top_Red_Color", english[17], 0xEF476FFF)

-- DRAW COMMON SHROOM POSITIONS IN MID LANE SIDE
local Mid_Lane = UIMenu.teemo.Drawing:AddBool("Mid_Lane", english[20], false)
local Mid_Lane_Color = UIMenu.teemo.Drawing:AddRGBAMenu("Mid_Lane_Color", english[17], 0xEF476FFF)

-- DRAW COMMON SHROOM POSITIONS IN TOP DRAGON  SIDE
local Dragon = UIMenu.teemo.Drawing:AddBool("Dragon", english[21], false)
local Dragon_Color = UIMenu.teemo.Drawing:AddRGBAMenu("Dragon_Color", english[17], 0xEF476FFF)

-- DRAW COMMON SHROOM POSITIONS IN BOT RED  SIDE
local Bot_Red_Side = UIMenu.teemo.Drawing:AddBool("Bot_Red_Side", english[22], false)
local Bot_Red_Side_Color = UIMenu.teemo.Drawing:AddRGBAMenu("Bot_Red_Side_Color", english[17], 0xEF476FFF)

-- DRAW COMMON SHROOM POSITIONS IN BOT BLUE SIDE
local Bot_Blue_Side = UIMenu.teemo.Drawing:AddBool("Bot_Blue_Side", english[23], false)
local Bot_Blue_Side_Color = UIMenu.teemo.Drawing:AddRGBAMenu("Bot_Blue_Side_Color", english[17], 0xEF476FFF)

-- DRAW COMMON SHROOM POSITIONS IN BOT TRIE BUSHES SIDE
local Bot_Tri_Bushes = UIMenu.teemo.Drawing:AddBool("Bot_Tri_Bushes", english[24], false)
local Bot_Tri_Bushes_Color = UIMenu.teemo.Drawing:AddRGBAMenu("Bot_Tri_Bushes_Color", english[17], 0xEF476FFF)






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

local spellR = {
    Range = Player:GetSpell(SpellSlots.R).DisplayRange,
    Radius = 320,
    Delay = 0.25,
    Speed = 2000,
    Type = "Linear",

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

    if isUsable
            and (Player.AsAttackableUnit.Mana >= (manaPercent / 100) * Player.AsAttackableUnit.MaxMana)


    then
        Input.Cast(SpellSlots.W)
    end

end

---[CAST R ]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[CAST R :
+arguments : target  ,isUsable , manaPercent ,numberOfShrooms
]]
function CastR(target, isUsable, manaPercent
, numberOfShrooms
)
    local later = Game.GetTime()
    deltashroom = later - nowhshroom

    local targetAI = target.AsAI
    local position = nil

    if deltashroom >= 3.0 and
            targetAI and isUsable and Player.Position:Distance(target.Position) <= RRange()
            and Player:GetSpell(SpellSlots.R).Ammo >= numberOfShrooms
            and (Player.AsAttackableUnit.Mana >= (manaPercent / 100) * Player.AsAttackableUnit.MaxMana) then
        position = Prediction.GetPredictedPosition(targetAI, spellR, Player.Position)
        if position then
            if position.HitChance >= 0.5 then

                position = position.CastPosition
            else
                position = nil
            end
        end
    end

    if Player:GetSpellState(SpellSlots.R) == SpellStates.Ready
            and position then
        Input.Cast(SpellSlots.R, position)
        deltashroom = 0
        nowhshroom = later
    end


end



---[COMBO LOGIC]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



function Combo(target)
    CastR(target, R_Combo.Value, R_Mana_Combo.Value
    , R_Shroom_Combo.Value
    )
    if W_Type_Combo.Value == "Always" then
        CastW(W_Combo, W_Mana_Combo.Value)
    elseif Player.Position:Distance(target.Position) < target.AttackRange
            and W_Type_Combo.Value == "Smart"
    then
        CastW(W_Combo, W_Mana_Combo.Value)

    end
    CastQ(target, Q_ADC_Combo.Value, Q_Combo.Value, Q_Mana_Combo.Value)


end
---[HARASS LOGIC]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function Harass(target)

    CastR(target, R_Harass.Value, R_Mana_Harass.Value
    , R_Shroom_Harass.Value
    )

    CastQ(target, Q_ADC_Harass.Value, Q_Harass.Value, Q_Mana_Harass.Value)

    if W_Type_Combo.Value == "Always" then
        CastW(W_Combo, W_Mana_Combo.Value)
    elseif Player.Position:Distance(target.Position) < target.AttackRange
            and W_Type_Combo.Value == "Smart"
    then
        CastW(W_Combo, W_Mana_Combo.Value)

    end

end



---[FARM LOGIC ]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



function Farm()

    CastRMinions(R_Waveclear.Value, R_Mana_Waveclear.Value,
            R_Shroom_Waveclear.Value,
            R_NMinions_Waveclear.Value)
    CastQMinionsF(Q_Waveclear.Value, Q_Mana_Waveclear.Value)


end

---[LAST HIT LOGIC ]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




function LastHit()


    CastQMinionsLH(Q_LastHit.Value, Q_Mana_LastHit.Value)

end


------[FLEE LOGIC ]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



function Flee(target)

    CastW(W_Flee, W_Flee_Mana.Value)
end



---[Q LOGIC ON MINIONS (FOR LAST HIT )]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
contains the logic when temmo should use Q to last hit
]]

function CastQMinionsLH(isUsable, mana)

    if isUsable and (Player.AsAttackableUnit.Mana >= (mana / 100) * Player.AsAttackableUnit.MaxMana)

    then
        local minionsInRange = {}
        do
            GetMinions(minionsInRange, "neutral")
            GetMinions(minionsInRange, "enemy")
            sort(minionsInRange, function(a, b)
                return a.MaxHealth > b.MaxHealth
            end)
        end

        for k, minion in ipairs(minionsInRange) do

            local healthPred = HealthPred.GetHealthPrediction(minion, spellQ.Delay)
            local qDmg = DmgLib.CalculatePhysicalDamage(Player, minion, GetQDamage())

            if healthPred > 0 and healthPred < qDmg
            then
                Input.Cast(SpellSlots.Q, minion)

            end
        end


    end



    --if isUsable
    --
    --         and (Player.AsAttackableUnit.Mana >= (mana / 100) * Player.AsAttackableUnit.MaxMana)
    --    then
    --    for k, v in pairs(ObjManager.Get("enemy", "minions")) do
    --        local minion = v.AsAI
    --        if Player.Position:Distance(minion) < spellQ.Range and minion.IsTargetable then
    --
    --            Input.Cast(SpellSlots.Q, minion)
    --        end
    --    end
    --end

end






---[GET NEARBY MINIONS ]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


function GetMinions(table, type)
    for k, v in pairs(ObjManager.Get(type, "minions")) do
        local minion = v.AsAI
        local minionInRange = minion and minion.MaxHealth > 6
                and Player.Position:Distance(minion) <= spellQ.Range

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

            and (Player.AsAttackableUnit.Mana >= (mana / 100) * Player.AsAttackableUnit.MaxMana)
    then
        for k, v in pairs(ObjManager.Get("enemy", "minions")) do
            local minion = v.AsAI
            if Player.Position:Distance(minion) < spellQ.Range and minion.IsTargetable then

                Input.Cast(SpellSlots.Q, minion)
            end
        end
    end


end


------[R LOGIC ON MINIONS (FOR WAVECLEAR )]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
contains the logic when temmo should use R to WAVECLEAR
]]


function CastRMinions(isUsable, mana,
                      nShroom,
                      nMinions)


    local later = Game.GetTime()
    deltashroom = later - nowhshroom

    if isUsable and
            deltashroom >= 3.0
            and (Player.AsAttackableUnit.Mana >= (mana / 100) * Player.AsAttackableUnit.MaxMana)
            and Player:GetSpell(SpellSlots.R).Ammo >= nShroom
    then

        local points = {}
        local minionCount = nMinions
        local minions = ObjectManager.Get("enemy", "minions")

        for i, minion in pairs(minions) do
            local nminion = minion.AsAI
            if nminion then
                local predPos = nminion:FastPrediction(spellR.Delay)
                local dist = predPos:Distance(Player.Position)
                if dist < RRange() then
                    points[#points + 1] = predPos
                end
            end
        end

        local bestPos, hitCount = Geometry.BestCoveringCircle(points, 160)
        if bestPos and hitCount >= minionCount then
            Input.Cast(SpellSlots.R, bestPos)

            deltashroom = 0
            nowhshroom = later

        end

    end


end

---[GET Q DAMAGE ]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


function GetQDamage()

    return (35 + Player:GetSpell(SpellSlots.Q).Level * 45) + (0.8 * Player.TotalAP)
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

------[ON GAP CLOSE]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function OnGapclose(source, dash)


    if (Orbwalker.GetMode() == "Combo" or Orbwalker.GetMode() == "Harass")
            and not (W_Type_Combo.Value == "Never") then
        if not (source.IsEnemy and W_Combo.Value) then
            return
        end

        local paths = dash:GetPaths()
        local endPos = paths[#paths].EndPos
        local pPos = Player.Position
        local pDist = pPos:Distance(endPos)

        if pDist < 400 and pDist < pPos:Distance(dash.StartPos) and source:IsFacing(pPos) then
            CastW(W_Combo, W_Mana_Combo.Value)
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
                    CastW(W_Harass, W_Mana_Harass.Value)
                end
            end
        end
    end


end


---[ON DRAW]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
function RRange()
    if Player:GetSpell(SpellSlots.R).Level==1 then
        return 400
        elseif Player:GetSpell(SpellSlots.R).Level==2 then
        return 650
        elseif Player:GetSpell(SpellSlots.R).Level==3 then
        return 900
    end
    
end
------[ON DRAW]----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--[[
specify what to show on player's  screen ]]


function OnDraw()


    if not Disable_Drawings.Value then


        if Player:GetSpellState(SpellSlots.Q) == SpellStates.Ready and Q_Drawing.Value then
            Renderer.DrawCircle3D(Player.Position, spellQ.Range, 30, 2, Q_Color_Drawing.Value)
        end

        if Player:GetSpellState(SpellSlots.R) == SpellStates.Ready and R_Drawing.Value then
            Renderer.DrawCircle3D(Player.Position, RRange(), 30, 2, R_Color_Drawing.Value)
        end

        if Mid_Lane.Value then

            Renderer.DrawCircle3D(Vector(6484, -71.2406, 8380), 80, 3, 1, Mid_Lane_Color.Value)
            Renderer.DrawCircle3D(Vector(8380, -71.2406, 6502), 80, 3, 1, Mid_Lane_Color.Value)
            Renderer.DrawCircle3D(Vector(9099.75, 52.95337, 7376.637), 80, 3, 1, Mid_Lane_Color.Value)

            Renderer.DrawCircle3D(Vector(7376, 52.8726, 8802), 80, 3, 1, Mid_Lane_Color.Value)
            Renderer.DrawCircle3D(Vector(5776, 52.8726, 7402), 80, 3, 1, Mid_Lane_Color.Value)
            Renderer.DrawCircle3D(Vector(7602, 52.56985, 5928), 80, 3, 1, Mid_Lane_Color.Value)


        end



        --Dragon
        if Dragon.Value then
            Renderer.DrawCircle3D(Vector(9372, -71.2406, 5674), 80, 3, 1, Dragon_Color.Value)
            Renderer.DrawCircle3D(Vector(10148, -71.2406, 4801.525), 80, 3, 1, Dragon_Color.Value)

        end


        --  Top Lane Blue Side + Baron
        if Top_Blue_Side.Value then


            Renderer.DrawCircle3D(Vector(2790, 50.16358, 7278), 80, 3, 1, Top_Blue_Side_Color.Value)
            Renderer.DrawCircle3D(Vector(3700.708, -11.22648, 9294.094), 80, 3, 1, Top_Blue_Side_Color.Value)
            Renderer.DrawCircle3D(Vector(2314, 53.165, 9722), 80, 3, 1, Top_Blue_Side_Color.Value)
            Renderer.DrawCircle3D(Vector(3090, -68.03732, 10810), 80, 3, 1, Top_Blue_Side_Color.Value)
            Renderer.DrawCircle3D(Vector(4722, -71.2406, 10010), 80, 3, 1, Top_Blue_Side_Color.Value)

            Renderer.DrawCircle3D(Vector(5208, -71.2406, 9114), 80, 3, 1, Top_Blue_Side_Color.Value)
            Renderer.DrawCircle3D(Vector(4400, 52.53909, 7240), 80, 3, 1, Top_Blue_Side_Color.Value)
            Renderer.DrawCircle3D(Vector(4564, 51.83786, 6060), 80, 3, 1, Top_Blue_Side_Color.Value)
            Renderer.DrawCircle3D(Vector(2760, 52.96445, 5178), 80, 3, 1, Top_Blue_Side_Color.Value)
            Renderer.DrawCircle3D(Vector(4440, 56.8484, 11840), 80, 3, 1, Top_Blue_Side_Color.Value)

        end


        --Bot Lane Red Side
        if Bot_Red_Side.Value then

            Renderer.DrawCircle3D(Vector(9772, 9.031885, 6458), 80, 3, 1, Bot_Red_Side_Color.Value)
            Renderer.DrawCircle3D(Vector(9938, 51.62378, 7900), 80, 3, 1, Bot_Red_Side_Color.Value)
            Renderer.DrawCircle3D(Vector(11465, 51.72557, 7157.772), 80, 3, 1, Bot_Red_Side_Color.Value)
            Renderer.DrawCircle3D(Vector(12481, 51.7294, 5232.559), 80, 3, 1, Bot_Red_Side_Color.Value)

            Renderer.DrawCircle3D(Vector(11266, -7.897567, 5542), 80, 3, 1, Bot_Red_Side_Color.Value)
            Renderer.DrawCircle3D(Vector(11290, 64.39886, 8694), 80, 3, 1, Bot_Red_Side_Color.Value)
            Renderer.DrawCircle3D(Vector(12676, 51.6851, 7310.818), 80, 3, 1, Bot_Red_Side_Color.Value)
            Renderer.DrawCircle3D(Vector(12022, 9154, 51.25105), 80, 3, 1, Bot_Red_Side_Color.Value)


        end


        --Top Lane Tri Bush

        if Top_Tri_Bush_Side.Value then


            Renderer.DrawCircle3D(Vector(2420, 52.8381, 13482), 80, 3, 1, Top_Tri_Bush_Color.Value)
            Renderer.DrawCircle3D(Vector(1630, 52.8381, 13008), 80, 3, 1, Top_Tri_Bush_Color.Value)
            Renderer.DrawCircle3D(Vector(1172, 52.8381, 12302), 80, 3, 1, Top_Tri_Bush_Color.Value)

            Renderer.DrawCircle3D(Vector(3020, 52.8381, 12182), 80, 3, 1, Top_Tri_Bush_Color.Value)
            Renderer.DrawCircle3D(Vector(2472, 52.8381, 11702), 80, 3, 1, Top_Tri_Bush_Color.Value)

        end


        --Top Lane Red Side

        if Top_Red_Side.Value then


            Renderer.DrawCircle3D(Vector(5666, 52.8381, 12722), 80, 3, 1, Top_Red_Color.Value)
            Renderer.DrawCircle3D(Vector(8004, 56.4768, 11782), 80, 3, 1, Top_Red_Color.Value)
            Renderer.DrawCircle3D(Vector(9194, 53.35013, 11368), 80, 3, 1, Top_Red_Color.Value)

            Renderer.DrawCircle3D(Vector(8280, 50.06194, 10254), 80, 3, 1, Top_Red_Color.Value)
            Renderer.DrawCircle3D(Vector(6728, 53.82967, 11450), 80, 3, 1, Top_Red_Color.Value)
            Renderer.DrawCircle3D(Vector(5980, 53.82967, 11150), 80, 3, 1, Top_Red_Color.Value)
            Renderer.DrawCircle3D(Vector(6242, 54.09851, 10270), 80, 3, 1, Top_Red_Color.Value)


        end




        -- Bot Lane Blue Side+bushes
        if Bot_Blue_Side.Value then


            Renderer.DrawCircle3D(Vector(6544, 48.257, 4732), 80, 3, 1, Bot_Blue_Side_Color.Value)
            Renderer.DrawCircle3D(Vector(5576, 51.42581, 3512), 80, 3, 1, Bot_Blue_Side_Color.Value)
            Renderer.DrawCircle3D(Vector(6888, 51.94016, 3082), 80, 3, 1, Bot_Blue_Side_Color.Value)
            Renderer.DrawCircle3D(Vector(8070, 51.5508, 3472), 80, 3, 1, Bot_Blue_Side_Color.Value)

            Renderer.DrawCircle3D(Vector(8594, 51.73177, 4668), 80, 3, 1, Bot_Blue_Side_Color.Value)
            Renderer.DrawCircle3D(Vector(10388, 49.81641, 3046), 80, 3, 1, Bot_Blue_Side_Color.Value)
            Renderer.DrawCircle3D(Vector(9160, 59.97022, 2122), 80, 3, 1, Bot_Blue_Side_Color.Value)


        end


        -- Bot Lane tri bushes++
        if Bot_Tri_Bushes.Value then
            Renderer.DrawCircle3D(Vector(12518, 53.66707, 1504), 80, 3, 1, Bot_Tri_Bushes_Color.Value)
            Renderer.DrawCircle3D(Vector(13404, 51.3669, 2482), 80, 3, 1, Bot_Tri_Bushes_Color.Value)
            Renderer.DrawCircle3D(Vector(11854, -68.06037, 3922), 80, 3, 1, Bot_Tri_Bushes_Color.Value)

        end

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
