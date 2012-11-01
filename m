Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992589Ab2KAWMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 18:12:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41196 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992558Ab2KAWMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 18:12:15 -0400
Date: Thu, 1 Nov 2012 23:12:00 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: khali@linux-fr.org, ben-linux@fluff.org, swarren@nvidia.com,
        olof@lixom.net, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH REPOST] i2c: tegra: set irq name as device name
Message-ID: <20121101221200.GB22956@pengutronix.de>
References: <1351787894-23477-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JYK4vJDZwFMowpUq"
Content-Disposition: inline
In-Reply-To: <1351787894-23477-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JYK4vJDZwFMowpUq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 01, 2012 at 10:08:14PM +0530, Laxman Dewangan wrote:
> When watching the irqs name of tegra i2c, all instances
> irq name shows as tegra_i2c.
>=20
> Passing the device name properly to have the irq names with
> instance like tegra-i2c.0, tegra-i2c.1 etc.
>=20
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Acked-by: Jean Delvare <khali@linux-fr.org>

Applied to for-current, thanks.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--JYK4vJDZwFMowpUq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlCS87AACgkQD27XaX1/VRvfzQCfWr9v21gPlvC95vloittgOnij
F1MAmgMG9OqCQ++3qZnrYQTd75WPQm1D
=iyzJ
-----END PGP SIGNATURE-----

--JYK4vJDZwFMowpUq--
