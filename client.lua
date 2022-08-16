local active = false
local water = 100
local food = 100

Citizen.CreateThread(function()
    while true do
        Wait(150)
        if active == false then
            if IsPedRunning(PlayerPedId()) then
                active = true
                SendNUIMessage({
                    showhud = true
                })
            end
        end
        if active == false then
            if IsPedSprinting(PlayerPedId()) then
                active = true
                SendNUIMessage({
                    showhud = true
                })
            end
        end
        if active == false then
            if IsPedStopped(PlayerPedId()) then
                active = true
                SendNUIMessage({
                    showhud = true
                })
            end
        end
    end
end)


Citizen.CreateThread(function()
    while true do
        Wait(100)
        SendNUIMessage({
			thrist = water,
			hunger = food,
			temp = GetCurrentTemperature()
		})
    end
end)

RegisterNetEvent('exttasy_status:changeMetabolism')
AddEventHandler("exttasy_status:changeMetabolism", function(status, valor)
	valor2 = (valor / 10)
	if status == "Thirst" then
		water = valor2
		SendNUIMessage({
			thrist = valor2
		})
	elseif status == "Hunger" then
		food = valor2
		SendNUIMessage({
			hunger = valor2
		})
	end
end)

RegisterNetEvent('exttasy_status:changeMetabolisms')
AddEventHandler("exttasy_status:changeMetabolisms", function(thristvalor, hungervalor)
	thristvalorvalor2 = (thristvalor / 10)
	hungervalorvalor2 = (hungervalor / 10)
	water = thristvalorvalor2
	food = hungervalorvalor2
	SendNUIMessage({
        thrist = water,
        hunger = food,
        temp = GetCurrentTemperature()
    })
end)

Citizen.CreateThread(function()
    while true do
		Citizen.Wait(0)
		local player = PlayerPedId()
        local coords = GetEntityCoords(player)
        Citizen.InvokeNative(0xB98B78C3768AF6E0,true)
		local temp = math.floor(GetTemperatureAtCoords(coords))
		local hot = 0
		local cold = 0


		if temp > 20 then
			hot = 3
		else
			hot = 0
		end

		if temp < -20 then
			cold = 3
		else
			cold = 0
		end

        if IsPedRunning(PlayerPedId()) then
            food = food - (2 + cold)
            water = water - (3 + hot)
        elseif IsPedWalking(PlayerPedId()) then
            food = food - (0.5 + cold)
            water = water - (1 + hot)
        else
    		food = food - (0.5 + cold)
			water = water - (0.5 + hot)
		end
		Citizen.Wait(40000)
		if food < 20 or water < 20 then
			local newhealth = GetAttributeCoreValue(PlayerPedId(), 0) - 15
			Citizen.InvokeNative(0xC6258F41D86676E0, PlayerPedId(), 0, newhealth)
        end
	end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if food <= 1 or water <= 1 then
            food = 0
            water = 0
            local pl = Citizen.InvokeNative(0x217E9DC48139933D)
    		local ped = Citizen.InvokeNative(0x275F255ED201B937, pl)
        	Citizen.InvokeNative(0x697157CED63F18D4, PlayerPedId(), 500000, false, true, true)
            food = 40
            water = 40
        end
    end
end)

function GetCurrentTemperature()
    local player = PlayerPedId()
    local coords = GetEntityCoords(player)
    ShouldUseMetricTemperature()
    return round(GetTemperatureAtCoords(coords.x, coords.y, coords.z), 1)
end

function round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end
