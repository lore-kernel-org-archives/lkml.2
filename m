Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713Ab1KQLBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 06:01:30 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8990 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756494Ab1KQLB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 06:01:28 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 17 Nov 2011 03:01:27 -0800
From: hdoyu@nvidia.com
To: Hiroshi DOYU <hdoyu@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Hiroshi DOYU <hdoyu@nvidia.com>
Subject: [PATCH 0/3] ARM: iommu: tegra: Add initial Tegra IOMMU driver
Date: Thu, 17 Nov 2011 13:01:04 +0200
Message-Id: <1321527667-12923-1-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi DOYU <hdoyu@nvidia.com>

Hi,

This patchset adds support for Tegra IOMMU driver for Tegra2/3.

Presently this driver is specific to Tegra platform, but some of
functionalities could be replaced with a generic IOMMU framework. This
is expected to ease finding similarities with different platforms,
with the intention of solving problems once in a generic framework
which everyone can use.

Originally this was developed under git://nv-tegra.nvidia.com/linux-2.6.git,
and they are cleaned up for upstreaming.

Hiroshi DOYU (3):
  ARM: iommu: tegra/common: Initial support for IOVMM driver
  ARM: iommu: tegra2: Initial support for GART driver
  ARM: iommu: tegra3: Initial support for SMMU driver

 arch/arm/mach-tegra/include/mach/iovmm.h |  283 +++++++
 drivers/iommu/Kconfig                    |   34 +
 drivers/iommu/Makefile                   |    3 +
 drivers/iommu/tegra-gart.c               |  357 ++++++++
 drivers/iommu/tegra-iovmm.c              |  936 ++++++++++++++++++++
 drivers/iommu/tegra-smmu.c               | 1358 ++++++++++++++++++++++++++++++
 6 files changed, 2971 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-tegra/include/mach/iovmm.h
 create mode 100644 drivers/iommu/tegra-gart.c
 create mode 100644 drivers/iommu/tegra-iovmm.c
 create mode 100644 drivers/iommu/tegra-smmu.c

