Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab2GQBMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 21:12:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40269 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753333Ab2GQBMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 21:12:40 -0400
Message-ID: <5004BBFF.4040101@debian.org>
Date: Tue, 17 Jul 2012 09:12:31 +0800
From: "Ying-Chun Liu (PaulLiu)" <paulliu@debian.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: Richard Zhao <richard.zhao@freescale.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        sameo@linux.intel.com, shawn.guo@linaro.org
Subject: Re: [PATCH] mfd: anatop: matches should be NULL when populate child
 devices
References: <1342428957-14321-1-git-send-email-richard.zhao@freescale.com>
In-Reply-To: <1342428957-14321-1-git-send-email-richard.zhao@freescale.com>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig25B61D6C9BF1FA604EF9F845"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig25B61D6C9BF1FA604EF9F845
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2012=E5=B9=B407=E6=9C=8816=E6=97=A5 16:55, Richard Zhao wrote:
> Signed-off-by: Richard Zhao <richard.zhao@freescale.com>
> ---
>  drivers/mfd/anatop-mfd.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/mfd/anatop-mfd.c b/drivers/mfd/anatop-mfd.c
> index 6da0634..5576e07 100644
> --- a/drivers/mfd/anatop-mfd.c
> +++ b/drivers/mfd/anatop-mfd.c
> @@ -83,7 +83,7 @@ static int __devinit of_anatop_probe(struct platform_=
device *pdev)
>  	drvdata->ioreg =3D ioreg;
>  	spin_lock_init(&drvdata->reglock);
>  	platform_set_drvdata(pdev, drvdata);
> -	of_platform_populate(np, of_anatop_match, NULL, dev);
> +	of_platform_populate(np, NULL, NULL, dev);
> =20
>  	return 0;
>  }

Thanks.

Reviewed-by: Ying-Chun Liu (PaulLiu) <paulliu@debian.org>

--=20
                                PaulLiu (=E5=8A=89=E7=A9=8E=E9=A7=BF)
E-mail: Ying-Chun Liu (PaulLiu) <paulliu@debian.org>


--------------enig25B61D6C9BF1FA604EF9F845
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBCgAGBQJQBLwDAAoJEPgLgUbQQog29kgP+wSr/rnl96gB1Hf4WKEAf6/v
6fQmYfqbq4vqp1IZ8McnUi768xvtuuaC4ZtFP5jiYJKR41DiolAd0YxYXyScxFtT
QbzqFRqx2Iolaerlvuc5fKMxzsRKYPipxtLgaFG0LWZSyfG+PKnocG9aELLi6dN/
kmW/cTciv0ZfRZyQ1+J2MHLHIg/cQ/kCj0zcaPyzFVc9X61Q1jXdcybdKGU+t99U
NwNfkkq+6lL1U9WGlpNKerdcG1mGqu7sqxth1yt6ubO93oxQqmXOD5SR7D6K/T0N
IQTMJ1VZAi7Y4ucL2ngwpY2mSiH7WKwGyd3m46R2/AlYaciuUMWMC++J3Pd0JxB4
NDKcqCTQo3L4NDfzGEj0JE98usi8VMERnt3JCLmNQYSukPykWiOd09j6YKN3+S14
vFj5kA9Wszu2e7bBXAT+S7iNTdbMBFll17jcFW04AgnBUN7s9UFWWN42Usfka+mg
RK3vM+iL3dlbYv0WmFA1CRZr+chsrgT8akr80gvkpUgYJdw8kYizlollcg1PIKUr
dJfEkpoxAUyZ6SFanvvE44tm77/OSfE5bqUHmOE+Sv1b5Q77HdHuZTVkTTFCRI/h
/+LB1h7hvf/S+CoYp1C/X0/HlLIyy/bP7MKtiBOb2gc1j2leRijURAfwFnMJ74Ct
/pFHeePAULQOo+O5DGIM
=NSbU
-----END PGP SIGNATURE-----

--------------enig25B61D6C9BF1FA604EF9F845--
