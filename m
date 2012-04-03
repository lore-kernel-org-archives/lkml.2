Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab2DCW3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 18:29:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58805 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755725Ab2DCW3V (ORCPT
	<rfc822;linux-kernel@Vger.kernel.org>);
	Tue, 3 Apr 2012 18:29:21 -0400
Date: Tue, 3 Apr 2012 23:29:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Vasut <marek.vasut@gmail.com>, Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: isl6271a: Allow missing init_data for
 diagnostics
Message-ID: <20120403222918.GD11910@opensource.wolfsonmicro.com>
References: <1333492036-15990-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IDYEmSnFhs3mNXr+"
Content-Disposition: inline
In-Reply-To: <1333492036-15990-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IDYEmSnFhs3mNXr+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 03, 2012 at 11:27:16PM +0100, Mark Brown wrote:

>  {
> +	struct regulator_config config = { };
>  	struct regulator_init_data *init_data	= i2c->dev.platform_data;

I've dropped this hunk from the commit locally, it'll reappear later in
another patch (this is why I'm looking at all these drivers...).

--IDYEmSnFhs3mNXr+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPe3m2AAoJEBus8iNuMP3dUMQP/RkoKTdlXfyPeToiPiPn07Pt
ZXaRMD+DaxV7BZFEKvvEXEasb5uQUgjDfbqiCHpjcWxqTtmbWPk/pSuJo+g+DRox
LsrQhFzwAoryjNZk24TEnAkBMbitcfmU7Glp4235W1l6F+9/8NXoASqmqKeUNrcJ
6KxgqfCaKjJnk8tQu7LUI+sdqtvs4hNaHRpSdoRxMoFdH/ZQ7YKL6icsFBc/90xQ
9lAv5ahRK+ebyCRVfeQq6Ll4Vtb25HmjXSJ+isVH/+RoF8kmMKaQi5weZk1TwPm8
p4pxti2i6PzkdbxVcqv40jX0Ti/ZRph9xNeL8tjFx4XYkz95jynZj/D2snQlMYQP
pZ8OkgHFd+iEHHphyhF8HQxWrsD1MYZZNBxShSfTsXNcwqO1r1/bxP8Rvi+lzWXP
i+hAKGaZTO1+IguJP43tdzvEk10wGyxQk0UltPl5uCZvqKdZCf/kbOd0cR2tvmnZ
J4C2CtS9XBBjXfw9WKJZVxe83ZNO4AGIy9Bttf4UuNwMgR+mlKmx71qhkEw/C0sd
mzIPyMuZpuZVhUmrGPiEjn3PM9lxx0ZLigggyNGe93eSXW9dxiT+NEeLohSE/n8p
E9IVFAGIwwqHB/6vwf+0OYkxreaLlA2FfwsfDt1Y5cj0gJoT5G9NIgdy6H5Tj3U3
mr9ZqyBOrzTiVUUZSAdb
=FHhs
-----END PGP SIGNATURE-----

--IDYEmSnFhs3mNXr+--
