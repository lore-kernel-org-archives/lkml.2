Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab2IXJoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 05:44:16 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34753 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab2IXJoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 05:44:15 -0400
Date: Mon, 24 Sep 2012 19:44:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Vinod Koul <vinod.koul@linux.intel.com>
Subject: linux-next: manual merge of the arm-soc tree with the slave-dma
 tree
Message-Id: <20120924194413.87981dcbe729777af104d2c5@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Sep_2012_19_44_13_+1000_TrRU=8J1h_aeCzUD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Sep_2012_19_44_13_+1000_TrRU=8J1h_aeCzUD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/spi/spi-davinci.c between commit 048177ce3b39 ("spi: spi-davinci:
convert to DMA engine API") from the slave-dma tree and commit
ec2a0833e515 ("ARM: davinci: move platform_data definitions") from the
arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/spi/spi-davinci.c
index c1ec52d,3afe2f4..0000000
--- a/drivers/spi/spi-davinci.c
+++ b/drivers/spi/spi-davinci.c
@@@ -32,7 -30,8 +32,7 @@@
  #include <linux/spi/spi_bitbang.h>
  #include <linux/slab.h>
 =20
- #include <mach/spi.h>
+ #include <linux/platform_data/spi-davinci.h>
 -#include <mach/edma.h>
 =20
  #define SPI_NO_RESOURCE		((resource_size_t)-1)
 =20

--Signature=_Mon__24_Sep_2012_19_44_13_+1000_TrRU=8J1h_aeCzUD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYCttAAoJEECxmPOUX5FEuEEP/R2tAqIEj9iUULxWQsV+5Yla
20uS1sInRtTZLIjm7CO39I2PLxvYZtA0F0M4xU08AJVB5mxUUjsZkQNH56WpjGPz
oDBILTCirTTlz7uHoXUqIBphmSaQ7qhUv5w53RyHGIdXrIUmgRKXkZ+YNfcRIoUq
TedIxJTpUF/ahvLT4MaVerZlaAmQXF7L7VUXEoGpH3Os307nyGHdA4pImfhQA4qU
xOsfswmYdyVRVxivSfpsGYROyjlKG7NQrIRTYZ5sQo44ZU1uudvOypG6T1+yK86r
oh/HbTXfOtT4mI0Kb68Q3RFZ/z9n7kP/GA+HT/87if6EbxT7/cQ38kGy7VRbltPN
NIggASomYOnO3RK0j7BdtxRVYnwsLSNS4a4Dj/sARUrwqdcJvN9stetyCPEfP2Vi
t6G0DXrdQ0/FqBlbL4fY3C2khtF2JiW72/BOvXC/ypaYWnScbvrO49rrc1S+Un2g
6XqcSrazCo/5SMNFC0fVGTNbR4lxPlFIZlm44vfnuk7PJZCiI290QRv92sE9ty1i
SrNqvlatsz0DDHb0El+z/O5vp0HyzOdxVAtVwWRg9oJY1l1/ZUn1ow26Xs7VMRR7
bQU4TcRmUw65zM3LtfxKqm/6rJrSXchpdIVcbzqJOnnJ5OBXq1bdgKFtWgyPmE9L
OjpSmj4LTtmQmMOSNUcS
=UztF
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Sep_2012_19_44_13_+1000_TrRU=8J1h_aeCzUD--
