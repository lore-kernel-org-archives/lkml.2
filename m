Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753648Ab1KYWQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 17:16:16 -0500
Received: from mail.df.lth.se ([194.47.250.12]:34090 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408Ab1KYWQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 17:16:15 -0500
X-Greylist: delayed 513 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Nov 2011 17:16:15 EST
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [GIT PULL] GPIO fixes for -rc series
Date: Fri, 25 Nov 2011 23:07:20 +0100
Message-Id: <1322258840-9206-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Linus,

Grant asked me to harvest GPIO fixes in his absence,
and so I've done. But so far I've seen only one,
anyway, here it is, please pull it in.

The following changes since commit cfcfc9eca2bcbd26a8e206baeb005b055dbf8e37:

  Linux 3.2-rc2 (2011-11-15 15:02:59 -0200)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-stericsson.git gpio-fixes

Mark Brown (1):
      gpio: pca953x: Staticise pca953x_get_altdata()

 drivers/gpio/gpio-pca953x.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJO0BC7AAoJEEEQszewGV1zw/wP/j87GuAeQpGX90TaDjH8dQ17
wWbfNofxdYPzElIsu6/9QPDMj9TkfHSBySteXVBFvSfOOdYBCwmnOf0WDqQEbg6K
voG5R2dG0ksQpK6tkjZAWM6DJ5XeEXc0skf2+XauD84df2EAlnFc1kHeX7i08k0Q
pvow6tCGadHiuRD3waS2nuDDoBC7d0dcB8kPAYgZ9BuJA9eysWoeNJB3YIun+tdT
7qkexhj0YvKV9PmcAA5P2TaJ/HQPX+9ycc+pzAqxRgfqeN7NQ1PrKym40+wTiGyB
bnG7VRkSHk1VAO3waf2VUmE1qJ7o1uKPpSHIbwceIdlMFqnfpYrtTb6w6iR1T8uu
SZIaDKV+3afVROInwdGNMf1m/Amzbabh0ECbSYwkChUO0wQ3TgE1a5LyOMmDO7Ih
EuexSnRZ30sUjyQtV4fqDJN5EcsoqiqTgVbZlKcrO+uYLiOmQTCutjJxrhSmSxgm
L28y8by9Ixttklp/2I0KE8skTQC3igYJYEwgfzDgIphGlfxBeevjalU4Pk2SCs5Z
55GZ68B8tFT1CT8YShnrXbKXxw9eSum+DhJwMPliCLIi5+JrMufYZMomCreCZPGU
cKs/Qkv7ne6Z16SO36Tzf3vWn9MoDW+rxPQtuHlm+QfQjfTnYeyBL+JdI1eTVZW3
Z4L4qxXg42xqNGDl7NUa
=dsSG
-----END PGP SIGNATURE-----
