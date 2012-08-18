Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab2HRMM1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 08:12:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58802 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445Ab2HRMM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 08:12:26 -0400
Date: Sat, 18 Aug 2012 14:12:16 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, khali@linux-fr.org,
        swarren@nvidia.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: tegra: Fix ifdefs for suspend mode
Message-ID: <20120818121216.GA12839@pengutronix.de>
References: <1343655187-18282-1-git-send-email-ldewangan@nvidia.com>
 <20120818070732.GA24639@pengutronix.de>
 <20120818120138.GD21888@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <20120818120138.GD21888@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 18, 2012 at 01:01:38PM +0100, Mark Brown wrote:
> On Sat, Aug 18, 2012 at 09:07:32AM +0200, Wolfram Sang wrote:
> > On Mon, Jul 30, 2012 at 07:03:07PM +0530, Laxman Dewangan wrote:
> > > CONFIG_PM covers runtime only PM.
>=20
> > I am a bit confused by this description. CONFIG_PM_RUNTIME covers
> > runtime PM, no?
>=20
> The issue is that CONFIG_PM doesn't actually enable any of the PM
> callbacks, it only allows you to enable CONFIG_PM_SLEEP and
> CONFIG_PM_RUNTIME.  This means that if you use CONFIG_PM to protect your
> system sleep callbacks they may end up unreferenced if only runtime PM
> is enabled.

Thanks for the explanation!

Laxman, could you update the description to reflect that?

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAvhqAACgkQD27XaX1/VRtUGwCglSe5uQRmDW9RHO+wfJjDuH37
fI8An2P/PT9e+ZvZFS2zUNY4pXdzA7kY
=H7JU
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
