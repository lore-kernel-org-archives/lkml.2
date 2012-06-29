Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab2F2MdN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 08:33:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:41279 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab2F2MdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 08:33:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="171616826"
Message-ID: <1340973434.3070.168.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v10] MTD: LPC32xx MLC NAND driver
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Roland Stigge <stigge@antcom.de>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        dwmw2@infradead.org, kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org, hechtb@googlemail.com,
        lars@metafoo.de, b32955@freescale.com, leiwen@marvell.com,
        linux@arm.linux.org.uk,
        Alexandre Pereira da Silva <aletes.xgr@gmail.com>
Date: Fri, 29 Jun 2012 15:37:14 +0300
In-Reply-To: <1340834129-15545-1-git-send-email-stigge@antcom.de>
References: <1340834129-15545-1-git-send-email-stigge@antcom.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-7TXNPLOt3GGaK5PgQkkW"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7TXNPLOt3GGaK5PgQkkW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-06-27 at 23:55 +0200, Roland Stigge wrote:
> This patch adds a driver for the MLC NAND controller of the LPC32xx SoC.
>=20
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> Signed-off-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
> ---

Aiaiai complains like this about your patch, please, take a look:

---------------------------------------------------------------------------=
-----

Successfully built configuration "arm-lpc32xx_defconfig,arm,arm-unknown-lin=
ux-gnueabi-", results:

--- before_patching.log
+++ after_patching.log
@@ @@
+drivers/mtd/nand/lpc32xx_mlc.c: In function 'lpc32xx_nand_probe':
+drivers/mtd/nand/lpc32xx_mlc.c:679:10: warning: variable 'sr' set but not =
used [-Wunused-but-set-variable]
+drivers/mtd/nand/lpc32xx_mlc.c:561:24: error: bad constant expression [spa=
rse]

---------------------------------------------------------------------------=
-----

checkpatch.pl has some complaints:

---------------------------------------------------------------------------=
-----

checkpatch.pl results for patch "[PATCH] MTD: LPC32xx MLC NAND driver"

ERROR:INITIALISED_STATIC: do not initialise statics to 0 or NULL
#339: FILE: drivers/mtd/nand/lpc32xx_mlc.c:224:
+static int use_dma =3D 0;

total: 1 errors, 0 warnings, 1004 lines checked

---------------------------------------------------------------------------=
-----

--=20
Best Regards,
Artem Bityutskiy

--=-7TXNPLOt3GGaK5PgQkkW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP7aF6AAoJECmIfjd9wqK0uK0QANHL+nDb/HHhOgJHSMYuqUHa
6eVlnK1U6wde8BDLy3fDPKokLW85HjzVth54qvlZ2nra57mg+5xv32TtZNyhCjfA
xau50pFDx2ifkSkHHv1y/KSB4E84lMUa/sPUFpJ8ojuxrQ8YRfPmQEEl6eO9CaxX
qKcnGnGjrMXTNNqSl7BGbsCX5blc6/6IQxWRTMIg9vZ7tO7VTdJTwvFPzcsbsbBk
NcivLZvBZUDLaMj9Q0XgXMbWUbFVSPQ5aqCG3YCjijl/v/1SBp3hZ/QfAdY//Cyk
2T4sI6ZtNjwiB7ZRwOXdYBMcpBjETGHAnhfq3TTLcWPOxrcPZ8/DQKTMlQ3nFogm
kYEIvtF6v5nl0YBUjHtggYvqQcN7sWupk7pU47J9M682ZlJNuMQO6PnvgouKagyz
K3Owg5HmllqSh8xwb34UFnqQhnmhSA4RczTfTlpeeGXna45Wb7vmGY91HXQS1GIb
ewJ6jPlAZDbJg9jpbgc0msJ6WbA146BBh0DMSYWb8sVv5NMVeDMGi8icDUqEOqpk
BbbK9IreZK0nxtXK/FRmGexdYuqdWeLclRgXm3G5GJIxL0I9QIXDOKDmiH90Go3u
pjeNmc6qzNxYOc2HI26UB8iAboq53T6skCOy+nKYTxC1HXehgclkWw7NaGEbUGmx
cO+ULa+Jpa/w7G2kOnPl
=o0wx
-----END PGP SIGNATURE-----

--=-7TXNPLOt3GGaK5PgQkkW--

