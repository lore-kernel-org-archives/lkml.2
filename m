Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab0LPS03 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 13:26:29 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33533 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263Ab0LPS0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 13:26:25 -0500
Date: Thu, 16 Dec 2010 19:26:20 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] of: platform: introduce of_probe_platform_driver()
Message-ID: <20101216182620.GA28712@pengutronix.de>
References: <1292519639-21859-1-git-send-email-w.sang@pengutronix.de> <1292519639-21859-2-git-send-email-w.sang@pengutronix.de> <AANLkTimxAGVkQF24YgDt+TxjbXvW+iCNJhqVLwXO6FXD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <AANLkTimxAGVkQF24YgDt+TxjbXvW+iCNJhqVLwXO6FXD@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> 2- of_platform_driver is deprecated.  Drivers should be converted to
> use platform_driver directly.

Ouch, I really should have remembered that. /me grabs a brown paper bag. So=
rry
for the noise, dunno what carried me away.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk0KWcwACgkQD27XaX1/VRuRqACeIKQaLjKS2jbJo6e2Ysknb3G0
G5oAoI2I/2nK+mzxbFWzcLm1fyIOolh4
=3Lo0
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
