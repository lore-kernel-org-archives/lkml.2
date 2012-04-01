Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab2DAQAa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:00:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56055 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750954Ab2DAQAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:00:25 -0400
Message-ID: <1333296015.3500.367.camel@deadeye>
Subject: Re: [ 032/149] USB: qcserial: add several new serial devices
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Thomas Tuttle <ttuttle@chromium.org>
Date: Sun, 01 Apr 2012 17:00:15 +0100
In-Reply-To: <20120330194840.189874097@linuxfoundation.org>
References: <20120330194840.189874097@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-twXYfa+Q2yin36w/8ubv"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-twXYfa+Q2yin36w/8ubv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-03-30 at 12:49 -0700, Greg KH wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Thomas Tuttle <ttuttle@chromium.org>
>=20
> commit 2db4d87070e87d198ab630e66a898b45eff316d9 upstream.
>=20
> Signed-off-by: Thomas Tuttle <ttuttle@chromium.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>=20
> ---
>  drivers/usb/serial/qcserial.c |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>=20
> --- a/drivers/usb/serial/qcserial.c
> +++ b/drivers/usb/serial/qcserial.c
> @@ -36,6 +36,11 @@ static const struct usb_device_id id_tab
>  	{USB_DEVICE(0x413c, 0x8171)},	/* Dell Gobi QDL device */
>  	{USB_DEVICE(0x1410, 0xa001)},	/* Novatel Gobi Modem device */
>  	{USB_DEVICE(0x1410, 0xa008)},	/* Novatel Gobi QDL device */
> +	{USB_DEVICE(0x1410, 0xa010)},	/* Novatel Gobi QDL device */
[...]

This one is already claimed by option as:

	{ USB_DEVICE(NOVATELWIRELESS_VENDOR_ID, NOVATELWIRELESS_PRODUCT_G2) }

Seems there's some confusion here...

Ben.

--=20
Ben Hutchings
I'm always amazed by the number of people who take up solipsism because
they heard someone else explain it. - E*Borg on alt.fan.pratchett

--=-twXYfa+Q2yin36w/8ubv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAT3h7j+e/yOyVhhEJAQrHjw//ce+ZIjhmOW8hzVACYUMSx/C21N27wcra
Eg2QR7hD/XuWpKlDDP/CvE0ATxJHlqsM7pTj8VUZtMCDbsykQCcngfRzyCEHXhHn
cunyysA8j2Q5YpFeOzk7WY+FLDOmsbACHBib/dTUPjW8+ieZhJPdvJdOM1Bjnw1g
kQ5wSYBmY+ljOxkJhMJugxRfcokCCuhIJOBMWIE+hhZkgrEuH9u7tQTrpu+ZzJQT
9BQg/8zhFtlrMp2AMv/cqgQyIl+bgwtg/ELs/iG350OWnjbYYYSiLLOtMysd4Rd9
BVhkuGhicW4b7dkdtrGrbDG9Vkwo1Ge9IV46YDpLhEotDIZuwBaik0bX3jKvGroS
Jc/35ZZA68r3xYvvi4ml3pMPSF6fpL6vUMNx9p5n98DgvwPii8Wv+7oXgwpzYzsS
FWljXojpwFZbWqUOVxAZpmGHCPLbInkPODddgw2dklrhAJ8v3Lx4UktoIN5gd6Fu
dgMg6LTTCPfe+0aDUc9aCkMpxBnbfjqrSQoChxHXlBgNqabFzh/P5jVWeqgftEKl
y/ul1bjbFOwLvSVWDF1fzWvvNrV5pvUE3U7CfK5b0uKm0+Y45LkZ3n1XwR1RLunh
KuXEzHnV8vlsz2DEcR2oUHmi4fcjw3YdSkLRae1XALCs7s3T4JVAwbig6bE1YIZ/
NSZVJzngXcE=
=eICf
-----END PGP SIGNATURE-----

--=-twXYfa+Q2yin36w/8ubv--
