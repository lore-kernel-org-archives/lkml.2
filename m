Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab2FML3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 07:29:18 -0400
Received: from service87.mimecast.com ([91.220.42.44]:47330 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab2FML3Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 07:29:16 -0400
From: Viresh Kumar <viresh.kumar2@arm.com>
To: <akpm@linux-foundation.org>
CC: <spear-devel@list.st.com>, <linux-kernel@vger.kernel.org>,
        Viresh Kumar <viresh.linux@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=5D=20Update=20e-mail=20address?=
Date: Wed, 13 Jun 2012 12:29:05 +0100
Message-ID: <bfdae4d34b7d70d75f8a1cfd9739aa20c4c72e4e.1339584763.git.viresh.linux@gmail.com>
X-Mailer: git-send-email 1.7.11.rc1.9.gf623ca1
MIME-Version: 1.0
X-MC-Unique: 112061312291300501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Viresh Kumar <viresh.linux@gmail.com>

viresh.kumar@st.com email-id doesn't exist anymore as I have left the company.
Replace ST's id with viresh.linux@gmail.com.

It also updates .mailmap file to fix address for 'git shortlog'

Signed-off-by: Viresh Kumar <viresh.linux@gmail.com>
---
 .mailmap                                           |  1 +
 Documentation/arm/SPEAr/overview.txt               |  2 +-
 MAINTAINERS                                        | 18 +++++++++---------
 arch/arm/boot/dts/spear1310-evb.dts                |  2 +-
 arch/arm/boot/dts/spear1310.dtsi                   |  2 +-
 arch/arm/boot/dts/spear1340-evb.dts                |  2 +-
 arch/arm/boot/dts/spear1340.dtsi                   |  2 +-
 arch/arm/boot/dts/spear13xx.dtsi                   |  2 +-
 arch/arm/boot/dts/spear300-evb.dts                 |  2 +-
 arch/arm/boot/dts/spear300.dtsi                    |  2 +-
 arch/arm/boot/dts/spear310-evb.dts                 |  2 +-
 arch/arm/boot/dts/spear310.dtsi                    |  2 +-
 arch/arm/boot/dts/spear320-evb.dts                 |  2 +-
 arch/arm/boot/dts/spear320.dtsi                    |  2 +-
 arch/arm/boot/dts/spear3xx.dtsi                    |  2 +-
 arch/arm/include/asm/hardware/sp810.h              |  2 +-
 arch/arm/mach-spear13xx/include/mach/debug-macro.S |  2 +-
 arch/arm/mach-spear13xx/include/mach/dma.h         |  2 +-
 arch/arm/mach-spear13xx/include/mach/generic.h     |  2 +-
 arch/arm/mach-spear13xx/include/mach/gpio.h        |  2 +-
 arch/arm/mach-spear13xx/include/mach/irqs.h        |  2 +-
 arch/arm/mach-spear13xx/include/mach/spear.h       |  2 +-
 arch/arm/mach-spear13xx/include/mach/timex.h       |  2 +-
 arch/arm/mach-spear13xx/include/mach/uncompress.h  |  2 +-
 arch/arm/mach-spear13xx/spear1310.c                |  2 +-
 arch/arm/mach-spear13xx/spear1340.c                |  2 +-
 arch/arm/mach-spear13xx/spear13xx.c                |  2 +-
 arch/arm/mach-spear3xx/include/mach/debug-macro.S  |  2 +-
 arch/arm/mach-spear3xx/include/mach/generic.h      |  2 +-
 arch/arm/mach-spear3xx/include/mach/gpio.h         |  2 +-
 arch/arm/mach-spear3xx/include/mach/irqs.h         |  2 +-
 arch/arm/mach-spear3xx/include/mach/misc_regs.h    |  2 +-
 arch/arm/mach-spear3xx/include/mach/spear.h        |  2 +-
 arch/arm/mach-spear3xx/include/mach/timex.h        |  2 +-
 arch/arm/mach-spear3xx/include/mach/uncompress.h   |  2 +-
 arch/arm/mach-spear3xx/spear300.c                  |  2 +-
 arch/arm/mach-spear3xx/spear310.c                  |  2 +-
 arch/arm/mach-spear3xx/spear320.c                  |  2 +-
 arch/arm/mach-spear3xx/spear3xx.c                  |  2 +-
 arch/arm/mach-spear6xx/include/mach/gpio.h         |  2 +-
 arch/arm/mach-spear6xx/include/mach/misc_regs.h    |  2 +-
 arch/arm/plat-spear/include/plat/debug-macro.S     |  2 +-
 arch/arm/plat-spear/include/plat/pl080.h           |  2 +-
 arch/arm/plat-spear/include/plat/shirq.h           |  2 +-
 arch/arm/plat-spear/include/plat/timex.h           |  2 +-
 arch/arm/plat-spear/include/plat/uncompress.h      |  2 +-
 arch/arm/plat-spear/pl080.c                        |  2 +-
 arch/arm/plat-spear/restart.c                      |  2 +-
 arch/arm/plat-spear/shirq.c                        |  2 +-
 drivers/ata/pata_arasan_cf.c                       |  4 ++--
 drivers/clk/spear/clk-aux-synth.c                  |  2 +-
 drivers/clk/spear/clk-frac-synth.c                 |  2 +-
 drivers/clk/spear/clk-gpt-synth.c                  |  2 +-
 drivers/clk/spear/clk-vco-pll.c                    |  2 +-
 drivers/clk/spear/clk.c                            |  2 +-
 drivers/clk/spear/clk.h                            |  2 +-
 drivers/clk/spear/spear1310_clock.c                |  2 +-
 drivers/clk/spear/spear1340_clock.c                |  2 +-
 drivers/clk/spear/spear3xx_clock.c                 |  2 +-
 drivers/clk/spear/spear6xx_clock.c                 |  2 +-
 drivers/dma/dw_dmac.c                              |  2 +-
 drivers/mfd/stmpe-i2c.c                            |  2 +-
 drivers/mfd/stmpe-spi.c                            |  4 ++--
 drivers/mmc/host/sdhci-spear.c                     |  4 ++--
 drivers/pinctrl/spear/pinctrl-spear.c              |  2 +-
 drivers/pinctrl/spear/pinctrl-spear.h              |  2 +-
 drivers/pinctrl/spear/pinctrl-spear1310.c          |  4 ++--
 drivers/pinctrl/spear/pinctrl-spear1340.c          |  4 ++--
 drivers/pinctrl/spear/pinctrl-spear300.c           |  4 ++--
 drivers/pinctrl/spear/pinctrl-spear310.c           |  4 ++--
 drivers/pinctrl/spear/pinctrl-spear320.c           |  4 ++--
 drivers/pinctrl/spear/pinctrl-spear3xx.c           |  2 +-
 drivers/pinctrl/spear/pinctrl-spear3xx.h           |  2 +-
 drivers/watchdog/sp805_wdt.c                       |  4 ++--
 include/linux/mmc/sdhci-spear.h                    |  2 +-
 include/linux/pata_arasan_cf_data.h                |  2 +-
 76 files changed, 93 insertions(+), 92 deletions(-)

diff --git a/.mailmap b/.mailmap
index 2909c33..658003a 100644
--- a/.mailmap
+++ b/.mailmap
@@ -111,6 +111,7 @@ Uwe Kleine-König <ukleinek@informatik.uni-freiburg.de>
 Uwe Kleine-König <ukl@pengutronix.de>
 Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
 Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
+Viresh Kumar <viresh.linux@gmail.com> <viresh.kumar@st.com>
 Takashi YOSHII <takashi.yoshii.zj@renesas.com>
 Yusuke Goda <goda.yusuke@renesas.com>
 Gustavo Padovan <gustavo@las.ic.unicamp.br>
diff --git a/Documentation/arm/SPEAr/overview.txt b/Documentation/arm/SPEAr/overview.txt
index 57aae77..65610bf 100644
--- a/Documentation/arm/SPEAr/overview.txt
+++ b/Documentation/arm/SPEAr/overview.txt
@@ -60,4 +60,4 @@ Introduction
   Document Author
   ---------------

-  Viresh Kumar <viresh.kumar@st.com>, (c) 2010-2012 ST Microelectronics
+  Viresh Kumar <viresh.linux@gmail.com>, (c) 2010-2012 ST Microelectronics
diff --git a/MAINTAINERS b/MAINTAINERS
index 7fc9b61..08abd9e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -579,7 +579,7 @@ F:  drivers/net/appletalk/
 F:     net/appletalk/

 ARASAN COMPACT FLASH PATA CONTROLLER
-M:     Viresh Kumar <viresh.kumar@st.com>
+M:     Viresh Kumar <viresh.linux@gmail.com>
 L:     linux-ide@vger.kernel.org
 S:     Maintained
 F:     include/linux/pata_arasan_cf_data.h
@@ -5304,7 +5304,7 @@ S:        Maintained
 F:     drivers/pinctrl/

 PIN CONTROLLER - ST SPEAR
-M:     Viresh Kumar <viresh.kumar@st.com>
+M:     Viresh Kumar <viresh.linux@gmail.com>
 L:     spear-devel@list.st.com
 L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:     http://www.st.com/spear
@@ -5881,7 +5881,7 @@ S:        Maintained
 F:     drivers/tty/serial

 SYNOPSYS DESIGNWARE DMAC DRIVER
-M:     Viresh Kumar <viresh.kumar@st.com>
+M:     Viresh Kumar <viresh.linux@gmail.com>
 S:     Maintained
 F:     include/linux/dw_dmac.h
 F:     drivers/dma/dw_dmac_regs.h
@@ -6029,7 +6029,7 @@ S:        Maintained
 F:     drivers/mmc/host/sdhci-s3c.c

 SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) ST SPEAR DRIVER
