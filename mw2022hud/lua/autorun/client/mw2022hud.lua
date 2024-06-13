include("mwhud-tfabasekeys.lua")
include("firemodescript/firemodescript.lua")

local stockGunIcons = { -- Stock HL2 gun icons use a FONT.
    weapon_357 = 'e',
    weapon_ar2 = 'l',
    weapon_bugbait = 'j',
    weapon_crossbow = 'g',
    weapon_crowbar = 'c',
    weapon_frag = 'k',
    weapon_physcannon = 'm',
    weapon_physgun = 'm',
    weapon_pistol = 'd',
    weapon_rpg = 'i',
    weapon_shotgun = 'b',
    weapon_slam = 'o',
    weapon_smg1 = 'a',
    weapon_stunstick = 'n',
}

local CPPAltfireWeps = {
	["Weapon_smg1"] = true,
	["Weapon_ar2"] = true,
	["Weapon_mp5_hl1"] = true
}

local ply = LocalPlayer()

local Weapon = nil
local WeaponClass = ""
local WepClip1 = -1
local WepClip2 = -1
local WepMag1 = -1
local WepMag2 = -1
local WepReserve1 = -1
local WepReserve2 = -1
local HasAltFire = false
local ActivePrimaryFire = true
local BottomlessMag = false

local WeaponJammed = false

local redcolor = Color(255,65,65)

local yellowcolor = Color(255,255,0)

local whitecolor = Color(255,255,255)

local graycolor = Color(178,178,178)
local bggraycolor = Color(106,106,106)

local blackcolor = Color(0,0,0)

local dispw = ScrW()
local disph = ScrH()

local scale = disph / 1080

local hide = {
	CHudBattery = true,
	CHudHealth = true,
	CHudDamageIndicator = true,
    CHudAmmo = true,
    CHudSecondaryAmmo = true
}

local platemat = Material("mw2022/armorplate.png")

hook.Add("HUDShouldDraw", "hudhide", function(name)
	if hide[name] then return false end
end)

surface.CreateFont("mwiitextnormal", {
    shadow = false,
    blursize = 0,
    underline = false,
    rotary = false,
    strikeout = false,
    additive = false,
    antialias = true,
    extended = false,
    scanlines = 0,
    font = "Stratum2 BETA Medium",
    italic = false,
    outline = false,
    symbol = false,
    weight = 2,
    size = 50 * scale
})

surface.CreateFont("mwiitextsmoler", {
    shadow = false,
    blursize = 0,
    underline = false,
    rotary = false,
    strikeout = false,
    additive = false,
    antialias = true,
    extended = false,
    scanlines = 0,
    font = "Stratum2 BETA Medium",
    italic = false,
    outline = false,
    symbol = false,
    weight = 2,
    size = 30 * scale
})

surface.CreateFont("mwiinicktext", {
    shadow = false,
    blursize = 0,
    underline = false,
    rotary = false,
    strikeout = false,
    additive = false,
    antialias = true,
    extended = false,
    scanlines = 0,
    font = "Stratum2 BETA Medium",
    italic = false,
    outline = false,
    symbol = false,
    weight = 2,
    size = 24 * scale
})

surface.CreateFont("mwiinickblur", {
    shadow = false,
    blursize = 5 * scale,
    underline = false,
    rotary = false,
    strikeout = false,
    additive = false,
    antialias = true,
    extended = false,
    scanlines = 0,
    font = "Stratum2 BETA Medium",
    italic = false,
    outline = false,
    symbol = false,
    weight = 2,
    size = 24 * scale
})

surface.CreateFont("mw2iitextnormal", {
    shadow = false,
    blursize = 5 * scale,
    underline = false,
    rotary = false,
    strikeout = false,
    additive = false,
    antialias = true,
    extended = false,
    scanlines = 0,
    font = "Stratum2 BETA Medium",
    italic = false,
    outline = false,
    symbol = false,
    weight = 2,
    size = 50 * scale
})

surface.CreateFont("mw2iitextsmoler", {
    shadow = false,
    blursize = 5 * scale,
    underline = false,
    rotary = false,
    strikeout = false,
    additive = false,
    antialias = true,
    extended = false,
    scanlines = 0,
    font = "Stratum2 BETA Medium",
    italic = false,
    outline = false,
    symbol = false,
    weight = 2,
    size = 30 * scale
})

surface.CreateFont("mwiithicksmalltext", {
    shadow = false,
    blursize = 0,
    underline = false,
    rotary = false,
    strikeout = false,
    additive = false,
    antialias = true,
    extended = false,
    scanlines = 0,
    font = "Stratum2 BETA Medium",
    italic = false,
    outline = false,
    symbol = false,
    weight = 500,
    size = 30 * scale
})

