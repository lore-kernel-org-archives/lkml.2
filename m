Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab2BAR1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 12:27:21 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44295 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751766Ab2BAR1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 12:27:20 -0500
Date: Wed, 1 Feb 2012 17:27:18 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl: delete raw device pointers in pinmux maps
Message-ID: <20120201172717.GG17170@opensource.wolfsonmicro.com>
References: <1328117053-27807-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MiFvc8Vo6wRSORdP"
Content-Disposition: inline
In-Reply-To: <1328117053-27807-1-git-send-email-linus.walleij@stericsson.com>
X-Cookie: You may be recognized soon.  Hide.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MiFvc8Vo6wRSORdP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 01, 2012 at 06:24:13PM +0100, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>=20
> After discussion with Mark Brown in an unrelated thread about
> ADC lookups, it came to my knowledge that the ability to pass
> a struct device * in the regulator consumers is just a
> historical artifact, and not really recommended. Since there
> are no in-kernel users of these pointers, we just kill them
> right now, before someone starts to use them.

Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--MiFvc8Vo6wRSORdP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPKXXtAAoJEBus8iNuMP3d6i0P/0lBmmQFHX71bUcXAezXtdun
cY2Nw26Wor54JriwlQwS7+FbfPx2NGApfssRArz4n1iTbW7IhrjvuEu61K2BlJxO
7wctlWQ/TRkCaYzkrOkeQ2jECn3Qh6g2VKrCwTYPuQxQvPee9wrVloS93yxOF8+w
TKMpXROAjWefJ3T/KlHq63InAjGDsGWz3iIr8zqlB7S2gmxNUuFqCQfWvEdPHAQX
byieUm3dtFKz9RGmR1p1BM7qM5QWR08HuZEmsO//DbHdbcXYbR2AxwUYEF/HOZ5I
314kXx9zK1dgMksJ8myDvM+HwlEsxoM+UoImt871PZ1i1GaAJw68u3hp/1rJBZtU
a48edLqqTTQCO7sVmjjIWVdBUN/+V7g7b78r2vxx9EbS2LOYQF11F8L2bLAMCOWb
+iZyW/TpojJOfm2Ovlk2GdNbN4gPLeaNssrV3jyo1GxXpX/L6v23HxuZIj0hP+f+
hRosOtwIj85d3IEQ0C+prdBNRQygJFZqZe7rzKjtrxJklnjW2nzlSRg1hsj+EjcS
LA+D1Z0aP71RpEyDAp8pLHXVAF4lV1BpSWoZ0h6b9bAuSozyq+8tjCNkGzQZclmE
oXh5tm/fEaIWOLR36/gqb7qDvB1puI/rd1PV2MfKsQB7lM7Uj61Pij0tMDBtBiRV
FNNpORkS+juHn3De6nm7
=Wrcj
-----END PGP SIGNATURE-----

--MiFvc8Vo6wRSORdP--
