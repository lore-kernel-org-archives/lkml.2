Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab2CTEjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 00:39:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58775 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab2CTEjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 00:39:22 -0400
Date: Tue, 20 Mar 2012 15:39:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arun Murthy <arun.murthy@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: linux-next: build failure after merge of the battery tree
Message-Id: <20120320153912.b97107ca4128d0692de17799@canb.auug.org.au>
In-Reply-To: <20120315135609.2f9a2a030866c476dc736b9c@canb.auug.org.au>
References: <20120315135609.2f9a2a030866c476dc736b9c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__20_Mar_2012_15_39_12_+1100_kksWIIHFcyV6yQvQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__20_Mar_2012_15_39_12_+1100_kksWIIHFcyV6yQvQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Anton,

On Thu, 15 Mar 2012 13:56:09 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the battery tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> drivers/power/ab8500_btemp.c: In function 'ab8500_btemp_batctrl_volt_to_r=
es':
> drivers/power/ab8500_btemp.c:142:2: error: implicit declaration of functi=
on 'is_ab8500_1p1_or_earlier' [-Werror=3Dimplicit-function-declaration]
> drivers/power/ab8500_btemp.c: In function 'ab8500_btemp_templow_handler':
> drivers/power/ab8500_btemp.c:619:2: error: implicit declaration of functi=
on 'is_ab8500_2p0_or_earlier' [-Werror=3Dimplicit-function-declaration]
> drivers/power/ab8500_charger.c: In function 'ab8500_charger_ac_en':
> drivers/power/ab8500_charger.c:1126:3: error: implicit declaration of fun=
ction 'is_ab8500_1p1_or_earlier' [-Werror=3Dimplicit-function-declaration]
> drivers/power/ab8500_charger.c: In function 'ab8500_charger_remove':
> drivers/power/ab8500_charger.c:2519:2: error: implicit declaration of fun=
ction 'usb_unregister_notifier' [-Werror=3Dimplicit-function-declaration]
> drivers/power/ab8500_charger.c:2520:2: error: implicit declaration of fun=
ction 'usb_put_transceiver' [-Werror=3Dimplicit-function-declaration]
> drivers/power/ab8500_charger.c: In function 'ab8500_charger_probe':
> drivers/power/ab8500_charger.c:2688:2: error: implicit declaration of fun=
ction 'usb_get_transceiver' [-Werror=3Dimplicit-function-declaration]
> drivers/power/ab8500_charger.c:2688:14: warning: assignment makes pointer=
 from integer without a cast [enabled by default]
> drivers/power/ab8500_charger.c:2695:2: error: implicit declaration of fun=
ction 'usb_register_notifier' [-Werror=3Dimplicit-function-declaration]
>=20
> Caused by commits 89449ac8d6d2 ("ab8500-charger: AB8500 charger driver")
> and 20ac1aed6206 ("ab8500-btemp: AB8500 battery temperature driver").
>=20
> I have used the battery tree form next-20120314 for today.

Still getting this build failure.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__20_Mar_2012_15_39_12_+1100_kksWIIHFcyV6yQvQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPaAnwAAoJEECxmPOUX5FEThIQAI9ztS5zF5+X8wbFmPrWhxH+
PrkLINLxe3YmGF5JAfD2jz5vxVqT8pg+FC8f1UypexM79aB4B3R+4gAqYWKzii8x
pckXJ19/cRY9uuUvmsXaeQl9N1PVciJSSJzWvUYE3k4+jn9ldFACM1H/1nTZPHj8
P2ZDGV/MZ936nAr/Jg3T3uznCcuScuqC/Jhw9Rgj+Y1oX3S537NMIPGJOpT8jUlk
2OF9ka2YycyrUv2L1e7qSpQIVS8uawVWneiaeVdUC2Qi0UmPgax7B3d/ENLWW51c
CArpU1wcyxBZ3w+D0ZMLqT2QaFtICyX+1h5O5LIPpJy/eroviLMHdRl4f2LP36Df
ZSYyGTXs3bH12Mz38FCitqxODzKHqgWRqyFvFEwBHdE7DusU9uPsg9P07SkmAMPe
7gFiCr63TsRbzcYjV4fI1RzgmEJEpedYGQqPdRbpWaVCwX0DA0IseBnEfin5lPDy
NBuGKFak6ffkPFlr3BCWGicDhcjjA8LEhojcxJgW95ceiSPXgLzifFV1kW1sHGdE
+13nKqXkE8Ka6kodQmWqBU9zxB2JCU6zefVjYudqiBgvQcNRw4cPXR7z6yWw9HzQ
Hq1HQyaK8d+zWjKdG9+vo1ORkfNrjf9i/SH3dfCcHsQvDzW6EcGyTw0oOXpw/M+l
HBqV+PoeYu+guwaR5P9i
=L1er
-----END PGP SIGNATURE-----

--Signature=_Tue__20_Mar_2012_15_39_12_+1100_kksWIIHFcyV6yQvQ--
