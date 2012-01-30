Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab2A3Nfe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 08:35:34 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51834 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab2A3Nfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 08:35:31 -0500
Date: Mon, 30 Jan 2012 14:35:29 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 1/3] regmap: Properly round reg_bytes and val_bytes
Message-ID: <20120130133529.GF15596@pengutronix.de>
References: <1327677023-29310-1-git-send-email-w.sang@pengutronix.de>
 <20120127162837.GB18572@opensource.wolfsonmicro.com>
 <20120128011403.GA6669@pengutronix.de>
 <20120130132134.GB4882@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+jhVVhN62yS6hEJ8"
Content-Disposition: inline
In-Reply-To: <20120130132134.GB4882@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+jhVVhN62yS6hEJ8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Clearly we *can* but there's other bits (chiefly the cache code once we
> acquire the ability to do block operations from cache) which really want
> stuff to be 8 bit aligned.  I deliberately chose to make things byte
> aligned so we have to think about this stuff before we do things that
> make byte aligned stuff hard, it felt like if we were going to take a
> complexity hit we probably want it to be on the odd register formats as
> pretty much all of the more demanding modern devices seem to be going
> for multiples of 8 bits.

Understood. I'd think we will find a non-intrusive way when a more generic
format_x_y-function seems worthwhile.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--+jhVVhN62yS6hEJ8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk8mnKEACgkQD27XaX1/VRuOUgCgkLlMNT015CBrdYZsUdMLAzaj
62UAoJP8bYRSKDU/H6Ogs7g7li5QRV3J
=Chy0
-----END PGP SIGNATURE-----

--+jhVVhN62yS6hEJ8--
