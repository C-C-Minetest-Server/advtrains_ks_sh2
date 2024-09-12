-- advtrains_ks_sh2/init.lua
-- Advtrains Ks: Sh2
-- Copyright (C) 2024  1F616EMO
-- SPDX-License-Identifier: AGPL-3.0-or-later

local S = minetest.get_translator("advtrains_ks_sh2")
local rtn_sh2_aspect = function()
    return advtrains.interlocking.DANGER
end

advtrains.trackplacer.register_tracktype("advtrains_ks_sh2:sh2")
for _, rtab in ipairs({
    { rot = "0",  r = 0, ici = true },
    { rot = "30", r = math.atan(1/2) },
    { rot = "45", r = math.rad(45) },
    { rot = "60", r = math.atan(2) },
}) do
    local box_bound = 1/16*math.sqrt(2)*math.max(math.sin(rtab.r+math.rad(45)), math.cos(rtab.r+math.rad(45)))
    local sbox = {-box_bound, -1/2, -box_bound, box_bound, 1, box_bound}
    minetest.register_node("advtrains_ks_sh2:sh2_sh2_" .. rtab.rot, {
        description = S("Ks Sh2 Signal"),
        drawtype = "mesh",
        mesh = "advtrains_ks_sh2_smr" .. rtab.rot .. ".obj",
        tiles = { "advtrains_ks_sh2_sh2.png" },

        paramtype = "light",
        sunlight_propagates = true,
        -- light_source = 4,

        paramtype2 = "facedir",
        selection_box = {
            type = "fixed",
            fixed = sbox,
        },
        collision_box = {
            type = "fixed",
            fixed = sbox,
        },
        groups = {
            cracky = 2,
            advtrains_signal = 2,
            not_blocking_trains = 1,
            save_in_at_nodedb = 1,
            not_in_creative_inventory = rtab.ici and 0 or 1,
        },
        drop = "advtrains_ks_sh2:sh2_sh2_0",
        inventory_image = "[combine:38x30:-2,0=advtrains_ks_sh2_sh2.png",
        advtrains = {
            get_aspect = rtn_sh2_aspect
        },
        on_rightclick = advtrains.interlocking.signal_rc_handler,
        can_dig = advtrains.interlocking.signal_can_dig,
        after_dig_node = advtrains.interlocking.signal_after_dig,
    })

    advtrains.trackplacer.add_worked("advtrains_ks_sh2:sh2", "sh2", "_" .. rtab.rot)
end

local sign_material = "default:sign_wall_steel" --fallback
if minetest.get_modpath("basic_materials") then
    sign_material = "basic_materials:plastic_sheet"
end

minetest.register_craft({
    output = "advtrains_ks_sh2:sh2_sh2_0 2",
    recipe = {
        { sign_material,   'dye:red' },
        { 'default:stick', '' },
        { 'default:stick', '' },
    },
})
