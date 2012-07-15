Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab2GOUwo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 16:52:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43683 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978Ab2GOUwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 16:52:39 -0400
Date: Sun, 15 Jul 2012 21:52:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps62360: Convert to devm_gpio_request_one
Message-ID: <20120715205235.GD4041@opensource.wolfsonmicro.com>
References: <1341620913.3153.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E/DnYTRukya0zdZ1"
Content-Disposition: inline
In-Reply-To: <1341620913.3153.1.camel@phoenix>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E/DnYTRukya0zdZ1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 07, 2012 at 08:28:33AM +0800, Axel Lin wrote:
> Use devm_gpio_request_one to save a few error handling code.
> Also remove trivial comment for tps62360_remove.

I applied Laxman's earlier version of this.

--E/DnYTRukya0zdZ1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQAy2BAAoJEBus8iNuMP3dGrYP/RbkIWLoEbWHM6i/+4Xc/etl
wcW6BQQFW5QrcU9DzKI4Gw+pujE1+aLGe+H+eNVSfMDq/qpTgVFlqPtxsEcdfvoD
zOOCXa/WdVSJckujLZNxDFZl3zwkuDP6nyQ0h6awF8mAZLcr4QHcY5KfMvjl5nr2
vOq/P1grSbDb3O33rf7ZpDu2yBQjD7z2QIBwgNDvc7JgYMRCF5Pe7yDMlTNEJxIG
0VeGYs5mEEIY4BQhTyQ1TJRxthLrcxDTm9+cHp5KHi7xZ6oPTTbuj0X0EsNxa2X3
GtzElqvKeh/JyadaxwdpUiGaTk+9toO8ETN033BcWLzzk/doKHOcDn4wnu+Un2E2
zhHqm5HI/eeCF2BjJORofyC/5mJWPvnrDVoEALdX4kz+Fsu4TeUphTjghZ76JJ0Z
Io6rl8YjJ0PBOVa2CPdwsu6irdiuFfz+IH0eql/FfZO7rzEiajhr1LL3pgcvfwUc
WQ2/qtQOIDgm7oUtvbg+fIu33EeVBipED0wWRCo9DhjvXox61FrRd6w1YQ0jhv/J
uV3LCASAkIneinHPdCazkQ279stZDygbMuLUvlEROgsfbr5AgfCcY36tFZG46VOw
IFRA5wzVq23e92v3nEJPuf0Ng8pjYRukvye3VoKL39eSf5MnCokgoJosjy7LMxFE
3ujRq/1UtYJPNzh64kEB
=9rMU
-----END PGP SIGNATURE-----

--E/DnYTRukya0zdZ1--
