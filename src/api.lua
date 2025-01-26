local serverdrop_inv -- inv


local function update_inv()
    local c = 1
    for _, v in pairs(serverdrop.serverdrop_items) do
        serverdrop_inv:set_size("main", c)

        local stack = ItemStack(v.name)
        stack:set_count(v.max_count)
        serverdrop_inv:set_stack("main", c, stack)

        c = c + 1
    end

    serverdrop_inv:set_size("main", c )
    serverdrop_inv:set_stack("main", c, ItemStack(""))
end

core.register_on_mods_loaded(update_inv)





-- Range

function serverdrop.api.register_range(range)
    if range and range.max and range.min and type(range.max.x) == "number" and type(range.max.y) == "number" and type(range.max.z) == "number" and type(range.min.x) == "number" and type(range.min.y) == "number" and type(range.min.z) == "number" then
        serverdrop.serverdrop_ranges[#serverdrop.serverdrop_ranges+1] = range

        serverdrop.storage:set_string("serverdrop_ranges", core.serialize(serverdrop.serverdrop_ranges) or "")

        return true
    end

    return false
end



-- Loot

function serverdrop.api.register_loot(name, max_count, one_out_of_chance)
    if not type(name) == "string" then return false end

    if (not serverdrop.serverdrop_items[name]) and type(one_out_of_chance) == "number" and one_out_of_chance >= 1 and type(max_count) == "number" and max_count >= 1 then
        serverdrop.serverdrop_items[name] = {
            name = name,
            max_count = max_count,
            chance = one_out_of_chance
        }

        serverdrop.storage:set_string("serverdrop_items", core.serialize(serverdrop.serverdrop_items) or "")

        update_inv()

        return true
    end

    return false
end


-- Returns old def
function serverdrop.api.unregister_loot(name)
    if not type(name) == "string" then return false, nil, nil, nil end

    if serverdrop.serverdrop_items[name] then
        local def = serverdrop.serverdrop_items[name]
        serverdrop.serverdrop_items[name] = nil

        serverdrop.storage:set_string("serverdrop_items", core.serialize(serverdrop.serverdrop_items) or "")

        update_inv()

        return true, def.name, def.max_count, def.chance
    end

    return false, nil, nil, nil
end

-- Returns old def
function serverdrop.api.get_loot_chance(name)
    if not type(name) == "string" then return false, nil end

    if serverdrop.serverdrop_items[name] then
        return true, serverdrop.serverdrop_items[name].chance
    end

    return false, nil
end




-- Formspec

function serverdrop.make_formspec(item)
    local formspec =  "formspec_version[3]size[14,8]"..
        "scroll_container[2,1;10,2;inv_scroll_bar;horizontal;0.1]"..
        "list[detached:serverdrop_inv;main;0,0;" .. serverdrop_inv:get_size("main") .. ",1;]"..
        "scroll_container_end[]"..
        "scrollbaroptions[arrows=show]scrollbar[0.2,0.5;0.5,3;vertical;inv_scroll_bar;0]"..

        "dropdown[3,4;4,0.6;item;"

    local items = {}
    local inverse_items = {}
    
    local i = 0
    for n, _ in pairs(serverdrop.serverdrop_items) do
        i = i + 1
        if i ~= 1 then
            formspec = formspec .. ","
        end

        items[n] = i
        inverse_items[#inverse_items+1] = n

        formspec = formspec .. n
    end


    -- index and chance

    local index = 1
    if item then
        index = items[item] or 1
    end

    local done, chance = serverdrop.api.get_loot_chance(inverse_items[index] or "")
    if not done or not chance then chance = "" end
 
 
    formspec = formspec  .. ";" .. index .. "]"..
        "field[7,4;2,0.6;chance;1/X chance;" .. chance .. "]"..
        "button[9.5,4;1,0.6;set_item_chance;Set]"..

        "list[current_player;main;2,6;8,1;]"

    return formspec
end




-- inv

serverdrop_inv = core.create_detached_inventory("serverdrop_inv", {
    allow_move = function(_, _, _, _, _, _, _)
        return 0
    end,
    allow_put = function(_, _, _, stack, _)
        local count = stack:get_count()

        stack:set_count(1)
        if serverdrop.serverdrop_items[stack:to_string()] then
            return 0
        end

        return count
    end,
    allow_take = function(_, _, _, stack, _)        
        return stack:get_count()
    end,

    on_put = function(inv, listname, index, stack, player)
        local count = stack:get_count()
        stack:set_count(1)
        serverdrop.api.register_loot(stack:to_string(), count, 100)

        core.show_formspec(player:get_player_name(), "serverdrop_conf", serverdrop.make_formspec())
    end,
    on_take = function(inv, listname, index, stack, player)
        stack:set_count(1)
        serverdrop.api.unregister_loot(stack:to_string())
        core.show_formspec(player:get_player_name(), "serverdrop_conf", serverdrop.make_formspec())
    end,
})


-- Add a form for setting chance