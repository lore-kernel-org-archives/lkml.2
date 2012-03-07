Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502Ab2CGRcE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 12:32:04 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39013 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758275Ab2CGRb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 12:31:59 -0500
Date: Wed, 7 Mar 2012 17:31:57 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH V1] i2c: gpio: Use open drain support from gpio driver
Message-ID: <20120307173157.GT3107@opensource.wolfsonmicro.com>
References: <1331127494-6913-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sDhuxz86kt5qlkuV"
Content-Disposition: inline
In-Reply-To: <1331127494-6913-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sDhuxz86kt5qlkuV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 07, 2012 at 07:08:14PM +0530, Laxman Dewangan wrote:
> The gpio core driver (gpio library) supports the open
> drain pin handling. Therefore, it is not require it
> to handle in the i2c-gpio driver, just require
> to pass the OPEN_DRAIN type flag when requesting the gpio.

Reviwed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

but note that this is a new gpiolib feature in -next and will need to
either be applied via Grant's tree or wait until after the merge window.

--sDhuxz86kt5qlkuV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPV5t0AAoJEBus8iNuMP3dnFQP/iT707PFwE6bw5wb5a0hsxrq
MSj7aOItxpYJWPxwddVJZkgmluH+P1kzqiINqNF1sIQ7FfS5qJ3uZkwu2D2bzCHo
F+yVd4X4zYTP15tx1Z2zZUipFo15XhcB0hTSrqvUPuyzVfWl/+jS5rJCxdWncVs2
doGgevvun2nM9kxmXCIR9TVhCFjQXHl6ySA2hzk+uuNuzBo9gU5OgoYpNpSiUVj7
L5ZEmo1QzhZKlMWSxFWLf5ySleI9vSqTDIHzDumse9B6aE+8MEC7H4281+VD0tHv
mI3O1YTn0WfdHAMqyYvx2hd8s+t6UP6/Xe8tYOoPob8c9JxavAVYgE2ad/RLIpT8
8g6S7fZa0uB8St9nac9hAVEJh1NIIIqTnWRhCuLu/T7j1MZea4fc1Tvc5bUEs25H
FUzYkQEVrOUDs9hV3b13muWJj50MmodnzfwE2/lRgkparFHpsZiKH+J4q8J95W9t
WxdquEu27RYb0mQbbY1fkv9YIesjTLQn/ovn8Os7DJhenoeVb0hJwrDYDi30f5hB
tI0ZD1fRBIh5+Lc7zWYJ8xo7cuvuQUZTjraDhnagz1r/K4U9bQS+W5NECsR4cHL8
4eMKYydSCL7X/E2myeIwDJjGpUrXVXbQ3iwXYny5F6Ncaj2Dlq8fFFIDAL58WCz6
FgdrLN4kkMWyS5f6XXTI
=ijI2
-----END PGP SIGNATURE-----

--sDhuxz86kt5qlkuV--
