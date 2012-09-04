Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698Ab2IDJUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 05:20:36 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39491 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752722Ab2IDJUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 05:20:35 -0400
Date: Tue, 4 Sep 2012 11:20:20 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: Kevin Wells <kevin.wells@nxp.com>,
        "vitalywool@gmail.com" <vitalywool@gmail.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srinivas Bakki <srinivas.bakki@nxp.com>,
        "aletes.xgr@gmail.com" <aletes.xgr@gmail.com>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>
Subject: Re: [PATCH RESEND 1/2] i2c: pnx: Fix bit definitions
Message-ID: <20120904092020.GA21271@pengutronix.de>
References: <1344411752-23469-1-git-send-email-stigge@antcom.de>
 <20120818095108.GB24812@pengutronix.de>
 <5030A81E.5090508@antcom.de>
 <083DF309106F364B939360100EC290F823A0354A3D@eu1rdcrdc1wx030.exi.nxp.com>
 <20120820175527.GA9169@pengutronix.de>
 <50451016.7010608@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <50451016.7010608@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 03, 2012 at 10:16:22PM +0200, Roland Stigge wrote:
> Hi Wolfram,
>=20
> On 20/08/12 19:55, Wolfram Sang wrote:
> >> I've never had my hands on a PNX4008 chip at NXP, but I do
> >> believe they are the same IP. That specific I2C IP was used in a
> >> number of NXP/Phillips chips besides the PNX4008/LPC32xx. I don't
> >> think there are any PNX4008's in the wild, and even working in
> >> NXP, I can't find any non-marketing reference material for that
> >> part (including the user manual).
> >=20
> > Thanks for the heads up. I'll apply both patches, then.
>=20
> Should I consider the two patches as applied now (where?
> i2c-embedded?), or should I resend? ;-)

I will apply them these days and then let them stay in linux-next for a
few days. So, I'd think they should go in for rc6.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlBFx9QACgkQD27XaX1/VRtkagCeJFTChjISeMcjcJcfwwThIKIF
nSQAmwSl2JaWlr0kFa3Kk5jVt6N5kQGQ
=h8Ur
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
