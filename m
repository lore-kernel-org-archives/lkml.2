Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510Ab0GMHJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 03:09:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56462 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751075Ab0GMHJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 03:09:56 -0400
Date: Tue, 13 Jul 2010 17:09:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        =?UTF-8?B?IlV3ZSBLbGVpbmUtS8O2bmlnIg==?= 
	<u.kleine-koenig@pengutronix.de>,
        Olof Johansson <olof@lixom.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH] powerpc: reduce the size of the defconfigs
Message-Id: <20100713170945.26d95641.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__13_Jul_2010_17_09_45_+1000_17jFtFQAUEbAHRS0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Jul_2010_17_09_45_+1000_17jFtFQAUEbAHRS0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This uses Uwe's script (modified by Olof Johansson to speed it up
somewhat) to reduce the size of all the powerpc defconfigs.  The resulting
files have been verified to produce the same .config files by generating
them before and after this patch and comparing the results.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/configs/40x/acadia_defconfig         | 1002 ----------
 arch/powerpc/configs/40x/ep405_defconfig          | 1211 ------------
 arch/powerpc/configs/40x/hcu4_defconfig           | 1064 ----------
 arch/powerpc/configs/40x/kilauea_defconfig        | 1197 -----------
 arch/powerpc/configs/40x/makalu_defconfig         | 1005 ----------
 arch/powerpc/configs/40x/virtex_defconfig         | 1105 -----------
 arch/powerpc/configs/40x/walnut_defconfig         | 1089 ----------
 arch/powerpc/configs/44x/arches_defconfig         | 1059 ----------
 arch/powerpc/configs/44x/bamboo_defconfig         | 1020 ----------
 arch/powerpc/configs/44x/canyonlands_defconfig    | 1263 ------------
 arch/powerpc/configs/44x/ebony_defconfig          | 1103 -----------
 arch/powerpc/configs/44x/eiger_defconfig          | 1177 -----------
 arch/powerpc/configs/44x/icon_defconfig           | 1335 -------------
 arch/powerpc/configs/44x/iss476-smp_defconfig     |  938 ---------
 arch/powerpc/configs/44x/katmai_defconfig         | 1088 ----------
 arch/powerpc/configs/44x/rainier_defconfig        | 1090 ----------
 arch/powerpc/configs/44x/redwood_defconfig        | 1168 -----------
 arch/powerpc/configs/44x/sam440ep_defconfig       | 1319 -------------
 arch/powerpc/configs/44x/sequoia_defconfig        | 1111 -----------
 arch/powerpc/configs/44x/taishan_defconfig        | 1097 -----------
 arch/powerpc/configs/44x/virtex5_defconfig        | 1111 -----------
 arch/powerpc/configs/44x/warp_defconfig           | 1389 -------------
 arch/powerpc/configs/52xx/cm5200_defconfig        | 1232 ------------
 arch/powerpc/configs/52xx/lite5200b_defconfig     | 1257 ------------
 arch/powerpc/configs/52xx/motionpro_defconfig     | 1265 ------------
 arch/powerpc/configs/52xx/pcm030_defconfig        | 1219 ------------
 arch/powerpc/configs/52xx/tqm5200_defconfig       | 1367 -------------
 arch/powerpc/configs/83xx/asp8347_defconfig       | 1432 --------------
 arch/powerpc/configs/83xx/kmeter1_defconfig       |  927 ---------
 arch/powerpc/configs/83xx/mpc8313_rdb_defconfig   | 1729 ----------------
 arch/powerpc/configs/83xx/mpc8315_rdb_defconfig   | 1798 -----------------
 arch/powerpc/configs/83xx/mpc832x_mds_defconfig   | 1328 -------------
 arch/powerpc/configs/83xx/mpc832x_rdb_defconfig   | 1475 --------------
 arch/powerpc/configs/83xx/mpc834x_itx_defconfig   | 1567 ---------------
 arch/powerpc/configs/83xx/mpc834x_itxgp_defconfig | 1453 --------------
 arch/powerpc/configs/83xx/mpc834x_mds_defconfig   | 1262 ------------
 arch/powerpc/configs/83xx/mpc836x_mds_defconfig   | 1403 -------------
 arch/powerpc/configs/83xx/mpc836x_rdk_defconfig   | 1304 ------------
 arch/powerpc/configs/83xx/mpc837x_mds_defconfig   | 1333 -------------
 arch/powerpc/configs/83xx/mpc837x_rdb_defconfig   | 1471 --------------
 arch/powerpc/configs/83xx/sbc834x_defconfig       | 1398 -------------
 arch/powerpc/configs/85xx/ksi8560_defconfig       | 1119 -----------
 arch/powerpc/configs/85xx/mpc8540_ads_defconfig   |  992 ----------
 arch/powerpc/configs/85xx/mpc8560_ads_defconfig   | 1139 -----------
 arch/powerpc/configs/85xx/mpc85xx_cds_defconfig   | 1155 -----------
 arch/powerpc/configs/85xx/sbc8548_defconfig       | 1001 ----------
 arch/powerpc/configs/85xx/sbc8560_defconfig       | 1029 ----------
 arch/powerpc/configs/85xx/socrates_defconfig      | 1645 ----------------
 arch/powerpc/configs/85xx/stx_gp3_defconfig       | 1528 --------------
 arch/powerpc/configs/85xx/tqm8540_defconfig       | 1318 -------------
 arch/powerpc/configs/85xx/tqm8541_defconfig       | 1364 -------------
 arch/powerpc/configs/85xx/tqm8548_defconfig       | 1355 +-------------
 arch/powerpc/configs/85xx/tqm8555_defconfig       | 1364 -------------
 arch/powerpc/configs/85xx/tqm8560_defconfig       | 1364 -------------
 arch/powerpc/configs/85xx/xes_mpc85xx_defconfig   | 1786 -----------------
 arch/powerpc/configs/86xx/gef_ppc9a_defconfig     | 1736 ----------------
 arch/powerpc/configs/86xx/gef_sbc310_defconfig    | 1625 ---------------
 arch/powerpc/configs/86xx/gef_sbc610_defconfig    | 1819 -----------------
 arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig  | 1634 ---------------
 arch/powerpc/configs/86xx/mpc8641_hpcn_defconfig  | 1640 ----------------
 arch/powerpc/configs/86xx/sbc8641d_defconfig      | 1432 --------------
 arch/powerpc/configs/adder875_defconfig           |  913 ---------
 arch/powerpc/configs/amigaone_defconfig           | 1490 --------------
 arch/powerpc/configs/c2k_defconfig                | 1608 ---------------
 arch/powerpc/configs/cell_defconfig               | 1314 +------------
 arch/powerpc/configs/celleb_defconfig             | 1195 +-----------
 arch/powerpc/configs/chrp32_defconfig             | 1469 --------------
 arch/powerpc/configs/ep8248e_defconfig            | 1118 -----------
 arch/powerpc/configs/ep88xc_defconfig             |  858 --------
 arch/powerpc/configs/g5_defconfig                 | 1549 ---------------
 arch/powerpc/configs/gamecube_defconfig           |  945 ---------
 arch/powerpc/configs/holly_defconfig              |  879 ---------
 arch/powerpc/configs/iseries_defconfig            | 1056 ----------
 arch/powerpc/configs/linkstation_defconfig        | 1782 -----------------
 arch/powerpc/configs/maple_defconfig              | 1371 -------------
 arch/powerpc/configs/mgcoge_defconfig             | 1158 -----------
 arch/powerpc/configs/mgsuvd_defconfig             |  937 ---------
 arch/powerpc/configs/mpc512x_defconfig            | 1559 ---------------
 arch/powerpc/configs/mpc5200_defconfig            | 1849 -----------------
 arch/powerpc/configs/mpc7448_hpc2_defconfig       | 1194 -----------
 arch/powerpc/configs/mpc8272_ads_defconfig        | 1185 -----------
 arch/powerpc/configs/mpc83xx_defconfig            | 1662 ----------------
 arch/powerpc/configs/mpc85xx_defconfig            | 1704 ----------------
 arch/powerpc/configs/mpc85xx_smp_defconfig        | 1708 ----------------
 arch/powerpc/configs/mpc866_ads_defconfig         |  950 ---------
 arch/powerpc/configs/mpc86xx_defconfig            | 1680 ----------------
 arch/powerpc/configs/mpc885_ads_defconfig         |  863 --------
 arch/powerpc/configs/pasemi_defconfig             | 1931 +----------------=
