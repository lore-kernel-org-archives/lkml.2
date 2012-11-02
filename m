Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab2KBUJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 16:09:43 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63060 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386Ab2KBUJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 16:09:41 -0400
X-Originating-IP: 108.223.40.66
Date: Fri, 2 Nov 2012 13:09:54 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon patches for 3.7-rc4
Message-ID: <20121102200954.GA32041@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon patches for Linux 3.7-rc4 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter
------

The following changes since commit 8f0d8163b50e01f398b14bcd4dc039ac5ab18d64:

  Linux 3.7-rc3 (2012-10-28 12:24:48 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git tags/hwmon-for-linus

for you to fetch changes up to eaa7cc60f7dff5e74ef387ace8228235fab8241b:

  hwmon: Only include of_match_table with CONFIG_OF_GPIO (2012-11-01 17:31:20 -0700)

----------------------------------------------------------------
An e-mail address update, and fix a compile error on SPARC

----------------------------------------------------------------
Andreas Herrmann (1):
      hwmon, fam15h_power: Change email address, MAINTAINERS entry

Jamie Lentin (1):
      hwmon: Only include of_match_table with CONFIG_OF_GPIO

 Documentation/hwmon/fam15h_power |    2 +-
 MAINTAINERS                      |    2 +-
 drivers/hwmon/fam15h_power.c     |    4 ++--
 drivers/hwmon/gpio-fan.c         |    2 ++
 4 files changed, 6 insertions(+), 4 deletions(-)

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJQlCiSAAoJEMsfJm/On5mB/cwP/1h0v+YcE/U6M3Jr0plsd9jE
5kMDvYmcrm0MuHTnl0wIOQ+d1SfYPAxMtyWz/lG8s+GZ1JzLRIbD9w1S3nd1twOT
jcck808ZOSH1wMaPRkFdbqpc7qD1c9sRVtAH5/qTYBmXxZ8hiO0lCiv7qlmp6uYU
HUpeqx86OG9KQb/vC96J7a8bImjic09h38P0fR5kp0s7G9wfel2J9ZGmbrg1sTJA
XbgPV0ODyq95gCwKKnO6Z7pBMRIwrXnJRWzWUe6Fw0j4trI1VLnC7rp+L6yWPtlY
xp0YQ+3aVZsXykBbzmdGSVmhdWbJBQxd1czs+U3nPxxa2H0vDMEgzfmkEvVfbfVc
6iR3zJBCbSyI8pGDfL2krow5MZwZrY+VIt7uhBOaiEEui4HyFmggeQDin2hfRmPI
tOHIPRfDVEUeeFAuLA/mON43RBKmRRfBQIf6DLBVpg5ZdNbPczEmpbwhd0hLEXhf
vFvdboI1NHpvrzn714tp6VMx+CnB1ZAqg/XReMW2poMqTUK7FYREvGFj2RvYYxUf
LMqFgrQmlEEXRlBEleFoQfJOTUgIm+8EXuXeZ67pXZgl5rlIV43kx2Hw7GYL8Bhx
x616qsCNYazGWN2Nf9IDqDVDLYGwGhRcOcTlAlLn6pbOUaVGiTWIWw3yWUeXe1Nn
vvEJFgdWCRXOaN2djJm7
=96mN
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
