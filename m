Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab1FBBuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 21:50:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33016 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090Ab1FBBut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 21:50:49 -0400
Date: Thu, 2 Jun 2011 11:50:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rickard Evertsson <rickard.evertsson@stericsson.com>,
        Daniel Willerud <daniel.willerud@stericsson.com>,
        Deepak Karda <deepak.karda@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Subject: linux-next: build failure after merge of the final tree (ux500-core
 tree related)
Message-Id: <20110602115045.41815756.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__2_Jun_2011_11_50_45_+1000_V7xFRI/zKnpnRD9J"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__2_Jun_2011_11_50_45_+1000_V7xFRI/zKnpnRD9J
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, next-20110601 build (arm u8500_defconfig)
failed like this:

arch/arm/mach-ux500/clock-db8500.c:21:32: error: linux/gpio/nomadik.h: No s=
uch file or directory
arch/arm/mach-ux500/clock-db8500.c: In function 'clkout0_enable':
arch/arm/mach-ux500/clock-db8500.c:214: error: implicit declaration of func=
tion 'nmk_config_pin'
arch/arm/mach-ux500/clock-db8500.c:214: error: implicit declaration of func=
tion 'PIN_CFG'
arch/arm/mach-ux500/clock-db8500.c:214: error: 'ALT_A' undeclared (first us=
e in this function)
arch/arm/mach-ux500/clock-db8500.c: In function 'clkout0_disable':
arch/arm/mach-ux500/clock-db8500.c:221: error: 'GPIO' undeclared (first use=
 in this function)
arch/arm/mach-ux500/clock-db8500.c: In function 'clkout1_enable':
arch/arm/mach-ux500/clock-db8500.c:239: error: 'ALT_A' undeclared (first us=
e in this function)
arch/arm/mach-ux500/clock-db8500.c: In function 'clkout1_disable':
arch/arm/mach-ux500/clock-db8500.c:246: error: 'GPIO' undeclared (first use=
 in this function)

Casued by commit 077f17db54fa ("mach-ux500: split per-SoC clock trees").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__2_Jun_2011_11_50_45_+1000_V7xFRI/zKnpnRD9J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN5ux1AAoJEDMEi1NhKgbsdAMH/jjNA6cptahg2mqQRuEd0nVP
KRAdTcXUL1IPxtIXQgl06y5PgsFLBq/n1QQ5AXwy88Zhp/WKc7Hq/EXzLA18evO/
xPfBKMZ7We2Ia68nfSsPvHCGbz94q6KHsIrGQwFLf+SxMuzJhqAGR734hpGjSlTr
27ywtuvX7tjJUQ0XdNAQpClbRaTZJEjEngZwKXLElxd9sLZd8YmTvd+aUp4ZGoeh
CjB83NnrQByApRD5E7rW5Yvh4jOGRWecS88r/bxh0+gMTwCoMTKe79DimTUs4TYo
r2arMM+ZW8w25lUtoBv8qGBdHSDITofieT6+ksP95+Wnrfu96fikxgE7RmYMmCs=
=dzhX
-----END PGP SIGNATURE-----

--Signature=_Thu__2_Jun_2011_11_50_45_+1000_V7xFRI/zKnpnRD9J--
