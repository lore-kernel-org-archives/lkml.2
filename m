Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab1KIGK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 01:10:29 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:60993 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751130Ab1KIGK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 01:10:27 -0500
Date: Wed, 9 Nov 2011 08:10:24 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        jaswinder.singh@linaro.org, 21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: Re: [PATCH 2/2] USB-renesas: move to dma_transfer_direction
Message-ID: <20111109061023.GE23337@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
 <1318610350-23335-2-git-send-email-vinod.koul@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lteA1dqeVaWQ9QQl"
Content-Disposition: inline
In-Reply-To: <1318610350-23335-2-git-send-email-vinod.koul@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lteA1dqeVaWQ9QQl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Oct 14, 2011 at 10:09:10PM +0530, Vinod Koul wrote:
> fixup usage of dma direction by introducing dma_transfer_direction,
> this patch moves usb/renesas driver to use new enum
>=20
> Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

This looks ok too:

Acked-by: Felipe Balbi <balbi@ti.com>

Kuninori-san, please have a look and reply with your Acked-by if you
think it's ok.

> ---
> v2: split the usb patch into two patches
>=20
>  drivers/usb/renesas_usbhs/fifo.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/usb/renesas_usbhs/fifo.c b/drivers/usb/renesas_usbhs=
/fifo.c
> index a34430f..f5bc370 100644
> --- a/drivers/usb/renesas_usbhs/fifo.c
> +++ b/drivers/usb/renesas_usbhs/fifo.c
> @@ -591,10 +591,10 @@ static void usbhsf_dma_prepare_tasklet(unsigned lon=
g data)
>  	struct dma_async_tx_descriptor *desc;
>  	struct dma_chan *chan =3D usbhsf_dma_chan_get(fifo, pkt);
>  	struct device *dev =3D usbhs_priv_to_dev(priv);
> -	enum dma_data_direction dir;
> +	enum dma_transfer_direction dir;
>  	dma_cookie_t cookie;
> =20
> -	dir =3D usbhs_pipe_is_dir_in(pipe) ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
> +	dir =3D usbhs_pipe_is_dir_in(pipe) ? DEV_TO_MEM : MEM_TO_DEV;
> =20
>  	sg_init_table(&sg, 1);
>  	sg_set_page(&sg, virt_to_page(pkt->dma),
> --=20
> 1.7.0.4
>=20

--=20
balbi

--lteA1dqeVaWQ9QQl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOuhlPAAoJEIaOsuA1yqREf6cP+wRGfKVDfheBZr/qXKDpqATW
i3CEDPdTKmuoQN8cTBkdHsGggPdeP0+jtD9TyljJyz4XcRcDNGGP/2YBrpuQFClj
XAlXjXUy4QyhBS/dGPjPs+rBo4hFjrWKu3moLYprhZ1Aq39O1J6PHy4wUpyUsNWX
/QBBcxfGNIfDfc70bKqTd1Nbg+yX6NucYfUvTvMeXYxHY9zmdSP3nGQe2MqILI+s
JYf2zEKpBJHSpMvdcwJRZ/6nUbcRkJjIxMfhmbZyl4Y1nX5CuNsuh1cjFGYzq5Lb
g3J+FMk6B9R5tU3rMmOFQfxLuE08Ch9YMUTbvpGYZmszAat8QX5w2FqGFLkja8Dx
C/tc80RXFfMHqBWfGwnXF6f89EeWvQPvlNCIpS86vhM8G8bMi3wZsRlVuvt7WZ7B
uxADofJj763JQQJiZ9Bvx5NQjg81R/cKEZB399Pun8U8ToKcKE5mgbpeYKF4I2zb
e9azqnF3z6BKkPyn2BhcRXXyNCm+YkRZ4w1BNd1roHrUJtXkZjn5CvTBaW/L/nIZ
eDoktcAYQVCue0Jn3C4mZ1xY9VIYtQ4yGFiYkH5CODzL94jmqoU6chYTlbZm3XhT
WaKGf72Tg9458bYArP4zLUv20zgoHw2WQ14F9IsHU3CLd3Mi/uWVTD4rMv0/wQ8S
dNfZnj/++qepOhDTXqYX
=426h
-----END PGP SIGNATURE-----

--lteA1dqeVaWQ9QQl--
