Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab2IYMOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 08:14:18 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:53187 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751507Ab2IYMOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 08:14:15 -0400
Date: Tue, 25 Sep 2012 15:09:19 +0300
From: Felipe Balbi <balbi@ti.com>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr, akpm@linux-foundation.org, a.zummo@towertech.it
Subject: Re: [PATCHv3 0/7] rtc: convert to c99 format
Message-ID: <20120925120918.GZ9137@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1348572726-6940-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9Q79yvCDNTHf0qBd"
Content-Disposition: inline
In-Reply-To: <1348572726-6940-1-git-send-email-shubhrajyoti@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9Q79yvCDNTHf0qBd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Sep 25, 2012 at 05:01:59PM +0530, Shubhrajyoti D wrote:
> The series tries to convert the i2c_msg to c99 struct.
> This may avoid issues like below if someone tries to add a
> structure.
> http://www.mail-archive.com/linux-i2c@vger.kernel.org/msg08972.html
>=20
> Special thanks to Julia Lawall for helping it automate.
> By the below script.
> http://www.mail-archive.com/cocci@diku.dk/msg02753.html
> =20
> Resending with Andrew Morton in cc for review as it was suggested to me.
>=20
> Fix a typo in the comments that crept in.
>=20
> Shubhrajyoti D (7):
>   rtc: Convert struct i2c_msg initialization to C99 format
>   rtc: Convert struct i2c_msg initialization to C99 format
>   rtc: Convert struct i2c_msg initialization to C99 format
>   rtc: Convert struct i2c_msg initialization to C99 format
>   rtc: Convert struct i2c_msg initialization to C99 format
>   rtc: Convert struct i2c_msg initialization to C99 format
>   rtc: Convert struct i2c_msg initialization to C99 format

FWIW:

Reviewed-by: Felipe Balbi <balbi@ti.com>

complete series look fine.

--=20
balbi

--9Q79yvCDNTHf0qBd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQYZ7uAAoJEIaOsuA1yqRESfYP/1FKS3bB40/7NUobHjVDewyo
zNDQs3AB+qL+72jOUixGjOKZbHwDsrQyFrHtkc8yCRNkt6HNZSkGhKCfTX0k+WKU
0CfnhtYG7txPEzBht2D5r8rhbl+WYGH/EdZINhM/e6zV7yydLFT72Kgpjpfi3l6A
ZPtc+VJ007mH0IHyHxquxoWtuhq04RzrUANo6q/TJzAziG5GO+Rhbyng10vNxUsp
mTdjUYZRIwYpB6LImVAr1Eci8a4qyYLzRo6tqyaLsYJNqF86VtWbfjZpnlyZanNo
V1lGGT4t0NDqaXlFxhjw+YzFiYqkFURirkGSxYH1OgLx1sW0KkoRcXsLmIEhwROA
27JF0XFLTPYr9gQTcih/uaUwq5hCT+/ztNpuP7DDnLKNA17k/jaIJjyKgA4zr2DU
xx1ZganqzkXiCtiHf/6+PYBjWIiQCUZmT+XD90IJXmYSvYp5qst3XK949N0KQlS6
85CSSBgCeKnTJZ3zr7+SKoa8HuZVKwWPKJEmdh0COYSAkdFj/OmyalaIz3yZdz8V
C2PEq8iYjAiyeM65oGX17ZX5Q+3TRR4lhFq1uxMWMB0SvBon80JbZ3kYSpoTW3jC
T+4EkT6zDEv9q0VL30IbIk8I98zIqRqiqtJh8Bz3YoTnuExhQnmAQnQXK0KGf8lk
ost4VaURfJ5ZagCXNOka
=ufQX
-----END PGP SIGNATURE-----

--9Q79yvCDNTHf0qBd--
