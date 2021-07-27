 
ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent("dhz_carwash:checkmoney")
AddEventHandler("dhz_carwash:checkmoney", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
	local prix = 250
    local xMoney = xPlayer.getMoney()
    
     if xMoney >= prix then
          xPlayer.removeMoney(prix)
          TriggerClientEvent('dhz_carwash:success', source, 250)
     else
		  TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas assez d'argent")
     end    
end)
