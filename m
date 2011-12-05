Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab1LECBO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 21:01:14 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:58600 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab1LECBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 21:01:13 -0500
Date: Mon, 5 Dec 2011 13:01:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: linux-next: manual merge of the sound-asoc tree with the s5p tree
Message-Id: <20111205130102.aec262d85aa6b47b0aec7011@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__5_Dec_2011_13_01_02_+1100_Ukmme00FjnHS=/tB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_Dec_2011_13_01_02_+1100_Ukmme00FjnHS=/tB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the sound-asoc tree got a conflict in
arch/arm/mach-s3c64xx/mach-crag6410.c between commit c5c32c965dad ("ARM:
S3C64XX: Hook up Littlemill audio card on Cragganmore") from the s5p tree
and commit 6414261f0a2a ("ASoC: Rename Speyside WM8962 to Tobermory")
from the sound-asoc tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-s3c64xx/mach-crag6410.c
index 6ff76c0,55c0e75..0000000
--- a/arch/arm/mach-s3c64xx/mach-crag6410.c
+++ b/arch/arm/mach-s3c64xx/mach-crag6410.c
@@@ -346,8 -338,7 +346,8 @@@ static struct platform_device *crag6410
  	&crag6410_lcd_powerdev,
  	&crag6410_backlight_device,
  	&speyside_device,
- 	&speyside_wm8962_device,
+ 	&tobermory_device,
 +	&littlemill_device,
  	&lowland_device,
  	&wallvdd_device,
  };

--Signature=_Mon__5_Dec_2011_13_01_02_+1100_Ukmme00FjnHS=/tB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO3CXeAAoJEECxmPOUX5FEp0sP+wf8v6hFIXkvOGare3tR4d/G
GZjx8yNp5bp7b4CXm+JPDa/qswONODlSDtgRZcDeZpXOwEO3pPoSi30rv7ALlNnE
Ej7X29ek8NLpbafRcbPeAqqCeNQvyJ0LhyEkxUVcGWokkheiRricc25rD6JCNkmN
SACuuZdT1muuBek583/ABwCcXUADIqh1/1IOIUI7rzq+lPVGssuih3n/DnQTUI64
Cn1XfYlNAQue102bhFsExOwUKQR7eHLSbz6zwZ5TDhKA7my0+ve/3gF9h8ImbAMG
w8hWIFydQ7DdSFUFZtLazet5fSLKmnUS7qmM4yPQ2vjlwSbyAKy0x91zev4ke29C
QYmO9QVfV+q9Dnk9tXicrr5jh0nhVqeOPHzdKTAafGODx/ZkCAS/jUToLRlcfLFz
nQ5V5VygRVPTKiVn4/Pm726y2k5sRuyr/Bcq/cu87/4WFreryZwe2vNlitd7dhwv
2sPdtr7cXf0+vLd2RoICsVYuXQSa0KtkBOKD24wh46gNXZf+EkH4S2mlCAX0LwRG
QL5kjKJ6Ynb3zY1NrgSRRkLPwBgWD2OfaQc2tIh2wxeOkd8wa7tZ6Gvmmsla8Tvg
tPojAqn8KEVvCKJrsLBZbOw+KyEk5FQl+Q5mVhG0/9vSBb+Nms/w5ORWyiZwpLoL
c0EQpsGfNXKkLqC8Rtgk
=nyu0
-----END PGP SIGNATURE-----

--Signature=_Mon__5_Dec_2011_13_01_02_+1100_Ukmme00FjnHS=/tB--
