Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030327Ab2EPLjC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 07:39:02 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52605 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030289Ab2EPLiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 07:38:52 -0400
Message-ID: <1337168320.4107.42.camel@deadeye>
Subject: Re: [PATCH 1/1] smsc95xx: add FLAG_POINTTOPOINT flag for driver_info
From: Ben Hutchings <ben@decadent.org.uk>
To: jgq516@gmail.com
Cc: steve.glendinning@smsc.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 16 May 2012 12:38:40 +0100
In-Reply-To: <1337155302-26244-1-git-send-email-jgq516@gmail.com>
References: <1337155302-26244-1-git-send-email-jgq516@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-AFG3JULNzdkpalkU0RyL"
X-Mailer: Evolution 3.2.2-1+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AFG3JULNzdkpalkU0RyL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-05-16 at 16:01 +0800, jgq516@gmail.com wrote:
> From: Xiao Jiang <jgq516@gmail.com>
>=20
> commit c26134 introduced FLAG_POINTTOPOINT flag for USB ethernet devices
> which possibly use "usb%d" names, add this flag to make sure pandaboard
> can mount nfs with smsc95xx NIC.

These are normal Ethernet interfaces, whereas FLAG_POINTTOPOINT is for
devices that use non-standard short physical links.

Ben.

> Signed-off-by: Xiao Jiang <jgq516@gmail.com>
> ---
>  drivers/net/usb/smsc95xx.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
> index 94ae669..e158288 100644
> --- a/drivers/net/usb/smsc95xx.c
> +++ b/drivers/net/usb/smsc95xx.c
> @@ -1192,7 +1192,8 @@ static const struct driver_info smsc95xx_info =3D {
>  	.rx_fixup	=3D smsc95xx_rx_fixup,
>  	.tx_fixup	=3D smsc95xx_tx_fixup,
>  	.status		=3D smsc95xx_status,
> -	.flags		=3D FLAG_ETHER | FLAG_SEND_ZLP | FLAG_LINK_INTR,
> +	.flags		=3D FLAG_ETHER | FLAG_POINTTOPOINT | FLAG_SEND_ZLP |
> +			  FLAG_LINK_INTR,
>  };
> =20
>  static const struct usb_device_id products[] =3D {

--=20
Ben Hutchings
The two most common things in the universe are hydrogen and stupidity.

--=-AFG3JULNzdkpalkU0RyL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT7ORwOe/yOyVhhEJAQoAOw//VsfBM2flAdjrv1gG5g4ukGKA5ounHI8h
iP1PWtlXUQx6LO0gBjzYNJRpFVW6Vw5VS9A5sQpJKP5Q9aWqnA/Vkbte5uCM4Lms
XHklGbFo0sUsWKR74FkRR81b6k6HiAlRaH7uJkiBDGiZQcej5hNEWs7bY7aXzg19
x+8AtDS7Kpb8lYB6FpeGb31iYkp2TtZ9FfIwnpm49nc7+73g76oqEK1GMg2APXUV
U+Y90nmxMy7esHsbyo3awwQazdinVoDGJAAijZBZRh03+JK+G3imddN3jNhRjEyG
Mv5lppYuIUJzOxD+CH0nj0JIXjYrThG7d3mSpH36zGDQKNpC0/Lna2Jp6op6+9LU
9Wt7aqaUX03BB+T5yfYxuFxpV56fuX1+H8CERgxNDfDVIP5Ap3ftAnb1ka6gNt2M
Fs+V0KpCm/wOm6LAuyLIPgzlJls6X36zINxR78wOLFR8LwEN7XQgNou57yWr6sGE
lNU65ETVDBI0IO5gwTiuVvxeFMy7TsIoF6isb7pNp7VMEp86ful8fFYeQCBd3j0L
GTvLz+CfA9mxcDuF9yVMmmR+JlGmNXwqeAN9pHyt6FJsP2cMzLpYfjj/V6ND+ndV
hcsBx5c9eSdO7rjRufIu70IPoBh8KgH4cpwnO1zIUNq+IVsZkULYunT8F751bPeC
RiHYuydiwTo=
=vUZg
-----END PGP SIGNATURE-----

--=-AFG3JULNzdkpalkU0RyL--
