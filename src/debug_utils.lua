local entities = require("entities")
local triggers = require("triggers")
local libraries = require("libraries")
local celesteRender = require("celeste_render")
local toolHandler = require("tools")
local sceneHandler = require("scene_handler")
local languageRegistry = require("language_registry")
local modHandler = require("mods")
local tasks = require("utils.tasks")
local utils = require("utils")
local logging = require("logging")

local hasProfile, profile = utils.tryrequire("profile.profile", false)
local origYield = coroutine.yield

local debugUtils = {}

-- Clear restart of Lua state without restarting application
function debugUtils.restartProcess()
    love.event.quit("restart")
end

function debugUtils.reloadMods()
    logging.info("Reloading mods")

    modHandler.unrequireKnownPluginRequires()
end

function debugUtils.reloadEntities()
    logging.info("Reloading entities")

    entities.initLogging()
    entities.initDefaultRegistry()

    entities.loadInternalEntities()
    entities.loadExternalEntities()
end

function debugUtils.reloadTriggers()
    logging.info("Reloading triggers")

    triggers.initDefaultRegistry()

    triggers.loadInternalTriggers()
    triggers.loadExternalTriggers()
end

function debugUtils.reloadTools()
    logging.info("Reloading tools")

    toolHandler.unloadTools()

    toolHandler.loadInternalTools()
    toolHandler.loadExternalTools()
end

function debugUtils.reloadScenes()
    logging.info("Reloading scenes")

    local scene = sceneHandler.getCurrentScene()

    sceneHandler.clearLoadedScenes()

    sceneHandler.loadInternalScenes()
    sceneHandler.loadExternalScenes()

    if scene then
        sceneHandler.changeScene(scene.name)
    end
end

function debugUtils.reloadLanguageFiles()
    logging.info("Reloading language files")

    languageRegistry.unloadFiles()

    languageRegistry.loadInternalFiles()
    languageRegistry.loadExternalFiles()

    languageRegistry.setLanguage(languageRegistry.currentLanguageName)
end

function debugUtils.reloadLibraries()
    logging.info("Reloading Libraries")

    libraries.initDefaultRegistry()

    libraries.loadInternalLibraries()
    libraries.loadExternalLibraries()
end

function debugUtils.reloadUI()
    -- Unimplemented
    -- UI branch can choose to change this function
end

function debugUtils.redrawMap()
    logging.info("Redrawing map")

    celesteRender.invalidateRoomCache()
    celesteRender.clearBatchingTasks()
end

-- TODO - Add as more hotswapping becomes available
function debugUtils.reloadEverything()
    logging.info("Reloading everything")

    debugUtils.reloadLanguageFiles()
    debugUtils.reloadLibraries()
    debugUtils.reloadMods()
    debugUtils.reloadEntities()
    debugUtils.reloadTriggers()
    debugUtils.reloadTools()
    debugUtils.reloadScenes()
    debugUtils.redrawMap()
    debugUtils.reloadUI()
end

function debugUtils.restartLuaInstance()
    love.event.quit("restart")
end

function debugUtils.debug()
    debug.debug()
end

function debugUtils.disableYields()
    coroutine.yield = function() end
    tasks.yield = coroutine.yield
end

function debugUtils.enableYields()
    coroutine.yield = origYield
    tasks.yield = coroutine.yield
end

function debugUtils.profile(f, options, ...)
    if not hasProfile then
        return "Profile library not available"
    end

    options = options or {}

    local yieldsAlreadyDisabled = coroutine.yield ~= origYield
    local rounds = options.rounds or 1

    if not yieldsAlreadyDisabled and (options.disableYields or options.disableYields == nil) then
        debugUtils.disableYields()
    end


    local res

    profile.reset()
    profile.start()


    for i = 1, rounds do
        res = f(...)
    end

    profile.stop()

    if not yieldsAlreadyDisabled and (options.disableYields or options.disableYields == nil) then
        debugUtils.enableYields()
    end

    local report = profile.report(options.rows or 50)

    if options.filename then
        local fh = io.open(options.filename, "wb")

        if fh then
            fh:write(report)
            fh:close()
        end
    end

    return report, res
end

function debugUtils.timeIt(f, options, ...)
    options = options or {}

    local start = love.timer.getTime()
    local rounds = options.rounds or 1000 

    for i = 1, rounds do
        f(...)
    end

    local timeTaken = love.timer.getTime() - start

    return timeTaken, timeTaken / rounds
end

return debugUtils