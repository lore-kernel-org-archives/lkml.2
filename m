Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756072Ab1KPLJY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 06:09:24 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:47416 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755394Ab1KPLJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 06:09:19 -0500
Date: Wed, 16 Nov 2011 13:09:13 +0200
From: Felipe Balbi <balbi@ti.com>
To: Tonylijo <mail@tonylijo.in>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb : gadget : usbstring : fix style problems
Message-ID: <20111116110912.GD27980@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1321418582.2443.4.camel@debian1.ic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yudcn1FV7Hsu/q59"
Content-Disposition: inline
In-Reply-To: <1321418582.2443.4.camel@debian1.ic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yudcn1FV7Hsu/q59
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 16, 2011 at 10:13:02AM +0530, Tonylijo wrote:
> Minor fixes for problems found by checkpatch.pl in usbstring.c.

list here the return from checkpatch.pl --terse just so we know what
you're fixing.

> Signed-off-by: Tonylijo Jose <mail@tonylijo.in>
> ---
> diff --git a/drivers/usb/gadget/usbstring.c
> b/drivers/usb/gadget/usbstring.c
> index 58c4d37..2bdc56a 100644
> --- a/drivers/usb/gadget/usbstring.c
> +++ b/drivers/usb/gadget/usbstring.c
> @@ -32,8 +32,9 @@ static int utf8_to_utf16le(const char *s, __le16 *cp,
> unsigned len)
>  	 */
>  	while (len !=3D 0 && (c =3D (u8) *s++) !=3D 0) {
>  		if (unlikely(c & 0x80)) {
> -			// 2-byte sequence:
> -			// 00000yyyyyxxxxxx =3D 110yyyyy 10xxxxxx
> +			/* 2-byte sequence:
> +			 * 00000yyyyyxxxxxx =3D 110yyyyy 10xxxxxx
> +			 */

still wrong. This should've been:

/*
 * 2-byte sequence
 * 00000yyyyyxxxxxx =3D 110yyyyy 10xxxxxx
 */

likewise all bellow.

--=20
balbi

--yudcn1FV7Hsu/q59
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOw5nYAAoJEIaOsuA1yqRE+SUP/iMM16r8dQrLGd3gEl3w2jOr
yVt6n9IeHZPSvVBtYtWy2ZzIVGClHPD4IS6AH5CdzCNHXUaUCR3KroOWMF2Lbstm
rUieJvNmQuDOfjygVwsg82GdIzI0rowX4D+05uv2Vn/CzJO6Nw6B/Ec3NzfW3cPG
vj0mKcQYul6E82VBsCe4uCMKib59Jgq5bw8Kp83srgLU/14AdseLcqtWDd4uvZ8R
zlxK2GAhSaZZ3jWQ1BYVKnCVHr6l6N0Y9XBGWPgE2D73dyZYW2s2SmEqMzR84pTV
vTS4LJ0TuB89gkBQ71xBB8FoZEFb9C/7xubcLkTFUEWsHQm9SYqb85QT/d9mFQTG
ERTPoRWORUsR/sNJxccjFLliPhf0KPutZhjIPMIbeAFI9bCLt6ZB5c5yo3Bb1vV4
XFutOi4AyUFDEpsmYU4o/qxrnWKXvYiOitTnjiLGjJhrC/jMx9g7EYl4YA+EWXKZ
5p2fwotgKBz+cUQbxXU2r/JJByY3qwUHu0YAa/A2/zNat3XDn8Y1neMPNu0RzQE7
yZbNcLyhpL0N/5GAbxodIFLm4VjMq/e1M+ZVq37lOUkuMNTqd1mLuTZpVjQyzyeL
NPtjgoLEAw0FqX8cpIq2UgZ+5Moai6APz1TKylf1CaMjrkCA2wxdheDeomHE7aGd
lLI8GLv5HosG+4FbBOf/
=4kg1
-----END PGP SIGNATURE-----

--yudcn1FV7Hsu/q59--
