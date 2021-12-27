--[[
    Voxel Tracker
    Version: 1
    License: GNU Affero General Public License version 3 (AGPLv3)
]]--

http = minetest.request_http_api()
minetest.settings:set_bool("menu_clouds", false)
minetest.settings:set("viewing_range", 1000)
minetest.register_item(":", { type = "none", wield_image = "blank.png"})
dofile(minetest.get_modpath("voxel_tracker") .. DIR_DELIM .. "hud.lua")
dofile(minetest.get_modpath("voxel_tracker") .. DIR_DELIM .. "formspec.lua")

 minetest.register_on_prejoinplayer(function(pname)
    if not http then
        return "\n\nVoxel Tracker needs to be added to your trusted mods list.\n" ..
            "To do so, click on the 'Settings' tab in the main menu.\n" ..
            "Click the 'All Settings' button and in the search bar, enter 'trusted'.\n" ..
            "Click the 'Edit' button and add 'voxel_tracker' to the list."
    end
end)
 
 --initializes the player and builds a platform
 minetest.register_on_joinplayer(function(player)
    player:set_properties({
        textures = { "blank.png", "blank.png" },
        visual = "upright_sprite",
        visual_size = { x = 1, y = 2 },
        collisionbox = {-0.49, 0, -0.49, 0.49, 2, 0.49 },
        initial_sprite_basepos = {x = 0, y = 0}
    })
    player:set_sky({ type = "plain", base_color = 000000 })
    player:hud_set_flags({hotbar = false, healthbar = false, crosshair = false})
    minetest.set_player_privs(player:get_player_name(), {fly=true})
    player:set_clouds({density = 0})
    player:set_physics_override({gravity = 0})
    player:set_pos(vector.new(0, 25, -40))
end)

--keeps time of day at 0.5
minetest.register_globalstep(function(dtime)  
    minetest.set_timeofday(0.5)
end)

--creates a voxel bar graph
function plot_data(data_json)
    local x = 24
    local size = get_size(data_json.counties)
    x = x - (21 - ((size - 1) * 7))
    
    for k1,v1 in pairs(data_json.counties) do
        local county_name = ""
        for k2,v2 in pairs(v1) do
            if k2 == "countyName" then
                county_name = v2
            elseif k2 == "historicData" then
                for k3,v3 in pairs(v2) do
                    local current_day = tonumber(k3)
                    if current_day < 6 then
                        plot_day(current_day, v2, v3, x, county_name)
                        x = x - 2
                    end
                end
            end
        end
        x = x - 4
    end
    
    local county_names = ""
    for i = size,1,-1 do
        local spacer = "                    "
        county_names = county_names .. data_json.counties[i].countyName .. spacer
    end
    update_county_hud(county_names)
    
    local dates = ""
    for i = 5,1,-1 do
        local spacer = "          "
        dates = dates .. data_json.counties[1].historicData[i].date .. spacer
    end
    update_date_hud(dates)
end

--creates a single bar on the graph
function plot_day(current_day, days, data, x, county_name)
    local past_change = 0
    local org_data = 0
    local past_data = days[current_day + 1].positiveCt
    if current_day <= 4 then
        org_data =  days[current_day + 2].positiveCt
        past_change = past_data - org_data
    end
    local change = data.positiveCt - past_data
    local increase = change > past_change
    add_hud_message(county_name .. ", " .. data.date .. " : " .. change .. " cases")
    change = scale_change(days, change)
    if change == 0 then change = 1 end
    for y = 1,change,1 do
        local node_pos = vector.new(x, y, 0)
        if current_day == 5 then
            minetest.set_node(node_pos, {name = "voxel_tracker:white"})
        elseif increase then
            minetest.set_node(node_pos, {name = "voxel_tracker:red"})
        else
            minetest.set_node(node_pos, {name = "voxel_tracker:green"})
        end
    end
end

--scales the bar to fit within range of the camera
function scale_change(days, change)
    for i = 1,5 do
        local highest = true
        local outer_change = days[i].positiveCt - days[i + 1].positiveCt
        for j = 1,5 do
            local inner_change = days[j].positiveCt - days[j + 1].positiveCt
            if outer_change < inner_change then
                highest = false
            end
        end
        if highest == true then
            local max = days[i].positiveCt - days[i + 1].positiveCt
            local result = 50 * (change / max)
            return result
        end
    end
    return 50
end

--processes data from http request
function handle_response(response)
    if not response.completed then
        return
    end
    local data_json = minetest.parse_json(response.data)
    if data_json then
        plot_data(data_json)
    end
end

--sends an http request
minetest.register_chatcommand("plot", {
    privs = {interact = true},
    func = function(name, param)
        if param then
            if tonumber(param) then
                for x = -24,24,1 do
                    for y = 1,50,1 do
                        local node_pos = vector.new(x, y, 0)
                        minetest.remove_node(node_pos)
                    end
                end
                if http then
                    local site = "https://localcoviddata.com/covid19/v1/cases/newYorkTimes?zipCode="
                    local url = site .. param .. "&daysInPast=6"
                    local response = http.fetch({url = url}, handle_response)
                else
                    return true, "usage: /plot <zip code>"
                end
            else
                return true, "usage: /plot <zip code>"
            end
        else
            return true, "usage: /plot <zip code>"
        end
    end
})

--gets the size of a table
function get_size(table)
    local size = 0
    for k,v in pairs(table) do
        size = size + 1
    end
    return size
end

--generates platform under the bar graphs
minetest.register_on_generated(function(minp, maxp, blockseed)
    if minp.y > 0 or maxp.y < 0 then return end
    local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
    local area = VoxelArea:new{MinEdge=emin, MaxEdge=emax}
    local data = vm:get_data()
    for z = minp.z, maxp.z do
        for x = minp.x, maxp.x do
            local vi = area:index(x, 0, z)
            data[area:index(x, 0, z)] = minetest.get_content_id("voxel_tracker:gray")
        end
    end
    vm:set_data(data)
    vm:write_to_map(data)
end)

minetest.register_node("voxel_tracker:gray", {
    name = "gray",
    description = "gray",
    tiles = {"gray.png"},
    light_source = 14
})

minetest.register_node("voxel_tracker:white", {
    name = "white",
    description = "white",
    tiles = {"white.png"},
    light_source = 14
})

minetest.register_node("voxel_tracker:green", {
    name = "green",
    description = "green",
    tiles = {"green.png"},
    light_source = 14
})

minetest.register_node("voxel_tracker:red", {
    name = "red",
    description = "red",
    tiles = {"red.png"},
    light_source = 14
})