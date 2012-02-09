Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab2BIJIO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 04:08:14 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48326 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757450Ab2BIJIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 04:08:11 -0500
Message-ID: <4F338CF9.6050803@pengutronix.de>
Date: Thu, 09 Feb 2012 10:08:09 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: Marc Kleine-Budde <mkl@blackshift.org>, linux-kernel@vger.kernel.org,
        Imre Kaloz <kaloz@openwrt.org>, linux-arm-kernel@lists.infradead.org,
        Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH 1/2] ARM: ixp4xx: fix compilation, add gpiolib support
References: <1328729069-21308-1-git-send-email-mkl@blackshift.org> <1328729069-21308-2-git-send-email-mkl@blackshift.org> <20275.35898.120590.54388@pilspetsen.it.uu.se>
In-Reply-To: <20275.35898.120590.54388@pilspetsen.it.uu.se>
X-Enigmail-Version: 1.3.5
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3662311C5915943F343369AA"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3662311C5915943F343369AA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/09/2012 10:04 AM, Mikael Pettersson wrote:
> Marc Kleine-Budde writes:
>  > From: Imre Kaloz <kaloz@openwrt.org>
>  >=20
>  > The problem was introduced with commit:
>  > "eb9ae7f gpio: fix build error in include/asm-generic/gpio.h"
>  >=20
>  > This patch adds gpiolib support for the IXP4xx platform, which fixes=
 the
>  > compilation of several ixp4xx platforms, e.g.:
>  >=20
>  > In file included from arch/arm/mach-ixp4xx/include/mach/gpio.h:72,
>  >                  from /home/frogger/projects/server/linux/arch/arm/i=
nclude/asm/gpio.h:9,
>  >                  from include/linux/gpio.h:30,
>  >                  from arch/arm/mach-ixp4xx/nslu2-setup.c:19:
>  > include/asm-generic/gpio.h: In function 'gpio_get_value_cansleep':
>  > include/asm-generic/gpio.h:218: error: implicit declaration of funct=
ion '__gpio_get_value'
>  > include/asm-generic/gpio.h: In function 'gpio_set_value_cansleep':
>  > include/asm-generic/gpio.h:224: error: implicit declaration of funct=
ion '__gpio_set_value'
>=20
> This fix is needed for 3.2 too, right?  I got the same errors when
> updating my (out-of-tree) ixp4xx/ds101 platform support to the 3.2 kern=
el
> a few days ago.

Yes, it's needed for 3.2, too. I'll put stable on Cc.

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--------------enig3662311C5915943F343369AA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk8zjPkACgkQjTAFq1RaXHPs4wCgjnAtDK51TREYNsVCLwLs/Rv5
lUUAnAkpFlCtvXfWGK634n6h7UTiXlDj
=TsOz
-----END PGP SIGNATURE-----

--------------enig3662311C5915943F343369AA--
