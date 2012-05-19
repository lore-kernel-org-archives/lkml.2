Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab2ESRsd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 13:48:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32837 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754538Ab2ESRsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 13:48:32 -0400
Date: Sat, 19 May 2012 18:48:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] regulator: tps65910: set of_node for regulator
 register config
Message-ID: <20120519174829.GZ4039@opensource.wolfsonmicro.com>
References: <1337438050-3707-1-git-send-email-ldewangan@nvidia.com>
 <1337438050-3707-3-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gpOboRovIPmaBszt"
Content-Disposition: inline
In-Reply-To: <1337438050-3707-3-git-send-email-ldewangan@nvidia.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gpOboRovIPmaBszt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 19, 2012 at 08:04:07PM +0530, Laxman Dewangan wrote:

> set of_node parameter for regulator registration configuration
> parameter. This node contains the regulator related device node
> information for regulator which need to be register.

This isn't adding setting of the of_node...

> -#ifdef CONFIG_OF
> -		config.of_node = of_find_node_by_name(tps65910->dev->of_node,
> +		if (reg_node)
> +			config.of_node = of_find_node_by_name(reg_node,
>  							info->name);
> -#endif

...it's changing the value that's being configured.  The changelog
doesn't explain why this is being done.

Also, why is the ifdef being removed - won't that break the build?

--gpOboRovIPmaBszt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPt9zmAAoJEBus8iNuMP3dn2sQAJTwkvxELeuU6j0fPWvBMtx/
nwxBcEVKmTAey5/P/HDNWCfY4tsEi1yxzNLZbbZVfwGMyUYm7ytCgROD3WNnXSCc
LAA2xBP8Ffl1pYu1dLow/PC0vHntVcN6O9hWWyyb/E3iRcrrfCx63bxPLVcJyI7C
oUpzSpAZytwxDRT4cwotBsqc/f439gIvYn93jpMOQJiaAYxJCgfpKkXTv1Y7O5sF
f1IJIF+KHmCqWwY02fm4/p6SQYjMkn5c7FojKBoznSpjKLw0OBtlppkCzmauVOIZ
lPsBn3kFMWYOKZiRfKjn5SIIg1ARupmdXDdYwrQFjE21uGdyrpD88wCRI0dzj6Qv
/xE+Zjt+hht6vDT1GUkOmpl/2iqTTqgp0uJjLlIUeeIMIGCWYHsdhuKRvPkuII8+
vDcQndOp+q0oanQi31+mO6mAtot+jIdb8nxAmplfXSfwQ0TNeGA/W/t/gDoYeAS7
2NWxlXuDgO0dczWsNEOpVnwCSjGA+OIWGDr8jf0ZEe3OmzxXHlbC9Ag5uk165vo9
pXGR8HIofL9c0fa3LzbZglz/MiC708VReuv0Valeg5GTzTWjsh6u3HzIsyl7kos5
b16s3feHaZib9aHm9UdvcTxHHVJqgTVj9K3YsDV4AfCB99KSZmieIXhCZkVjCWPK
J6PNGsuWWpFyJoLjBiVo
=EdWm
-----END PGP SIGNATURE-----

--gpOboRovIPmaBszt--
