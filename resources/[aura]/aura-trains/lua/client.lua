Trains.Client = {}

RegisterCommand('spawntrain', function()
    local trainModel = 'freight'
    local trainCarModel = 'freightcar'

    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)

    RequestModel(GetHashKey(trainModel))
    while not HasModelLoaded(GetHashKey(trainModel)) do
        Wait(1)
    end

    RequestModel(GetHashKey(trainCarModel))
    while not HasModelLoaded(GetHashKey(trainCarModel)) do
        Wait(1)
    end

    local train = CreateMissionTrain(24, playerPos.x, playerPos.y, playerPos.z, true)

    local carCount = 2
    for i = 1, carCount do
        local car = CreateVehicle(GetHashKey(trainCarModel), playerPos.x, playerPos.y, playerPos.z, 0.0, true, true)
        AttachVehicleToTrain(car, train, i)
    end

    TaskWarpPedIntoVehicle(playerPed, train, -1)
end, false)
