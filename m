Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab2JSSj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 14:39:29 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55444 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab2JSSj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 14:39:28 -0400
X-Originating-IP: 108.223.40.66
Date: Fri, 19 Oct 2012 11:40:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.7-rc2
Message-ID: <20121019184035.GA7287@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.7-rc2 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 1102dcab849313bd5a340b299b5cf61b518fbc0f:

  hwmon: (coretemp) Add support for Atom CE4110/4150/4170 (2012-10-14 15:21:33 -0700)

----------------------------------------------------------------
Drop some leftover dependencies on CONFIG_EXPERIMENTAL,
and add support for Intel Atom CE4110/4150/4170.

----------------------------------------------------------------
Guenter Roeck (1):
      hwmon: (coretemp) Add support for Atom CE4110/4150/4170

Kees Cook (2):
      hwmon: (pmbus) remove CONFIG_EXPERIMENTAL
      Documentation/hwmon: remove CONFIG_EXPERIMENTAL

 Documentation/hwmon/coretemp           |    1 +
 Documentation/hwmon/submitting-patches |    3 +--
 drivers/hwmon/coretemp.c               |    7 +++++--
 drivers/hwmon/pmbus/Kconfig            |    2 +-
 4 files changed, 8 insertions(+), 5 deletions(-)

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQgZ6iAAoJEMsfJm/On5mBtVYP/RJPyk5d/3ApIM8iCun2ZHBY
rKe0CefH7Uj/tJa3t9mwISzGmD1nPs/WrO0pqpku1FBSWF/8RScpUtd9UwJRZJ52
+hGpo6F29/uc/iLyup79UzCWTPi0CgrE+gFo010nQmZvJ67W7KgFWS/7Kehq612W
tJJkNQDqJ8da7xW9lhv1N45KTlhZw/rRKGlqWJ98BvTLe1ORSlPQn1Tr8NEglp9M
HDlW4RRyDAnduhIG/O3hzuQILm18zk+fdWvyJp63AuWfChS77yVT/Cp4bOoJHXhC
mB2yV/HThp6wRvibKoZTtprmW9KHVd3Fr5m3N2maHI8K241/W0bQdtOXv3oboCPw
wpHXuWMGfQN33gQ/RyTzn1MDuBjmdk7ZgyDIBTsgrvJHROfSS7NwvYSLnZKT7e6U
I4Pfl+5KFQeR81UE4mNrvclEy2jdny4zrpwPFG9xjzo0i7mLoUu4bKGp6MIhV5V6
60/RBz32xGRfYzeLRMHFNQBQtAoMI0Vl1GTiWPNC4dAAipB9SYHahaXEVoHrUJ8M
um9xiy7D2q3jUCHNzo7NekQ6/n4vsJn2EEI+FE8P55JTvYYL5IcFXk51TvCQPboJ
woHUbmRT08GYZ29f4c8QFoNj6SUi3juTO3ZrIPrSZo6ceMyVn6hy7Ap3MCmyc57m
rVZFtLBR+g1dc3vIQ3H3
=J6xN
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
