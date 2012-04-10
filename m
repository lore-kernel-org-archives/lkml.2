Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab2DJQaE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 12:30:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54849 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751913Ab2DJQaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 12:30:02 -0400
Date: Tue, 10 Apr 2012 17:29:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: twl-regulator: Fix off-by-one vsel setting in
 twl6030smps_set_voltage
Message-ID: <20120410162957.GP7499@opensource.wolfsonmicro.com>
References: <1334070472.18312.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R3SAtXwgGp429mN7"
Content-Disposition: inline
In-Reply-To: <1334070472.18312.4.camel@phoenix>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R3SAtXwgGp429mN7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 10, 2012 at 11:07:52PM +0800, Axel Lin wrote:
> commit 268a1 "regulator: twl-regulator: Use DIV_ROUND_UP at appropriate places"
> introduced an off-by-one bug for setting vsel.

Applied, thanks.

--R3SAtXwgGp429mN7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPhF/oAAoJEBus8iNuMP3d0KsP/iQFbDXq2ws6wQ4eKhUnsCG5
7pyujOzBihrdnd/ozvTUlwJ7irBU4FsKcevegl19sLy3adhsoA5MIci6usERh95M
qrMHcFhOiroWSIe360Aah+4WgZFetOk1lrPmncrmm0px4W13qaFaLjpqaNNFPA56
+At1Y27jduPl+jhYhjzWCj6Ie0NXe1TDE0mAzMFD2VOcHWDbNGCeQMxqwaeVAxT3
BZsDH2W18N5sBLfZHO5k7XKQ1rMi/MEzqnJY12b0fxEkCpzoJeK1HNXb2PskqUNf
xzxPqTwbqcQEsoUz1v4TFcUU9e0l+c5zkLr2NLeio2KrHwE9AHLBgu+bPyfZq3S4
z9mgWdVydRXwoIKjexlFSSzCQtbIA9z2WxASPbkOQ4zm8XN4eAQEzm5rCWzexzvV
OU6d8LKSJ9J3tCFFOKfVaYTEq2bcVxMYNk4ezwlLqsakieHPAW5w5MEna5t45Ix3
1y/+D2esGR2ilSpWfkl9qqsU+ZWHLlw1uMhLjGh8p5wpsV7eRN4eUzv/JBFgGm4X
CuWmRq+aCiQVITrCCudiPH2m3OEXC5RmE5PBRH8Dh5LpqxYitj9AOl50+vNC2cXz
LGXnZPuhb+2jpk1QUk1n+69k86KSyO8iaNtdMNY6HMDEiXB+C+1wqtvsLizRROG6
eOrSClPiuEyzfBsApzC7
=7WLB
-----END PGP SIGNATURE-----

--R3SAtXwgGp429mN7--
