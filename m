Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933574Ab2EWGTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:19:45 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5463 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab2EWGTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:19:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 22 May 2012 23:18:45 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@nvidia.com>, <olof@lixom.net>
CC: <linux-kernel@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-tegra@vger.kernel.org>,
        <broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 1/2] ARM: tegra: config: enable TPS65910 drivers
Date: Wed, 23 May 2012 11:42:53 +0530
Message-ID: <1337753574-32699-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable TPS65910 mfd, gpio and regulator drivers.
This is the PMIC module for Tegra30 based cardhu
platform.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
No change from V1.

 arch/arm/configs/tegra_defconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index 1198dd6..26ad2b4 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -106,16 +106,19 @@ CONFIG_I2C=y
 CONFIG_I2C_TEGRA=y
 CONFIG_SPI=y
 CONFIG_SPI_TEGRA=y
+CONFIG_GPIO_TPS65910=y
 CONFIG_POWER_SUPPLY=y
 CONFIG_BATTERY_SBS=y
 CONFIG_SENSORS_LM90=y
 CONFIG_MFD_TPS6586X=y
+CONFIG_MFD_TPS65910=y
 CONFIG_REGULATOR=y
 CONFIG_REGULATOR_FIXED_VOLTAGE=y
 CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
 CONFIG_REGULATOR_GPIO=y
 CONFIG_REGULATOR_TPS62360=y
 CONFIG_REGULATOR_TPS6586X=y
+CONFIG_REGULATOR_TPS65910=y
 CONFIG_SOUND=y
 CONFIG_SND=y
 # CONFIG_SND_SUPPORT_OLD_API is not set
-- 
1.7.1.1

