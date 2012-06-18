Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab2FRQrF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:47:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45464 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752739Ab2FRQrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:47:04 -0400
Date: Mon, 18 Jun 2012 17:46:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Roland Stigge <stigge@antcom.de>
Cc: swarren@wwwdotorg.org, cjb@laptop.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rmk+kernel@arm.linux.org.uk,
        ulf.hansson@stericsson.com, linus.walleij@linaro.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        aletes.xgr@gmail.com, linux-arm-kernel@lists.infradead.org, lrg@ti.com,
        perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/2] sound: tegra_wm8903: Adjust to of_get_named_gpio()
 change
Message-ID: <20120618164659.GV3974@opensource.wolfsonmicro.com>
References: <1340037743-12924-1-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BcZrms9gUsdgyR6a"
Content-Disposition: inline
In-Reply-To: <1340037743-12924-1-git-send-email-stigge@antcom.de>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BcZrms9gUsdgyR6a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 18, 2012 at 06:42:21PM +0200, Roland Stigge wrote:
> of_get_named_gpio() was changed to return -EPROBE_DEFER in case of
> gpios not probed yet. This patch adjusts tegra_wm8903 to this.

So, I saw from the other thread that this didn't actually happen yet - I
guess the best thing is to merge this along with the changes for
introducing -EPROBE_DEFER.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--BcZrms9gUsdgyR6a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP31spAAoJEBus8iNuMP3dNNgP/0uhJgi/e+8hnU/E4BHvXyHx
6zlx6GeLyFmUN/KreJn3cfpvTTOObVSrLts602vjGlx/kaGXLN1DDyVqovrqF9vA
AIhUS4uLNtsxMFKT2blgfvUck7ONnM/C21Yb8mRVPoGJkGVMnS8ZEZRwPpCiEUgm
X3PAvAUccb1NV3fq+pd3di5h44pZqShj7wLxpuwbdqnwgb5bUmSwPLyhbUbkR+mH
BNurlYDw8PDUZ+jDHr8OfWU5U2PhbgTQpa2TWpumqZ3b6kKKOQSRAm25a7OD6Fwf
9xAxsvdGnJKsaP0DNKVsuKiLub9E/uga5EgjTk6mFl54xY8KJCglTHw7Lm3by3Uh
1YUuNQNbKmpzZUq50JL0kt+u0/E9scjQCnU3I3Gwxqgoot0aeLeS1zyUvWx12lAd
xD9t+KRdNuDuil4ek1ASgAXwnjnLSnVEYKnlB3VRQuSdlPUPxPrHHOrg1XL0jNz9
QMT1bW0oiKq+CfnKaoUGlOIQmUDdrGItOxO6Cw1dgn1h2PbwzORb7tAmO4KHzBgr
ZA841T9RzEhW9LFcF0HEaqqR4PZLBFgQ5Y7ETFaV/9tKKOT+M5YUjYXdWRsDxoUL
MjiWiyxGhpwOtzkKIoUni69MDgaTKgafvSi1r8MY3AElkupYmR8P9cTHfF46kzUu
oiqmUd/ntWUV1b08N82h
=oMRM
-----END PGP SIGNATURE-----

--BcZrms9gUsdgyR6a--
