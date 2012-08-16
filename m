Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932573Ab2HPObc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 10:31:32 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17215 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab2HPOb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 10:31:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 16 Aug 2012 07:31:09 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <olof@lixom.net>, <grant.likely@secretlab.ca>,
        <lrg@ti.com>, <broonie@opensource.wolfsonmicro.com>
CC: <vinod.koul@linux.intel.com>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <spi-devel-general@lists.sourceforge.net>,
        <alsa-devel@alsa-project.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/5] ARM: tegra: config: enable dmaengine based APB DMA driver
Date: Thu, 16 Aug 2012 19:43:13 +0530
Message-ID: <1345126397-28864-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1345126397-28864-1-git-send-email-ldewangan@nvidia.com>
References: <1345126397-28864-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable config for dmaengine based Tegra APB DMA driver and
disable the legacy APB DMA driver (SYSTEM_DMA).

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/configs/tegra_defconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index 4f078e0..40f7a87 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -29,6 +29,7 @@ CONFIG_ARCH_TEGRA_2x_SOC=y
 CONFIG_ARCH_TEGRA_3x_SOC=y
 CONFIG_TEGRA_PCI=y
 CONFIG_TEGRA_DEBUG_UART_AUTO_ODMDATA=y
+# CONFIG_TEGRA_SYSTEM_DMA is not set
 CONFIG_TEGRA_EMC_SCALING_ENABLE=y
 CONFIG_SMP=y
 CONFIG_PREEMPT=y
@@ -148,6 +149,8 @@ CONFIG_RTC_CLASS=y
 CONFIG_RTC_DRV_MAX8907=y
 CONFIG_RTC_DRV_EM3027=y
 CONFIG_RTC_DRV_TEGRA=y
+CONFIG_DMADEVICES=y
+CONFIG_TEGRA20_APB_DMA=y
 CONFIG_STAGING=y
 CONFIG_SENSORS_ISL29018=y
 CONFIG_SENSORS_ISL29028=y
-- 
1.7.1.1

