Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337Ab2J2Olc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 10:41:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48252 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752714Ab2J2Ol2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 10:41:28 -0400
Message-ID: <1351521683.13356.8.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 102/105] usb: gadget: at91_udc: fix dt support
From: Ben Hutchings <ben@decadent.org.uk>
To: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 29 Oct 2012 14:41:23 +0000
In-Reply-To: <CAHkwnC8awjvFxM1x2VGpG0K44zR2jTo8MRQk1v1YwJwrKxMYnA@mail.gmail.com>
References: <20121028231536.970033833@decadent.org.uk>
	 <20121028231608.685974874@decadent.org.uk>
	 <CAHkwnC8awjvFxM1x2VGpG0K44zR2jTo8MRQk1v1YwJwrKxMYnA@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-xMsjP6Z96BGH6mfQwTnl"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xMsjP6Z96BGH6mfQwTnl
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-10-29 at 07:21 +0100, Fabio Porcedda wrote:
> On Mon, Oct 29, 2012 at 12:17 AM, Ben Hutchings <ben@decadent.org.uk> wro=
te:
> > 3.2-stable review patch.  If anyone has any objections, please let me k=
now.
>=20
> Hi Ben,
> this patch is only useful only for kernel version 3.4 and later,
> because the dt support was
> introduced in the 3.4 release with the following commit:
>      d1494a340807c9b77aa44bc8d8166353df4cf1c3
> so i think it's best to doesn't apply this patch.

Thanks, I'll drop it.

Ben.

--=20
Ben Hutchings
Humans are not rational beings; they are rationalising beings.

--=-xMsjP6Z96BGH6mfQwTnl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUI6Vk+e/yOyVhhEJAQp0cg//S5p1EFKmHEibOlB9wagVSS5xIEo1aaZu
xV+ZADjOrlDRpA1C6lPoGp6jabtUV3+BkJwmEM8EqRAxjyyN3GlMNmWtDy9g96GC
dMS0cDra2+sKltGcT0ErusP0TGfUeSVizZO0FOlgdtP+YrTj5BUPiXJPK3DxI/HZ
rgf1+ZHf419Zh5u1ydhMeXNrPaX4E/I+ZfYgBLIMdPZoQW1c9YzWxpVjQPEetQcp
7Gd9LBH9ALK715AUzroi5MHZEwMNhh4jebYY5HcnZ77ECvcQR905bKU1VXtdmmYv
zgi8jZPfU+02W00MfNaXPUH+B4hF/YbnN1GBbxrEao/M5AtC/2QkNXy4YmvLXxNq
orBctRat7eLPikkhXVgfZ1DRB3AiJXQEyebfgosahT9TKpUtmDM38CQzcAiqbPWS
mPhe3hwiRaw0NPJmZc2NZj6dToAzekdDuAIXJVase8LXO8ea18Tl7JGiC7rTy/88
ycrMRTR1cVMz/YMLbTFvtqKBnwYCcJcFcbGC5fvjRLIw/lvh7IUNiNzU/h51fuPx
dtGjzq4DYWI9hJLvPtE0EwXGQpMfaX7MVxMXDlxi+05ciZjZhG6RsmVLco3BhfmD
SmkIzsDrudsYhzL+ukYcpU6ZsmxdxJMmyB0XlDnALXwazoZ91bTTbpKZdf3/cSA+
t+yxQxqYtzo=
=QoO0
-----END PGP SIGNATURE-----

--=-xMsjP6Z96BGH6mfQwTnl--
