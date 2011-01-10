Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab1AJVFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 16:05:20 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48223 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab1AJVFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 16:05:17 -0500
Date: Mon, 10 Jan 2011 22:05:09 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-mmc@vger.kernel.org, trivial@kernel.org,
        linux-kernel@vger.kernel.org, Axel Lin <axel.lin@gmail.com>,
        Chris Ball <cjb@laptop.org>, David Vrabel <david.vrabel@csr.com>
Subject: Re: [PATCH] USB SD Host Controller: Including usb.h once is enough
Message-ID: <20110110210509.GD31011@pengutronix.de>
References: <alpine.LNX.2.00.1101102153280.32164@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Hf61M2y+wYpnELGG"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1101102153280.32164@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Hf61M2y+wYpnELGG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 10, 2011 at 09:56:08PM +0100, Jesper Juhl wrote:
>=20
> Including usb.h once is enough in drivers/mmc/host/ushc.c
> This removes the duplicate.
>=20
>=20
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Correct. Why the newlines in the commit-msg?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Hf61M2y+wYpnELGG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk0rdIUACgkQD27XaX1/VRvkhwCfYGhyRyJuSZFg07zlwSo9VLL1
Zd8An3RPpMC3qJ2vFYSw+nCq5Id+OlUW
=fjM+
-----END PGP SIGNATURE-----

--Hf61M2y+wYpnELGG--
