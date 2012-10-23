Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933820Ab2JWWkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 18:40:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49390 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933508Ab2JWWkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 18:40:10 -0400
Date: Tue, 23 Oct 2012 15:40:05 -0700
From: Tyler Hicks <tyhicks@canonical.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Dustin Kirkland <dustin.kirkland@gazzang.com>
Subject: Re: [PATCH 146/193] fs/ecryptfs: remove CONFIG_EXPERIMENTAL
Message-ID: <20121023224005.GB29213@boyd>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
 <1351022666-6960-147-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="0eh6TmSyL6TZE2Uz"
Content-Disposition: inline
In-Reply-To: <1351022666-6960-147-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0eh6TmSyL6TZE2Uz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-10-23 13:03:39, Kees Cook wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
>=20
> CC: Tyler Hicks <tyhicks@canonical.com>

Kees - Please push this through your tree. Thanks!

Acked-by: Tyler Hicks <tyhicks@canonical.com>

> CC: Dustin Kirkland <dustin.kirkland@gazzang.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  fs/ecryptfs/Kconfig |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/fs/ecryptfs/Kconfig b/fs/ecryptfs/Kconfig
> index cc16562..e15ef38 100644
> --- a/fs/ecryptfs/Kconfig
> +++ b/fs/ecryptfs/Kconfig
> @@ -1,6 +1,6 @@
>  config ECRYPT_FS
> -	tristate "eCrypt filesystem layer support (EXPERIMENTAL)"
> -	depends on EXPERIMENTAL && KEYS && CRYPTO && (ENCRYPTED_KEYS || ENCRYPT=
ED_KEYS=3Dn)
> +	tristate "eCrypt filesystem layer support"
> +	depends on KEYS && CRYPTO && (ENCRYPTED_KEYS || ENCRYPTED_KEYS=3Dn)
>  	select CRYPTO_ECB
>  	select CRYPTO_CBC
>  	select CRYPTO_MD5
> --=20
> 1.7.9.5
>=20

--0eh6TmSyL6TZE2Uz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCgAGBQJQhxzFAAoJENaSAD2qAscKzJEP/j3gWw8jIUUxgPqSGBvCp1F7
I7bSJHhhaXSawsdwy0AeYOj4VMow6fq5CXrY/RoKYr9N4dmpcnUaRtRuCEvSHqL2
BynPyl7YwaxRIyfSatj9aa/TmtZdkouHNjnquqMWgSjKuFM1aofP/CiFO2JYsLV7
nlRNGdEllaTM/II50ov7aGiXB3gRtIqZ+iKuVkiOfkW9X2mANKkRTR58HXYYxzhC
JJbDBqSGoYzhb5lolKNevLdX0Zb0s6lF75BGeEQY/5rh9a7j5jRXa+PninQM2Jn1
DT0MRrf+5xugVwGjWMS+lcIjfHeT4ijd3GwZBWQshrMksXQkGw1hje6NWH/UOcyY
pal7Xg5wPklFaUYptvS1QWvoiaznIxScbL64HkTgtfdYaqxqgKIhh1seCrhvAyZH
ztR3Bw8oIGBfNzPGiIiTvvVLRxi2YRYbIRef9fLgSPMAoprbc7yBPkhv+H6yybN+
96uoZcLet/LXjXntgTb7yDWU9YNQMAIAfJLHpirwwNCRdlkdN5hC2JZpf0a/cIKL
vKUpd6F+IcKT7Tc7uVrYVBrBTYSQ8kDgozUriWKMU+QmzCDsEEf7Ibap/Ee43BYC
FfBkENaefVcD6/R/FQ/l6HYpbKq28oU5TVxQpKGb/NROeq34scWy6ickKo079YF3
F16UeS4pUbpG/x98DhsJ
=yPtE
-----END PGP SIGNATURE-----

--0eh6TmSyL6TZE2Uz--
