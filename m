Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab2HSGd6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 02:33:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35819 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab2HSGdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 02:33:24 -0400
Date: Sun, 19 Aug 2012 08:33:14 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: khali@linux-fr.org, swarren@nvidia.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V2 1/2] i2c: tegra: I2_M_NOSTART functionality not
 supported in Tegra20
Message-ID: <20120819063314.GA2147@pengutronix.de>
References: <1345317467-22258-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
In-Reply-To: <1345317467-22258-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 19, 2012 at 12:47:46AM +0530, Laxman Dewangan wrote:
> Tegra20 i2c controller does not support the continue transfer
> which implements the I2C_M_NOSTART functionality of i2c
> protocol mangling.
> Removing the I2C_M_NOSTART functionality support for Tegra20.
>=20
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> Changes from V1:
> - make the hw feature structure as part of tegra device structure in
>   place of copying the member.
> - Remove check for extra M_NOSTART flag if it is not supported in xfer fu=
nction.
>=20
> Please note that this should go on tegra common clock source tree to avoi=
d conflicts.

Looks good to me regarding the I2C part:

Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAwiKoACgkQD27XaX1/VRs8MwCfROdoJPccn631aBFjG2WhGuDW
bUQAnR3c2FBXVIjkT0KHva7nssU0dhJE
=0ojK
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