surface.CreateFont("mwiireloadtext", {
    shadow = false,
    blursize = 0,
    underline = false,
    rotary = false,
    strikeout = false,
    additive = false,
    antialias = true,
    extended = false,
    scanlines = 0,
    font = "Stratum2 BETA Medium",
    italic = false,
    outline = false,
    symbol = false,
    weight = 2,
    size = 30 * scale
})

surface.CreateFont("mwiinadetext", {
    shadow = false,
    blursize = 0,
    underline = false,
    rotary = false,
    strikeout = false,
    additive = false,
    antialias = true,
    extended = false,
    scanlines = 0,
    font = "Stratum2 BETA Medium",
    italic = false,
    outline = false,
    symbol = false,
    weight = 2,
    size = 30 * scale
})

surface.CreateFont("hl2wepicon", {
    font = 'halflife2',
    size = 128 * 1.3,
    outline = true
})

surface.CreateFont("hl2nadeicon", {
    font = 'halflife2',
    size = 64 * 1.3,
    outline = true
})

hook.Add("OnScreenSizeChanged", "mwiireschange", function()
    dispw = ScrW()
    disph = ScrH()
    surface.CreateFont("mwiitextnormal", {
        shadow = false,
        blursize = 0,
        underline = false,
        rotary = false,
        strikeout = false,
        additive = false,
        antialias = true,
        extended = false,
        scanlines = 0,
        font = "Stratum2 BETA Medium",
        italic = false,
        outline = true,
        symbol = false,
        weight = 2,
        size = 50 * scale
    })

    surface.CreateFont("mwiitextsmoler", {
        shadow = false,
        blursize = 0,
        underline = false,
        rotary = false,
        strikeout = false,
        additive = false,
        antialias = true,
        extended = false,
        scanlines = 0,
        font = "Stratum2 BETA Medium",
        italic = false,
        outline = true,
        symbol = false,
        weight = 2,
        size = 30 * scale
    })

    surface.CreateFont("mwiinadetext", {
        shadow = false,
        blursize = 0,
        underline = false,
        rotary = false,
        strikeout = false,
        additive = false,
        antialias = true,
        extended = false,
        scanlines = 0,
        font = "Stratum2 BETA Medium",
        italic = false,
        outline = true,
        symbol = false,
        weight = 2,
        size = 28 * scale
    })

    surface.CreateFont("mwiireloadtext", {
        shadow = false,
        blursize = 0,
        underline = false,
        rotary = false,
        strikeout = false,
        additive = false,
        antialias = true,
        extended = false,
        scanlines = 0,
        font = "Stratum2 BETA Medium",
        italic = false,
        outline = false,
        symbol = false,
        weight = 2,
        size = 30 * scale
    })

    surface.CreateFont("mwiithicksmalltext", {
        shadow = false,
        blursize = 0,
        underline = false,
        rotary = false,
        strikeout = false,
        additive = false,
        antialias = true,
        extended = false,
        scanlines = 0,
        font = "Stratum2 BETA Medium",
        italic = false,
        outline = true,
        symbol = false,
        weight = 500,
        size = 30 * scale
    })

    surface.CreateFont("mw2iitextnormal", {
        shadow = false,
        blursize = 5 * scale,
        underline = false,
        rotary = false,
        strikeout = false,
        additive = false,
        antialias = true,
        extended = false,
        scanlines = 0,
        font = "Stratum2 BETA Medium",
        italic = false,
        outline = false,
        symbol = false,
        weight = 2,
        size = 50 * scale
    })

    surface.CreateFont("mw2iitextsmoler", {
        shadow = false,
        blursize = 5 * scale,
        underline = false,
        rotary = false,
        strikeout = false,
        additive = false,
        antialias = true,
        extended = false,
        scanlines = 0,
        font = "Stratum2 BETA Medium",
        italic = false,
        outline = false,
        symbol = false,
        weight = 2,
        size = 30 * scale
    })

    surface.CreateFont("mwiinicktext", {
        shadow = false,
        blursize = 0,
        underline = false,
        rotary = false,
        strikeout = false,
        additive = false,
        antialias = true,
        extended = false,
        scanlines = 0,
        font = "Stratum2 BETA Medium",
        italic = false,
        outline = false,
        symbol = false,
        weight = 2,
        size = 24 * scale
    })

    surface.CreateFont("mwiinickblur", {
        shadow = false,
        blursize = 5 * blur,
        underline = false,
        rotary = false,
        strikeout = false,
        additive = false,
        antialias = true,
        extended = false,
        scanlines = 0,
        font = "Stratum2 BETA Medium",
        italic = false,
        outline = false,
        symbol = false,
        weight = 2,
        size = 24 * scale
    })

    surface.CreateFont("hl2wepicon", {
        font = 'halflife2',
        size = 128 * 1.3,
        outline = true
    })

    surface.CreateFont("hl2nadeicon", {
        font = 'halflife2',
        size = 64 * 1.3,
        outline = true
    })
end)

