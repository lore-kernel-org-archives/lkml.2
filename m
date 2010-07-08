Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab0GHCmh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 22:42:37 -0400
Received: from liberdade2.minaslivre.org ([74.50.53.203]:44893 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab0GHCmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 22:42:36 -0400
Date: Wed, 7 Jul 2010 23:42:27 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Daniel Oliveira Nascimento <don@syst.com.br>,
       Matthew Garrett <mjg@redhat.com>,
       Richard Purdie <rpurdie@linux.intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] classmate-laptop: make needlessly global symbols static
Message-ID: <20100708024226.GA19890@barata.holoscopio.com>
References: <1278553670.7162.4.camel@mola>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <1278553670.7162.4.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 08, 2010 at 09:47:50AM +0800, Axel Lin wrote:
> cmpc_accel_sensitivity_attr is needlessly defined global.
> This patch makes the symbol static.
>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/platform/x86/classmate-laptop.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platform/x=
86/classmate-laptop.c
> index 3bf399f..6c63303 100644
> --- a/drivers/platform/x86/classmate-laptop.c
> +++ b/drivers/platform/x86/classmate-laptop.c
> @@ -208,7 +208,7 @@ static ssize_t cmpc_accel_sensitivity_store(struct de=
vice *dev,
>  	return strnlen(buf, count);
>  }
> =20
> -struct device_attribute cmpc_accel_sensitivity_attr =3D {
> +static struct device_attribute cmpc_accel_sensitivity_attr =3D {
>  	.attr =3D { .name =3D "sensitivity", .mode =3D 0660 },
>  	.show =3D cmpc_accel_sensitivity_show,
>  	.store =3D cmpc_accel_sensitivity_store
> --=20
> 1.5.4.3
>=20
>=20
>=20

Acked-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJMNTsSAAoJEEWxSg7udFZIF6gQAN7AKK4gEAvGqhtL+Dp40zig
FJadGyAFSnfZDAd+AU7KmIzDntXQHY8bdN+7+S7UMOAeg0idNygt9vEtBko9CTyD
qHVo0uIaLQDuw70id0J+cvG8boVjpn7ncKGDuobrElvS/wJ2gp3S0g19zI17iw6l
o9os/p7sFq+csCEuM/mffX4I4mExYZzruwY+XTvACrWMvJsQAi5m6KzgQXuAeZ+P
NKI2hN/WOOTk5m7NU3vcQA6IHZEs5FNMtDj7n481qQltkYSWnmf6vJK565vJrry7
Ed0rATML94gZuY+huzczKNnJ8JPpk+5+zu1z54FNCzvv6aAHj70BylHUL90Ck3n5
gxoUEFooQb5nXIapR/zjJFhVKue3AAluwExjgrNHgc+VEyaQnt/IIlq7uxBisV6J
DTBKtttAWDqgFb50lp9rC9/7jtbmHdxDbhQQeplQ8MFewoDUHMqzryv6AN71cPoB
nae8zLgtYjtJOFmk3k2NRc1emV5YfM6dD1d1v2aknSJtzMTQKVaI1BpfjfVyU6w4
zMqCSBGQAfLI/qF7YEOC97Sz8yMfBrXILi936tdUE8Ctauo5X1WbpFA/IhR9CPZl
4vVFU+POfHYmrmKMUfFtRMxiWGR7DEVwOfDZuIVHk7HdpaLCNKCoWZ3vdqGboKMx
F02bhMJK0MCkiXBCuWIA
=hrgq
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
