Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab2GRGah (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 02:30:37 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18730 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab2GRGaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 02:30:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 17 Jul 2012 23:30:17 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <grant.likely@secretlab.ca>, <linus.walleij@stericsson.com>,
        <sameo@linux.intel.com>, <swarren@nvidia.com>,
        <broonie@opensource.wolfsonmicro.com>
CC: <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 5/6] ARM: tegra: defconfig: enable tps6586x gpio
Date: Wed, 18 Jul 2012 11:50:49 +0530
Message-ID: <1342592450-12488-6-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1342592450-12488-1-git-send-email-ldewangan@nvidia.com>
References: <1342592450-12488-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable GPIO_TPS6586X as the gpio functionality of
this device moved as platform driver.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes V1 -> V2: 
New change in V2 series. To avoid bisect, added change in defconfig.

Changes V2->V3:
No Change, just recreated part of series.

 arch/arm/configs/tegra_defconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index 4be9c1e..5ae3889 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -105,6 +105,7 @@ CONFIG_I2C_MUX_PINCTRL=y
 CONFIG_I2C_TEGRA=y
 CONFIG_SPI=y
 CONFIG_SPI_TEGRA=y
+CONFIG_GPIO_TPS6586X=y
 CONFIG_GPIO_TPS65910=y
 CONFIG_POWER_SUPPLY=y
 CONFIG_BATTERY_SBS=y
-- 
1.7.1.1

