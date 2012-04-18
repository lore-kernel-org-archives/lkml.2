Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab2DROja (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 10:39:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40596 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab2DROj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 10:39:29 -0400
Date: Wed, 18 Apr 2012 16:39:20 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: "Voss, Nikolaus" <N.Voss@weinmann.de>
Cc: "'Hubert Feurstein'" <h.feurstein@gmail.com>,
        "'rmallon@gmail.com'" <rmallon@gmail.com>,
        "'nicolas.ferre@atmel.com'" <nicolas.ferre@atmel.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'balbi@ti.com'" <balbi@ti.com>,
        "'linux-i2c@vger.kernel.org'" <linux-i2c@vger.kernel.org>,
        "'ben-linux@fluff.org'" <ben-linux@fluff.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] i2c-at91: fix data-loss issue
Message-ID: <20120418143920.GA19802@pengutronix.de>
References: <20120413103937.GH7154@arwen.pp.htv.fi>
 <1334317476-10044-1-git-send-email-h.feurstein@gmail.com>
 <EF2E73589CA71846A15D0B2CDF79505D0905D5A1AA@wm021.weinmann.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <EF2E73589CA71846A15D0B2CDF79505D0905D5A1AA@wm021.weinmann.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> I'll repost the driver with your fix on positive feedback from you.
> Thanks for tracking this down.
>=20
> Ben, is there any chance to get this driver into next?

I think sending a new series would be good. It depends a bit on the amount
of donated tags (Tested-by, especially) if it will make it into 3.5.

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+O0hgACgkQD27XaX1/VRuGVwCfbCS5QH55EkuCi1We072O4Wet
1H8AnRYNi+NoqQhdyENB66VTVwGdcko5
=GF9j
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
