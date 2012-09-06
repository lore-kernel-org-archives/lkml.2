Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab2IFPT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:19:28 -0400
Received: from mail.active-venture.com ([67.228.131.205]:65329 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab2IFPT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:19:27 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 6 Sep 2012 08:19:28 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.6-rc5
Message-ID: <20120906151928.GA18841@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.6-rc5 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

There is only one patch in this pull request. While the changes are not in the
drivers/hwmon directory, the problem primarily affects hwmon drivers, and it
makes sense to push the patch through the hwmon tree.

The patch has been in -mm and -next for about a week with no adverse effects.

Thanks,
Guenter
------

The following changes since commit 4cbe5a555fa58a79b6ecbb6c531b8bab0650778d:

  Linux 3.6-rc4 (2012-09-01 10:39:58 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to b6d86d3d6d6e4c9b588d81615c81b5a8292b62ed:

  linux/kernel.h: Fix DIV_ROUND_CLOSEST to support negative dividends (2012-09-01 18:58:09 -0700)

----------------------------------------------------------------
One patch, fixing DIV_ROUND_CLOSEST to support negative dividends.

----------------------------------------------------------------
Guenter Roeck (1):
      linux/kernel.h: Fix DIV_ROUND_CLOSEST to support negative dividends

 include/linux/kernel.h |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQSL8AAAoJEMsfJm/On5mBhqQP/1NzZ1G7S6eiZXCO9hi56G3a
zhrmYj4GQzzuUdUKnhJnB/Q8RyyeRNKuDo/jt35aGPEf5HQgVQcB6ylUIAFvvzBC
0VXmtjkS/nZjJmg9UCsQQSPnXzeoBtXWDTe97XXz1ThoxdbpgWybOUzW5rW4MF+z
SBhpIDuOfZC299rK/JjGPI49KzmY2voOAlIvZJp76jT+KLs+CptuHlp+yJa5KYck
d/68zaL5YvVb5I+hQZLsbri1HK5EpkE9Irjg6mw7P7nmp/+V/7daqpz6kLDFfIM2
tNAeXijE93E2JpFLBwjKaICMsYOKLCHzyctCJbdepqwVaKEGIeny395QhsBSoIFs
msDJbAj9U9d4RTSv7u5Bz+niYwfR7UelbV2o8NFv3F2w00OAScXByIYEFxt6jjH3
jBMZ7Rn1sMqm3SglR6wPmdBdoXjtjTR5/3wfbGTsnMIU6YoDGSDNBOGZbdAW3bEO
DBNvR3kcoYlDMkjyik5ius06zsj+gz/ByHclSR2NrGXtPrxu+3stvRAiKTUIbsrK
Jt7A5IZ1y2KoOboxiw05mz9P6gEU4Ot30gkRxcnQ96xiAazqKBuNZh1WW5Ogvg1t
dIUs78WuAMkqInMfz4RAc165aSWfaYFShYxCMG9fytX2icoDbaKqdLhJ8JOuzqxc
fKLfSZ7OfS6jHPi7QRon
=kD6t
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
