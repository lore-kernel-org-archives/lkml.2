Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab2BQRY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 12:24:59 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:36449 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753471Ab2BQRY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 12:24:58 -0500
Date: Fri, 17 Feb 2012 09:24:50 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [git pull] PCI fixes
Message-ID: <20120217092450.340e2ac5@jbarnes-desktop>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/BGcF8AH.wyxInd9ddqM0HNz"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/BGcF8AH.wyxInd9ddqM0HNz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

The following changes since commit
acb42a3b611d7ad4cb173c3b37674b549df2ffeb:

  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux (=
2012-01-27 07:56:25 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci for-linus

One regression fix for SR-IOV on PPC and a couple of misc fixes from
Yinghai.

Vaidyanathan Srinivasan (1):
      PCI: set pci sriov page size before reading SRIOV BAR

Yinghai Lu (2):
      PCI: workaround hard-wired bus number V2
      PCI: Fix pci cardbus removal

 drivers/pci/iov.c    |    3 +--
 drivers/pci/probe.c  |    5 +++++
 drivers/pci/remove.c |   28 ++++++++++++++++++++++------
 3 files changed, 28 insertions(+), 8 deletions(-)


--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/BGcF8AH.wyxInd9ddqM0HNz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPPo1iAAoJEIEoDkX4Qk9hAzsQAJKBxUq9Ea17/JA1cvFQWSnr
mVqrH2diLAwVyB1Gzh0qWxgUCCQNEYspSlAN7ysqf3RCFyDvw2umm5RSsTT/GNku
UNovSra8nSxgfnJgD1M7jkjoi84hPhpWCY4vkxIHkFVFAGg+xZOibj62WY8SrFt4
rbsu5zvggAMBp8pmnDD8uVN4hjMaVl8fV1wCYbpeXITAPYHb56GGKW39GkDUbbyd
+FqYvUIAtmqSfeCZpEaTQg2b4jH3D4dXEmXJ54Siokp/BEyLqEyUsiU/RXynaDNv
fGZ+ic56QyDEJPneQgkTNRwp+rnX0st3h4DR2HtHKbEudiVKwtyk7/zETZyGTPci
+X78pYTmD+WVPQLmN+hQtPGYIqfbsYAeeGzMMecMLdifYctc1rJL2kwNqwzuwXdr
UOB4NgXocxDuJDCWan+Z67V4TZ6rFI1w7jAA7KOS4g60Su9lPjW1X6r6ViFTqPaN
PZ8a4FsY75J/r3kcdWuiGGyos6p08p8rue9TwtZylrlJ5W4kXegyDpLCBRttX8XH
DkNowYssk9CoFAa8z2cBeaiUHP7jki8yHcBdogISCxPmYvFcXybOD6GNBfvkL0pW
DLbWasRQUcpeNkJJ/dshk4/gpi/MJUz2eiYcCmKffdNO5Z8Jr7hz43CZ0h5ATLCh
iDX96RhzWzZnVWCawP2f
=s6wp
-----END PGP SIGNATURE-----

--Sig_/BGcF8AH.wyxInd9ddqM0HNz--
