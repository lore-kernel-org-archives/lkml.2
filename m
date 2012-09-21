Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab2IUARe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:17:34 -0400
Received: from mail.active-venture.com ([67.228.131.205]:49318 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab2IUARc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:17:32 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 20 Sep 2012 17:17:50 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.6-rc7
Message-ID: <20120921001750.GA18950@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull hwmon fixes for Linux 3.6-rc7 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git =
hwmon-for-linus

There is one out-of-hwmon patch in linux/kernel.h to fix a compiler warning
seen with W=3D1. The patch is low risk and has been in -next since yesterda=
y.=20

Thanks,
Guenter
------

The following changes since commit 5698bd757d55b1bb87edd1a9744ab09c142abfc2:

  Linux 3.6-rc6 (2012-09-16 14:58:51 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git ta=
gs/hwmon-for-linus

for you to fetch changes up to 263a523d18bca306016d75f5c8d5c57c37fe52fb:

  linux/kernel.h: Fix warning seen with W=3D1 due to change in DIV_ROUND_CL=
OSEST (2012-09-19 06:51:25 -0700)

----------------------------------------------------------------
Add missing 'name' sysfs attributes to ad7314 and ads7871 drivers
Bump maximum wait time for applesmc driver (again)
Fix build warning seen with W=3D1 in include/linux/kernel.h, introduced
with b6d86d3 (Fix DIV_ROUND_CLOSEST to support negative dividends)

----------------------------------------------------------------
Guenter Roeck (3):
      hwmon: (ads7871) Add 'name' sysfs attribute
      hwmon: (ad7314) Add 'name' sysfs attribute
      linux/kernel.h: Fix warning seen with W=3D1 due to change in DIV_ROUN=
D_CLOSEST

Parag Warudkar (1):
      hwmon: (applesmc) Bump max wait

 drivers/hwmon/ad7314.c   |    8 ++++++++
 drivers/hwmon/ads7871.c  |    9 +++++++++
 drivers/hwmon/applesmc.c |    4 ++--
 include/linux/kernel.h   |    2 +-
 4 files changed, 20 insertions(+), 3 deletions(-)

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQW7IuAAoJEMsfJm/On5mB/HkP/3xhGlhoEegtuINbZtUs8kCe
3xM+DPtw4ROyxcm0ZNGc2tgytI1CclmV4nQ/1zmHoRgcNIzLo8fo82V9b5bnEmoa
64UUukEwAoJ0U9iQWoj9uIgcXtbp+JjLr+M/rd18QlFKE7pPH+bHdbpYaRSr6EoU
y+kyJrAtojMqgXQfxy90c/92Ctchvutsw9vcQkO2M4Fto7nflt7jBWSQ5VcgH+Oa
727ZnthDSAPsuFZ9xgBzfOtC1d4C/TNOiwsptQahMbcbe7Dj8HChptRUzrVhgUyb
HRS+53OEu97YKTSDmcwsDADp8ppxcZqEoYBxSLN7Kpgf2giDIdVCnA6YfBQuosLF
xQtdnzE9nNZ5QkUpbs+YXqKE2yaB/yfxC2+rTYO5l/tqbyJiWMAx53KtZknsgcKV
dv4QiCi0p46Jvr+iZV+/9Ez+ACH1hs7IQZEm00ZXtZ50C5IKiMIR/3duekzY/4IG
HgKK52PFrgd1LtSknBP8LT2ap1x5gyvG+coaHztAeQdQcBd+QOsGANrIalwVo7nY
BXv2UYKBa3VCjN0X+JptQHlH/WXsQUGPZFLUxqIz9uqexlWs3hrFta9vQKlpE6w7
6tSv3QkwQdpIsHJ3L1Dc6fRo+NBy5kvISHmBTqsXJkBRq9BRDjyCuD25yK+bpeSY
4tkmIvZcAf7ou0LiAO5q
=eRvz
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
