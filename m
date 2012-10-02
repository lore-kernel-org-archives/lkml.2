Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752194Ab2JBFSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 01:18:07 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48673 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491Ab2JBFSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 01:18:05 -0400
Date: Tue, 2 Oct 2012 15:18:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: manual merge of the arm-soc tree with the spi-mb tree
Message-Id: <20121002151802.9afb32b096a0fbc29c5a5496@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Oct_2012_15_18_02_+1000_M/zmkcOr.XA9N.lv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Oct_2012_15_18_02_+1000_M/zmkcOr.XA9N.lv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/spi/spi-tegra.c between commit 536a53a300d0 ("spi: remove
completely broken Tegra driver") from the spi-mb tree and commit
5bd276118189 ("spi: tegra: remove support of legacy DMA driver based
access") from the arm-soc tree.

I removed the file and can carry the fix as necessary (no action is
required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__2_Oct_2012_15_18_02_+1000_M/zmkcOr.XA9N.lv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQankKAAoJEECxmPOUX5FE7P0P/R9vQshunkjuHe04OyLt3DQY
XjJ3uS18XIkgHvP0XEXN/3TD1O+nKn2vbkbbySfnUhaoNLvxoHbat5+RZT5pwXkN
OmEVZs5AizgUnq5Zo13YvS96HEgHbPEY9FqAVcbMT6pl3eimOxlPijYVOxx7sOtd
t1+nCl50hkSrNIii/FNtM9O/dVIjAbYvmO5AeSgZlhQhYaGq3jOC3QPDQZbaRcv/
E97Of8TNqinMQxcnyVaPuR7Y8/t54J1pxfiOBfX8r0X7qqIHnLbZr2Llz6zwK4fD
ubMTsxBJ8ufXYNTwVD+tx/qwXY4gfpUAfGbMdc5ZEhdz3yyjrIHfO0PzVKL/pxNV
hwAAt265CU/COUL9KnT9JqLhw2lw2yxFSrVxJsxue7co8pumTaqL7haj4M53XJxD
M4Q+6w9fEq78FDD8srVo2w2ysOXa4MftvSSYw6RFRklYNvpjTwa7iv4vc9H31tYO
SkdUTvdSXgSIHeg5ouXUqcaZs5RcVjTGq0/8cgaHUeOpEpGynh3tFiObrGltvugv
HRdiMA3POjYtjAgZqe4Zl1w2pfxEvCWUS/2orA+w3ueyn0UI+oJSIlwJnk4Q5WQl
zhGVEi4G+fW15PW0Obfr9dK41SZACufEw6mZjelT34LCk4h7oa0Pcj3BehPIgrnq
zcWhnnc7ZEH9t0uSIhIs
=NHyx
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Oct_2012_15_18_02_+1000_M/zmkcOr.XA9N.lv--
