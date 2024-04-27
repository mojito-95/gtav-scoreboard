local serverName = "Grand Theft Auto V"

local frame = nil
local planet = Material("gtav_scoreboard/planet.png", "smooth")
local backgroundColor = Color(42, 45, 53, 255)
local firstBackgroundColor = Color(64, 93, 125, 235)
local secondBackgroundColor = Color(55, 83, 113, 235)
local iconBackgroundColor = Color(20, 20, 20, 255)

surface.CreateFont("Mojito.GTAV.Title", {
        size = ScrW() * 0.02,
        weight = 500,
        antialias = true,
        shadow = false,
        font = "Copyright House industries",
        extended = true,
})

surface.CreateFont("Mojito.GTAV.Medium", {
        size = ScrW() * 0.016,
        weight = 400,
        antialias = true,
        shadow = false,
        font = "Bahnschrift Light",
        extended = true,
})

surface.CreateFont("Mojito.GTAV.Light", {
        size = ScrW() * 0.014,
        weight = 500,
        antialias = true,
        shadow = false,
        font = "Bahnschrift Light",
        extended = true,
})

local function DrawFrame()

    if (frame != nil) then return end

    frame = vgui.Create("DFrame")
	frame:SetSize(ScrW() * 0.26, ScrH() * 0.7)
	frame:SetPos(ScrW() * 0.02  , ScrH() * 0.025)
	frame:SetDraggable(false)
	frame:ShowCloseButton(false)
	frame:SetTitle("")
	frame.Paint = function(self, w, h)

        draw.RoundedBox(0, 0, 0, w, h * 0.08, backgroundColor)
        draw.SimpleText(serverName, "Mojito.GTAV.Title", w / 2, h * 0.044, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

	end

    local w, h = frame:GetSize()

    local panel = frame:Add("DPanel")
	panel:SetPos(0, h * 0.08)
	panel:SetSize(w, h * 0.8)
	panel.Paint = function(self, w, h) end

    local scrollPanel = panel:Add("DScrollPanel")
	scrollPanel:Dock(FILL)

    for k, v in pairs(player.GetAll()) do

        local panel = scrollPanel:Add("DPanel")
		panel:SetSize(w, h * 0.08)
		panel:SetText("")
		panel:Dock(TOP)
		panel:DockMargin(0, 0, 0, 0)
		panel.Paint = function(self, w, h)

            if (k % 2 == 0) then

                draw.RoundedBox(0, 0, 0, w, h, firstBackgroundColor)

            else

                draw.RoundedBox(0, 0, 0, w, h, secondBackgroundColor)

            end

            draw.RoundedBox(0, 0, 0, w * 0.16, h, iconBackgroundColor)
            if (string.len(v:Name()) > 22) then

                local name = string.sub(v:Name(), 0, 22).. "..."
                draw.SimpleText(name, "Mojito.GTAV.Medium", w * 0.176, h * 0.50, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            else

                draw.SimpleText(v:Name(), "Mojito.GTAV.Medium", w * 0.176, h * 0.50, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

            end
            draw.SimpleText(v:Frags(), "Mojito.GTAV.Light", w * 0.736, h * 0.50, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            draw.SimpleText(v:Deaths(), "Mojito.GTAV.Light", w * 0.812, h * 0.50, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
            surface.SetDrawColor(color_white)
            surface.SetMaterial(planet)
            surface.DrawTexturedRect(w * 0.878, h * 0.1, w * 0.1, h * 0.8)
            draw.SimpleText(v:Ping(), "Mojito.GTAV.Light", w * 0.9251, h * 0.50, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        end

        local w, h = panel:GetSize()

        local icon = panel:Add("DModelPanel")
        icon:SetPos(-8, 0)
        icon:SetSize(w * 0.2, h)
        icon:SetModel(v:GetModel())
        icon:SetAnimated(false)
        function icon:LayoutEntity(ent) return end

        local eyepos = icon.Entity:GetBonePosition(icon.Entity:LookupBone("ValveBiped.Bip01_Head1"))

        eyepos:Add(Vector(0, 0, 2))
        
        icon:SetLookAt(eyepos)
        icon:SetCamPos(eyepos-Vector(-20, 0, 0))
        icon.Entity:SetEyeTarget(eyepos-Vector(-20, 0, 0))

    end

end

hook.Add("ScoreboardShow", "Mojito.GTAV.ScoreboardShow", function()
	
    if(frame == nil) then

        gui.EnableScreenClicker(true)
        DrawFrame()

    end

    return false

end)

hook.Add("ScoreboardHide", "Mojito.GTAV.ScoreboardHide", function()

	if(frame != nil) then

        gui.EnableScreenClicker(false)
        frame:Remove()
        frame = nil

    end

end)