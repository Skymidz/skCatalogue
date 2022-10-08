
ESX = nil
Citizen.CreateThread(function() while ESX == nil do TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) Citizen.Wait(0) end end)

local listCarMenu = {}
local listCategoriesCar = {}
local entityCar = nil
local Etat = false

Menu = {
    ListColor = {}, IndexListColor = 1
}

for k,v in pairs (Config.ListColor) do table.insert(Menu.ListColor, v.nameColor) end

RegisterNetEvent('skCatalogue:Car')
AddEventHandler('skCatalogue:Car', function(listCar) listCarMenu = listCar end)

RegisterNetEvent('skCatalogue:CategoriesCar')
AddEventHandler('skCatalogue:CategoriesCar', function(listCat) listCategoriesCar = listCat end)

function LoadMenuCatalogue()
    local menuCatalogue = RageUI.CreateMenu("~u~Catalogue", "Catégories", 10, 40, 'banner', 'sk_banner')
    local menuCar = RageUI.CreateSubMenu(menuCatalogue, "~u~Catalogue", "Véhicules")
    local menuEssai = RageUI.CreateSubMenu(menuCatalogue, "~u~Catalogue", "Option(s)")

    RageUI.Visible(menuCatalogue, not RageUI.Visible(menuCatalogue))
    while menuCatalogue do
        Citizen.Wait(0)

        RageUI.IsVisible(menuCatalogue,true,true,true,function()
            for k,v in pairs(listCategoriesCar) do 
                RageUI.ButtonWithStyle(Config.Menu.Color.."→~s~ "..v.label, nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(h, a, s)
                    if s then TriggerServerEvent('skCatalogue:SelectCar', v.name) end
                end, menuCar)
            end 
        end, function() end, 1)

        RageUI.IsVisible(menuCar,true,true,true,function()
            for k,v in pairs(listCarMenu) do
                RageUI.ButtonWithStyle(Config.Menu.Color.."→~s~ "..v.name, nil, {RightLabel = "~g~"..v.price.." $"}, true, function(h, a, s)
                    if a then
                        car = GetHashKey(v.model)
                    end
                    if s then
                        if DoesEntityExist(entityCar) then DeleteEntity(entityCar) end
                        ESX.Game.SpawnLocalVehicle(v.model, Config.Position.SpawnCar, Config.Position.SpawnCarHeading, function(vehicle)
                            FreezeEntityPosition(vehicle, true)
                            SetEntityInvincible(vehicle, true)
                            SetVehicleDoorsLocked(vehicle, 2)
                            SetVehicleDirtLevel(vehicle, 0)
                            SetVehicleNumberPlateText(vehicle, "ESSAICAR")
                            entityCar = vehicle
                        end)
                    end
                end, menuEssai)
            end 
        end, function() end, 1)

        RageUI.IsVisible(menuEssai,true,true,true,function()
            RageUI.ButtonWithStyle("~r~→ Retour", nil, {RightLabel = "→→→"}, true, function(h, a, s)
                if s then
                    DeleteEntity(entityCar)
                    RageUI.GoBack()
                end
            end)
            RageUI.Line(Config.Menu.rgba.r, Config.Menu.rgba.g, Config.Menu.rgba.b, Config.Menu.rgba.a)
            RageUI.List(Config.Menu.Color.."→~s~ Couleur", Menu.ListColor, Menu.IndexListColor, "N°"..Config.Menu.Color..Menu.IndexListColor.."~s~/"..Config.Menu.Color..#Menu.ListColor, {}, true,{
                onListChange = function(Index) Menu.IndexListColor=Index end,
                onSelected = function(Num, Heure) SetVehicleColours(entityCar, Config.ListColor[Num].idColor, 0) end
            })
            RageUI.ButtonWithStyle(Config.Menu.Color.."→~s~ Tester le Véhicule", nil, {RightLabel = "→→→"}, true, function(h, a, s)
                if s then
                    if Config.OneByOne then 
                        if Etat then 
                            ESX.ShowNotification("~r~Une personne test déjà un véhicule.")
                        else 
                            Etat = true
                        end
                    end
                    ESX.Game.SpawnVehicle(car, Config.Position.SpawnCarEssai, Config.Position.SpawnCarEssaiHeading, function(vehicle)
                        SetVehicleFuelLevel(vehicle, 50.0)
                        SetVehicleDirtLevel(vehicle, 0)
                        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1) 
                        SetVehicleNumberPlateText(vehicle, "ESSAICAR")
                        EssaiCar()
                    end)
                    RageUI.CloseAll()
                end
            end)
        end, function() end, 1)

        if not RageUI.Visible(menuCatalogue) and not RageUI.Visible(menuCar) and not RageUI.Visible(menuEssai) then
            menuCatalogue=RMenu:DeleteType("Catalogue", true)
            FreezeEntityPosition(PlayerPedId(), false)
            if DoesEntityExist(entityCar) then DeleteEntity(entityCar) end
        end
    end
end

function EssaiCar()
    local EtatEssaiCar = true
    local timeEssai = Config.TimeEssai
    Wait(1000)
    while EtatEssaiCar do
        timeEssai = timeEssai - 1
        RageUI.Text({ message = "Temps restant ["..Config.Menu.Color..timeEssai.."~s~] seconde(s)", time_display = 1000})
        while IsPedInAnyVehicle(PlayerPedId()) == false do 
            ESX.ShowNotification("~r~Vous êtes descendu du véhicule.")
            DeleteEntity(GetClosestVehicle(GetEntityCoords(PlayerPedId()), 15.0, 0, 70))
            ESX.Game.Teleport(PlayerPedId(), Config.Position.Menu, function()end)
            FreezeEntityPosition(PlayerPedId(), false)
            EtatEssaiCar, Etat = false, false
            return
        end
        if timeEssai == 0 then 
            ESX.ShowNotification("~r~L'essai du véhicule est terminé.")
            ESX.Game.DeleteVehicle(GetVehiclePedIsIn(PlayerPedId(), false))
            ESX.Game.Teleport(PlayerPedId(), Config.Position.Menu, function()end)
            FreezeEntityPosition(PlayerPedId(), false)
            EtatEssaiCar, Etat = false, false
            return
        end
        Citizen.Wait(1000)
    end
end

Citizen.CreateThread(function()
    while true do
        local interval = 500
        local menuCoords = Config.Position.Menu
        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
        local distance = #(menuCoords - plyCoords)
        if distance <= Config.Distance.Marker then 
            interval = 1
            DrawMarker(27, menuCoords.x,menuCoords.y,menuCoords.z-1, 60.0, 0.0, 0.0, 0.0,0.0,0.0, 1.2, 1.2, 1.2, Config.Menu.rgba.r, Config.Menu.rgba.g, Config.Menu.rgba.b, Config.Menu.rgba.a, false, true, p19, true)
        end
        if distance <= Config.Distance.Texte then
            interval = 1
            RageUI.Text({ message = "Appuyez sur ["..Config.Menu.Color.."E~s~] pour accéder au catalogue", time_display = 1})
            if IsControlJustPressed(1, 51) then
                FreezeEntityPosition(PlayerPedId(), true)
                TriggerServerEvent("skCatalogue:SelectCat")
                LoadMenuCatalogue()
            end
        elseif distance > Config.Distance.Marker then interval = 200
        elseif distance > 30 then interval = 500
        elseif distance > 50 then interval = 2000 end
        Citizen.Wait(interval)
    end
end)