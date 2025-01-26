


function serverdrop.do_serverdrop(name)
    -- If not properly configured.
    if #serverdrop.serverdrop_ranges == 0 then
        return false, core.colorize("#ff0000", "[ServerDrop] /serverdrop_conf")
    end

    local start_time = core.get_us_time()

    local range = serverdrop.serverdrop_ranges[math.random(#serverdrop.serverdrop_ranges)]

    local pos = {
        x = math.random(range.min.x, range.max.x),
        y = math.random(range.min.y, range.max.y),
        z = math.random(range.min.z, range.max.z)
    }

    core.emerge_area(pos, pos, function()
        core.set_node(pos, {name="serverdrop:serverdrop"}) -- The airdoping code is in the on_construct
        core.fix_light(pos, pos)

        if name then
            core.chat_send_player(name, core.colorize("#00ff00", "[ServerDrop] t=" .. core.get_us_time() - start_time .. " us     (" .. pos.x .. ", " .. pos.y .. ", " .. pos.z .. ")"))
        end
    end, nil)
    
    return true, core.colorize("#ffff00", "[ServerDrop] Queued...")
end


core.register_chatcommand("serverdrop", {
    description = "ServerDrop",
    privs = {["serverdrop"] = true},
    func = function(name)
        return serverdrop.do_serverdrop(name)
    end
})






local function random_serverdrop()
    serverdrop.do_serverdrop()
    core.after(60*60*math.random(6, 12), random_serverdrop)
end


core.after(60*60*math.random(6, 12), random_serverdrop)