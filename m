Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab2DIMkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 08:40:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50633 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754324Ab2DIMkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 08:40:19 -0400
Date: Mon, 9 Apr 2012 13:40:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: [GIT PULL] regulator fix for 3.4
Message-ID: <20120409124015.GD3182@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZJcv+A0YCCLh2VIg"
Content-Disposition: inline
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZJcv+A0YCCLh2VIg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit dd775ae2549217d3ae09363e3edb305d0fa19928:

  Linux 3.4-rc1 (2012-03-31 16:24:09 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/regulator-3.4

for you to fetch changes up to c0d78c23423ee6ec774ac53f129e61839dde1908:

  regulator: anatop: fix 'anatop_regulator' name collision (2012-04-02 23:28:58 +0100)

----------------------------------------------------------------
regulator: Fix a build warning in the anatop driver for 3.4

This is a trivial rename to stop the build system complaining that we're
referencing things we shouldn't be.

----------------------------------------------------------------
Shawn Guo (1):
      regulator: anatop: fix 'anatop_regulator' name collision

 drivers/regulator/anatop-regulator.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

--ZJcv+A0YCCLh2VIg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPgtJfAAoJEBus8iNuMP3dy/YP/iIY+tTbFF9tSdlJff9vJVqT
t5KXob0czYvIIbnOyd0ERlhw8Hb2idPTH2FGk9VOO93Ac/HvIGyiK+uMjPFoL5zO
i6fF1HpVrNHYhtkXcNAnda+VRZxUbWTq7p6nvKmvbjXl8Wf+OpJ6bHj0v5a8In5s
i8vC9CHttdQLLu/rWiRZpajgfZE0Vi8xUD4aMAxpTtufGsVia7UO6/31Bf/YXwhw
MwvjTEKIjkbwlcOWZp3pKJIJMow40cGUoYpuZnse82aaPrL7J+ckuNTaJzOdNw9A
kxZEIA1XMeiq055uMHIeK5dr8UUNmnHvDNdR3AqhASoS5Amva7A68LdL44mUU1mC
lUXvljXOjd6IhNgNBX3GOu+hviDn143YTZvVKSHCV7vxMj/0UFkUWUMf+TX5Gsdn
xCnadDEr/t9Hnd8Kvi5/118KKQjlhzMDQB4OW12XF05FVyRFolSdIba0O3QVupIg
/bGlYdIMjUKQfqJ5aF3cwpvg4T2FTvOKWPEHissIIfTtTxKj6MUxPZqAukk9puOH
l5zqguUNOwmzQ3AQ2mTjAeXvgq807P8/KsVKJvYjkT8wx+kQdokkZyQU78xX3r+e
93A9l44HLkbgrTYcMegb6jsdLEHuE2xpPc9RBfrNqH+SNwxMybkGJ0r5v4ubdfsd
mm5U2lfYi4ifxZpFVkOp
=adak
-----END PGP SIGNATURE-----

--ZJcv+A0YCCLh2VIg--
