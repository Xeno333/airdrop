serverdrop = {
    api = {},

    code_loc = core.get_modpath("serverdrop") .. "/src",
    storage = core.get_mod_storage()
}

serverdrop.serverdrop_ranges = core.deserialize(serverdrop.storage:get_string("serverdrop_ranges") or "") or {}
serverdrop.serverdrop_items = core.deserialize(serverdrop.storage:get_string("serverdrop_items") or "") or {}



dofile(serverdrop.code_loc .. "/priv.lua")
dofile(serverdrop.code_loc .. "/api.lua")
dofile(serverdrop.code_loc .. "/conf.lua")
dofile(serverdrop.code_loc .. "/serverdrop.lua")
dofile(serverdrop.code_loc .. "/do_serverdrop.lua")



