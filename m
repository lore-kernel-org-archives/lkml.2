Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720Ab0J1A1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 20:27:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43835 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab0J1A1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 20:27:48 -0400
Date: Thu, 28 Oct 2010 11:27:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sweta Bhatt <sweta.bhatt@einfochips.com>,
        Roland Dreier <rolandd@cisco.com>, Davide Rizzo <elpa.rizzo@gmail.com>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Mike Frysinger <vapier@gentoo.org>,
        Richard Purdie <rpurdie@linux.intel.com>,
        Joseph Chan <JosephChan@via.com.tw>
Subject: linux-next: build warnings from Linus' tree
Message-Id: <20101028112739.0f400818.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__28_Oct_2010_11_27_39_+1100_EUPa91qJ2eWSW.nN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_Oct_2010_11_27_39_+1100_EUPa91qJ2eWSW.nN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

While building Linus' tree, today's linux-next build (x86_64 allmodconfig)
produced these warnings:

sound/soc/soc-core.c: In function 'pmdown_time_set':
sound/soc/soc-core.c:169: warning: ignoring return value of 'strict_strtol'=
, declared with attribute warn_unused_result
drivers/infiniband/hw/nes/nes.c: In function 'nes_store_wqm_quanta':
drivers/infiniband/hw/nes/nes.c:1115: warning: ignoring return value of 'st=
rict_strtoul', declared with attribute warn_unused_result
drivers/hwmon/lm95241.c: In function 'set_interval':
drivers/hwmon/lm95241.c:132: warning: ignoring return value of 'strict_strt=
ol', declared with attribute warn_unused_result
drivers/hwmon/lm95241.c: In function 'set_type1':
drivers/hwmon/lm95241.c:219: warning: ignoring return value of 'strict_strt=
ol', declared with attribute warn_unused_result
drivers/hwmon/lm95241.c: In function 'set_type2':
drivers/hwmon/lm95241.c:220: warning: ignoring return value of 'strict_strt=
ol', declared with attribute warn_unused_result
drivers/hwmon/lm95241.c: In function 'set_min1':
drivers/hwmon/lm95241.c:248: warning: ignoring return value of 'strict_strt=
ol', declared with attribute warn_unused_result
drivers/hwmon/lm95241.c: In function 'set_min2':
drivers/hwmon/lm95241.c:249: warning: ignoring return value of 'strict_strt=
ol', declared with attribute warn_unused_result
drivers/hwmon/lm95241.c: In function 'set_max1':
drivers/hwmon/lm95241.c:277: warning: ignoring return value of 'strict_strt=
ol', declared with attribute warn_unused_result
drivers/hwmon/lm95241.c: In function 'set_max2':
drivers/hwmon/lm95241.c:278: warning: ignoring return value of 'strict_strt=
ol', declared with attribute warn_unused_result
drivers/video/backlight/adp8860_bl.c: In function 'adp8860_bl_l1_daylight_m=
ax_store':
drivers/video/backlight/adp8860_bl.c:506: warning: ignoring return value of=
 'strict_strtoul', declared with attribute warn_unused_result
drivers/video/via/viafbdev.c: In function 'viafb_dvp0_proc_write':
drivers/video/via/viafbdev.c:1117: warning: ignoring return value of 'stric=
t_strtoul, ', declared with attribute warn_unused_result
drivers/video/via/viafbdev.c: In function 'viafb_dvp1_proc_write':
drivers/video/via/viafbdev.c:1187: warning: ignoring return value of 'stric=
t_strtoul', declared with attribute warn_unused_result
drivers/video/via/viafbdev.c: In function 'viafb_dfph_proc_write':
drivers/video/via/viafbdev.c:1245: warning: ignoring return value of 'stric=
t_strtoul', declared with attribute warn_unused_result
drivers/video/via/viafbdev.c: In function 'viafb_dfpl_proc_write':
drivers/video/via/viafbdev.c:1284: warning: ignoring return value of 'stric=
t_strtoul', declared with attribute warn_unused_result
drivers/video/via/viafbdev.c: In function 'viafb_vt1636_proc_write':
drivers/video/via/viafbdev.c:1353: warning: ignoring return value of 'stric=
t_strtoul', declared with attribute warn_unused_result
drivers/video/via/viafbdev.c:1390: warning: ignoring return value of 'stric=
t_strtoul', declared with attribute warn_unused_result

Exposed by commit a55621f15bc61826969a29e111ba131a55ef45de
("include/linux/kernel.h: add __must_check to strict_strto*()").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__28_Oct_2010_11_27_39_+1100_EUPa91qJ2eWSW.nN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMyMN7AAoJEDMEi1NhKgbsdhkH/2GneWDtDnkRJFOItyfi8FbP
rd0HecZt9pi9cLa2Rk/fo3JyDrFl2qx5QMRa2S9TC7mQA3hN0CDJJsll7frIrk80
YjWU6rB3GlDPuQz4UFWrT75Q0LLijFGVi+MYGQtrMZ3duvhm8X5z2n10fJFbp8UQ
4EJy1f2L+hiz7PU32PcFF2YMzo4YnD50Y9ZzqU5eDrceZJUmsSORgEvxnS2xf1oV
w4njn5/1MhvqXB4oR/GJg/52AxJer6G+s3PGsNbbZkNK7Qz5hPep5QqTh2tp65JV
J3mTLJMuWuV57/1izCoEGuJXqpXYlDHdO1W2y9B1AsFm2Lhm1hMuHkawlxPC+3M=
=oIMj
-----END PGP SIGNATURE-----

--Signature=_Thu__28_Oct_2010_11_27_39_+1100_EUPa91qJ2eWSW.nN--
