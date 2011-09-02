Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554Ab1IBIVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 04:21:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42134 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932488Ab1IBIVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 04:21:39 -0400
Date: Fri, 2 Sep 2011 10:21:34 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sascha Hauer <kernel@pengutronix.de>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] dmaengine i.MX DMA/SDMA: add missing include of
 linux/module.h
Message-ID: <20110902082134.GC1901@pengutronix.de>
References: <1314688104.23734.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jousvV0MzM2p6OtC"
Content-Disposition: inline
In-Reply-To: <1314688104.23734.1.camel@phoenix>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jousvV0MzM2p6OtC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 30, 2011 at 03:08:24PM +0800, Axel Lin wrote:
> Add missing include of linux/module.h to fix build error.
>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Sascha is on holiday, so please accept my:

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

> ---
>  drivers/dma/imx-dma.c  |    1 +
>  drivers/dma/imx-sdma.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
> index d99f71c..d746899 100644
> --- a/drivers/dma/imx-dma.c
> +++ b/drivers/dma/imx-dma.c
> @@ -14,6 +14,7 @@
>   * http://www.gnu.org/copyleft/gpl.html
>   */
>  #include <linux/init.h>
> +#include <linux/module.h>
>  #include <linux/types.h>
>  #include <linux/mm.h>
>  #include <linux/interrupt.h>
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index b5cc27d..eab1fe7 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -18,6 +18,7 @@
>   */
> =20
>  #include <linux/init.h>
> +#include <linux/module.h>
>  #include <linux/types.h>
>  #include <linux/mm.h>
>  #include <linux/interrupt.h>
> --=20
> 1.7.4.1
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--jousvV0MzM2p6OtC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk5gkg4ACgkQD27XaX1/VRuNjwCgpqzaDNYxvXpYcoA2dwCtf4a9
XfgAn3pvPvD28WzGHad3SIVWZ2Nvdbaw
=sv5E
-----END PGP SIGNATURE-----

--jousvV0MzM2p6OtC--
