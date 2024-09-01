-- advtrains_ks_sh2/init.lua
-- Advtrains Ks: Sh2
-- Copyright (C) 2024  1F616EMO
-- SPDX-License-Identifier: AGPL-3.0-or-later

local S = minetest.get_translator("advtrains_ks_sh2")
local rotation_sbox = { -1 / 4, -1 / 2, -1 / 4, 1 / 4, -7 / 16, 1 / 4 }
local rtn_sh2_aspect = function()
    return advtrains.interlocking.DANGER
end

advtrains.trackplacer.register_tracktype("advtrains_ks_sh2:sh2")
for _, rtab in ipairs({
    { rot = "0",  sbox = { -1 / 8, -1 / 2, -1 / 2, 1 / 8, 1 / 2, -1 / 4 },  ici = true },
    { rot = "30", sbox = { -3 / 8, -1 / 2, -1 / 2, -1 / 8, 1 / 2, -1 / 4 }, },
    { rot = "45", sbox = { -1 / 2, -1 / 2, -1 / 2, -1 / 4, 1 / 2, -1 / 4 }, },
    { rot = "60", sbox = { -1 / 2, -1 / 2, -3 / 8, -1 / 4, 1 / 2, -1 / 8 }, },
}) do
    minetest.register_node("advtrains_ks_sh2:sh2_sh2_" .. rtab.rot, {
        description = S("Ks Sh2 Signal"),
        drawtype = "mesh",
        mesh = "advtrains_signals_ks_sign_smr" .. rtab.rot .. ".obj",
        tiles = { "advtrains_signals_ks_signpost.png", "advtrains_ks_sh2_sh2.png" },

        paramtype = "light",
        sunlight_propagates = true,
        light_source = 4,

        paramtype2 = "facedir",
        selection_box = {
            type = "fixed",
            fixed = { rtab.sbox, rotation_sbox }
        },
        collision_box = {
            type = "fixed",
            fixed = rtab.sbox,
        },
        groups = {
            cracky = 2,
            advtrains_signal = 2,
            not_blocking_trains = 1,
            save_in_at_nodedb = 1,
            not_in_creative_inventory = rtab.ici and 0 or 1,
        },
        drop = "advtrains_ks_sh2:sh2_sh2_0",
        inventory_image = "advtrains_ks_sh2_sh2.png",
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
