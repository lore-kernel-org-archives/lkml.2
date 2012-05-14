Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab2ENDiG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 23:38:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35121 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162Ab2ENDiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 23:38:05 -0400
Date: Mon, 14 May 2012 13:37:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: build failure after merge of the mfd tree
Message-Id: <20120514133753.77567dfa46a1e51f9d33bb47@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__14_May_2012_13_37_53_+1000_J7==K5R2m2Y78iR1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_May_2012_13_37_53_+1000_J7==K5R2m2Y78iR1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

ERROR: "wm8400_block_read" [drivers/regulator/wm8400-regulator.ko] undefine=
d!
ERROR: "regmap_reinit_cache" [drivers/mfd/wm8400-core.ko] undefined!

Caused by commit 4d240045599c ("mfd: Remove wm8400 custom cache
implementation").

I have used the mfd tree from next-20120511 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__14_May_2012_13_37_53_+1000_J7==K5R2m2Y78iR1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPsH4RAAoJEECxmPOUX5FEYV0P/3riCU4RMNXOIIklTLlIrPvW
AV1V8+Wa+WW9oiUIdBeWFkH7+LmPeeggmXGTC97hE26a+0uStSn8Npgdt5ClbXD2
QLpJJMdMdA5I1J944t2Lun9y61dPh86fLoFA2QZ+FLOyIzIdQr/YC/B5DoRIP9+F
x7h6m+o8mhHDi3eWfjelB5fIp5+nXc8vkM4W+fqe7jC/xGnvLua6IK7yPNF2vTUO
+UyPNPN3gEDBoHISo4UF3SNar4Y4FTBMm+GlYA8ICY9XVym8RGtVrp0R8OXpjnSt
bC2HkOoLFTh1Foxz0G3RV/G0KXryOOgbEwIdRYs1t6H5uYoIr6atEiX+r0b3dGKT
cdkkyYehX1FreHqBGWoV2iO/cMFXKCncGW6DnXeyuZm6Ga6sASCgfGvM3+awsva6
wt6t/apLElxmJcWrUBWsh3WIdiIGATdw0Pp0fmb6YXFuiJYPFvRmKAhQL2FOlRp5
GZD8d4t3OF2/o8e1uqi0pzm5egeyyNsO13lH+sE/Eu+oB8ILDYpZf53u61qJG7Wg
HFTe0G1Z+eZ1mu0qK8CrsM/o+yPgiIAIV6K3OVu9yu5hJMiRfddNSy53msEN41HP
ugHDZwTG4iDmTsS8wbG37YGQ2yCN8ha+ws5VcKNULQIgupifJtowX2pgNXAkrVAQ
s3KOg21+L/nSK0D8KofA
=JAxo
-----END PGP SIGNATURE-----

--Signature=_Mon__14_May_2012_13_37_53_+1000_J7==K5R2m2Y78iR1--
