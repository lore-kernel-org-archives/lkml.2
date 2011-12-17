Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab1LQJz0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 04:55:26 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54015 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab1LQJzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 04:55:20 -0500
From: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org,
        syed rafiuddin <rafiuddin.sayed@gmail.com>,
        Rodolfo Giometti <giometti@linux.it>,
        David Woodhouse <dwmw2@infradead.org>,
        Sebastian Reichel <sre@debian.org>
Subject: Re: [PATCH] rx51: add bq27200 i2c board info
Date: Sat, 17 Dec 2011 10:55:15 +0100
Message-ID: <7700705.IODZRCEMlU@pali-elitebook>
User-Agent: KMail/4.7.4 (Linux/3.2.0-4-generic; KDE/4.7.4; x86_64; ; )
In-Reply-To: <20111207202546.GJ31337@atomide.com>
References: <1316531933-7159-1-git-send-email-pali.rohar@gmail.com> <20111125230321.GA12373@oksana.dev.rtsoft.ru> <20111207202546.GJ31337@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1515633.gvPZuPyBuI"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: quoted-printable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1515633.gvPZuPyBuI
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"

On Wednesday 07 December 2011 12:25:47 you wrote:
> * Anton Vorontsov <cbouatmailru@gmail.com> [111125 14:28]:
> > Cc'ing Tony Lindgren.
> >=20
> > Tony, OK to pass this via battery git tree?
>=20
> Sorry for the delay, yes that's fine with me:
>=20
> Acked-by: Tony Lindgren <tony@atomide.com>

Anton Vorontsov, can you now include this patch into battery tree?

>=20
> > p.s. Though, not sure if we really should bother w/ these #ifs.
>=20
> Up to you, looks like they could be left out.

Now I see that these #ifs is not needed.

>=20
> > On Fri, Nov 25, 2011 at 11:53:06PM +0100, Pali Roh=E1r wrote:
> > > I forgot to send patch which enable bq27x00_battery driver on Nok=
ia N900=20
RX51. Here is:
> > > >From c06d00aa9d394ab5b65bbd5361c6da8424afbfe5 Mon Sep 17 00:00:0=
0
> > > >2001
> > >=20
> > > From: =3D?UTF-8?q?Pali=3D20Roh=3DC3=3DA1r?=3D <pali.rohar@gmail.c=
om>
> > > Date: Fri, 25 Nov 2011 23:42:54 +0100
> > > Subject: [PATCH] rx51: add bq27200 i2c board info
> > >=20
> > > ---
> > >=20
> > >  arch/arm/mach-omap2/board-rx51-peripherals.c |    5 +++++
> > >  1 files changed, 5 insertions(+), 0 deletions(-)
> > >=20
> > > diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c
> > > b/arch/arm/mach-omap2/board-rx51-peripherals.c index
> > > 5a886cd..23c626e 100644
> > > --- a/arch/arm/mach-omap2/board-rx51-peripherals.c
> > > +++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
> > > @@ -940,6 +940,11 @@ static struct i2c_board_info __initdata
> > > rx51_peripherals_i2c_board_info_2[] =3D {> >=20
> > >  =09=09.platform_data  =3D &rx51_lp5523_platform_data,
> > >  =09
> > >  =09},
> > > =20
> > >  #endif
> > >=20
> > > +#if defined(CONFIG_BATTERY_BQ27X00_I2C) ||
> > > defined(CONFIG_BATTERY_BQ27X00_I2C_MODULE) +=09{
> > > +=09=09I2C_BOARD_INFO("bq27200", 0x55),
> > > +=09},
> > > +#endif
> > >=20
> > >  =09{
> > >  =09
> > >  =09=09I2C_BOARD_INFO("tpa6130a2", 0x60),
> > >  =09=09.platform_data =3D &rx51_tpa6130a2_data,

--=20
Pali Roh=E1r
pali.rohar@gmail.com
--nextPart1515633.gvPZuPyBuI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk7sZwMACgkQi/DJPQPkQ1KNGwCffdzEHLI47xZxp/mhxydxlnLk
KPUAoI5h1TyLtsA4it4Bj/Jn5MQwVcyX
=Ek1s
-----END PGP SIGNATURE-----

--nextPart1515633.gvPZuPyBuI--

