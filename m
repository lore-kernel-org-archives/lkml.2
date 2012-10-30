Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669Ab2J3HHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 03:07:51 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:6502 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab2J3HHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 03:07:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 29 Oct 2012 23:54:29 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>
CC: <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 0/4] ARM: tegra: Enable SLINK controller driver
Date: Tue, 30 Oct 2012 12:35:22 +0530
Message-ID: <1351580726-17350-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series modify the dts file to add the slink addresses,
make AUXDATA in board dt files, enable slink4 for tegra30-cardhu and 
enable slink controller defconfig.

Changes from V1: 
- Remove changes from clock tables.
- Make the dma req dt property name to nvidia,dma-request-selector.
- change the spi max frequency prop to spi-max-frequency.

Changes from V2:
- make node name to spi.
- get rid of iomap.h.

Laxman Dewangan (4):
  ARM: tegra: dts: add slink controller dt entry
  ARM: tegra: Add OF_DEV_AUXDATA for SLINK driver in board dt
  ARM: tegra: dts: cardhu: enable SLINK4
  ARM: tegra: config: enable spi driver for Tegra SLINK controller

 arch/arm/boot/dts/tegra20.dtsi         |   41 ++++++++++++++++++++++
 arch/arm/boot/dts/tegra30-cardhu.dtsi  |    5 +++
 arch/arm/boot/dts/tegra30.dtsi         |   60 ++++++++++++++++++++++++++++++++
 arch/arm/configs/tegra_defconfig       |    2 +-
 arch/arm/mach-tegra/board-dt-tegra20.c |    8 ++++
 arch/arm/mach-tegra/board-dt-tegra30.c |   12 ++++++
 6 files changed, 127 insertions(+), 1 deletions(-)

