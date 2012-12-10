Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab2LJGlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 01:41:09 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:57078 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab2LJGlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 01:41:07 -0500
Date: Mon, 10 Dec 2012 17:40:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Padmavathi Venna <padma.v@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Subject: linux-next: manual merge of the arm-soc tree with the sound-asoc
 tree
Message-Id: <20121210174057.9862b43ff7350ba20c048df3@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__10_Dec_2012_17_40_57_+1100_9I91pdmKQv01OuK."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Dec_2012_17_40_57_+1100_9I91pdmKQv01OuK.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/plat-samsung/include/plat/devs.h between commit a08485d8fdf6
("ASoC: Samsung: Do not register samsung audio dma device as pdev") from
the sound-asoc tree and commit 0a9d5ac307ae ("ARM: EXYNOS: removing
exynos-drm device registration from non-dt platforms") from the arm-soc
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/plat-samsung/include/plat/devs.h
index c45f70c,f53beba..0000000
--- a/arch/arm/plat-samsung/include/plat/devs.h
+++ b/arch/arm/plat-samsung/include/plat/devs.h
@@@ -133,8 -132,7 +132,6 @@@ extern struct platform_device exynos4_d
  extern struct platform_device exynos4_device_pcm2;
  extern struct platform_device exynos4_device_spdif;
 =20
- extern struct platform_device exynos_device_drm;
-=20
 -extern struct platform_device samsung_asoc_dma;
  extern struct platform_device samsung_asoc_idma;
  extern struct platform_device samsung_device_keypad;
 =20

--Signature=_Mon__10_Dec_2012_17_40_57_+1100_9I91pdmKQv01OuK.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQxYP5AAoJEECxmPOUX5FEom0QAKWluHAFavlKZOml1GojBsaA
wiRmSZbz5cvedVfWxodWNAMRz0VVsO+JhhPKpBNa4Q71feBRQO9E+U4+GWZuzUL+
mX6fETIKhyNHS2PLXtidX7WNUaJcIE+HCsiMPj49/jWfIhJYLGCyEI4PWuuZIkQ4
9XubaWUW9HNsTfjOaFbJ3kp2cEW56tmFh+IsohWC1ZyZjq/ZcK8y27OFJ5479OkG
SRB7MV3KD/2DcbVZxKN84703cxF9ts9SD/lIefq0E6d7Y0L0WDjwGycSIfawVjT/
bESDVTl6pxVvNJYIszdSBemuq5I0oDOnkwNeTleGnVX3wsxB04bNdpwU0u/Yr6J4
57UwaiWP5z54DDHBTE5IdzLUg30tVXI9sum/yRdin4p2LEWY++A1hyFku0JAOBRI
YZZduVmLBZVyTrHa+IhC/zZsLLfKI70pLyBi0+gV3v/9v8MEfQn7zHD/uWs8tdz2
bloot3s4hdLhjPe+x+T2+/fz+tYjl5ppC4R6lLfwzAfeO2N5ydWtgoRVVJR0qPSZ
xij91eEDNYdobCvk2A8LVRJk8B47AQirKhPim0ixJlH9GKi2MfUSqxCuiLiCUyPB
bRGmv/tFyyrxQjmHNWd7F5MVl9rx/V1xmhCqWOoGuBSzX0SaEY7+0B/jHIyM6NjM
q4DjrBJtAggIwFvCscUS
=PdMx
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Dec_2012_17_40_57_+1100_9I91pdmKQv01OuK.--
