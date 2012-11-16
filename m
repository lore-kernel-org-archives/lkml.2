Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab2KPODW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 09:03:22 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:48119 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590Ab2KPODV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 09:03:21 -0500
Date: Fri, 16 Nov 2012 15:56:52 +0200
From: Felipe Balbi <balbi@ti.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Vinod Koul <vinod.koul@intel.com>, spear-devel <spear-devel@list.st.com>,
        <linux-kernel@vger.kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 5/6] dma: ipu_idmac: reuse is_slave_xfer helper
Message-ID: <20121116135651.GB18920@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1353074360-1903-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1353074360-1903-6-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kXdP64Ggrk/fb43R"
Content-Disposition: inline
In-Reply-To: <1353074360-1903-6-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--kXdP64Ggrk/fb43R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 16, 2012 at 03:59:18PM +0200, Andy Shevchenko wrote:

-ENOCOMMITLOG ??

> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/dma/ipu/ipu_idmac.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
> index 6585537..c8d0254 100644
> --- a/drivers/dma/ipu/ipu_idmac.c
> +++ b/drivers/dma/ipu/ipu_idmac.c
> @@ -1347,7 +1347,7 @@ static struct dma_async_tx_descriptor *idmac_prep_s=
lave_sg(struct dma_chan *chan
>  	    chan->chan_id !=3D IDMAC_IC_7)
>  		return NULL;
> =20
> -	if (direction !=3D DMA_DEV_TO_MEM && direction !=3D DMA_MEM_TO_DEV) {
> +	if (!is_slave_xfer(direction)) {
>  		dev_err(chan->device->dev, "Invalid DMA direction %d!\n", direction);
>  		return NULL;
>  	}
> --=20
> 1.7.10.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--kXdP64Ggrk/fb43R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQpkYjAAoJEIaOsuA1yqREAk0P/0oFMv/9h+rAcjg5lYmnX1lC
nJ+w5eByAeiyAKJPQHK3ITrFrn6WicqX5ifestT3hC9FgokutU9X87H/byDWs6WS
S7aS9LPhIiwo+0d3np7EExWMT8d/L4q6xWHjNONmIdaeuiZwrFAaz340SgNmvxKI
wo9wow7qkQ8KZAGk6SMoo1VTEgo1ELT+PC1VFjugdRtI4TPKTCZ7A63EJgG2c2QP
dO+iC6yk4wZt1RHbmo04RPWX6o98fCAkaPgNeXrwOl/gHPoWzBHCYP84D4tWqvpv
UNX8U6C5PqSfwZ2iQIn//ctCTYrvPsTSuLV6ToEclhsHbHzgj+SxvqJhoFdIRsac
RJyRS4FsfGhedvfUxvlIB/InEQAyWRs33sNvQ/I6YY19cgK56qstYfC3qvElmwLP
SIhZfL0Xe+vQjFcYyJyQE/dfpOHxRi6DQy5k7Zvyzcucimr2yD5i2F+0l42RCvBK
eSrV2DnBVcxbMA4msQ6ghK2Oht1xf6u1aL1tNqK5EqsoTzpxW8fwdRYX0HiP7Bn8
GSK3r5ruVv/4xQBDpPrfHT6FFX1cBlvGBHio2gH+mvH44xQlpzQManuU3/L4oavB
BmwyM85EZdK1WnnSAKaiighckfkK280y5Ye3C8uWYNMT4BLu9F9MlmyIY3Z//gQI
Fcqomda5DpV8Uy4Whokq
=/zE/
-----END PGP SIGNATURE-----

--kXdP64Ggrk/fb43R--
