Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab2JBFNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 01:13:40 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54573 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab2JBFNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 01:13:38 -0400
Date: Tue, 2 Oct 2012 15:13:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: manual merge of the arm-soc tree with the spi-mb tree
Message-Id: <20121002151327.bff0573c41ce8d983c392820@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Oct_2012_15_13_27_+1000_/.Ctad6Cfgxg2jLS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Oct_2012_15_13_27_+1000_/.Ctad6Cfgxg2jLS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/spi/Kconfig between commit 536a53a300d0 ("spi: remove completely
broken Tegra driver") from the spi-mb tree and commit 5bd276118189 ("spi:
tegra: remove support of legacy DMA driver based access") from the
arm-soc tree.

I fixed it up (by removing the SPI_TEGRA section) and can carry the fix
as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__2_Oct_2012_15_13_27_+1000_/.Ctad6Cfgxg2jLS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQanf3AAoJEECxmPOUX5FE/b0P/2O6naknbkjZYwJE7TgfEIbv
VWO2ewMxTojA6q74M5YmGrpuu8HseJH/hAKhgVek8BYB0qvEWAWcf8F8I+W/mhr0
eQQeK5S5Jb5SsGGn/Y/eu4dc30GH0Fjtfwo5aZqOxIiAOVFZGVkjwoY7/NdgbHZB
C+buoL/E7LQzueiJZegUU6SIVOBUHUfLXFwlseNlI0cyk0I0y191CVxg7KlpWfJw
I2wOOFp34rn8kFgGOTsj6TAIhyYYB+FBEHpo8Z3MMyrGLxWs6UvgG2QX3Z4d9fuM
OTVVgUtY3rL0rzRGiyOe9iE6Fu2DrEA6QU9oExWPV5F2VwRHBHH+XHLdeAeBBMpD
K4LS3RWMpvVx+KCMibozSeONPSnt2Gfei0QF//5h4ZQic/WZjhhJDGguTDfOxDFL
L+F6ZrXzb+Z5DION3tMSDYXyUIVNw7v+QqkT06i56I28x+T6xfGmQF1yAEX7Kjq1
QVPHvQeafdt/XJWyC3i/mHDy2J5zEPhWHPWL9ELVrDvSoEIJbYehWQoCpjlcD2r5
qZJ2hIPGMTf+8xYpriDn0Y3QfIT/lkwMlodZJCfPXDRPwpMtdrFru5H0XE7xmSJl
+y1Oh7sTRy+jDzNNDU51Iy7sTsN3iYxOX4ormLFhkL6SKBL7vMLH/kaafKJw6A/0
OjFCO6tO3n6jlzJSd1zX
=N0Jj
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Oct_2012_15_13_27_+1000_/.Ctad6Cfgxg2jLS--
