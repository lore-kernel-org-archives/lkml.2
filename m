Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822Ab2CAP3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 10:29:01 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44083 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755512Ab2CAP3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 10:29:00 -0500
Date: Thu, 1 Mar 2012 15:28:58 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: [GIT PULL] Regulator fix for 3.3
Message-ID: <20120301152857.GA10915@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
X-Cookie: Are you sure the back door is locked?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit b01543dfe67bb1d191998e90d20534dc354de059:

  Linux 3.3-rc4 (2012-02-18 15:53:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git tags/for-linus

for you to fetch changes up to 3380643b0eaa7ecf99c4f095bdfcb6e5df471616:

  regulator: fix the ldo configure according to 88pm860x spec (2012-02-24 14:56:32 +0000)

----------------------------------------------------------------
A simple, driver specific fix.  This device isn't widely used outside of
Marvell reference boards most of which are probably used with their BSPs
rather than with mainline so low risk.
----------------------------------------------------------------

Jett.Zhou (1):
      regulator: fix the ldo configure according to 88pm860x spec

 drivers/regulator/88pm8607.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPT5WuAAoJEBus8iNuMP3dvlYP/AoxeGztxvdxV5WDcf1L2nUN
Mn87VSJUcojx+aJWnHfceydPY72IhYCh0t9PkPFvRoZwBr3YW2xBII10BD+2hbAQ
IhT8Rng1sdLAJ5FPLaBduH8rdoibg+kuUgD1xYGhHGKrPeFq9e21r+mUNz2flM28
OVUlyH0k3aMoN6OG5im1eoWGImeOIk2YHB7NYdf5c4e2jMCdn8I/MWCALwI3TZMh
KtYu2fccb1Ne2ZtZ94X4FtxTe7FmlL97dhGwIv0kRDaDG/A70TlVwGNm1Q803Tty
1GCss6+dVqGwpZjF/AkAnkcA/xZbYp6jy2fUJdb9aN5qvBI3naWBbY6HiQNHrSiA
mTpgPdmII+KV01eEl8OT9DURIntxsdDD4svX4yXekdaJi5nuDYvT90FIuEnn+6Vv
QR2f+xgP7fDhF6a4uRA0ZGpOlb62p+ayuST29jfKHE6d82im07gaNXgX0OzIF6ES
7k5P+T2l1tOU3SQzxDqMDpfL+BXwtCChOtpzvgMqNLqjgT9NMV7asrdk+Lj01faP
aPxu2WN6ZfJW5PPwa0BBjzj+qnxMe3LPfhL7VOknIdfwhR8uUjP5N3NYq8S80hhL
/uliunvuaTB73o9mInyEt8SHioTplt1acIf96TA0RiPUO/zufGvsf414jduWx8Qk
DGUg0uteF06j6q+oB2CI
=pHin
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
