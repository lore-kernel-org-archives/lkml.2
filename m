Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732Ab2JGBCS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 21:02:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57717 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750954Ab2JGBCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 21:02:17 -0400
Message-ID: <1349571728.16173.80.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 29/52] xHCI: add aborting command ring function
From: Ben Hutchings <ben@decadent.org.uk>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Elric Fu <elricfu1@gmail.com>,
        Miroslav Sabljic <miroslav.sabljic@avl.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sun, 07 Oct 2012 02:02:08 +0100
In-Reply-To: <20121004210638.997023603@linuxfoundation.org>
References: <20121004210635.372689554@linuxfoundation.org>
	 <20121004210638.997023603@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Fx8WQP10qGLbJB3XTfxy"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Fx8WQP10qGLbJB3XTfxy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-10-04 at 14:21 -0700, Greg Kroah-Hartman wrote:
[...]
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -52,7 +52,7 @@ MODULE_PARM_DESC(link_quirk, "Don't clea
>   * handshake done).  There are two failure modes:  "usec" have passed (m=
ajor
>   * hardware flakeout), or the register reads as all-ones (hardware remov=
ed).
>   */
> -static int handshake(struct xhci_hcd *xhci, void __iomem *ptr,
> +int handshake(struct xhci_hcd *xhci, void __iomem *ptr,
>  		      u32 mask, u32 done, int usec)
>  {
>  	u32	result;
[...]

I don't think it matters for stable, but since this function is now
extern it should have an 'xhci_' prefix.

Ben.

--=20
Ben Hutchings
You can't have everything.  Where would you put it?

--=-Fx8WQP10qGLbJB3XTfxy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUHDUkOe/yOyVhhEJAQoaUxAAlR5kc1XcZ+QmAJnJQ+ky08a3eFUXVLbt
IX+Ao55dtOvWK5rbrjezFYjOBIhPjtVi1q2Q64s3thowp7t7MyFmpsB4Wl+p6jr9
Z4PjCTPB+8Jb3ZY0GMlFCreJN0Raj48r9unuUq+/u4B75LKYwt82v2sXYVQw7o7t
+6rX9dz72By+cQumRUvbOWSz20hIvbBgNlrKAWwJP82/V9RZuad9ZaZ/ixVfuPI3
xLrH9TnSD49hP/yDiG705iU/BwFOrTJo+bilbXGSaMSTmrMdXv6GSiV7qS2MytcH
okvhNLQnN8EvaX57bt1VdIlGIS8DygNvRHCJghyY+tkCwhWZjNIq0MVQTJlIJyrl
xtSmsji+R45m7nSf0Do/c/3GQWJP1EQZqepkmgnSYgy7TuLywk/I4tBiDj1t6+cw
oxL3O2MI9rLkU9SM71p15JJw6GtSpijk7lKTiLN5LdW6i5tPOjOfJteVE2jALHLt
q/C33/ni9i9b3kfY92nIupLrrgoqxQAM4lJgzsiu2f9mUYJCgonEMYlk3KBM5Xw/
UKnIkoM7+rnStkEuKVQqdZ69na8Iu9pbYepLCBiMzW4K658VUsfRI6pqjYL8LC/K
pbj00qrkFcyV9PtlzQpH4s1vtpdJy9Xx/azosnoNPTbd2BkJ0t6ak2tQ+bo/aqqd
z6JKcUZH9fk=
=eFDY
-----END PGP SIGNATURE-----

--=-Fx8WQP10qGLbJB3XTfxy--
