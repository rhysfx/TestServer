Trains.Client = {}

RegisterCommand('spawntrain', function()
    local trainModel = 'freight'
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)

    RequestModel(GetHashKey(trainModel))
    while not HasModelLoaded(GetHashKey(trainModel)) do
        Wait(1)
    end
    local train = CreateMissionTrain(24, playerPos.x, playerPos.y, playerPos.z, true)
    TaskWarpPedIntoVehicle(playerPed, train, -1)
end, false)
