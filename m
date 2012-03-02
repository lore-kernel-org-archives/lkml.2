Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283Ab2CBVrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 16:47:08 -0500
Received: from imr4.ericy.com ([198.24.6.9]:59735 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab2CBVrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 16:47:06 -0500
Date: Fri, 2 Mar 2012 13:45:00 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.3-rc6
Message-ID: <20120302214459.GA25716@ericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.3-rc6 from tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

These patches are necessary for correct operation and management of F75387.

Thanks,
Guenter

------

The following changes since commit 6b21d18ed50c7d145220b0724ea7f2613abf0f95:

  Linux 3.3-rc5 (2012-02-25 12:18:16 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Nikolaus Schulz (4):
      hwmon: (f75375s) Fix writes to the pwm* attribute for the F75387
      hwmon: (f75375s) Make pwm*_mode writable for the F75387
      hwmon: (f75375s) Properly map the F75387 automatic modes to pwm_enable
      hwmon: (f75375s) Catch some attempts to write to r/o registers

 drivers/hwmon/f75375s.c |   89 +++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 75 insertions(+), 14 deletions(-)

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPUT9bAAoJEMsfJm/On5mBVN0P/Rw7msLmnTYOkrAQaLdy1FX4
rDhTNF008T9+2FrnKpANy+PfTb6rIQ+I7WSRYqTUewxnavHmqFEaB18dDe1yxdgq
3kytmK+GNIWMdhlSLaKJ1rILbDNfZYvI1Lu1wKq7qRhx8bwTC12hevvUpNp0zdC8
hv8uEmgj41dRHYRaIxd59MQ94AdXwpmRMvDa2c4NvsxpBXf2n8V7MYKtet31+T1s
VzcqmMQuJzFaa7BmABvE1mkmpTegWXdC90J1LkcVsI0LibsiN5mQIJ591XANgpI6
12GyFEnaYKGww0PoOgLlSBmlCYhtsPGwMOuV3wZp2VCCfSFaGwi/8rIFFY1bEl7l
Clx3IIKzp84GaIkUh+8rXxBasw4VSPyriRnjKdUMYe+/pL26HtNArr9AChSnl8tm
gM4I4IEMYRsPKVxbsVIPTXTzlsLKeNSVJRiDtzVFps47b4opSiS6pXFrNLyLCpWy
yBrdI1TwjSsGgCvB6McrJnBj3XEDiT2e3f37pLCFfm/8iDuTaoY434NiwYDwK0ME
eA9Uf0qk8q7Q3bqMPlKFsw34B0dPlvsaVtpJnumYU3uHohM8m1Byk/LCKxsJBMpk
xD3VOtKo5ADU7GSnYVEeQm/YwjTYCjvpN7RbkW7oinA/YpDJT9vvZLo/XTdBZ7vu
UTagy8rI5KgqkaYjjppq
=Ttqq
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
