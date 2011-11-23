Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab1KWVw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 16:52:27 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:57976 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab1KWVwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 16:52:25 -0500
Date: Wed, 23 Nov 2011 22:52:23 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Marc Vertes <marc.vertes@sigfox.com>, broonie@opensource.wolfsonmicro.com,
        linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        HaraldWelte@viatech.com
Subject: Re: [PATCH RFC] watchdog: add a new driver for VIA chipsets
Message-ID: <20111123215223.GC32669@pengutronix.de>
References: <4ecbd66c.8a87vIwdu0Z+quuZ%marc.vertes@sigfox.com>
 <20111122173227.GK6624@sirena.org.uk>
 <20111122184051.GA30941@pengutronix.de>
 <4eccc3f0.iApQ//mCzaN3UsrB%marc.vertes@sigfox.com>
 <20111123104926.GB4063@pengutronix.de>
 <20111123121329.GM23376@infomag.iguana.be>
 <20111123122018.GA12227@opensource.wolfsonmicro.com>
 <20111123124037.GN23376@infomag.iguana.be>
 <4ecd075d.2YyTTCA13zxwZmwT%marc.vertes@sigfox.com>
 <20111123214338.GP23376@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qtZFehHsKgwS5rPz"
Content-Disposition: inline
In-Reply-To: <20111123214338.GP23376@infomag.iguana.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qtZFehHsKgwS5rPz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > I do not fully understand yet what has to be done with the timer.
>=20
> Below the example driver that should get included in the Documentation.

Shouldn't the timer stuff go to the core instead, activated by some flag?

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--qtZFehHsKgwS5rPz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7NaxcACgkQD27XaX1/VRun2QCfbrqZEdpjNZvs/8cIAJz0TSRw
rtEAoJdLnVTojGS0m0vqOl8XrGcGcU9J
=bEbx
-----END PGP SIGNATURE-----

--qtZFehHsKgwS5rPz--
