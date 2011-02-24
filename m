Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab1BXIp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 03:45:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34860 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab1BXIp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 03:45:57 -0500
Date: Thu, 24 Feb 2011 09:45:54 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 2/2] hwmon: adt7411: add MODULE_DEVICE_TABLE
Message-ID: <20110224084554.GB4901@pengutronix.de>
References: <1298514037.19027.3.camel@mola>
 <1298514121.19027.5.camel@mola>
 <20110224033310.GB4596@ericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rJwd6BRFiFCcLxzm"
Content-Disposition: inline
In-Reply-To: <20110224033310.GB4596@ericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rJwd6BRFiFCcLxzm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 23, 2011 at 07:33:10PM -0800, Guenter Roeck wrote:
> On Wed, Feb 23, 2011 at 09:22:01PM -0500, Axel Lin wrote:
> > The device table is required to load modules based on modaliases.
> >=20
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
>=20
> Applied.

That was fast :)

FWIW

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--rJwd6BRFiFCcLxzm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk1mGsIACgkQD27XaX1/VRv5RwCfRwwPixxxbxArCnrnmO/dNTmX
rJEAoKw3UKighx7wW9XslJbM1q8V5J8y
=FGvy
-----END PGP SIGNATURE-----

--rJwd6BRFiFCcLxzm--
