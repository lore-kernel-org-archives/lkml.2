Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab1JUR0Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Oct 2011 13:26:24 -0400
Received: from imr4.ericy.com ([198.24.6.9]:57007 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753475Ab1JUR0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Oct 2011 13:26:23 -0400
Date: Fri, 21 Oct 2011 10:24:38 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.1
Message-ID: <20111021172438.GA10764@ericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon subsystem fixes for Linux 3.1 from:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter Roeck

------

The following changes since commit 899e3ee404961a90b828ad527573aaaac39f0ab1:

  Linux 3.1-rc10 (2011-10-17 21:06:23 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Jean Delvare (1):
      hwmon: (w83627ehf) Fix negative 8-bit temperature values

 drivers/hwmon/w83627ehf.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOoarWAAoJEMsfJm/On5mBQR8P/1GAlo2YJx7596NKXjoOPODT
I0FKtXMk4RRrmln8JUyjBSwEXTx6S/9392D1YoRKHgqU7+MBk0ny04XHMId5p3N1
SfcfBn/QkNM5gIh04aQ1/ST0O0Aa79cPWCakw0xuMgGIfpFi+BtpBcS8VpINlPP1
GnvVV6sjJTHHYzE8ZJVXoB3HOVBV8M2P86FjNTETKLESg1o3oFslAfXLt1KYrmTg
huzeiEAslptIUMszC9Hp+cXv4tKTzqDMyMpEyaDvvAVsKxc2ddrrzJAZxTRrZD5U
kC7gS17Ek+lQ668UNsSruxeG1FhISXXepzPXLSRzYWnxLyUe7c0fQV1mVAgWjTI6
GjJln9bmR/USv3QiMU6K5/HzIjh15G+1APGyK/QGLS1U52Uk7BInnsFzW076pOzv
4tgQzB5O3HnXM7U79oxKZf6UrD0oyh19ZS7THXhMGLJ3o7Z1Ao88UEjrNfQ3im3l
I4JdbqbI0RZX+WkoH6sYz7v4R/gnb2j9YWNheS6Rxm8HYiUK7Obv+W34ik+8bSrn
Jhm1MbUdj7bW4t17DKsIe+MuhxN7Wl6T1OC8UQzRpXjIBqmNHBRgtYxT3274KOzn
sYKDcC30jt0Eb8Iinq0b9B85egD1DFrbykGN1CKk8eMT481xGFeRCywUH5wMr/Lw
j+swQYwsGH9L/IFdARJ7
=XtXO
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
