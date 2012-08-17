Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab2HQJbL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 05:31:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600Ab2HQJbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 05:31:06 -0400
Date: Fri, 17 Aug 2012 19:30:46 +1000
From: NeilBrown <neilb@suse.de>
To: Il Han <corone.il.han@gmail.com>
Cc: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        "werner" <w.landgraf@ru.ru>
Subject: Re: [PATCH] twl4030: It would be better not to use the 0b-prefix.
Message-ID: <20120817193046.7eeb758a@notabene.brown>
In-Reply-To: <1345189783-19200-1-git-send-email-corone.il.han@gmail.com>
References: <1345189783-19200-1-git-send-email-corone.il.han@gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/96jo.C/=CB2OGz9.EhoRNtA"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/96jo.C/=CB2OGz9.EhoRNtA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 17 Aug 2012 16:49:43 +0900 Il Han <corone.il.han@gmail.com> wrote:

> It would be better not to use the 0b-prefix for earlier versions of gcc-4=
.3.
> Please, Modify it.
>=20
> Signed-off-by: Il Han <corone.il.han@gmail.com>
> ---
>  drivers/power/twl4030_charger.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_char=
ger.c
> index 15f4d5d..8d6bc68 100644
> --- a/drivers/power/twl4030_charger.c
> +++ b/drivers/power/twl4030_charger.c
> @@ -41,16 +41,16 @@
>  #define TWL4030_STS_VBUS	BIT(7)
>  #define TWL4030_STS_USB_ID	BIT(2)
>  #define TWL4030_BBCHEN		BIT(4)
> -#define TWL4030_BBSEL_MASK	0b1100
> -#define TWL4030_BBSEL_2V5	0b0000
> -#define TWL4030_BBSEL_3V0	0b0100
> -#define TWL4030_BBSEL_3V1	0b1000
> -#define TWL4030_BBSEL_3V2	0b1100
> -#define TWL4030_BBISEL_MASK	0b11
> -#define TWL4030_BBISEL_25uA	0b00
> -#define TWL4030_BBISEL_150uA	0b01
> -#define TWL4030_BBISEL_500uA	0b10
> -#define TWL4030_BBISEL_1000uA	0b11
> +#define TWL4030_BBSEL_MASK	0x0c
> +#define TWL4030_BBSEL_2V5	0x00
> +#define TWL4030_BBSEL_3V0	0x04
> +#define TWL4030_BBSEL_3V1	0x08
> +#define TWL4030_BBSEL_3V2	0x0c
> +#define TWL4030_BBISEL_MASK	0x03
> +#define TWL4030_BBISEL_25uA	0x00
> +#define TWL4030_BBISEL_150uA	0x01
> +#define TWL4030_BBISEL_500uA	0x02
> +#define TWL4030_BBISEL_1000uA	0x03
> =20
>  /* BCI interrupts */
>  #define TWL4030_WOVF		BIT(0) /* Watchdog overflow */

Thanks.  I'd been meaning to send that patch, but life got in the way
recently.

Acked-by: NeilBrown <neilb@suse.de>

NeilBrown

--Sig_/96jo.C/=CB2OGz9.EhoRNtA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUC4PRjnsnt1WYoG5AQIF+Q//V91JnStE3Nvt2TBGnpiRQPAffv/M5uvO
RJelBcFncBn98AjTiiCy5qToIdrQ4ACcgTQhrxXr4L69z5v3/daGuZLqmFJywFDY
GppQfeppExp7uuQ7T/wmTEPy/zs4UUIAHWi/9+X0hlhA7DGj6K+DsVdg+3HPcNiv
9VooRDTaDfxlyJPs92P8S3uscCXHKLnOJqprtdaxZWOOY3+8fboy2JolF0nZnxra
mHCzHhEfNSqVIqx0unsNIRT1O2RSi9pI5RB5G2sr/xkcWXkVNcLZc7bdhoXgcP17
HAfmRRFEPNQhol9yE5lOINSx9ta3VUfQjCYtGHoWKiLSLcrS913WeHFyPuLYaPjl
cCs/Vh6U4FAtfLOOndzqp7tFj5qglEiXdBtSXRdOh4mO3VHXR0lgVz2GnCx9N4u2
OZZlzWoe8AWc8Y7aGrH4xzrPwdphJf7MKHopdOJ9pVRo5FrFpf+N4ITtEQlugUx7
ooYttnCtsJ6IeyKCdBKWnmrcXKvQ3GY0+bMMksxLAYBlIQZ74vGQ16zA1eKfk/Ea
9UEV6ygTVkeQjGkgESY5j4H8P7HozbSDK86+0FSzbk3eq3tkP4r08BZqvCY4ZLoP
aggbc6XZhBW07B3AFerOzm34sHBIelwkfjWLmElYieh501iIgMoG97FbwiG74JTG
2XuDeY76aqA=
=ikkL
-----END PGP SIGNATURE-----

--Sig_/96jo.C/=CB2OGz9.EhoRNtA--
