Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab2DRK4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 06:56:16 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52749 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab2DRK4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 06:56:15 -0400
Date: Wed, 18 Apr 2012 12:56:02 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Karol Lewandowski <k.lewandowsk@samsung.com>
Cc: ben-linux@fluff.org, m.szyprowski@samsung.com, thomas.abraham@linaro.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-samsung-soc@vger.kernel.org,
        t.stanislaws@samsung.com, kyungmin.park@samsung.com,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/3] i2c-s3c2410: Drop unused define
Message-ID: <20120418105602.GB21955@pengutronix.de>
References: <1332357113-2973-1-git-send-email-k.lewandowsk@samsung.com>
 <1332357113-2973-2-git-send-email-k.lewandowsk@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dTy3Mrz/UPE2dbVg"
Content-Disposition: inline
In-Reply-To: <1332357113-2973-2-git-send-email-k.lewandowsk@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 21, 2012 at 08:11:51PM +0100, Karol Lewandowski wrote:
> Use standard of_match_ptr() to avoid defining variable unused
> in non device tree builds.
>=20
> Signed-off-by: Karol Lewandowski <k.lewandowsk@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>

I applied this one already.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--dTy3Mrz/UPE2dbVg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+OncIACgkQD27XaX1/VRsZowCfdPzc8izNYMoA/3QsfHlPQxLV
+qcAn0MnVpNS8u7w6SBHGRqwLBVMCsQe
=wj7B
-----END PGP SIGNATURE-----

--dTy3Mrz/UPE2dbVg--
