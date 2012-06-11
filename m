Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751009Ab2FKEIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 00:08:15 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49446 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab2FKEIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 00:08:12 -0400
Date: Mon, 11 Jun 2012 12:07:54 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Message-ID: <20120611040752.GI4218@opensource.wolfsonmicro.com>
References: <1339240239-5626-1-git-send-email-yadi.brar@samsung.com>
 <1339240239-5626-2-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U3s59FfKcByyGl+j"
Content-Disposition: inline
In-Reply-To: <1339240239-5626-2-git-send-email-yadi.brar@samsung.com>
X-Cookie: Reply hazy, ask again later.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH v2 2/2] regulator: Parse ramp_delay in while parsing DT
 for regulators.
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U3s59FfKcByyGl+j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jun 09, 2012 at 04:40:39PM +0530, Yadwinder Singh Brar wrote:
> For some hardwares ramp_delay for BUCKs is a configurable parameter which can
> be configured through DT.This patch adds support for parsing ramp_delay also
> while parsing DT for regulators.

I think this is a sensible idea but I think that we should go further,
move the value into the constraints and add set and get operations too
so that all the device needs to do is provide the operations (ideally
just the translation functions for regmap using devices).

--U3s59FfKcByyGl+j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP1W8QAAoJEBus8iNuMP3dulAP/iwHGmdNLdaNrbzagGQioI4g
2mrkcvQd3wrrzBZzsN0tokblM1nwhRSZmdjzAhx862xi3MexZ+VO4FqspyVO8POE
9SVGrcz3DiwKsjQ4DnbWkUgrg8UCH4EV9wFLUD8FR+wMWflc7W7UuNebglq4auyp
5017X3RBe80WagcemAEgLpPA3Dx/dkglJ1XO9aCdhOQZ40vmhrWRkhOnkHoTw671
3JWOB0EspAqJ5Oy1yJKqSOqrDXVZovF+ghlMGhJpzeLlVsYZBMglJnWsGxHDSn1S
lRTz8nanqzCxkjJ2+0GU/96pSUHDBTb+yUTTa6TWW4s3+3Ut22PT+NhaxXU4X3FB
b7wxmFjnHXiE+LVIlsu3MIRHvAeG6p713pOgQwUU2tg//G9klW11ZtO/5AQ++r0W
JD9K+u+lvytMsBz7KLYlAP72Wqu8ENg+ZZHoCnhsB/staORnj4zAdXJvwbK/eMhD
Q1o3xU8STY5mI+lCOcAQZfDBO7xR+iWrzZ081Yq0SgMlyFU3wRW5iP2QHBL15iC9
tkjS5LUJ0YmrpQbZXTvEFSyBx3Um/X6U1aPQIdEz2X3vHUGoFeAlbSdsA7xOh9KP
6Si1bZkfClsFpku8+hXvW1EChmK49H5DSqsiusg+B5CzaWIcDwZqPj3g+GBqu2ZD
7mfK6J8WL6cpXeF3LUzH
=987v
-----END PGP SIGNATURE-----

--U3s59FfKcByyGl+j--
