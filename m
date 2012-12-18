Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab2LRKas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 05:30:48 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59743 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab2LRKaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 05:30:46 -0500
Date: Tue, 18 Dec 2012 11:30:37 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Jean Delvare <khali@linux-fr.org>
Cc: Laurent Navet <laurent.navet@gmail.com>, ben-linux@fluff.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver i2c-nforce2: fix pointer CodingStyle issues
Message-ID: <20121218103037.GC2612@pengutronix.de>
References: <1355778259-8445-1-git-send-email-laurent.navet@gmail.com>
 <20121218105223.0184d4a3@endymion.delvare>
 <CAH7P7Nhz2FpBct4afvAXU2Zgi-yA4TkJj7CtYMaW7pXr6weZig@mail.gmail.com>
 <20121218100906.GB2612@pengutronix.de>
 <20121218112355.69369ee1@endymion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ncSAzJYg3Aa9+CRW"
Content-Disposition: inline
In-Reply-To: <20121218112355.69369ee1@endymion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ncSAzJYg3Aa9+CRW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > Are you also able to build-test the changes?
>=20
> Most certainly yes, this driver has almost no dependencies. I will
> build-test it anyway.

Me too :) I just wanted to express that I would love to see a compile
test before submission, even for checkpatch thingies. Can save some
hazzle for all of us.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--ncSAzJYg3Aa9+CRW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlDQRc0ACgkQD27XaX1/VRuVKwCgt/rjkHZ6aKRst3EsaOIoSMhV
D/YAoJe2IoxOZJ84CiXmH8e9fTo0a9V/
=XeWT
-----END PGP SIGNATURE-----

--ncSAzJYg3Aa9+CRW--