-M:     Viresh Kumar <viresh.kumar@st.com>
+M:     Viresh Kumar <viresh.linux@gmail.com>
 L:     spear-devel@list.st.com
 L:     linux-mmc@vger.kernel.org
 S:     Maintained
@@ -6385,7 +6385,7 @@ S:        Maintained
 F:     include/linux/compiler.h

 SPEAR PLATFORM SUPPORT
-M:     Viresh Kumar <viresh.kumar@st.com>
+M:     Viresh Kumar <viresh.linux@gmail.com>
 M:     Shiraz Hashim <shiraz.hashim@st.com>
 L:     spear-devel@list.st.com
 L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
@@ -6394,7 +6394,7 @@ S:        Maintained
 F:     arch/arm/plat-spear/

 SPEAR13XX MACHINE SUPPORT
-M:     Viresh Kumar <viresh.kumar@st.com>
+M:     Viresh Kumar <viresh.linux@gmail.com>
 M:     Shiraz Hashim <shiraz.hashim@st.com>
 L:     spear-devel@list.st.com
 L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
@@ -6403,7 +6403,7 @@ S:        Maintained
 F:     arch/arm/mach-spear13xx/

 SPEAR3XX MACHINE SUPPORT
-M:     Viresh Kumar <viresh.kumar@st.com>
+M:     Viresh Kumar <viresh.linux@gmail.com>
 M:     Shiraz Hashim <shiraz.hashim@st.com>
 L:     spear-devel@list.st.com
 L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
@@ -6414,7 +6414,7 @@ F:        arch/arm/mach-spear3xx/
 SPEAR6XX MACHINE SUPPORT
 M:     Rajeev Kumar <rajeev-dlh.kumar@st.com>
 M:     Shiraz Hashim <shiraz.hashim@st.com>
