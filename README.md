Voxel Tracker
=============
<pre>
Voxel Tracker is a tool for viewing locality specific trends in
COVID-19 case data. 

Voxel Tracker was created using a voxel game engine called <a href="https://www.minetest.net/">Minetest</a>.

A stand-alone version of Voxel Tracker can be downloaded here: <a href="https://github.com/Droog71/voxel_tracker/releases/tag/stand-alone">stand-alone download</a>
To run Voxel Tracker, simply extract the contents of the downloaded file
and run start.bat (windows) or start.sh (linux).

If you already have the Minetest game engine installed and would
like to install Voxel Tracker inside of Minetest, you can
simply clone this repository in the Minetest games directory.
More information is available here: <a href="https://wiki.minetest.net/Games#Installing_games">'Installing games in Minetest'</a>

In order to run Voxel Tracker using this method, you will need to add the mod to your
trusted mods list. To do so, click on the 'Settings' tab in the main menu. 
Click the 'All Settings' button and in the search bar, enter 'trusted'. 
Click the 'Edit' button and add 'voxel_tracker' to the list.

Voxel Tracker gathers data <a href="https://anypoint.mulesoft.com/exchange/portals/mulesoft-2778/5a0bd415-9488-4e33-88d6-ba31cbef5957/contact-tracing-exp-api/">sourced from The New York Times</a>  
and plots a 3 dimensional voxel bar graph for the given zip code. 
A separate graph is created for each county in the zip code. 
Each bar on the graph represents the difference in cases from
one day to the next. If there were more cases than the previous day,
the bar is constructed with red voxels, representing an upward
trend. If the number of cases was less than the previous day,
the bar is constructed with green voxels, representing a downward
trend. For the first day returned by the api, the bar is constructed 
with white voxels since the change is unknown. To plot a graph, 
press the '/' key and type the word 'plot' followed by a space and 
the desired zip code. For example, entering the command '/plot 90001' 
will plot a graph for Los Angeles County, California.

To view this information while using Voxel Tracker, press the I key.
This will open a pop up dialog with the explanation above.
</pre>
<img src="https://i.imgur.com/puVr6dq.png" alt="Voxel Tracker" width="427" height="240"></br>
<img src="https://i.imgur.com/CrlA2PI.png" alt="Voxel Tracker" width="427" height="240"></br>
<img src="https://i.imgur.com/wVPQofK.png" alt="Voxel Tracker" width="427" height="240"></br>
<img src="https://i.imgur.com/hsvCIx9.png" alt="Voxel Tracker" width="427" height="240"></br>
