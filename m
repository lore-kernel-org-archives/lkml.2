Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab1LMWxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 17:53:17 -0500
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:46975 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752914Ab1LMWxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 17:53:14 -0500
Date: Wed, 14 Dec 2011 00:53:09 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        Kalle Jokiniemi <kalle.jokiniemi@nokia.com>,
        Heikki Krogerus <heikki.krogerus@nokia.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH 2/2] Revert "ARM: RX-51: Enable isp1704 power on/off"
Message-ID: <20111213225308.GB10066@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1323105820-25946-1-git-send-email-felipe.contreras@nokia.com>
 <1323105820-25946-3-git-send-email-felipe.contreras@nokia.com>
 <CAMP44s3Szzm9iXxghXfNCBjKyUw-nRrG1aEeweKnRCidaxmxEA@mail.gmail.com>
 <4EDF5231.6080309@bitmer.com>
 <CAMP44s0a6hcORZn8wDxHUJKxs=wjAmkhRfiT9kEA_MoDYeAmfg@mail.gmail.com>
 <4EE5A8A0.2010206@bitmer.com>
 <CAMP44s1Zz7CqxRM6PeNT3GN9GbCLy+0smgk6_-9kSjghY33Xuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H1spWtNR+x+ondvy"
Content-Disposition: inline
In-Reply-To: <CAMP44s1Zz7CqxRM6PeNT3GN9GbCLy+0smgk6_-9kSjghY33Xuw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H1spWtNR+x+ondvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 13, 2011 at 11:19:52PM +0200, Felipe Contreras wrote:
> On Mon, Dec 12, 2011 at 9:09 AM, Jarkko Nikula <jarkko.nikula@bitmer.com>=
 wrote:
> > Indeed yes. I checked that in 3.0 it still works but not in 3.1 so some
> > non isp1704_charger change has broke it as there hasn't been changes on=
 it.
>=20
> Actually it's broken in 3.0 as well, try this configuration:
>=20
> 	# CONFIG_USB_MUSB_HOST is not set
> 	# CONFIG_USB_MUSB_PERIPHERAL is not set
> 	CONFIG_USB_MUSB_OTG=3Dy
> 	CONFIG_USB_GADGET_MUSB_HDRC=3Dy
> 	CONFIG_USB_MUSB_HDRC_HCD=3Dy
>=20
> 	CONFIG_USB_GADGET_SELECTED=3Dy
> 	# CONFIG_USB_GADGET_FUSB300 is not set
> 	# CONFIG_USB_GADGET_OMAP is not set
> 	# CONFIG_USB_GADGET_R8A66597 is not set
> 	# CONFIG_USB_GADGET_PXA_U2O is not set
> 	# CONFIG_USB_GADGET_M66592 is not set
> 	# CONFIG_USB_GADGET_DUMMY_HCD is not set
>=20
> I will try to find where the issues started to happen, but it's a bit
> difficult because all this USB Kconfig stuff is completely messed up.
>=20
> *Sigh*

patches are welcome

--=20
balbi

--H1spWtNR+x+ondvy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO59dTAAoJEIaOsuA1yqRE6OYP/AtCVZRkl+YDL49ZiyLuDU/C
IeIzsbkmRuBoL37/xx2FEW4IKd8ecl2ko3kjvNQOzQ0cQUCWLCD42AyKZSIi7xV8
yaY/By+XF7//dStib6JkNwAQkFUkvf3HKvrgKGpAgbtnwaDAPfhmDjNXu0oRwmc+
RSRrVekJWn9JDYVPu2j8Vu1tiZ8szMd2fcvfVqTwYtCMHPI9jYg8MmQ/jR4Kva3R
S6P4h/n4FQQ6z6S7SNF/eK9APhNXMgG1RmddnmPXUUPda6TMWikVaH0hOxY4DzAU
x+Fzdv5s06p97jQITzadHzeBCUXbrZDbDnJqx358eJLfpMStZHfvqvaztki44nMS
ycjwNBVqX69UTCuiUTf2jOp4+2xAAheQBCVlaGVSrhQ+NzKviPDsTeO4zloDWgEP
v8PB9ZNLdj3xOeQI6bq+cIw86qmniSiA8sZgZ2QpcO4NtvAhBfG/WjoalDbTK64m
RZTokaSUpiebdlHczhtTu+F2kXIpv6DtZ0CqycPLDIJuCRNTdic1qsnIemLd7ttz
HGoa/MQ8AVd/28UARN3LybZSrA/ahhBKG1szKvJrOVyuWaWiGwnX0OxiA76tGyJ6
qEAdI70ZfxXMKS0f6dOpDWtgQXC35bGHOff+DXiLqqR5r0ohLyf6s4ybIdbrCI3o
g+Afzh//GSec/fy8x2VP
=uyu1
-----END PGP SIGNATURE-----

--H1spWtNR+x+ondvy--
