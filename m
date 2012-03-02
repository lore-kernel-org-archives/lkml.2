Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964920Ab2CBLYW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 06:24:22 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59777 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932307Ab2CBLYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 06:24:19 -0500
Date: Fri, 2 Mar 2012 11:24:17 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sonic Zhang <sonic.zhang@analog.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/3] regulator: ad5398: Use DIV_ROUND_UP macro to
 calculate selector
Message-ID: <20120302112417.GC3230@opensource.wolfsonmicro.com>
References: <1330676454.31023.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Md/poaVZ8hnGTzuv"
Content-Disposition: inline
In-Reply-To: <1330676454.31023.0.camel@phoenix>
X-Cookie: Chicken Little was right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Md/poaVZ8hnGTzuv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 02, 2012 at 04:20:54PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied all, thanks.

--Md/poaVZ8hnGTzuv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPUK3YAAoJEBus8iNuMP3dw/cP+wZjXOWnHvi9hlp03qegpypx
Oa2lgu1qol8EF6pzZWKx/Z4fG2Yh2Nm+GHy9iFSeZ9X/2RxpA+ajvYLW1CPycepZ
moyhAV9mG53ttBDOe+w+DMVoqrVKQ58QxWF4jgPNhCjtgKywKykT66Gjx4VczJ1L
g4uNpmXeoVru1Lbtz5L5j8X9AZQ19NjIs9UfTdC2yAqyS26a4HYMiY7y7bjAqD5U
SzSpYfCFxOgztFNGncW+xdVZSreSnfBMa5UZI9Ddqx0RlAZk/LNv/+Xp9uI7QD/v
t1P5bGRmMboA0XS5jFZL05YS1tA4UVRTwAR9fR/UrEb2e8VUe5vWVW6lxzV0giyO
AL1CyooKYTsj2yQtDY8MhN4kQIk9VkFpIK1+1eT2iGV5YxlJDShOXziuBbcF8E0Z
LksEBMzjxKT0nrP5z93tvLAGRb7OHhpqEDbjvOBPZJIN2TnvzjsXtV4s+8pc/uBy
LYSctm6fRZQafZTal6OAlqe0AMWhnuAlR256taqiBiBJy3TVr5clDb/LhuaFaAqV
rKKeLCRDCK9Sn7QxKa7Qw9RXNA3IXp/BNR84G/tNry1BwsZCg4bWqiqFvv0NjSQa
+qVnLcDEclIJEC6UOmZeDeQql6syx6/NHzMWJlf0/7aKeCo8gbjZ/YPLbZgyQ/wL
UcDdXQNPwfNKKI+KCWTJ
=VQog
-----END PGP SIGNATURE-----

--Md/poaVZ8hnGTzuv--
