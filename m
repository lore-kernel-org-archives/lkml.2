Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab1BGJ3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 04:29:36 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49227 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab1BGJ3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 04:29:34 -0500
Date: Mon, 7 Feb 2011 10:29:30 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Andrew Murray <amurray@mpcdata.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-embedded@vger.kernel.org,
        linux kernel <linux-kernel@vger.kernel.org>, trivial@kernel.org,
        rdunlap@xenotime.net
Subject: Re: [PATCH] printk-formats.txt documentation update
Message-ID: <20110207092930.GA3123@pengutronix.de>
References: <AANLkTikj+FU8OF_-KFr2hmTSWqTHMK5JnrnTVyn-XtxQ@mail.gmail.com>
 <AANLkTimcFvq-cSpain--STuVVg3dUJeTCDrykQ=24egg@mail.gmail.com>
 <AANLkTimsTJ4smnJUfkvYEkJixKQoZNfq6RHU4moLhT0o@mail.gmail.com>
 <AANLkTi=bHe_h1F6Lh=rv6BXmVzkyPSW9u5EKXxpYGuL_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <AANLkTi=bHe_h1F6Lh=rv6BXmVzkyPSW9u5EKXxpYGuL_@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 06, 2011 at 04:23:09PM +0000, Andrew Murray wrote:
> On 6 February 2011 16:14, Andrew Murray <amurray@mpcdata.com> wrote:
> From: Andrew Murray <amurray@mpc-data.co.uk>
>=20
> This patch updates the incomplete documentation concerning the printk
> extended format specifiers.

Good one, thanks!

> +Kernel Pointers:
> +
> +	%pK	0x0
> +
> +	For printing kernel pointers which should be hidden from unprivileged
> +	users. The behaviour of %pK depends on the kptr_resrict sysctl - see

Typo: Should be kptr_restrict.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk1Pu3kACgkQD27XaX1/VRtm1wCgwnMBdLX3kUwURReBPGdgqych
vFEAn0gRJn6kmTXAwYH+B3G1eCusi8+j
=2PET
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
