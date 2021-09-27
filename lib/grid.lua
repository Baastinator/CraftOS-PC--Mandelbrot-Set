--imports


--globals
local grid = {}

--functions

local function init(X, Y)
    for y=1,Y do
        grid[y] = {}
        for x=1,X do
            grid[y][x] = {lightLevel=0}
        end
    end
end

local function GetlightLevel(X,Y)
    return grid[Y][X].lightLevel
end

local function SetlightLevel(X,Y,Value)
    grid[Y][X].lightLevel = Value
end

local function fill(X,Y,W,H,D)
    for y=1,H do
        for x=1,W do
            SetlightLevel(X+x-1,Y+y-1,D)
        end
    end
end



return {
    fill = fill,
    GetlightLevel = GetlightLevel,
    SetlightLevel = SetlightLevel,
    grid = grid,
    init = init
}
