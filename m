Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645Ab2HRSq3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 14:46:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59371 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab2HRSq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 14:46:27 -0400
Date: Sat, 18 Aug 2012 20:46:20 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: khali@linux-fr.org, swarren@nvidia.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH V2] i2c: tegra: protect suspend/resume callbacks with
 CONFIG_PM_SLEEP
Message-ID: <20120818184620.GC19802@pengutronix.de>
References: <1345292398-10609-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="adJ1OR3c6QgCpb/j"
Content-Disposition: inline
In-Reply-To: <1345292398-10609-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--adJ1OR3c6QgCpb/j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 18, 2012 at 05:49:58PM +0530, Laxman Dewangan wrote:
> The CONFIG_PM doesn't actually enable any of the PM callbacks, it
> only allows to enable CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME.
> This means if CONFIG_PM is used to protect system sleep callbacks
> then it may end up unreferenced if only runtime PM is enabled.
> Hence protecting sleep callbacks with CONFIG_PM_SLEEP.
>=20
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Applied to -current, thanks!

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--adJ1OR3c6QgCpb/j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAv4vwACgkQD27XaX1/VRuwRgCgzEtWwJCz9PkFTwn095N8AbNW
d9UAn1WBYRQXvK8iyjq2rJIkSLxlZdgt
=mA58
-----END PGP SIGNATURE-----

--adJ1OR3c6QgCpb/j--
