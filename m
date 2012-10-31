Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935250Ab2JaJFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 05:05:33 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11312 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161066Ab2JaJEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 05:04:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 31 Oct 2012 02:04:49 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>
CC: <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V4 4/4] ARM: tegra: config: enable spi driver for Tegra SLINK controller
Date: Wed, 31 Oct 2012 14:32:55 +0530
Message-ID: <1351674176-20603-4-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1351674176-20603-1-git-send-email-ldewangan@nvidia.com>
References: <1351674176-20603-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also enable the MTD, MTD_M25P80 and MTD_CHAR driver to enable
SPI flash.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
No change from V1 and V2.

Changes from V2:
- enable MTD, MTD_M25P80 and MTD_CHAR drivers.

 arch/arm/configs/tegra_defconfig |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index fb29680..9dac09b 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -80,6 +80,9 @@ CONFIG_RFKILL_GPIO=y
 CONFIG_DEVTMPFS=y
 CONFIG_DEVTMPFS_MOUNT=y
 # CONFIG_FIRMWARE_IN_KERNEL is not set
+CONFIG_MTD=y
+CONFIG_MTD_CHAR=y
+CONFIG_MTD_M25P80=y
 CONFIG_PROC_DEVICETREE=y
 CONFIG_BLK_DEV_LOOP=y
 CONFIG_AD525X_DPOT=y
@@ -117,7 +120,7 @@ CONFIG_I2C_MUX=y
 CONFIG_I2C_MUX_PINCTRL=y
 CONFIG_I2C_TEGRA=y
 CONFIG_SPI=y
-CONFIG_SPI_TEGRA=y
+CONFIG_SPI_TEGRA20_SLINK=y
 CONFIG_GPIO_PCA953X_IRQ=y
 CONFIG_GPIO_TPS6586X=y
 CONFIG_GPIO_TPS65910=y
-- 
1.7.1.1

