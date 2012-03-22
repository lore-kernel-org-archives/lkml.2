Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391Ab2CVTXm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 15:23:42 -0400
Received: from 8bytes.org ([88.198.83.132]:34573 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751714Ab2CVTXl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 15:23:41 -0400
Date: Thu, 22 Mar 2012 20:23:36 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [git pull] IOMMU updates for Linux 3.4
Message-ID: <20120322192334.GA2919@8bytes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Linus,

The following changes since commit c16fa4f2ad19908a47c63d8fa436a1178438c7e7:

  Linux 3.3 (2012-03-18 16:15:34 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git next

or as a signed tag at:
  git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git iommu-updates-v3.4

Gerard Snitselaar (1):
      iommu/amd: Fix section mismatch

Hiroshi DOYU (2):
      ARM: IOMMU: Tegra20: Add iommu_ops for GART driver
      ARM: IOMMU: Tegra30: Add iommu_ops for SMMU driver

Joerg Roedel (7):
      iommu/amd: Split amd_iommu_init function
      iommu/amd: Fix double free of mem-region in error-path
      iommu/amd: Update git-tree in MAINTAINERS
      iommu/amd: Don't initialize IOMMUv2 resources when not required
      iommu/amd: Make sure IOMMU interrupts are re-enabled on resume
      iommu/amd: Move interrupt setup code into seperate function
      Merge branches 'iommu/fixes', 'arm/tegra' and 'x86/amd' into next

Lucas Stach (1):
      iommu/tegra-gart: fix spin_unlock in map failure path

Steffen Persvold (1):
      iommu/amd: Fix section warning for prealloc_protection_domains

 MAINTAINERS                             |    2 +-
 arch/arm/mach-tegra/include/mach/smmu.h |   63 ++
 drivers/iommu/Kconfig                   |   20 +
 drivers/iommu/Makefile                  |    2 +
 drivers/iommu/amd_iommu.c               |    2 +-
 drivers/iommu/amd_iommu_init.c          |  187 ++++--
 drivers/iommu/amd_iommu_v2.c            |   14 +-
 drivers/iommu/tegra-gart.c              |  451 ++++++++++++++
 drivers/iommu/tegra-smmu.c              | 1034 +++++++++++++++++++++++++++++++
 include/linux/amd-iommu.h               |    2 +-
 10 files changed, 1709 insertions(+), 68 deletions(-)
 create mode 100644 arch/arm/mach-tegra/include/mach/smmu.h
 create mode 100644 drivers/iommu/tegra-gart.c
 create mode 100644 drivers/iommu/tegra-smmu.c

The IOMMU updates for this round are not very large patch-wise. But
they contain two new IOMMU drivers for the ARM Tegra 2 and 3 platforms.
Besides that there are also a few patches for the AMD IOMMU which
prepare the driver for adding intr-remapping support and a couple of
fixes.

The top-commit of the next branch on my local machine is

	7de473066f1512e52ea806e3c9698e5ea325b26c

Please pull.

Thanks,

	Joerg


--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPa3w2AAoJECvwRC2XARrjO/YP/2+eGJ0/HmfyVXH9dsY5FHOV
mjy25Edkw+4dWghx3j8fB3TtHKIraayJBSFr6MvB5RwAMldneyreE5WbqzZi8W4e
3wsjOcW/jvIhBs/QzaqE+5LAE8S57Ktj/reF/EWcreZK9kNf2N8Dc3fmdVaJDtK/
XcAODhzHiBYUCsYcYC7G4RHr4zHe8on97uRbNvLx1JZ9ZkOQXecYd0A0JdZKyyZt
hwANgn2qojCA3ikBu9WYoLRE3X56/CBASGe0QeeuBfg66akItBW06epiEtToOSf5
7y2ANivHe4KHrwquxzEvjes2K4CtiOtynxJTZKwhqsaOfGQaTZA+bOkFdcEVOBhq
JwMqpSDxblHzyFJPCIjF7SWRwRNrFjFliq5JEUdvZQth8lnGVQbI8GzJXRtQFM9s
saIyqZ7D8pbQ2U2sf9Pi1i1shDuDo1uzWRmBFWoGkeh7ujaMR+3wUKNhjgONXDgs
fHqt2AbEU627sxhGdzHGcxorJ2mAjf1AspwFpX3z4CKmvems6BsrP2XdURQiSvIH
Fli1MBzdNlrXg4Y10wn3zcmsUVMhvxiHgX18Gs9y3kS7hQdPQd+XYCZSr+4Oxhul
95lwWG108bSqFNu8rwVtjaYHm4StHAl9PmMw+qf0ykeMcry+l5DIouMYIHAH0++3
6YqOlRTlEoP2MXnnX2h2
=Wetq
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
