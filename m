Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964869Ab2KOKS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 05:18:29 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44175 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964838Ab2KOKS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 05:18:28 -0500
Date: Thu, 15 Nov 2012 11:18:20 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: "chuansheng.liu@intel.com" <chuansheng.liu@intel.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [PATCH 1/7] I2c-nomadik: Fix the usage of
 wait_for_completion_timeout
Message-ID: <20121115101820.GC418@pengutronix.de>
References: <1352222317.15558.1584.camel@cliu38-desktop-build>
 <CACRpkdYekQF5111NSNSPeaHdxgS_gpXkCjqT1n-n1_iAdDXbSg@mail.gmail.com>
 <20121115084858.GA29668@bnru10>
 <20121115092953.GA418@pengutronix.de>
 <20121115095741.GA6280@bnru10>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C94crkcyjafcjHxo"
Content-Disposition: inline
In-Reply-To: <20121115095741.GA6280@bnru10>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C94crkcyjafcjHxo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 15, 2012 at 03:27:42PM +0530, Srinidhi Kasagar wrote:
> On Thu, Nov 15, 2012 at 10:29:53 +0100, Wolfram Sang wrote:
> >=20
> > > > -       if (timeout < 0) {
> > > > -               dev_err(&dev->adev->dev,
> > > > -                       "wait_for_completion_timeout "
> > > > -                       "returned %d waiting for event\n", timeout);
> > > > -               status =3D timeout;
> > > > -       }
> > > > -
> > > No, it is wrong. You need to update the status variable in the case o=
f timeout.
> >=20
> > Looking at the patch context, such code comes later.
> But it causes regressions; without looking at the "later" code, we can't =
afford merging
> this code now.

Later as in "a few lines later" not "some time later". Or am I missing
something else?

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--C94crkcyjafcjHxo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlCkwWwACgkQD27XaX1/VRukewCdHgxxIEsKSngw5LopT7WAECRa
CxwAn1GR0ahWKqSoV/fJeL4ncyKPFKf2
=/CFu
-----END PGP SIGNATURE-----

--C94crkcyjafcjHxo--
