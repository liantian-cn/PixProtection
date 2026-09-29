-- 治疗阈值使用普通整数灰度字节，数值直接表示百分数。
local addonName, addonTable = ...
local X = 59
local config = addonTable.Config("word_of_glory_two_stacks_health_pct")
local cell
config:set_default(75)
table.insert(addonTable.ConfigRows, {
    type = "slider",
    name = "荣耀圣令：双层",
    tooltip = "闪耀之光2层、法力至少20%时的自身治疗血量阈值。",
    bind_config = config,
    default_value = 75,
    min_value = 55,
    max_value = 95,
    step = 1,
})
local function Refresh()
    if not cell then return end
    local value = math.floor(math.max(55, math.min(95, config:get_value())) + 0.5) / 255
    cell:setCellRGBA(value, value, value)
end
local function Initialize()
    cell = addonTable.Cell:New({ x = X })
    Refresh()
end
config:register_callback(Refresh)
table.insert(addonTable.UIInitFuncs, Initialize)
