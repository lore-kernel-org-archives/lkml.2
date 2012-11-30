Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab2K3IzA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 03:55:00 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:52958 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357Ab2K3Iy6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 03:54:58 -0500
Message-ID: <50B8745F.4020701@ti.com>
Date: Fri, 30 Nov 2012 10:54:55 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Archit Taneja <archit@ti.com>, Mythri P K <mythripk@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] OMAPDSS: Add terminating entry for picodlp_i2c_id table
References: <1354249845.18712.2.camel@phoenix>
In-Reply-To: <1354249845.18712.2.camel@phoenix>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig3C2E0DFF10C4F0CF3288AA4D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig3C2E0DFF10C4F0CF3288AA4D
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,

On 2012-11-30 06:30, Axel Lin wrote:
> The i2c_device_id table is supposed to be zero-terminated.
>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/video/omap2/displays/panel-picodlp.c |    1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/video/omap2/displays/panel-picodlp.c b/drivers/vid=
eo/omap2/displays/panel-picodlp.c
> index e3a6c19..1b94018 100644
> --- a/drivers/video/omap2/displays/panel-picodlp.c
> +++ b/drivers/video/omap2/displays/panel-picodlp.c
> @@ -50,6 +50,7 @@ struct picodlp_i2c_data {
> =20
>  static struct i2c_device_id picodlp_i2c_id[] =3D {
>  	{ "picodlp_i2c_driver", 0 },
> +	{ }
>  };
> =20
>  struct picodlp_i2c_command {

Thanks, I'll apply to omapdss tree.

 Tomi




--------------enig3C2E0DFF10C4F0CF3288AA4D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJQuHRfAAoJEPo9qoy8lh71BgMP/iokScfkKLA2NHTpv8aUoblR
mfIGKtggJ21fYVMHbmhyD/ohy3RRofX/KZSJXPSNuygN8cwjD/LbrxlfMvGsB1/R
frbFHG98E/im31MKm8e/R7GmZgmceUgtjaPq3pEkatN1VrCpcfREAEmFWAgYetad
Jn9U/qNf0M08vQ2Pyd9mXiGIuYZ2AcXavtEuvjVAgsKLjgeSwTpp61MzN/X2wBrQ
HqXmCCEAd3FoJARBofzdXBiw0DBg34umYFDbg7AFRHTv9m7pdRtONf7Yl/qHgCEn
u1ylOpV7jmVnKqEnjAH5whQhu9bEMAxCI7mJ8XWJBn2D+0vD+wYhG08qwAluBkJY
+/zAj3P5RDcmSLvcLZZsv085v7AYM/yI4XQf3XF5y41PDLW2jZPqVYVhDjn+r1fS
4rjcZ3QQpdvegyvqg3NhP7eUeyQ4H5911PUYxjmKk9eAqyAB9BHzpQovCKGm6IBO
I52VwRgBraIN0oVOLDRK6UPJML3rFbIHXhz+AP+LFClRo5BHuWJCCwJwoP75+UOw
X4Tkhhhr8LyjE6PEuDWExZ/qi/oVhN/fUwOuciQzP8rQiKLdwkpUrKlpVkzrX/Iz
+Zz3yUcjBrXlTPD+fNEU4LBhOBYFXwOCLyFq97miwf4BZZ+KAwpb4RNQac4+dfrM
EngBNyWsk61lvUbn2Hmf
=1gRk
-----END PGP SIGNATURE-----

--------------enig3C2E0DFF10C4F0CF3288AA4D--
