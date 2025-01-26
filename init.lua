airdrop = {
    api = {},

    code_loc = core.get_modpath("airdrop") .. "/src",
    storage = core.get_mod_storage()
}

airdrop.airdrop_ranges = core.deserialize(airdrop.storage:get_string("airdrop_ranges") or "") or {}
airdrop.airdrop_items = core.deserialize(airdrop.storage:get_string("airdrop_items") or "") or {}



dofile(airdrop.code_loc .. "/priv.lua")
dofile(airdrop.code_loc .. "/api.lua")
dofile(airdrop.code_loc .. "/conf.lua")
dofile(airdrop.code_loc .. "/airdrop.lua")
dofile(airdrop.code_loc .. "/do_airdrop.lua")



