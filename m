Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab2B0SIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 13:08:30 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56629 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab2B0SI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 13:08:29 -0500
Date: Mon, 27 Feb 2012 19:08:14 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Roland Stigge <stigge@antcom.de>
Cc: linux-arm-kernel@lists.infradead.org, kevin.wells@nxp.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Subject: Re: [PATCH v3] ARM: LPC32xx: Ethernet support
Message-ID: <20120227180814.GB21386@pengutronix.de>
References: <1330364762-23203-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Content-Disposition: inline
In-Reply-To: <1330364762-23203-1-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

On Mon, Feb 27, 2012 at 06:46:02PM +0100, Roland Stigge wrote:
> This patch adds ethernet support to the LPC32xx ARM architecture. The act=
ual
> driver in drivers/net is contained in a separate patch.
>=20
> Signed-off-by: Roland Stigge <stigge@antcom.de>
>=20
> ---

Please add below this dashed line what changed since the last version. This
makes reviewing easier.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk9Lxo4ACgkQD27XaX1/VRsZEQCgkMQrMjtfsGsTMhPRqCk45iaz
Y9IAoK4xd+x3dhyuUxQ4x1jyEenL+T7N
=7Yau
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
