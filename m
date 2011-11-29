Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab1K2L6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 06:58:18 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56359 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab1K2L6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 06:58:15 -0500
Date: Tue, 29 Nov 2011 12:58:13 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Marc Vertes <marc.vertes@sigfox.com>, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Dimitry Andric <dimitry.andric@tomtom.com>,
        Ben Dooks <ben@simtec.co.uk>
Subject: Re: [PATCH] watchdog: add nowayout helpers to Watchdog Timer
 Driver Kernel API
Message-ID: <20111129115813.GF5455@pengutronix.de>
References: <20111129111430.GA17609@infomag.iguana.be>
 <20111129114744.GA21542@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7mxbaLlpDEyR1+x6"
Content-Disposition: inline
In-Reply-To: <20111129114744.GA21542@infomag.iguana.be>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7mxbaLlpDEyR1+x6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 29, 2011 at 12:47:44PM +0100, Wim Van Sebroeck wrote:
> Hi Marc, Wolfram,
>=20
> > Add two nowayout helpers for the Watchdog Timer Driver Kernel API.
> >=20
> > Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--7mxbaLlpDEyR1+x6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk7UyNUACgkQD27XaX1/VRs5RQCeMNBsKsJqoZ6oMpC2bwpEgSyA
w7AAoJU/axjvRQEAuDGlnPC2yunPpelU
=+ARp
-----END PGP SIGNATURE-----

--7mxbaLlpDEyR1+x6--