--
 arch/powerpc/configs/pmac32_defconfig             | 1884 +----------------=
--
 arch/powerpc/configs/ppc40x_defconfig             | 1332 -------------
 arch/powerpc/configs/ppc44x_defconfig             | 1471 --------------
 arch/powerpc/configs/ppc64_defconfig              | 1724 +----------------
 arch/powerpc/configs/ppc64e_defconfig             | 1803 -----------------
 arch/powerpc/configs/ppc6xx_defconfig             | 2186 +----------------=
----
 arch/powerpc/configs/pq2fads_defconfig            | 1304 ------------
 arch/powerpc/configs/prpmc2800_defconfig          | 1674 ----------------
 arch/powerpc/configs/ps3_defconfig                | 1334 -------------
 arch/powerpc/configs/pseries_defconfig            | 1454 +--------------
 arch/powerpc/configs/storcenter_defconfig         | 1305 ------------
 arch/powerpc/configs/wii_defconfig                | 1262 ------------
 100 files changed, 51 insertions(+), 133815 deletions(-)

The patch is available at
http://ozlabs.org/~sfr/powerpc-reduce-the-size-of-the-defconfigs.patch.bz2 .

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__13_Jul_2010_17_09_45_+1000_17jFtFQAUEbAHRS0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMPBE5AAoJEDMEi1NhKgbshZoIAIhXqDjS3gjfk/qys6ozLC43
1SVRjNzq+vGa3ZX/MjxGxiWurydf1yz8K1jymsE+ommP+Id/YzLpsfgJ/v88O+Hu
2+z1B7j2mcQzWC6yaPm0SUxZhluzHvvBJ49l5Axx7/3IjVc2NamraZOFB6T8bcpT
vDc0p8b5chGoU5uQvV0Y60xd65s4NVc1JCmCVBRj5L5faDLtYC1PZrUW6JamfP1Y
qESoKHdTvFY7teGxQvOLy+tvqVgfWBNOlt1Rr9TXElePJMHSYv0wndg+9h9YdQTz
UDQVR370U8bZKFqL8i/iGIXE5p5Vbr5eu2MSGTMSzEwhkKmeKj0Ur1K4rfCyLAI=
=NaEl
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Jul_2010_17_09_45_+1000_17jFtFQAUEbAHRS0--
