Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab2LVUxY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 15:53:24 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19880 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab2LVUxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 15:53:22 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sat, 22 Dec 2012 12:51:29 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>
CC: <linux@arm.linux.org.uk>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] ARM: tegra: config: Add TPS6586X RTC config
Date: Sun, 23 Dec 2012 02:23:05 +0530
Message-ID: <1356209585-6506-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

enable CONFIG_RTC_DRV_TPS6586X to have RTC driver support for
ventana, harmony etc.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/configs/tegra_defconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index a7827fd..b88ec5a 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -186,6 +186,7 @@ CONFIG_RTC_INTF_SYSFS=y
 CONFIG_RTC_INTF_PROC=y
 CONFIG_RTC_INTF_DEV=y
 CONFIG_RTC_DRV_MAX8907=y
+CONFIG_RTC_DRV_TPS6586X=y
 CONFIG_RTC_DRV_TPS65910=y
 CONFIG_RTC_DRV_EM3027=y
 CONFIG_RTC_DRV_TEGRA=y
-- 
1.7.1.1

