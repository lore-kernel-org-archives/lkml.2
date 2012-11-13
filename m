Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab2KMLTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 06:19:33 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58056 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754963Ab2KMLTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 06:19:22 -0500
Date: Tue, 13 Nov 2012 12:19:12 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Peter Korsgaard <jacmet@sunsite.dk>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: i2c-ocores: Use devm_request_and_ioremap()
Message-ID: <20121113111912.GH23119@pengutronix.de>
References: <1344408872-1051-1-git-send-email-thierry.reding@avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6b3yLyRKT1M6kiA0"
Content-Disposition: inline
In-Reply-To: <1344408872-1051-1-git-send-email-thierry.reding@avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6b3yLyRKT1M6kiA0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 08, 2012 at 08:54:32AM +0200, Thierry Reding wrote:
> Replacing the devm_request_mem_region() and devm_ioremap_nocache() calls
> by a single call to devm_request_and_ioremap() simplifies the code.
>=20
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

Applied to for-next, thanks.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--6b3yLyRKT1M6kiA0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlCiLLAACgkQD27XaX1/VRuFNwCfXDSB8lTXZnfX4ylXOku7u1qW
k8gAn3UG0vIkAzG52PJjS1E49UtSrX7p
=horz
-----END PGP SIGNATURE-----

--6b3yLyRKT1M6kiA0--
