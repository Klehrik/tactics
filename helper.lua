-- helper and tables

function init_tables()
 names = {"aLLY"}
	names2 = {"eNEMY"}
	weapons = {
		{name = "sWORD", pwr = 1, dex = 0, min_range = 1, max_range = 1},
		{name = "sCIMITAR", pwr = 0, dex = 2, min_range = 1, max_range = 1},
		{name = "lONGSWORD", pwr = 0, dex = -3, min_range = 1, max_range = 1},
		
		{name = "bATTLEAXE", pwr = 2, dex = -2, min_range = 1, max_range = 1},
		{name = "cLAYMORE", pwr = 0, dex = -3, min_range = 1, max_range = 1},
		
		{name = "sPEAR", pwr = 2, dex = -1, min_range = 1, max_range = 1},
		{name = "pIKE", pwr = 0, dex = -2, min_range = 1, max_range = 2},
		{name = "hALBERD", pwr = 0, dex = -3, min_range = 1, max_range = 1},
		{name = "gLAIVE", pwr = 0, dex = -4, min_range = 1, max_range = 1},
		
		{name = "bOW", pwr = 1, dex = 0, min_range = 2, max_range = 2},
		{name = "sHORTBOW", pwr = 0, dex = 0, min_range = 1, max_range = 2},
		{name = "lONGBOW", pwr = 0, dex = -2, min_range = 2, max_range = 3},
		{name = "pIERCEbOW", pwr = 0, dex = -3, min_range = 2, max_range = 2},
	}
	classes = {
	 {name = "tRAVELER", sprite = 49, move = 4}, -- 1
	 {name = "wARRIOR", sprite = 4, move = 5}, -- 2
	 {name = "fIGHTER", sprite = 1, move = 4}, -- 3
	 {name = "cHAMPION", sprite = 4, move = 4}, -- 4
	 {name = "fIGHTER", sprite = 1, move = 4}, -- 5
	 {name = "dUELIST", sprite = 7, move = 4}, -- 6
	 {name = "rANGER", sprite = 17, move = 4}, -- 7
	 {name = "sNIPER", sprite = 20, move = 4}, -- 8
	 {name = "rIDER", sprite = 23, move = 6}, -- 9
	 {name = "cAVALIER", sprite = 33, move = 7}, -- 10
	 {name = "sOLDIER", sprite = 36, move = 4}, -- 11
	 {name = "kNIGHT", sprite = 39, move = 3}, -- 12
	}
end

function mflag(x, y, f)
 return fget(mget(x, y), f)
end

function dist(x1, y1, x2, y2)
 return sqrt(((x2 - x1) / 64) ^ 2 + ((y2 - y1) / 64) ^ 2) * 64
end

function printb(text, x, y, clr, bclr)
 xx = '-1+1+0+0-1-1+1+1'
 yy = '+0+0-1+1-1+1-1+1'
 for i = 1, 8, 1 do
  j = i * 2
  print(text, x + tonum(sub(xx, j - 1, j)), y + tonum(sub(yy, j - 1, j)), bclr)
 end
 print(text, x, y, clr)
end

function cursor_stats()
 stats_type = 1
 stats_show = 0
	for unit in all(blue_units) do
		if csr_xpos == unit.xpos and csr_ypos == unit.ypos then
			stats_unit = unit
			stats_show = 1
			break
		end
	end
	for unit in all(red_units) do
		if stats_show == 0 and csr_xpos == unit.xpos and csr_ypos == unit.ypos then
			stats_unit = unit
			stats_show = 1
			break
		end
	end
end