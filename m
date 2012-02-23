Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932155Ab2BWK2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 05:28:51 -0500
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:46074 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932121Ab2BWK2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 05:28:49 -0500
Date: Thu, 23 Feb 2012 12:28:40 +0200
From: Felipe Balbi <balbi@ti.com>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: Felipe Balbi <balbi@ti.com>, Danny Kukawka <dkukawka@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] at91_udc: linux/prefetch.h included twice
Message-ID: <20120223102839.GX18463@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1329328567-5012-1-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8D1TCnBmjJJF2KCx"
Content-Disposition: inline
In-Reply-To: <1329328567-5012-1-git-send-email-danny.kukawka@bisect.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8D1TCnBmjJJF2KCx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 15, 2012 at 06:56:07PM +0100, Danny Kukawka wrote:
> drivers/usb/gadget/at91_udc.c included 'linux/prefetch.h' twice,
> remove the duplicate.
>=20
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>

applied, thanks

--=20
balbi

--8D1TCnBmjJJF2KCx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRhTXAAoJEIaOsuA1yqRE8QAP/iJBZadkWdXuItQ17WlEjXEt
AbhXENxXVQE4Gm228VvbZyELgLWvObkHsX6zzA8wnk2hGHXrZKpO3ViVEbwhHFCS
vqi3Hm0QL2vtGSyl6JTsq30sP1Zkj9mQAWpEVDIrPalfM8EQ/cUQYJ3lZ0/+d5v3
NLz7Bsc60k2ioQIWTbPP6Or8GDupZLOWw6h3Zc53hX+PWGO2HJsAaZFcewldwlxS
740swkLLLRgpVPrOik1O/lAeZbCMUx31Y9agAxt3cSHGjw+b6rBLiKmaftq/iEpv
jFF9jB7+klWyPmimmxN2FAmakqvGl9XZSVYahuS71MYwlwdIy6tOfd+OgGzOy9L5
/O3lXHfePwsY20o2cYFYTGcPRe19BEamXf3LtdtCJYdkcubtixHNfSyGmRHUuPh/
I4z/bBmLumV3anIA1EgINQjn5qtKGUe9XtCJg8Ghjrn+N+8F0v4AunYRqt86p9Ia
bPnisXEetBP7a6/xj6V+qeLjvBBhdt2LypgmX72Vp7Uyh0QOhkz9TrFBMrVoCwgM
WcFJgNRfSBkywbXbaTheL/Jx3azCIeWGqrHuo7eWNuKB8XUpKFUhRga/XNHn/w/S
+JBZej9uIF+qaSOJTvNK8yxowd/7nFIzbikjTMKEJPFO40gV0i+aSaa8w7DVDzto
q1yVHOq8yxlgGfoYj28O
=mhGd
-----END PGP SIGNATURE-----

--8D1TCnBmjJJF2KCx--
