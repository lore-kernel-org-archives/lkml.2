Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab0CaIKM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 04:10:12 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43737 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315Ab0CaIKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 04:10:08 -0400
Date: Wed, 31 Mar 2010 10:10:04 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Bryan Wu <bryan.wu@canonical.com>, gerg@uclinux.org,
       amit.kucheria@canonical.com, kernel-team@lists.ubuntu.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] netdev/fec.c: add phylib supporting to enable carrier
	detection
Message-ID: <20100331081004.GB23391@pengutronix.de>
References: <1269597052-10104-1-git-send-email-bryan.wu@canonical.com> <20100331075746.GO2241@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Content-Disposition: inline
In-Reply-To: <20100331075746.GO2241@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> With rounding this would be:
>=20
> (clk_get_rate() + 4999999) / 5000000

Better use DIV_ROUND_UP(clk_get_rate(), 5000000)?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkuzA1wACgkQD27XaX1/VRvefwCcD/QU+dlkXWFsDrjDTt7idHPQ
/boAn3KKMX9GVpD2HgJpBU2YpElzNmPT
=IK7w
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
