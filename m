Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab2DMP2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 11:28:10 -0400
Received: from imr4.ericy.com ([198.24.6.9]:59725 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680Ab2DMP2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 11:28:09 -0400
Date: Fri, 13 Apr 2012 08:25:49 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.4-rc3
Message-ID: <20120413152549.GA3111@ericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.4-rc3 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Fix build warnings in four drivers.

Thanks,
Guenter

------

The following changes since commit 0034102808e0dbbf3a2394b82b1bb40b5778de9e:

  Linux 3.4-rc2 (2012-04-07 18:30:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

for you to fetch changes up to d7ee11157f1fce02632e2f3a56b99b2afd9e5f93:

  hwmon: (pmbus_core) Fix compiler warning (2012-04-09 12:17:38 -0700)

----------------------------------------------------------------
hwmon patches for 3.4-rc3

Fix build warnings in four drivers

----------------------------------------------------------------
Guenter Roeck (4):
      hwmon: (smsc47b397) Fix compiler warning
      hwmon: (acpi_power_meter) Fix compiler warning seen in some configurations
      hwmon: (smsc47m1) Fix compiler warning
      hwmon: (pmbus_core) Fix compiler warning

 drivers/hwmon/acpi_power_meter.c |    1 +
 drivers/hwmon/pmbus/pmbus_core.c |   17 ++++++++---------
 drivers/hwmon/smsc47b397.c       |   14 ++++++++------
 drivers/hwmon/smsc47m1.c         |   19 ++++++++++---------
 4 files changed, 27 insertions(+), 24 deletions(-)

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPiEV9AAoJEMsfJm/On5mBwcYP/2y6yCFtFSU21he4hE5xYFaG
9sK28PJBSbG0masfq7NW55B3FI6f1+p3iiXuZcy5dr4cuvfQpAKTJjaDVFMXSGn0
izrTMhGHMEdaDl4eP3oolQyWSMoP56P8mTUK47iD4Hmy/zCGTMsoWVw3E2PN6ydp
6e3PLkmNnCArwQqK8qDcnB+KqQNpeaeaydmZK8Yv7TQHaayl/5tAvX4mQ9925zm3
PWWTFVMiVKPtjBZmzkSA/QvCKWDFfMeonTe2IkMRnYRohRX2pTFphLlP/WoMDXiz
XjqDgeoGDIWt5hNw0frujLAFxCJ3VhaSGz678xIUS5ZgxI7DYPyikAl4dIq7IOs7
igMIpz7uKaJLijotu36keirusb15ZrMQeOURgTNQ5bNbC+NefRoHCPeA1mtDSySn
pM85OX383vd2pYiJZCaGAY84+XuddALwaQ9t+Uuies8e7E8vlrjxl6W02R+hUsp/
hIDTfOkWzS1ple2yfBX4upiwV4qEc5NKMj8aYTy8CMAEboGjHekW5nWZOSUUHknR
KyepEjHmOUBTKEsU+Ycew4Hp1xto+X0cQwLZecp5YBujylBwx72of8IRxCpLA5zY
zCWbczzqVdKJ0PsS4vUEW/YQ2ZcPtDLJG8scHQM/YjBGPZQuG8cbdehT5XCJKB+4
yFwOYHkUD6tgRIeEZfGG
=ZBg2
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
