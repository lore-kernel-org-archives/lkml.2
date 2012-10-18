Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab2JRK5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:57:45 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19606 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932321Ab2JRK5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:57:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 18 Oct 2012 03:45:54 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>
CC: <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 0/5] ARM: tegra: Enable SLINK controller driver
Date: Thu, 18 Oct 2012 16:26:30 +0530
Message-ID: <1350557795-31487-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series modify the dts file to add the slink addresses,
make entry of slink in clock tables, defines SLINK addressed,
enable slink controller in Tegra30 based platform cardhu.

Laxman Dewangan (5):
  ARM: tegra: Add slink controller base address
  ARM: tegra: dts: add slink controller dt entry
  ARM: tegra: fix clock entry of slink controller
  ARM: tegra: dts: cardhu: enable SLINK4
  ARM: tegra: config: enable spi driver for Tegra SLINK controller

 arch/arm/boot/dts/tegra20.dtsi            |   40 +++++++++++++++++++
 arch/arm/boot/dts/tegra30-cardhu.dtsi     |    5 ++
 arch/arm/boot/dts/tegra30.dtsi            |   60 +++++++++++++++++++++++++++++
 arch/arm/configs/tegra_defconfig          |    2 +-
 arch/arm/mach-tegra/board-dt-tegra20.c    |    8 ++++
 arch/arm/mach-tegra/board-dt-tegra30.c    |   12 ++++++
 arch/arm/mach-tegra/include/mach/iomap.h  |   22 +++++++----
 arch/arm/mach-tegra/tegra20_clocks_data.c |   16 ++++----
 arch/arm/mach-tegra/tegra30_clocks_data.c |   36 +++++++++---------
 9 files changed, 166 insertions(+), 35 deletions(-)

