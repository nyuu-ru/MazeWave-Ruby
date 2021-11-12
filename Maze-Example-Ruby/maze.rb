#!/usr/bin/env ruby

MAZE = [
    "##########",
    "#        #",
    "### ### ##",
    "#    #   #",
    "## #### ##",
    "#  #  ####",
    "# ###    #",
    "# # # ## #",
    "#     #  #",
    "##########",
]

FROM = [1,1]
TO   = [8,8]

EMPTY =  0
WALL  = -1
PATH  = -2

def cook_map(map)
    cooked = []
    
    map.each do |row|
        cols = []
        row.each_char do |ch|
            if ch == '#'
                cols.push WALL
            else
                cols.push EMPTY
            end
        end
        cooked.push cols
    end
    return cooked
end

def print_map(map)
    map.each do |row|
        row.each do |cell|
            case cell
                when WALL
                    print "\u2588\u2588" # ██
                when PATH
                    print "\u2591\u2591" # ░░
                else
                    print "  "
            end
        end
        puts
    end
end

def send_wave(map, from, to)
    fx, fy = from
    tx, ty = to
    
    iter = 1
    map[fx][fy] = iter
    found = false
    loop do
        map[1..-2].each_with_index do |row_data, row|
            row += 1
            row_data[1..-2].each_with_index do |cell, col|
                next unless cell == iter
                col += 1
                found = true
                if map[row][col-1] == EMPTY then map[row][col-1] = iter+1 end
                if map[row][col+1] == EMPTY then map[row][col+1] = iter+1 end
                if map[row-1][col] == EMPTY then map[row-1][col] = iter+1 end
                if map[row+1][col] == EMPTY then map[row+1][col] = iter+1 end
            end
        end
        iter += 1
        break if map[tx][ty] != EMPTY
        break if not found
        found = false
    end
    return found
end

def draw_path(map, finish)
    x, y = finish
    loop do
        iter = map[x][y]
        break if iter == 1
        iter -= 1
        map[x][y] = PATH
        if map[x][y-1] == iter then y -= 1; next end
        if map[x][y+1] == iter then y += 1; next end
        if map[x-1][y] == iter then x -= 1; next end
        if map[x+1][y] == iter then x += 1; next end
    end
    map[x][y] = PATH
end


work_map = cook_map(MAZE)

found = send_wave(work_map, FROM, TO)
if not found
    puts "No way!"
else
    draw_path(work_map, TO)
end

print_map work_map
