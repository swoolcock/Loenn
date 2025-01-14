local drawing = require("utils.drawing")
local utils = require("utils")
local drawableLine = require("structs.drawable_line")

local wire = {}

wire.name = "wire"
wire.nodeLimits = {1, 1}
wire.fieldInformation = {
    color = {
        fieldType = "color"
    }
}

function wire.depth(room, entity)
    return entity.above and -8500 or 2000
end

local defaultColor = {89 / 255, 88 / 255, 102 / 255}

function wire.sprite(room, entity)
    local color = defaultColor

    if entity.color then
        local success, r, g, b = utils.parseHexColor(entity.color)

        if success then
            color = {r, g, b}
        end
    end

    local firstNode = entity.nodes[1]

    local start = {entity.x, entity.y}
    local stop = {firstNode.x, firstNode.y}
    local control = {
        (start[1] + stop[1]) / 2,
        (start[2] + stop[2]) / 2 + 24
    }

    local points = drawing.getSimpleCurve(start, stop, control)

    return drawableLine.fromPoints(points, color, 1)
end

function wire.selection(room, entity)
    local main = utils.rectangle(entity.x - 2, entity.y - 2, 5, 5)
    local nodes = {}

    if entity.nodes then
        for i, node in ipairs(entity.nodes) do
            nodes[i] = utils.rectangle(node.x - 2, node.y - 2, 5, 5)
        end
    end

    return main, nodes
end

wire.placements = {
    name = "wire",
    data = {
        above = false,
        color = "595866"
    }
}

return wire