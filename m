Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab2J2GQa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 02:16:30 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45145 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756370Ab2J2GQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 02:16:27 -0400
Date: Mon, 29 Oct 2012 08:10:26 +0200
From: Felipe Balbi <balbi@ti.com>
To: kishon <kishon@ti.com>
CC: <balbi@ti.com>, Tony Lindgren <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <b-cousson@ti.com>, <arnd@arndb.de>, <olof@lixom.net>,
        <rdunlap@xenotime.net>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] drivers: bus: ocp2scp: add pdata support
Message-ID: <20121029061026.GO17570@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1349675983-23803-1-git-send-email-kishon@ti.com>
 <1349675983-23803-2-git-send-email-kishon@ti.com>
 <20121016165043.GS15569@atomide.com>
 <20121025004806.GK11928@atomide.com>
 <20121025061722.GB4449@arwen.pp.htv.fi>
 <20121025174446.GT11928@atomide.com>
 <20121026064736.GA22206@arwen.pp.htv.fi>
 <20121026171655.GI11908@atomide.com>
 <20121026195915.GA29548@arwen.pp.htv.fi>
 <508BD344.1090001@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <508BD344.1090001@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Oct 27, 2012 at 05:57:48PM +0530, kishon wrote:
> Hi,
>=20
> On Saturday 27 October 2012 01:29 AM, Felipe Balbi wrote:
> >Hi,
> >
> >On Fri, Oct 26, 2012 at 10:16:55AM -0700, Tony Lindgren wrote:
> >>* Felipe Balbi <balbi@ti.com> [121025 23:55]:
> >>>On Thu, Oct 25, 2012 at 10:44:47AM -0700, Tony Lindgren wrote:
> >>>>* Felipe Balbi <balbi@ti.com> [121024 23:24]:
> >>>>>Hi,
> >>>>>
> >>>>>On Wed, Oct 24, 2012 at 05:48:07PM -0700, Tony Lindgren wrote:
> >>>>>>* Tony Lindgren <tony@atomide.com> [121016 09:53]:
> >>>>>>>* Kishon Vijay Abraham I <kishon@ti.com> [121007 23:01]:
> >>>>>>>>ocp2scp was not having pdata support which makes *musb* fail for =
non-dt
> >>>>>>>>boot in OMAP platform. The pdata will have information about the =
devices
> >>>>>>>>that is connected to ocp2scp. ocp2scp driver will now make use of=
 this
> >>>>>>>>information to create the devices that is attached to ocp2scp.
> >>>>>>>>
> >>>>>>>>Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> >>>>>>>
> >>>>>>>This fixes the regression on my panda es for musb port:
> >>>>>>>
> >>>>>>>Acked-by: Tony Lindgren <tony@atomide.com>
> >>>>>>
> >>>>>>Looks like nobody has picked this one up and we need it to
> >>>>>>fix the musb regression on omap, so I'll queue these up.
> >>>>>
> >>>>>I don't seem to have the patches around in any mailbox :-(
> >>>>
> >>>>Bounced them to you. Do you have any better ideas for the
> >>>>-rc cycle to fix the MUSB regression on omap4?
> >>>
> >>>Well, there are two regressions that I know of. One is caused by the
> >>>mode1 DMA changes, which I'll just revert, and the other is the
> >>>missing platform_data support on the new PHY driver which these patches
> >>>are supposed to solve, right ?
> >>
> >>Yes that's it AFAIK.
> >
> >Kishon, any other patches I need to take to get MUSB working on v3.7 ?
>=20
> These should be good enough to get MUSB working..

nothing needed for omap-usb2.c ? That's great, cheers

--=20
balbi

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQjh3SAAoJEIaOsuA1yqREZsUQAKG8UcbcHA8KiRuq6fT4qQ/h
yLHUbgg4rDn9rWQAhrWtg3C4Tcuylitg5gV7rxbE7O6Yi2ATfI3XHXDebpHFfnm5
bxQe/KLnpnvrxZw3z1cG2k140PaYaQR77yMsvmyFFmAx/c/GRJJII2haePEvVZsb
iMWmTVoyAu9eMuTqX8uaRHZ6lhTMhikBWqb0eZN9sow5UE96DOmyZoHpBsx92tCg
l069eAbMzKz0CKHpFQO7FECfYsIwAEPGtYpAhaVD2Ahn1MSozFjZQVEy6jfnJF9n
fuq53VsJ7eAMgLkK+Mchs7Fby1EFNKU2eOGaxVt63YTqm3RO19N8wgl/XGpKv5aI
hCcFV4jB/6ZnJDRYHg/HbrNOHldW44q4ATaVjVuzC0L2F2beVsazG2h6et8aZjnP
waYHJ70ZCKnNQMC5x2pMbs9HoMf/Q4uSaoysjBJ4Uz76HFQBNQFpubLY/bSHyQFV
2FsvHbeq8VGBBn1cmTQ52mviiokgTwowfKiu+S5UqGmdE7yKc0m4KOWcT6GmwcfU
E0GOBlqXtOoQy2O1vbBLvlvZsPDqHQii5WeTk5dW+CfQhG+G1PiXlGcBR0Ovt8vW
oU/2pp6JAqTI8OJWx2dvsfg2W8U30lXwTT8Ii2NS4TB9C7WOKp28fx6I6Hmj9T8p
UosOjnZ9Wy5w/lMtFpaD
=kD0w
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
