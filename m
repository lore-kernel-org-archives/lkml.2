Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab2L0N6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 08:58:21 -0500
Received: from mail.active-venture.com ([67.228.131.205]:61585 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752446Ab2L0N6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 08:58:20 -0500
X-Originating-IP: 108.223.40.66
Date: Thu, 27 Dec 2012 05:58:25 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon patches for 3.8-rc2
Message-ID: <20121227135825.GA9302@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon patches for Linux 3.8-rc2 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit a49f0d1ea3ec94fc7cf33a7c36a16343b74bd565:

  Linux 3.8-rc1 (2012-12-21 17:19:00 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 86266ca0e23b2b8e7e38edda1675cd085a9abc14:

  hwmon: (emc6w201) Fix DIV_ROUND_CLOSEST problem with unsigned divisors (2012-12-22 02:16:40 -0800)

----------------------------------------------------------------
Report i2c errors to userspace in lm73 driver
Fix problem with DIV_ROUND_CLOSEST and unsigned divisors in emc6w201 driver

----------------------------------------------------------------
Chris Verges (1):
      hwmon: (lm73} Detect and report i2c bus errors

Guenter Roeck (1):
      hwmon: (emc6w201) Fix DIV_ROUND_CLOSEST problem with unsigned divisors

 drivers/hwmon/emc6w201.c |    2 +-
 drivers/hwmon/lm73.c     |   16 +++++++++++-----
 2 files changed, 12 insertions(+), 6 deletions(-)

--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQ3FQBAAoJEMsfJm/On5mB/QgP/0h4HGPtK/IbpXTX4ZrXfmga
6LWcHHCl4xS/I948gOIiPREvvC6Lqp3OMQRZuFDsZsOgC3O7P9dahTxAaqN+WwB1
UbosY+S6hqiMmxI1XKPbtlxZq/ZTTIRcPdGg+Z8VqafarNHR2WYYsYPDlimzxOh2
HPcoTx4THX5oa1tJsrVNyJeKakAm+RuKMA7dtBdIRZ5Jq0SnsfaC+o4I5VQQ8tJD
X0mlthskniYBxzhQpk40BPo9oKqX7t352czpmj61Og45nu68ZjyPxu950ztT2CA+
rUmvkVvzc9KVF2iq6qorbUQxKZg9xC0EXSpr8Tc7LRdzRSfKAetjEhcjv0qVZ9KU
6Rfvet1W4adm869Z3g+WWr5aFkgiTF6N5pZzd0LtirpWGl80tNNCvG8KsgWs5QQz
4BNHQwyD1+iCw4GD0+XLLwG+lRbyaPFgQb5VFWNen2T0FFZJYoF5/7WJYdnGjb7m
RgLp3IbO9aOtQ3bWUQFYxF/8yu6fW8e+IE6r0/g3Clq3mRzvRxrRHDWaPHjSaq+S
LxVJRE/ERDolQxxV9q2BamL8EesU1u8E7+g9NbxQRnC5CrEN0gg9DBLinD08cVwU
e37v1Yo3gQvmS2x0aiU08ytRFxh6KJoT5/BKFuGRUXnda0AEVNWBT9LPM1AXjp4P
MUPjT98u0WDmSJ+7GARa
=liQD
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
