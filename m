Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760274Ab2J2RVz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 13:21:55 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11445 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757386Ab2J2RVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 13:21:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 29 Oct 2012 10:21:41 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>
CC: <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 0/4] ARM: tegra: Enable SLINK controller driver
Date: Mon, 29 Oct 2012 22:49:36 +0530
Message-ID: <1351531180-1652-1-git-send-email-ldewangan@nvidia.com>
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

Laxman Dewangan (4):
  ARM: tegra: dts: add slink controller dt entry
  ARM: tegra: Add OF_DEV_AUXDATA for SLINK driver in board dt
  ARM: tegra: dts: cardhu: enable SLINK4
  ARM: tegra: config: enable spi driver for Tegra SLINK controller

 arch/arm/boot/dts/tegra20.dtsi           |   40 ++++++++++++++++++++
 arch/arm/boot/dts/tegra30-cardhu.dtsi    |    5 ++
 arch/arm/boot/dts/tegra30.dtsi           |   60 ++++++++++++++++++++++++++++++
 arch/arm/configs/tegra_defconfig         |    2 +-
 arch/arm/mach-tegra/board-dt-tegra20.c   |    8 ++++
 arch/arm/mach-tegra/board-dt-tegra30.c   |   12 ++++++
 arch/arm/mach-tegra/include/mach/iomap.h |   22 +++++++----
 7 files changed, 140 insertions(+), 9 deletions(-)

