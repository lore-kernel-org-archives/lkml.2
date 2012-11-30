Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab2K3Hor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 02:44:47 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43270 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab2K3Hoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 02:44:46 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] treewide: Fix typos in various Kconfig
Date: Fri, 30 Nov 2012 16:44:39 +0900
Message-Id: <1354261479-32553-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.0.1.347.gf94c325
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo within various Kconfig.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/arm/mach-tegra/Kconfig |  2 +-
 arch/openrisc/Kconfig       |  2 +-
 drivers/gpio/Kconfig        |  2 +-
 drivers/mmc/host/Kconfig    |  2 +-
 drivers/thermal/Kconfig     |  2 +-
 lib/Kconfig.debug           | 10 +++++-----
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-tegra/Kconfig b/arch/arm/mach-tegra/Kconfig
index 9ff6f6e..dd1ae01 100644
--- a/arch/arm/mach-tegra/Kconfig
+++ b/arch/arm/mach-tegra/Kconfig
@@ -55,7 +55,7 @@ config TEGRA_AHB
 	help
 	  Adds AHB configuration functionality for NVIDIA Tegra SoCs,
 	  which controls AHB bus master arbitration and some
-	  perfomance parameters(priority, prefech size).
+	  performance parameters(priority, prefech size).
 
 choice
         prompt "Default low-level debug console UART"
diff --git a/arch/openrisc/Kconfig b/arch/openrisc/Kconfig
index e7f1a29..ec37e18 100644
--- a/arch/openrisc/Kconfig
+++ b/arch/openrisc/Kconfig
@@ -146,7 +146,7 @@ config DEBUG_STACKOVERFLOW
 	help
 	  Make extra checks for space available on stack in some
           critical functions. This will cause kernel to run a bit slower,
-	  but will catch most of kernel stack overruns and exit gracefuly.
+	  but will catch most of kernel stack overruns and exit gracefully.
 
 	  Say Y if you are unsure.
 
diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 9e3fb34..14abfb0 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -485,7 +485,7 @@ config GPIO_ADNP
 	help
 	  This option enables support for N GPIOs found on Avionic Design
 	  I2C GPIO expanders. The register space will be extended by powers
-	  of two, so the controller will need to accomodate for that. For
+	  of two, so the controller will need to accommodate for that. For
 	  example: if a controller provides 48 pins, 6 registers will be
 	  enough to represent all pins, but the driver will assume a
 	  register layout for 64 pins (8 registers).
diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
index 3c769ba..87f2ceb 100644
--- a/drivers/mmc/host/Kconfig
+++ b/drivers/mmc/host/Kconfig
@@ -537,7 +537,7 @@ config MMC_DW_PLTFM
 	  If unsure, say Y.
 
 config MMC_DW_EXYNOS
-	tristate "Exynos specific extentions for Synopsys DW Memory Card Interface"
+	tristate "Exynos specific extensions for Synopsys DW Memory Card Interface"
 	depends on MMC_DW
 	select MMC_DW_PLTFM
 	help
diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
index 266c15e..3ba12f1 100644
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -53,7 +53,7 @@ config EXYNOS_THERMAL
 	depends on (ARCH_EXYNOS4 || ARCH_EXYNOS5) && THERMAL
 	select CPU_FREQ_TABLE
 	help
-	  If you say yes here you get support for TMU (Thermal Managment
+	  If you say yes here you get support for TMU (Thermal Management
 	  Unit) on SAMSUNG EXYNOS series of SoC.
 
 config FAIR_SHARE
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 6a4b500..37684ee 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1115,7 +1115,7 @@ config NOTIFIER_ERROR_INJECTION
 	depends on DEBUG_KERNEL
 	select DEBUG_FS
 	help
-	  This option provides the ability to inject artifical errors to
+	  This option provides the ability to inject artificial errors to
 	  specified notifier chain callbacks. It is useful to test the error
 	  handling of notifier call chain failures.
 
@@ -1126,7 +1126,7 @@ config CPU_NOTIFIER_ERROR_INJECT
 	depends on HOTPLUG_CPU && NOTIFIER_ERROR_INJECTION
 	help
 	  This option provides a kernel module that can be used to test
-	  the error handling of the cpu notifiers by injecting artifical
+	  the error handling of the cpu notifiers by injecting artificial
 	  errors to CPU notifier chain callbacks.  It is controlled through
 	  debugfs interface under /sys/kernel/debug/notifier-error-inject/cpu
 
@@ -1150,7 +1150,7 @@ config PM_NOTIFIER_ERROR_INJECT
 	depends on PM && NOTIFIER_ERROR_INJECTION
 	default m if PM_DEBUG
 	help
-	  This option provides the ability to inject artifical errors to
+	  This option provides the ability to inject artificial errors to
 	  PM notifier chain callbacks.  It is controlled through debugfs
 	  interface /sys/kernel/debug/notifier-error-inject/pm
 
@@ -1173,7 +1173,7 @@ config MEMORY_NOTIFIER_ERROR_INJECT
 	tristate "Memory hotplug notifier error injection module"
 	depends on MEMORY_HOTPLUG_SPARSE && NOTIFIER_ERROR_INJECTION
 	help
-	  This option provides the ability to inject artifical errors to
+	  This option provides the ability to inject artificial errors to
 	  memory hotplug notifier chain callbacks.  It is controlled through
 	  debugfs interface under /sys/kernel/debug/notifier-error-inject/memory
 
@@ -1196,7 +1196,7 @@ config PSERIES_RECONFIG_NOTIFIER_ERROR_INJECT
 	tristate "pSeries reconfig notifier error injection module"
 	depends on PPC_PSERIES && NOTIFIER_ERROR_INJECTION
 	help
-	  This option provides the ability to inject artifical errors to
+	  This option provides the ability to inject artificial errors to
 	  pSeries reconfig notifier chain callbacks.  It is controlled
 	  through debugfs interface under
 	  /sys/kernel/debug/notifier-error-inject/pSeries-reconfig/
-- 
1.8.0.1.347.gf94c325

