Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914Ab2G3BRX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 21:17:23 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62115 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab2G3BRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 21:17:22 -0400
X-Originating-IP: 108.223.40.66
Date: Sun, 29 Jul 2012 18:17:46 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.6-rc1
Message-ID: <20120730011746.GA20149@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.6-rc1 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

The branch is based on an arbitrary commit in your tree. This was necessary
because one of the patches fixes a newly introduced build warning.

Thanks,
Guenter
------

The following changes since commit 25918f9811eae1d657db2bccdfcb077038d9454c:

  Merge tag 'fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc (2012-07-26 20:29:52 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 829917cd7246204d6c5f066c40b66d2b62d0930d:

  hwmon: (applesmc) Decode and act on read/write status codes (2012-07-27 14:00:12 -0700)

----------------------------------------------------------------
Fix timing problems in applesmc driver
Improve device removal in jc42 driver
Fix build warning in acpi_power_meter driver

----------------------------------------------------------------
Guenter Roeck (1):
      hwmon: (acpi_power_meter) Fix build warning

Henrik Rydberg (1):
      hwmon: (applesmc) Decode and act on read/write status codes

Jean Delvare (2):
      hwmon: (jc42) Simplify hysteresis mask
      hwmon: (jc42) Don't reset hysteresis on device removal

 drivers/hwmon/acpi_power_meter.c |    4 +++
 drivers/hwmon/applesmc.c         |   70 +++++++++++++++++++++++++-------------
 drivers/hwmon/jc42.c             |   26 ++++++++------
 3 files changed, 66 insertions(+), 34 deletions(-)

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQFeC6AAoJEMsfJm/On5mBY4gQAKHxfS67P18K4zq50la15bqt
QUyqPA+FBWK8+GX8q+cDzTNdAroejpbW65qqjp5qK0rmbNVJJ2+UscgIUhBqpoXp
zBvCQeK+JHNjU3CgLgl9IEj9Gxsa+KRGKwZ7QhfHu5pHVp3VBchvDIdrFIsE33dX
L19Gdt/k2zxtHhHK8SWuuJk0KY9tTBf+6sLEQYHb55zAgTFoQ6nLaTQX0bN0KApz
EUdSbrJZPqffXWfG18yNmBaVKoxZ9n5yYtiGE7rIG+fNasHl3N7215cYbwPK88xP
lpj/51YHmtm2pYW1NiTPPCQu31iwjkPbFWKb9ai88x7iNuL6ki4yPqVeEV1LmwMd
fJX5TNTdlN3sVq6QMisyyFizRHRvQvg7MtPfqXO71eo/5vN/1QLgnXT7Gc7NSUHO
Jh5hYZ22nWpPXnk/1wZks3hzKc8a8nUcoDirEdtHTLCur1nSJqitJTDB9BlyQemn
6xR5qJLq1vAh5H7WvlxJBZpqmwqOFu0ZmmQMDK/Gzue0Zt576h5U1R217xERlrUZ
4w0yPi3LPE+AoEHty49VJxQp2BUaYOSDffu1Sr8KafKr8rdYy3b8FBQrWvytpe+N
fXQfTwJMKt00T1wheHqDuRQPzSBa9QpkIdbkZtddxBhgFixDSS/EC4h/iEH7cThZ
G4aU0NBUyNUgs9ktkr3c
=jJzw
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