-M:     Viresh Kumar <viresh.kumar@st.com>
+M:     Viresh Kumar <viresh.linux@gmail.com>
 L:     spear-devel@list.st.com
 L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:     http://www.st.com/spear
@@ -6422,7 +6422,7 @@ S:        Maintained
 F:     arch/arm/mach-spear6xx/

 SPEAR CLOCK FRAMEWORK SUPPORT
-M:     Viresh Kumar <viresh.kumar@st.com>
+M:     Viresh Kumar <viresh.linux@gmail.com>
 L:     spear-devel@list.st.com
 L:     linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 W:     http://www.st.com/spear
diff --git a/arch/arm/boot/dts/spear1310-evb.dts b/arch/arm/boot/dts/spear1310-evb.dts
index 8314e41..dd4358b 100644
--- a/arch/arm/boot/dts/spear1310-evb.dts
+++ b/arch/arm/boot/dts/spear1310-evb.dts
@@ -1,7 +1,7 @@
 /*
  * DTS file for SPEAr1310 Evaluation Baord
  *
- * Copyright 2012 Viresh Kumar <viresh.kumar@st.com>
+ * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff --git a/arch/arm/boot/dts/spear1310.dtsi b/arch/arm/boot/dts/spear1310.dtsi
index 9e61da4..419ea74 100644
--- a/arch/arm/boot/dts/spear1310.dtsi
+++ b/arch/arm/boot/dts/spear1310.dtsi
@@ -1,7 +1,7 @@
 /*
  * DTS file for all SPEAr1310 SoCs
  *
- * Copyright 2012 Viresh Kumar <viresh.kumar@st.com>
+ * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff --git a/arch/arm/boot/dts/spear1340-evb.dts b/arch/arm/boot/dts/spear1340-evb.dts
index 0d8472e..c9a54e0 100644
--- a/arch/arm/boot/dts/spear1340-evb.dts
+++ b/arch/arm/boot/dts/spear1340-evb.dts
@@ -1,7 +1,7 @@
 /*
  * DTS file for SPEAr1340 Evaluation Baord
  *
- * Copyright 2012 Viresh Kumar <viresh.kumar@st.com>
+ * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff --git a/arch/arm/boot/dts/spear1340.dtsi b/arch/arm/boot/dts/spear1340.dtsi
index a26fc47..d71fe2a 100644
--- a/arch/arm/boot/dts/spear1340.dtsi
+++ b/arch/arm/boot/dts/spear1340.dtsi
@@ -1,7 +1,7 @@
 /*
  * DTS file for all SPEAr1340 SoCs
  *
- * Copyright 2012 Viresh Kumar <viresh.kumar@st.com>
+ * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff --git a/arch/arm/boot/dts/spear13xx.dtsi b/arch/arm/boot/dts/spear13xx.dtsi
index 1f8e1e1..10dcec7 100644
--- a/arch/arm/boot/dts/spear13xx.dtsi
+++ b/arch/arm/boot/dts/spear13xx.dtsi
@@ -1,7 +1,7 @@
 /*
  * DTS file for all SPEAr13xx SoCs
  *
- * Copyright 2012 Viresh Kumar <viresh.kumar@st.com>
+ * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff --git a/arch/arm/boot/dts/spear300-evb.dts b/arch/arm/boot/dts/spear300-evb.dts
index fc82b1a..d71b8d5 100644
--- a/arch/arm/boot/dts/spear300-evb.dts
+++ b/arch/arm/boot/dts/spear300-evb.dts
@@ -1,7 +1,7 @@
 /*
  * DTS file for SPEAr300 Evaluation Baord
  *
- * Copyright 2012 Viresh Kumar <viresh.kumar@st.com>
+ * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff --git a/arch/arm/boot/dts/spear300.dtsi b/arch/arm/boot/dts/spear300.dtsi
index 01c5e35..ed3627c 100644
--- a/arch/arm/boot/dts/spear300.dtsi
+++ b/arch/arm/boot/dts/spear300.dtsi
@@ -1,7 +1,7 @@
 /*
  * DTS file for SPEAr300 SoC
  *
- * Copyright 2012 Viresh Kumar <viresh.kumar@st.com>
+ * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff --git a/arch/arm/boot/dts/spear310-evb.dts b/arch/arm/boot/dts/spear310-evb.dts
index dc5e2d4..b00544e 100644
--- a/arch/arm/boot/dts/spear310-evb.dts
+++ b/arch/arm/boot/dts/spear310-evb.dts
@@ -1,7 +1,7 @@
 /*
  * DTS file for SPEAr310 Evaluation Baord
  *
- * Copyright 2012 Viresh Kumar <viresh.kumar@st.com>
+ * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff --git a/arch/arm/boot/dts/spear310.dtsi b/arch/arm/boot/dts/spear310.dtsi
index e47081c..62fc4fb 100644
--- a/arch/arm/boot/dts/spear310.dtsi
+++ b/arch/arm/boot/dts/spear310.dtsi
@@ -1,7 +1,7 @@
 /*
  * DTS file for SPEAr310 SoC
  *
- * Copyright 2012 Viresh Kumar <viresh.kumar@st.com>
+ * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff --git a/arch/arm/boot/dts/spear320-evb.dts b/arch/arm/boot/dts/spear320-evb.dts
index 6308fa3..c13fd1f 100644
--- a/arch/arm/boot/dts/spear320-evb.dts
+++ b/arch/arm/boot/dts/spear320-evb.dts
@@ -1,7 +1,7 @@
 /*
  * DTS file for SPEAr320 Evaluation Baord
  *
- * Copyright 2012 Viresh Kumar <viresh.kumar@st.com>
+ * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff --git a/arch/arm/boot/dts/spear320.dtsi b/arch/arm/boot/dts/spear320.dtsi
index 5372ca3..1f49d69 100644
--- a/arch/arm/boot/dts/spear320.dtsi
+++ b/arch/arm/boot/dts/spear320.dtsi
@@ -1,7 +1,7 @@
 /*
  * DTS file for SPEAr320 SoC
  *
- * Copyright 2012 Viresh Kumar <viresh.kumar@st.com>
+ * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff --git a/arch/arm/boot/dts/spear3xx.dtsi b/arch/arm/boot/dts/spear3xx.dtsi
index 9107255..3a8bb57 100644
--- a/arch/arm/boot/dts/spear3xx.dtsi
+++ b/arch/arm/boot/dts/spear3xx.dtsi
@@ -1,7 +1,7 @@
 /*
  * DTS file for all SPEAr3xx SoCs
  *
- * Copyright 2012 Viresh Kumar <viresh.kumar@st.com>
+ * Copyright 2012 Viresh Kumar <viresh.linux@gmail.com>
  *
  * The code contained herein is licensed under the GNU General Public
  * License. You may obtain a copy of the GNU General Public License
diff --git a/arch/arm/include/asm/hardware/sp810.h b/arch/arm/include/asm/hardware/sp810.h
index e0d1c0c..6b9b077 100644
--- a/arch/arm/include/asm/hardware/sp810.h
+++ b/arch/arm/include/asm/hardware/sp810.h
@@ -4,7 +4,7 @@
  * ARM PrimeXsys System Controller SP810 header file
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/mach-spear13xx/include/mach/debug-macro.S b/arch/arm/mach-spear13xx/include/mach/debug-macro.S
index ea15646..9e3ae6b 100644
--- a/arch/arm/mach-spear13xx/include/mach/debug-macro.S
+++ b/arch/arm/mach-spear13xx/include/mach/debug-macro.S
@@ -4,7 +4,7 @@
  * Debugging macro include header spear13xx machine family
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/mach-spear13xx/include/mach/dma.h b/arch/arm/mach-spear13xx/include/mach/dma.h
index 383ab04..d50bdb6 100644
--- a/arch/arm/mach-spear13xx/include/mach/dma.h
+++ b/arch/arm/mach-spear13xx/include/mach/dma.h
@@ -4,7 +4,7 @@
  * DMA information for SPEAr13xx machine family
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/mach-spear13xx/include/mach/generic.h b/arch/arm/mach-spear13xx/include/mach/generic.h
index 6d8c45b..dac57fd 100644
--- a/arch/arm/mach-spear13xx/include/mach/generic.h
+++ b/arch/arm/mach-spear13xx/include/mach/generic.h
@@ -4,7 +4,7 @@
  * spear13xx machine family generic header file
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/mach-spear13xx/include/mach/gpio.h b/arch/arm/mach-spear13xx/include/mach/gpio.h
index cd6f4f8..85f1763 100644
--- a/arch/arm/mach-spear13xx/include/mach/gpio.h
+++ b/arch/arm/mach-spear13xx/include/mach/gpio.h
@@ -4,7 +4,7 @@
  * GPIO macros for SPEAr13xx machine family
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/mach-spear13xx/include/mach/irqs.h b/arch/arm/mach-spear13xx/include/mach/irqs.h
index f542a24..271a62b 100644
--- a/arch/arm/mach-spear13xx/include/mach/irqs.h
+++ b/arch/arm/mach-spear13xx/include/mach/irqs.h
@@ -4,7 +4,7 @@
  * IRQ helper macros for spear13xx machine family
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/mach-spear13xx/include/mach/spear.h b/arch/arm/mach-spear13xx/include/mach/spear.h
index 30c57ef..65f27de 100644
--- a/arch/arm/mach-spear13xx/include/mach/spear.h
+++ b/arch/arm/mach-spear13xx/include/mach/spear.h
@@ -4,7 +4,7 @@
  * spear13xx Machine family specific definition
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/mach-spear13xx/include/mach/timex.h b/arch/arm/mach-spear13xx/include/mach/timex.h
index 31af3e8..3a58b82 100644
--- a/arch/arm/mach-spear13xx/include/mach/timex.h
+++ b/arch/arm/mach-spear13xx/include/mach/timex.h
@@ -4,7 +4,7 @@
  * SPEAr3XX machine family specific timex definitions
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/mach-spear13xx/include/mach/uncompress.h b/arch/arm/mach-spear13xx/include/mach/uncompress.h
index c784089..70fe72f 100644
--- a/arch/arm/mach-spear13xx/include/mach/uncompress.h
+++ b/arch/arm/mach-spear13xx/include/mach/uncompress.h
@@ -4,7 +4,7 @@
  * Serial port stubs for kernel decompress status messages
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/mach-spear13xx/spear1310.c b/arch/arm/mach-spear13xx/spear1310.c
index fefd15b..732d29b 100644
--- a/arch/arm/mach-spear13xx/spear1310.c
+++ b/arch/arm/mach-spear13xx/spear1310.c
@@ -4,7 +4,7 @@
  * SPEAr1310 machine source file
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/mach-spear13xx/spear1340.c b/arch/arm/mach-spear13xx/spear1340.c
index ee38cbc..81e4ed7 100644
--- a/arch/arm/mach-spear13xx/spear1340.c
+++ b/arch/arm/mach-spear13xx/spear1340.c
@@ -4,7 +4,7 @@
  * SPEAr1340 machine source file
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/mach-spear13xx/spear13xx.c b/arch/arm/mach-spear13xx/spear13xx.c
index 50b349a..cf936b1 100644
--- a/arch/arm/mach-spear13xx/spear13xx.c
+++ b/arch/arm/mach-spear13xx/spear13xx.c
@@ -4,7 +4,7 @@
  * SPEAr13XX machines common source file
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/mach-spear3xx/include/mach/debug-macro.S b/arch/arm/mach-spear3xx/include/mach/debug-macro.S
index 590519f..0a6381f 100644
--- a/arch/arm/mach-spear3xx/include/mach/debug-macro.S
+++ b/arch/arm/mach-spear3xx/include/mach/debug-macro.S
@@ -4,7 +4,7 @@
  * Debugging macro include header spear3xx machine family
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar<viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/mach-spear3xx/include/mach/generic.h b/arch/arm/mach-spear3xx/include/mach/generic.h
index 4a95b94..ce19113 100644
--- a/arch/arm/mach-spear3xx/include/mach/generic.h
+++ b/arch/arm/mach-spear3xx/include/mach/generic.h
@@ -4,7 +4,7 @@
  * SPEAr3XX machine family generic header file
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar<viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/mach-spear3xx/include/mach/gpio.h b/arch/arm/mach-spear3xx/include/mach/gpio.h
index 451b208..2ac74c6 100644
--- a/arch/arm/mach-spear3xx/include/mach/gpio.h
+++ b/arch/arm/mach-spear3xx/include/mach/gpio.h
@@ -4,7 +4,7 @@
  * GPIO macros for SPEAr3xx machine family
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar<viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/mach-spear3xx/include/mach/irqs.h b/arch/arm/mach-spear3xx/include/mach/irqs.h
index 51bd62a..803de76 100644
--- a/arch/arm/mach-spear3xx/include/mach/irqs.h
+++ b/arch/arm/mach-spear3xx/include/mach/irqs.h
@@ -4,7 +4,7 @@
  * IRQ helper macros for SPEAr3xx machine family
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/mach-spear3xx/include/mach/misc_regs.h b/arch/arm/mach-spear3xx/include/mach/misc_regs.h
index 18e2ac5..6309bf6 100644
--- a/arch/arm/mach-spear3xx/include/mach/misc_regs.h
+++ b/arch/arm/mach-spear3xx/include/mach/misc_regs.h
@@ -4,7 +4,7 @@
  * Miscellaneous registers definitions for SPEAr3xx machine family
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/mach-spear3xx/include/mach/spear.h b/arch/arm/mach-spear3xx/include/mach/spear.h
index 51eb953..8cca951 100644
--- a/arch/arm/mach-spear3xx/include/mach/spear.h
+++ b/arch/arm/mach-spear3xx/include/mach/spear.h
@@ -4,7 +4,7 @@
  * SPEAr3xx Machine family specific definition
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/mach-spear3xx/include/mach/timex.h b/arch/arm/mach-spear3xx/include/mach/timex.h
index a38cc9d..9f5d08b 100644
--- a/arch/arm/mach-spear3xx/include/mach/timex.h
+++ b/arch/arm/mach-spear3xx/include/mach/timex.h
@@ -4,7 +4,7 @@
  * SPEAr3XX machine family specific timex definitions
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/mach-spear3xx/include/mach/uncompress.h b/arch/arm/mach-spear3xx/include/mach/uncompress.h
index 53ba8bb..b909b01 100644
--- a/arch/arm/mach-spear3xx/include/mach/uncompress.h
+++ b/arch/arm/mach-spear3xx/include/mach/uncompress.h
@@ -4,7 +4,7 @@
  * Serial port stubs for kernel decompress status messages
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/mach-spear3xx/spear300.c b/arch/arm/mach-spear3xx/spear300.c
index f74a05b..0f882ec 100644
--- a/arch/arm/mach-spear3xx/spear300.c
+++ b/arch/arm/mach-spear3xx/spear300.c
@@ -4,7 +4,7 @@
  * SPEAr300 machine source file
  *
  * Copyright (C) 2009-2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/mach-spear3xx/spear310.c b/arch/arm/mach-spear3xx/spear310.c
index 84dfb09..bbcf457 100644
--- a/arch/arm/mach-spear3xx/spear310.c
+++ b/arch/arm/mach-spear3xx/spear310.c
@@ -4,7 +4,7 @@
  * SPEAr310 machine source file
  *
  * Copyright (C) 2009-2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/mach-spear3xx/spear320.c b/arch/arm/mach-spear3xx/spear320.c
index a88fa84..88d483b 100644
--- a/arch/arm/mach-spear3xx/spear320.c
+++ b/arch/arm/mach-spear3xx/spear320.c
@@ -4,7 +4,7 @@
  * SPEAr320 machine source file
  *
  * Copyright (C) 2009-2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/mach-spear3xx/spear3xx.c b/arch/arm/mach-spear3xx/spear3xx.c
index f22419e..0f41bd1 100644
--- a/arch/arm/mach-spear3xx/spear3xx.c
+++ b/arch/arm/mach-spear3xx/spear3xx.c
@@ -4,7 +4,7 @@
  * SPEAr3XX machines common source file
  *
  * Copyright (C) 2009-2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/mach-spear6xx/include/mach/gpio.h b/arch/arm/mach-spear6xx/include/mach/gpio.h
index 3a789db..d42cefc 100644
--- a/arch/arm/mach-spear6xx/include/mach/gpio.h
+++ b/arch/arm/mach-spear6xx/include/mach/gpio.h
@@ -4,7 +4,7 @@
  * GPIO macros for SPEAr6xx machine family
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/mach-spear6xx/include/mach/misc_regs.h b/arch/arm/mach-spear6xx/include/mach/misc_regs.h
index 179e457..c34acc2 100644
--- a/arch/arm/mach-spear6xx/include/mach/misc_regs.h
+++ b/arch/arm/mach-spear6xx/include/mach/misc_regs.h
@@ -4,7 +4,7 @@
  * Miscellaneous registers definitions for SPEAr6xx machine family
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/plat-spear/include/plat/debug-macro.S b/arch/arm/plat-spear/include/plat/debug-macro.S
index ab3de72..75b05ad 100644
--- a/arch/arm/plat-spear/include/plat/debug-macro.S
+++ b/arch/arm/plat-spear/include/plat/debug-macro.S
@@ -4,7 +4,7 @@
  * Debugging macro include header for spear platform
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/plat-spear/include/plat/pl080.h b/arch/arm/plat-spear/include/plat/pl080.h
index e14a3e4..2bc6b54 100644
--- a/arch/arm/plat-spear/include/plat/pl080.h
+++ b/arch/arm/plat-spear/include/plat/pl080.h
@@ -4,7 +4,7 @@
  * DMAC pl080 definitions for SPEAr platform
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/plat-spear/include/plat/shirq.h b/arch/arm/plat-spear/include/plat/shirq.h
index 03ed8b5..88a7fbd 100644
--- a/arch/arm/plat-spear/include/plat/shirq.h
+++ b/arch/arm/plat-spear/include/plat/shirq.h
@@ -4,7 +4,7 @@
  * SPEAr platform shared irq layer header file
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/plat-spear/include/plat/timex.h b/arch/arm/plat-spear/include/plat/timex.h
index 914d09d..ef95e5b 100644
--- a/arch/arm/plat-spear/include/plat/timex.h
+++ b/arch/arm/plat-spear/include/plat/timex.h
@@ -4,7 +4,7 @@
  * SPEAr platform specific timex definitions
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/plat-spear/include/plat/uncompress.h b/arch/arm/plat-spear/include/plat/uncompress.h
index 6dd455b..2ce6cb1 100644
--- a/arch/arm/plat-spear/include/plat/uncompress.h
+++ b/arch/arm/plat-spear/include/plat/uncompress.h
@@ -4,7 +4,7 @@
  * Serial port stubs for kernel decompress status messages
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/plat-spear/pl080.c b/arch/arm/plat-spear/pl080.c
index a56a067..12cf27f 100644
--- a/arch/arm/plat-spear/pl080.c
+++ b/arch/arm/plat-spear/pl080.c
@@ -4,7 +4,7 @@
  * DMAC pl080 definitions for SPEAr platform
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/plat-spear/restart.c b/arch/arm/plat-spear/restart.c
index ea0a613..4f99011 100644
--- a/arch/arm/plat-spear/restart.c
+++ b/arch/arm/plat-spear/restart.c
@@ -4,7 +4,7 @@
  * SPEAr platform specific restart functions
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/arch/arm/plat-spear/shirq.c b/arch/arm/plat-spear/shirq.c
index 961fb72..853e891 100644
--- a/arch/arm/plat-spear/shirq.c
+++ b/arch/arm/plat-spear/shirq.c
@@ -4,7 +4,7 @@
  * SPEAr platform shared irq layer source file
  *
  * Copyright (C) 2009 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
index b943be0..bfaa5cb 100644
--- a/drivers/ata/pata_arasan_cf.c
+++ b/drivers/ata/pata_arasan_cf.c
@@ -4,7 +4,7 @@
  * Arasan Compact Flash host controller source file
  *
  * Copyright (C) 2011 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
@@ -947,7 +947,7 @@ static struct platform_driver arasan_cf_driver = {

 module_platform_driver(arasan_cf_driver);

-MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
+MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
 MODULE_DESCRIPTION("Arasan ATA Compact Flash driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:" DRIVER_NAME);
diff --git a/drivers/clk/spear/clk-aux-synth.c b/drivers/clk/spear/clk-aux-synth.c
index af34074..6756e7c 100644
--- a/drivers/clk/spear/clk-aux-synth.c
+++ b/drivers/clk/spear/clk-aux-synth.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/drivers/clk/spear/clk-frac-synth.c b/drivers/clk/spear/clk-frac-synth.c
index 4dbdb3f..958aa3a 100644
--- a/drivers/clk/spear/clk-frac-synth.c
+++ b/drivers/clk/spear/clk-frac-synth.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/drivers/clk/spear/clk-gpt-synth.c b/drivers/clk/spear/clk-gpt-synth.c
index b471c97..1afc18c 100644
--- a/drivers/clk/spear/clk-gpt-synth.c
+++ b/drivers/clk/spear/clk-gpt-synth.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/drivers/clk/spear/clk-vco-pll.c b/drivers/clk/spear/clk-vco-pll.c
index dcd4bdf..5f1b6ba 100644
--- a/drivers/clk/spear/clk-vco-pll.c
+++ b/drivers/clk/spear/clk-vco-pll.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/drivers/clk/spear/clk.c b/drivers/clk/spear/clk.c
index 376d4e5..7cd6378 100644
--- a/drivers/clk/spear/clk.c
+++ b/drivers/clk/spear/clk.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/drivers/clk/spear/clk.h b/drivers/clk/spear/clk.h
index 3321c46..9317376 100644
--- a/drivers/clk/spear/clk.h
+++ b/drivers/clk/spear/clk.h
@@ -2,7 +2,7 @@
  * Clock framework definitions for SPEAr platform
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/drivers/clk/spear/spear1310_clock.c b/drivers/clk/spear/spear1310_clock.c
index 42b68df..8f05652 100644
--- a/drivers/clk/spear/spear1310_clock.c
+++ b/drivers/clk/spear/spear1310_clock.c
@@ -4,7 +4,7 @@
  * SPEAr1310 machine clock framework source file
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/drivers/clk/spear/spear1340_clock.c b/drivers/clk/spear/spear1340_clock.c
index f130919..e3ea721 100644
--- a/drivers/clk/spear/spear1340_clock.c
+++ b/drivers/clk/spear/spear1340_clock.c
@@ -4,7 +4,7 @@
  * SPEAr1340 machine clock framework source file
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/drivers/clk/spear/spear3xx_clock.c b/drivers/clk/spear/spear3xx_clock.c
index 440bb3e..01dd6da 100644
--- a/drivers/clk/spear/spear3xx_clock.c
+++ b/drivers/clk/spear/spear3xx_clock.c
@@ -2,7 +2,7 @@
  * SPEAr3xx machines clock framework source file
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/drivers/clk/spear/spear6xx_clock.c b/drivers/clk/spear/spear6xx_clock.c
index f9a20b3..554d64b 100644
--- a/drivers/clk/spear/spear6xx_clock.c
+++ b/drivers/clk/spear/spear6xx_clock.c
@@ -2,7 +2,7 @@
  * SPEAr6xx machines clock framework source file
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index e23dc82..7212961 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1626,4 +1626,4 @@ module_exit(dw_exit);
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("Synopsys DesignWare DMA Controller driver");
 MODULE_AUTHOR("Haavard Skinnemoen (Atmel)");
-MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
+MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
diff --git a/drivers/mfd/stmpe-i2c.c b/drivers/mfd/stmpe-i2c.c
index 373f423..947a06a 100644
--- a/drivers/mfd/stmpe-i2c.c
+++ b/drivers/mfd/stmpe-i2c.c
@@ -6,7 +6,7 @@
  *
  * License Terms: GNU General Public License, version 2
  * Author: Rabin Vincent <rabin.vincent@stericsson.com> for ST-Ericsson
- * Author: Viresh Kumar <viresh.kumar@st.com> for ST Microelectronics
+ * Author: Viresh Kumar <viresh.linux@gmail.com> for ST Microelectronics
  */

 #include <linux/i2c.h>
