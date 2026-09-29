-- 治疗阈值使用普通整数灰度字节，数值直接表示百分数。
local addonName, addonTable = ...
local X = 61
local config = addonTable.Config("word_of_glory_progress_health_pct")
local cell
config:set_default(90)
table.insert(addonTable.ConfigRows, {
    type = "slider",
    name = "荣耀圣令：叠层",
    tooltip = "闪耀之光2层、小闪耀之光2层、圣能至少3、法力至少50%时的自身治疗血量阈值。",
    bind_config = config,
    default_value = 90,
    min_value = 70,
    max_value = 100,
    step = 1,
})
local function Refresh()
    if not cell then return end
    local value = math.floor(math.max(70, math.min(100, config:get_value())) + 0.5) / 255
    cell:setCellRGBA(value, value, value)
end
local function Initialize()
    cell = addonTable.Cell:New({ x = X })
    Refresh()
end
config:register_callback(Refresh)
table.insert(addonTable.UIInitFuncs, Initialize)
