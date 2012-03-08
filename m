Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab2CHGcy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 01:32:54 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48388 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2CHGcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 01:32:51 -0500
Date: Thu, 8 Mar 2012 17:32:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Philip A. Prindeville" <philipp@redfish-solutions.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20120308173244.2100f2f8eff02e303023d30f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__8_Mar_2012_17_32_44_+1100_SrPOLZK3H_fi6mio"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Mar_2012_17_32_44_+1100_SrPOLZK3H_fi6mio
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
arch/x86/Kconfig between commit da4e3302949f ("x86/geode/net5501: Add
platform driver for Soekris Engineering net5501") from the tip tree and
commit "geos: platform driver for Geos and Geos2 single-board computers"
from the akpm tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/Kconfig
index 97a7a56,a985f6b..0000000
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@@ -2151,12 -2151,13 +2151,19 @@@ config ALI
 =20
  	  Note: You have to set alix.force=3D1 for boards with Award BIOS.
 =20
 +config NET5501
 +	bool "Soekris Engineering net5501 System Support (LEDS, GPIO, etc)"
 +	select GPIOLIB
 +	---help---
 +	  This option enables system support for the Soekris Engineering net5501.
 +
+ config GEOS
+ 	bool "Traverse Technologies GEOS System Support (LEDS, GPIO, etc)"
+ 	select GPIOLIB
+ 	depends on DMI
+ 	---help---
+ 	  This option enables system support for the Traverse Technologies GEOS.
+=20
  endif # X86_32
 =20
  config AMD_NB

--Signature=_Thu__8_Mar_2012_17_32_44_+1100_SrPOLZK3H_fi6mio
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWFKMAAoJEECxmPOUX5FEE4UP/0lynv6JWBoMDXzNGxAHlHSF
vkDvk+k7zvS3EXe6+8SF7l+HsgtEXdqBZAA4BbBQhDZo5/7OuSqWdMnN/14+GR79
oI8Ligb1b1IEkGPZJPOjqBvqJ70AnT0+YQ58Noao2RxT4J5HNkKK2FTB59oZnoAm
BlJOKaL2KQhke0ZyN9Of5if40HsrWDX495ccVXS+dlYoJWINHHQGm3vlJmK3NBVY
KCM+U9gSH0f1yzfm7oyyn+XZQnTVbcBtQRWuYnarGyYGW3aWQbr0nzAFKgCnEXCB
zrouIhZsLT4WBQCbYegBR7iMr2k/fGkZWSHOWW7yZwOxtwzmeT0xlnNPgrUeIpRm
XROnbbRTXUZaXs4w3p1x5GhJFcaVINnKr/KrosKqWbRZNPadLh6XIOQuAR32vszX
OrNSzGcfmVpgbDYubae2MpxqNOU9IwS6MFPnIhWb4uYEztX8z2I5hS3wfH4rz8jY
6XfWd60EomlDMSy++JQ2B/SezNcV3694qt/7rn8MyGFl4jWpoGGn1Nuwtx3U5CGX
2eLKd6P0v0UJSSWW/KSUbsaUcS+Wf8nxPiF+X88GhYI+a6eUyx751mv7thqD0N5D
T13ODk7D3KGXkASE9GvujxAUpn9FHtJ9fu88KjFW3+EtIqhs8ids1ZTMpgNGYH2G
4KnC9EN+xj8/0C05gffN
=hCTK
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Mar_2012_17_32_44_+1100_SrPOLZK3H_fi6mio--
