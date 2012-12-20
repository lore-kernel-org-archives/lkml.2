Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab2LTUbL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 15:31:11 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:33922 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab2LTUbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 15:31:00 -0500
Date: Thu, 20 Dec 2012 22:30:53 +0200
From: Felipe Balbi <balbi@ti.com>
To: Sasha Levin <sasha.levin@oracle.com>
CC: Venkatraman S <svenkatr@ti.com>, Chris Ball <cjb@laptop.org>,
        <linux-mmc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: omap_hsmmc: correct precedence of operators
Message-ID: <20121220203053.GB28433@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
 <1356030701-16284-18-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
In-Reply-To: <1356030701-16284-18-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 20, 2012 at 02:11:26PM -0500, Sasha Levin wrote:
> With the current code, the condition in the if() doesn't make much sense =
due to
> precedence of operators.
>=20
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

nice catch!!!

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/mmc/host/omap_hsmmc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index bc58078..3ee2664 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -611,7 +611,7 @@ static int omap_hsmmc_context_restore(struct omap_hsm=
mc_host *host)
>  	if (host->context_loss =3D=3D context_loss)
>  		return 1;
> =20
> -	if (!OMAP_HSMMC_READ(host->base, SYSSTATUS) & RESETDONE)
> +	if (!(OMAP_HSMMC_READ(host->base, SYSSTATUS) & RESETDONE))
>  		return 1;
> =20
>  	if (host->pdata->controller_flags & OMAP_HSMMC_SUPPORTS_DUAL_VOLT) {
> --=20
> 1.8.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ03V9AAoJEIaOsuA1yqREVUwQALBNrDPbE21HuB+KJip442M1
2DEdXuUz3NPz4cnJUL5HNZP/peWUNhYtZTTnN7TcsguKNXbj/hE8qwmzm2zIFTc2
nnDtJsUUNUUclqLmeO4sUfC9ZOjaYE8ZCUwNxAFbIg4fLA5VxfHigfG7s9QtTpil
UlfWZnIGsffhzk4HQjbe1h/ZDj04avxl2vc+Zn54xCNA+WPsKK0MMxsoiMZiUHsZ
gpJMnsgr3kV54+Sne3I7pnQSeNm/Bpt9aHxcA4QRq7gw44V25k2GIRuEUd4z1CU2
3nL8xuP8FqureYsaA+MB855sJYQ6lFsefxv4DRgVvxik30GvsJqxOpBctItt5d01
mwUthhZdjrMnJ7nsVi+GE+utZpb/k1bFJVoQhKS0WCjpAgoWwDQGe/vNj9jW1v1s
3QbLYtaUs9T2EuxnwD2z1oC3jgg1JYnP1I9g6W4zvb/IMePGKBpAUGR7OQX+kXkm
hpsV9+lujgwgg0d/h11wTRi6OXazA2D0XasXZyjDfSdrbJta4kDHXlxX93oqOp0C
e75g6ZlLwjQ0+WDRYY80davURJRMxzPxTLlITBjKSq/4WazqkkUwuydOWyXLymwk
qbfAUpsoKSXv/5G3NlY4qcWbPiy2Bd/cLMufe1vJ5S8XlrlUAPZnwtdBfZNo8wQ8
tzWYeabZjV87eBvGuJAo
=UhSJ
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
