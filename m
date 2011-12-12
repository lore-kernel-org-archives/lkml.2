Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab1LLKq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 05:46:26 -0500
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:53516 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169Ab1LLKqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 05:46:22 -0500
Subject: Re: [PATCH 2/3] video: omap: convert drivers/video/omap/* to use
 module_platform_driver()
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jonathan McDowell <noodles@earth.li>,
        Cory Maccarrone <darkstar6262@gmail.com>,
        Laurent Gonzalez <palmte.linux@free.fr>,
        Marek Vasut <marek.vasut@gmail.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-omap@vger.kernel.org
In-Reply-To: <1323395996.3740.6.camel@phoenix>
References: <1323395873.3740.4.camel@phoenix>
	 <1323395996.3740.6.camel@phoenix>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/QLa9Q3qWruYqmM5KY9b"
Date: Mon, 12 Dec 2011 12:46:16 +0200
Message-ID: <1323686776.3852.13.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/QLa9Q3qWruYqmM5KY9b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2011-12-09 at 09:59 +0800, Axel Lin wrote:
> This patch converts the drivers in drivers/video/omap/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
>=20
> Cc: Jonathan McDowell <noodles@earth.li>
> Cc: Cory Maccarrone <darkstar6262@gmail.com>
> Cc: Laurent Gonzalez <palmte.linux@free.fr>
> Cc: Marek Vasut <marek.vasut@gmail.com>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Thanks, applied to DSS tree.

 Tomi


--=-/QLa9Q3qWruYqmM5KY9b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJO5dt4AAoJEPo9qoy8lh71RvYQAKizsrDkI7U4w17BBf4uYcmA
JBll+gSWM15GdXXf4p/XdIrriTdj9ft/wDS173a2fauiRth25cQKaWuKAOxCriTV
NAKz5wWvcEGJg1eV7pyOypE6pjPO3kc33dGDeXU2dEW4SNzY0KTtyqJ5rs4USKsV
ook/GYzgh6B2tD2pm6c2RQ3bukBk3jSiAuyMK6j+xGamkz/TSGdFCYrCMA6rFi/v
YADE0UbfvvT24klvmUV6ipyGA4BCYFzzQMv4gB5jq0XyOrfxHA089nNTMX5pcBzd
7/vDtLX+w9Yku4s2y6wPiSmoYQ8hB2QizAX35M9nLoAlbVPUx3ueHKI/WyTozIMQ
1KdLqvVkaaMMDECAyFhnNCSVP373oov55qxEZTM2t8HCpJWv3kCvb5lvBl5qevYu
1lzF5CJQ4rA6B//bvx7Lu7bu15zWIDO4IK9lPxNRYS47vCVp6abogP3zUXCWE9x/
pzCrzPepkmUdk4gIrOEF1vAxeEQ172BcMoeqACmyQph0yKTLd9+ZncmgKMbv5W8Y
9Ku1ht8NVc0Qtjt/LzeKKVAPx8IZFQ4dJgT8waA5ubS6KG+AAKikLPahR9BkWX7q
Ok18xV9Xs7FSceZcnbuoNvgdQ1vm6yM/m8nxEKiwqEmMOWJ57Fp3Pkzdrfgo/Ofk
SjtpdHNuMu82k1F+AsDS
=yvqC
-----END PGP SIGNATURE-----

--=-/QLa9Q3qWruYqmM5KY9b--

