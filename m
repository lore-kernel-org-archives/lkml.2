Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab2LUJGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 04:06:42 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:54283 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339Ab2LUJGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 04:06:32 -0500
Date: Fri, 21 Dec 2012 11:06:25 +0200
From: Felipe Balbi <balbi@ti.com>
To: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] arm/davinci/musb: fix mispint introduced by commit
 032ec49f5351e9cb242b1a1c367d14415043ab95
Message-ID: <20121221090625.GA31453@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1356040747-15105-1-git-send-email-mikhail.kshevetskiy@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <1356040747-15105-1-git-send-email-mikhail.kshevetskiy@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 21, 2012 at 01:59:06AM +0400, Mikhail Kshevetskiy wrote:

please respin this patch with a real commit log.

> Signed-off-by: Mikhail Kshevetskiy <mikhail.kshevetskiy@gmail.com>
> ---
>  drivers/usb/musb/da8xx.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/usb/musb/da8xx.c b/drivers/usb/musb/da8xx.c
> index 8bc44b7..0ed24a6 100644
> --- a/drivers/usb/musb/da8xx.c
> +++ b/drivers/usb/musb/da8xx.c
> @@ -327,7 +327,7 @@ static irqreturn_t da8xx_musb_interrupt(int irq, void=
 *hci)
>  		u8 devctl =3D musb_readb(mregs, MUSB_DEVCTL);
>  		int err;
> =20
> -		err =3D musb->int_usb & USB_INTR_VBUSERROR;
> +		err =3D musb->int_usb & MUSB_INTR_VBUSERROR;
>  		if (err) {
>  			/*
>  			 * The Mentor core doesn't debounce VBUS as needed
> --=20
> 1.7.10.4
>=20

--=20
balbi

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ1CaRAAoJEIaOsuA1yqREG2MP/2fqv5j0vUp26L+Uly5Oplbq
Qs3gzWc5YqWrx6Iv3D2BY9cPcIGd4CKCI5bDUEXA3QycgdhTXwIhqzv2m+/cYNGI
ARSJ98/ShnZ8j3J3zerCo//j/PMMp3mumoR/n6ihfyazu29AYO6/MuV2WAm03Jtj
dbg6pvxW6ncItsYVZTojMrK8iOQOeZQcOxsUsUke8VEx/JQuZtT66eDcl7qedKLY
UDlV2hUmC+rwDBKvamFmflEEnl6mc1CLvpzcyR3WGj2Ri+HBy9lZtB2jAWOGtAXT
beWnbhiH7gI6MkgLF5Jw98FrzI9ovtgia+OeqJCA45J5IMsEnWPW6FY6sZWtDu9E
wMivxGBD3/BnAsy0jrKWdUMOFO52emYHRPt9JbBaQ4d9J+elIURHwZDAXPrb5bfH
OOQCF2lrTsAS9Out9/e9Ycg4EtwPNxjRqbAU5AQuhJaSzTAZbg0FsdXvMwtEuyws
zedKVuWNP9nYAsNWw5F/tkuQ72aPV+WNaxhkYfqkKwv6nrYPFaC61suBROnNRJCJ
ttEq+iZUdFiwehGGr0XiCrmToKVmt4Vvmooh1v5FWHwjvIxLC+87AJ/k69xEng80
TM/SkOB9L5sUCjqk9hmIA5AZINREyRXxDlJoxpk5zXKHnsHTqa7WBkbgdu/mrarW
VqqvEFktbuIEeSpgbfvh
=mMSZ
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
