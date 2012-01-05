Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab2AEHMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 02:12:00 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10335 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763Ab2AEHL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 02:11:59 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 04 Jan 2012 23:11:56 -0800
From: Hiroshi DOYU <hdoyu@nvidia.com>
To: Hiroshi DOYU <hdoyu@nvidia.com>
Cc: iommu@lists.linux-foundation.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-mm-sig-bounces@lists.linaro.org
Subject: [PATCH v3 0/2] ARM: IOMMU: tegra: Add iommu_ops for GART/SMMU driver
Date: Thu,  5 Jan 2012 09:11:47 +0200
Message-Id: <1325747509-29665-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for IOMMU API for Tegra20(GART) and
Tegra30(SMMU). "struct iommu_ops" are implemented for both H/W IOMMU
modules.

Tested with "Ion memory manager" and "DMA mapping API"(*1).

This was originally developed with Tegra specific IOMMU
API(tegra_iovmm_*()) in:

git://nv-tegra.nvidia.com/linux-2.6.git.

v2:
https://lkml.org/lkml/2011/12/15/203

v1:
https://lkml.org/lkml/2011/11/17/111

*1: Reworking the DMA mapping code (especially on ARM)
    http://lwn.net/Articles/467509/

Hiroshi DOYU (2):
  ARM: IOMMU: Tegra20: Add iommu_ops for GART driver
  ARM: IOMMU: Tegra30: Add iommu_ops for SMMU driver

 arch/arm/mach-tegra/include/mach/smmu.h |   63 ++
 drivers/iommu/Kconfig                   |   22 +
 drivers/iommu/Makefile                  |    2 +
 drivers/iommu/tegra-gart.c              |  436 +++++++++++++
 drivers/iommu/tegra-smmu.c              | 1026 +++++++++++++++++++++++++++++++
 5 files changed, 1549 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-tegra/include/mach/smmu.h
 create mode 100644 drivers/iommu/tegra-gart.c
 create mode 100644 drivers/iommu/tegra-smmu.c

-- 
1.7.5.4

