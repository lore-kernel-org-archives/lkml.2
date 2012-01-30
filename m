Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab2A3VyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 16:54:13 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51665 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753854Ab2A3VyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 16:54:12 -0500
Date: Mon, 30 Jan 2012 21:54:09 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, Liam Girdwood <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH 3/3] ASoC: codecs: add driver for max9768
 amplifier
Message-ID: <20120130215409.GA16187@opensource.wolfsonmicro.com>
References: <1327677023-29310-1-git-send-email-w.sang@pengutronix.de>
 <1327677023-29310-3-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <1327677023-29310-3-git-send-email-w.sang@pengutronix.de>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 27, 2012 at 04:10:23PM +0100, Wolfram Sang wrote:
> Add a driver supporting the volume control and the mute pin. Shdn pin
> and DAPM are not taken care of yet.

Given your comments about being out of time I went ahead and applied
this, I'll do a patch fixing up the main review comments I had on top of
it (the Mute Switch name and the always_false thing which you now fixed
in the regmap core).

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPJxE9AAoJEBus8iNuMP3dliIP/iocevPV4vd+N2lR4kLVNKAi
+lm1HNk75jAl7sdGuao7CxoDu2wh4ZZ6Ok1x/gisBSmJulSQaWA2+2yKn60TbEoo
qzm89uFec4xT9Q+diVAJwS1Ekc7/nDkbX8j8WYuPIAhF03LzU+IAE9IsCjO6MCfy
8Unoka4a3wphVLDJr99tuJUwF0iAA8PXjVNNIUxJv2rQ8B0r9xrWoaD62NyjnVQW
kGZkwVMYXqCaRePcaFt7MxdsBuUxGu2nnllnH6bzIoW+dzXktK8zRj8HeOBiqqkD
j8buXsN9bY6A/GO8MJisdmLlH2zG3AKWRlZfwOmWHOwhJhSY+SBZDs4f+LscNXpw
AcDoa74JOmBTB/K5y2Pz4O/41FjYK5Cev8cl5q5K4pAAuoeFW/yFiers1tNEpO/T
QFoJJ3GDWjhtmPLe/6eKf04mZx7P2p8HkVDZli9S3e7XRq5fDRuIQZWk2aX/BR1i
MlxGZCcKGnCtJp/pwqcXc4bl/zpsG1hk/yNz44kbh7yuSOmiz6m+7z8gBlk/fAM4
n0WjXrSYWJsj0lQ9RkDy0QgmP9b+PN2QKE5pzWK8lffor/qSCUhUuaxTSkojwMTt
cquzdCiJ0bOLBQQS39FUNJPgH61VikJ+szDNgj0CTd1As9dmkDuycEhdY7Z99ZMS
anTkdz0LEVcJieK0oSyf
=Xwyf
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
