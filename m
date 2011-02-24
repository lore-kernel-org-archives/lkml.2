Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab1BXUoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 15:44:07 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50977 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab1BXUoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 15:44:03 -0500
Date: Thu, 24 Feb 2011 21:43:52 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Chris Ball <cjb@laptop.org>
Cc: Philip Rakity <prakity@marvell.com>,
        "Dong, Chuanxiao" <chuanxiao.dong@intel.com>,
        Jae hoon Chung <jh80.chung@gmail.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 1/1]mmc: set timeout for SDHCI host before sending busy
 cmd
Message-ID: <20110224204352.GB9841@pengutronix.de>
References: <20110224111935.GB7169@intel.com>
 <AANLkTinJEXc_x36Rht=XfYEtjShAYKWRDcsjGFtd=5Tj@mail.gmail.com>
 <5D8008F58939784290FAB48F5497519835CE59FE81@shsmsx502.ccr.corp.intel.com>
 <79DD18D4-C79A-4B08-B9E6-050D7EF2FC3D@marvell.com>
 <20110224201504.GA12913@void.printf.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hHWLQfXTYDoKhP50"
Content-Disposition: inline
In-Reply-To: <20110224201504.GA12913@void.printf.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hHWLQfXTYDoKhP50
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 24, 2011 at 08:15:04PM +0000, Chris Ball wrote:
> On Thu, Feb 24, 2011 at 10:32:30AM -0800, Philip Rakity wrote:
> > proposed this a while ago and strongly support just removing the quirk =
for broken timeout and setting the timeout value to maximum of 0xE.
> >=20
> > This also handles the case of the sd device having a timeout value too =
low.  In my testing I have come across SD cards that do not provide the cor=
rect value.
> > We force our pxa168, pxa910, and mmp2 controllers to have 0xE. =20
>=20
> Yeah, OLPC's CaFe controller -- which might be the same hardware as yours,
> actually -- has the same problem.
>=20
> Does anyone know of a reason (beyond strict spec-compliance, I suppose)
> for honoring the timeout value rather than using 0xE everywhere?  If not,
> I'm willing to try out Philip's suggestion.

+1. A full cycle in linux-next might an idea to be on the safe side? That w=
ould
be 2.6.40-material then. Or too slow?

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--hHWLQfXTYDoKhP50
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk1mwwgACgkQD27XaX1/VRuEKgCgrfoFiyOxpTEwbTEo2pJusgdU
XxsAoLE1ytg7M0xyoyn2vwrin3y48eAd
=ZExM
-----END PGP SIGNATURE-----

--hHWLQfXTYDoKhP50--
