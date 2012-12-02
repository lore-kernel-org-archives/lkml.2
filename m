Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950Ab2LBPMd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 10:12:33 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43813 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751770Ab2LBPMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 10:12:32 -0500
Date: Mon, 3 Dec 2012 00:12:27 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: wm831x-dcdc: Ensure selected voltage falls
 within requested range
Message-ID: <20121202151225.GZ17981@opensource.wolfsonmicro.com>
References: <1354252773.23591.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ECAkxgSy0pGoHfdA"
Content-Disposition: inline
In-Reply-To: <1354252773.23591.1.camel@phoenix>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ECAkxgSy0pGoHfdA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 30, 2012 at 01:19:33PM +0800, Axel Lin wrote:
> Use DIV_ROUND_UP to ensure selected voltage won't less than min_uV due to
> integer truncation.

Applied, thanks.

--ECAkxgSy0pGoHfdA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQu2/TAAoJELSic+t+oim915EP/in00WmqVi7INs1m3DgaZfKs
HCNG3MnEDcv9TVckIxgjm2VjhvF+kDQQsoQk2IF8WpO0iZQTLKjT0rOf7bofGPgf
xLJzyrYbXpYyoYW7zC3/RykmITVmaKo2S123+D2hwqaNVX2lVUjiAWxsmKmLDfj8
wUSsZzuY42j8+BZJpT5o4LOu+DifhBOlmXv6ag1YOfNfq2fm4u2sXRmIZBTa3gL/
HIwxqtQi45i4Bf29HcLvnkEIJhawisdBAcc9RUwZVp4NU0Pnh/lwebynSsrIDaSH
5An4Yok+7uNKvon6mA6gucU7PgTNwdP7skJijq63XhKXf/AVmaA8Q8pUQ8HHHm/L
H553gtc2fTWpKvVdGmqssXx0SDfBlT6auR7r5uvEOdbZhrHqBBzxz7894sX8pX9e
lDsLL3iPZNTopko9bw5NeG9BbWRkuiijQHk0HYRfJDbxQwK2pgyWJFAmfrxkhW1+
tE9t0r3at/wcLUasoaOL6PMF4xv9vUpgAPhtAhoZOB8p29M7n4vDe7vNmSXhogMj
tO/rkw+vR4VXSJVjDlyUeIgeG1Ic6cjHKOIaO9yUvRZLXEUZ8N+dNMMgaxsyMwR/
G1brtknBtPN3B3lvQKUBgtlKx+654Y3GxFVq/lsL4763bCRnc7sjQS/mCMBM7S+B
VEoGVRXyJf394dKNGM4R
=4p1c
-----END PGP SIGNATURE-----

--ECAkxgSy0pGoHfdA--
