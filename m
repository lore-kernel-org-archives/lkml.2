Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab2E3MjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 08:39:12 -0400
Received: from 8bytes.org ([85.214.48.195]:46352 "EHLO
	h2027444.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753268Ab2E3MjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 08:39:10 -0400
Date: Wed, 30 May 2012 14:39:06 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU updates for Linux 3.5
Message-ID: <20120530123906.GB3601@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vGgW1X5XWziG23Ko"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed May 30 14:39:07 2012
X-DSPAM-Confidence: 0.9988
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 4fc614eb28387260814110
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit 76e10d158efb6d4516018846f60c2ab5501900bc:

  Linux 3.4 (2012-05-20 15:29:13 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git tags/iommu-updates-v3.5

for you to fetch changes up to 28f8571e1e84782244cc7bf1b129baf6cdc0832e:

  Merge branches 'iommu/fixes', 'dma-debug', 'arm/omap', 'arm/tegra', 'core' and 'x86/amd' into next (2012-05-30 12:41:29 +0200)

----------------------------------------------------------------

IOMMU Updates for Linux 3.5

Not much stuff this time. The only change to the IOMMU core code is the
addition of a handle to the fault handling code. A few updates to the
AMD IOMMU driver to work around new errata. The other patches are mostly
fixes and enhancements to the existing ARM IOMMU drivers and
documentation updates.

A new IOMMU driver for the Exynos platform was also underway but got
merged via the Samsung tree and is not part of this tree.

----------------------------------------------------------------
Hiroshi DOYU (2):
      iommu/tegra: smmu: Print device name correctly
      iommu/tegra: gart: Fix register offset correctly

Jakub Kicinski (1):
      dma-debug: release free_entries_lock before saving stack trace

Joerg Roedel (3):
      iommu/amd: Check for the right TLP prefix bit
      iommu/amd: Add workaround for event log erratum
      Merge branches 'iommu/fixes', 'dma-debug', 'arm/omap', 'arm/tegra', 'core' and 'x86/amd' into next

Ohad Ben-Cohen (1):
      iommu/core: pass a user-provided token to fault handlers

Omar Ramirez Luna (1):
      iommu: OMAP: device detach on domain destroy

Shuah Khan (1):
      Documentation: kernel-parameters.txt Add amd_iommu_dump

Thierry Reding (1):
      iommu: tegra/gart: Add device tree support

Vandana Salve (1):
      iommu: tegra/gart: use correct gart_device

 .../bindings/iommu/nvidia,tegra20-gart.txt         |   14 ++++++++
 Documentation/kernel-parameters.txt                |    6 ++++
 drivers/iommu/amd_iommu.c                          |   37 ++++++++++++++------
 drivers/iommu/iommu.c                              |    5 ++-
 drivers/iommu/omap-iommu.c                         |   32 ++++++++++++-----
 drivers/iommu/tegra-gart.c                         |   20 ++++++++---
 drivers/iommu/tegra-smmu.c                         |    2 +-
 drivers/remoteproc/remoteproc_core.c               |    4 +--
 include/linux/iommu.h                              |   10 +++---
 lib/dma-debug.c                                    |   10 +++---
 10 files changed, 104 insertions(+), 36 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/iommu/nvidia,tegra20-gart.txt

Please pull.

Regards,

	Joerg


--vGgW1X5XWziG23Ko
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPxhTqAAoJECvwRC2XARrjawsP/0L04DUvIXobpMEFLBcYSoDu
Jt9mJWAs0jbQtoGTUtOuF5UI+fiNR9Vbt76C9aMPY8kYS4224RXVsAThSTf4/2VQ
FzkN99U5jrDg0V/Lc9f0qB0CCVAhJ58nrGoC5KIdNipYWtHVEp9DDYgbwd9gqh9f
RK5U40MkZL7iILMV9RLKhiHsokydMEAoaUALOBD8PBC+S3A25Nx0Hkg6Foy/Sg6D
GzuqYqycuPfC8RN9D9uxUk/XSuzDVaf9zxrPWv9eITmshW+VqkMW/0ZEuo3uP0yA
9X99eaSklI0sltuoaErG2JcgMlJE1Ihtz06hOSnFCpVB+TqS+og/jnwXzNIZ84WA
tDj7aJvpldz8mTSKeOq8OMsQ2OwdJEsnjZsaOUim0eWGCI3q53/M9QXfaGX8tHKT
LrUotdOdVvQaqB/BGY3bdaY3LocAP4fKDZ42bw7gbZxq8+/bbhU+arqven8LHzc1
EQ53cE2uFYMbhrIC3sVmitOQp77wwg1Ssw18cf/wj94xTlwi1+BwYUMrq0Evf2+r
KKmhm0JgYWid0cm1QL6iPs2dp+9SG0tOJJSbuGcMhz5nuSuW9dzl09kSJhpW44c6
EnbEPxjIj/VoINlcqTQVfgS5sQKZvLUEH5xvB9WGS3TL5mS0NP0Exf0RM2gErEjO
dtaveyjm/O1QgakaoZ5D
=Hhie
-----END PGP SIGNATURE-----

--vGgW1X5XWziG23Ko--


