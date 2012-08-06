Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab2HFJeJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 05:34:09 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:42571 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754125Ab2HFJeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 05:34:07 -0400
Date: Mon, 6 Aug 2012 12:30:34 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, arnd@arndb.de,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] driver: misc: bmp085: remove "of_match_table" property.
Message-ID: <20120806093033.GH17551@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1344245324-16704-1-git-send-email-sourav.poddar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K1n7F7fSdjvFAEnM"
Content-Disposition: inline
In-Reply-To: <1344245324-16704-1-git-send-email-sourav.poddar@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K1n7F7fSdjvFAEnM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 06, 2012 at 02:58:44PM +0530, Sourav Poddar wrote:
> There is an automatic binding done for I2C devices in the of_i2c core
> code. So, DT will be able to bind to any I2C device using the
> already existing table: MODULE_DEVICE_TABLE(i2c, bmp085_id).
>=20
> Tested on omap5430 evm.
>=20
> Cc: Benoit Cousson <b-cousson@ti.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  drivers/misc/bmp085-i2c.c |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/misc/bmp085-i2c.c b/drivers/misc/bmp085-i2c.c
> index 9943971..a4f33c9 100644
> --- a/drivers/misc/bmp085-i2c.c
> +++ b/drivers/misc/bmp085-i2c.c
> @@ -57,12 +57,6 @@ static int bmp085_i2c_remove(struct i2c_client *client)
>  	return bmp085_remove(&client->dev);
>  }
> =20
> -static const struct of_device_id bmp085_of_match[] =3D {
> -	{ .compatible =3D "bosch,bmp085", },
> -	{ },
> -};
> -MODULE_DEVICE_TABLE(of, bmp085_of_match);
> -
>  static const struct i2c_device_id bmp085_id[] =3D {
>  	{ BMP085_NAME, 0 },
>  	{ "bmp180", 0 },
> @@ -74,7 +68,6 @@ static struct i2c_driver bmp085_i2c_driver =3D {
>  	.driver =3D {
>  		.owner	=3D THIS_MODULE,
>  		.name	=3D BMP085_NAME,
> -		.of_match_table =3D bmp085_of_match
>  	},
>  	.id_table	=3D bmp085_id,
>  	.probe		=3D bmp085_i2c_probe,
> --=20
> 1.7.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--K1n7F7fSdjvFAEnM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQH465AAoJEIaOsuA1yqREcJoQAJENziQpMBU4QPDfICJ8k1um
38UederLGeC2zHMWOo0oKxTpSo7YGaA+gLjDgmnrOvuSRxvHsKrSh4AvQqrrMI65
EsSrs6TeDZc7sYg+JQ/nRWPgRkW4Bs1lpCjeQwwCvEfyAxAoLO44Eum9DqNZOg0Z
cDoPfk7Lifs7OacHYj4ZquM4QvtE0jjMUxYbTgTs6vIvhT/veSDZqVOha71sRpX/
2gGVnGqR0P3Es0c7k+bTf4+d2+Oz3xgzr8L3J2+AD/8ZcUFKRVsG1mVDhPF0TtsJ
CDGuT3DpoEIysmvXoHblWXXUFewm2nS3/bqjujcbdwTowhthVrDZiQARMrmvt+p5
dM1g+ng31bVVKRBDjNZ0GQ087p8rtDEr8hzXsqolRrfYUkzwai1MKqThLJ4SlTk5
kGvJqDvHbFhn1+DeUFBtA4VCP2B1jtqbLLSZn1Lrd4ksAjXUpmBj7GcnXySRZ+Nh
1objbxZVodoiTMZsQcMUDGY0HoKHl8IlLLEukTfC5jUsvsQgD91kg7s8Ez4Zd78W
NFus3ZcmTS6+fIMRmnCEOUBPs3w7pKweIShVyc02git407BPON9BC8s4W9A2SSk+
7sSDyjPfwMIyJO1bKe62lrUW2+BUKNVBArJaekHacShtHuQabKnqeVcR8u2oes+P
hh1fXXOEsxGcdUETKW2t
=RKAD
-----END PGP SIGNATURE-----

--K1n7F7fSdjvFAEnM--
