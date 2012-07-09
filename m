Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751644Ab2GIG1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 02:27:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54479 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab2GIG1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 02:27:12 -0400
Date: Mon, 9 Jul 2012 08:27:07 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH 1/1] pwm: Use pr_* functions in pwm-samsung.c file
Message-ID: <20120709062707.GB10484@avionic-0098.mockup.avionic-design.de>
References: <1341566030-3902-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JP+T4n/bALQSJXh8"
Content-Disposition: inline
In-Reply-To: <1341566030-3902-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:u9ETboaUegNBAjGoHN63qo1c2pb0/uifGQ78Tfk+J8j
 7WqNqbsZ9reqVgqW178U+8Dt6dIp/V5hHHyRI4SLCe28KrvVTB
 ZaJSyY9gFyjSrsr1s1X+zw4/f3/grnSjxCjVk8VPt0hPX2tibg
 96s+VeLRNvm7tYd1AiGvSWPhwTpn4CC01o9SdREahwjRR8ZKQt
 ZMBJBO/2A/HXIy7KDg+qVUoBvRFip+v5fC22GgST+GWgked8qR
 goslUN95DSPkz/tXSCGpR+FKOzKKvMuhhNfk8uJ9pV9nOo42mk
 8cfNw61K5Y3CGdgx5cl3Rt+PXi6mDyublPO6rcMb8pgviW1XV5
 s3MV/N9rPfLEV1+oQfJaIdwHTgXYEyALBLxlBMQPuQQfx6rB8z
 Cd+frOYefxzcplbSt1Uv5M8LO4/s38zXG6CfKz6FlPQDYwcBwJ
 U9mst
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JP+T4n/bALQSJXh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 06, 2012 at 02:43:50PM +0530, Sachin Kamat wrote:
> Replace printk with pr_* functions to avoid checkpatch warnings.
>=20
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/pwm/pwm-samsung.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)

Applied, thanks,

Thierry

>=20
> diff --git a/drivers/pwm/pwm-samsung.c b/drivers/pwm/pwm-samsung.c
> index 35fa0e8..d103865 100644
> --- a/drivers/pwm/pwm-samsung.c
> +++ b/drivers/pwm/pwm-samsung.c
> @@ -11,6 +11,8 @@
>   * the Free Software Foundation; either version 2 of the License.
>  */
> =20
> +#define pr_fmt(fmt) "pwm-samsung: " fmt
> +
>  #include <linux/export.h>
>  #include <linux/kernel.h>
>  #include <linux/platform_device.h>
> @@ -340,13 +342,13 @@ static int __init pwm_init(void)
>  	clk_scaler[1] =3D clk_get(NULL, "pwm-scaler1");
> =20
>  	if (IS_ERR(clk_scaler[0]) || IS_ERR(clk_scaler[1])) {
> -		printk(KERN_ERR "%s: failed to get scaler clocks\n", __func__);
> +		pr_err("failed to get scaler clocks\n");
>  		return -EINVAL;
>  	}
> =20
>  	ret =3D platform_driver_register(&s3c_pwm_driver);
>  	if (ret)
> -		printk(KERN_ERR "%s: failed to add pwm driver\n", __func__);
> +		pr_err("failed to add pwm driver\n");
> =20
>  	return ret;
>  }
> --=20
> 1.7.4.1
>=20
>=20
>=20

--JP+T4n/bALQSJXh8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJP+nm7AAoJEN0jrNd/PrOh4LkQAJqrbeFBdRdKfYWzVht3Gwjy
NO8rPlQ4g/YUUKIN8dEIUwJtyeRGYke3B3VnTLsSho2TdGGqKR4h3pPcV3OYIH61
mzzNdRALgNdAx/ISh2rAe/taXUQ6lqglIvXNPwr81EMtSCcCKZJ9prq3/QhB0HjT
/HQ6BSAFkH9gCiAszgMcFPQU56Z95CKVg/VQOYYdhohrBpI0f9VVqlHEfFTXcLSU
obB43CxYGEeE3YdZOjMwNd3HjOUYquYyNQlxT2lwM+jlk4CdUmylDcveYPVX80jy
TmyxjjJjpD+o9BxqkPq8z5eFsGkWRiOnX/d5ZhRlXnkSXdnOZqClLWgHaC5yOAVY
ARzOEvNqqzr7WA56I1RCVApRdVzOj/H8hrRLjvE/uf+ZC/KSGAUrZB2X199uTI5s
KJQSsfIFWcdzTs0Lq1ZcU1DChCN8+bL6Gf+k7aPNjbnGZNqlv2we7DxHvf5LO6wZ
i92LxJKB6O7u7F4zUEU6Jxv9bog4oPLO9xLgVAtDTp/5MTNUSOHuipP6qUy3kqpZ
IFXUnHq0gP1+Q6EGD1m++snZFnrKqFXseG0Sey17IaaRe0l9DC3B8/KCFsOX+5Av
bvShNhs60pxlvsKfwk3NK3+fcqOJV5jvHopBEn5w19HLHsAm53bwh3ZZzWUZ7nmm
kqA+yhBQ2983R8EtnL2u
=+ejz
-----END PGP SIGNATURE-----

--JP+T4n/bALQSJXh8--
