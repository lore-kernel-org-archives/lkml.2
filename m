Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646Ab2J3MlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 08:41:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41213 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756795Ab2J3MlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 08:41:12 -0400
Date: Tue, 30 Oct 2012 14:35:15 +0200
From: Felipe Balbi <balbi@ti.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        <linux-kernel@vger.kernel.org>, spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH 2/3] dma: move dw_dmac driver to an own directory
Message-ID: <20121030123515.GE29095@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1351600332-29443-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1351600332-29443-3-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N1GIdlSm9i+YlY4t"
Content-Disposition: inline
In-Reply-To: <1351600332-29443-3-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--N1GIdlSm9i+YlY4t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 30, 2012 at 02:32:11PM +0200, Andy Shevchenko wrote:
> The dw_dmac driver contains multiple files. To make a management of them =
more
> convenient move it to an own directory.
>=20
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Felipe Balbi <balbi@ti.com>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/dma/Makefile                |    3 +--
>  drivers/dma/dw/Makefile             |    2 ++
>  drivers/dma/{ =3D> dw}/dw_dmac.c      |    2 +-
>  drivers/dma/{ =3D> dw}/dw_dmac_pci.c  |    0
>  drivers/dma/{ =3D> dw}/dw_dmac_regs.h |    0
>  5 files changed, 4 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/dma/dw/Makefile
>  rename drivers/dma/{ =3D> dw}/dw_dmac.c (99%)
>  rename drivers/dma/{ =3D> dw}/dw_dmac_pci.c (100%)
>  rename drivers/dma/{ =3D> dw}/dw_dmac_regs.h (100%)
>=20
> diff --git a/drivers/dma/Makefile b/drivers/dma/Makefile
> index 15eef5f..122a48a 100644
> --- a/drivers/dma/Makefile
> +++ b/drivers/dma/Makefile
> @@ -11,8 +11,7 @@ obj-$(CONFIG_INTEL_IOP_ADMA) +=3D iop-adma.o
>  obj-$(CONFIG_FSL_DMA) +=3D fsldma.o
>  obj-$(CONFIG_MPC512X_DMA) +=3D mpc512x_dma.o
>  obj-$(CONFIG_MV_XOR) +=3D mv_xor.o
> -obj-$(CONFIG_DW_DMAC) +=3D dw_dmac.o
> -obj-$(CONFIG_DW_DMAC_PCI) +=3D dw_dmac_pci.o
> +obj-$(CONFIG_DW_DMAC) +=3D dw/

this is wrong, I guess. If you want dw_dmac_pci.o to be statically
built-in, but dw_dmac.o to be a dynamic module, according to this
Makefile entry, dw_dmac_pci.o will be linked to vmlinux.

--=20
balbi

--N1GIdlSm9i+YlY4t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQj8mDAAoJEIaOsuA1yqRE3yAQAK1WajVFjZhR7X8cabw1l/yc
m2kl2i/dviUVhTL9HXBv6BAvIB4ZClAanB2eWISAF5Og+/qPO+VIxwU81xH0g17X
9Y2WSEOzyfmuRN9xRz1luNFdh74eNXpD9ytYHjqeZkJDqMRJwy68jpCqaLT0GFnU
tRBoP6RgEsL9WDt2U9geVIb5/AMBCkb84PnB7mvPOj6mEJIFiwZj9aFPLiqn1JqE
L8G08bbHfKxOFQvEsjWRA89MYp/Ee+jICOBbroPrsWQV9yEjCsouuUt+mDZVM/ft
BkrY57MIF1pEH/viwVUlAJCsWn8FXd2fUiFh21DIviZxF+icnPDKiMOaGteD7DJZ
EFrl/sdH4yueXL+KRi0xx7h/pB9nOJh1kspbVU58Kz88HnF1Wam8jCvzx4EzdAWp
fGeilFQ/0EDfLIPaT9kP68rjf2H3iy27+qjPeFwx5uYf3JDkDM46EauABzoXasx5
jpcUEYE4yv+iipypoS2nZ4/oqhoLB5HCFrdEbwvo4GT6fSAwJ61MTg9Jtc5i2n9h
HEayEYrLtt4XexYfl2uUukJ5VvYsUXw3kKXuhRdf2A0GXoiLYoYKv6f0Uf4WsWsJ
ZlZPOMMayCEhAxaateGNo+37R8xycrdAV5qCkGJx09Dm43X01K5g4ywbjosGitDR
YLj6MKFX4NQdWdAoCGZl
=4UMA
-----END PGP SIGNATURE-----

--N1GIdlSm9i+YlY4t--
