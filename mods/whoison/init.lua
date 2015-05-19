-- Rewrite of whoison mod, LeMagnesium
--

whoison = {}
whoison.datas = {}
whoison.config = {}
whoison.config.save_interval = 10
whoison.functions = {}

dofile(minetest.get_modpath("whoison") .. "/functions.lua")

-- Boot, Step 0, open presence file
whoison.presence_file = io.open(minetest.get_worldpath() .. "/whoison.wio","r+")
if not whoison.presence_file then
    --minetest.log("error", "[whoison] Cannot open presence file! Mod disabled.")
    whoison.presence_file = io.open(minetest.get_worldpath() .. "/whoison.wio","w")
    return
end

whoison.datas = whoison.functions.load("E")
if not whoison.datas then
    whoison.datas = {}
end


-- Boot, Step 1, define callbacks

function whoison.functions.on_newplayer(player)
    whoison.datas[player:get_player_name()] = 0
end

function whoison.functions.on_joinplayer(player)
    local time = whoison.functions.load(player:get_player_name())
    if not time then
        minetest.log("error", "[whoison] Reading failed. Player " ..
            player:get_player_name())
        whoison.datas[player:get_player_name()] = 0

        return
    end
    whoison.datas[player:get_player_name()] = time
end

function whoison.functions.on_leaveplayer(player)
    local name = player:get_player_name()
    local auth = minetest.get_auth_handler().get_auth(name)
    if auth and auth.last_login then
        local last_login = auth.last_login
        local uptime = os.difftime(os.time(),last_login)
        whoison.datas[name] = whoison.datas[name] + uptime
        local success = whoison.functions.save(name)
        if not success then
            minetest.log("error", "[whoison] Something went wrong while saving " ..
            name .. "'s file")
        end
    else
        minetest.log("error", "[whoison] Couldn't get " .. name .. "'s uptime")
        return
    end
end

function whoison.functions.on_shutdown()
    for index, player in pairs(minetest.get_connected_players()) do
        whoison.functions.on_leaveplayer(player)
    end
end

minetest.register_on_joinplayer(whoison.functions.on_joinplayer)
minetest.register_on_newplayer(whoison.functions.on_newplayer)
minetest.register_on_leaveplayer(whoison.functions.on_leaveplayer)
minetest.register_on_shutdown(whoison.functions.on_shutdown)
