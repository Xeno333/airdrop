

core.register_chatcommand("airdrop_conf", {
    description = "Airdrop",
    privs = {["airdrop"] = true},
    func = function(name)            
        core.show_formspec(name, "airdrop_conf", airdrop.make_formspec())
        return true, nil
    end
})

core.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "airdrop_conf" then return end

    print(dump(fields))

    -- Entered
    if fields.set_item_chance and type(fields.item) == "string" then
        local chance = tonumber(fields.chance)

        if chance and chance >= 1 then
            -- New chance
            local done, name, max_count, _ = airdrop.api.unregister_loot(fields.item)
            if done then
                airdrop.api.register_loot(name, max_count, chance)

                core.show_formspec(player:get_player_name(), "airdrop_conf", airdrop.make_formspec(fields.item))
            end
        end

    elseif fields.item then
        core.show_formspec(player:get_player_name(), "airdrop_conf", airdrop.make_formspec(fields.item))
    end
end)


core.register_chatcommand("add_airdrop_area", {
    description = "Add airdrop area",
    params = "<xmin> <ymin> <zmin> <xmax> <ymax> <zmax>",
    privs = {["airdrop"] = true},
    func = function(name, param)
        local params = {}
        for p in param:gmatch("%S+") do
            params[#params+1] = p
        end

        local rc = airdrop.api.register_range({
            min={
                x=tonumber(params[1]),
                y=tonumber(params[2]),
                z=tonumber(params[3])
            },
            max={
                x=tonumber(params[4]),
                y=tonumber(params[5]),
                z=tonumber(params[6])
            },
        })

        if rc then return true, core.colorize("#00ff00", "Done") end

        return false, core.colorize("#ff0000", "Failed")
    end
})
