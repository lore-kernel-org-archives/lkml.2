Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab2FMOF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 10:05:29 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39061 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab2FMOF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 10:05:27 -0400
Date: Wed, 13 Jun 2012 16:05:10 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: khali@linux-fr.org, ben-linux@fluff.org, swarren@wwwdotorg.org,
        olof@lixom.net, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3 0/4]  i2c: tegra: Bug fixes, cleanups and M_NOSTART
 support
Message-ID: <20120613140510.GA11438@pengutronix.de>
References: <1339582359-7911-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <1339582359-7911-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 13, 2012 at 03:42:35PM +0530, Laxman Dewangan wrote:
> This patch series having the:
> - Handling of late register write due to Tegra PPSB design.
> - support for I2C_M_NOSTART
> - Use devm_* for all allocation.

Thanks. 1/4 applied to for-current, rest to for-next.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/YnhYACgkQD27XaX1/VRu5XQCcDCPoNmRqn8yNGCkWao/Fjq31
lxcAn1IizXi25yAKlJw1Nk2ZJC1cfruq
=aBHw
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
