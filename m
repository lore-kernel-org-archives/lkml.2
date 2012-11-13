Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab2KMJBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 04:01:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51861 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750811Ab2KMJBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 04:01:14 -0500
Date: Tue, 13 Nov 2012 18:01:06 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH 1/3] regulator: fix voltage check in
 regulator_is_supported_voltage()
Message-ID: <20121113090104.GT18224@opensource.wolfsonmicro.com>
References: <1352796533-12350-1-git-send-email-m.szyprowski@samsung.com>
 <1352796533-12350-2-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MT9SxUWSsctiw0kG"
Content-Disposition: inline
In-Reply-To: <1352796533-12350-2-git-send-email-m.szyprowski@samsung.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MT9SxUWSsctiw0kG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 13, 2012 at 09:48:51AM +0100, Marek Szyprowski wrote:
> regulator_is_supported_voltage() should return true only if the voltage
> of fixed/constant regulator is between min_uV and max_uV.

Applied, thanks.

--MT9SxUWSsctiw0kG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQogw4AAoJELSic+t+oim9AG8P/0oGKHrupzuwhI9oXF0yZrcb
3426KLB2ce5qwM4Io9GWN82CX41qRpscKbKDePV5StsRclsEWrmHdd/p2XHvbCpc
OtyDmub1yV2hF4gqchcqR9U6t2AI9ESmcHQyGUhqRZFPvKAlWO2X4+ZkdEpsLAL5
IM80RaQQe//9o3Ck8Sx7nN12hv2xMLexZzmZLH/B/zYL0uOiY7RlTzlOxdwZ3u2O
cPCkBRD6YjEEaZsiPWHiUoRHYHQCiZ5yaX4fc+yldnlP66Pp/QAwrTrXdao4Vpki
g8eSdgkTIG90x9E+95ZLMhd2Gh9ffrs+94DemC6eQsnF3BOrze1vezx58PxgSKlQ
VttX2H/QRRSYndSAuynha63faGGsUjndseUtMtBzY9+UnMamMdYUrZO5U5VmSk73
W7QwyX1SCsQ7suI7KkbKcaTqm6MZ/EINdxmI8e4wW9Rcw96rJ5EqFLjTt6sJRhXH
O/WxNPYQSC0D4H9RU/1BLUhwjsQ1CxzxSwVN+bgVxvah22k+DEio1mGEuw1BVJjq
wttKMksSGmK8BhydZgPk3o8jOoqInxzcK57a9LACaJzUasmmnvhjGUtJe3Y3ZJz8
DsAI9RsCgtmpB0N7vvAo7jDN5zZF3yJ1Cnq20BViaOQrnbUCYxvmUtLopcXXPIs0
vekEDBeQ+dg/0EAcoX2m
=xyDO
-----END PGP SIGNATURE-----

--MT9SxUWSsctiw0kG--
