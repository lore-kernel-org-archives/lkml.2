Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab2A3Npp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 08:45:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39669 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753093Ab2A3Npo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 08:45:44 -0500
Date: Mon, 30 Jan 2012 13:45:42 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 1/3] regmap: Properly round reg_bytes and val_bytes
Message-ID: <20120130134542.GH4882@opensource.wolfsonmicro.com>
References: <1327677023-29310-1-git-send-email-w.sang@pengutronix.de>
 <20120127162837.GB18572@opensource.wolfsonmicro.com>
 <20120128011403.GA6669@pengutronix.de>
 <20120130132134.GB4882@opensource.wolfsonmicro.com>
 <20120130133529.GF15596@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrvsYIebpInmECXG"
Content-Disposition: inline
In-Reply-To: <20120130133529.GF15596@pengutronix.de>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrvsYIebpInmECXG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 30, 2012 at 02:35:29PM +0100, Wolfram Sang wrote:

> Understood. I'd think we will find a non-intrusive way when a more generic
> format_x_y-function seems worthwhile.

Probably either your suggestion of just storing the shifts in there will
be it or it'll just turn out that there aren't actually enough odd
formats to make it worth worrying about the hard coding.  I was making
this decision before we had the cache or anything like that so was
thinking about what made sense for facilitating the infrastructure work.

--lrvsYIebpInmECXG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPJp7/AAoJEBus8iNuMP3dedAP/RusWokPIArxozPc8siwRslj
85syTIpBuifJDZ/MvLtxGoqyuyJYX6bhTy0p7wYIHGp9MLydPK0igbI3HQEPYec/
0WJyCL1A6gEZnkvLqMK59eSzaFFCNMA+F8t8wddKj6613IXagCAEJ54VaLz3Auw/
9epWtqq5vMXR3Ueq7qhN4zDPIcE1sFE4RMld2ijXGXAsW/oLTDBG+94/7ul3agjo
VBHjVF9jxLqvO45sCKkZ0c9yEPRe8hBG9bC7RBJRiv9pUxVrfVoHSeBMuyzbdXju
rgrDUuv9PCoSV024LLxhmBrpv1fNq1poATr6e7g1Q3k+PMxIaoY//LczYSqMztiZ
C6/k6AaxBrV1MNGbVXtZgix4FVgDhzwMKyuIPLsBlHcx47iRUee8KvgEi74XQaDC
zzID6oFxtO94vukJPkWQwqBJcyqyzbL4JoaZ8IbLnliwdb8pHz5xp1bmQlwfU53R
sevZRsaspS+40xbz8hBt6Yph9uMqOOqtn9vzjAjYvMcECMcY+DAviiyb6SIACR+G
MGK5mdOPLFrM9d84lUBtr9J6MhdaeeqxY2ZXvgltXfA86m9nEgeiJgBjFpeu9jhf
wgPoroBv1TitNS8MQukp0I9pD515loYvCFlbO52LeSIOQ4fAzKBE8+siTFmjAno5
lgRWmpnTOk/2/pA3ZzV/
=Fvat
-----END PGP SIGNATURE-----

--lrvsYIebpInmECXG--
