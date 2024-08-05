Trains.Client = {}

Trains.Client.LoadTrainModels = function()
    for _, vehicleName in ipairs(Trains.Config.Models) do
        local modelHashKey = GetHashKey(vehicleName)
        RequestModel(modelHashKey)
        while not HasModelLoaded(modelHashKey) do
            Citizen.Wait(500)
        end
    end
end

Trains.Client.LoadTrainModels()

RegisterCommand("spawntrain", function(source, args, rawCommand)
    local playerCoords = GetEntityCoords(PlayerPedId())
    -- 1438.98, 6405.92, 34.19
    CreateMissionTrain(26, playerCoords.x, playerCoords.y, playerCoords.z, true, true, true)
end, false)