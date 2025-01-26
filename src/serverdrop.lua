

core.register_node("serverdrop:serverdrop", {
    description = "ServerDrop",
    tiles = {"serverdrop_serverdrop.png"},
    light_source = 10,
    drop = "",

    on_construct = function(pos)
        core.chat_send_all(core.colorize("#ffff00", "[ServerDrop] (" .. pos.x .. ", " .. pos.y .. ", " .. pos.z .. ")"))
    end,

    after_dig_node = function(pos, _, _, digger)
        local to_drop = 16 -- Number to drop

        for _=1, 1024 do -- Worst case
            for _, v in pairs(serverdrop.serverdrop_items) do
                if math.random(v.chance) == 1 then
                    local item = ItemStack(v.name)
                    item:set_count(math.random(v.max_count)) -- Drope node

                    core.add_item(pos, item)

                    to_drop = to_drop - 1
                end

                if to_drop == 0 then break end
            end

            if to_drop == 0 then break end
        end

        if digger:is_player() then
            core.chat_send_all(core.colorize("#ff00ff", "[ServerDrop] " .. digger:get_player_name() .. " @ (" .. pos.x .. ", " .. pos.y .. ", " .. pos.z .. ")"))
        end
    end,

    groups = {dig_immediate = 3}
})