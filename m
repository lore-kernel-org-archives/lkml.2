Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753786Ab2FLQZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 12:25:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34727 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab2FLQZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 12:25:43 -0400
Date: Tue, 12 Jun 2012 18:25:27 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: khali@linux-fr.org, ben-linux@fluff.org, swarren@wwwdotorg.org,
        olof@lixom.net, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V2 3/4] i2c: tegra: support for I2C_M_NOSTART
 functionality
Message-ID: <20120612162527.GB24753@pengutronix.de>
References: <1339497451-26260-1-git-send-email-ldewangan@nvidia.com>
 <1339497451-26260-4-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GID0FwUMdk1T2AWN"
Content-Disposition: inline
In-Reply-To: <1339497451-26260-4-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 12, 2012 at 04:07:30PM +0530, Laxman Dewangan wrote:
> Adding support for functionality I2C_M_NOSTART.
> When multiple message transfer request made through i2c
> and if any message is flagged with I2C_M_NOSTART then
> it will not send the start/repeat-start and address of
> that message i.e. sends data directly.
>=20
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
> This is rebased of earlier patch on same support.
> At this time using the new flag I2C_FUNC_NOSTART.
>=20
> No change from V1.

There is a change. It is now dependant on the clk_prepare_enable change
which will go in via arm-soc as discussed previously. Can you resend
please?

> @@ -564,8 +579,14 @@ static int tegra_i2c_xfer(struct i2c_adapter *adap, =
struct i2c_msg msgs[],
> =20
>  	clk_prepare_enable(i2c_dev->clk);

^^^^

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--GID0FwUMdk1T2AWN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/XbXcACgkQD27XaX1/VRtdqACfeEe0JtvcWCgbwSaFVHFCaPdp
LpsAn1JhjLP8fwszNoQEA/2obYH2G1wl
=+Iev
-----END PGP SIGNATURE-----

--GID0FwUMdk1T2AWN--
