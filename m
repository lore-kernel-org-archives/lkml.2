Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab2B0GLJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 01:11:09 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:51327 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601Ab2B0GLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 01:11:07 -0500
Date: Mon, 27 Feb 2012 09:13:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Lionel Debroux <lionel_debroux@yahoo.fr>
Cc: linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] edac: move const pci_device_id tables from __devinitdata
 to __devinitconst.
Message-ID: <20120227061300.GC4763@mwanda>
References: <791782.71473.bm@smtp128.mail.ukl.yahoo.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PuGuTyElPB9bOcsM"
Content-Disposition: inline
In-Reply-To: <791782.71473.bm@smtp128.mail.ukl.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090204.4F4B1E79.00C0,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PuGuTyElPB9bOcsM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 26, 2012 at 09:15:29PM +0100, Lionel Debroux wrote:
> Based on PaX and earlier work by Andi Kleen.
>=20
> Patch against current Linus tree.
>=20

Always write patches against linux-next.  We can't apply this.

I wonder if we could make a coccinelle script for this.

regards,
dan carpenter

--PuGuTyElPB9bOcsM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPSx7rAAoJEOnZkXI/YHqRHKMP/jG8J9wO3O2GGcAfRHpAkty0
FmTPdKveOG3E8vppVBvEG4UEPvuPV7509gqcx/jlJsjtd0zBQHu1vD2BcxxXoPNP
ZcU1Xc9dKW7DR8OgPoBIlMT7lBRZsoEiRRc5Njb8qB6tR2cn5o0geWYfR5Plztyw
te3o1eMFPJ6qzgeLSRfVomXK+bwuYpRFa9k9GKyWsbsMIobnfOW88eFgCJvsehuW
SJD/NsElHLoRM1o/mwtaQHH2gK19iNjaBvFAsQWv/bcs5uDpXUx+NqNdLAJ2jGnQ
sK3XIA3REfeTXFdQ1XDkCIzqYDlK/2c+xdf0GByCePeV5kS9uKe83uEXrfVA4VAD
+5V8C0dY1h6xrq/I8ttQZG9sdC8+MeIZC4mBM8z/QCWr/jA9RfWnSObhjib6vFDH
RNTbogXfTDB7Y03q81hStxEESJaI51NSTt9GKhgkDmyL4LDbvibLK1VwEbmqB9CW
cD2TWyXuk+x2jZCZW3ZuBCcSPKCnXWDEjHtRGLh7AiAt9JTJWU9ARKcLCN8kNIvG
FK7HuCqWbI3qVs/yG+iuD9iKg0ScW+hZQy+Jp0MdR0W9ZDC9yEW8ap3xaBuWyUQp
aMUGGu8F/tcCzX8diRImVG9rJZl9tm/nzMXb3WCm2/GyY6lBxuiTYQR/XWRyqavN
WLWtW4nbfhZX9pW4H0TZ
=FA7v
-----END PGP SIGNATURE-----

--PuGuTyElPB9bOcsM--
