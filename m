Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab2DQPBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:01:30 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:59035 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab2DQPB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:01:28 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] Fix "the the" in various Kconfig
Date: Wed, 18 Apr 2012 00:01:21 +0900
Message-Id: <1334674881-788-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.10.169.g146fe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix typo "the the" in various Kconfig.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 arch/arm/Kconfig                |    4 ++--
 arch/arm/mach-s3c64xx/Kconfig   |    4 ++--
 arch/blackfin/Kconfig           |    2 +-
 drivers/iommu/Kconfig           |    4 ++--
 drivers/net/can/sja1000/Kconfig |    2 +-
 drivers/net/irda/Kconfig        |    2 +-
 kernel/trace/Kconfig            |    2 +-
 sound/soc/imx/Kconfig           |    2 +-
 8 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 4ece1de..0209918 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1926,10 +1926,10 @@ choice
 	default ZBOOT_ROM_NONE
 	help
 	  Include experimental SD/MMC loading code in the ROM-able zImage.
-	  With this enabled it is possible to write the the ROM-able zImage
+	  With this enabled it is possible to write the ROM-able zImage
 	  kernel image to an MMC or SD card and boot the kernel straight
 	  from the reset vector. At reset the processor Mask ROM will load
-	  the first part of the the ROM-able zImage which in turn loads the
+	  the first part of the ROM-able zImage which in turn loads the
 	  rest the kernel image to RAM.
 
 config ZBOOT_ROM_NONE
diff --git a/arch/arm/mach-s3c64xx/Kconfig b/arch/arm/mach-s3c64xx/Kconfig
index 82c0915..06ca1cd 100644
--- a/arch/arm/mach-s3c64xx/Kconfig
+++ b/arch/arm/mach-s3c64xx/Kconfig
@@ -210,7 +210,7 @@ config SMDK6410_WM1190_EV1
 	  and audio daughtercard for the Samsung SMDK6410 reference
 	  platform.  Enabling this option will build support for this
 	  module into the kernel.  The presence of the module will be
-	  detected at runtime so the the resulting kernel can be used
+	  detected at runtime so the resulting kernel can be used
 	  with or without the 1190-EV1 fitted.
 
 config SMDK6410_WM1192_EV1
@@ -226,7 +226,7 @@ config SMDK6410_WM1192_EV1
 	  daughtercard for the Samsung SMDK6410 reference platform.
 	  Enabling this option will build support for this module into
 	  the kernel.  The presence of the daughtercard will be
-	  detected at runtime so the the resulting kernel can be used
+	  detected at runtime so the resulting kernel can be used
 	  with or without the 1192-EV1 fitted.
 
 config MACH_NCP
diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 373a690..b83e89c 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -1258,7 +1258,7 @@ config PM_BFIN_WAKE_GP
 	  (all processors, except ADSP-BF549). This option sets
 	  the general-purpose wake-up enable (GPWE) control bit to enable
 	  wake-up upon detection of an active low signal on the /GPW (PH7) pin.
-	  On ADSP-BF549 this option enables the the same functionality on the
+	  On ADSP-BF549 this option enables the same functionality on the
 	  /MRXON pin also PH7.
 
 endmenu
diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index 3bd9fff..c698437 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -43,7 +43,7 @@ config AMD_IOMMU
 	  With this option you can enable support for AMD IOMMU hardware in
 	  your system. An IOMMU is a hardware component which provides
 	  remapping of DMA memory accesses from devices. With an AMD IOMMU you
-	  can isolate the the DMA memory of different devices and protect the
+	  can isolate the DMA memory of different devices and protect the
 	  system from misbehaving device drivers or hardware.
 
 	  You can find out if your system has an AMD IOMMU if you look into
@@ -67,7 +67,7 @@ config AMD_IOMMU_V2
 	---help---
 	  This option enables support for the AMD IOMMUv2 features of the IOMMU
 	  hardware. Select this option if you want to use devices that support
-	  the the PCI PRI and PASID interface.
+	  the PCI PRI and PASID interface.
 
 # Intel IOMMU support
 config DMAR_TABLE
diff --git a/drivers/net/can/sja1000/Kconfig b/drivers/net/can/sja1000/Kconfig
index b60d6c5..03df9a8 100644
--- a/drivers/net/can/sja1000/Kconfig
+++ b/drivers/net/can/sja1000/Kconfig
@@ -75,7 +75,7 @@ config CAN_KVASER_PCI
 	tristate "Kvaser PCIcanx and Kvaser PCIcan PCI Cards"
 	depends on PCI
 	---help---
-	  This driver is for the the PCIcanx and PCIcan cards (1, 2 or
+	  This driver is for the PCIcanx and PCIcan cards (1, 2 or
 	  4 channel) from Kvaser (http://www.kvaser.com).
 
 config CAN_PLX_PCI
diff --git a/drivers/net/irda/Kconfig b/drivers/net/irda/Kconfig
index 4680478..7ca9ab1 100644
--- a/drivers/net/irda/Kconfig
+++ b/drivers/net/irda/Kconfig
@@ -316,7 +316,7 @@ config AU1000_FIR
 	tristate "Alchemy IrDA SIR/FIR"
 	depends on IRDA && MIPS_ALCHEMY
 	help
-	  Say Y/M here to build suppor the the IrDA peripheral on the
+	  Say Y/M here to build support the IrDA peripheral on the
 	  Alchemy Au1000 and Au1100 SoCs.
 	  Say M to build a module; it will be called au1k_ir.ko
 
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index a1d2849..6692db9 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -272,7 +272,7 @@ config PROFILE_ANNOTATED_BRANCHES
 	bool "Trace likely/unlikely profiler"
 	select TRACE_BRANCH_PROFILING
 	help
-	  This tracer profiles all the the likely and unlikely macros
+	  This tracer profiles all likely and unlikely macros
 	  in the kernel. It will display the results in:
 
 	  /sys/kernel/debug/tracing/trace_stat/branch_annotated
diff --git a/sound/soc/imx/Kconfig b/sound/soc/imx/Kconfig
index 810acaa..d83e5d0 100644
--- a/sound/soc/imx/Kconfig
+++ b/sound/soc/imx/Kconfig
@@ -28,7 +28,7 @@ config SND_SOC_IMX_AUDMUX
 	tristate
 
 config SND_MXC_SOC_WM1133_EV1
-	tristate "Audio on the the i.MX31ADS with WM1133-EV1 fitted"
+	tristate "Audio on the i.MX31ADS with WM1133-EV1 fitted"
 	depends on MACH_MX31ADS_WM1133_EV1 && EXPERIMENTAL
 	select SND_SOC_WM8350
 	select SND_MXC_SOC_FIQ
-- 
1.7.10.169.g146fe

