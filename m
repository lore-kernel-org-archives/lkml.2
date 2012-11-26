Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab2KZKGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 05:06:09 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:40938 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab2KZKGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 05:06:07 -0500
Date: Mon, 26 Nov 2012 21:06:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>,
        Zhang Rui <rui.zhang@intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: linux-next: manual merge of the arm-soc tree with the thermal tree
Message-Id: <20121126210604.e8ae2a872b9a3d0e60609740@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Nov_2012_21_06_04_+1100_kc0Bg5p.CAcGsQPR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Nov_2012_21_06_04_+1100_kc0Bg5p.CAcGsQPR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/boot/dts/snowball.dts between commit dc1956b5f84d ("Thermal: Add
ST-Ericsson DB8500 thermal properties and platform data") from the
thermal tree and commit 809efa565a83 ("ARM: ux500: Move regulator-name
properties out to board DTS files") from the arm-soc tree.

I fixed it up (I think - see below) and can carry the fix as necessary (no =
action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/boot/dts/snowball.dts
index c6f85f0,9e02a91..0000000
--- a/arch/arm/boot/dts/snowball.dts
+++ b/arch/arm/boot/dts/snowball.dts
@@@ -211,8 -184,136 +211,140 @@@
  			};
  		};
 =20
 +		cpufreq-cooling {
 +			status =3D "okay";
 +		};
++
+ 		prcmu@80157000 {
+ 			db8500-prcmu-regulators {
+ 				db8500_vape_reg: db8500_vape {
+ 					regulator-name =3D "db8500-vape";
+ 				};
+=20
+ 				db8500_varm_reg: db8500_varm {
+ 					regulator-name =3D "db8500-varm";
+ 				};
+=20
+ 				db8500_vmodem_reg: db8500_vmodem {
+ 					regulator-name =3D "db8500-vmodem";
+ 				};
+=20
+ 				db8500_vpll_reg: db8500_vpll {
+ 					regulator-name =3D "db8500-vpll";
+ 				};
+=20
+ 				db8500_vsmps1_reg: db8500_vsmps1 {
+ 					regulator-name =3D "db8500-vsmps1";
+ 				};
+=20
+ 				db8500_vsmps2_reg: db8500_vsmps2 {
+ 					regulator-name =3D "db8500-vsmps2";
+ 				};
+=20
+ 				db8500_vsmps3_reg: db8500_vsmps3 {
+ 					regulator-name =3D "db8500-vsmps3";
+ 				};
+=20
+ 				db8500_vrf1_reg: db8500_vrf1 {
+ 					regulator-name =3D "db8500-vrf1";
+ 				};
+=20
+ 				db8500_sva_mmdsp_reg: db8500_sva_mmdsp {
+ 					regulator-name =3D "db8500-sva-mmdsp";
+ 				};
+=20
+ 				db8500_sva_mmdsp_ret_reg: db8500_sva_mmdsp_ret {
+ 					regulator-name =3D "db8500-sva-mmdsp-ret";
+ 				};
+=20
+ 				db8500_sva_pipe_reg: db8500_sva_pipe {
+ 					regulator-name =3D "db8500_sva_pipe";
+ 				};
+=20
+ 				db8500_sia_mmdsp_reg: db8500_sia_mmdsp {
+ 					regulator-name =3D "db8500_sia_mmdsp";
+ 				};
+=20
+ 				db8500_sia_mmdsp_ret_reg: db8500_sia_mmdsp_ret {
+ 					regulator-name =3D "db8500-sia-mmdsp-ret";
+ 				};
+=20
+ 				db8500_sia_pipe_reg: db8500_sia_pipe {
+ 					regulator-name =3D "db8500-sia-pipe";
+ 				};
+=20
+ 				db8500_sga_reg: db8500_sga {
+ 					regulator-name =3D "db8500-sga";
+ 				};
+=20
+ 				db8500_b2r2_mcde_reg: db8500_b2r2_mcde {
+ 					regulator-name =3D "db8500-b2r2-mcde";
+ 				};
+=20
+ 				db8500_esram12_reg: db8500_esram12 {
+ 					regulator-name =3D "db8500-esram12";
+ 				};
+=20
+ 				db8500_esram12_ret_reg: db8500_esram12_ret {
+ 					regulator-name =3D "db8500-esram12-ret";
+ 				};
+=20
+ 				db8500_esram34_reg: db8500_esram34 {
+ 					regulator-name =3D "db8500-esram34";
+ 				};
+=20
+ 				db8500_esram34_ret_reg: db8500_esram34_ret {
+ 					regulator-name =3D "db8500-esram34-ret";
+ 				};
+ 			};
+=20
+ 			ab8500@5 {
+ 				ab8500-regulators {
+ 					ab8500_ldo_aux1_reg: ab8500_ldo_aux1 {
+ 						regulator-name =3D "V-DISPLAY";
+ 					};
+=20
+ 					ab8500_ldo_aux2_reg: ab8500_ldo_aux2 {
+ 						regulator-name =3D "V-eMMC1";
+ 					};
+=20
+ 					ab8500_ldo_aux3_reg: ab8500_ldo_aux3 {
+ 						regulator-name =3D "V-MMC-SD";
+ 					};
+=20
+ 					ab8500_ldo_initcore_reg: ab8500_ldo_initcore {
+ 						regulator-name =3D "V-INTCORE";
+ 					};
+=20
+ 					ab8500_ldo_tvout_reg: ab8500_ldo_tvout {
+ 						regulator-name =3D "V-TVOUT";
+ 					};
+=20
+ 					ab8500_ldo_usb_reg: ab8500_ldo_usb {
+ 						regulator-name =3D "dummy";
+ 					};
+=20
+ 					ab8500_ldo_audio_reg: ab8500_ldo_audio {
+ 						regulator-name =3D "V-AUD";
+ 					};
+=20
+ 					ab8500_ldo_anamic1_reg: ab8500_ldo_anamic1 {
+ 						regulator-name =3D "V-AMIC1";
+ 					};
+=20
+ 					ab8500_ldo_amamic2_reg: ab8500_ldo_amamic2 {
+ 						regulator-name =3D "V-AMIC2";
+ 					};
+=20
+ 					ab8500_ldo_dmic_reg: ab8500_ldo_dmic {
+ 						regulator-name =3D "V-DMIC";
+ 					};
+=20
+ 					ab8500_ldo_ana_reg: ab8500_ldo_ana {
+ 						regulator-name =3D "V-CSI/DSI";
+ 					};
+ 				};
+ 			};
+ 		};
  	};
  };

