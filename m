Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab1JMGZI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 02:25:08 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:44715 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab1JMGZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 02:25:06 -0400
Date: Thu, 13 Oct 2011 17:25:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: linux-next: manual merge of the moduleh tree with the s5p tree
Message-Id: <20111013172500.ad9d603304f5b13527b8410d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Oct_2011_17_25_00_+1100_mN+jVOmRBuk3eGo/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Oct_2011_17_25_00_+1100_mN+jVOmRBuk3eGo/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the moduleh tree got conflicts in
arch/arm/plat-s3c24xx/devs.c, arch/arm/plat-s5p/dev-ehci.c,
arch/arm/plat-s5p/dev-onenand.c, arch/arm/plat-samsung/dev-adc.c,
arch/arm/plat-samsung/dev-asocdma.c, arch/arm/plat-samsung/dev-ide.c,
arch/arm/plat-samsung/dev-nand.c, arch/arm/plat-samsung/dev-pwm.c,
arch/arm/plat-samsung/dev-rtc.c, arch/arm/plat-samsung/dev-ts.c,
arch/arm/plat-samsung/dev-usb.c and arch/arm/plat-samsung/dev-wdt.c
between commits from the s5p tree and commits 8d7f68e196ec ("arm: fix
implicit use of asm/sizes.h in plat-s5p/plat-samsung") and 1c28ea1c50da
("arm: Add export.h to ARM specific files as required") from the moduleh
tree.

The s5p tree commits effectively removed these files, so I did that.
Hopefully the fixups from the moduleh tree are no longer required or
covered by other changes.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__13_Oct_2011_17_25_00_+1100_mN+jVOmRBuk3eGo/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOloQ8AAoJEECxmPOUX5FEN8QQAJHLG+fmU9pl9YOEqIlXXkU9
/2GtMxK6kwnRTnwM5hmcunvLFA+jdhBzzFW383GhP+94zn6T9iPnga7EIN2xNwme
JFYR3khMZpDDZ+vPQ6E8dwoqKp5MfenRwZFVFmGBlShXBM2ofJRwgXmnO/79p00y
MZBCOUnJnMr8DCgT1GMwD4aBIwcyfRJxiFmAgF/A/NXAgehsPtcYcYFXhyS5ID0p
PYmL8E2PN1IgB/9xI85jiO6s5pShLASj12PGt/ZCsrUxM2LSIObUnlPTIZvJOXwV
UzZotKRazPrcSIZJ3A5sueCXeoU1KTo8ilLei58q1I+NQ+9g/0hxDdLOyOtkuZQ5
NNCkwmiVpqQLlj4RNp2RkHfWb8GiF6eMwA0AVfY2e70/sRthcXugqihqzbL8QsdR
nhI439IhD2etPTb9fn/qcMcD5eNj/kT8Vky/sWjXIl/VvAsi3ME3ldNfy5DzbBJh
D5NiphatLxNn2VfW5QyfmCEb43UFIsPLc+O6BQYfrN2LrkJurxwIVFcepmVA/G/l
kUuopvMPqX8qdGS7TgXUO6q/0mHuXCGSf4ZHbaUE4CBL+NZzM6WHNxsNcPBS+rfu
FJKRZSXC5x+n2Za6zbyUjiMRZ/W0wk3jerwYUh+PelBK6/tmcHh8xnNa1KWfpEay
StDdbO0qzGXmYmsr2QNC
=xoZo
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Oct_2011_17_25_00_+1100_mN+jVOmRBuk3eGo/--
