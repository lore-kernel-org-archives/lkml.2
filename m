Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566Ab2CJSoh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 13:44:37 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44413 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab2CJSoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 13:44:19 -0500
Date: Sat, 10 Mar 2012 19:44:07 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Joe Perches <joe@perches.com>
Cc: Anatolij Gustschin <agust@denx.de>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Jeff Garzik <jgarzik@pobox.com>, kernel-janitors@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] drivers/ata/pata_mpc52xx.c: add missing kfree
Message-ID: <20120310184407.GB4139@pengutronix.de>
References: <1331402199-8000-1-git-send-email-Julia.Lawall@lip6.fr>
 <20120310181315.GA4139@pengutronix.de>
 <1331404377.14442.19.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cvVnyQ+4j833TQvp"
Content-Disposition: inline
In-Reply-To: <1331404377.14442.19.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cvVnyQ+4j833TQvp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Anatolij is not listed as a maintainer for this file
> nor has he ever written or signed a patch for it.

I noticed that Grant was in CC, assumed that it was because of his previous=
 MPC
maintainership and mentioned that Anatolij took over. Nothing more, just wa=
nted
to help.

> It'd be possible to add patterns to MAINTAINERS
> if Anatolij really wants to see changes to drivers.

It seems a bit too much for my taste (hardly readable? false positives?), b=
ut
then again, it is not my decision, but Anatolij's :)

Thanks!

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--cvVnyQ+4j833TQvp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9boPcACgkQD27XaX1/VRulfACaA9SJ+mYmDAahULtYCkpEy3fw
2PcAoMrBrav7Iq+Ay12VktLVxc4jHRYV
=14t0
-----END PGP SIGNATURE-----

--cvVnyQ+4j833TQvp--
