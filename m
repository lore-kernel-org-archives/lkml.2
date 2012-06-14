Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390Ab2FNQIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:08:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55662 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997Ab2FNQIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:08:18 -0400
Date: Thu, 14 Jun 2012 18:07:58 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "olof@lixom.net" <olof@lixom.net>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V3 1/4] i2c: tegra: make sure register writes completes
Message-ID: <20120614160758.GD14419@pengutronix.de>
References: <1339582359-7911-1-git-send-email-ldewangan@nvidia.com>
 <1339582359-7911-2-git-send-email-ldewangan@nvidia.com>
 <4FD8B7FC.3060708@wwwdotorg.org>
 <4FD9DAAC.5000709@nvidia.com>
 <4FDA09FC.1010307@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C+ts3FVlLX8+P6JN"
Content-Disposition: inline
In-Reply-To: <4FDA09FC.1010307@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C+ts3FVlLX8+P6JN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> probably doesn't impact performance. It'd be more self-documenting if
> this readback was limited to the specific registers where it was needed
> though.

I'd think this is easier to maintain in case code gets
rewritten/shuffled around.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--C+ts3FVlLX8+P6JN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/aDF4ACgkQD27XaX1/VRuSwACfX57hbCpT7GodrAIdUbIuFfIc
CMcAnRVfF4Qc6PoJLlvor0/OIW8MAsl6
=mpfj
-----END PGP SIGNATURE-----

--C+ts3FVlLX8+P6JN--
