Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2DQTnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 15:43:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52584 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752357Ab2DQTns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 15:43:48 -0400
Date: Tue, 17 Apr 2012 20:43:43 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Ondrej Zary <linux@rainbow-software.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 3/4] Add Wolfson Microelectronics WM8776
 codec ALSA driver
Message-ID: <20120417194341.GX6652@opensource.wolfsonmicro.com>
References: <1334611118-10301-1-git-send-email-linux@rainbow-software.org>
 <20120417170431.GT6652@opensource.wolfsonmicro.com>
 <s5h3982p71g.wl%tiwai@suse.de>
 <201204172015.14582.linux@rainbow-software.org>
 <20120417182204.GV6652@opensource.wolfsonmicro.com>
 <s5hwr5enpau.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y48FV0AvvvAm5Iyr"
Content-Disposition: inline
In-Reply-To: <s5hwr5enpau.wl%tiwai@suse.de>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y48FV0AvvvAm5Iyr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 17, 2012 at 09:14:49PM +0200, Takashi Iwai wrote:
> Mark Brown wrote:

> > Can we make a sound/legacy-codec or something?  Or fix these drivers if
> > they're actively developed...

> sound/i2c are obvious components for such drivers.
> You don't have to react against each rare action.  There aren't so
> many hardware any longer, and will be less and less in future.

That's the case in the PC world but obviously this is exactly how
essentially all embedded systems are built up.  It needs to be very
clear that this is just legacy code for these old PC sound cards and
nothing else, nothing about either the directory naming or the changelog
here suggests that this is anything other than the standard way to add
support for new CODECs to ALSA.

We usually have to go through a loop of "you need to use the frameworks"
with new vendors, we need to make the process of figuring out what they
should do as simple as we can.

--Y48FV0AvvvAm5Iyr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPjce+AAoJEBus8iNuMP3dEyUP/AhQQp6ie8bms7UAHYBtMjgC
0J5y4pfXN03/s3VJfESWB+InzZajSlPnar7cntXuYzXcUM5JZWhJgjRwHxvqcyFE
turJ+n07rANlaxp+cSz1/vxKkAyxHWQ7V2mhxWzjToFAOrdl8B81dpozmCMHANSk
EBHUHcF5iEJBdVyqRnRfDfjd3cjI//LKD4eA4l4beSTdDhPFCsa/Z63YHeT9H58D
OdksIutoRiOD1yB69z5No69wIQAXvKNecijuv+HqbgIvdTRaPAe7X+LLbK8XItCn
b0LTShl+KPdtjHkHNgeYQxyVt+h1dFhIa0A+cDELIq02OS4GMFmVYf++WM7Mb9QL
te+r2g5HOUJ5iINEzTl3taBnddbQLOhHzDunpAGQ0q6yPaPKsgMWJhxpi4M/FVF5
l+V8zBRfj0E+hHiPiCiF3SrtWy7bRoxE9Y98tECLcS0F5A2HRhCDXBH0KA2We5en
M53umVag3w4ezzSxGqcME1L2bS7Cp2qB8FkkdwOFITfAzHqhFnCJEzBonQU8njJD
oM8NfMC8rYXqaovSwIogQ9H/JrsX+7XUfaVOYBVGyaDZkd4SZHuqMVk5dTSpwcIr
4SxQ/OWtUE1Hr1QYPGkHKjTsMHyF2EDbTmrc4SnIAsA9olQXehhDT4ffRut+wcXI
aU+c9DxDniNGlsgKr42S
=uvH4
-----END PGP SIGNATURE-----

--Y48FV0AvvvAm5Iyr--
