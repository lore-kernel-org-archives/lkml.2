Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786Ab2CZCNd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 22:13:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54641 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995Ab2CZCNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 22:13:31 -0400
Date: Mon, 26 Mar 2012 13:13:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arun Murthy <arun.murthy@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: linux-next: build failure after merge of the battery tree
Message-Id: <20120326131316.b791ebefd94d8cbcac5bccfa@canb.auug.org.au>
In-Reply-To: <20120320153912.b97107ca4128d0692de17799@canb.auug.org.au>
References: <20120315135609.2f9a2a030866c476dc736b9c@canb.auug.org.au>
	<20120320153912.b97107ca4128d0692de17799@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Mar_2012_13_13_16_+1100_pljozaNH=EjXs5E8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Mar_2012_13_13_16_+1100_pljozaNH=EjXs5E8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Anton,

On Tue, 20 Mar 2012 15:39:12 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Thu, 15 Mar 2012 13:56:09 +1100 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > After merging the battery tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >=20
> > drivers/power/ab8500_btemp.c: In function 'ab8500_btemp_batctrl_volt_to=
_res':
> > drivers/power/ab8500_btemp.c:142:2: error: implicit declaration of func=
tion 'is_ab8500_1p1_or_earlier' [-Werror=3Dimplicit-function-declaration]
> > drivers/power/ab8500_btemp.c: In function 'ab8500_btemp_templow_handler=
':
> > drivers/power/ab8500_btemp.c:619:2: error: implicit declaration of func=
tion 'is_ab8500_2p0_or_earlier' [-Werror=3Dimplicit-function-declaration]
> > drivers/power/ab8500_charger.c: In function 'ab8500_charger_ac_en':
> > drivers/power/ab8500_charger.c:1126:3: error: implicit declaration of f=
unction 'is_ab8500_1p1_or_earlier' [-Werror=3Dimplicit-function-declaration]
> > drivers/power/ab8500_charger.c: In function 'ab8500_charger_remove':
> > drivers/power/ab8500_charger.c:2519:2: error: implicit declaration of f=
unction 'usb_unregister_notifier' [-Werror=3Dimplicit-function-declaration]
> > drivers/power/ab8500_charger.c:2520:2: error: implicit declaration of f=
unction 'usb_put_transceiver' [-Werror=3Dimplicit-function-declaration]
> > drivers/power/ab8500_charger.c: In function 'ab8500_charger_probe':
> > drivers/power/ab8500_charger.c:2688:2: error: implicit declaration of f=
unction 'usb_get_transceiver' [-Werror=3Dimplicit-function-declaration]
> > drivers/power/ab8500_charger.c:2688:14: warning: assignment makes point=
er from integer without a cast [enabled by default]
> > drivers/power/ab8500_charger.c:2695:2: error: implicit declaration of f=
unction 'usb_register_notifier' [-Werror=3Dimplicit-function-declaration]
> >=20
> > Caused by commits 89449ac8d6d2 ("ab8500-charger: AB8500 charger driver")
> > and 20ac1aed6206 ("ab8500-btemp: AB8500 battery temperature driver").
> >=20
> > I have used the battery tree form next-20120314 for today.
>=20
> Still getting this build failure.

Ping?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__26_Mar_2012_13_13_16_+1100_pljozaNH=EjXs5E8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPb9C8AAoJEECxmPOUX5FE3zwP/15EbuOCK4ypBBmIRkCtibth
YlMhKA+B1m1Oq4Y0UPhBA8yz1GYIGHxsmsyWmxTAiVdHje2PSAv5UJH2acG4+I7T
MKtqdI8CPUaWhf4IqitCkjURyrD/D/h01B/B0It70P1GhFtgjfzoduPYVh1hCgEj
lYo0Eh9f4zkqRJGKm0Wza4l7H2Y9zOq1VP7vof+ZhFdkkr8dfka1yCUkWeIVpHAz
sSjvFAyHG1V/KiDVEGXldbsPXT30lRArS/Urz391YYZpGwnQWdHw1hXO/Yn1hEjU
Z9+SmOoNj2YmA+nFCgMAbjcC1YfBdevuTYIVvwY9epdekOUsa/3Qd8yaIxZATB4F
d8WzXDZxeI65/bXksNWJnzBQajqY9u4NcFZAHmk/dYCtjHBfuYBTVIvGK3y0TNVT
AZuj5l/C2Dcc7ySixc8XjigckzYmUixFF/8C8XU+nOP7IyhDdG45XkTq27FSZ+G6
Nty1etVeP9alUO62H2JmOgIN3V19/WRMOprE3AX+5pny4G5MRWUzvoHosIdcRRii
eg/zWQFp7jV3veaIxCtpS+NztW3mR3D0zor7ixEj+1WLfmW2mi1Vm9BP7ahS6h0m
RJq//QPV1XKpaSAtB9dhxTMcaeGsMEJTuD/0IAHJ1P3erfrb7DprRw2oGoxFaXE/
qhkHNEKaY/YhcRnOfBl6
=brVt
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Mar_2012_13_13_16_+1100_pljozaNH=EjXs5E8--
