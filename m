Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab1G3QPI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 12:15:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34445 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab1G3QPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 12:15:03 -0400
From: Zoltan Devai <zdevai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-am33-list@redhat.com,
        user-mode-linux-devel@lists.sourceforge.net, chris@zankel.net,
        cmetcalf@tilera.com, Zoltan Devai <zdevai@gmail.com>
Subject: [PATCH] Remove remaining references of CONFIG_GENERIC_TIME
Date: Sat, 30 Jul 2011 18:14:38 +0200
Message-Id: <1312042478-26012-1-git-send-email-zdevai@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 592913ecb87a9e06f98ddb55b298f1a66bf94c6b has killed off any
use of this config option long ago.

Signed-off-by: Zoltan Devai <zdevai@gmail.com>
---
 arch/arm/Kconfig                    |    4 ----
 arch/mn10300/Kconfig                |    3 ---
 arch/tile/Kconfig                   |    3 ---
 arch/tile/configs/tilegx_defconfig  |    1 -
 arch/tile/configs/tilepro_defconfig |    1 -
 arch/um/defconfig                   |    1 -
 arch/xtensa/configs/iss_defconfig   |    1 -
 arch/xtensa/configs/s6105_defconfig |    1 -
 8 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 2c71a8f..37cc722 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -347,7 +347,6 @@ config ARCH_GEMINI
 config ARCH_PRIMA2
 	bool "CSR SiRFSoC PRIMA2 ARM Cortex A9 Platform"
 	select CPU_V7
-	select GENERIC_TIME
 	select NO_IOPORT
 	select GENERIC_CLOCKEVENTS
 	select CLKDEV_LOOKUP
@@ -520,7 +519,6 @@ config ARCH_LPC32XX
 	select ARM_AMBA
 	select USB_ARCH_HAS_OHCI
 	select CLKDEV_LOOKUP
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	help
 	  Support for the NXP LPC32XX family of processors
@@ -599,7 +597,6 @@ config ARCH_TEGRA
 	bool "NVIDIA Tegra"
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_GPIO
 	select HAVE_CLK
@@ -911,7 +908,6 @@ config ARCH_VT8500
 config ARCH_ZYNQ
 	bool "Xilinx Zynq ARM Cortex A9 Platform"
 	select CPU_V7
-	select GENERIC_TIME
 	select GENERIC_CLOCKEVENTS
 	select CLKDEV_LOOKUP
 	select ARM_GIC
diff --git a/arch/mn10300/Kconfig b/arch/mn10300/Kconfig
index 1f87034..5f7f2f8d 100644
--- a/arch/mn10300/Kconfig
+++ b/arch/mn10300/Kconfig
@@ -47,9 +47,6 @@ config GENERIC_CMOS_UPDATE
 config GENERIC_HWEIGHT
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_CLOCKEVENTS
 	def_bool y
 
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 0249b8b..4c5b286 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -45,9 +45,6 @@ config NEED_PER_CPU_PAGE_FIRST_CHUNK
 config SYS_SUPPORTS_HUGETLBFS
 	def_bool y
 
-config GENERIC_TIME
-	def_bool y
-
 config GENERIC_CLOCKEVENTS
 	def_bool y
 
diff --git a/arch/tile/configs/tilegx_defconfig b/arch/tile/configs/tilegx_defconfig
index 2ad73fb..dafdbba 100644
--- a/arch/tile/configs/tilegx_defconfig
+++ b/arch/tile/configs/tilegx_defconfig
@@ -11,7 +11,6 @@ CONFIG_HAVE_ARCH_ALLOC_REMAP=y
 CONFIG_HAVE_SETUP_PER_CPU_AREA=y
 CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
 CONFIG_SYS_SUPPORTS_HUGETLBFS=y
-CONFIG_GENERIC_TIME=y
 CONFIG_GENERIC_CLOCKEVENTS=y
 CONFIG_RWSEM_GENERIC_SPINLOCK=y
 CONFIG_DEFAULT_MIGRATION_COST=10000000
diff --git a/arch/tile/configs/tilepro_defconfig b/arch/tile/configs/tilepro_defconfig
index f58dc36..6f05f969 100644
--- a/arch/tile/configs/tilepro_defconfig
+++ b/arch/tile/configs/tilepro_defconfig
@@ -11,7 +11,6 @@ CONFIG_HAVE_ARCH_ALLOC_REMAP=y
 CONFIG_HAVE_SETUP_PER_CPU_AREA=y
 CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
 CONFIG_SYS_SUPPORTS_HUGETLBFS=y
-CONFIG_GENERIC_TIME=y
 CONFIG_GENERIC_CLOCKEVENTS=y
 CONFIG_RWSEM_GENERIC_SPINLOCK=y
 CONFIG_DEFAULT_MIGRATION_COST=10000000
diff --git a/arch/um/defconfig b/arch/um/defconfig
index 9f7634f..761f5e1 100644
--- a/arch/um/defconfig
+++ b/arch/um/defconfig
@@ -13,7 +13,6 @@ CONFIG_LOCKDEP_SUPPORT=y
 # CONFIG_STACKTRACE_SUPPORT is not set
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_GENERIC_BUG=y
-CONFIG_GENERIC_TIME=y
 CONFIG_GENERIC_CLOCKEVENTS=y
 CONFIG_IRQ_RELEASE_METHOD=y
 CONFIG_HZ=100
diff --git a/arch/xtensa/configs/iss_defconfig b/arch/xtensa/configs/iss_defconfig
index 0234cd1..f932b30 100644
--- a/arch/xtensa/configs/iss_defconfig
+++ b/arch/xtensa/configs/iss_defconfig
@@ -15,7 +15,6 @@ CONFIG_GENERIC_GPIO=y
 # CONFIG_ARCH_HAS_ILOG2_U64 is not set
 CONFIG_NO_IOPORT=y
 CONFIG_HZ=100
-CONFIG_GENERIC_TIME=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 CONFIG_CONSTRUCTORS=y
 
diff --git a/arch/xtensa/configs/s6105_defconfig b/arch/xtensa/configs/s6105_defconfig
index 4891abb..550e8ed 100644
--- a/arch/xtensa/configs/s6105_defconfig
+++ b/arch/xtensa/configs/s6105_defconfig
@@ -15,7 +15,6 @@ CONFIG_GENERIC_GPIO=y
 # CONFIG_ARCH_HAS_ILOG2_U64 is not set
 CONFIG_NO_IOPORT=y
 CONFIG_HZ=100
-CONFIG_GENERIC_TIME=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
 
 #
-- 
1.7.4.1

