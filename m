Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab2EGQwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 12:52:31 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:22962 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756911Ab2EGQwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 12:52:30 -0400
Date: Mon, 7 May 2012 12:46:39 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] (xen) stable/for-linus-3.4-rc6-tag
Message-ID: <20120507164639.GA3155@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Linus,

Please pull this last (I hope) pull for this release from me:

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-lin=
us-3.4-rc6-tag

which has a sm=F6rg=E5sbord of fixes - fix to Kconfig to make it fit within
80 line characters, two bootup fixes, cleanup code in a driver, and a crash
when trying to `cat /sys/kernel/debug/kernel_page_tables`. This
release we have been focused on fixing bugs - and it feels good
to have the outstanding bug list shrink. Please pull!


 arch/x86/xen/enlighten.c    |   42 +++++++++++++++++++++++++++++++++++++++=
---
 arch/x86/xen/mmu.c          |    7 ++++++-
 drivers/video/xen-fbfront.c |   27 ++++++++++++++++-----------
 drivers/xen/Kconfig         |   22 ++++++++++++----------
 4 files changed, 73 insertions(+), 25 deletions(-)

Andrew Morton (1):
      xen/Kconfig: fix Kconfig layout

David Vrabel (1):
      xen/pci: don't use PCI BIOS service for configuration space accesses

Julia Lawall (1):
      drivers/video/xen-fbfront.c: add missing cleanup code

Konrad Rzeszutek Wilk (2):
      xen/apic: Return the APIC ID (and version) for CPU 0.
      xen/pte: Fix crashes when trying to see non-existent PGD/PMD/PUD/PTEs


--wac7ysb48OaltWcw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJPp/xgAAoJEFjIrFwIi8fJsl0H/jvmBwuNwlJyfcBLLitSSKUv
I1qMYO0B925YYFQV7bL8SfSM918cPwO2NsqOu/QMw5Dw3IUgtu5eCT8adxRtzdsG
nSklt5bIuI3cJbxwkTyriD9OwnG+dHHnvncuC85U6hTvS24ECCOlDDN/7Va4waNF
Gx+AHGTBfoZOvNcp0/zvZ5OsKKQujxyZoSha/IYWim61SJJLgFMZ4c2ROE9bvVkJ
bmnw3e8lBbF6RaoEIu8wvlPCLs2iGKLHleqNndb1ksJomK2uLCXVYXydk1UDQZw8
atFK19RGuusv/Z+cr/BjR6chy+dmmkK1jPC3fIaCZdweFeNP07xDo+ZOFUnjKKw=
=eL90
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
