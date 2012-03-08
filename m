Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390Ab2CHHmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 02:42:11 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58395 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004Ab2CHHmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 02:42:08 -0500
Date: Thu, 8 Mar 2012 08:41:49 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, khali@linux-fr.org,
        ben-linux@fluff.org, grant.likely@secretlab.ca,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH V1] i2c: gpio: Use open drain support from gpio driver
Message-ID: <20120308074149.GA18510@pengutronix.de>
References: <1331127494-6913-1-git-send-email-ldewangan@nvidia.com>
 <20120307173157.GT3107@opensource.wolfsonmicro.com>
 <CACRpkdaEHOGA2XfW1SMJodyf9oTNRF7kk9ErQeSpBv_2TFj=Rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <CACRpkdaEHOGA2XfW1SMJodyf9oTNRF7kk9ErQeSpBv_2TFj=Rg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> I'd ask Grant to take this into the GPIO tree if Broonie can ACK it.

Uhm, why? What's wrong with going in via I2C?

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9YYr0ACgkQD27XaX1/VRsJmQCglYZ0sk7+0qiaIPEl2W3NX/QL
GRsAoIfr13YVx7OtLTGm8Fa1kFckIy2k
=Bk+T
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
