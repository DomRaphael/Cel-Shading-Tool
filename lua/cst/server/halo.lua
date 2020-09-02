util.AddNetworkString("net_left_click_start")
util.AddNetworkString("net_left_click_finish")
util.AddNetworkString("net_right_click")
util.AddNetworkString("net_set_halo")
util.AddNetworkString("net_remove_halo")

function CST:SetHalo(ply, ent, h_data)
    ent.cel = h_data

    timer.Create("DuplicatorFix", 0.1, 1, function()
        for _,v in pairs(player.GetAll()) do
            net.Start("net_set_halo")
            net.WriteEntity(ent)
            net.WriteTable(h_data)
            net.Send(v)
        end

        table.insert(self.ENTITIES, { ent })
        duplicator.StoreEntityModifier(ent, "Cel_Halo", h_data)
    end)
end
duplicator.RegisterEntityModifier("Cel_Halo", CST.SetHalo)

function CST:RemoveHalo(ent)
    ent.cel = nil

    for k,v in pairs(self.ENTITIES) do
        if (table.HasValue(v, ent)) then
            self.ENTITIES[k] = nil
        end
    end

    for _,v in pairs(player.GetAll()) do
        net.Start("net_remove_halo")
        net.WriteEntity(ent)
        net.Send(v)
    end

    duplicator.ClearEntityModifier(ent, "Cel_Halo")
end
