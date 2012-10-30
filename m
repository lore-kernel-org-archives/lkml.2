Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab2J3DoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 23:44:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58916 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab2J3DoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 23:44:22 -0400
Date: Tue, 30 Oct 2012 14:44:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: manual merge of the samsung tree with the pinctrl tree
Message-Id: <20121030144412.4a4a60dc0dace86f1a91af8c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__30_Oct_2012_14_44_12_+1100_2tUa8exMbwvoPmqk"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__30_Oct_2012_14_44_12_+1100_2tUa8exMbwvoPmqk
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kukjin,

Today's linux-next merge of the samsung tree got a conflict in
arch/arm/boot/dts/exynos4210.dtsi between commit a7a8241540c3 ("ARM: dts:
exynos4210-pinctrl: Add nodes for pin banks") from the pinctrl tree and
commit 8d4155dbb184 ("ARM: EXYNOS: Add devicetree node for TMU driver for
exynos4") from the samsung tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/exynos4210.dtsi
index d877dbe,038de97..0000000
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@@ -64,4 -74,240 +64,11 @@@
  		compatible =3D "samsung,pinctrl-exynos4210";
  		reg =3D <0x03860000 0x1000>;
  	};
+=20
 -	gpio-controllers {
 -		#address-cells =3D <1>;
 -		#size-cells =3D <1>;
 -		gpio-controller;
 -		ranges;
 -
 -		gpa0: gpio-controller@11400000 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x11400000 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpa1: gpio-controller@11400020 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x11400020 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpb: gpio-controller@11400040 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x11400040 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpc0: gpio-controller@11400060 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x11400060 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpc1: gpio-controller@11400080 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x11400080 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpd0: gpio-controller@114000A0 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x114000A0 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpd1: gpio-controller@114000C0 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x114000C0 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpe0: gpio-controller@114000E0 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x114000E0 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpe1: gpio-controller@11400100 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x11400100 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpe2: gpio-controller@11400120 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x11400120 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpe3: gpio-controller@11400140 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x11400140 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpe4: gpio-controller@11400160 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x11400160 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpf0: gpio-controller@11400180 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x11400180 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpf1: gpio-controller@114001A0 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x114001A0 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpf2: gpio-controller@114001C0 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x114001C0 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpf3: gpio-controller@114001E0 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x114001E0 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpj0: gpio-controller@11000000 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x11000000 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpj1: gpio-controller@11000020 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x11000020 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpk0: gpio-controller@11000040 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x11000040 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpk1: gpio-controller@11000060 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x11000060 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpk2: gpio-controller@11000080 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x11000080 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpk3: gpio-controller@110000A0 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x110000A0 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpl0: gpio-controller@110000C0 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x110000C0 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpl1: gpio-controller@110000E0 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x110000E0 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpl2: gpio-controller@11000100 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x11000100 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpy0: gpio-controller@11000120 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x11000120 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpy1: gpio-controller@11000140 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x11000140 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpy2: gpio-controller@11000160 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x11000160 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpy3: gpio-controller@11000180 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x11000180 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpy4: gpio-controller@110001A0 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x110001A0 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpy5: gpio-controller@110001C0 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x110001C0 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpy6: gpio-controller@110001E0 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x110001E0 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpx0: gpio-controller@11000C00 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x11000C00 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpx1: gpio-controller@11000C20 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x11000C20 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpx2: gpio-controller@11000C40 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x11000C40 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpx3: gpio-controller@11000C60 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x11000C60 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -
 -		gpz: gpio-controller@03860000 {
 -			compatible =3D "samsung,exynos4-gpio";
 -			reg =3D <0x03860000 0x20>;
 -			#gpio-cells =3D <4>;
 -		};
 -	};
 -
+ 	tmu@100C0000 {
+ 		compatible =3D "samsung,exynos4210-tmu";
+ 		interrupt-parent =3D <&combiner>;
+ 		reg =3D <0x100C0000 0x100>;
+ 		interrupts =3D <2 4>;
+ 	};
  };

--Signature=_Tue__30_Oct_2012_14_44_12_+1100_2tUa8exMbwvoPmqk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQj00MAAoJEECxmPOUX5FE5K0P/2y1x6VOoxVuxoA4y0gyFK6d
JXzYA0u4GJHusZOnd9aekTGxt9wyjACeBfZtcJcXJjlOgM30L6SzY7iFlF0wPw7C
Le1XedYKZ5YMB/1pUgZnTxyeNF1dHaVGo6RXI5KRTSXnTZBhgFN4VAqzu8nO7w6/
COiACRfpFChmixWEzmboO3OyIHMqFPQVhC5jybAjRFawlRqogL04dVFsMIv8rzB1
ofTqSkvWq48knxqsC5bnGdDa9QwGlGBBYLx8kXklP5hMt5HxxbdAQdeoS4GeGMyX
mHPd9DpZ56rqDKhY1bd1mjwOTlzL8KRywuPwyu2L1y3CK/m0U08zlubqhR/ekXL1
VjUu3e6zT7Q/0+x0VomKGXhmRCGBsp3crHAQb/OwFKOIDW7ftJEsZOHBYaWcFheb
UypD96WaKBnxWY78yzKi58QB0Ma4aSRZ89boH7BxBWiEMuB+0iNcFbHYrmMJKwN6
smkPl3Wjt2qmO0KDrn9MEGDofjCU5lfFX/LV8PHzp3q44j2QashPd5LNoHgix4Gx
XSq6WLX8bO2KSE26LAPfgXrmOuS+HtueqYN1DHRItwZGTUnnIiGM4nbA2UvRKDW/
BR/fzRRNKX+c2wsJ1ryBdln0kS7xX/GTfw0O5GUtfCXpnaSzN7QNS8DEiKpQk3lh
sRiYZ2KcdiGnMQIgGsFd
=zSkb
-----END PGP SIGNATURE-----

--Signature=_Tue__30_Oct_2012_14_44_12_+1100_2tUa8exMbwvoPmqk--
