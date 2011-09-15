Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934443Ab1IOSzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 14:55:05 -0400
Received: from imr4.ericy.com ([198.24.6.9]:42344 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934209Ab1IOSzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 14:55:04 -0400
Subject: [GIT PULL] hwmon fixes for 3.1-rc7
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-pwFKYr+h5L7o4O7Eq0iT"
Organization: Ericsson
Date: Thu, 15 Sep 2011 11:53:40 -0700
Message-ID: <1316112821.2456.47.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-pwFKYr+h5L7o4O7Eq0iT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull hwmon subsystem fixes for Linux 3.1-rc7 from:

    git://github.com/groeck/linux.git hwmon-for-linus

Thanks,
Guenter Roeck

------

The following changes since commit
b6fd41e29dea9c6753b1843a77e50433e6123bcb:

  Linux 3.1-rc6 (2011-09-12 14:02:02 -0700)

are available in the git repository at:
  git://github.com/groeck/linux.git hwmon-for-linus

Guenter Roeck (1):
      hwmon: (pmbus) Fix low limit temperature alarms

Jean Delvare (1):
      hwmon: (coretemp) Initialize tmin

 drivers/hwmon/coretemp.c         |    7 ++++++-
 drivers/hwmon/pmbus/pmbus_core.c |    9 ++++++++-
 2 files changed, 14 insertions(+), 2 deletions(-)


--=-pwFKYr+h5L7o4O7Eq0iT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJOckmxAAoJEANmWzN1g3l3SrQH/ia+6I5VzOm1obACuyfXlaqA
87M1jJePpM50BtVQtcUMUKPn2ZCuTaHCOB0VmV+6voVMc5ColL3UJSHgsl+mY+Hy
hJkeWUqq5EvjM/VUKM1IJcrBzWIzHm3B0tlSiDNcgfEgAJY3tVon8FwhATU9KSgC
d8OoowmFgdKatx1Y/LyvRwZ9ehfTpuieoI6nPJusY8w6MO3PLq43lLezItScVbT0
NJkcRG+uj/zON9LwQRHheI2L46gMWtg4ZtVKY/jkQJyEBss7YsTQbL1io1y6DKtq
8UE6zNtYBHeyxFH3I8EJrReE0Uxbb4nJtemrCLAKsAD7Qtqd4lrH9i5CDZFtotE=
=IPdo
-----END PGP SIGNATURE-----

--=-pwFKYr+h5L7o4O7Eq0iT--
