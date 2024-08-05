local trainHandle = nil
local isDrivingTrain = false
local Config = {
    KeyBind = {
        SpeedUp = 32,   -- 'W' key
        SpeedDown = 33, -- 'S' key
        EBreak = 44     -- 'E' key
    },
    Speed = 0,
    Debug = true,
    TrainVeh = nil, -- This will be set when the train is created
}

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
    -- Create the train and store its handle
    trainHandle = CreateMissionTrain(
        tonumber(args[1]),
        playerCoords.x, playerCoords.y, playerCoords.z,
        true,
        true,
        true
    )
    
    -- Wait for the train to be fully spawned
    Citizen.Wait(1000)

    -- Put the player in the driver seat of the train
    local playerPed = PlayerPedId()
    TaskWarpPedIntoVehicle(playerPed, trainHandle, -1)
    
    -- Set driving state
    isDrivingTrain = true
    Config.TrainVeh = trainHandle
end, false)

Citizen.CreateThread(function()
    local acceleration = 0.5 -- Speed increment per cycle
    local deceleration = 0.5 -- Speed decrement per cycle
    local maxSpeed = 60.0 -- Maximum speed
    local brakeSpeed = 10.0 -- Speed decrement for braking

    while true do
        Citizen.Wait(0) -- wait for 0 milliseconds to make this thread run continuously
        
        if isDrivingTrain and Config.TrainVeh then
            local currentSpeed = GetTrainSpeed(Config.TrainVeh)
            local maxTrainSpeed = maxSpeed -- Example max speed, you can replace with dynamic values if needed

            -- Debugging
            if Config.Debug then
                DebugLog("Current Speed: " .. currentSpeed)
            end

            -- Check for brake (W + S keys)
            if IsControlPressed(0, Config.KeyBind.SpeedUp) and IsControlPressed(0, Config.KeyBind.SpeedDown) and Config.Debug and Config.Speed ~= 0 then
                if Config.Debug then
                    DebugLog("Debug Brake: " .. GetEntityCoords(Config.TrainVeh))
                end
                Config.Speed = 0
                SetTrainSpeed(Config.TrainVeh, 0)
            elseif IsControlPressed(0, Config.KeyBind.EBreak) then -- E Brake (X)
                Config.Speed = 0
                SetTrainSpeed(Config.TrainVeh, 0)
            elseif IsControlPressed(0, Config.KeyBind.SpeedUp) and Config.Speed < maxTrainSpeed then -- Forward (W)
                Config.Speed = math.min(Config.Speed + acceleration, maxTrainSpeed)
                SetTrainSpeed(Config.TrainVeh, Config.Speed)
            elseif IsControlPressed(0, Config.KeyBind.SpeedDown) and Config.Speed > -maxTrainSpeed then -- Backwards (S)
                Config.Speed = math.max(Config.Speed - deceleration, -maxTrainSpeed)
                SetTrainSpeed(Config.TrainVeh, Config.Speed)
            end
        end
    end
end)