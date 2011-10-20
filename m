Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab1JTLCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 07:02:18 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38327 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab1JTLCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 07:02:17 -0400
Date: Thu, 20 Oct 2011 13:02:14 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Zeng Zhaoming <zhaoming.zeng@freescale.com>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: Use SGTL5000_LINREG_VDDD_MASK instead of
 hardcoded mask value
Message-ID: <20111020110214.GC2379@pengutronix.de>
References: <1319107769.8866.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4ZLFUWh1odzi/v6L"
Content-Disposition: inline
In-Reply-To: <1319107769.8866.3.camel@phoenix>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4ZLFUWh1odzi/v6L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 20, 2011 at 06:49:29PM +0800, Axel Lin wrote:
> We have defined SGTL5000_LINREG_VDDD_MASK in sgtl5000.h,
> use it instead of hardcoded (0x1 << 4) - 1 for the mask.
>=20
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--4ZLFUWh1odzi/v6L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk6f/7YACgkQD27XaX1/VRujkQCgvbBT+W0D/cvxeU1/RwizmSRl
TN4AniW36F+60OJpzwudfi4Q0q56H6+J
=A16E
-----END PGP SIGNATURE-----

--4ZLFUWh1odzi/v6L--
