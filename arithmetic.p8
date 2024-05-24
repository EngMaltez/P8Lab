pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- arithmetic
-- by miguel maltez

-- numbers battle with addition
-- tile based

-- actions:
--  . attack adjencent
--  . do nothing

function _init()
	p_x = 0
	p_y = 0
end

function _update()
	if btnp(➡️) then
		p_x += 1
	end
	if btnp(⬅️) then
		p_x -= 1
	end
	if btnp(⬇️) then
		p_y += 1
	end
	if btnp(⬆️) then
		p_y -= 1
	end
end

function _draw()
	cls()
	print("웃",p_x, p_y,12)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000