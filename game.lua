-- game ⬆️⬇️⬅️➡️🅾️❎

-- button down event
function btnp_update()
 if btn(🅾️) then
	 if btnp_o == 0 then btnp_o = 1
		else btnp_o = 2
		end
	end
	if btn(❎) then
	 if btnp_x == 0 then btnp_x = 1
		else btnp_x = 2
		end
	end
	if not btn(🅾️) then btnp_o = 0 end
	if not btn(❎) then btnp_x = 0 end
	
	if btn(⬅️) or btn(➡️) or btn(⬆️) or btn(⬇️) then btn_arrow = 1
	else btn_arrow = 0
	end
end



-- cursor
function move_cursor()
 if csr_t > 0 then csr_t -= 1 end
 if csr_move >= 1 and csr_t <= 0 then
	 local d = 10 -- delay
		if btn(❎) then d = 4		end -- fast cursor
		
		-- restrict cursor to moveable tiles
		
	 if btn(⬅️) and csr_xpos > 1 and (csr_move == 1 or pathmap[csr_ypos][csr_xpos - 1] <= selected.mov) then csr_xpos -= 1 csr_t = d end
	 if btn(➡️) and csr_xpos < map_width and  (csr_move == 1 or pathmap[csr_ypos][csr_xpos + 1] <= selected.mov) then csr_xpos += 1 csr_t = d end
	 if btn(⬆️) and csr_ypos > 1 and  (csr_move == 1 or pathmap[csr_ypos - 1][csr_xpos] <= selected.mov) then csr_ypos -= 1 csr_t = d end
	 if btn(⬇️) and csr_ypos < map_height and  (csr_move == 1 or pathmap[csr_ypos + 1][csr_xpos] <= selected.mov) then csr_ypos += 1 csr_t = d end
	end
end

function draw_cursor()
 csr_x += ((csr_xpos - 1) * 8 - csr_x) / 4
 csr_y += ((csr_ypos - 1) * 8 - csr_y) / 4
	if abs((csr_xpos - 1) * 8 - csr_x) < 0.5 then csr_x = (csr_xpos - 1) * 8 end
	if abs((csr_ypos - 1) * 8 - csr_y) < 0.5 then csr_y = (csr_ypos - 1) * 8 end
	
	if csr_show == 1 then
		pal(9, 4)
		spr(16, csr_x + 1, csr_y + 1)
		pal(9, 9)
		spr(16, csr_x, csr_y)
	end
end



