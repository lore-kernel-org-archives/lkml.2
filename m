Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250Ab2KMEUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 23:20:41 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53222 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab2KMEUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 23:20:39 -0500
Date: Tue, 13 Nov 2012 15:20:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>, Felipe Balbi <balbi@ti.com>,
        Greg KH <greg@kroah.com>,
        "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>
Subject: linux-next: manual merge of the arm-soc tree with the usb tree
Message-Id: <20121113152029.9bcfc18a4bca8dc53a033a86@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Nov_2012_15_20_29_+1100_SW37Rv1PGQXipBDW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Nov_2012_15_20_29_+1100_SW37Rv1PGQXipBDW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in arch/arm/con=
figs/stamp9g20_defconfig between commit 77614e025061 ("arch: Change defconf=
igs to point to g_mass_storage") from the usb tree and commit 2484575268e2 =
("arm: at91: drop machine defconfig") from the arm-soc tree.

The latter deleted the file so I did that and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__13_Nov_2012_15_20_29_+1100_SW37Rv1PGQXipBDW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQocqNAAoJEECxmPOUX5FEM7AP/3tCMLUIAdfXpTiD++v5DutE
4Tt6GMLSjISO28e1NTJVCw7U5vOAVv0+j4mp6CRtrZsaq5VBYIIdQbBvoeyKxzDd
2zNi88vprMGyxbuMjCd+KFCtD8X5MSxO6yBVmA077uvfbwhUNkcZPaC9HTys9qYJ
xgMNnxEjQu2QJkCM/MrmDH/ocnCuUO0SBOxHp1FJD0F5J2kZ6etnbMCQ16pyvf7H
UR9m+0v6akLYWw5sjHjo9RyT9nUI+06uXOkIZUXHryhcLvVBY4APJ6eEK+zOqc3V
PWv8Sh0ZYdCzxEReqsfb+mdrCydNnLW7m4Ni1grn0xRDTv2nW9qRsjeYe2sQlzuf
Gdb7dymMq2vuFOlD9H2in9scoEDz3Tbx6/vfwH0GszfeXSePqUuLBZffARheyDt5
rOpVLeN3GiButy3tfwif8OwLuImikwD0QXJMWydhORSkRcn/qFjVsLttHBL/lZ+R
Nx7RsvCMVcpLafzBTXz1Php/ldScLBvDCgHwDPpe07w946hWrx8zrcQIYky6kbng
IL+E6qPAgCINFom4Og0eLekASQfiaHG3UenZaoHPTtfiXV/HLzSTdfbJh6idKPuD
MoF9uMFqPuMlNyCCsbaAhGbay44DsO5d75gwJlW5d4RbQA9fOIgdqN7PZNjJbCZ/
NnJrmqPwlryy4ZYfFDII
=PT/4
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Nov_2012_15_20_29_+1100_SW37Rv1PGQXipBDW--
