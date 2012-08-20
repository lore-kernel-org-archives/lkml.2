Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab2HTQkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:40:21 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63818 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335Ab2HTQkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:40:20 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 20 Aug 2012 09:40:22 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.6-rc3
Message-ID: <20120820164022.GA20942@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.6-rc3 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit d9875690d9b89a866022ff49e3fcea892345ad92:

  Linux 3.6-rc2 (2012-08-16 14:51:24 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to 64f503076f9921fc714a2c79fb0fa520869d2c08:

  sections: Fix section conflicts in drivers/hwmon (2012-08-18 16:17:43 -0700)

----------------------------------------------------------------
One patch with section conflict fixes.

----------------------------------------------------------------
Andi Kleen (1):
      sections: Fix section conflicts in drivers/hwmon

 drivers/hwmon/coretemp.c |    2 +-
 drivers/hwmon/w83627hf.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQMmh2AAoJEMsfJm/On5mB86EP/1vQjUyZYd15QHoITEB1J/Xb
MZHvsw2toHMqtQuuNXLxKOuFt1F/MlQJK+jSxNu7yR5rbb7SdMb45cCD+fLp+Hhf
PXB9QGfFfxdGU498GJUzO0tIcdPHp0AKVb8wHcz/MsHOOKSUOpc56lsCKuQTNsKu
DxbL5uFp8hgOKUVKpwngH5my1gm31SbzqaOBukXIT0av6MmLhFz4fIafrdUjS6dG
+92F1Ez0uiAjDuDv/f+FfdHuc4tRad7lAOHlQ9eEuiLBHddw5mP74aE58K+hP6r+
UOomFBboIepLhoZ1Ln0kkoxVNDiyvY7xOyFInfCeN/664klOF8W6YPyVYV1wpNTC
FFkg5vQUI+OqyUNAlE7rNHrmglSK4evgY7HlKs78u/6w8EK1bN7j89NgS8KfAjKg
vN1IMtkwG+uaFUUKBky4kp5NGhhN8JsbWH90dMFztLNpgwO3ZThm7dQnOPPDD8AK
fg4Hfmc0o55K8tuQl9Uy4HCWp+dM8TxSr3tzKUmjaQuASxQ6kX1dCzT1R/4IxUtR
n0gEHEfmGq/R5Sb57UQMo+3kIeWzaYNO9fdo526lodXaC+z2La5in+J7i1jj25QY
55CZOs7tRv2sZSI0dJC2NhnD5CLEHKqVJt7j5gyndVcqF4cHLKTYHWNr06FX5w6b
+vNYPVefJ3gVrJn9eg83
=i4fl
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
