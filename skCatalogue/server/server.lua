local ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local listCar = {}
local listCat = {}

RegisterNetEvent('skCatalogue:SelectCar')
AddEventHandler('skCatalogue:SelectCar', function(name)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    if (not xPlayer) then return end
    MySQL.Async.fetchAll("SELECT * FROM vehicles WHERE category = @category", { ["@category"] = name }, function(result)
        if (result) then
            listCar = result
            TriggerClientEvent('skCatalogue:Car', _src, listCar)
        end
    end)
end)

RegisterNetEvent('skCatalogue:SelectCat')
AddEventHandler('skCatalogue:SelectCat', function()
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    if (not xPlayer) then return end
    MySQL.Async.fetchAll("SELECT * FROM vehicle_categories", {}, function(result)
        if (result) then
            listCat = result
            TriggerClientEvent('skCatalogue:CategoriesCar', _src, listCat)
        end
    end)
end)

print("[^1Auteur^0] : ^4Skymidz#7333^0")