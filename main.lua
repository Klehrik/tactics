-- main

function palette()
 pal(2, 130, 1)
	pal(4, 132, 1)
	pal(10, 134, 1)
	pal(11, 140, 1)
	palt(0, false)
	palt(14, true)
end

function _init()
	palette()
	
	debug = 0
	
	btnp_o = 0
	btnp_x = 0
	btn_arrow = 0
 	
	t = 0
	
	csr_move = 1
	csr_show = 1
	csr_xpos = 2
	csr_ypos = 13
	csr_x = 0
	csr_y = 0
	csr_t = 0
	
	map_width = 16
	map_height = 16
	
	turn = 1
	
	selected = 0 -- selected unit
	selected_state = 0
	pathmap = 0
	show_pathmap = 0
	
	targets = {}
	target = 1
	target_show = 0
 	
	options = {}
	option = 1
	option_x = -34
	option_y = 8
	option_show = 0
	
	stats_type = 1
	stats_unit = 0
	stats_x = -60
	stats_show = 0
	
	combat_state = 0
	combat_turn = 1
	combat_t = 0
	
	popups = {} -- damage numbers, etc.
	
	camx = 0
	camy = 0
	
	unitmap = create_grid(map_width, map_height, 0)
	
	init_tables()
	
 blue_units = {}
	add_blue({2, 13, 1, 1, 6, 2, 1, 5, 5, 1, 0, 6})
	add_blue({2, 15, 1, 9, 6, 2, 1, 5, 5, 1, 0, 6})
	add_blue({3, 14, 1, 7, 6, 2, 1, 5, 5, 1, 0, 10})
	add_blue({4, 15, 1, 4, 6, 2, 1, 5, 5, 1, 0, 1})
	-- data: x, y, name, class (4),
	-- vit, pwr, def, dex (8),
	-- lck, level, exp, wep (12)
	
	red_units = {}
	add_red({4, 11, 1, 3, 6, 2, 0, 3, 3, 1, 1})
	add_red({3, 10, 1, 7, 6, 2, 1, 3, 1, 1, 10})
	-- data: x, y, name, class (4),
	-- vit, pwr, def, dex (8),
	-- lck, level, wep (11)
	
	for i in all(blue_units) do
	 i.x = (i.xpos - 1) * 8
	 i.y = (i.ypos - 1) * 8
		i.team = 1
		i.sta = i.dex
	end
	for i in all(red_units) do
	 i.x = (i.xpos - 1) * 8
	 i.y = (i.ypos - 1) * 8
		i.team = 2
		i.sta = i.dex
	end
end



function _update60()
 t += 1
 
	btnp_update()
	
 move_cursor()
	unit_actions()
	update_units()
	combat()
end



function _draw()
 cls()
 map(1, 1, 0, 0, map_width, map_height)
	
	draw_pathmap()
	draw_units()
	
	draw_cursor()
	stats_hud()
	options_box()
	
	draw_popups()
	
	//if selected != 0 then print(selected.xprev.." "..selected.yprev, 1, 1, 0) end
	//print(stats_show, 1, 1, 0)
	//print(debug, 1, 1, 0)
end