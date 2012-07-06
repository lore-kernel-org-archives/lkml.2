Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab2GFFYv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 01:24:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53453 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab2GFFYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 01:24:49 -0400
Date: Thu, 5 Jul 2012 22:24:44 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: [git pull] Input updates for 3.5-rc5
Message-ID: <20120706052444.GA6804@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull from:

	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus

to receive updates for the input subsystem. You will get 2 fixes for
regressions in Wacom driver and fixes for drivers using threaded IRQ
framework without specifying IRQF_ONESHOT.=20

Changelog:
---------

Lars-Peter Clausen (1):
      Input: request threaded-only IRQs with IRQF_ONESHOT

Ping Cheng (2):
      Input: wacom - fix retrieving touch_max bug
      Input: wacom - don't retrieve touch_max when it is predefined

Randy Dunlap (1):
      Input: fix input.h kernel-doc warning


Diffstat:
--------

 drivers/input/joystick/as5011.c             |    5 +++--
 drivers/input/keyboard/mcs_touchkey.c       |    3 ++-
 drivers/input/keyboard/mpr121_touchkey.c    |    2 +-
 drivers/input/keyboard/qt1070.c             |    3 ++-
 drivers/input/keyboard/tca6416-keypad.c     |    3 ++-
 drivers/input/keyboard/tca8418_keypad.c     |    2 +-
 drivers/input/keyboard/tnetv107x-keypad.c   |    8 ++++----
 drivers/input/misc/ad714x.c                 |    8 +++++---
 drivers/input/misc/dm355evm_keys.c          |    3 ++-
 drivers/input/tablet/wacom_sys.c            |    6 ++++--
 drivers/input/touchscreen/ad7879.c          |    2 +-
 drivers/input/touchscreen/atmel_mxt_ts.c    |    3 ++-
 drivers/input/touchscreen/bu21013_ts.c      |    3 ++-
 drivers/input/touchscreen/cy8ctmg110_ts.c   |    3 ++-
 drivers/input/touchscreen/intel-mid-touch.c |    2 +-
 drivers/input/touchscreen/pixcir_i2c_ts.c   |    2 +-
 drivers/input/touchscreen/tnetv107x-ts.c    |    2 +-
 drivers/input/touchscreen/tsc2005.c         |    3 ++-
 include/linux/input.h                       |    1 +
 19 files changed, 39 insertions(+), 25 deletions(-)

--=20
Dmitry

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9nacAAoJEH70+W8r6ZYqXwkQAL5YohjgWMqqg43JLkfHLbC5
nOCUtBcqVkubUoM/4xq7pGBjQeyWz71kSduoX6JKRmvvM20K23LQbJY5M8s1piZ6
pC1Yhh977Q5xcgOKQNiP75VILaUzwMIQZnaac2M/rzuJwgmA+QyVdIxk6JWc/WLY
txBEY1chniCngugfEWhLmlKdxe/5ZWZUFastMuGFJjYTo3iZukwEocGZVI/7Fxb0
UJ77NpU4cEdhS8zqgNGRSEuNnQzHFhjmgB+Ck8XObPcIE7d0TqmkIC+WwYaASkAE
Ph/iZvh9PbXUURUVlvYc8OFrd1TNf1TiE9KgYXKxfTMD6KvzCwzRVy+k//WQXgj/
uLjwnzhmPbmZkfoEyOUxakcagrLGygvojanYn2Dbn+hCyvBPpNHCajDyHYFkVzqQ
mXAi6uBJaYRg0tW7aYDJd4tj+pVL6MH0iL16bcw5Db3XA7dE1rPjgqyOXKZ6V0LU
IyBtLWYeni7blZ8oYuN6NCDcmLeEc1ZKiQJkVZbEYYj+p5kEa56KUVsARNJ3CplA
FGpxLg5FBybTLet9gmRQUcbSw0fi/GcvFNDLhKndiXtZP2u98dH8Y7XA4pIW2j7v
Z/C2SKZTT7yQ+Tn/T1bWXfYojd/tS7oFfmX/siNNzm9vinyN0L/Ya0o+rbxoCDSb
dqFyWpvWG6nxIAgcwWOB
=j6O6
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
