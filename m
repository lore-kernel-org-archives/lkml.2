Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab2A3Vbs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 16:31:48 -0500
Received: from imr4.ericy.com ([198.24.6.9]:48638 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622Ab2A3Vbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 16:31:47 -0500
Date: Mon, 30 Jan 2012 13:29:35 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.3-rc2
Message-ID: <20120130212935.GA4792@ericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon subsystem fixes on top of Linux 3.3-rc1 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter

------

The following changes since commit dcd6c92267155e70a94b3927bce681ce74b80d1f:

  Linux 3.3-rc1 (2012-01-19 15:04:48 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Guenter Roeck (2):
      MAINTAINERS: Drop maintainer for MAX1668 hwmon driver
      hwmon: (w83627ehf) Disable setting DC mode for pwm2, pwm3 on NCT6776F

Jean Delvare (1):
      hwmon: (f71805f) Fix clamping of temperature limits

Mark Brown (1):
      MAINTAINERS: Add hwmon entries for Wolfson

Vivien Didelot (1):
      hwmon: (sht15) fix bad error code

 MAINTAINERS               |    8 +-------
 drivers/hwmon/f71805f.c   |   10 +++++-----
 drivers/hwmon/sht15.c     |    3 ++-
 drivers/hwmon/w83627ehf.c |    6 ++++++
 4 files changed, 14 insertions(+), 13 deletions(-)

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPJwu/AAoJEMsfJm/On5mB/NwP/RsVmAmNU5l/1/lQm6pww9nP
8W3/mh70y7ce8xy/WksG1uHNFG3yOawVq46CZzdvWeF4uDfHzaF1P8WBi46CbMWv
O/fMKW8Qx7Pw78Nr+HALvVU0RaKWTlT7tldLfqs9n9TFp4yz82y/YtrjsEmoDCah
6aPt3WkcVwnY3pU4I7PTdlwibgBkRWtHT4isKAR1yrNM7PXrI5Xvz/F1asLHGSVp
uTGxrnuOKtMt3yZNntXtoe8mtAoIduz1XhE+W3mJHojcVHMbHxjziPG1s3EOnQvs
IQR5GKFhDZm7gEyc3GKgUWPmzwyZdfJyz2hKM43YgadBT4P/hU8/ibGYpG4Lbwpv
6wS/aU8DQZ7AHfzlbBXADTPn6P/CeTOsmTgytEC1capc5Onng/D2dx04qkokAguV
7E5GY8znInr7mQYV+bk4olNBm3ZLr9P/z9953RYiBPDEr8jON96dYNlNMiX707s0
jA/Qj7jzVzePuT+eh1YzsN1G6XpcZXfUJyep1H9EhY7jeRVrL9c15t336u2hjMGv
3rXPDo/UxHrOPkCq2+0Y2Ia1rn6jQatAlfSA5IgqZYYqbOhFk0rtCnHTcxB27PSl
d+aLLLlAqQfEoCbMgdfHPrkLgT8JW1+6pSZxQL5fLX3ALMV2ZXRQn8QYh2iV+ETH
VoIVhoCExGaBEEmJ5QDF
=zM34
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