diff --git a/drivers/mfd/stmpe-spi.c b/drivers/mfd/stmpe-spi.c
index afd4590..9edfe86 100644
--- a/drivers/mfd/stmpe-spi.c
+++ b/drivers/mfd/stmpe-spi.c
@@ -4,7 +4,7 @@
  * Copyright (C) ST Microelectronics SA 2011
  *
  * License Terms: GNU General Public License, version 2
- * Author: Viresh Kumar <viresh.kumar@st.com> for ST Microelectronics
+ * Author: Viresh Kumar <viresh.linux@gmail.com> for ST Microelectronics
  */

 #include <linux/spi/spi.h>
@@ -146,4 +146,4 @@ module_exit(stmpe_exit);

 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("STMPE MFD SPI Interface Driver");
-MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
+MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
diff --git a/drivers/mmc/host/sdhci-spear.c b/drivers/mmc/host/sdhci-spear.c
index 1fe32df..423da81 100644
--- a/drivers/mmc/host/sdhci-spear.c
+++ b/drivers/mmc/host/sdhci-spear.c
@@ -4,7 +4,7 @@
  * Support of SDHCI platform devices for spear soc family
  *
  * Copyright (C) 2010 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * Inspired by sdhci-pltfm.c
  *
@@ -289,5 +289,5 @@ static struct platform_driver sdhci_driver = {
 module_platform_driver(sdhci_driver);

 MODULE_DESCRIPTION("SPEAr Secure Digital Host Controller Interface driver");
-MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
+MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/pinctrl/spear/pinctrl-spear.c b/drivers/pinctrl/spear/pinctrl-spear.c
index 5ae50aa..b3f6b28 100644
--- a/drivers/pinctrl/spear/pinctrl-spear.c
+++ b/drivers/pinctrl/spear/pinctrl-spear.c
@@ -2,7 +2,7 @@
  * Driver for the ST Microelectronics SPEAr pinmux
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * Inspired from:
  * - U300 Pinctl drivers
diff --git a/drivers/pinctrl/spear/pinctrl-spear.h b/drivers/pinctrl/spear/pinctrl-spear.h
index 9155783..d950eb7 100644
--- a/drivers/pinctrl/spear/pinctrl-spear.h
+++ b/drivers/pinctrl/spear/pinctrl-spear.h
@@ -2,7 +2,7 @@
  * Driver header file for the ST Microelectronics SPEAr pinmux
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/drivers/pinctrl/spear/pinctrl-spear1310.c b/drivers/pinctrl/spear/pinctrl-spear1310.c
index fff168b..d6cca8c 100644
--- a/drivers/pinctrl/spear/pinctrl-spear1310.c
+++ b/drivers/pinctrl/spear/pinctrl-spear1310.c
@@ -2,7 +2,7 @@
  * Driver for the ST Microelectronics SPEAr1310 pinmux
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
@@ -2192,7 +2192,7 @@ static void __exit spear1310_pinctrl_exit(void)
 }
 module_exit(spear1310_pinctrl_exit);

-MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
+MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
 MODULE_DESCRIPTION("ST Microelectronics SPEAr1310 pinctrl driver");
 MODULE_LICENSE("GPL v2");
 MODULE_DEVICE_TABLE(of, spear1310_pinctrl_of_match);
diff --git a/drivers/pinctrl/spear/pinctrl-spear1340.c b/drivers/pinctrl/spear/pinctrl-spear1340.c
index a8ab2a6..a0eb057 100644
--- a/drivers/pinctrl/spear/pinctrl-spear1340.c
+++ b/drivers/pinctrl/spear/pinctrl-spear1340.c
@@ -2,7 +2,7 @@
  * Driver for the ST Microelectronics SPEAr1340 pinmux
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
@@ -1983,7 +1983,7 @@ static void __exit spear1340_pinctrl_exit(void)
 }
 module_exit(spear1340_pinctrl_exit);

-MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
+MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
 MODULE_DESCRIPTION("ST Microelectronics SPEAr1340 pinctrl driver");
 MODULE_LICENSE("GPL v2");
 MODULE_DEVICE_TABLE(of, spear1340_pinctrl_of_match);
diff --git a/drivers/pinctrl/spear/pinctrl-spear300.c b/drivers/pinctrl/spear/pinctrl-spear300.c
index 9c82a35..4dfc284 100644
--- a/drivers/pinctrl/spear/pinctrl-spear300.c
+++ b/drivers/pinctrl/spear/pinctrl-spear300.c
@@ -2,7 +2,7 @@
  * Driver for the ST Microelectronics SPEAr300 pinmux
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
@@ -702,7 +702,7 @@ static void __exit spear300_pinctrl_exit(void)
 }
 module_exit(spear300_pinctrl_exit);

-MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
+MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
 MODULE_DESCRIPTION("ST Microelectronics SPEAr300 pinctrl driver");
 MODULE_LICENSE("GPL v2");
 MODULE_DEVICE_TABLE(of, spear300_pinctrl_of_match);
diff --git a/drivers/pinctrl/spear/pinctrl-spear310.c b/drivers/pinctrl/spear/pinctrl-spear310.c
index 1a97076..9688369 100644
--- a/drivers/pinctrl/spear/pinctrl-spear310.c
+++ b/drivers/pinctrl/spear/pinctrl-spear310.c
@@ -2,7 +2,7 @@
  * Driver for the ST Microelectronics SPEAr310 pinmux
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
@@ -425,7 +425,7 @@ static void __exit spear310_pinctrl_exit(void)
 }
 module_exit(spear310_pinctrl_exit);

-MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
+MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
 MODULE_DESCRIPTION("ST Microelectronics SPEAr310 pinctrl driver");
 MODULE_LICENSE("GPL v2");
 MODULE_DEVICE_TABLE(of, SPEAr310_pinctrl_of_match);
diff --git a/drivers/pinctrl/spear/pinctrl-spear320.c b/drivers/pinctrl/spear/pinctrl-spear320.c
index de726e6..020b1e0 100644
--- a/drivers/pinctrl/spear/pinctrl-spear320.c
+++ b/drivers/pinctrl/spear/pinctrl-spear320.c
@@ -2,7 +2,7 @@
  * Driver for the ST Microelectronics SPEAr320 pinmux
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
@@ -3462,7 +3462,7 @@ static void __exit spear320_pinctrl_exit(void)
 }
 module_exit(spear320_pinctrl_exit);

-MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
+MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
 MODULE_DESCRIPTION("ST Microelectronics SPEAr320 pinctrl driver");
 MODULE_LICENSE("GPL v2");
 MODULE_DEVICE_TABLE(of, spear320_pinctrl_of_match);
diff --git a/drivers/pinctrl/spear/pinctrl-spear3xx.c b/drivers/pinctrl/spear/pinctrl-spear3xx.c
index 91c883b..0242378 100644
--- a/drivers/pinctrl/spear/pinctrl-spear3xx.c
+++ b/drivers/pinctrl/spear/pinctrl-spear3xx.c
@@ -2,7 +2,7 @@
  * Driver for the ST Microelectronics SPEAr3xx pinmux
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/drivers/pinctrl/spear/pinctrl-spear3xx.h b/drivers/pinctrl/spear/pinctrl-spear3xx.h
index 5d5fdd8..31f4434 100644
--- a/drivers/pinctrl/spear/pinctrl-spear3xx.h
+++ b/drivers/pinctrl/spear/pinctrl-spear3xx.h
@@ -2,7 +2,7 @@
  * Header file for the ST Microelectronics SPEAr3xx pinmux
  *
  * Copyright (C) 2012 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/drivers/watchdog/sp805_wdt.c b/drivers/watchdog/sp805_wdt.c
