


function airdrop.do_airdrop(name)
    -- If not properly configured.
    if #airdrop.airdrop_ranges == 0 then
        return false, core.colorize("#ff0000", "[Airdrop] /airdrop_conf")
    end

    local start_time = core.get_us_time()

    local range = airdrop.airdrop_ranges[math.random(#airdrop.airdrop_ranges)]

    local pos = {
        x = math.random(range.min.x, range.max.x),
        y = math.random(range.min.y, range.max.y),
        z = math.random(range.min.z, range.max.z)
    }

    core.emerge_area(pos, pos, function()
        core.set_node(pos, {name="airdrop:airdrop"}) -- The airdoping code is in the on_construct
        core.fix_light(pos, pos)

        if name then
            core.chat_send_player(name, core.colorize("#00ff00", "[Airdrop] t=" .. core.get_us_time() - start_time .. " us     (" .. pos.x .. ", " .. pos.y .. ", " .. pos.z .. ")"))
        end
    end, nil)
    
    return true, core.colorize("#ffff00", "[Airdrop] Queued...")
end


core.register_chatcommand("airdrop", {
    description = "Airdrop",
    privs = {["airdrop"] = true},
    func = function(name)
        return airdrop.do_airdrop(name)
    end
})






local function random_airdrop()
    airdrop.do_airdrop()
    core.after(60*60*math.random(6, 12), random_airdrop)
end


core.after(60*60*math.random(6, 12), random_airdrop)