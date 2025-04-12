-- advtrains_ks_sh2/init.lua
-- Advtrains Ks: Sh2
-- Copyright (C) 2024  1F616EMO
-- SPDX-License-Identifier: AGPL-3.0-or-later

local S = minetest.get_translator("advtrains_ks_sh2")
local rotation_sbox = { -1 / 4, -1 / 2, -1 / 4, 1 / 4, -7 / 16, 1 / 4 }
local rtn_sh2_aspect = function()
    return {
        main = 0,
        shunt = false,
        proceed_as_main = true,
        dst = false,
        info = {}
    }
end

local function on_rightclick(pos, _, player)
    local pname = player:get_player_name()
    if pname == "" then return end
    return advtrains.interlocking.show_ip_form(pos, pname)
end

for _, rtab in ipairs({
    { rot = "0",  sbox = { -1 / 8, -1 / 2, -1 / 2, 1 / 8, 1 / 2, -1 / 4 },  ici = true, nextrot = "30" },
    { rot = "30", sbox = { -3 / 8, -1 / 2, -1 / 2, -1 / 8, 1 / 2, -1 / 4 }, nextrot = "45" },
    { rot = "45", sbox = { -1 / 2, -1 / 2, -1 / 2, -1 / 4, 1 / 2, -1 / 4 }, nextrot = "60"},
    { rot = "60", sbox = { -1 / 2, -1 / 2, -3 / 8, -1 / 4, 1 / 2, -1 / 8 }, nextrot = "0"},
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
            advtrains_signal = 1,
            not_blocking_trains = 1,
            save_in_at_nodedb = 1,
            not_in_creative_inventory = rtab.ici and 0 or 1,
        },
        drop = "advtrains_ks_sh2:sh2_sh2_0",
        inventory_image = "advtrains_ks_sh2_sh2.png",
        advtrains = {
            main_aspects = {
                {
                    name = "proceed",
                    description = "Proceed",
                }
            },
            get_aspect_info = rtn_sh2_aspect,
            route_role = "end",
            trackworker_next_rot = "advtrains_ks_sh2:sh2_sh2_"..rtab.nextrot,
            trackworker_rot_incr_param2 = (rtab.rot=="60")
        },
        on_rightclick = on_rightclick,
        can_dig = advtrains.interlocking.signal.can_dig,
        after_dig_node = advtrains.interlocking.signal.after_dig,
    })
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