--Signature=_Mon__26_Nov_2012_21_06_04_+1100_kc0Bg5p.CAcGsQPR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQsz8MAAoJEECxmPOUX5FEpzIP/2E3VexAgrensehCgrQVIeGw
7tQDWpxS7J59L8sUQBipdaCHqmAu4X0b8y51H58R+VRWmUtwwUZK0i43v4CakCF4
mN8wve5lx+5dEtOX/aJZiGQC0nki8c4mqh6+SPaQDE00Qo5o7YND9HnNk5pjjl71
yt56iRzUdnve+O+R8/8vpdFx/f9XZsH4NPP+xBLaNvTrjRNbrYBQDegtMPVVoygp
Cuf0gSopxYX6KaqYOc4ilL0c2d3HW8EzFjHcctANVi/Xea4uASOx14EFdg59AtPV
4MMt7dnE/XRsSQslkvgFAUcW/qn2tVy+50PQDenyuAxIAya/p0QwK26Gxc5Y7pts
a6FuSIJ0jliVGbLKYrdCnIPKyRAhfmCFXnOgyDAyzb5p1yIx/9JXMBMFD3V0SL0u
mTt9Bl3GI78PAD3I8W6ZqJeJdEJFPpUbWXY2nqNjU0Xm8tQeSWaxCk6gn9uGtxQs
er6VEvi8FMb5fwUdhQQ+HhzkGaGbSyka2FEYRg87WrPBgJM73MqUMGaf8Lyxc+hp
x5azacoA+umc2fcqrXSIbomZ7pFY2AchqTTbUCXBKiltAHNkodtvrceei42eBKrM
Yxad6nndwqqqLSBNhJkmZC3QghdD1kFZtY8INsZKV963ZedNxZN9gJMq60cU9qqG
mw2DOZoIXNo7XCGLxNjv
=XqZH
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Nov_2012_21_06_04_+1100_kc0Bg5p.CAcGsQPR--
