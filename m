Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab2CCQd5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 11:33:57 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51235 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752767Ab2CCQd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 11:33:56 -0500
Date: Sat, 3 Mar 2012 16:33:54 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        linux-arm-kernel@lists.infradead.org,
        Estevam Fabio-R49496 <r49496@freescale.com>
Subject: Re: [PATCH 2/4] regulator: provide a helper for registering a fixed
 regulator
Message-ID: <20120303163354.GA3071@opensource.wolfsonmicro.com>
References: <1330774804-7310-1-git-send-email-s.hauer@pengutronix.de>
 <1330774804-7310-3-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <1330774804-7310-3-git-send-email-s.hauer@pengutronix.de>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 03, 2012 at 12:40:02PM +0100, Sascha Hauer wrote:
> Some devices require a regulator to work, but boards may not have
> a software controllable regulator for this device. Provide a helper
> function to make it simpler for these boards to register a fixed
> regulator as a dummy regulator.

Applied, thanks.

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPUkfqAAoJEBus8iNuMP3dHxgP/0BVwPFZ3JYwpWaN71WGl6TX
yNoGKyTJUQOY+Ym1cu/J+7ayN35Cy2LAPO74DNc2GU64fPuCPStufgtcCt/XoZTD
KDGqBMgsAVxrbVFzJlYiY/k7B130HtmfQAw9D0MF7raaA0I0KO9bIbTuGkp1hYrN
K4xOnYTYSV095uImqoFTMi0eB3ZnvYhS3K5Y+ScPAaB/CEiTlWYyue/hjrqUInur
ComE2hDSVaHsCnm64RGZOIus80KeZMpYrPD/oU42aJow2KzFVE/4G8QbFNhNw3TW
QTYUGX2jGgnZ+uFuXIVKnOFh8iX5NVyI3epDSuuqSk331/PdSxJmB4QJ7pilOgoE
XDARrwTGX15OoMg9uKO20QTKHgAits4+gddGpNXG2ChnniUu2qYYnDNiqgVFO8Cn
1peFmAJ7H1cgzZsxEIN4VBqXxlNKyqD0zDK6WfmtwVXZSu7mP2CbyKU1TtD+vDpX
cSRH85HSOcLC+Q6jFbPBUG67kHfrpyaCjXvl2pkxk/YDC05CQGfpvUvRGppxlNPp
fP3GNuz3JKVYDOjV1KIEIkqhoygMCKI1+6A9PvY5PxSy+6qsXhKkgBuEULltBh3l
5wX8vPo/r4ofMrDBbTZGKperjYHeo5kMNZhWp5uf5+wv/aANY3kucRldTUijJNpP
3kGL4ycvp9Uy/Ub9wzqK
=8NmO
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
