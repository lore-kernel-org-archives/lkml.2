Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab1GXVP5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jul 2011 17:15:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62538 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501Ab1GXVPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jul 2011 17:15:54 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaud Lacombe <lacombar@gmail.com>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH -next] arm/mm: fix broken Kconfig
Date: Sun, 24 Jul 2011 17:15:41 -0400
Message-Id: <1311542141-16226-1-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.6.153.g78432
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Missing backslash lead to:

arch/arm/mm/Kconfig:834: invalid option
arch/arm/mm/Kconfig:835: syntax error
arch/arm/mm/Kconfig:838: unknown option "ARCH_PRIMA2"

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 arch/arm/mm/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index d490c4a..2df5504 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -834,7 +834,7 @@ config CACHE_L2X0
 	depends on REALVIEW_EB_ARM11MP || MACH_REALVIEW_PB11MP || MACH_REALVIEW_PB1176 || \
 		   REALVIEW_EB_A9MP || SOC_IMX35 || SOC_IMX31 || MACH_REALVIEW_PBX || \
 		   ARCH_NOMADIK || ARCH_OMAP4 || ARCH_EXYNOS4 || ARCH_TEGRA || \
-		   ARCH_U8500 || ARCH_VEXPRESS_CA9X4 || ARCH_SHMOBILE ||
+		   ARCH_U8500 || ARCH_VEXPRESS_CA9X4 || ARCH_SHMOBILE || \
 		   ARCH_PRIMA2 || ARCH_ZYNQ || ARCH_CNS3XXX
 	default y
 	select OUTER_CACHE
-- 
1.7.6.153.g78432

