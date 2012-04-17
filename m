Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab2DQOVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 10:21:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51408 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab2DQOVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 10:21:07 -0400
Date: Tue, 17 Apr 2012 16:21:05 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Zhao Chenhui <chenhui.zhao@freescale.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Yang <leoli@freescale.com>
Subject: Re: [PATCH] i2c-mpc: avoid I2C abnormal after resuming from deep
 sleep
Message-ID: <20120417142105.GA21802@pengutronix.de>
References: <1330511961-22498-1-git-send-email-chenhui.zhao@freescale.com>
 <20120229183436.GA30545@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <20120229183436.GA30545@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 29, 2012 at 07:45:23PM +0100, Wolfram Sang wrote:
> Hi,
>=20
> On Wed, Feb 29, 2012 at 06:39:21PM +0800, Zhao Chenhui wrote:
> > When entering deep sleep, the value in the registers I2CFDR and
> > I2CDFSRR are lost. This causes I2C access to fail after resuming.
> >=20
> > Add suspend/resume routines to save/restore the registers
> > I2CFDR and I2CDFSRR.
> >=20
> > Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> > Signed-off-by: Li Yang <leoli@freescale.com>
> > ---
> >  drivers/i2c/busses/i2c-mpc.c |   34 +++++++++++++++++++++++++++++++++-
> >  1 files changed, 33 insertions(+), 1 deletions(-)
> >=20
> > diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
> > index a8ebb84..f95a647 100644
> > --- a/drivers/i2c/busses/i2c-mpc.c
> > +++ b/drivers/i2c/busses/i2c-mpc.c
> > @@ -1,7 +1,9 @@
> >  /*
> >   * (C) Copyright 2003-2004
> >   * Humboldt Solutions Ltd, adrian@humboldt.co.uk.
> > -
> > + *
> > + * Copyright 2012 Freescale Semiconductor, Inc.
> > + *
>=20
> I'd think the change is too trivial to claim copyright on the file.

Do you want to resend with the comments addressed?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+NfFEACgkQD27XaX1/VRsRyQCePPnnlynynpq5hVQMeZDBMIWu
crsAnA4Xgpuf089oXkaxypETfwVnrNg9
=TAH2
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
