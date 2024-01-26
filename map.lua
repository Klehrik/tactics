-- map

-- create a grid filled with a value
function create_grid(w, h, val)
 local grid = {}
 for y = 1, h do
	 local row = {}
	 for x = 1, w do
	  add(row, val)
	 end
		add(grid, row)
	end
	return grid
end

-- pathfind unit movement
function pathfind(grid, ox, oy, max_val, mounted, team, terrain_cost, atk_range)
 
	local grid = grid
	
 local w = #grid[1]
	local h = #grid

 -- clear grid to 99
	for y = 1, h do
		for x = 1, w do
		 grid[y][x] = 99
		end
	end

	-- pathfind
	local open = {{ox, oy}}
	grid[oy][ox] = 0
	
	while #open > 0 do
		local i = open[1]
		
		local _x = {-1, 1, 0, 0}
		local _y = {0, 0, -1, 1}
		for j = 1, 4 do
		
		 local nx = i[1] + _x[j] -- neighbor
			local ny = i[2] + _y[j]
		
			-- check if within grid
		 if nx >= 1 and nx <= w and ny >= 1 and ny <= h then
		  
				-- get terrain cost
				local cost = 1
				if terrain_cost == 1 then
					if mflag(nx, ny, 0) then cost = 99 -- water
					elseif mflag(nx, ny, 1) then cost = 2 -- woods
					elseif mflag(nx, ny, 2) then -- ridge
						cost = 3
						if mounted == 1 then cost = 99 end -- prevent mounted units from crossing ridges
					end
				end
				
				-- team check
				if team > 0 then
				 if unitmap[ny][nx] > 0 and
					unitmap[ny][nx] != team then
					 cost = 99
					end
				end
				
				-- check if cost is less than neighbor tile cost
				if grid[i[2]][i[1]] + cost <= grid[ny][nx]
				and grid[i[2]][i[1]] + cost <= max_val then
		   grid[ny][nx] = grid[i[2]][i[1]] + cost
					add(open, {nx, ny})
				end
				
				-- attack tiles
				-- loop through all applicable attack tiles and
				-- set tiles as attack tiles if they are unexplored
				for k = atk_range[1], atk_range[2] do -- loop through ranges
				 for l = -k, k do -- loop through each row of the range (-dist to dist)
					 for m = -1, 1, 2 do -- (-1 and 1)
							local tx = i[1] + (k - abs(l)) * m -- abs(x) and abs(y) must add up to the range (k)
							local ty = i[2] + l
							if tx >= 1 and tx <= w and ty >= 1 and ty <= h then
						  if grid[ty][tx] == 99 or grid[ty][tx] > k + 10 then grid[ty][tx] = k + 10 end
						 end
						end
					end
				end
				
		 end
		 
		end
		
		del(open, i)
	end
	
	return grid
	
end

-- draw pathmap
function draw_pathmap()
 if pathmap != 0 and show_pathmap == 1 then
		for y = 1, map_height do
			for x = 1, map_width do
			 if pathmap[y][x] != 99 then
					fillp(0b1000000100100100.1)
					if t % 120 < 30 then fillp(0b0100100000010010.1)
					elseif t % 120 < 60 then fillp(0b0010010010000001.1)
					elseif t % 120 < 90 then fillp(0b0001001001001000.1)
					end
					
					local clr = 12 -- move colour
					if pathmap[y][x] > 10 then clr = 8 end -- attack colour
					
					rectfill((x - 1) * 8, (y - 1) * 8, (x - 1) * 8 + 7, (y - 1) * 8 + 7, clr)
					fillp(0b0000000000000000)
				end
				
			 -- val = pathmap[y][x]
				-- if val == 99 then val = "" end
				-- local clr = 12
				-- if pathmap[y][x] > 10 then clr = 8 end
				-- print(val, (x-1) * 8, (y-1) * 8, clr)
			end
		end
	end
	
	-- targets
	if target_show == 1 then
	 fillp(0b1000000100100100.1)
		if t % 120 < 30 then fillp(0b0100100000010010.1)
		elseif t % 120 < 60 then fillp(0b0010010010000001.1)
		elseif t % 120 < 90 then fillp(0b0001001001001000.1)
		end
		
	 for i = 1, #targets do
		 local x = targets[i].xpos
		 local y = targets[i].ypos
		 rectfill((x - 1) * 8, (y - 1) * 8, (x - 1) * 8 + 7, (y - 1) * 8 + 7, 8)
		end
		
		fillp(0b0000000000000000)
	end
end