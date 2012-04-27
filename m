Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932338Ab2D0RVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 13:21:49 -0400
Received: from imr4.ericy.com ([198.24.6.9]:42044 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290Ab2D0RVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 13:21:48 -0400
Date: Fri, 27 Apr 2012 10:19:40 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: torvalds@linux-foundation.org
CC: linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: [GIT PULL] hwmon fixes for 3.4-rc5
Message-ID: <20120427171940.GA18027@ericsson.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

Please pull hwmon fixes for Linux 3.4-rc5 from signed tag:

    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

Thanks,
Guenter

------

The following changes since commit 66f75a5d028beaf67c931435fdc3e7823125730c:

  Linux 3.4-rc4 (2012-04-21 14:47:52 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus

for you to fetch changes up to c3e40a9972428d6e2d8e287ed0233a57a218c30f:

  hwmon: (fam15h_power) Fix pci_device_id array (2012-04-26 08:40:08 -0700)

----------------------------------------------------------------
hwmon patches for 3.4-rc5

Fix build warning in ad7314 driver
Fix pci_device_id array access in fam15h_power driver, introduced by 00250ec

----------------------------------------------------------------
Guenter Roeck (2):
      hwmon: (ad7314) Fix build warning
      hwmon: (fam15h_power) Fix pci_device_id array

 drivers/hwmon/ad7314.c       |   12 +++++-------
 drivers/hwmon/fam15h_power.c |    9 ++++++---
 2 files changed, 11 insertions(+), 10 deletions(-)

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPmtUsAAoJEMsfJm/On5mBuoYQAJX/x2SaM80/DiNCmO3+pcXW
gb7woQnl6rtzr5ozmfQZ7jE2jOM4H80u+iJNrQfC3jrK0yRjPfhqk2sJqKgtBlsY
hns4NZH7DkkUAjT35HELMi7ZoWtPYmwZCpULWjbV8eQPtBFATdZDamcU1hxZUmvg
lkys1kYsXvsXjTcnNpoYp2eSFmforgkBw88RsRI0dlxnCR/lp/PkJEr542WxxSnH
NBXzyzKM0OqZ6L42nhrMzy6eTWW5WgG7No0Hf2HyEbM59QMTqjYl9HI8gmqMJjxi
byTHYlcKSXLeBflar0V5MhsusKq3BqYE5psR5C9+BmuCdz7pPsF2MqN6hMDCymiW
XEk9UItu/4PguMNcV6tvnS0MRDvt1olrARRILiXIMQSHiUMlT+cGakCeH3CG0ZBK
E6oZXnzK3Gu5mK8LAmsT/Fye/3Zphx3bfY6hUKuqx/G2UCyY+LFIc/AGbV8SEjZ0
PCbu5C0CwkXc6gID6OeTy1WUX01byUr4PrulmgPdeyEQsCnOYmim8/MQf/gPAfnl
zrO4lceuGmHk+jp05bJKh/liKvhhW7x1Nu+NZ6HFaBPankh6Q6Q9fnfpc9L7AGMF
k0feLef56emkqtS8pqHQtm6g8auN8X2pN3mTCnkWnKTFsIALEd/CEPIS0PG2FMEK
zfsLrYPu5Qsi29NO8kFM
=M4qn
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
