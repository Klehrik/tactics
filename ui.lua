-- ui

-- options box
function options_box()
	if option_show == 1 then
	 
		-- slide the option box into view
	 option_x += (6 - option_x) / 6
		if abs(6 - option_x) < 0.5 then option_x = 6 end
		
		-- move cursor ⬆️⬇️⬅️➡️
		if btnp(➡️) or btnp(⬇️) then option += 1 end
		if btnp(⬅️) or btnp(⬆️) then option -= 1 end
		
		if option < 1 then option = #options
		elseif option > #options then option = 1
		end
	 
		-- select option
		if btnp_o == 1 then
		 
			if options[option] == "aTTACK" then
				selected_state = 3
				option_show = 0
				target_show = 1
				stats_type = 2
				stats_show = 1
				stats_unit = selected
			
			elseif options[option] == "wAIT" then
    selected.moved = 1
				selected = 0
				selected_state = 0
				show_pathmap = 0
				csr_move = 1
				option_show = 0
			
			end
		end
	
	else
	 -- slide the option box out of view
	 option_x += (-34 - option_x) / 6
		if abs(-34 - option_x) < 0.5 then option_x = -34 end
		
	end
	
	
	
	option_y += ((1 + option * 7) - option_y) / 4
	if abs((1 + option * 7) - option_y) < 0.5 then option_y = 1 + option * 7 end
	
	-- draw box and highlight
	rectfill(option_x, 6, option_x + 28, 9 + #options * 7, 0)
	rectfill(option_x + 2, option_y, option_x + 26, option_y + 6, 10)
	
	-- list options
	for i = 1, #options do
		print(options[i], option_x + 3, 2 + i * 7, 7)
	end
end



-- stats hud
function stats_hud()
	if stats_show == 1 then -- slide the stats hud into view
		stats_x += (6 - stats_x) / 6
		if abs(6 - stats_x) < 0.5 then stats_x = 6 end
	else stats_x += (-60 - stats_x) / 6 -- slide the stats hud out of view
	end
	
	
	
	if stats_type >= 1 then -- cursor over unit
	
		-- draw box
		rectfill(stats_x, 6, stats_x + 54, 21, 0)
		
		-- name and level
		local name = "?"
		local clr = 12
		if stats_unit.team == 1 then name = names[stats_unit.name]
		else name = names2[stats_unit.name] clr = 8
		end
		print(name, stats_x + 2, 8, clr)
		print("lV."..stats_unit.lv, stats_x + 38, 8, 6)
		
		-- stats
		print("vIT", stats_x + 2, 15, 10)
		print("sTA", stats_x + 30, 15, 10)
		local hp = stats_unit.hp
		local sta = stats_unit.sta
		if hp < 10 then hp = " "..hp end
		if sta < 10 then sta = " "..sta end
		print(hp, stats_x + 18, 15, 6)
		print(sta, stats_x + 46, 15, 9)
	end
		
		
		
	if stats_type == 2 then -- lower half of box and target unit
	
	 local tgt = targets[target]
		
		-- draw lower half of box (blue)
		rectfill(stats_x, 22, stats_x + 54, 33, 0)
		
		-- stats and wep
		print("dMG", stats_x + 2, 21, 10)
		print("cRT", stats_x + 30, 21, 10)
		print("wEP", stats_x + 2, 27, 10)
		local dmg = max(0, (stats_unit.pwr + weapons[stats_unit.wep].pwr) - tgt.def)
		local crt = max(0, ceil((stats_unit.dex - tgt.dex) / 2) + (stats_unit.lck - tgt.lck))
		if dmg < 10 then dmg = " "..dmg end
		if crt < 10 then crt = " "..crt end
		print(dmg, stats_x + 18, 21, 6)
		print(crt, stats_x + 46, 21, 6)
		print(weapons[stats_unit.wep].name, stats_x + 18, 27, 6)
		
		
		
		-- draw box (red)
		rectfill(stats_x, 36, stats_x + 54, 63, 0)
		
		-- name and level (red)
		local name = "?"
		local clr = 12
		name = names2[tgt.name]
		print(name, stats_x + 2, 38, 8)
		print("lV."..tgt.lv, stats_x + 38, 38, 6)
		
		-- stats and wep (red)
		print("vIT", stats_x + 2, 45, 10)
		print("sTA", stats_x + 30, 45, 10)
		print("dMG", stats_x + 2, 51, 10)
		print("cRT", stats_x + 30, 51, 10)
		print("wEP", stats_x + 2, 57, 10)
		local hp = tgt.hp
		local sta = tgt.sta
		if hp < 10 then hp = " "..hp end
		if sta < 10 then sta = " "..sta end
		
		local dmg = "--"
		local crt = "--"
		local range = pathmap[tgt.ypos][tgt.xpos] - 10
		if range >= weapons[tgt.wep].min_range and range <= weapons[tgt.wep].max_range then
		 dmg = max(0, (tgt.pwr + weapons[tgt.wep].pwr) - stats_unit.def)
		 crt = max(0, ceil((tgt.dex - stats_unit.dex) / 2) + (tgt.lck - stats_unit.lck))
			if dmg < 10 then dmg = " "..dmg end
		 if crt < 10 then crt = " "..crt end
		end
		
		print(hp, stats_x + 18, 45, 6)
		print(sta, stats_x + 46, 45, 9)
		print(dmg, stats_x + 18, 51, 6)
		print(crt, stats_x + 46, 51, 6)
		print(weapons[tgt.wep].name, stats_x + 18, 57, 6)
	end
end