-- unit actions
function unit_actions()

 -- no unit selected yet
	if selected == 0 then
	 
		cursor_stats() -- show stats hud
	 
		if btnp_o == 1 then -- select unit
		 
			-- update unitmap
			for y = 1, map_height do
				for x = 1, map_width do
					unitmap[y][x] = 0
				end
			end
			for unit in all(blue_units) do unitmap[unit.ypos][unit.xpos] = 1 end
			for unit in all(red_units) do unitmap[unit.ypos][unit.xpos] = 2 end
		 
			-- check all units
			for unit in all(blue_units) do
				if csr_xpos == unit.xpos and csr_ypos == unit.ypos and unit.moved == 0 then
					selected = unit
					pathmap = create_grid(map_width, map_height, 0)
					pathmap = pathfind(pathmap, unit.xpos, unit.ypos, unit.mov, unit.mounted, selected.team, 1, {weapons[unit.wep].min_range, weapons[unit.wep].max_range})
					csr_move = 2
					show_pathmap = 1
					break
				end
			end
			for unit in all(red_units) do
				if csr_xpos == unit.xpos and csr_ypos == unit.ypos and unit.moved == 0 then
					selected = unit
					pathmap = create_grid(map_width, map_height, 0)
					pathmap = pathfind(pathmap, unit.xpos, unit.ypos, unit.mov, unit.mounted, selected.team, 1, {weapons[unit.wep].min_range, weapons[unit.wep].max_range})
					show_pathmap = 1
					selected_state = -1
					break
				end
			end
			
		end
		
	
 
 -- view enemy move and attack distances	
	elseif selected_state == -1 then
	
	 cursor_stats() -- show stats hud
	 
	 if btnp_o == 1 or (btnp_x == 1 and btn_arrow == 0) then
		 selected = 0
			show_pathmap = 0
			selected_state = 0
		end
		
	 
	 
	-- select tile to move unit to
	elseif selected_state == 0 then
	
	 cursor_stats() -- show stats hud
	 
		if btnp_o == 1 then
		 if pathmap[csr_ypos][csr_xpos] != 999
			and (unitmap[csr_ypos][csr_xpos] == 0
			or (csr_xpos == selected.xpos and csr_ypos == selected.ypos)) then
			 selected.movepath = {}
			
			 -- get path to target location
			 pathmap = pathfind(pathmap, csr_xpos, csr_ypos, selected.mov, selected.mounted, selected.team, 1, {0, 0})
				local ox = selected.xpos
				local oy = selected.ypos
				while ox != csr_xpos or oy != csr_ypos do
				 local val = pathmap[oy][ox]
					
					local dir = 0
					if ox > 1 and pathmap[oy][ox - 1] < val then dir = 2 val = pathmap[oy][ox - 1] end
					if oy > 1 and pathmap[oy - 1][ox] < val then dir = 1 val = pathmap[oy - 1][ox] end
					if oy < map_height and pathmap[oy + 1][ox] < val then dir = 3 val = pathmap[oy + 1][ox] end
					
					if dir == 0 then ox += 1
					elseif dir == 1 then oy -= 1
					elseif dir == 2 then ox -= 1
					elseif dir == 3 then oy += 1
					end
					add(selected.movepath, dir)
					
				end
				
				selected.xprev = selected.xpos
				selected.yprev = selected.ypos
				selected.xpos = csr_xpos
				selected.ypos = csr_ypos
				selected_state = 1
			 show_pathmap = 0
				csr_move = 0
			else selected = 0 show_pathmap = 0 csr_move = 1
			end
		
		elseif btnp_x == 1 and btn_arrow == 0 then selected = 0 show_pathmap = 0 csr_move = 1
		end
		
		
		
	-- unit is moving...
	elseif selected_state == 1 then
	 stats_show = 0
	
		if #selected.movepath <= 0 and selected.movedir == -1 then
		 selected_state = 2
			
			options = {}
			pathmap = pathfind(pathmap, selected.xpos, selected.ypos, 0,
			0, 1, 0, {weapons[selected.wep].min_range, weapons[selected.wep].max_range})
			targets = {}
			target = 1
			for unit in all(red_units) do
			 if pathmap[unit.ypos][unit.xpos] > 10 and pathmap[unit.ypos][unit.xpos] != 99 then
				 add(targets, unit)
				end
			end
			if #targets > 0 then add(options, "aTTACK") end
			add(options, "wAIT")
			
			option = 1
			option_y = 8
			option_show = 1
		end
		
		
		
	-- select unit action
	elseif selected_state == 2 then
	 
	 stats_show = 0
		
	 if btnp_x == 1 then
		 selected.xpos = selected.xprev
		 selected.ypos = selected.yprev
		 selected.x = (selected.xprev - 1) * 8
		 selected.y = (selected.yprev - 1) * 8
		 selected_state = 0
			
			pathmap = pathfind(pathmap, selected.xpos, selected.ypos, selected.mov, selected.mounted, selected.team, 1, {weapons[selected.wep].min_range, weapons[selected.wep].max_range})
			show_pathmap = 1
			
			csr_xpos = selected.xprev
			csr_ypos = selected.yprev
			csr_move = 2
			
			option_show = 0
		end
	
	
	
	-- select target
 elseif selected_state == 3 then
	 
		if btnp(➡️) or btnp(⬇️) then target += 1 end
		if btnp(⬅️) or btnp(⬆️) then target -= 1 end
		
		if target < 1 then target = #targets
		elseif target > #targets then target = 1
		end
		
		local tgt = targets[target]
		
	 -- move cursor to selected target
		csr_xpos = tgt.xpos
		csr_ypos = tgt.ypos
		
		if btnp_o == 1 then
			selected_state = 4
			csr_show = 0
			target_show = 0
			
			local ang = atan2(tgt.x - selected.x, tgt.y - selected.y)
			if ang > 0.25 and ang < 0.75 then selected.sflip = true end
			
	  combat_state = 1
	  combat_turn = 1
			combat_t = 30
		 
		elseif btnp_x == 1 then
		 selected_state = 2
			option_show = 1
			target_show = 0
		 csr_xpos = selected.xpos
			csr_ypos = selected.ypos
		end
	
	
	
	-- unit is attacking...
 elseif selected_state == 4 then
	 
	 
	end
