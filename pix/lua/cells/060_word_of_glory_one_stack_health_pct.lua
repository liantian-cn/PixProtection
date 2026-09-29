-- 治疗阈值使用普通整数灰度字节，数值直接表示百分数。
local addonName, addonTable = ...
local X = 60
local config = addonTable.Config("word_of_glory_one_stack_health_pct")
local cell
config:set_default(55)
table.insert(addonTable.ConfigRows, {
    type = "slider",
    name = "荣耀圣令：单层",
    tooltip = "闪耀之光1层、法力至少5%时的自身治疗血量阈值。",
    bind_config = config,
    default_value = 55,
    min_value = 35,
    max_value = 75,
    step = 1,
})
local function Refresh()
    if not cell then return end
    local value = math.floor(math.max(35, math.min(75, config:get_value())) + 0.5) / 255
    cell:setCellRGBA(value, value, value)
end
local function Initialize()
    cell = addonTable.Cell:New({ x = X })
    Refresh()
end
config:register_callback(Refresh)
table.insert(addonTable.UIInitFuncs, Initialize)
