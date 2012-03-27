Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab2C0Ap5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 20:45:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52115 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab2C0Ap4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 20:45:56 -0400
Date: Tue, 27 Mar 2012 11:45:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martin <javier.martin@vista-silicon.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: manual merge of the slave-dma tree with Linus' tree
Message-Id: <20120327114545.031deecd5fb48267b56b9b2c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Mar_2012_11_45_45_+1100_.x/hlNF9qUB2Vbdh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Mar_2012_11_45_45_+1100_.x/hlNF9qUB2Vbdh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vinod,

Today's linux-next merge of the slave-dma tree got a conflict in
arch/arm/mach-imx/Kconfig between commit 3c77c29c49c6 ("ASoC: imx: move
audmux driver into sound/soc/imx") from Linus' tree and commit
6bd081277ea0 ("dmaengine: imx-dma: merge old dma-v1.c with imx-dma.c")
from the slave-dma tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-imx/Kconfig
index 3919fba,3da1421..0000000
--- a/arch/arm/mach-imx/Kconfig
+++ b/arch/arm/mach-imx/Kconfig
@@@ -46,7 -30,7 +42,6 @@@ config SOC_IMX2
  	bool
  	select MACH_MX21
  	select CPU_ARM926T
- 	select IMX_HAVE_DMA_V1
 -	select ARCH_MXC_AUDMUX_V1
  	select IMX_HAVE_IOMUX_V1
  	select MXC_AVIC
 =20
@@@ -61,7 -46,7 +56,6 @@@ config SOC_IMX2
  	bool
  	select MACH_MX27
  	select CPU_ARM926T
- 	select IMX_HAVE_DMA_V1
 -	select ARCH_MXC_AUDMUX_V1
  	select IMX_HAVE_IOMUX_V1
  	select MXC_AVIC
 =20

--Signature=_Tue__27_Mar_2012_11_45_45_+1100_.x/hlNF9qUB2Vbdh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPcQ25AAoJEECxmPOUX5FEojcP/1To0BwbZQ1Ak4lwbq+8XN6q
6x4eLgMQnIqONEkHGnY9P46EZyqTvbS6V0cLk+hK0Ctmu/RK1iWgmOSH8LrLdv+z
9fzkQ+o53H3Pl2Az7DDfNCBn1g8LPYIpQMD6cBe4sD/1aZh5eaIWfqDqMEOmSLhh
D38ODxHfNj+ujVVy3YKfcVf9nIigClmjIgqbyvE36+ZJvDMkRQx5Nz8YSMNaW6Va
xPl9ECM4NsQDKG2jk7vUB4xfLvQ3L5dEFQ4hlDk8Lk0KNlFgqjLzjduQUF/mcNdV
GUS5aEAkAN+jM01i5xHkjNh+ib2P6PaDW3gEgynJ1yjGhCIWwMKIz0aQM+vGx8lT
ah8yCZJg9aKXYRjDbqWT+W69QkKlbYRFjLH33vH158v3NsEt5JRRXGJ3Bgj6xkxm
2sMPSxkdVXfnZ1Pckv6zFp2CCQq9eI3eSTc4pakexgvs4CC/Pg+6rm5FmO/ZFH9n
pgChJ9033tv8JAWWaBCyrOweyrql20ASt8q/TAr39zgdGXN+nkepoAEJTSCOK3NW
rDaVLD2x8smBtPL1DLDEVJEQl8tjZeVEyL/mTqhxOgoEu9kP+n7yliEEsMCoghms
rEDZyOkZazqHDbNz8OG/4ReMBD/beSDYWl148VyYNvvh8EVHEwwHkE7TUhIdlKFR
tTGx/A8q7nOGi7ebZKMp
=XfEs
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Mar_2012_11_45_45_+1100_.x/hlNF9qUB2Vbdh--
