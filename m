Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab2AILQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 06:16:04 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:53554 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab2AILQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 06:16:02 -0500
Date: Mon, 9 Jan 2012 14:17:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] dmatest: store correct thread count in
 dmatest_add_channel()
Message-ID: <20120109111702.GE3644@mwanda>
References: <20111124114734.GB32522@elgon.mountain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gMR3gsNFwZpnI/Ts"
Content-Disposition: inline
In-Reply-To: <20111124114734.GB32522@elgon.mountain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4F0ACC71.000F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gMR3gsNFwZpnI/Ts
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Ping?

regards,
dan carpenter

On Thu, Nov 24, 2011 at 02:47:34PM +0300, Dan Carpenter wrote:
> The original code added 1 to the thread_count, but the intent was to
> add +=3D cnt.
>=20
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>=20
> diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
> index 2b8661b..24225f0 100644
> --- a/drivers/dma/dmatest.c
> +++ b/drivers/dma/dmatest.c
> @@ -599,7 +599,7 @@ static int dmatest_add_channel(struct dma_chan *chan)
>  	}
>  	if (dma_has_cap(DMA_PQ, dma_dev->cap_mask)) {
>  		cnt =3D dmatest_add_threads(dtc, DMA_PQ);
> -		thread_count +=3D cnt > 0 ?: 0;
> +		thread_count +=3D cnt > 0 ? cnt : 0;
>  	}
> =20
>  	pr_info("dmatest: Started %u threads using %s\n",
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--gMR3gsNFwZpnI/Ts
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPCsytAAoJEOnZkXI/YHqRKugP/jBHw0rfew+3hp8d2culuGtU
+DGsCGwDOHimEk/BtnNGciqJZ7XUC4qI0X/ZZz1RUvJsfb842t2oUsj+ROV8/uI6
RgdcSe57fmvPmEL3qig8i7olqXACxFwlnt+bz2P/epsQQtwD390QnREvgG9tbJ0h
Twnn8kQFTebsF6eGCXZtpWU6N4p6iB/lNAB16LuuUkypDc731EQhegyarmsWv6ZE
8N3JiHhAkx+jLhQTJeE/PJZSEQc7sMx6QZj+q0DhSlFtcEQ1B8fMCmS+D4tvU6RZ
7bedCh2SKN15Xn9DdnCEh27cUgJwcpHZULginADErZ7MZOgRCN0YcRXcR30oTT8L
bFiIIy2KTsVDY5yYJ4vFpz9HWxFCxQCTCzW/bvmi2InT2jf88Mup/eg38eSy5xst
pObOyV9Ih+m3/Vd8FbEATcUsZHmJ5r7dLNJ54XaZJx2odYgvfBB6kP691jRf4tVD
NVSnqOB3K85JZZym2KTn7GHA3JWysysSNv0fCcpjt/nwjP6lnu8FtOwluGd2WgcU
hpjaC52FIfZFSkvt1XxcFEup3dm1MFpjKjv9mxQUnLwjsFhBxPYEG/8lodIWg7vL
Z2krnpTWjEI9h6reeZW8RFFtc/CHLh6fVgbAtp/LxfFKo7k/K6yIy31uekN2YcwN
pkQR8BTqYzSAL2AZLPm1
=l3ss
-----END PGP SIGNATURE-----

--gMR3gsNFwZpnI/Ts--
