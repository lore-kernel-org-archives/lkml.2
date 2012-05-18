Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758431Ab2ERQXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:23:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43043 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758286Ab2ERQXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:23:39 -0400
Date: Fri, 18 May 2012 17:23:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        lrg@ti.com, b-cousson@ti.com, linux-omap@vger.kernel.org
Subject: Re: [PATCHv2 1/4] MFD: palmas PMIC device support
Message-ID: <20120518162335.GL4039@opensource.wolfsonmicro.com>
References: <1337064539-3014-1-git-send-email-gg@slimlogic.co.uk>
 <1337064539-3014-2-git-send-email-gg@slimlogic.co.uk>
 <20120515181448.GD19592@opensource.wolfsonmicro.com>
 <20120518095512.GF12015@sortiz-mobl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jtcAeju3WzRmRF+o"
Content-Disposition: inline
In-Reply-To: <20120518095512.GF12015@sortiz-mobl>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jtcAeju3WzRmRF+o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 18, 2012 at 11:55:12AM +0200, Samuel Ortiz wrote:

> I'm fine with it. For the MFD parts:

> Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Applied all, thanks.  I moved the header updates from the regulator into
the MFD so the regulator driver can be applied via the regulator tree
and the MFD via the regmap tree in order to preserve bisection.

--jtcAeju3WzRmRF+o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPtndwAAoJEBus8iNuMP3dr7AP/04Fi2wErD5ja2wEOL7AdzD5
lQNsrMswlTxAR5JGgTZ00GDyIPh/CFtyjsk2YJ9+s67neuJCRyze171TsUuuUhiy
V1oh2mr0oFCcUj0T5PtOYUOca+qsx3Oo71DkDoHgxHkpYSoq3dnedEXIGBF9LzBH
N9oZt8rwAFpwT5o5mwFkh7Jd3oCUbY8BiNlWtVkLPyuifR/6CUNetFtqsjxY64sD
Nout70ybg3/0zkrdHj9LCHnDpmYsTZeGlOI56VGDSoO2lO2NisEJwi2PeHd3yamU
KYgpNoixa71teF2GFPdo5JeWZsK3Ow7/dG1X/q+Y9IhcJBNUmceqlxvDQPMDpzBU
0TTJsuVnR0mjwVRQ5lmbzgcVnsyyxDjn3rk4mpwuuKQBBWUyTxNj1cVdaNN8C2Kj
dA9zMw64m4dYVZvmYL2oogOl5lUua58O/f4uTfpF9T0jcnr18m2Rn0JOpFKEJBPg
1EWrbHvapqZU8zb14TSNnV7fpzYV7s2cq/xrbw1Og+CxPDyUSW5terN+FeUe0tIw
zHPeJ4Bzc5o4XGas1OwOjO4CKDEWkZArdY1LkpB2waw0CaHJ7krxKKkwb7EpAv11
3vZJ8N4aqlv+jB1qNidgw35onySDxQlbv1yaXNK1rUCSxHVnwSp0Gph5WWqPPvg0
rDs9B+sqkfdcvRI/0Jhq
=4uin
-----END PGP SIGNATURE-----

--jtcAeju3WzRmRF+o--
