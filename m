Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab2LNGwL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 01:52:11 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:56647 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2LNGwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 01:52:09 -0500
Date: Fri, 14 Dec 2012 07:52:01 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH] pwm: samsung: add missing s3c->pwm_id
Message-ID: <20121214065200.GB24094@avionic-0098.adnet.avionic-design.de>
References: <1355458809-12290-1-git-send-email-jy0922.shim@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lEGEL1/lMxI0MVQ2"
Content-Disposition: inline
In-Reply-To: <1355458809-12290-1-git-send-email-jy0922.shim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:jlozPQdjbrhEbTp9s2mN5vPK/N7b+T3DeEU2OW3MLyt
 VzNWc3gKAwxSE0dVA7t/R4gmQWOv8LFB+Qa1NtnR9hyGQbSHB9
 5AV6Cx8MT1eC1JZdNL/ZXSV+a1KZ6jATzRutO5WGeXJ/iZW4UL
 5GUt+TWSSi4o5c0krhkN2fosT6aWXa+zwuWjEAA/GKQ/cNc+vX
 6j7bW0pGEEDwUzWtqqxfk1VxGLHVKBCmwDL3+itq80xj/AJLDF
 FIt+eay2y6FgbfG2NY2qKhF+Pd1mpHL8cPncxR75dzS+q5H8K0
 FlqnoU2Tj5Wx34DS710JjMVM0yQp2M8tiA7z0qZZ6mwfcsCefU
 uULXetai0O5WIMb1LPOY/RvCiMmK8r3pHo1Eq1AHeKVMmgEKkZ
 vgtfrW6HLZjFcI9dEPQuAlboC8YF0kLaso=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lEGEL1/lMxI0MVQ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 14, 2012 at 01:20:09PM +0900, Joonyoung Shim wrote:
> The s3c->pwm_id is used to calculate offset of related register.
>=20
> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
> ---
>  drivers/pwm/pwm-samsung.c |    2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/pwm/pwm-samsung.c b/drivers/pwm/pwm-samsung.c
> index 023a3be..b415102 100644
> --- a/drivers/pwm/pwm-samsung.c
> +++ b/drivers/pwm/pwm-samsung.c
> @@ -220,6 +220,8 @@ static int s3c_pwm_probe(struct platform_device *pdev)
>  		return -ENOMEM;
>  	}
> =20
> +	s3c->pwm_id =3D id;
> +
>  	/* calculate base of control bits in TCON */
>  	s3c->tcon_base =3D id =3D=3D 0 ? 0 : (id * 4) + 4;

Can you please move the assignment to below the above line? That way s3c
initialization is more localized.

Thierry

--lEGEL1/lMxI0MVQ2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQysyQAAoJEN0jrNd/PrOhKZgP/2anWUPa6W6NZ+MfAsUMzzJc
ANqgRhogft4P6xWRe0mvPRQAFE0o0v2T2wfZJaETIuuPL2UNxgF6FBdgkewKtc+t
ZJdEGkhCCmEdyfjKhiWuJn1x+S+piPWeCoR3sHBXLFysTLiSLH4dYhJBnMu+/m/f
WUTjMPTyzHnA282VdrYYMCS1CDYu0e/Ly2W7W3206ijglEac4F10SIAGQZ5dAfy6
PaydVLsJXKM8kf4A66xP8ZyoK8iYqGnTZ34AS7nbjAuSlndF5Oc+gyshJw7BqYuT
adfR1veCr4Jj3tVn6q6DQakv3qyuoZhiWR9juzeJApbPVa1dGTxBLNF583/rEXvz
xIlol0Gc9gpSblaKx+iXMJEEgSMxco4o7JAjN/vmNP7B/Acs1k7eAaWrV7+d8LTl
szMGxesuVexHVBZKrhZccADisx9s2AxjRCCi1u3Fl3mVE0ikCBmMlPQIWP46aeqU
JtyQXaOc+0IRAX45Slirnp2Ce+zcVpIPRVGJG9hSjDvqyycXkpQq8NFQUUtYcqMS
z96bbBfhG5xkmyfTGC/SVLvEMhQunvQrmbJAPOJs0jpLshKBJMby2IdcWRXnxKDD
xkS77whhjIKZuTfXbL5RDrG6shChJfg71TeCZFTzzgXoNovyrTa1MZn79TU7alLE
rs+2T1x/n5IwHHY5/NPu
=5yZ+
-----END PGP SIGNATURE-----

--lEGEL1/lMxI0MVQ2--
