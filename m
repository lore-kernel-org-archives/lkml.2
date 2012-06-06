Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab2FFNhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 09:37:53 -0400
Received: from mga14.intel.com ([143.182.124.37]:6680 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173Ab2FFNhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 09:37:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="asc'?scan'208";a="152342511"
Message-ID: <1338990096.6875.52.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v6] MTD: LPC32xx SLC NAND driver
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Roland Stigge <stigge@antcom.de>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        dwmw2@infradead.org, kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org, hechtb@googlemail.com,
        lars@metafoo.de, b32955@freescale.com, leiwen@marvell.com,
        linux@arm.linux.org.uk
Date: Wed, 06 Jun 2012 16:41:36 +0300
In-Reply-To: <1338974414-5308-1-git-send-email-stigge@antcom.de>
References: <1338974414-5308-1-git-send-email-stigge@antcom.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-4702nwg7fga9mZeThSKX"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4702nwg7fga9mZeThSKX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-06-06 at 11:20 +0200, Roland Stigge wrote:
>  drivers/mtd/nand/lpc32xx_nand_slc.c                   | 1060 +++++++++++=
+++++++

Can you please rename it to lpc32xx_slc.c? It is already in the "nand"
sub-directory, no need to add "nand" to the file name.

--=20
Best Regards,
Artem Bityutskiy

--=-4702nwg7fga9mZeThSKX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPz14QAAoJECmIfjd9wqK0V6oQANCYRPLO5K9qalkxC83P9V+A
2LYCUIaXWs0zvNT/Ho+8M+faTu+pBHMlDsknaiG6IaX/uj9AgD/M+pGD4t6A3MgA
OUHtFZhEXEStAak87n5Nfa8+GjDsDGoLfIalhc4LWXTAxlzExcB2+DEdY9xpQtKR
YjplXhEedBbuLEMMp88uX8nLzFvFTQdf888EGLs18N2RqrYy/vVcspGVCmqUYCmo
oglv3tRxS6yCpfHqwv6L8h/lWq29xOmOObQZXzJzMrC6/0t3yRvOTppmsaOMFIiH
WoxhZpC3lvCyyf2qN3Yp0Cpu3FLHVU75vhTYjptiXkugpx7Q69AUIbnJf9L169wN
bONf+iqwxAzbkHmiTxwAOAt/GQSDL4Zl5LZVk6ywxInFpK4YrRwfcclfX/ZEXhGR
Fm7diq2Ng7Vo9ZZClHziatTfcq6FlFGykoMCQrGm4vk3Ck2cUlyHuIfhyQ424nUZ
HL2B+eJk/QVQAcVONXZjeeGwbSWkd8ew7FlGV34OLljdLza7kkkD1gCdrwaRy15p
QjdNipn90vlFtBBReI//ynExJaRog57tZNGZ9guAsfDwWtvDgPKnaOzSfC94cc0B
UeZPXVOD16yoTaCHWI0zNz50X2SQx+dWeNYGXcxjpJ/npWpwLVWJX6AmNYqMhRS1
Au7LogFVYeJysWE5mwlb
=7oQh
-----END PGP SIGNATURE-----

--=-4702nwg7fga9mZeThSKX--

