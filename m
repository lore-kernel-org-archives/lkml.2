Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830Ab2DQGKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 02:10:41 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7426 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab2DQGKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 02:10:40 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 16 Apr 2012 23:10:27 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: linux@arm.linux.org.uk, swarren@nvidia.com, olof@lixom.net,
        ccross@android.com, ldewangan@nvidia.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH V1 2/2] ARM: config: tegra: add ISL29028
Date: Tue, 17 Apr 2012 11:40:02 +0530
Message-Id: <1334643002-6337-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1334643002-6337-1-git-send-email-ldewangan@nvidia.com>
References: <1334643002-6337-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ALS and prosimity sensor ISL29028 config.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/configs/tegra_defconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/configs/tegra_defconfig b/arch/arm/configs/tegra_defconfig
index 351d670..2ad3e3b 100644
--- a/arch/arm/configs/tegra_defconfig
+++ b/arch/arm/configs/tegra_defconfig
@@ -137,6 +137,7 @@ CONFIG_RTC_DRV_TEGRA=y
 CONFIG_STAGING=y
 CONFIG_IIO=y
 CONFIG_SENSORS_ISL29018=y
+CONFIG_SENSORS_ISL29028=y
 CONFIG_SENSORS_AK8975=y
 CONFIG_MFD_NVEC=y
 CONFIG_KEYBOARD_NVEC=y
-- 
1.7.1.1

