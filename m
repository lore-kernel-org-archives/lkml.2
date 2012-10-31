Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935241Ab2JaJFB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:05:01 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11321 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935214Ab2JaJE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:04:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 31 Oct 2012 02:04:52 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>
CC: <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V4 0/4] ARM: tegra: Enable SLINK controller driver
Date: Wed, 31 Oct 2012 14:32:56 +0530
Message-ID: <1351674176-20603-5-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1351674176-20603-1-git-send-email-ldewangan@nvidia.com>
References: <1351674176-20603-1-git-send-email-ldewangan@nvidia.com>
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

Changes from V3:
- Enable spi flash connected on slink4-cs1.
- Enable require defconfigs.

Laxman Dewangan (4):
  ARM: tegra: dts: add slink controller dt entry
  ARM: tegra: Add OF_DEV_AUXDATA for SLINK driver in board dt
  ARM: tegra: dts: cardhu: enable SLINK4
  ARM: tegra: config: enable spi driver for Tegra SLINK controller

 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 arch/arm/boot/dts/tegra20.dtsi                     |   41 +++++++++++++
 arch/arm/boot/dts/tegra30-cardhu.dtsi              |   10 +++
 arch/arm/boot/dts/tegra30.dtsi                     |   60 ++++++++++++++++++++
 arch/arm/configs/tegra_defconfig                   |    5 +-
 arch/arm/mach-tegra/board-dt-tegra20.c             |    8 +++
 arch/arm/mach-tegra/board-dt-tegra30.c             |   12 ++++
 7 files changed, 136 insertions(+), 1 deletions(-)

