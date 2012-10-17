Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab2JQNT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 09:19:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35577 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756848Ab2JQNT4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 09:19:56 -0400
Date: Wed, 17 Oct 2012 16:14:22 +0300
From: Felipe Balbi <balbi@ti.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Viresh Kumar <viresh.linux@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        <linux-kernel@vger.kernel.org>, spear-devel <spear-devel@list.st.com>,
        <balbi@ti.com>
Subject: Re: [PATCHv2 4/4] dw_dmac: don't call platform_get_drvdata twice
Message-ID: <20121017131422.GE11394@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350469879-16018-1-git-send-email-andriy.shevchenko@linux.intel.com>
 <1350469879-16018-5-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GxcwvYAGnODwn7V8"
Content-Disposition: inline
In-Reply-To: <1350469879-16018-5-git-send-email-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GxcwvYAGnODwn7V8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 17, 2012 at 01:31:18PM +0300, Andy Shevchenko wrote:

I would suggest adding a commit log, but if maintainer is fine without,
I'm fine too :-p

> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

looks good:

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/dma/dw_dmac.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
> index 60b172a..7d2b438 100644
> --- a/drivers/dma/dw_dmac.c
> +++ b/drivers/dma/dw_dmac.c
> @@ -1653,7 +1653,7 @@ static void dw_shutdown(struct platform_device *pde=
v)
>  {
>  	struct dw_dma	*dw =3D platform_get_drvdata(pdev);
> =20
> -	dw_dma_off(platform_get_drvdata(pdev));
> +	dw_dma_off(dw);
>  	clk_disable_unprepare(dw->clk);
>  }
> =20
> @@ -1662,7 +1662,7 @@ static int dw_suspend_noirq(struct device *dev)
>  	struct platform_device *pdev =3D to_platform_device(dev);
>  	struct dw_dma	*dw =3D platform_get_drvdata(pdev);
> =20
> -	dw_dma_off(platform_get_drvdata(pdev));
> +	dw_dma_off(dw);
>  	clk_disable_unprepare(dw->clk);
> =20
>  	return 0;
> --=20
> 1.7.10.4
>=20

--=20
balbi

--GxcwvYAGnODwn7V8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQfq8uAAoJEIaOsuA1yqREs4MP/1FyrE48m61IaL12VR57cN6Z
TReBOStsTEcLeJyOSnVdzEsDdVB6O2ProaGwmNtd4HnS5br0sE+HK8uS8ixcIUr1
zoVkr94gXuc8PTi2HD5O3O2TapscTB38ks2pZkjLJFKwypESZC0SQlEur/0KFvhl
bHVNomwcjZjRaphLfLa/x4oqydzLY8jr4VNLQutc0eHKNSa80zNrwgmlL3yvEfOQ
ueh0OATSjY9MYoBUnhuJRz6yrbS0XFD5KBIKNaG3nGnbtyVjDjyvLWpLf/Fo5kdy
JGXWQ5cCgWYNodNe2Mwl8pu2kWwCtyKiF/tspm4HaXf/dJoS+ulnf5KG5NtEFagl
AwOnCYFoKInW/s5FWNFk02Bo9oxFxTEu3KJ3AmCL8wc+fHkXonCo0Rsp3qAe6ocB
7PYAcrfCW0Q65u33wnY2Z3QCYz+QheRP5K+2PDyn4TyTsvv/y/WKKu9Z4Hwlogn2
Hz/wMFvjPyz3gD2L4+rXmtFlImdSa7Hvy9ZwHscjB3+RbNRYiAvUzPbPA31Arw9+
umlstSRHt0B2wldyklxOX2JnMBiTNhcsDTKBFFmibBU+0Wwd3D1ivV14m2RpRBdT
LmRsRxa1xQ3x3LGp1pm6BIu9Q9QSKyvjbwFmwIvKuPf0XuDMVR1DVP/1sPyxbjfb
dk5XsvpDikgnGY6ZXGTd
=NpVe
-----END PGP SIGNATURE-----

--GxcwvYAGnODwn7V8--
