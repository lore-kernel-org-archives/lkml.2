Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab2KMLU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 06:20:26 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58070 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964Ab2KMLUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 06:20:14 -0500
Date: Tue, 13 Nov 2012 12:20:00 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: "Maxin B. John" <maxin.john@gmail.com>
Cc: Peter Korsgaard <jacmet@sunsite.dk>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>
Subject: Re: [PATCH 2/2] i2c: busses: i2c-ocores: switch to
 devm_request_and_ioremap
Message-ID: <20121113112000.GI23119@pengutronix.de>
References: <20120923133358.GA22861@linux-3ix0.site>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1y6imfT/xHuCvpN0"
Content-Disposition: inline
In-Reply-To: <20120923133358.GA22861@linux-3ix0.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1y6imfT/xHuCvpN0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 23, 2012 at 09:33:58AM -0400, Maxin B. John wrote:
> This drops a few lines of code and allows common APIs to handle those for=
 us.
>=20
> Signed-off-by: Maxin B. John <maxin.john@gmail.com>

Thanks, I just applied a very similar patch by Thierry Reding which was
sent earlier.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--1y6imfT/xHuCvpN0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlCiLOAACgkQD27XaX1/VRtqbACgvYNr1kOOLmSrF2xAURrq2EbQ
qScAoJM5dx4ERt6KsE2HDLsDCIMYE4Ca
=VvVM
-----END PGP SIGNATURE-----

--1y6imfT/xHuCvpN0--
