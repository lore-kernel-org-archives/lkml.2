Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab2I1NEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 09:04:52 -0400
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:36067 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758196Ab2I1NEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 09:04:45 -0400
Date: Fri, 28 Sep 2012 15:59:30 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, balbi@ti.com
Subject: Re: [PATCH 4/6] usb: dwc3-omap: Add an API to write to dwc mailbox
Message-ID: <20120928125929.GM31006@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1348836795-4783-1-git-send-email-kishon@ti.com>
 <1348836795-4783-5-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sk71+Upln2BLuDmg"
Content-Disposition: inline
In-Reply-To: <1348836795-4783-5-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Sk71+Upln2BLuDmg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Sep 28, 2012 at 06:23:13PM +0530, Kishon Vijay Abraham I wrote:
> Add an API in the omap glue layer to write to the mailbox register which
> can be used by comparator driver(twl). To pass the detection of the attac=
hed
> device (signified by VBUS, ID) to the dwc3 core, dwc3 core has to write
> to the mailbox regiter.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/usb/dwc3/dwc3-omap.c  |   59 +++++++++++++++++++++++++++++++++++=
++++++
>  include/linux/usb/dwc3-omap.h |   30 +++++++++++++++++++++
>  2 files changed, 89 insertions(+)
>  create mode 100644 include/linux/usb/dwc3-omap.h
>=20
> diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
> index a1704c6..7ae4d73 100644
> --- a/drivers/usb/dwc3/dwc3-omap.c
> +++ b/drivers/usb/dwc3/dwc3-omap.c
> @@ -43,6 +43,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/platform_device.h>
>  #include <linux/platform_data/dwc3-omap.h>
> +#include <linux/usb/dwc3-omap.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/ioport.h>
> @@ -126,6 +127,8 @@ struct dwc3_omap {
>  	u32			dma_status:1;
>  };
> =20
> +struct dwc3_omap		*_omap;
> +
>  static inline u32 dwc3_omap_readl(void __iomem *base, u32 offset)
>  {
>  	return readl(base + offset);
> @@ -136,6 +139,56 @@ static inline void dwc3_omap_writel(void __iomem *ba=
se, u32 offset, u32 value)
>  	writel(value, base + offset);
>  }
> =20
> +void omap_dwc3_mailbox(enum omap_dwc3_vbus_id_status status)

all other functions are "dwc3_omap_", let's keep it consistent.

--=20
balbi

--Sk71+Upln2BLuDmg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQZZ8xAAoJEIaOsuA1yqRE0s0QAJa6eDd+7pY4eMEbEeFb1eAl
k7H9zsjsF8PJbcXWU5zvUbTb/hqoO6NLiTUWgTjGlfVcU0bEGjP5vmFTQhK2Pwk3
fh+u7+iY01ZSduw83/j+BiVZCLor+PWiGZAPx5wQWvvVQmbNg+bbvgCXIYaje+34
4uuiC68oH571TWU2nggULiP7zyoLJv+271CCXs7nxW9ZGNoKH8T2Z9lS3VRwBcvV
NSzPicfQ8TzrpiKylIUgxO688ugRnW2rP2sqVj9XJqph5OB0RYSQwZGOcum2WqbO
wjmsNrsRFMz+Xl124FjHhFRsltreSnKwQN3blr7/MXpjLvTvCI3pN3ADs8fjvotj
ZY5KHuHuzwa7N5CZU4LynEcwXLVMSh7eGIVPixUCD0pG7qTs8ReKWJyJb5fH7EY/
+WzB+A/EV88wUxE8OkBhxBfpztRguzRVF6E9/pLZ1+YHN2n6CBuU4d+TQ/FkevKe
mrR3NDAKOqnpB6r2tGDVE1Nnwck+ONEi/HirMGkPsj5HY7vJWmvSwjvNluWFNvPg
qxvIU9SlqfHRyqPDQxPJYattu1V+cteO94TNkYebNFypYn2ODuyXxWTqsisxAg05
YvajX3vwnt/hZxtH2vstqqhVn5q6owTRPB7MFVNsf52UoTmIbBdtzIvAq1GhJrHr
CLlTwiCbbxtOPCYeFthk
=Cw1m
-----END PGP SIGNATURE-----

--Sk71+Upln2BLuDmg--
