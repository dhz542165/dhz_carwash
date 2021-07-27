ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

vehicleWashStation = {
	vector3(26.5906, -1392.0261, 27.3634),
	vector3(167.1034, -1719.4704, 27.2916),
	vector3(-74.5693, 6427.8715, 29.4400),
	vector3(-699.6325, -932.7043, 17.0139)
}

Citizen.CreateThread(function()
	for i=1, #vehicleWashStation, 1 do
		carWashLocation = vehicleWashStation[i]
		local blip = AddBlipForCoord(carWashLocation)
		SetBlipSprite(blip, 100)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName('STRING')
		AddTextComponentString('Carwash')
		EndTextCommandSetBlipName(blip)
	end
end)

local timer2 = false
local mycie = false
Citizen.CreateThread(function ()
	while true do
		Citizen.Wait(0)
		if IsPedSittingInAnyVehicle(PlayerPedId()) then 
			for i=1, #vehicleWashStation, 1 do
				garageCoords2 = vehicleWashStation[i]
				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vehicleWashStation[i], true ) < 5 then
					Texte2D('Faites ~g~[E]~s~ pour nettoyer votre voiture ~g~(250$)',1)
					if IsControlJustPressed(1, 38) then
						TriggerServerEvent('dhz_carwash:checkmoney')
					end
				end
			end
		end
	end
end)


RegisterNetEvent('dhz_carwash:success')
AddEventHandler('dhz_carwash:success', function (price)
	local car = GetVehiclePedIsUsing(PlayerPedId())
	local coords = GetEntityCoords(PlayerPedId())
	mycie = true
	FreezeEntityPosition(car, true)
	if not HasNamedPtfxAssetLoaded("core") then
		RequestNamedPtfxAsset("core")
		while not HasNamedPtfxAssetLoaded("core") do
			Wait(1)
		end
	end
	UseParticleFxAssetNextCall("core")
	particles  = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p", coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	UseParticleFxAssetNextCall("core")
	particles2  = StartParticleFxLoopedAtCoord("ent_amb_waterfall_splash_p", coords.x + 2, coords.y, coords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
	timer = 15
	timer2 = true
    Citizen.CreateThread(function()
		while timer2 do
            Citizen.Wait(0)
            Citizen.Wait(1000)
            if(timer > 0)then
				timer = timer - 1
			elseif (timer == 0) then
				mycie = false
				WashDecalsFromVehicle(car, 1.0)
				SetVehicleDirtLevel(car)
				FreezeEntityPosition(car, false)
				ESX.ShowNotification("Votre véhicule à été nettoyé pour ~g~250$")
				StopParticleFxLooped(particles, 0)
				StopParticleFxLooped(particles2, 0)
				timer2 = false
			end
        end
    end)
end)

function Texte2D(msg, time)
    ClearPrints()
    BeginTextCommandPrint('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandPrint(time, 1)
end