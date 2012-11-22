Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab2KVSc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:32:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44848 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753065Ab2KVScZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:32:25 -0500
Date: Thu, 22 Nov 2012 10:27:59 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-sh@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regulator: add a regulator driver for the AS3711 PMIC
Message-ID: <20121122012757.GF4371@opensource.wolfsonmicro.com>
References: <Pine.LNX.4.64.1211211916160.842@axis700.grange>
 <Pine.LNX.4.64.1211211918330.842@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tmoQ0UElFV5VgXgH"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1211211918330.842@axis700.grange>
X-Cookie: You will be successful in love.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tmoQ0UElFV5VgXgH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 21, 2012 at 07:21:11PM +0100, Guennadi Liakhovetski wrote:

> +	if (!pdata) {
> +		dev_err(&pdev->dev, "No platform data, exiting...\n");
> +		return -ENODEV;
> +	}

There's no reason to require platform data, the driver can still support
readback of the current device state for diagnostic purposes with no
configuration.

--tmoQ0UElFV5VgXgH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQrX+VAAoJELSic+t+oim9UrsP/0t2AMfE2IlSLTnEIOwAgWK6
3hcav0fXJNJdU5bGLFiGj4Fm3qkuwb+9jTQQuEUFy5vhk3FnVskNanAIYcflgAwF
8u4wDgMBD+1d/eyimtLvHjN+3QoF0as6gWaVlzy1cSGAPNY2077yHrUhN70b3hxE
u6Qf9EF+SfyYGLCn/mJK+gAAB7dS6JEu+iGoaJoD1kFIbKBEVmwtKgcoutbiWrAU
r6xcHpCYtu9yh1VCn5tbPCFxbyC8OI8936QIaXnj9wl5t3xm6q4F/ElbZnGCNAAe
hCnnJfrupqSNSSopXLxcz46ITrNIRc/86rMmr1RTuJpnycQHasQZdFLqeuL1JJ3d
i5DoBdvBkqTOwcO5lKaAyHGkt9MCu1XM8elh7USBNZPTZE+tKimuBxwCAfZBQaSZ
L3GAFI/geNwEd+3PQ3n2FKI94yIajuWYPkNthSTxmPwjmtCrvbfQ/ZBJbFT/M8c/
ItO0VhNoGOKmQjBTkTxj+bo1qocJy6M1DOpiL78O82uUl4VLRlfV6rrUPxPd+wj7
V/2+ZiUXw7JHw2qmAy4fDh7HVzkuhB2h8Eg5BbfhxdxGI74KK1h+UTPxtYYb8aYT
b+gO86li5kKUuwXMMeS748DwVDmnzkIzb3yL5xcRlmitxyWwaEn9veaHtmQmVDz8
g6W9FlPsPFvY12x4zqch
=BLZV
-----END PGP SIGNATURE-----

--tmoQ0UElFV5VgXgH--
