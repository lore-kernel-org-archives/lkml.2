Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992946Ab2KOJaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 04:30:06 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52356 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756017Ab2KOJaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 04:30:04 -0500
Date: Thu, 15 Nov 2012 10:29:53 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: chuansheng.liu@intel.com, linus.walleij@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Fwd: [PATCH 1/7] I2c-nomadik: Fix the usage of
 wait_for_completion_timeout
Message-ID: <20121115092953.GA418@pengutronix.de>
References: <1352222317.15558.1584.camel@cliu38-desktop-build>
 <CACRpkdYekQF5111NSNSPeaHdxgS_gpXkCjqT1n-n1_iAdDXbSg@mail.gmail.com>
 <20121115084858.GA29668@bnru10>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <20121115084858.GA29668@bnru10>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > -       if (timeout < 0) {
> > -               dev_err(&dev->adev->dev,
> > -                       "wait_for_completion_timeout "
> > -                       "returned %d waiting for event\n", timeout);
> > -               status =3D timeout;
> > -       }
> > -
> No, it is wrong. You need to update the status variable in the case of ti=
meout.

Looking at the patch context, such code comes later.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEUEARECAAYFAlCkthEACgkQD27XaX1/VRue5QCfeckXfQePz2lemPalqV4qdR8/
DQQAmOsTqsnFfVP3gXBDLmUN05gVmqE=
=ayxD
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
