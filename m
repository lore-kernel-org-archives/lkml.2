Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372Ab2GCTSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 15:18:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41806 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750803Ab2GCTSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 15:18:46 -0400
Date: Tue, 3 Jul 2012 20:18:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: "AnilKumar, Chimata" <anilkumar@ti.com>, "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>
Subject: Re: [PATCH v2] regulator: tps65217: Fix voltage boundary checking in
 tps65217_pmic_map_voltage
Message-ID: <20120703191843.GF29030@opensource.wolfsonmicro.com>
References: <1341299973.4669.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4imyEzq1NYdDURgI"
Content-Disposition: inline
In-Reply-To: <1341299973.4669.4.camel@phoenix>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4imyEzq1NYdDURgI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 03, 2012 at 03:19:33PM +0800, Axel Lin wrote:
> It is ok to request voltage with min_uV < tps->info[rid]->min_uV and
> max_uV > tps->info[rid]->max_uV.

Applied, thanks.

--4imyEzq1NYdDURgI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP80WNAAoJEBus8iNuMP3d+94P/iGfRh/bBb9awxNrOGjZfK4x
D8EFyDCSgXnip64gMvs6oTa3j5lcQuGFh8/L8nQS8TXuFry4ntASuyHp3+hDN+cQ
G/UDqIFkBs0TYMrYIXY8GpnnKiTQAkI0tw/I3XRAO8grOXPfL4j28Mi7nyZThE1P
W0A8emey1IbTgVzZpxHsC1mqNvZmDxhb+4HtYzoIdeabdAWBpfa70FvubgN966R/
bl40p78WZeiwgDC0J1HRUXszTiBJv6znlAK0hn8FQzoN1H09r4wEdWpFC/w8JoGG
xJh1I950zgWKBndukTOvgvcD8233m3A1HiYZ0t5CPtHSGv5APLGtNROFk93ydNBk
GHYtYsHt/Gn6ZYB6QOwIyMylJFpQwkMFk/MZCpMRQS7CmJh1ikBD30hCFE831Mme
R6Jlhb1TRQcZO7QAoChNWQrGwwaIY1PJqa/AvEXMNwfRI92Cu4l0x+NB3Qe0H8D3
Bf8dpkoUs3ZwY8KCY/0keiU4HZvwmnqLsXhSAtYZDOgEFFqC7310Giu4w/oMjG/5
Ovavvh7tuUstn4EGdhPrG8cI3eOupkoK/630g8TafbvrIlpWAS+e4AH7Y4/MsgoJ
tlW62TlPgw7T/ey15mRT7ff/DsmursK0XqbXhwiqdYd/8mYfi5Ulx/b/Tu91o2wd
/sqpFa4UbCARw9Zyq0yd
=pTlk
-----END PGP SIGNATURE-----

--4imyEzq1NYdDURgI--
