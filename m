Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab2ITKnR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 06:43:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58770 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab2ITKnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 06:43:15 -0400
Date: Thu, 20 Sep 2012 12:43:05 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Jean Delvare <khali@linux-fr.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 1/4] i2c: introduce i2c-cbus driver
Message-ID: <20120920104305.GA2609@pengutronix.de>
References: <1346703805-31598-1-git-send-email-aaro.koskinen@iki.fi>
 <1346703805-31598-2-git-send-email-aaro.koskinen@iki.fi>
 <20120914100806.GC2630@pengutronix.de>
 <20120919200812.GA2063@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
In-Reply-To: <20120919200812.GA2063@blackmetal.musicnaut.iki.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 19, 2012 at 11:08:13PM +0300, Aaro Koskinen wrote:
> On Fri, Sep 14, 2012 at 12:08:06PM +0200, Wolfram Sang wrote:
> > On Mon, Sep 03, 2012 at 11:23:22PM +0300, Aaro Koskinen wrote:
> > > Add i2c driver to enable access to devices behind CBUS on Nokia Inter=
net
> > > Tablets.
> > >=20
> > > The patch also adds CBUS I2C configuration for N8x0 which is one of t=
he
> > > users of this driver.
> > >=20
> > > Cc: linux-i2c@vger.kernel.org
> > > Acked-by: Felipe Balbi <balbi@ti.com>
> > > Acked-by: Tony Lindgren <tony@atomide.com>
> > > Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
> >=20
> > OK, I found the short paragrahp about CBUS in the I2C spec, so I2C might
> > be an appropriate place. Still, before deciding if it should rather be
> > in the core directory, I still have a few questions.
>=20
> Thanks for your feedback. I will fix up the incorrect comments, and do
> other improvements (e.g. use devm_* stuff) in the next version.
>=20
> The questions about delays and bit counts are very valid, but it's
> difficult to do anything with them due to lack of documentation and HW on
> which to test - I have Nokia tablets to test the driver, and the driver
> is very reliable, but I do not know of any other HW with CBUS. :-/

Fine enough, then please add comments saying that.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlBa8zkACgkQD27XaX1/VRsVHwCgsjykOB2kzmTya56rCzCbNrEA
bE4An1fYtsnkBDBxTDYpvivonREAjUfc
=2PKi
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