index afcd136..e4841c3 100644
--- a/drivers/watchdog/sp805_wdt.c
+++ b/drivers/watchdog/sp805_wdt.c
@@ -4,7 +4,7 @@
  * Watchdog driver for ARM SP805 watchdog module
  *
  * Copyright (C) 2010 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2 or later. This program is licensed "as is" without any
@@ -331,6 +331,6 @@ static struct amba_driver sp805_wdt_driver = {

 module_amba_driver(sp805_wdt_driver);

-MODULE_AUTHOR("Viresh Kumar <viresh.kumar@st.com>");
+MODULE_AUTHOR("Viresh Kumar <viresh.linux@gmail.com>");
 MODULE_DESCRIPTION("ARM SP805 Watchdog Driver");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/mmc/sdhci-spear.h b/include/linux/mmc/sdhci-spear.h
index 5cdc96d..e78c0e2 100644
--- a/include/linux/mmc/sdhci-spear.h
+++ b/include/linux/mmc/sdhci-spear.h
@@ -4,7 +4,7 @@
  * SDHCI declarations specific to ST SPEAr platform
  *
  * Copyright (C) 2010 ST Microelectronics
- * Viresh Kumar<viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
diff --git a/include/linux/pata_arasan_cf_data.h b/include/linux/pata_arasan_cf_data.h
index a6ee9aa..a7b4fc3 100644
--- a/include/linux/pata_arasan_cf_data.h
+++ b/include/linux/pata_arasan_cf_data.h
@@ -4,7 +4,7 @@
  * Arasan Compact Flash host controller platform data header file
  *
  * Copyright (C) 2011 ST Microelectronics
- * Viresh Kumar <viresh.kumar@st.com>
+ * Viresh Kumar <viresh.linux@gmail.com>
  *
  * This file is licensed under the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
--
1.7.11.rc1.9.gf623ca1


-- IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium.  Thank you.

