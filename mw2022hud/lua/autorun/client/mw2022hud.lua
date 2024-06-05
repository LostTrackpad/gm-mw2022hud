include("mwhud-tfabasekeys.lua")

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

local MWBaseFiremodes = {
    ["AUTOMATIC"] = "Full-Auto",
	["FULL AUTO"] = "Full-Auto",
	["SEMI AUTO"] = "Semi-Auto",
	["SEMI AUTOMATIC"] = "Semi-Auto",
	["3RND BURST"] = "3-Burst"
}

local TFAFiremodes = {
    ["Full-Auto"] = "Full-Auto",
	["Semi-Auto"] = "Semi-Auto",
	["3 Round Burst"] = "3-Burst"
}

local VanillaAutomatics = {
	["weapon_smg1"] = true,
	["weapon_ar2"] = true,
	["weapon_mp5_hl1"] = true,
	["weapon_gauss"] = true,
	["weapon_egon"] = true
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
local FiremodeText = "Full-Auto"
local AltFiremodeText = "Altfire"
local ActivePrimaryFire = true
local InstantAltfire = false
local BottomlessMag = false

local redcolor = Color(255,65,65)

local yellowcolor = Color(255,255,0)

local whitecolor = Color(255,255,255)

local graycolor = Color(165,165,165)

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

surface.CreateFont("mw2iitextnormal", {
    shadow = false,
    blursize = 1 * scale,
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

surface.CreateFont("mw2iitextsmoler", {
    shadow = false,
    blursize = 1 * scale,
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
    outline = true,
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
        outline = true,
        symbol = false,
        weight = 5000,
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
        outline = true,
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
end

hook.Add("HUDPaint", "mwiihuddraw", function()
    if (dispw / disph) < (16 / 10) then return end
    local reloadw, reloadh = 4 * scale + surface.GetTextSize(string.upper(" " .. input.LookupBinding("+reload") .. " " .. "   RELOAD"))
    local reloadbutw, reloadbuth = 4 * scale + surface.GetTextSize(string.upper(" " .. input.LookupBinding("+reload")))
    -- MWII does not support resolutions less wide than 16:10

    PKAD2_GetWeaponData()
    if !IsValid(Weapon) then return end

    if Weapon:GetPrimaryAmmoType() != -1 then
        if BottomlessMag then
            draw.DrawText(WepReserve1 + math.Clamp(WepClip1, 0, 9999), "mw2iitextnormal", dispw - 210 * scale, disph - 145 * scale, blackcolor, TEXT_ALIGN_RIGHT)
            draw.DrawText(WepReserve1 + math.Clamp(WepClip1, 0, 9999), "mwiitextnormal", dispw - 210 * scale, disph - 145 * scale, whitecolor, TEXT_ALIGN_RIGHT)
        else
            draw.DrawText(WepClip1, "mw2iitextnormal", dispw - 210 * scale, disph - 145 * scale, blackcolor, TEXT_ALIGN_RIGHT)
            draw.DrawText(WepReserve1, "mw2iitextsmoler", dispw - 210 * scale, disph - 100 * scale, blackcolor, TEXT_ALIGN_RIGHT)
            draw.DrawText(WepClip1, "mwiitextnormal", dispw - 210 * scale, disph - 145 * scale, whitecolor, TEXT_ALIGN_RIGHT)
            draw.DrawText(WepReserve1, "mwiitextsmoler", dispw - 210 * scale, disph - 100 * scale, graycolor, TEXT_ALIGN_RIGHT)

            if WepClip1 < (WepMag1 / 3) and WepClip1 != 0 then
                if WepReserve1 > 0 then
                    draw.WordBox(2 * scale, dispw * 0.5 - (reloadw / 2), disph * 0.6, string.upper(" " .. input.LookupBinding("+reload") .. " "), "mwiireloadtext", whitecolor, Color(0,0,0), TEXT_ALIGN_LEFT)
                    draw.DrawText("   RELOAD", "mw2iitextsmoler", dispw * 0.5 - (reloadw / 2) + reloadbutw, disph * 0.6, blackcolor, TEXT_ALIGN_LEFT)
                    draw.DrawText("   RELOAD", "mwiithicksmalltext", dispw * 0.5 - (reloadw / 2) + reloadbutw, disph * 0.6, whitecolor, TEXT_ALIGN_LEFT)
                else
                    draw.DrawText("LOW AMMO", "mw2iitextsmoler", dispw * 0.5, disph * 0.58, blackcolor, TEXT_ALIGN_CENTER)
                    draw.DrawText("LOW AMMO", "mwiithicksmalltext", dispw * 0.5, disph * 0.58, yellowcolor, TEXT_ALIGN_CENTER)
                end
            elseif WepClip1 == 0 then
                if WepReserve1 > 0 then
                    draw.WordBox(2 * scale, dispw * 0.5 - (reloadw / 2), disph * 0.6, string.upper(" " .. input.LookupBinding("+reload") .. " "), "mwiireloadtext", whitecolor, Color(0,0,0), TEXT_ALIGN_LEFT)
                    draw.DrawText("   RELOAD", "mw2iitextsmoler", dispw * 0.5 - (reloadw / 2) + reloadbutw, disph * 0.6, blackcolor, TEXT_ALIGN_LEFT)
                    draw.DrawText("   RELOAD", "mwiithicksmalltext", dispw * 0.5 - (reloadw / 2) + reloadbutw, disph * 0.6, whitecolor, TEXT_ALIGN_LEFT)
                else
                    draw.DrawText("NO AMMO", "mw2iitextsmoler", dispw * 0.5, disph * 0.58, blackcolor, TEXT_ALIGN_CENTER)
                    draw.DrawText("NO AMMO", "mwiithicksmalltext", dispw * 0.5, disph * 0.58, redcolor, TEXT_ALIGN_CENTER)
                end
            end
        end
    end
    mwhuddrawgunicon(Weapon, dispw - 590 * scale, disph - 190 * scale, 280 * scale, 140 * scale)

    draw.DrawText(ply:GetAmmoCount(10), "mwiinadetext", dispw - 70 * scale, disph - 90 * scale, whitecolor, TEXT_ALIGN_CENTER)
    draw.SimpleText("k","hl2nadeicon",dispw - 70 * scale,disph - 125 * scale,headerTextColor,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
end)