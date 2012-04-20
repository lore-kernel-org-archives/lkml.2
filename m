Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab2DTP2h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:28:37 -0400
Received: from imr4.ericy.com ([198.24.6.9]:48178 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755691Ab2DTP2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:28:35 -0400
Date: Fri, 20 Apr 2012 08:26:23 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.4-rc4
Message-ID: <20120420152623.GA8928@ericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.4-rc4 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter

------

The following changes since commit e816b57a337ea3b755de72bec38c10c864f23015:

  Linux 3.4-rc3 (2012-04-15 18:28:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

for you to fetch changes up to 1196573fe493aeeb826468157313ee84ffbc59f3:

  hwmon: (ads1015) Fix build warning (2012-04-18 11:15:50 -0700)

----------------------------------------------------------------
hwmon fixes for 3.4-rc4

Two patches: Fix build warning in ads1015 driver, and fix bogus power values
with current BIOSes in fam15h_power driver.

----------------------------------------------------------------
Andre Przywara (1):
      hwmon: fam15h_power: fix bogus values with current BIOSes

Guenter Roeck (1):
      hwmon: (ads1015) Fix build warning

 drivers/hwmon/ads1015.c      |   33 ++++++++++++++++-----------------
 drivers/hwmon/fam15h_power.c |   39 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+), 17 deletions(-)

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPkYAfAAoJEMsfJm/On5mB34AQAJaUdopNHrnFbASTaP0xr4sF
akn0K7LAi8gVhSkOPnPrMLgWk9XeNSn3w1Dct947kfDxpyB0lovYm+UNPHLu/x0v
CZVQVK5P/Cok4ue/kVWFlSzwyDs1c4nod/ijQObGusoZ1KeMPF55jL438ycWeJAo
ObCkS49Rtxe929+oxuKKr6VI5uopHmrdW29R9E5XAxWuQvF+NVd6a7TlLcsOgfAE
of/PtaljW8/dTz7xj6aWrDuW4SVo3b0MfcFkgoQK1jxVxeRSKfkMSaVo2xd9Fe0V
VDfYtbfI9THmEM0yGIQ93mVNDU9JDlqyIZLaEmwAPKyTjdgWIZ8EcrosdHXGZUGV
BeK9Ak08JK/EiIdb5OEI55F45CsVspIVC1xmF28dQZ/l0Z0Kc5IEsEklUlUGJxTO
4+Iw/8TGQ0grsXiswHUJl70NewhxygwpAxWN4uv8OedUYceX69aBq0kmq4myf69e
UW29b/URvY5iDC7t3QQeqQYImntW8i3frbnEvv99+wl7Hwx5gNDEOMqQy7ZMkq/J
FOlu7BWafmp/pgmtfj316No0e032LPQ9zlL+6zDprhDPJN8JMyhZk1nbYRANYrF8
Cvvsqgj1q13oioq1MVrEwvqvjmZf623svwr3CSSPIQcM1VOLOJ2L3gBp53YuQ0sM
Pcn8qXIURLqC5DXJyAYl
=mbkI
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