end



-- combat
function combat()
	if combat_state >= 1 then
	 if combat_t > 0 then combat_t -= 1
		else
		 
		 local tgt = targets[target]
		 local xo = (selected.xpos - 1) * 8 -- original point
			local yo = (selected.ypos - 1) * 8
			local xo2 = (tgt.xpos - 1) * 8 -- original point (defender)
			local yo2 = (tgt.ypos - 1) * 8
			local ang = atan2(tgt.x - selected.x, tgt.y - selected.y)
	  
			-- move initiator sprite
			if combat_state == 1 then
				if dist(selected.x, selected.y, xo + cos(ang) * 6, yo + sin(ang) * 6) > 0.5 then
				 selected.x += cos(ang) / 2
				 selected.y += sin(ang) / 2
				else
				 -- compute stats
					local sta = selected.sta
					local sta2 = tgt.sta
					selected.sta = max(0, selected.sta - sta2)
					tgt.sta = max(0, tgt.sta - sta)
					
					if selected.sta > tgt.sta then -- deal damage
					 local dmg = max(0, (selected.pwr + weapons[selected.wep].pwr) - tgt.def)
						local crt = max(0, ceil((selected.dex - tgt.dex) / 2) + (selected.lck - tgt.lck))
					 
						if flr(rnd(100)) < crt then dmg *= 3 end
						tgt.hp = max(0, tgt.hp - dmg)
						
						add(popups, {val = "hIT", x = stats_x + 59, y = 45,
						max_y = 45, vsp = -0.8, life = 90})
						add(popups, {val = "-"..sta2, x = stats_x + 59, y = 15,
						max_y = 15, vsp = -0.8, life = 90})
						add(popups, {val = "-"..dmg, x = stats_x + 28, y = 45,
						max_y = 45, vsp = -0.8, life = 90})
						
					else
					 add(popups, {val = "mISS", x = stats_x + 59, y = 45,
						max_y = 45, vsp = -0.8, life = 90})
					end
					
				 combat_state = 2
				end
			
			-- move back to original point
			elseif combat_state == 2 then
				if dist(selected.x, selected.y, xo, yo) > 0.5 then
				 selected.x -= cos(ang) / 2
				 selected.y -= sin(ang) / 2
				else
				 selected.x = xo
					selected.y = yo
				 combat_state = 3
					combat_t = 110
				end
			
			-- move defender sprite
			elseif combat_state == 3 then
			 if dist(tgt.x, tgt.y, xo2 - cos(ang) * 6, yo2 - sin(ang) * 6) > 0.5 then
				 tgt.x -= cos(ang) / 2
				 tgt.y -= sin(ang) / 2
				else
				 -- compute stats
					if tgt.sta > selected.sta then -- deal damage
					 local dmg = max(0, (tgt.pwr + weapons[tgt.wep].pwr) - selected.def)
		    local crt = max(0, ceil((tgt.dex - selected.dex) / 2) + (tgt.lck - selected.lck))
			   
						if flr(rnd(100)) < crt then dmg *= 3 end
						selected.hp = max(0, selected.hp - dmg)
						
						add(popups, {val = "hIT", x = stats_x + 59, y = 15,
						max_y = 45, vsp = -0.8, life = 90})
						add(popups, {val = "-"..sta2, x = stats_x + 59, y = 45,
						max_y = 15, vsp = -0.8, life = 90})
						add(popups, {val = "-"..dmg, x = stats_x + 28, y = 15,
						max_y = 45, vsp = -0.8, life = 90})
					
					else
					 add(popups, {val = "mISS", x = stats_x + 59, y = 15,
						max_y = 15, vsp = -0.8, life = 90})
					end
					
				 combat_state = 4
				end
		 
			-- move back to original point
			elseif combat_state == 4 then
				if dist(tgt.x, tgt.y, xo2, yo2) > 0.5 then
				 tgt.x += cos(ang) / 2
				 tgt.y += sin(ang) / 2
				else
				 tgt.x = xo2
					tgt.y = yo2
				 combat_state = 5
					combat_t = 110
				end
				
			-- end combat
			elseif combat_state == 5 then
			 combat_state = 0
				
				selected.moved = 1
				selected = 0
				selected_state = 0
				csr_move = 1
			 csr_show = 1
			
			end
		end
	end
end