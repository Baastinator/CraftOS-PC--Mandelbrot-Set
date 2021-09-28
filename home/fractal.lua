--imports

local Grid = dofile("lib/grid.lua")
local draw = dofile("lib/draw.lua")
local CN = dofile("lib/CompNum.lua")


--globals

local res = {}
local tres = {}
local key, event
local mainLoop = true
local renderBool = false

local zoom = 0.5
local pos = {x=1.25,y=0.5}

--side functions

local function keyboardInput()
    local is_held
    while true do
    ---@diagnostic disable-next-line: undefined-field
        event, key, is_held = os.pullEvent("key") 
        if key == 20 then mainLoop = false end
        if key == keys.numPadAdd then zoom = zoom * 1.01 renderBool = true
        elseif key == keys.numPadSubtract then zoom = zoom / 1.01 renderBool = true end
        if key == keys.right then pos.x = pos.x - 0.1/zoom renderBool = true 
        elseif key == keys.left then pos.x = pos.x + 0.1/zoom renderBool = true end
        if key == keys.up then pos.y = pos.y + 0.1/zoom renderBool = true 
        elseif key == keys.down then pos.y = pos.y - 0.1/zoom renderBool = true end
        key = nil
    end
end

local function render()
    for y, vx in ipairs(Grid.grid) do
        for x, vy in ipairs(vx) do
            local C = CN.new((x/res.y)/zoom-pos.x,(y/res.y)/zoom-pos.y)
            --local C = CN.new((x/res.y*0.1)-0.65,(y/res.y*0.1)-0.7) --TWIG ZOOM 1
            --local C = CN.new((x/res.y*2)-2.3,(y/res.y*2)-1) --NO ZOOM
            local Z = CN.new(0,0)
            if (CN.getLength(CN.new((x/res.y*2)-2.3,(y/res.y*2)-1))) < 5 then
                Grid.SetlightLevel(x,y,1)
                local iterations = 500
                for i=1,iterations do
                    Z = CN.add(CN.multiply(Z,Z),C)
                    if (CN.getLength(Z) > 5) then
                        Grid.SetlightLevel(x,y,i/iterations)
                        break
                    end
                end
                
            end
        end
    end
    draw.drawFromArray2D(0,0,Grid)
end

--main functions

local function init()
    term.clear()
    term.setGraphicsMode(2)
    draw.setPalette()
    term.clear()
    tres.x, tres.y = term.getSize(1)
    res = tres
    Grid.init(res.x, res.y)
end

local function start()
   render()
end

local function update()
    if renderBool then
        render()
        renderBool = false
    end
end

local function close()
    term.clear()
    term.setGraphicsMode(0)
    draw.resetPalette()
    term.clear()
    term.setCursorPos(1,1)
end

--main structure

local function main()
    init()
    start()
    while mainLoop do
        update()
        sleep(0)
    end
    close()
end

--execution

parallel.waitForAny(main, keyboardInput)
