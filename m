Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab2DRO21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 10:28:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35626 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab2DRO2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 10:28:25 -0400
Date: Wed, 18 Apr 2012 16:27:58 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Alok Chauhan <alokc@nvidia.com>
Cc: swarren@wwwdotorg.org, khali@linux-fr.org, ben-linux@fluff.org,
        swarren@nvidia.com, olof@lixom.net, bones@secretlab.ca,
        omaplinuxkernel@gmail.com, ccross@android.com, ldewangan@nvidia.com,
        linux-tegra@vger.kernel.org, linux-i2c@vger.kernel.org,
        dgreid@chromium.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c: tegra: Add delay before reset the controller
Message-ID: <20120418142758.GE19220@pengutronix.de>
References: <1333345982-16595-1-git-send-email-alokc@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="imjhCm/Pyz7Rq5F2"
Content-Disposition: inline
In-Reply-To: <1333345982-16595-1-git-send-email-alokc@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--imjhCm/Pyz7Rq5F2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 02, 2012 at 11:23:02AM +0530, Alok Chauhan wrote:
> NACK interrupt generated before I2C controller generates
> the STOP condition on bus. In Software, because of this
> reset of controller is happening before I2C controller could
> complete STOP condition. So wait for some time before resetting
> the controller so that STOP condition has delivered properly on bus.
>=20
> Added delay of 2 clock period before reset the
> controller in case of NACK error.
>=20
> Signed-off-by: Alok Chauhan <alokc@nvidia.com>

Applied with Stephen's ACK and slightly reworded comment and commit msg.

Wondering a bit that you want it for 3.5, not for 3.4. Looks like a
bugfix to me.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--imjhCm/Pyz7Rq5F2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+Oz24ACgkQD27XaX1/VRsa7QCggv2aNwPXDAt16LauuUs/fLwY
6okAoI7x3/3McmF0Y4fUHzEUDh1SG86r
=1vge
-----END PGP SIGNATURE-----

--imjhCm/Pyz7Rq5F2--
