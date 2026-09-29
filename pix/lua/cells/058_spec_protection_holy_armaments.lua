-- 防骑军备形态：灰度字节 0=未知、1=神圣壁垒、2=圣洁武器。
-- 只比较普通替代技能 ID；未识别时清零，不沿用上一次形态。
local addonName, addonTable = ...
local X = 58
local cell
local eventFrame = CreateFrame("Frame")
local function Refresh()
    if not cell then return end
    local state = 0
    local _, class = UnitClass("player")
    if class == "PALADIN" and GetSpecialization() == 2 then
        local spellID = C_Spell.GetOverrideSpell(375576)
        if not issecretvalue(spellID) then
            if spellID == 432459 then state = 1
            elseif spellID == 432472 then state = 2 end
        end
    end
    local value = state / 255
    cell:setCellRGBA(value, value, value)
end
local function Initialize()
    cell = addonTable.Cell:New({ x = X })
    Refresh()
end
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("SPELLS_CHANGED")
eventFrame:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
eventFrame:RegisterEvent("SPELL_UPDATE_ICON")
eventFrame:SetScript("OnEvent", function() C_Timer.After(0, Refresh) end)
local elapsedTime = -math.random()
eventFrame:SetScript("OnUpdate", function(_, elapsed)
    elapsedTime = elapsedTime + elapsed
    if elapsedTime >= 1 then
        elapsedTime = elapsedTime % 1
        Refresh()
    end
end)
table.insert(addonTable.UIInitFuncs, Initialize)
