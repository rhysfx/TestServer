--[[ 
    This function needs to be invoked prior to calling CreateMissionTrain  or the trains (as well as its carriages) won't spawn.
    Could also result in a game-crash when CreateMissionTrain is called without
    loading the train model needed for the variation before-hand.
]]
function loadTrainModels()
    local trainsAndCarriages = {
        'freight', 'metrotrain', 'freightcont1', 'freightcar', 
        'freightcar2', 'freightcont2', 'tankercar', 'freightgrain'
    }

    for _, vehicleName in ipairs(trainsAndCarriages) do
        local modelHashKey = GetHashKey(vehicleName)
        RequestModel(modelHashKey) -- load the model
        -- wait for the model to load
        while not HasModelLoaded(modelHashKey) do
            Citizen.Wait(500)
        end
    end
end

loadTrainModels()

RegisterCommand("createtrain", function(source, args, rawCommand)
    if #args < 1 then
        TriggerEvent('chat:addMessage', {
            args = { 
                'Error, provide a variation id, you can find those in trains.xml. Variations range from 0 to 26.'
            }
        })
        return
    end
    
    local playerCoords = GetEntityCoords(PlayerPedId())
     -- Now actually create a train using a variation
     -- These coordinates were used for testing: 1438.98, 6405.92, 34.19
    CreateMissionTrain(
        tonumber(args[1]),
        playerCoords.x, playerCoords.y, playerCoords.z,
        true,
        true,
        true
    )
end, false)