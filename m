Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab2ACMnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 07:43:45 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:63952 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574Ab2ACMnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 07:43:41 -0500
Date: Tue, 3 Jan 2012 15:44:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, linux-media@vger.kernel.org
Subject: Re: [PATCH 12/15] module_param: make bool parameters really bool
 (drivers & misc)
Message-ID: <20120103124420.GA3626@mwanda>
References: <87ehw6sesk.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
In-Reply-To: <87ehw6sesk.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090203.4F02F7ED.007B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> diff --git a/drivers/video/intelfb/intelfbdrv.c b/drivers/video/intelfb/i=
ntelfbdrv.c
> --- a/drivers/video/intelfb/intelfbdrv.c
> +++ b/drivers/video/intelfb/intelfbdrv.c
> @@ -230,16 +230,16 @@ MODULE_DESCRIPTION("Framebuffer driver f
>  MODULE_LICENSE("Dual BSD/GPL");
>  MODULE_DEVICE_TABLE(pci, intelfb_pci_table);
> =20
> -static int accel        =3D 1;
> +static bool accel       =3D 1;
>  static int vram         =3D 4;
> -static int hwcursor     =3D 0;
> -static int mtrr         =3D 1;
> -static int fixed        =3D 0;
> -static int noinit       =3D 0;
> -static int noregister   =3D 0;
> -static int probeonly    =3D 0;
> -static int idonly       =3D 0;
> -static int bailearly    =3D 0;
> +static bool hwcursor    =3D 0;
> +static bool mtrr        =3D 1;
> +static bool fixed       =3D 0;
> +static bool noinit      =3D 0;
> +static bool noregister  =3D 0;
> +static bool probeonly   =3D 0;
> +static bool idonly      =3D 0;
> +static bool bailearly   =3D 0;

bailearly should be an int here.  It's part of some ugly debug code
where a value of 3 means bailout at point 3.  Maybe we should just
remove it instead...

regards,
dan carpenter


--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPAvgjAAoJEOnZkXI/YHqRx6EP/jovDezfg3JzgRdJA0HNNNdh
U6Wug7WJ3JTumKizWdrwEtUz4nV/tvZkSGF5WUy5YqPRa4zAHbiBJlMzHuYMP8ci
dnpbRp9LiBH9hrwOfTPYBwPOmQAXa/Zvq7jB/2M77kd0Wi0h/jgDv0saTC0dpgVw
XIxFU4O9ziuZD+Yh0YcYvoJPOzLy7ifSyQm8dld0GvQ7LUXi8iBa3S5t1F7Rwlkc
fN0jZGDDdcOZKmTINXiBaov6PaspFrAI0GxXGYX6LbM7OqECth8UtFPwwUMMAEmi
pAOqwFXbDCjGzy5JZ3RIgtm6ccBJWE09bQFQ7EEM9A/udg5rij9zxfOXREHqdJfE
1lKff1lAV9DenpwuEQfZ+ADqYjTpjpqWqaaTuiwvve/zJN8uginrHkIQyqjWDSC2
hj3LBIzTnQAFgjz/CBQimGfnZZG1y0UtdTWRjI29632ImoYfgvFHMDY8y+AYuk9t
mtK5JFSxJmw3hRrSHGDgGNmx//UzlmLab62bXM4vRvGh8z1DiswlwX7ZAmEzcI6K
pWelV17TgsrS0h5RcqeAVGRtsNvrXVMaNG9uaOah7JUpGKIklciM4iaUdSH2drq0
Rhuky04PyzPs5rTc3CnRU2+7NjVNvzFPD1LQ5mWUzijQmLgGgEjYIU6h9eo5MZXk
b3zAboXTeP/CDiwAiBFE
=ObDb
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
