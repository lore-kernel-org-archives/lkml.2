Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab2JRK5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 06:57:46 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:19605 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269Ab2JRK5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 06:57:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 18 Oct 2012 03:57:34 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>
CC: <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/5] ARM: tegra: Add slink controller base address
Date: Thu, 18 Oct 2012 16:26:31 +0530
Message-ID: <1350557795-31487-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1350557795-31487-1-git-send-email-ldewangan@nvidia.com>
References: <1350557795-31487-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add base address of all slink controller of Tegra20
and tegra30.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/mach-tegra/include/mach/iomap.h |   22 ++++++++++++++--------
 1 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-tegra/include/mach/iomap.h b/arch/arm/mach-tegra/include/mach/iomap.h
index fee3a94..0f46765 100644
--- a/arch/arm/mach-tegra/include/mach/iomap.h
+++ b/arch/arm/mach-tegra/include/mach/iomap.h
@@ -206,17 +206,23 @@
 #define TEGRA_DVC_BASE			0x7000D000
 #define TEGRA_DVC_SIZE			SZ_512
 
-#define TEGRA_SPI1_BASE			0x7000D400
-#define TEGRA_SPI1_SIZE			SZ_512
+#define TEGRA_SLINK1_BASE		0x7000D400
+#define TEGRA_SLINK1_SIZE		SZ_512
 
-#define TEGRA_SPI2_BASE			0x7000D600
-#define TEGRA_SPI2_SIZE			SZ_512
+#define TEGRA_SLINK2_BASE		0x7000D600
+#define TEGRA_SLINK2_SIZE		SZ_512
 
-#define TEGRA_SPI3_BASE			0x7000D800
-#define TEGRA_SPI3_SIZE			SZ_512
+#define TEGRA_SLINK3_BASE		0x7000D800
+#define TEGRA_SLINK3_SIZE		SZ_512
 
-#define TEGRA_SPI4_BASE			0x7000DA00
-#define TEGRA_SPI4_SIZE			SZ_512
+#define TEGRA_SLINK4_BASE		0x7000DA00
+#define TEGRA_SLINK4_SIZE		SZ_512
+
+#define TEGRA_SLINK5_BASE		0x7000DC00
+#define TEGRA_SLINK5_SIZE		SZ_512
+
+#define TEGRA_SLINK6_BASE		0x7000DE00
+#define TEGRA_SLINK6_SIZE		SZ_512
 
 #define TEGRA_RTC_BASE			0x7000E000
 #define TEGRA_RTC_SIZE			SZ_256
-- 
1.7.1.1

