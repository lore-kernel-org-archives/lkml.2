Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791Ab2HVIHl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:07:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57687 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758778Ab2HVIHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:07:20 -0400
Date: Wed, 22 Aug 2012 10:07:11 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] pwm: fixes for v3.6-rc3
Message-ID: <20120822080711.GA5706@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:VtLBuL/x6pfyvt7CWPAeaEevYJM36/BPsxQ6LU3t8zT
 ngf04Enu6QOxbtMOtABvpjpGNjbN1ax4bvSkDFSMMXSkJdQgyw
 fvYq2tAkRw3SUoyAHbnYRFEnlqWquQKGWa5q8sGVmqPP0/Pucw
 /F505+lI87LYe+j9g+cwETMp6JnuzIXK8nP4ZmOv5H7PbZ5r+O
 AJ1+aDzKQbgpRF/GZRwrAMyofWXINy4UpD9WQTQqKhQz+wFq2e
 +r2Dq3KOYmBAjLV9ahqOC6LHUMitRAWuNCZQV3uBBNXsjgHrlK
 SxoSpSe5tb+prT1xoAUvhWWAYerYqPcrzWy6iIFzeoCaoPs5RC
 6v1q43UOwtqGM9h2vhiXMQPB9ax2m7fcS4xMxpz+f507RI7ec5
 Qc5+eswK8iCiPve1oycxbVTQf2njCXnpVw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit d9875690d9b89a866022ff49e3fcea892345ad92:

  Linux 3.6-rc2 (2012-08-16 14:51:24 -0700)

are available in the git repository at:

  git://gitorious.org/linux-pwm/linux-pwm.git tags/for-3.6-rc3

for you to fetch changes up to b817bf5c72774556345a9043c6b0c497cdcb7295:

  pwm: Improve Kconfig help text (2012-08-20 11:58:43 +0200)

----------------------------------------------------------------
pwm: fixes for v3.6-rc3

These patches fix the Samsung PWM driver and perform some minor cleanups
like fixing checkpatch and sparse warnings. Two redundant error messages
are removed and the Kconfig help text for the PWM subsystem is made more
descriptive.

----------------------------------------------------------------
Axel Lin (1):
      pwm: Remove a redundant error message when devm_request_and_ioremap fails

Jingoo Han (1):
      pwm: samsung: add missing device pointer to struct pwm_chip

Sachin Kamat (3):
      pwm: Add missing static storage class specifiers in core.c file
      pwm: vt8500: Fix coding style issue
      pwm: core: Fix coding style issues

Thierry Reding (1):
      pwm: Improve Kconfig help text

 drivers/pwm/Kconfig        | 31 +++++++++++++++++++++++++------
 drivers/pwm/core.c         | 12 ++++++------
 drivers/pwm/pwm-samsung.c  |  1 +
 drivers/pwm/pwm-tegra.c    |  4 +---
 drivers/pwm/pwm-tiecap.c   |  4 +---
 drivers/pwm/pwm-tiehrpwm.c |  4 +---
 drivers/pwm/pwm-vt8500.c   |  2 +-
 7 files changed, 36 insertions(+), 22 deletions(-)

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQNJMvAAoJEN0jrNd/PrOhAOAQALm4XOMpbZX4Sn6Hopx73QgJ
TDnnXzcDWUvypPUX5/eyGNtEexGXiH+TLnvwb1oOHbDOuYEqu9TBI459Rxj2ejWq
FkFyUJzuNvvYbCVW+0JWj8ooK0O6YdTwTty+IJ5xl2J1FSaTUHJw6AxB+2A/mMPC
LaD+EOKihQPb6v0VSudqmeFql3KQ7Zti30GwAht6t0lIb5frA5fGdD0n/XDQX5Wv
dOApEQSmtTI6lmRy1f989xZGZH3kZkFzDNuGwFS7J6CYbAeUgRJFTc5j/CZRA++o
ggJQOoCg9s8WjwPklmJTAvH/wJ0MBtJPcNg2siDQJiqnIcTPHZN1IgLcQt9eDpla
YEYve42lp64PwcV2tBFN2TGntRiFdTwY/6kDbgfxgvrkZX5TNrf+nFvOqZsuRrsi
RuImm4ur5hZHaNZfF/1c7MzCsNAHHltcw6q+DNwvkvD9be+dWUuiKo9tU8l113ls
P/PWZDOTZCNer32ymKEYp34IFFXeVB7QjJ/UOAcocvLFpQUlUxIs92iXHA/VxzCJ
Ez/YRvdMshxTwvjq1IFer7m2YF9Wh64G1yfxmpOcgak4sbQo03J/AlIrV4jmfgEa
AdurtASs16R28r5so8cJVZdVd6Ml25LR1OzyUJPJqZ3p9pWE6aisQj+Wl2dyorun
OkprQTZfujNSrsZ8T6GY
=MAzA
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