local function doNothing() end

function mwhuddrawgunicon(Weapon, x, y, width, h)
    if Weapon.DrawWeaponSelection then
        local oldDrawInfo = Weapon.PrintWeaponInfo
        Weapon.PrintWeaponInfo = doNothing
        Weapon:DrawWeaponSelection(x, y, width, h, 255)
        Weapon.PrintWeaponInfo = oldDrawInfo
    else
        local iconChar = stockGunIcons[Weapon:GetClass()]
        if iconChar then
            draw.SimpleText(iconChar,"hl2wepicon",x + width / 2,y + h / 2,headerTextColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
        end
    end
end

function PKAD2_GetWeaponData()
    -- Yes I reuse code. Is that bad? No.
	ply = LocalPlayer()
	Weapon = ply:GetActiveWeapon()

	if !IsValid(Weapon) then return end

	WeaponClass = Weapon:GetClass()
	WepClip1 = Weapon:Clip1()
	WepClip2 = Weapon:Clip2()
	WepMag1 = Weapon:GetMaxClip1()
	WepMag2 = Weapon:GetMaxClip2()
	WepReserve1 = math.Clamp(ply:GetAmmoCount(Weapon:GetPrimaryAmmoType()), 0, 2147483647)
	WepReserve2 = math.Clamp(ply:GetAmmoCount(Weapon:GetSecondaryAmmoType()), 0, 2147483647)
	OverCapacity = math.Clamp(Weapon:Clip1() - WepMag1, 0, 2147483647)
	OverAltCapacity = math.Clamp(Weapon:Clip2() - WepMag2, 0, 2147483647)
	if Weapon:GetSecondaryAmmoType() != -1 then
		HasAltFire = true
	else
		HasAltFire = false
	end
	MagFillRatio = WepClip1 / WepMag1
	AltFillRatio = WepClip2 / WepMag2
	OverfillRatio = math.Clamp(Weapon:Clip1() - WepClip1, 0, 2147483647) / WepClip1
	AltOverfillRatio = math.Clamp(Weapon:Clip2() - WepClip2, 0, 2147483647) / WepClip2

	-- Bottomless clip detection. Same as infinite ammo detection.
	if Weapon.ARC9 and Weapon:GetProcessedValue("BottomlessClip", true) then
		BottomlessMag = true
		InstantAltfire = true
	elseif Weapon.ArcCW and GetConVar("arccw_mult_bottomlessclip"):GetBool() then
		BottomlessMag = true
		InstantAltfire = false
		-- For some inexplicable reason altfire for ArcCW is NOT affected by its bottomless clip CVar.
	elseif !Weapon.ARC9 and !Weapon.ArcCW and Weapon:GetMaxClip1() == -1 then
		BottomlessMag = true
	else
		BottomlessMag = false
	end

    WeaponJammed = false
    if Weapon.ARC9 then
        if Weapon:GetJammed() then
			WeaponJammed = true
		end
    elseif Weapon.ArcCW then
        if Weapon:GetMalfunctionJam() then
			WeaponJammed = true
		end
    end
end

hook.Add("PostDrawHUD", "mwiihuddraw", function()
    if gui.IsGameUIVisible() then return end

    if (dispw / disph) < (16 / 10) then return end
    -- MWII does not support resolutions less wide than 16:10

    PKAD2_GetWeaponData()
    if !LocalPlayer():Alive() then return end
    if IsValid(Weapon) then
        local clipcolor = nil
        local reservecolor = nil

        if Weapon:GetPrimaryAmmoType() != -1 then
            if BottomlessMag then
                draw.DrawText(WepReserve1 + math.Clamp(WepClip1, 0, 9999), "mw2iitextnormal", dispw - 210 * scale, disph - 145 * scale, blackcolor, TEXT_ALIGN_RIGHT)
                draw.DrawText(WepReserve1 + math.Clamp(WepClip1, 0, 9999), "mw2iitextnormal", dispw - 210 * scale, disph - 145 * scale, blackcolor, TEXT_ALIGN_RIGHT)
                draw.DrawText(WepReserve1 + math.Clamp(WepClip1, 0, 9999), "mwiitextnormal", dispw - 210 * scale, disph - 145 * scale, whitecolor, TEXT_ALIGN_RIGHT)
            else
                if WepClip1 < (WepMag1 / 3) then
                    clipcolor = redcolor
                else
                    clipcolor = whitecolor
                end

                if WepReserve1 == 0 then
                    reservecolor = redcolor
                else
                    reservecolor = graycolor
                end

                draw.DrawText(WepClip1, "mw2iitextnormal", dispw - 210 * scale, disph - 145 * scale, blackcolor, TEXT_ALIGN_RIGHT)
                draw.DrawText(WepClip1, "mw2iitextnormal", dispw - 210 * scale, disph - 145 * scale, blackcolor, TEXT_ALIGN_RIGHT)
                draw.DrawText(WepReserve1, "mw2iitextsmoler", dispw - 210 * scale, disph - 100 * scale, blackcolor, TEXT_ALIGN_RIGHT)
                draw.DrawText(WepReserve1, "mw2iitextsmoler", dispw - 210 * scale, disph - 100 * scale, blackcolor, TEXT_ALIGN_RIGHT)
                draw.DrawText(WepClip1, "mwiitextnormal", dispw - 210 * scale, disph - 145 * scale, clipcolor, TEXT_ALIGN_RIGHT)
                draw.DrawText(WepReserve1, "mwiitextsmoler", dispw - 210 * scale, disph - 100 * scale, reservecolor, TEXT_ALIGN_RIGHT)

                local reloadw, reloadh = 4 * scale + surface.GetTextSize(string.upper(" " .. input.LookupBinding("+reload") .. " " .. "   RELOAD"))
                local reloadbutw, reloadbuth = 4 * scale + surface.GetTextSize(string.upper(" " .. input.LookupBinding("+reload")))

                if WepClip1 < (WepMag1 / 3) and WepClip1 != 0 and !WeaponJammed then
                    if WepReserve1 > 0 then
                        draw.WordBox(2 * scale, dispw * 0.5 - (reloadw / 2), disph * 0.6, string.upper(" " .. input.LookupBinding("+reload") .. " "), "mwiireloadtext", whitecolor, Color(0,0,0), TEXT_ALIGN_LEFT)
                        draw.DrawText("   RELOAD", "mw2iitextsmoler", dispw * 0.5 - (reloadw / 2) + reloadbutw, disph * 0.6, blackcolor, TEXT_ALIGN_LEFT)
                        draw.DrawText("   RELOAD", "mw2iitextsmoler", dispw * 0.5 - (reloadw / 2) + reloadbutw, disph * 0.6, blackcolor, TEXT_ALIGN_LEFT)
                        draw.DrawText("   RELOAD", "mwiithicksmalltext", dispw * 0.5 - (reloadw / 2) + reloadbutw, disph * 0.6, whitecolor, TEXT_ALIGN_LEFT)
                    else
                        draw.DrawText("LOW AMMO", "mw2iitextsmoler", dispw * 0.5, disph * 0.58, blackcolor, TEXT_ALIGN_CENTER)
                        draw.DrawText("LOW AMMO", "mw2iitextsmoler", dispw * 0.5, disph * 0.58, blackcolor, TEXT_ALIGN_CENTER)
                        draw.DrawText("LOW AMMO", "mwiithicksmalltext", dispw * 0.5, disph * 0.58, yellowcolor, TEXT_ALIGN_CENTER)
                    end
                elseif WepClip1 == 0 and !WeaponJammed then
                    if WepReserve1 > 0 then
                        draw.WordBox(2 * scale, dispw * 0.5 - (reloadw / 2), disph * 0.6, string.upper(" " .. input.LookupBinding("+reload") .. " "), "mwiireloadtext", whitecolor, Color(0,0,0), TEXT_ALIGN_LEFT)
                        draw.DrawText("   RELOAD", "mw2iitextsmoler", dispw * 0.5 - (reloadw / 2) + reloadbutw, disph * 0.6, blackcolor, TEXT_ALIGN_LEFT)
                        draw.DrawText("   RELOAD", "mw2iitextsmoler", dispw * 0.5 - (reloadw / 2) + reloadbutw, disph * 0.6, blackcolor, TEXT_ALIGN_LEFT)
                        draw.DrawText("   RELOAD", "mwiithicksmalltext", dispw * 0.5 - (reloadw / 2) + reloadbutw, disph * 0.6, whitecolor, TEXT_ALIGN_LEFT)
                    else
                        draw.DrawText("NO AMMO", "mw2iitextsmoler", dispw * 0.5, disph * 0.58, blackcolor, TEXT_ALIGN_CENTER)
                        draw.DrawText("NO AMMO", "mwiithicksmalltext", dispw * 0.5, disph * 0.58, redcolor, TEXT_ALIGN_CENTER)
                    end
                end

                if WeaponJammed then
                    local jamw, jamh = 4 * scale + surface.GetTextSize(string.upper(" " .. input.LookupBinding("+reload") .. " " .. "    UNJAM WEAPON"))
                    draw.WordBox(2 * scale, dispw * 0.5 - (jamw / 2), disph * 0.6, string.upper(" " .. input.LookupBinding("+reload") .. " "), "mwiireloadtext", redcolor, Color(0,0,0), TEXT_ALIGN_LEFT)
                    draw.DrawText("    UNJAM WEAPON", "mw2iitextsmoler", dispw * 0.5 - (jamw / 2) + reloadbutw, disph * 0.6, blackcolor, TEXT_ALIGN_LEFT)
                    draw.DrawText("    UNJAM WEAPON", "mw2iitextsmoler", dispw * 0.5 - (jamw / 2) + reloadbutw, disph * 0.6, blackcolor, TEXT_ALIGN_LEFT)
                    draw.DrawText("    UNJAM WEAPON", "mwiithicksmalltext", dispw * 0.5 - (jamw / 2) + reloadbutw, disph * 0.6, redcolor, TEXT_ALIGN_LEFT)
                end
            end
        end
        mwhuddrawgunicon(Weapon, dispw - 590 * scale, disph - 190 * scale, 280 * scale, 140 * scale)
    end

    draw.DrawText(ply:GetAmmoCount(10), "mw2iitextsmoler", dispw - 70 * scale, disph - 90 * scale, blackcolor, TEXT_ALIGN_CENTER)
    draw.DrawText(ply:GetAmmoCount(10), "mw2iitextsmoler", dispw - 70 * scale, disph - 90 * scale, blackcolor, TEXT_ALIGN_CENTER)
    draw.DrawText(ply:GetAmmoCount(10), "mwiinadetext", dispw - 70 * scale, disph - 90 * scale, whitecolor, TEXT_ALIGN_CENTER)
    draw.SimpleText("k","hl2nadeicon",dispw - 70 * scale,disph - 125 * scale,headerTextColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)

    surface.SetDrawColor(53,53,53,148)
    surface.DrawRect(0 + 71 * scale, disph - 85 * scale, 100 * scale, 16 * scale)
    surface.SetDrawColor(74,125,253)
    surface.DrawRect(0 + 74 * scale, disph - 82 * scale, 94 * scale * math.Clamp(math.Remap(LocalPlayer():Armor(), 0, LocalPlayer():GetMaxArmor() / 3, 0, 1), 0, 1), 10 * scale)
    surface.SetDrawColor(53,53,53,148)
    surface.DrawRect(0 + 71 * scale + 105 * scale, disph - 85 * scale, 100 * scale, 16 * scale)
    surface.SetDrawColor(74,125,253)
    surface.DrawRect(0 + 74 * scale + 105 * scale, disph - 82 * scale, 94 * scale * math.Clamp(math.Remap(LocalPlayer():Armor(), LocalPlayer():GetMaxArmor() / 3, LocalPlayer():GetMaxArmor() / 3 * 2, 0, 1), 0, 1), 10 * scale)
    surface.SetDrawColor(53,53,53,148)
    surface.DrawRect(0 + 71 * scale + 210 * scale, disph - 85 * scale, 100 * scale, 16 * scale)
    surface.SetDrawColor(74,125,253)
    surface.DrawRect(0 + 74 * scale + 210 * scale, disph - 82 * scale, 94 * scale * math.Clamp(math.Remap(LocalPlayer():Armor(), LocalPlayer():GetMaxArmor() / 3 * 2, LocalPlayer():GetMaxArmor(), 0, 1), 0, 1), 10 * scale)
    surface.SetDrawColor(whitecolor)
    surface.DrawRect(0 + 74, disph - 65, 304 * scale * math.Remap(LocalPlayer():Health(), 0, 100, 0, 1), 10 * scale)

    surface.SetMaterial(platemat)
    surface.DrawTexturedRect(390 * scale, disph - 125 * scale, 70 * scale, 63 * scale)

    draw.DrawText(LocalPlayer():Nick(), "mwiinickblur", 0 + 71 * scale, disph - 115 * scale, blackcolor, TEXT_ALIGN_LEFT)
    draw.DrawText(LocalPlayer():Nick(), "mwiinicktext", 0 + 71 * scale, disph - 115 * scale, whitecolor, TEXT_ALIGN_LEFT)

    GetCurrentWeaponFiremode()
end)