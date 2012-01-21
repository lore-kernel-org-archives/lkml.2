Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab2AUIH4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 03:07:56 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:27048 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab2AUIHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 03:07:54 -0500
Date: Sat, 21 Jan 2012 11:08:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kashyap Gada <gada.kashyap@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, bringert@android.com,
        linux-kernel@vger.kernel.org, arve@android.com, john.stultz@linaro.org,
        ccross@android.com
Subject: Re: [PATCH 4/4] Staging: android: Fix struct definitioni warning
 from static to const
Message-ID: <20120121080838.GK3294@mwanda>
References: <1327112269-17530-1-git-send-email-gada.kashyap@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j/HO4hzKTNbM1mOX"
Content-Disposition: inline
In-Reply-To: <1327112269-17530-1-git-send-email-gada.kashyap@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4F1A724E.0001,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--j/HO4hzKTNbM1mOX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 21, 2012 at 02:17:49AM +0000, Kashyap Gada wrote:
> ---
>  drivers/staging/android/ashmem.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/a=
shmem.c
> index 4a00174a5..9f1f27e 100644
> --- a/drivers/staging/android/ashmem.c
> +++ b/drivers/staging/android/ashmem.c
> @@ -680,7 +680,7 @@ static long ashmem_ioctl(struct file *file, unsigned =
int cmd, unsigned long arg)
>  	return ret;
>  }
> =20
> -const struct file_operations ashmem_fops =3D {
> +static const struct file_operations ashmem_fops =3D {
>  	.owner =3D THIS_MODULE,
>  	.open =3D ashmem_open,
>  	.release =3D ashmem_release,

No.  We're not going to merge the broken patch which removes the
static.

Plus your patch numbering is totally bogus.
[PATCH 2/2]
[PATCH 3/3]
[PATCH 4/4]
[PATCH 5/5]

The second number is supposed to say how many patches there are in
the series.  If these were bug fixes, we'd go out of our way to work
with you, but you're just sending random whitespace fixes so they
have to be pretty much perfect.  (In other words, please slow down
and work more carefully or else focus on fixing bugs instead of
whitespace).

regards,
dan carpenter

--j/HO4hzKTNbM1mOX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPGnKGAAoJEOnZkXI/YHqRfW0QAKpU3M02vvSlad8P8F1azxPL
zLKwwOBfjCz8fGwJfCCEh+a1VvjnKk4cl6Z1zc7IMIg3lmsO3KjJILgbmvzMuhXM
l4pyGiSi2mPGHclv34Y/Kw6ueZyKJ0IO2YWB/fOp3W42Ow7H3qwaZ7Cguo6LBRQ8
vXuHlzPoRavY4EMJGVw5Bn6jch2kGWfTCLBOlw2z4O/kayDqA1Hd+BfIcdGSj6gz
PVzoDTe4o0JUQ/I7/enQJvqYUMMBs//r8A7N5BQ+mrZnjlmOYuRoZsQp01iroX0R
lDxUsuHABbpRfvsqZBPE4chZ9N7gk7TC6u3Hqv7jfsW6MzMLIoL/L8MfEkZ+hf7z
RKPZv564dsAhvh+o3k7t+gryLRW6IAHMRujf2vVP4nx8icqjvtZZ5HKHctRQqDRa
qmPt41F1mDAJqJ9tiCkaV3qLBIbrfy91IIqwycANTb79VKs8tPjd5RUk8/g57Z9L
8hKBkPX9awT5GKt8lHYCjJ8C0YyrCoWcYZflw6Adnb1FhOmEfcodYsUEZtNBUE30
WoYBjmzFYTAgySqLEi/koVA8a2JZUgi7UH4c9cJ8gg25lQaipboA7FSN9XX7VzYA
42WoUEzDaeduV4hxIaYRYVn0M87Y4zrXG4S+Ayx1xKeFd4S6ewf7plLENTKUjitf
Skoh5c1yqVU/2c0sQMAk
=9KVv
-----END PGP SIGNATURE-----

--j/HO4hzKTNbM1mOX--
