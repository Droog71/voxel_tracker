--text to display
local text = "This script gathers data from localcoviddata.com and plots a\n" ..
    "voxel bar graph for the given zip code. A separate graph is\n" ..
    "created for each county in the zip code. Each bar on the graph\n" ..
    "represents the change in cases for that day compared to the\n" ..
    "previous day. If there were more cases than the previous day,\n" ..
    "the bar is constructed with red voxels, representing an upward\n" ..
    "trend. If the number of cases was less than the previous day,\n" ..
    "the bar is constructed with green voxels, representing a downward\n" ..
    "trend. If the bar represents the first day returned by the api,\n" ..
    "it is constructed with white voxels since the change is unknown.\n" ..
    "To plot a graph, press the '/' key and type the word 'plot' followed\n" ..
    "by a space and the desired zip code. For example, entering the command\n" ..
    "'/plot 90001' would plot a graph for Los Angeles County, California."

--defines the formspec
local function generate_formspec(player)
    local formspec = {
        "size[9,9]",
        "bgcolor[#252525;false]",
        "label[1,1;"..text.."]",
        "button_exit[3,7;3,1;exit;Close]"
    }
    return formspec
end

--sets the inventory formspec
minetest.register_on_joinplayer(function(player)
    local formspec = generate_formspec(player)
    player:set_inventory_formspec(table.concat(formspec, ""))
end)