Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab2DWMSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 08:18:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42798 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754100Ab2DWMSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 08:18:34 -0400
Date: Mon, 23 Apr 2012 13:18:31 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: s5m8767: Use DIV_ROUND_UP to calculate
 selector
Message-ID: <20120423121831.GF8318@opensource.wolfsonmicro.com>
References: <1334280605.6755.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SxgehGEc6vB0cZwN"
Content-Disposition: inline
In-Reply-To: <1334280605.6755.1.camel@phoenix>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SxgehGEc6vB0cZwN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 13, 2012 at 09:30:05AM +0800, Axel Lin wrote:
> Integer division may truncate the result.
> Use DIV_ROUND_UP to ensure new voltage setting falls within specified range.

Applied, thanks.

--SxgehGEc6vB0cZwN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPlUiQAAoJEBus8iNuMP3dJzMP/2IuU2/GDy6jEi6hfFmixEd/
GdgRXST/TGNQEZYKRaObMnTRq4BuOYpH9wUszmh5ckoNqSuc2lVniQSWYkVk0dIA
mGEwhg6GDy8tOBsJuAxxSX7ZDyj7snwoJiexv6JQqKaFIVmj9ySJzX7vJCuCn4t9
8E9Hmi3ktMpdp/9S78j3QV83kb6UD7lM7OHCm8o6TAuQM0vgP3t7bgzMqRR3Omtw
nQLq6euLQIZdRGKgZST0CxMDMaLpBCs/naeEGFNfxUSgAYSGvS8NywGG4xkfMFfb
arnSzLqvLIsgDXvxRCc0A2yDQQSoQCn/Ert1KIV9mg3Gf6lFVXPp9RtTy41JEJtB
2SGeHkSdi5EeYi1s9n1eFFtpIdx6uc/sqSb84qW7re8kDPUh5QYqo+6ihs5Hw+0V
eQKQwsTmwalHp9mBHIXKvGNAMOfLnI4zIRKot5NAoH2oCO6yAn5NZsMtqNUApqtL
lYY+bfHht5YqyeXz5CwSJ5pbuh88+RcKksYZ5nm4W74JSlcVzxo1QnuxjUqbR1KC
LABoApNwq5aWu053hOH+JcGqpkfH4Dk5vpHoSihX9DSU/jOODM8Wp1ZalcVObPjY
WiPPuvUkeQGJ74vbUQfPPejIxAZmYqoEpXsuB/xKp7HW+hdU3D8CGNk/UrrNkpsS
Sfdz0zo/hFvqJ6Jh7w0T
=aTiS
-----END PGP SIGNATURE-----

--SxgehGEc6vB0cZwN--
