Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab2GEGrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 02:47:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49331 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060Ab2GEGrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 02:47:14 -0400
Message-ID: <4FF53840.3070802@debian.org>
Date: Thu, 05 Jul 2012 14:46:24 +0800
From: "Ying-Chun Liu (PaulLiu)" <paulliu@debian.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@linaro.org>
CC: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        Samuel Ortiz <sameo@linux.intel.com>, patches@linaro.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Robin Gong <B38343@freescale.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: Add Freescale's PMIC MC34708 support
References: <1334853521-23792-1-git-send-email-paul.liu@linaro.org> <20120704073749.GD5398@pengutronix.de> <CAAQ0ZWST5DgS+2Er5EsNscxXtThO7H9-HAO=TtM6Me7EHygK7w@mail.gmail.com>
In-Reply-To: <CAAQ0ZWST5DgS+2Er5EsNscxXtThO7H9-HAO=TtM6Me7EHygK7w@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig077704081AED87C0E99423BF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig077704081AED87C0E99423BF
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

(2012=E5=B9=B407=E6=9C=8804=E6=97=A5 21:44), Shawn Guo wrote:
> On 4 July 2012 15:37, Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutroni=
x.de> wrote:
>> I want to push that forward. What is the state of these patches on you=
r
>> end? Did you start to address the comments? Are there more recent
>> patches than the ones in this thread?
>>
>> Whatever you might have it would be great if you could share it to hel=
p
>> preventing duplicate efforts.
>>
> As far as I know, Paul hasn't been on that effort any more.
>=20
> Copied his another email address.
>=20
> Regards,
> Shawn

Hi,

Sorry, forget to mention about this.
We have a patch for the DTS corresponding to this patch.

=46rom f3d28445de908bf2a848f6e8104b5c7f347ecd64 Mon Sep 17 00:00:00 2001
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Date: Thu, 19 Apr 2012 15:24:10 +0800
Subject: [PATCH] arm: imx53-qsb: Add Ripley driver DT nodes

This patch adds the ripley driver and regulators.

Signed-off-by: Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>
---
 arch/arm/boot/dts/imx53-qsb.dts |  104
+++++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff --git a/arch/arm/boot/dts/imx53-qsb.dts
b/arch/arm/boot/dts/imx53-qsb.dts
index 5c57c86..c95bad7 100644
--- a/arch/arm/boot/dts/imx53-qsb.dts
+++ b/arch/arm/boot/dts/imx53-qsb.dts
@@ -80,6 +80,110 @@
 					compatible =3D "dialog,da9053", "dialog,da9052";
 					reg =3D <0x48>;
 				};
+
+				ripley@8 {
+					compatible =3D "fsl,mc34708";
+					reg =3D <0x08>;
+					regulators {
+						mc34708__sw1a {
+							regulator-name =3D "SW1";
+							regulator-min-microvolt =3D <650000>;
+							regulator-max-microvolt =3D <1437500>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						mc34708__sw1b {
+							regulator-name =3D "SW1B";
+							regulator-min-microvolt =3D <650000>;
+							regulator-max-microvolt =3D <1437500>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						mc34708__sw2 {
+							regulator-name =3D "SW2";
+							regulator-min-microvolt =3D <650000>;
+							regulator-max-microvolt =3D <1437500>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						mc34708__sw3 {
+							regulator-name =3D "SW3";
+							regulator-min-microvolt =3D <650000>;
+							regulator-max-microvolt =3D <1425000>;
+							regulator-boot-on;
+						};
+						mc34708__sw4a {
+							regulator-name =3D "SW4A";
+							regulator-min-microvolt =3D <1200000>;
+							regulator-max-microvolt =3D <3300000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						mc34708__sw4b {
+							regulator-name =3D "SW4B";
+							regulator-min-microvolt =3D <1200000>;
+							regulator-max-microvolt =3D <3300000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						mc34708__sw5 {
+							regulator-name =3D "SW5";
+							regulator-min-microvolt =3D <1200000>;
+							regulator-max-microvolt =3D <1975000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						mc34708__swbst {
+							regulator-name =3D "SWBST";
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						mc34708__vpll {
+							regulator-name =3D "VPLL";
+							regulator-min-microvolt =3D <1200000>;
+							regulator-max-microvolt =3D <1800000>;
+							regulator-boot-on;
+						};
+						mc34708__vrefddr {
+							regulator-name =3D "VREFDDR";
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						mc34708__vusb {
+							regulator-name =3D "VUSB";
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						mc34708__vusb2 {
+							regulator-name =3D "VUSB2";
+							regulator-min-microvolt =3D <2500000>;
+							regulator-max-microvolt =3D <3000000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						mc34708__vdac {
+							regulator-name =3D "VDAC";
+							regulator-min-microvolt =3D <2500000>;
+							regulator-max-microvolt =3D <2775000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						mc34708__vgen1 {
+							regulator-name =3D "VGEN1";
+							regulator-min-microvolt =3D <1200000>;
+							regulator-max-microvolt =3D <1550000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						mc34708__vgen2 {
+							regulator-name =3D "VGEN2";
+							regulator-min-microvolt =3D <2500000>;
+							regulator-max-microvolt =3D <3300000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+					};
+				};
 			};

 			fec@63fec000 {
--=20
1.7.10


Thanks,
Paul

--=20
                                PaulLiu (=E5=8A=89=E7=A9=8E=E9=A7=BF)
E-mail: Ying-Chun Liu (PaulLiu) <paulliu@debian.org>


--------------enig077704081AED87C0E99423BF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCgAGBQJP9ThAAAoJEPgLgUbQQog2/n8QAIMcGgbjKBT+1REyVH44UiOr
L1EQgPMA5gyjJoRsZFLhMcMyhI/grJxndGWQSQthWDepAToxqFCVTpzhQDIEMUA8
Sq9O4KmPk3M6MdHfD9TUMg0kZP4CEyK0cN8Trk2Y9+a1ZltBrtW9l1FBOxzwZb7h
VAsdT1JM/NYswZw1FrKPq5uN6XdB2QzlnXGNBsioHiyVEcW0KTM7J4oJrIwYUnjJ
gl+caBR+xYMOJRfyG+bpIJTXR/05zGV93PRZC+pu4SXXEeBsvdIlCvoGUVkVZrSr
jdzS8d+kGE4f7Iz7qjTfdTHPK/JqXakmuc7P1xG9ecvs8AkLseyF/5p8bwbDTyC2
ouvTZz+AzUoqEN6XJI3N0KPKiREZHj4o5F6noJ3f6DVf7rtsn6v/hRezLQE0v6yp
Hk0V2FLtHr+1pcYvTep1Cc9hy/lkdbvzLk9Ui0VOok3nFPBLzdbqf8p9qkF675hb
Rbho5O0LvBDruvhLy92V2VFx7HXCJnre0G8ycnwcPXZbFNNAnLbsK9CObDcWdgwd
/FtGf6VRmFk1XLs/WbyeO9EZLgJZKfuWf9LJ0dr6YEuJEwM32wGjY/raN1FbMd2c
h3bKPtz4qlDr+0C3G4sbmYEl4SEoVtC+rferCWhi0w9Kk+x35jekD87b5Oed7g+b
reZkMH+HtYM/YYQw0Bp5
=NXtd
-----END PGP SIGNATURE-----

--------------enig077704081AED87C0E99423BF--
