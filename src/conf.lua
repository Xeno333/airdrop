

core.register_chatcommand("serverdrop_conf", {
    description = "serverdrop",
    privs = {["serverdrop"] = true},
    func = function(name)            
        core.show_formspec(name, "serverdrop_conf", serverdrop.make_formspec())
        return true, nil
    end
})

core.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "serverdrop_conf" then return end

    print(dump(fields))

    -- Entered
    if fields.set_item_chance and type(fields.item) == "string" then
        local chance = tonumber(fields.chance)

        if chance and chance >= 1 then
            -- New chance
            local done, name, max_count, _ = serverdrop.api.unregister_loot(fields.item)
            if done then
                serverdrop.api.register_loot(name, max_count, chance)

                core.show_formspec(player:get_player_name(), "serverdrop_conf", serverdrop.make_formspec(fields.item))
            end
        end

    elseif fields.item then
        core.show_formspec(player:get_player_name(), "serverdrop_conf", serverdrop.make_formspec(fields.item))
    end
end)


core.register_chatcommand("add_serverdrop_area", {
    description = "Add serverdrop area",
    params = "<xmin> <ymin> <zmin> <xmax> <ymax> <zmax>",
    privs = {["serverdrop"] = true},
    func = function(name, param)
        local params = {}
        for p in param:gmatch("%S+") do
            params[#params+1] = p
        end

        local rc = serverdrop.api.register_range({
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
