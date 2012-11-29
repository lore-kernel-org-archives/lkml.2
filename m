Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab2K2EAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 23:00:49 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:49108 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab2K2EAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 23:00:48 -0500
Date: Thu, 29 Nov 2012 15:00:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the driver-core tree with the mfd tree
Message-Id: <20121129150044.3795f21cd3913abc0c10f45c@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Nov_2012_15_00_44_+1100_IU75cvJiyjjoom4i"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Nov_2012_15_00_44_+1100_IU75cvJiyjjoom4i
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/mfd/tps65090.c between various commits from the mfd tree and
commits 84449216b01f ("mfd: remove use of __devexit_p"), f791be492f76
("mfd: remove use of __devinit") and 4740f73fe538 ("mfd: remove use of
__devexit") from the driver-core tree.

I fixed it up (by using the mfd tree version) and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__29_Nov_2012_15_00_44_+1100_IU75cvJiyjjoom4i
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtt3tAAoJEECxmPOUX5FES9EQAIBgM38j1rGYlIVY4cUomqOY
J1ixBaZlmiNg0c8fdxKjFa7FGR4yRcSEK7xAdp4TkGwSLLk3njYGMBvystn2smTn
bkSr6jsuDdx2qhLNf9g5G32YhGxBbeADd6ko7JYtXlc8si0r4aRY0hOe0pYJQfhq
v04TXfu7ZMLGfe//8yu5Mj4A+J3n/nj3EmhSXGcTj62OrsXa2VUaBHU7QXPIGhV7
o52OhJNruP8nAX8ySqGs5kn08iDmMEeL4qizlgkhQ24U85HY96LgdauFEXmKJB/A
5+QzfZnv/e2nES5IfZSkIfGbvPa3ADyDg6TsAf4aN1xEoaJvf/Z9A/cpmFw0CkJ0
EkJoiykGPPJCr6y91udXq72Qt/hNt2DzNy8AQlidbAALSSX601+O6YvDnKrjnj8b
0kOfE3uoJ2N+JpKt8g4I7+DyxrVGHK9ex39s5A7mqIC5Hf+63JoO0+KFsWqPCkO+
a/VBlnf+5nbUOCHMoon6xZuEWC24A1UTc5Xz1nX2SeJA5IF0Y1BVH5U4vdGMbCln
4W7PYT52hcS617FCnUHi42zaISKAPtCebOACbWOs0nd6XO8zz7uy7sIt5N92CLw8
amnDLgApJc07FRW7EzesIQ/WUlSeueEiV5ex/DIxlXpYbw7+sE/aRLIXEXrMIVLo
b1hm2THMl2KuFZ0RR8CR
=UAQD
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Nov_2012_15_00_44_+1100_IU75cvJiyjjoom4i--
