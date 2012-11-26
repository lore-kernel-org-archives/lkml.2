Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab2KZLPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 06:15:16 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48240 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab2KZLPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 06:15:14 -0500
Date: Mon, 26 Nov 2012 22:15:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: manual merge of the samsung tree with the arm-soc tree
Message-Id: <20121126221504.b5da9b5f938ed84b0693c4a3@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Nov_2012_22_15_04_+1100_zkafXtVp9_F1uHF6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Nov_2012_22_15_04_+1100_zkafXtVp9_F1uHF6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the samsung tree got a conflict in
arch/arm/boot/dts/exynos5250-smdk5250.dts between commit 24025f6f5821
("Merge branch 'next/dt-samsung' of
git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into
next/dt") from the arm-soc tree and commit 65fc7232786b ("Merge branch
'next/devel-samsung-3' into for-next") from the samsung tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/exynos5250-smdk5250.dts
index 29f1333,cdeb4f2..0000000
--- a/arch/arm/boot/dts/exynos5250-smdk5250.dts
+++ b/arch/arm/boot/dts/exynos5250-smdk5250.dts
@@@ -208,4 -200,31 +204,27 @@@
  		samsung,mfc-r =3D <0x43000000 0x800000>;
  		samsung,mfc-l =3D <0x51000000 0x800000>;
  	};
+=20
 -	hdmi {
 -		hpd-gpio =3D <&gpx3 7 0xf 1 3>;
 -	};
 -
+ 	i2s_0: i2s@03830000 {
+ 		gpios =3D <&gpz 0 2 0 0>, <&gpz 1 2 0 0>, <&gpz 2 2 0 0>,
+ 			<&gpz 3 2 0 0>, <&gpz 4 2 0 0>, <&gpz 5 2 0 0>,
+ 			<&gpz 6 2 0 0>;
+ 	};
+=20
+ 	i2s_1: i2s@12D60000 {
+ 		status =3D "disabled";
+ 	};
+=20
+ 	i2s_2: i2s@12D70000 {
+ 		status =3D "disabled";
+ 	};
+=20
+ 	dp-controller {
+ 		samsung,color-space =3D <0>;
+ 		samsung,dynamic-range =3D <0>;
+ 		samsung,ycbcr-coeff =3D <0>;
+ 		samsung,color-depth =3D <1>;
+ 		samsung,link-rate =3D <0x0a>;
+ 		samsung,lane-count =3D <4>;
+ 	};
  };

--Signature=_Mon__26_Nov_2012_22_15_04_+1100_zkafXtVp9_F1uHF6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQs084AAoJEECxmPOUX5FEkDIP/2iaVBofgh8j3lNkI72tS/8P
HrobOPNbaSj+Msr2muuKk1ElRUzB83WrlbiXRAWykfXiMf3DheUPxuT8yhMkUGDo
1I1uWNDkrksbeOVA4qqeRXwu0w0oMn7kq55V3RwOKHuvn3XRkiVjvkenaxr9vjFP
7h5zxHxN7JEfdUNQ+x1pBesQeojSttpaIHHkFoYhDonpLeB5KxHRIkKa5ERm2Up2
84e72zFREZ0FEzmt6bVbIlRhElhgBPjorhRikz6igaSU4PtJjgFI/jpsRshBva/k
o1uQZIwVXRmnVaP1B7SPwvc5TKR+XiiusXHIq1TB5+EzyoBqAh3jPqtuzCs9UXWu
uqHVLwgyFavevbAmlzzflKvDLKSEc27zl6k7zuIX6DzpELZaEhcf4lyN8Y4o/RJC
ARCsaHaoNT9jCOf0+0E2cu8FPfJJQEoBSTGa7DW1WkW5j9OYRJcXIgjgEJwPxesy
rvAYMcccTVCGr6XbX0Vn9yQ15k8yPKlgI4A3YiVXWK+WGqXuJu6SDp97IA9B/DTF
/IClLVuMmWjsMz6Pp5Ptjd+IWNBHV5G7IWyVTs9fTf7snovb84JUGLsz7J1YHjIS
e+XyDjgmtw38DvPfehNb8A5spB7rz4UJH1C2rGYtqmepJIT7sOya0/6KnL6tope5
vWeuOU7jHq7n/tHVQ6/H
=c1Yp
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Nov_2012_22_15_04_+1100_zkafXtVp9_F1uHF6--
