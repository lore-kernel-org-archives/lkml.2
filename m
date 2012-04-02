Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab2DBWQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 18:16:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55542 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752619Ab2DBWQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 18:16:23 -0400
Date: Mon, 2 Apr 2012 23:16:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFT] regulator: Add support for tps62362 and tps62363 in
 tps62360-regulator driver
Message-ID: <20120402221620.GK3160@opensource.wolfsonmicro.com>
References: <1333361968.2802.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dxRQSzdsN/lOP445"
Content-Disposition: inline
In-Reply-To: <1333361968.2802.1.camel@phoenix>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dxRQSzdsN/lOP445
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 02, 2012 at 06:19:28PM +0800, Axel Lin wrote:
> According to the datasheet[1], tps62360 is register compatible with tps62362.
> tps62361B is register compatible with tps62363.
> Thus this patch adds support for tps62362 and tps62363.

Applied, thanks.

--dxRQSzdsN/lOP445
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPeiUtAAoJEBus8iNuMP3dUfMP/37q2fx5Nn1z68Tylcjjujki
xq3YSqwxesMyaBa8Wzz36RjCObL7xjKk51ZsiavwevI2yF9sZ7j8ghJI4lI7Ma2A
WNUXmeM2NswrNmlnwViY9KYTr5BRsbrx/J/QexgEtUD3Ktyu+x+iaarQmwnBRvMI
We1AcigoApkGgmk827hGctd43blkv3I2i7ebW66cGIF5EC1VM01YgmOk1LlReZuQ
qe93zBh/vjsHfAxfDxbraBDUISbdjBOSm9Wa6ojSG/rEKyEPeOOTDBQYnSRAjuuQ
NSP80jfax2AHWVC/1mRaIcdzq45drk4pfq5YehKxO3VAhHcBw9ts8AoN6ETaOzf6
bEd8JUudAlMXfXPIQHd65U2EDAjRSO0kOgAH0nQIOaEWUiwuxSolwszHtGqBi+99
zutcw+AdnLjdEcYjcoI9fI0LGMvoXZ+BV4X7l0W8+PhKLf+1B37U6GvYQl+6MvUk
LO3gU1Wl3dYOVuY1rFDpcvrtXjn82LNx6Uj+cMxkeL6iJvUV83yeKklVeFpQPZca
iigXkoS9s2q5PbSrJ3dIjwKQDUMOIISDptQk2cadY4slJqbMY0GRonVMe/2sV9W5
CgcUYFX/EhGLA1O7u9/fOFygACTa7g2NLVJPfaMLgbYWXtGdS8Lcw8g1NuZC3XEh
le80VHnqXI3l2V7K4029
=JRPH
-----END PGP SIGNATURE-----

--dxRQSzdsN/lOP445--
