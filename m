Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801Ab2GEMug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:50:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55279 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932447Ab2GEMue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:50:34 -0400
Date: Thu, 5 Jul 2012 13:50:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, rob.herring@calxeda.com, grant.likely@secretlab.ca,
        arnd@arndb.de, linus.walleij@linaro.org, lee.jones@linaro.org,
        swarren@wwwdotorg.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 REBASED] regulator: fixed: dt: support for input supply
Message-ID: <20120705125016.GG4111@opensource.wolfsonmicro.com>
References: <1341492121-14049-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rz/qo3iW6Lu5yGf1"
Content-Disposition: inline
In-Reply-To: <1341492121-14049-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rz/qo3iW6Lu5yGf1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 05, 2012 at 06:12:01PM +0530, Laxman Dewangan wrote:
> Add support for input supply in DT parsing of node.
> The input supply will be provided by the property
> "vin-supply" in the regulator node.

Applied, thanks.

--rz/qo3iW6Lu5yGf1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9Y2CAAoJEBus8iNuMP3daYcP/0QN+a3losw0ezpuYbAu9zTV
sFdirNDYYtL6zhQLRjmEAQb1YCJVpvyBgg0Fpay4606LZ0iMDISQnqlwgicfL7Z4
oEGlTu1Jlp8tn8FHLnd9XfGvVQCgp0fJO3CY6NA/D8is0mhUnCw3nhT/XvdpT4Gp
I/UvvLQjXzuG/Ae0WRjntW16TJlu2Yqgw/eByAhcuU6g8rp/tWZgn8FslakG1rLi
euUC8lzBd1lYPv9B+1OCDHINaytDLp+3zcO8q77VkqLbU8CBqWWnXMlqNdB6yoRV
rJ2ZluxXfflq86jeq7A1veNIwwIeX3PHsKkJF2KPkDMNXQzBxXLZLMovWKsvhGcn
cE9m0ikIIbj1I1/zD1Mw/ciK/UuPaVS+U91NZOanyp4HXm/i/By51wyzMljX0OH8
gXVZynZIu3GyPUPfT/hWCDk+iF6x6KigGh9JThMOKandCiHwlYRGVE4k029+B8jK
RUJPAvazTTh+KytX9HnH1hoQEpWHTweIwEZeikZyU6wfQAOlrMBJsTdx6RIN8vU7
LVe/Ogio8wcGewUrEMKYaHVr0LYGyujhe9pdRjj20aujP19diAa3PEnXzbQAuyVx
6FqGEO8OZFlgJYloofUCnlsmzUSDiXFFeod0O36JmzPJC2vVGaOpY2530IMyd9bq
EnY/j1a9pNUKXQGkc0Zy
=MXTs
-----END PGP SIGNATURE-----

--rz/qo3iW6Lu5yGf1--
