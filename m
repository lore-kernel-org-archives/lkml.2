Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718Ab2GYBS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 21:18:59 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45124 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab2GYBS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 21:18:57 -0400
Date: Wed, 25 Jul 2012 11:18:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: linux-next: manual merge of the mfd tree with Linus' tree
Message-Id: <20120725111855.bd9553a735807afa0bd03821@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__25_Jul_2012_11_18_55_+1000_eFvyyu7J=M2VId.2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__25_Jul_2012_11_18_55_+1000_eFvyyu7J=M2VId.2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

Today's linux-next merge of the mfd tree got a conflict in
arch/arm/configs/tegra_defconfig between commit dbebe1589d3a ("ARM:
tegra: defconfig updates") from Linus' tree and commit 05f3ad2b8ae5
("ARM: tegra: defconfig: Enable tps6586x gpio") from the mfd tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/configs/tegra_defconfig
index 4be9c1e,7c0d115..0000000
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@@ -105,7 -106,7 +105,8 @@@ CONFIG_I2C_MUX_PINCTRL=3D
  CONFIG_I2C_TEGRA=3Dy
  CONFIG_SPI=3Dy
  CONFIG_SPI_TEGRA=3Dy
+ CONFIG_GPIO_TPS6586X=3Dy
 +CONFIG_GPIO_TPS65910=3Dy
  CONFIG_POWER_SUPPLY=3Dy
  CONFIG_BATTERY_SBS=3Dy
  CONFIG_SENSORS_LM90=3Dy

--Signature=_Wed__25_Jul_2012_11_18_55_+1000_eFvyyu7J=M2VId.2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQD0l/AAoJEECxmPOUX5FEkG8P/3q8609RcrJEEzNpUrfiM2p1
9ayVMdHU7b2pv8uLG8tVWPy8Y4OQRv8I8nEJLc5vvrU99djk78BCnMXC2ztmPru4
85U98YdAxd2eFT5X/yUD6at0iVEJhsjVGhqK9DiBtwYusLsmeS9beXogCUd/ZgfF
P0kdaPtEhLALG9OG6pD4jPXTGLP1FI/X41TetKH4EHf2s942bZHxc3tG/0h1Sghg
RNWV64LgOqtbwaxmBZ3XWXu8VuUeFSbZwATZnSw2r6OlExX0CAlsnBFzpM3B7rrR
kj7UXwNZAi+RpW+dHFCLn1qLH9i76Jzrf9xuXyyA/4VU124Fk2oeGl6bwYkOr5Vn
pBZTfk++91zJYkcAggg97oi73W6kP5z8AulNJZ6IjbGz0Y+ZCfYb3XiTHM3gDnRU
TAMmAwcvv3QWAicfvnCOCJf6INqWTOHqOc7Gh1hU8DuEq0Y4cDmBSu7DNSWllMfb
65JDfOkIe84ZqrVoCH+vc1ZjxyUCJCXL9ByLPkj0czuJI0BVYJQSlTfgxdrsJxwZ
xL8LK0NsGvmt4Nu+UxH4MxSkYh/8xJ3yh54yMGPu+PybBBzTC1HZCw1lMHujwF3y
eapbHQyFdqedjr76uZEgib8IjH9nl7EE1aWu6rbHlNSPQQaGNaUJ0I1o4poz2jw0
VYuggZqTlcbLLXW7ughI
=0DmF
-----END PGP SIGNATURE-----

--Signature=_Wed__25_Jul_2012_11_18_55_+1000_eFvyyu7J=M2VId.2--
