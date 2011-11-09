Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab1KIGJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 01:09:27 -0500
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:54596 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751130Ab1KIGJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 01:09:26 -0500
Date: Wed, 9 Nov 2011 08:09:21 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vinod Koul <vinod.koul@linux.intel.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        jaswinder.singh@linaro.org, 21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Subject: Re: [PATCH v2 1/2] USB-musb: move to dma_transfer_direction
Message-ID: <20111109060919.GD23337@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
 <1318610350-23335-1-git-send-email-vinod.koul@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2iBwrppp/7QCDedR"
Content-Disposition: inline
In-Reply-To: <1318610350-23335-1-git-send-email-vinod.koul@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2iBwrppp/7QCDedR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 14, 2011 at 10:09:09PM +0530, Vinod Koul wrote:
> fixup usage of dma direction by introducing dma_transfer_direction,
> this patch moves usb/musb driver to use new enum
>=20
> Signed-off-by: Vinod Koul <vinod.koul@linux.intel.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

This looks ok to me:

Acked-by: Felipe Balbi <balbi@ti.com>

Mian, if you agree with this patch, please reply with your Acked-by

> ---
> v2: split the usb patch into two patches
>     fix the error of direction variable
>=20
>  drivers/usb/musb/ux500_dma.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/usb/musb/ux500_dma.c b/drivers/usb/musb/ux500_dma.c
> index ef4333f..d5b5262 100644
> --- a/drivers/usb/musb/ux500_dma.c
> +++ b/drivers/usb/musb/ux500_dma.c
> @@ -112,7 +112,7 @@ static bool ux500_configure_channel(struct dma_channe=
l *channel,
>  	struct musb_hw_ep *hw_ep =3D ux500_channel->hw_ep;
>  	struct dma_chan *dma_chan =3D ux500_channel->dma_chan;
>  	struct dma_async_tx_descriptor *dma_desc;
> -	enum dma_data_direction direction;
> +	enum dma_transfer_direction direction;
>  	struct scatterlist sg;
>  	struct dma_slave_config slave_conf;
>  	enum dma_slave_buswidth addr_width;
> @@ -132,7 +132,7 @@ static bool ux500_configure_channel(struct dma_channe=
l *channel,
>  	sg_dma_address(&sg) =3D dma_addr;
>  	sg_dma_len(&sg) =3D len;
> =20
> -	direction =3D ux500_channel->is_tx ? DMA_TO_DEVICE : DMA_FROM_DEVICE;
> +	direction =3D ux500_channel->is_tx ? MEM_TO_DEV : DEV_TO_MEM;
>  	addr_width =3D (len & 0x3) ? DMA_SLAVE_BUSWIDTH_1_BYTE :
>  					DMA_SLAVE_BUSWIDTH_4_BYTES;
> =20
> --=20
> 1.7.0.4
>=20

--=20
balbi

--2iBwrppp/7QCDedR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOuhkPAAoJEIaOsuA1yqREOmoP/RKyKiMkb8dYVI774/biK0oU
lHUYEn9uKtnxAFHlyHjj6m4qLk+Cf0mePyHTFHgG49fNc2mb9rQbDgysj6jiSO8J
nn9yfWYiDdnUD4OqFm0ittH5UQRGICa87Rw8esrLilgNrh8ZCtiDOiP1t26T247O
FiRNsunLa+xDnOoGDCI4/LeMqrNZI2qnqlV0CQL6CBaxkM2C75r5Owba0SFjXsyT
YTg2Yj6NYG8RLmVjbEbJWYABcj3erN1fUPcozAo1O3q+V+Y9GfSTco1PKNZbp1Eq
Qn82ifJTd6EW1aVpvyntW8p88DC2z/4Qo+dGVp/77CYyLc0Lh2dZT8HiKpsOO9Hu
kM7J1fPZ1UJ37XaDI0eXuzEaaQUsZumcyHoaGCKMoQ0P/gnTzz3vpSkAmw5VByG1
eRGBPX8J1lzuHHPifPHGZ4pdb9Gc7Us/lgz6Pxb6vwVxdVH4oqzo5sL0PYHs2hoA
stoPXJTQmjo42VoPg2mOMFv4DVobhbnomSRVdem6KG3AP38PbsnM89dGYH+/1TpF
LN7zLtG4XpwyabzRsR+jZvjCdtzTixvay2iY5Swwq5x7CkH3IyLqkWhpSOpADDxN
b/hDYnPM7YpS0oCccOneYojX3qo+4J63/LhuKEcN/zwR8k9JonnuPdafsgbN3dEz
WqvdgrKF4F9ygW2LPE4A
=Grdi
-----END PGP SIGNATURE-----

--2iBwrppp/7QCDedR--
