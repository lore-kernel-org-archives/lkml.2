Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab2GFNRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 09:17:48 -0400
Received: from 8bytes.org ([85.214.48.195]:38096 "EHLO
	h2027444.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173Ab2GFNRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 09:17:47 -0400
Date: Fri, 6 Jul 2012 15:17:43 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU fixes for Linux 3.5-rc5
Message-ID: <20120706131743.GA2364@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Jul  6 15:17:44 2012
X-DSPAM-Confidence: 0.9990
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4ff6e57820426257015805
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit eee53537c476c947bf7faa1c916d2f5a0ae8ec93:

  iommu/amd: Fix deadlock in ppr-handling error path (2012-06-04 12:47:44 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/iommu-fixes-v3.5-rc5

for you to fetch changes up to 3775d4818d72081e2afa2aed2442a2b9ecfc5eab:

  iommu/amd: fix type bug in flush code (2012-07-02 12:11:40 +0200)

----------------------------------------------------------------
IOMMU fixes for Linux v3.5-rc5

The patches fix several issues in the AMD IOMMU driver, the NVidia SMMU
driver, and the DMA debug code. The most important fix for the AMD IOMMU
solves a problem with SR-IOV devices where virtual functions did not
work with IOMMU enabled. The NVidia SMMU patch fixes a possible sleep
while spin-lock situation (queued the small fix for v3.5, a better but
more intrusive fix is coming for v3.6). The DMA debug patches fix a
possible data corruption issue due to bool vs. u32 usage.

----------------------------------------------------------------
Dan Carpenter (2):
      dma-debug: debugfs_create_bool() takes a u32 pointer
      iommu/amd: fix type bug in flush code

Hiroshi DOYU (1):
      iommu/tegra: smmu: Fix unsleepable memory allocation

Joerg Roedel (1):
      iommu/amd: Initialize dma_ops for hotplug and sriov devices

Shuah Khan (1):
      iommu/amd: Fix missing iommu_shutdown initialization in passthrough mode

 drivers/iommu/amd_iommu.c       |   11 ++++++++++-
 drivers/iommu/amd_iommu_init.c  |    6 +++---
 drivers/iommu/amd_iommu_types.h |    2 +-
 drivers/iommu/tegra-smmu.c      |    4 ++--
 lib/dma-debug.c                 |    4 ++--
 5 files changed, 18 insertions(+), 9 deletions(-)

Please pull.

Regards,

	Joerg


--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJP9uV3AAoJECvwRC2XARrjPk8QAMFosqWmN4ZdqD6BJ7csCkVA
tHIeO2fK43JeOIgTzgPFMnvRdEv4kM8I9CkQNWffTNbentD0YTm5WFobFrXbdTOO
UiBw9ZKxxyQToYKSdAh/xwVoY+wxG2WFwbIV45NYoI52+8alYr9Nt3vjfRYqge3B
lVjhsYr9li3jC0K/a49kcSLi59JUcBwLcsiL78TzaYbLSRm3wXdkDzN5EhCMeZao
TMD/SX2p29v3jgcWqH9aNg1sum2OOuQvZre3Dxek0WwqMsBPJJHIcfsjRjAlMwYR
+DOznne6pbZf+yXrWN+BZmOvYRToy4UbYxBppPlk7QhE8cy7gMHkU4Xo8EMhb0Qy
00thyC5UcXvPJG41wWDmbP/N3mvOg2pLQTC3QV3G9CS8mKekEvQ4Wb8vdaHhsQbp
dvT7gXUfF++HWoC/hSdlxO0wKAiqj8vU1LpJALnqEBsXIRlEKDQENgaE2rNlr5lI
xXbjK1R2pR0saF1OavgoKB/uVNpgmMPBdtcrRK5UGKAaPbgrogkzcfmELQIMppF/
mMTQSX2WMumoK3ViQFNMi+thrEY1Da4cTC1IrrzaTmtdKDjbD/vNjs+rf8WiN//P
UAwOMKnR0WhdWrA83fQCMuMhFfH3xeQxVUoe6QQBytXIqIwXmVysg/M/Pz0OF6v+
UcSY5l7bbOoCfiEO1Oj6
=Q5ji
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--


