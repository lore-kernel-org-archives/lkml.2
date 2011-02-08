Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab1BHVUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 16:20:54 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56289 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551Ab1BHVUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 16:20:52 -0500
Date: Tue, 8 Feb 2011 22:20:46 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Sourav Poddar <sourav.poddar@ti.com>,
        Linux-Next <linux-next@vger.kernel.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: drivers/input/touchscreen/ads7846.c:959: error: 'GPIOF_DIR_IN'
 undeclared
Message-ID: <20110208212046.GA29410@pengutronix.de>
References: <AANLkTim2706Negrvd-ektbNMLwucM9M0icphb_uFY_9D@mail.gmail.com>
 <20110208211035.GC16527@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <20110208211035.GC16527@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 08, 2011 at 01:10:36PM -0800, Dmitry Torokhov wrote:

> Crap, sorry about that, I'll fix it up tonight.

I had the same issue while working on some other gpio-cleanup.
I am just about to finish a patch.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk1Rs64ACgkQD27XaX1/VRviUQCfft151XDHdTwdby8L39uMwkuZ
0VsAoIQZKwV83uRaGRLTQR9lyLX1YtQs
=FSnh
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
