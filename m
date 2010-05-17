Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab0EQJxb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 05:53:31 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49336 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab0EQJx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 05:53:29 -0400
Date: Mon, 17 May 2010 11:53:28 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Antonio Ospite <ospite@studenti.unina.it>,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: [PATCH v2] leds-lp3944: properly handle lp3944_configure fail
	in lp3944_probe
Message-ID: <20100517095328.GF22781@pengutronix.de>
References: <1274089668.28623.3.camel@mola>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w3uUfsyyY1Pqa/ej"
Content-Disposition: inline
In-Reply-To: <1274089668.28623.3.camel@mola>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w3uUfsyyY1Pqa/ej
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 17, 2010 at 05:47:48PM +0800, Axel Lin wrote:
> In current implementation, lp3944_probe return 0 even if lp3944_configure=
 fail.
> Therefore, led_classdev_unregister will be executed twice
> ( in error handling of lp3944_configure and lp3944_remove ).
> This patch properly handles lp3944_configure fail in lp3944_probe.
>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Looks good to me.

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--w3uUfsyyY1Pqa/ej
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkvxEhgACgkQD27XaX1/VRssCwCffRsfthPK1hE62Zt1rpLL/EeV
zCAAoI55JnNWN5+LcBsJJKtTGr0Rgux0
=RQp5
-----END PGP SIGNATURE-----

--w3uUfsyyY1Pqa/ej--
