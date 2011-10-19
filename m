Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab1JSLcv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 07:32:51 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:42695 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab1JSLcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 07:32:50 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E9EB565.8000500@cam.ac.uk>
Date: Wed, 19 Oct 2011 12:32:53 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111003 Thunderbird/7.0.1
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch WARNING: patch prefix 'b' exists, appears to be a
 -p0 patch
References: <4E9D9558.7040705@cam.ac.uk> <alpine.DEB.2.00.1110181643450.8149@chino.kir.corp.google.com> <1318982469.7569.1.camel@Joe-Laptop> <alpine.DEB.2.00.1110181819110.12850@chino.kir.corp.google.com> <4E9E89F2.2060103@cam.ac.uk> <20111019102630.GE3217@pengutronix.de> <4E9EAEB7.6080601@cam.ac.uk> <20111019112220.GG3217@pengutronix.de>
In-Reply-To: <20111019112220.GG3217@pengutronix.de>
X-Enigmail-Version: 1.4a1pre
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA479AA90B723B90B4356534F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA479AA90B723B90B4356534F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/19/11 12:22, Wolfram Sang wrote:
>> Maybe something as simple as a comment in the checkpatch source
>> to say that such a file / directory can cause false positives?
>=20
> I'd hope this error message would be clear enough, what do you think?
Would have told me what was going on!

Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
>=20
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 3dfc471..19e4de7 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1506,7 +1506,7 @@ sub process {
>  			if (!$file && $tree && $p1_prefix ne '' &&
>  			    -e "$root/$p1_prefix") {
>  				WARN("PATCH_PREFIX",
> -				     "patch prefix '$p1_prefix' exists, appears to be a -p0 patch\=
n");
> +				     "patch prefix '$p1_prefix' exists as file/directory. Make sur=
e this isn't a -p0 patch\n");
>  			}
> =20
>  			if ($realfile =3D~ m@^include/asm/@) {
>=20


--------------enigA479AA90B723B90B4356534F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJOnrVlAAoJEFSFNJnE9BaILhYP/i0awuyeB0AqvbZcgZk1ZuNZ
mQ5YAK3CawftyhYF3dhJE89k6HtjBAqK2BxLFPkMgpfb2f8izInkOisYdFOwuH27
1x82gXvlrJPKTDj2M0UuR38+8spy3zb+MT5Bf7K5NizlnT5mTymAFMMKcBcnH3yR
aeLSNvqTxTtY+gRPqoEFjKD0oEyDiNIBBOBLMBOEDqMN6tMaAzXQupSsiYIPlDcB
lyrgBviFi52sL3LcJB0++0Tn2DumkdRqALvICNJWdMzsrgCnQgECAoyCS+unPSC3
uPU7upMzrsAfH/8LOa6ULbthlboU4oGMa4jpvKfFiYF3nysjHjSuCZXL/2OIh9mP
+XzFyINj7gtrPYcd9Bf3LR/4hQrzGPhbhLqI/A/9GpAyJ/3O+eTiOUuEm2Mt8Gr3
cULDcPbRowYEfZLtZxGyCRAAhHo1LySiJ2orymUNW2STB8lB630L4VAkEiuMZKIi
0IPHXpWtKVyXbLr1h3kX8JZsiL+K2noTCxvciyi0dABeaK38h/XOp9T2cjQjFVe9
zvLzQ1m5B2SyKSM81e2cDdlQ2uiKxMhs4/0RshX+eaDt/C/dP+2LoGLIbx1oOQzI
km7H2++oIHIlCD5U0n3gdRDtTQMZmkdBD4r9gVJVkKXXqChc+PhWm+cbFx+2ilPM
pHBfIC8zHf2QTTTb7BAS
=cHg1
-----END PGP SIGNATURE-----

--------------enigA479AA90B723B90B4356534F--
