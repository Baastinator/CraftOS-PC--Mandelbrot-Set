local function new(a,b )
    return {a=a or 1, b=b or 0}
end

local function getLength( a )
    return math.sqrt( a.a * a.a + a.b * a.b )
end

local function add(a ,b)
    return new(
        a.a + b.a,
        a.b + b.b
    )
end

local function multiply(a,b)
    return new(
        a.a * b.a - a.b * b.b,
        a.a * b.b + b.a * a.b
    )
end

return {
    add = add,
    multiply = multiply,
    getLength = getLength,
    new = new
}