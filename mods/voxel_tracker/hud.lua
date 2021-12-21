local messages = ""
local message_count = 0
local message_list = {}
local county_hud_ids = {}
local date_hud_ids = {}
local message_hud_ids = {}

--initializes HUD
minetest.register_on_joinplayer(function(player)
    message_hud_ids[player:get_player_name()] = player:hud_add({
        hud_elem_type = "text",
        position = {x = 1, y = 0.5},
        offset = {x = -200, y = 0},
        scale = {x = 1, y = 1},
        text = messages,
        number = 0xFFFFFF
    })
    county_hud_ids[player:get_player_name()] = player:hud_add({
        hud_elem_type = "text",
        position = {x = 0.5, y = 0.1},
        offset = {x = 0, y = 0},
        scale = {x = 1, y = 1},
        text = "",
        number = 0xFFFFFF
    })
    date_hud_ids[player:get_player_name()] = player:hud_add({
        hud_elem_type = "text",
        position = {x = 0.5, y = 0.9},
        offset = {x = 0, y = 0},
        scale = {x = 1, y = 1},
        text = "",
        number = 0xFFFFFF
    })
end)

--removes message hud id from the list
minetest.register_on_leaveplayer(function(player)
    local name = player:get_player_name()
    message_hud_ids[name] = nil
    county_hud_ids[name] = nil
    date_hud_ids[name] = nil
end)

--adds a message to the HUD
function add_hud_message(message)
    table.insert(message_list, message)
    message_count = message_count + 1
    if message_count >= 32 then
        messages = ""
        for index, msg in pairs(message_list) do
            if index == 1 then
                table.remove(message_list, 1)
                message_count = message_count - 1
            else
                messages = messages .. msg .. "\n"
            end
        end
    else
        messages = messages .. message .. "\n"
    end
    update_message_hud()
end

--updates messages
function update_message_hud()
    for name, id in pairs(message_hud_ids) do
        local player = minetest.get_player_by_name(name)
        if player then
          player:hud_remove(message_hud_ids[name])
          message_hud_ids[name] = player:hud_add({
              hud_elem_type = "text",
              position = {x = 1, y = 0.5},
              offset = {x = -200, y = 0},
              scale = {x = 1, y = 1},
              text = messages,
              number = 0xFFFFFF
          })
        end
    end
end

--updates counties
function update_county_hud(text)
    for name, id in pairs(county_hud_ids) do
        local player = minetest.get_player_by_name(name)
        if player then
          player:hud_remove(county_hud_ids[name])
          county_hud_ids[name] = player:hud_add({
              hud_elem_type = "text",
              position = {x = 0.5, y = 0.1},
              offset = {x = 0, y = 0},
              scale = {x = 1, y = 1},
              text = text,
              number = 0xFFFFFF
          })
        end
    end
end

--updates dates
function update_date_hud(text)
    for name, id in pairs(date_hud_ids) do
        local player = minetest.get_player_by_name(name)
        if player then
          player:hud_remove(date_hud_ids[name])
          date_hud_ids[name] = player:hud_add({
              hud_elem_type = "text",
              position = {x = 0.5, y = 0.9},
              offset = {x = 0, y = 0},
              scale = {x = 1, y = 1},
              text = text,
              number = 0xFFFFFF
          })
        end
    end
end