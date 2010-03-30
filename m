Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab0C3Mr6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 08:47:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52737 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab0C3Mr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 08:47:56 -0400
Date: Tue, 30 Mar 2010 14:47:54 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: kernel-janitors@vger.kernel.org, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 17/24] regulator: fix dangling pointers
Message-ID: <20100330124754.GL29472@pengutronix.de>
References: <1269094385-16114-1-git-send-email-w.sang@pengutronix.de> <1269094385-16114-18-git-send-email-w.sang@pengutronix.de> <1269287350.3754.22.camel@odin>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FnOKg9Ah4tDwTfQS"
Content-Disposition: inline
In-Reply-To: <1269287350.3754.22.camel@odin>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FnOKg9Ah4tDwTfQS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 22, 2010 at 07:49:10PM +0000, Liam Girdwood wrote:
> On Sat, 2010-03-20 at 15:12 +0100, Wolfram Sang wrote:
> > Fix I2C-drivers which missed setting clientdata to NULL before freeing =
the
> > structure it points to. Also fix drivers which do this _after_ the stru=
cture
> > was freed already.
> >=20
> > Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> > Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> > Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > ---
> >=20
>=20
> Applied.

Thanks. An update will be needed though. But we will take care of it!

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--FnOKg9Ah4tDwTfQS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkux8voACgkQD27XaX1/VRvqzQCgoo9UfUUrP+Y5X9g0wL4yyTj7
5K8AnAn1KMgqMK1J+UnjLi2fj9X4siZB
=qMhL
-----END PGP SIGNATURE-----

--FnOKg9Ah4tDwTfQS--
