Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab1EKVHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 17:07:24 -0400
Received: from c-76-97-164-112.hsd1.ga.comcast.net ([76.97.164.112]:55110 "EHLO
	deneb.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756237Ab1EKVHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 17:07:07 -0400
X-Greylist: delayed 3155 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 May 2011 17:06:39 EDT
From: Mark Salter <msalter@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 12/16] C6X: add platform files
Date: Wed, 11 May 2011 16:13:59 -0400
Message-Id: <1305144843-5058-13-git-send-email-msalter@redhat.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1305144843-5058-12-git-send-email-msalter@redhat.com>
References: <1305144843-5058-1-git-send-email-msalter@redhat.com>
 <1305144843-5058-2-git-send-email-msalter@redhat.com>
 <1305144843-5058-3-git-send-email-msalter@redhat.com>
 <1305144843-5058-4-git-send-email-msalter@redhat.com>
 <1305144843-5058-5-git-send-email-msalter@redhat.com>
 <1305144843-5058-6-git-send-email-msalter@redhat.com>
 <1305144843-5058-7-git-send-email-msalter@redhat.com>
 <1305144843-5058-8-git-send-email-msalter@redhat.com>
 <1305144843-5058-9-git-send-email-msalter@redhat.com>
 <1305144843-5058-10-git-send-email-msalter@redhat.com>
 <1305144843-5058-11-git-send-email-msalter@redhat.com>
 <1305144843-5058-12-git-send-email-msalter@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Salter <msalter@redhat.com>
---
 arch/c6x/platforms/Kconfig                       |   63 ++
 arch/c6x/platforms/Makefile                      |   16 +
 arch/c6x/platforms/board-dsk6455.c               |  227 +++++++
 arch/c6x/platforms/board-evm6457.c               |  101 +++
 arch/c6x/platforms/board-evm6472.c               |  144 ++++
 arch/c6x/platforms/board-evm6474.c               |  112 ++++
 arch/c6x/platforms/board-evm6474lite.c           |  110 ++++
 arch/c6x/platforms/include/mach/board-dsk6455.h  |   53 ++
 arch/c6x/platforms/include/mach/board-evm6457.h  |   25 +
 arch/c6x/platforms/include/mach/board-evm6472.h  |   23 +
 arch/c6x/platforms/include/mach/board-evm6474.h  |   23 +
 arch/c6x/platforms/include/mach/board-evm6474l.h |   23 +
 arch/c6x/platforms/include/mach/board.h          |   32 +
 arch/c6x/platforms/include/mach/cache.h          |  104 +++
 arch/c6x/platforms/include/mach/dscr.h           |  184 ++++++
 arch/c6x/platforms/include/mach/emif.h           |   63 ++
 arch/c6x/platforms/include/mach/gemac.h          |  763 ++++++++++++++++++++++
 arch/c6x/platforms/include/mach/gmdio.h          |   18 +
 arch/c6x/platforms/include/mach/hardware.h       |  194 ++++++
 arch/c6x/platforms/include/mach/irq-c645x.h      |  131 ++++
 arch/c6x/platforms/include/mach/irq-c6472.h      |  138 ++++
 arch/c6x/platforms/include/mach/irq-c6474.h      |  323 +++++++++
 arch/c6x/platforms/include/mach/irq.h            |   52 ++
 arch/c6x/platforms/include/mach/pll.h            |  134 ++++
 arch/c6x/platforms/include/mach/timer.h          |  104 +++
 arch/c6x/platforms/phy.c                         |  141 ++++
 arch/c6x/platforms/platform-c64xx.c              |  439 +++++++++++++
 arch/c6x/platforms/sgmii.c                       |   83 +++
 28 files changed, 3823 insertions(+), 0 deletions(-)
 create mode 100644 arch/c6x/platforms/Kconfig
 create mode 100644 arch/c6x/platforms/Makefile
 create mode 100644 arch/c6x/platforms/board-dsk6455.c
 create mode 100644 arch/c6x/platforms/board-evm6457.c
 create mode 100644 arch/c6x/platforms/board-evm6472.c
 create mode 100644 arch/c6x/platforms/board-evm6474.c
 create mode 100644 arch/c6x/platforms/board-evm6474lite.c
 create mode 100644 arch/c6x/platforms/include/mach/board-dsk6455.h
 create mode 100644 arch/c6x/platforms/include/mach/board-evm6457.h
 create mode 100644 arch/c6x/platforms/include/mach/board-evm6472.h
 create mode 100644 arch/c6x/platforms/include/mach/board-evm6474.h
 create mode 100644 arch/c6x/platforms/include/mach/board-evm6474l.h
 create mode 100644 arch/c6x/platforms/include/mach/board.h
 create mode 100644 arch/c6x/platforms/include/mach/cache.h
 create mode 100644 arch/c6x/platforms/include/mach/dscr.h
 create mode 100644 arch/c6x/platforms/include/mach/emif.h
 create mode 100644 arch/c6x/platforms/include/mach/gemac.h
 create mode 100644 arch/c6x/platforms/include/mach/gmdio.h
 create mode 100644 arch/c6x/platforms/include/mach/hardware.h
 create mode 100644 arch/c6x/platforms/include/mach/irq-c645x.h
 create mode 100644 arch/c6x/platforms/include/mach/irq-c6472.h
 create mode 100644 arch/c6x/platforms/include/mach/irq-c6474.h
 create mode 100644 arch/c6x/platforms/include/mach/irq.h
 create mode 100644 arch/c6x/platforms/include/mach/pll.h
 create mode 100644 arch/c6x/platforms/include/mach/timer.h
 create mode 100644 arch/c6x/platforms/phy.c
 create mode 100644 arch/c6x/platforms/platform-c64xx.c
 create mode 100644 arch/c6x/platforms/sgmii.c

diff --git a/arch/c6x/platforms/Kconfig b/arch/c6x/platforms/Kconfig
new file mode 100644
index 0000000..a271f0f
--- /dev/null
+++ b/arch/c6x/platforms/Kconfig
@@ -0,0 +1,63 @@
+
+config SOC_TMS320C6455
+	bool "TMS320C6455"
+	default n
+	select TMS320C64XPLUS
+	select PLL_TCI648X
+	select TIMER_TCI648X
+	select PIC_C64XPLUS
+
+config SOC_TMS320C6457
+	bool "TMS320C6457"
+	default n
+	select TMS320C64XPLUS
+	select PLL_TCI648X
+	select TIMER_TCI648X
+	select PIC_C64XPLUS
+	select SGMII
+
+config SOC_TMS320C6472
+	bool "TMS320C6472"
+	default n
+	select TMS320C64XPLUS
+	select PLL_TCI648X
+	select TIMER_TCI648X
+	select PIC_C64XPLUS
+
+config SOC_TMS320C6474
+	bool "TMS320C6474"
+	default n
+	select TMS320C64XPLUS
+	select PLL_TCI648X
+	select TIMER_TCI648X
+	select PIC_C64XPLUS
+	select SGMII
+
+comment "Board Selection"
+choice
+	prompt "Board"
+	help
+	  This option specifies the specific board for which the kernel will be
+	  compiled.
+
+config ARCH_BOARD_DSK6455
+	bool "DSK6455"
+	select SOC_TMS320C6455
+
+config ARCH_BOARD_EVM6457
+	bool "EVM6472"
+	select SOC_TMS320C6457
+
+config ARCH_BOARD_EVM6472
+	bool "EVM6472"
+	select SOC_TMS320C6472
+
+config ARCH_BOARD_EVM6474
+	bool "EVM6474"
+	select SOC_TMS320C6474
+
+config ARCH_BOARD_EVM6474L
+	bool "EVM6474L"
+	select SOC_TMS320C6474
+
+endchoice
diff --git a/arch/c6x/platforms/Makefile b/arch/c6x/platforms/Makefile
new file mode 100644
index 0000000..da0f247
--- /dev/null
+++ b/arch/c6x/platforms/Makefile
@@ -0,0 +1,16 @@
+#
+# Makefile for arch/c6x/platforms
+#
+# Copyright 2010, 2011 Texas Instruments Incorporated
+#
+
+obj-$(CONFIG_TMS320C6X) += platform-c64xx.o
+
+obj-$(CONFIG_SGMII)		+= sgmii.o
+
+# Board objects
+obj-$(CONFIG_ARCH_BOARD_DSK6455)  += board-dsk6455.o
+obj-$(CONFIG_ARCH_BOARD_EVM6457)  += board-evm6457.o phy.o
+obj-$(CONFIG_ARCH_BOARD_EVM6472)  += board-evm6472.o phy.o
+obj-$(CONFIG_ARCH_BOARD_EVM6474)  += board-evm6474.o phy.o
+obj-$(CONFIG_ARCH_BOARD_EVM6474L) += board-evm6474lite.o phy.o
diff --git a/arch/c6x/platforms/board-dsk6455.c b/arch/c6x/platforms/board-dsk6455.c
new file mode 100644
index 0000000..03cca20
--- /dev/null
+++ b/arch/c6x/platforms/board-dsk6455.c
@@ -0,0 +1,227 @@
+/*
+ *  linux/arch/c6x/platforms/board-dsk6455.c
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2008, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@virtuallogix.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#include <linux/delay.h>
+#include <linux/platform_device.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/map.h>
+#include <linux/mtd/partitions.h>
+
+#include <asm/clock.h>
+#include <mach/dscr.h>
+#include <mach/board.h>
+#include <mach/emif.h>
+
+/*
+ * Resources present on the DSK6455 board
+ */
+static struct resource _flash_res = {
+	.name  = "Flash",
+	.start = 0xb0000000,
+	.end   = 0xbfffffff,
+	.flags = IORESOURCE_MEM,
+};
+static struct resource _cpld_async_res = {
+	.name  = "CPLD async",
+	.start = 0xa0000000,
+	.end   = 0xa0000008,
+	.flags = IORESOURCE_MEM,
+};
+
+#define NR_RESOURCES 2
+static struct resource *dsk_resources[NR_RESOURCES] = {
+	&_flash_res, &_cpld_async_res
+};
+
+
+/*----------------------------------------------------------------------*/
+
+
+static struct pll_data pll1_data = {
+	.num	   = 1,
+	.phys_base = ARCH_PLL1_BASE,
+};
+
+static struct clk clkin1 = {
+	.name = "clkin1",
+	.rate = 50000000,
+	.node = LIST_HEAD_INIT(clkin1.node),
+	.children = LIST_HEAD_INIT(clkin1.children),
+	.childnode = LIST_HEAD_INIT(clkin1.childnode),
+};
+
+static struct clk pll1_clk = {
+	.name = "pll1",
+	.parent = &clkin1,
+	.pll_data = &pll1_data,
+	.flags = CLK_PLL | PLL_HAS_PREDIV,
+};
+
+static struct clk pll1_sysclk2 = {
+	.name = "pll1_sysclk2",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL | FIXED_DIV_PLL,
+	.div = 3,
+};
+
+static struct clk pll1_sysclk3 = {
+	.name = "pll1_sysclk3",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL | FIXED_DIV_PLL,
+	.div = 6,
+};
+
+static struct clk pll1_sysclk4 = {
+	.name = "pll1_sysclk4",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL,
+	.div = PLLDIV4,
+};
+
+static struct clk pll1_sysclk5 = {
+	.name = "pll1_sysclk5",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL,
+	.div = PLLDIV5,
+};
+
+static struct clk watchdog_clk = {
+	.name = "watchdog",
+	.parent = &pll1_sysclk3,
+};
+
+static struct clk core_clk = {
+	.name = "core",
+	.parent = &pll1_clk,
+};
+
+static struct clk_lookup evm_clks[] = {
+	CLK(NULL, "pll1", &pll1_clk),
+	CLK(NULL, "pll1_sysclk2", &pll1_sysclk2),
+	CLK(NULL, "pll1_sysclk3", &pll1_sysclk3),
+	CLK(NULL, "pll1_sysclk4", &pll1_sysclk4),
+	CLK(NULL, "pll1_sysclk5", &pll1_sysclk5),
+	CLK(NULL, "core", &core_clk),
+	CLK("watchdog", NULL, &watchdog_clk),
+	CLK("", NULL, NULL)
+};
+
+/* Called from arch/kernel/setup.c */
+void c6x_board_setup_arch(void)
+{
+	int i;
+
+	printk(KERN_INFO "Designed for the DSK6455, Spectrum Digital Inc.\n");
+
+	/* Bootloader may not have setup EMIFA, so we do it here just in case */
+	DSCR_PERCFG1 = 3;
+	__delay(100);
+
+	/* CPLD */
+	EMIFA_CE2CFG = EMIFA_CFG_ASYNC |
+		       EMIFA_CFG_W_SETUP(1)   |
+		       EMIFA_CFG_W_STROBE(10) |
+		       EMIFA_CFG_W_HOLD(1)    |
+		       EMIFA_CFG_R_SETUP(1)   |
+		       EMIFA_CFG_R_STROBE(10) |
+		       EMIFA_CFG_R_HOLD(1)    |
+		       EMIFA_CFG_WIDTH_8;
+
+	/* NOR Flash */
+	EMIFA_CE3CFG = EMIFA_CFG_ASYNC |
+		       EMIFA_CFG_W_SETUP(1)   |
+		       EMIFA_CFG_W_STROBE(10) |
+		       EMIFA_CFG_W_HOLD(1)    |
+		       EMIFA_CFG_R_SETUP(1)   |
+		       EMIFA_CFG_R_STROBE(10) |
+		       EMIFA_CFG_R_HOLD(1)    |
+		       EMIFA_CFG_WIDTH_8;
+
+	/* Daughter Card */
+	EMIFA_CE4CFG = EMIFA_CFG_ASYNC |
+		       EMIFA_CFG_W_SETUP(1)   |
+		       EMIFA_CFG_W_STROBE(10) |
+		       EMIFA_CFG_W_HOLD(1)    |
+		       EMIFA_CFG_R_SETUP(1)   |
+		       EMIFA_CFG_R_STROBE(10) |
+		       EMIFA_CFG_R_HOLD(1)    |
+		       EMIFA_CFG_WIDTH_32;
+
+	/* Daughter Card */
+	EMIFA_CE5CFG = EMIFA_CFG_ASYNC |
+		       EMIFA_CFG_W_SETUP(1)   |
+		       EMIFA_CFG_W_STROBE(10) |
+		       EMIFA_CFG_W_HOLD(1)    |
+		       EMIFA_CFG_R_SETUP(1)   |
+		       EMIFA_CFG_R_STROBE(10) |
+		       EMIFA_CFG_R_HOLD(1)    |
+		       EMIFA_CFG_WIDTH_32;
+
+	/* Raise priority of waiting bus commands after 255 transfers */
+	EMIFA_BPRIO = 0xFE;
+
+	/* Initialize DSK6455 resources */
+	iomem_resource.name = "Memory";
+	for (i = 0; i < NR_RESOURCES; i++)
+		request_resource(&iomem_resource, dsk_resources[i]);
+
+	/* Initialize led register */
+	cpld_set_reg(DSK6455_CPLD_USER, 0x0);
+
+	c6x_clk_init(evm_clks);
+}
+
+/*
+ * NOR Flash support.
+ */
+#ifdef CONFIG_MTD
+static struct map_info nor_map = {
+	.name		= "NOR-flash",
+	.phys		= 0xB0000000,
+	.size		= 0x400000,
+	.bankwidth	= 1,
+};
+static struct mtd_info *mymtd;
+#ifdef CONFIG_MTD_PARTITIONS
+static int nr_parts;
+static struct mtd_partition *parts;
+static const char *part_probe_types[] = {
+	"cmdlinepart",
+	NULL
+};
+#endif
+
+static __init int nor_init(void)
+{
+	nor_map.virt = ioremap(nor_map.phys, nor_map.size);
+	simple_map_init(&nor_map);
+	mymtd = do_map_probe("cfi_probe", &nor_map);
+	if (mymtd) {
+		mymtd->owner = THIS_MODULE;
+
+#ifdef CONFIG_MTD_PARTITIONS
+		nr_parts = parse_mtd_partitions(mymtd,
+						part_probe_types,
+						&parts, 0);
+		if (nr_parts > 0)
+			add_mtd_partitions(mymtd, parts, nr_parts);
+		else
+			add_mtd_device(mymtd);
+#else
+		add_mtd_device(mymtd);
+#endif
+	}
+	return 0;
+}
+
+late_initcall(nor_init);
+#endif
diff --git a/arch/c6x/platforms/board-evm6457.c b/arch/c6x/platforms/board-evm6457.c
new file mode 100644
index 0000000..5d440fe
--- /dev/null
+++ b/arch/c6x/platforms/board-evm6457.c
@@ -0,0 +1,101 @@
+/*
+ *  linux/arch/c6x/platforms/board-evm6457.c
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2008, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@virtuallogix.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#include <linux/platform_device.h>
+#include <asm/clock.h>
+#include <mach/board.h>
+
+static struct pll_data pll1_data = {
+	.num	   = 1,
+	.phys_base = ARCH_PLL1_BASE,
+};
+
+static struct clk clkin1 = {
+	.name = "clkin1",
+	.rate = 60000000,
+	.node = LIST_HEAD_INIT(clkin1.node),
+	.children = LIST_HEAD_INIT(clkin1.children),
+	.childnode = LIST_HEAD_INIT(clkin1.childnode),
+};
+
+static struct clk pll1_clk = {
+	.name = "pll1",
+	.parent = &clkin1,
+	.pll_data = &pll1_data,
+	.flags = CLK_PLL,
+};
+
+static struct clk pll1_sysclk1 = {
+	.name = "pll1_sysclk1",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL | FIXED_DIV_PLL,
+	.div = 1,
+};
+
+static struct clk pll1_sysclk2 = {
+	.name = "pll1_sysclk2",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL | FIXED_DIV_PLL,
+	.div = 3,
+};
+
+static struct clk pll1_sysclk3 = {
+	.name = "pll1_sysclk3",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL | FIXED_DIV_PLL,
+	.div = 6,
+};
+
+static struct clk pll1_sysclk4 = {
+	.name = "pll1_sysclk4",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL,
+	.div = PLLDIV4,
+};
+
+static struct clk pll1_sysclk5 = {
+	.name = "pll1_sysclk5",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL,
+	.div = PLLDIV5,
+};
+
+static struct clk core_clk = {
+	.name = "core",
+	.parent = &pll1_sysclk1,
+};
+
+static struct clk watchdog_clk = {
+	.name = "watchdog",
+	.parent = &pll1_sysclk5,
+};
+
+static struct clk_lookup evm_clks[] = {
+	CLK(NULL, "pll1", &pll1_clk),
+	CLK(NULL, "pll1_sysclk1", &pll1_sysclk1),
+	CLK(NULL, "pll1_sysclk2", &pll1_sysclk2),
+	CLK(NULL, "pll1_sysclk3", &pll1_sysclk3),
+	CLK(NULL, "pll1_sysclk4", &pll1_sysclk4),
+	CLK(NULL, "pll1_sysclk5", &pll1_sysclk5),
+	CLK(NULL, "core", &core_clk),
+	CLK("watchdog", NULL, &watchdog_clk),
+	CLK("", NULL, NULL)
+};
+
+/* Called from arch/kernel/setup.c */
+void c6x_board_setup_arch(void)
+{
+	printk(KERN_INFO "Designed for the EVM6457 board, Texas Instruments.\n");
+
+	c6x_clk_init(evm_clks);
+}
+
diff --git a/arch/c6x/platforms/board-evm6472.c b/arch/c6x/platforms/board-evm6472.c
new file mode 100644
index 0000000..ac49019
--- /dev/null
+++ b/arch/c6x/platforms/board-evm6472.c
@@ -0,0 +1,144 @@
+/*
+ *  linux/arch/c6x/platforms/board-evm6472.c
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2008, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@virtuallogix.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#include <linux/platform_device.h>
+#include <asm/clock.h>
+#include <mach/board.h>
+
+/*----------------------------------------------------------------------*/
+
+
+static struct pll_data pll1_data = {
+	.num	   = 1,
+	.phys_base = ARCH_PLL1_BASE,
+};
+
+static struct clk clkin1 = {
+	.name = "clkin1",
+	.rate = 25000000,
+	.node = LIST_HEAD_INIT(clkin1.node),
+	.children = LIST_HEAD_INIT(clkin1.children),
+	.childnode = LIST_HEAD_INIT(clkin1.childnode),
+};
+
+static struct clk pll1_clk = {
+	.name = "pll1",
+	.parent = &clkin1,
+	.pll_data = &pll1_data,
+	.flags = CLK_PLL,
+};
+
+static struct clk pll1_sysclk1 = {
+	.name = "pll1_sysclk1",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL | FIXED_DIV_PLL,
+	.div = 1,
+};
+
+static struct clk pll1_sysclk2 = {
+	.name = "pll1_sysclk2",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL | FIXED_DIV_PLL,
+	.div = 1,
+};
+
+static struct clk pll1_sysclk3 = {
+	.name = "pll1_sysclk3",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL | FIXED_DIV_PLL,
+	.div = 1,
+};
+
+static struct clk pll1_sysclk4 = {
+	.name = "pll1_sysclk4",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL | FIXED_DIV_PLL,
+	.div = 1,
+};
+
+static struct clk pll1_sysclk5 = {
+	.name = "pll1_sysclk5",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL | FIXED_DIV_PLL,
+	.div = 1,
+};
+
+static struct clk pll1_sysclk6 = {
+	.name = "pll1_sysclk6",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL | FIXED_DIV_PLL,
+	.div = 1,
+};
+
+static struct clk pll1_sysclk7 = {
+	.name = "pll1_sysclk7",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL | FIXED_DIV_PLL,
+	.div = 3,
+};
+
+static struct clk pll1_sysclk8 = {
+	.name = "pll1_sysclk8",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL | FIXED_DIV_PLL,
+	.div = 6,
+};
+
+static struct clk pll1_sysclk9 = {
+	.name = "pll1_sysclk9",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL | FIXED_DIV_PLL,
+	.div = 2,
+};
+
+static struct clk pll1_sysclk10 = {
+	.name = "pll1_sysclk10",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL,
+	.div = PLLDIV10,
+};
+
+static struct clk watchdog_clk = {
+	.name = "watchdog",
+	.parent = &pll1_sysclk8,
+};
+
+static struct clk core_clk = {
+	.name = "core",
+	.parent = &pll1_sysclk1,
+};
+
+static struct clk_lookup evm_clks[] = {
+	CLK(NULL, "pll1", &pll1_clk),
+	CLK(NULL, "pll1_sysclk1", &pll1_sysclk1),
+	CLK(NULL, "pll1_sysclk2", &pll1_sysclk2),
+	CLK(NULL, "pll1_sysclk3", &pll1_sysclk3),
+	CLK(NULL, "pll1_sysclk4", &pll1_sysclk4),
+	CLK(NULL, "pll1_sysclk5", &pll1_sysclk5),
+	CLK(NULL, "pll1_sysclk6", &pll1_sysclk6),
+	CLK(NULL, "pll1_sysclk7", &pll1_sysclk7),
+	CLK(NULL, "pll1_sysclk8", &pll1_sysclk8),
+	CLK(NULL, "pll1_sysclk9", &pll1_sysclk9),
+	CLK(NULL, "pll1_sysclk10", &pll1_sysclk10),
+	CLK(NULL, "core", &core_clk),
+	CLK("watchdog", NULL, &watchdog_clk),
+	CLK(NULL, NULL, NULL)
+};
+
+/* Called from arch/kernel/setup.c */
+void c6x_board_setup_arch(void)
+{
+	printk(KERN_INFO "Designed for the EVM6472 board, Texas Instruments.\n");
+
+	c6x_clk_init(evm_clks);
+}
+
diff --git a/arch/c6x/platforms/board-evm6474.c b/arch/c6x/platforms/board-evm6474.c
new file mode 100644
index 0000000..35a616f
--- /dev/null
+++ b/arch/c6x/platforms/board-evm6474.c
@@ -0,0 +1,112 @@
+/*
+ * Copyright (C) 2010, 2011 Texas Instruments Incorporated
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#include <linux/platform_device.h>
+#include <asm/clock.h>
+#include <mach/board.h>
+
+/*----------------------------------------------------------------------*/
+
+static struct pll_data pll1_data = {
+	.num	   = 1,
+	.phys_base = ARCH_PLL1_BASE,
+};
+
+static struct clk clkin1 = {
+	.name = "clkin1",
+/*	.rate = 61440000, This is when using SYSCLK (SW5 CORE_CLOK_SEL to ON) */
+	.rate = 50000000, /* default one is 50MHz clock */
+	.node = LIST_HEAD_INIT(clkin1.node),
+	.children = LIST_HEAD_INIT(clkin1.children),
+	.childnode = LIST_HEAD_INIT(clkin1.childnode),
+};
+
+static struct clk pll1_clk = {
+	.name = "pll1",
+	.parent = &clkin1,
+	.pll_data = &pll1_data,
+	.flags = CLK_PLL,
+};
+
+static struct clk pll1_sysclk7 = {
+	.name = "pll1_sysclk7",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL | FIXED_DIV_PLL,
+	.div = 1,
+};
+
+static struct clk pll1_sysclk9 = {
+	.name = "pll1_sysclk9",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL | FIXED_DIV_PLL,
+	.div = 3,
+};
+
+static struct clk pll1_sysclk10 = {
+	.name = "pll1_sysclk10",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL | FIXED_DIV_PLL,
+	.div = 6,
+};
+
+static struct clk pll1_sysclk11 = {
+	.name = "pll1_sysclk11",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL,
+	.div = PLLDIV11,
+};
+
+static struct clk pll1_sysclk12 = {
+	.name = "pll1_sysclk12",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL | FIXED_DIV_PLL,
+	.div = 2,
+};
+
+static struct clk pll1_sysclk13 = {
+	.name = "pll1_sysclk13",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL,
+	.div = PLLDIV13,
+};
+
+static struct clk core_clk = {
+	.name = "core",
+	.parent = &pll1_sysclk7,
+};
+
+static struct clk watchdog_clk = {
+	.name = "watchdog",
+	.parent = &pll1_sysclk10,
+};
+
+static struct clk_lookup evm_clks[] = {
+	CLK(NULL, "pll1", &pll1_clk),
+	CLK(NULL, "pll1_sysclk7", &pll1_sysclk7),
+	CLK(NULL, "pll1_sysclk9", &pll1_sysclk9),
+	CLK(NULL, "pll1_sysclk10", &pll1_sysclk10),
+	CLK(NULL, "pll1_sysclk11", &pll1_sysclk11),
+	CLK(NULL, "pll1_sysclk12", &pll1_sysclk12),
+	CLK(NULL, "pll1_sysclk13", &pll1_sysclk13),
+	CLK(NULL, "core", &core_clk),
+	CLK("watchdog", NULL, &watchdog_clk),
+	CLK("", NULL, NULL)
+};
+
+/* Called from arch/kernel/setup.c */
+void c6x_board_setup_arch(void)
+{
+	printk(KERN_INFO "Designed for the EVM6474 board, Texas Instruments.\n");
+
+	c6x_clk_init(evm_clks);
+}
+
diff --git a/arch/c6x/platforms/board-evm6474lite.c b/arch/c6x/platforms/board-evm6474lite.c
new file mode 100644
index 0000000..12cd4e3
--- /dev/null
+++ b/arch/c6x/platforms/board-evm6474lite.c
@@ -0,0 +1,110 @@
+/*
+ * Copyright (C) 2010, 2011 Texas Instruments Incorporated
+ * Author: Sandeep Paulraj <s-paulraj@ti.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation version 2.
+ *
+ * This program is distributed "as is" WITHOUT ANY WARRANTY of any
+ * kind, whether express or implied; without even the implied warranty
+ * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+#include <linux/platform_device.h>
+#include <asm/clock.h>
+#include <mach/board.h>
+
+static struct pll_data pll1_data = {
+	.num	   = 1,
+	.phys_base = ARCH_PLL1_BASE,
+};
+
+static struct clk clkin1 = {
+	.name = "clkin1",
+	.rate = 50000000,
+	.node = LIST_HEAD_INIT(clkin1.node),
+	.children = LIST_HEAD_INIT(clkin1.children),
+	.childnode = LIST_HEAD_INIT(clkin1.childnode),
+};
+
+static struct clk pll1_clk = {
+	.name = "pll1",
+	.parent = &clkin1,
+	.pll_data = &pll1_data,
+	.flags = CLK_PLL,
+};
+
+static struct clk pll1_sysclk7 = {
+	.name = "pll1_sysclk7",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL | FIXED_DIV_PLL,
+	.div = 1,
+};
+
+static struct clk pll1_sysclk9 = {
+	.name = "pll1_sysclk9",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL | FIXED_DIV_PLL,
+	.div = 3,
+};
+
+static struct clk pll1_sysclk10 = {
+	.name = "pll1_sysclk10",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL | FIXED_DIV_PLL,
+	.div = 6,
+};
+
+static struct clk pll1_sysclk11 = {
+	.name = "pll1_sysclk11",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL,
+	.div = PLLDIV11,
+};
+
+static struct clk pll1_sysclk12 = {
+	.name = "pll1_sysclk12",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL | FIXED_DIV_PLL,
+	.div = 2,
+};
+
+static struct clk pll1_sysclk13 = {
+	.name = "pll1_sysclk13",
+	.parent = &pll1_clk,
+	.flags = CLK_PLL,
+	.div = PLLDIV13,
+};
+
+static struct clk core_clk = {
+	.name = "core",
+	.parent = &pll1_sysclk7,
+};
+
+static struct clk watchdog_clk = {
+	.name = "watchdog",
+	.parent = &pll1_sysclk10,
+};
+
+static struct clk_lookup evm_clks[] = {
+	CLK(NULL, "pll1", &pll1_clk),
+	CLK(NULL, "pll1_sysclk7", &pll1_sysclk7),
+	CLK(NULL, "pll1_sysclk9", &pll1_sysclk9),
+	CLK(NULL, "pll1_sysclk10", &pll1_sysclk10),
+	CLK(NULL, "pll1_sysclk11", &pll1_sysclk11),
+	CLK(NULL, "pll1_sysclk12", &pll1_sysclk12),
+	CLK(NULL, "pll1_sysclk13", &pll1_sysclk13),
+	CLK(NULL, "core", &core_clk),
+	CLK("watchdog", NULL, &watchdog_clk),
+	CLK("", NULL, NULL)
+};
+
+/* Called from arch/kernel/setup.c */
+void c6x_board_setup_arch(void)
+{
+	printk(KERN_INFO "Designed for the EVM6474 Lite EVM\n");
+
+	c6x_clk_init(evm_clks);
+}
+
diff --git a/arch/c6x/platforms/include/mach/board-dsk6455.h b/arch/c6x/platforms/include/mach/board-dsk6455.h
new file mode 100644
index 0000000..f2d2273
--- /dev/null
+++ b/arch/c6x/platforms/include/mach/board-dsk6455.h
@@ -0,0 +1,53 @@
+/*
+ *  linux/arch/c6x/platforms/mach/board-dsk6455.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2010, 2011 Texas Instruments Incorporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+/*
+ * Board memory
+ */
+#define BOARD_RAM_SIZE	0x08000000
+
+/*
+ * Timer definitions
+ */
+#define LINUX_TIMER_SRC TIMER_1
+#define LINUX_TIMER_IRQ IRQ_TINT1
+
+/*
+ * DSK6455 CPLD registers
+ */
+#define DSK6455_CPLD_REG_BASE  0xa0000000
+
+#define DSK6455_CPLD_USER      0x0
+#define DSK6455_CPLD_DC        0x1
+#define DSK6455_CPLD_VERSION   0x4
+#define DSK6455_CPLD_MISC      0x6
+#define DSK6455_CPLD_MISC2     0x7
+
+#ifndef __ASSEMBLY__
+#define cpld_setbit_reg(reg, val) \
+	(*((volatile unsigned char *) (DSK6455_CPLD_REG_BASE + (reg))) |= \
+	 (unsigned char) (val))
+
+#define cpld_clearbit_reg(reg, val) \
+	(*((volatile unsigned char *) (DSK6455_CPLD_REG_BASE + (reg))) &= \
+	 ~((unsigned char) (val)))
+
+#define cpld_set_reg(reg, val) \
+	(*((volatile unsigned char *) (DSK6455_CPLD_REG_BASE + (reg))) = \
+	 (unsigned char) (val))
+
+#define cpld_get_reg(reg) \
+	(*((volatile unsigned char *) (DSK6455_CPLD_REG_BASE + (reg))))
+
+
+#endif
diff --git a/arch/c6x/platforms/include/mach/board-evm6457.h b/arch/c6x/platforms/include/mach/board-evm6457.h
new file mode 100644
index 0000000..cc6006c
--- /dev/null
+++ b/arch/c6x/platforms/include/mach/board-evm6457.h
@@ -0,0 +1,25 @@
+/*
+ *  linux/arch/c6x/platforms/mach/board-evm6457.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2010, 2011 Texas Instruments Incorporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+/*
+ * Board memory
+ */
+#define BOARD_RAM_SIZE	0x10000000
+
+/*
+ * Timer definitions
+ */
+#define LINUX_TIMER_SRC TIMER_1
+#define LINUX_TIMER_IRQ IRQ_TINT1
+
+
diff --git a/arch/c6x/platforms/include/mach/board-evm6472.h b/arch/c6x/platforms/include/mach/board-evm6472.h
new file mode 100644
index 0000000..5e33d30
--- /dev/null
+++ b/arch/c6x/platforms/include/mach/board-evm6472.h
@@ -0,0 +1,23 @@
+/*
+ *  linux/arch/c6x/platforms/mach/board-evm6472.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2010, 2011 Texas Instruments Incorporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+/*
+ * Board memory
+ */
+#define BOARD_RAM_SIZE	0x10000000
+
+/*
+ * Timer definitions
+ */
+#define LINUX_TIMER_SRC (TIMER_0 + get_coreid())
+#define LINUX_TIMER_IRQ IRQ_TINT
diff --git a/arch/c6x/platforms/include/mach/board-evm6474.h b/arch/c6x/platforms/include/mach/board-evm6474.h
new file mode 100644
index 0000000..a5f8f94
--- /dev/null
+++ b/arch/c6x/platforms/include/mach/board-evm6474.h
@@ -0,0 +1,23 @@
+/*
+ *  linux/arch/c6x/platforms/mach/board-evm6474.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2010, 2011 Texas Instruments Incorporated
+ *  Author: Sandeep Paulraj <s-paulraj@ti.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+/*
+ * Board memory
+ */
+#define BOARD_RAM_SIZE	0x08000000
+
+/*
+ * Timer definitions
+ */
+#define LINUX_TIMER_SRC (TIMER_5 - get_coreid())
+#define LINUX_TIMER_IRQ (IRQ_TINT5 - (get_coreid() << 1))
diff --git a/arch/c6x/platforms/include/mach/board-evm6474l.h b/arch/c6x/platforms/include/mach/board-evm6474l.h
new file mode 100644
index 0000000..a5f8f94
--- /dev/null
+++ b/arch/c6x/platforms/include/mach/board-evm6474l.h
@@ -0,0 +1,23 @@
+/*
+ *  linux/arch/c6x/platforms/mach/board-evm6474.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2010, 2011 Texas Instruments Incorporated
+ *  Author: Sandeep Paulraj <s-paulraj@ti.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+/*
+ * Board memory
+ */
+#define BOARD_RAM_SIZE	0x08000000
+
+/*
+ * Timer definitions
+ */
+#define LINUX_TIMER_SRC (TIMER_5 - get_coreid())
+#define LINUX_TIMER_IRQ (IRQ_TINT5 - (get_coreid() << 1))
diff --git a/arch/c6x/platforms/include/mach/board.h b/arch/c6x/platforms/include/mach/board.h
new file mode 100644
index 0000000..a03dd27
--- /dev/null
+++ b/arch/c6x/platforms/include/mach/board.h
@@ -0,0 +1,32 @@
+/*
+ *  linux/arch/c6x/platforms/mach/board.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2010 Texas Instruments Incorporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef __ASM_C6X_BOARD_H
+#define __ASM_C6X_BOARD_H
+
+#ifdef CONFIG_ARCH_BOARD_DSK6455
+#include <mach/board-dsk6455.h>
+#endif
+#ifdef CONFIG_ARCH_BOARD_EVM6457
+#include <mach/board-evm6457.h>
+#endif
+#ifdef CONFIG_ARCH_BOARD_EVM6472
+#include <mach/board-evm6472.h>
+#endif
+#ifdef CONFIG_ARCH_BOARD_EVM6474
+#include <mach/board-evm6474.h>
+#endif
+#ifdef CONFIG_ARCH_BOARD_EVM6474L
+#include <mach/board-evm6474l.h>
+#endif
+
+#endif
diff --git a/arch/c6x/platforms/include/mach/cache.h b/arch/c6x/platforms/include/mach/cache.h
new file mode 100644
index 0000000..bc31a58
--- /dev/null
+++ b/arch/c6x/platforms/include/mach/cache.h
@@ -0,0 +1,104 @@
+/*
+ *  linux/arch/c6x/platforms/include/mach/cache.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2007, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@virtuallogix.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+/*
+ * Cache line size
+ */
+#define L1D_CACHE_BYTES   64
+#define L1P_CACHE_BYTES   32
+#define L2_CACHE_BYTES	  128
+
+/*
+ * L2 used as cache
+ */
+#define L2MODE_SIZE	  L2MODE_256K_CACHE
+
+/*
+ * Internal Memory Control Registers for caches
+ */
+#define IMCR_CCFG	  0x01840000
+#define IMCR_L1PCFG	  0x01840020
+#define IMCR_L1PCC	  0x01840024
+#define IMCR_L1DCFG	  0x01840040
+#define IMCR_L1DCC	  0x01840044
+#define IMCR_L2ALLOC0	  0x01842000
+#define IMCR_L2ALLOC1	  0x01842004
+#define IMCR_L2ALLOC2	  0x01842008
+#define IMCR_L2ALLOC3	  0x0184200c
+#define IMCR_L2WBAR	  0x01844000
+#define IMCR_L2WWC	  0x01844004
+#define IMCR_L2WIBAR	  0x01844010
+#define IMCR_L2WIWC	  0x01844014
+#define IMCR_L2IBAR	  0x01844018
+#define IMCR_L2IWC	  0x0184401c
+#define IMCR_L1PIBAR	  0x01844020
+#define IMCR_L1PIWC	  0x01844024
+#define IMCR_L1DWIBAR	  0x01844030
+#define IMCR_L1DWIWC	  0x01844034
+#define IMCR_L1DWBAR	  0x01844040
+#define IMCR_L1DWWC	  0x01844044
+#define IMCR_L1DIBAR	  0x01844048
+#define IMCR_L1DIWC	  0x0184404c
+#define IMCR_L2WB	  0x01845000
+#define IMCR_L2WBINV	  0x01845004
+#define IMCR_L2INV	  0x01845008
+#define IMCR_L1PINV	  0x01845028
+#define IMCR_L1DWB	  0x01845040
+#define IMCR_L1DWBINV	  0x01845044
+#define IMCR_L1DINV	  0x01845048
+#define IMCR_MAR_BASE	  0x01848000
+#define IMCR_MAR96_111	  0x01848180
+#define IMCR_MAR128_191   0x01848200
+#define IMCR_MAR224_239   0x01848380
+#define IMCR_L2MPFAR	  0x0184a000
+#define IMCR_L2MPFSR	  0x0184a004
+#define IMCR_L2MPFCR	  0x0184a008
+#define IMCR_L2MPLK0	  0x0184a100
+#define IMCR_L2MPLK1	  0x0184a104
+#define IMCR_L2MPLK2	  0x0184a108
+#define IMCR_L2MPLK3	  0x0184a10c
+#define IMCR_L2MPLKCMD	  0x0184a110
+#define IMCR_L2MPLKSTAT   0x0184a114
+#define IMCR_L2MPPA_BASE  0x0184a200
+#define IMCR_L1PMPFAR	  0x0184a400
+#define IMCR_L1PMPFSR	  0x0184a404
+#define IMCR_L1PMPFCR	  0x0184a408
+#define IMCR_L1PMPLK0	  0x0184a500
+#define IMCR_L1PMPLK1	  0x0184a504
+#define IMCR_L1PMPLK2	  0x0184a508
+#define IMCR_L1PMPLK3	  0x0184a50c
+#define IMCR_L1PMPLKCMD   0x0184a510
+#define IMCR_L1PMPLKSTAT  0x0184a514
+#define IMCR_L1PMPPA_BASE 0x0184a600
+#define IMCR_L1DMPFAR	  0x0184ac00
+#define IMCR_L1DMPFSR	  0x0184ac04
+#define IMCR_L1DMPFCR	  0x0184ac08
+#define IMCR_L1DMPLK0	  0x0184ad00
+#define IMCR_L1DMPLK1	  0x0184ad04
+#define IMCR_L1DMPLK2	  0x0184ad08
+#define IMCR_L1DMPLK3	  0x0184ad0c
+#define IMCR_L1DMPLKCMD   0x0184ad10
+#define IMCR_L1DMPLKSTAT  0x0184ad14
+#define IMCR_L1DMPPA_BASE 0x0184ae00
+#define IMCR_L2PDWAKE0	  0x0184c040
+#define IMCR_L2PDWAKE1	  0x0184c044
+#define IMCR_L2PDSLEEP0   0x0184c050
+#define IMCR_L2PDSLEEP1   0x0184c054
+#define IMCR_L2PDSTAT0	  0x0184c060
+#define IMCR_L2PDSTAT1	  0x0184c064
+
+/*
+ * Physical memory granularity for MAR registers
+ */
+#define IMCR_MAR_SIZE	  0x01000000
+
diff --git a/arch/c6x/platforms/include/mach/dscr.h b/arch/c6x/platforms/include/mach/dscr.h
new file mode 100644
index 0000000..1021e8a
--- /dev/null
+++ b/arch/c6x/platforms/include/mach/dscr.h
@@ -0,0 +1,184 @@
+/*
+ *  linux/arch/c6x/platforms/include/mach/dscr.h
+ *
+ *  DSCR definitions for Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2010 Texas Instruments Incorporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#ifndef __MACH_C6X_DSCR_H
+#define __MACH_C6X_DSCR_H
+
+#include <linux/bitops.h>
+#include <asm/hardware.h>
+
+/*
+ * Device State Control Registers
+ */
+#if defined(CONFIG_SOC_TMS320C6455)
+#define DSCR_DEVSTAT		__SYSREG(0x02a80000, unsigned int)
+#define DSCR_PERLOCK		__SYSREG(0x02ac0004, unsigned int)
+#define DSCR_PERCFG0		__SYSREG(0x02ac0008, unsigned int)
+#define DSCR_PERSTAT0		__SYSREG(0x02ac0014, unsigned int)
+#define DSCR_PERSTAT1		__SYSREG(0x02ac0018, unsigned int)
+#define DSCR_EMACCFG		__SYSREG(0x02ac0020, unsigned int)
+#define DSCR_PERCFG1		__SYSREG(0x02ac002c, unsigned int)
+#define DSCR_EMUBUFPD		__SYSREG(0x02ac0054, unsigned int)
+
+#define DSCR_LOCKVAL		     0x0f0a0b00
+
+#define DSCR_B_PERCFG0_TCP	     BIT(0)
+#define DSCR_B_PERCFG0_VCP	     BIT(2)
+#define DSCR_B_PERCFG0_EMAC	     BIT(4)
+#define DSCR_B_PERCFG0_TIMER0	     BIT(6)
+#define DSCR_B_PERCFG0_TIMER1	     BIT(8)
+#define DSCR_B_PERCFG0_GPIO	     BIT(10)
+#define DSCR_B_PERCFG0_I2C	     BIT(12)
+#define DSCR_B_PERCFG0_BSP0	     BIT(14)
+#define DSCR_B_PERCFG0_BSP1	     BIT(16)
+#define DSCR_B_PERCFG0_HPI	     BIT(18)
+#define DSCR_B_PERCFG0_PCI	     BIT(20)
+#define DSCR_B_PERCFG0_UTOPIA	     BIT(22)
+
+#define DSCR_B_PERCFG1_EMIFA	     BIT(0)
+#define DSCR_B_PERCFG1_DDR2	     BIT(1)
+
+#define DSCR_B_EMACCFG_RMIIRST	     (1<<19)
+
+#define DEVSTAT_MACSEL_OFFSET	     9
+#define DEVSTAT_MACSEL_MASK	     3
+
+#endif	/* CONFIG_SOC_TMS320C6455 */
+
+#if defined(CONFIG_SOC_TMS320C6457)
+#define DSCR_JTAGID		__SYSREG(0x02880818, unsigned int)
+#define DSCR_DEVSTAT		__SYSREG(0x02880820, unsigned int)
+#define DSCR_KICK0		__SYSREG(0x02880838, unsigned int)
+#define DSCR_KICK1		__SYSREG(0x0288083c, unsigned int)
+#define DSCR_BOOTADDR		__SYSREG(0x02880840, unsigned int)
+#define DSCR_DEVCFG		__SYSREG(0x02880910, unsigned int)
+#define DSCR_MACID1		__SYSREG(0x02880914, unsigned int)
+#define DSCR_MACID2		__SYSREG(0x02880918, unsigned int)
+#define DSCR_PRI_ALLOC		__SYSREG(0x0288091c, unsigned int)
+#define DSCR_WDRSTSEL		__SYSREG(0x02880920, unsigned int)
+
+#define DSCR_KICK0_KEY		     0x83E70B13
+#define DSCR_KICK1_KEY		     0x95A4F1E0
+
+#define DSCR_B_DEVSTAT_LENDIAN	     BIT(0)
+#define DSCR_B_DEVSTAT_HPIWIDTH      BIT(14)
+#define DSCR_B_DEVSTAT_ECLKINSEL     BIT(15)
+
+/* Using SGMII */
+#define DEVSTAT_MACSEL_OFFSET	     0
+#define DEVSTAT_MACSEL_MASK	     0
+
+#endif	/* CONFIG_SOC_TMS320C6457 */
+
+#if defined(CONFIG_SOC_TMS320C6474)
+#define DSCR_DEVSTAT		__SYSREG(0x02880804, unsigned int)
+#define DSCR_JTAGID		__SYSREG(0x02880814, unsigned int)
+#define DSCR_PERLOCK		__SYSREG(0x02ac0004, unsigned int)
+#define DSCR_PERCFG0		__SYSREG(0x02ac0008, unsigned int)
+#define DSCR_PERSTAT0		__SYSREG(0x02ac0014, unsigned int)
+#define DSCR_PERSTAT1		__SYSREG(0x02ac0018, unsigned int)
+#define DSCR_EMACCFG		__SYSREG(0x02ac0020, unsigned int)
+#define DSCR_PERCFG1		__SYSREG(0x02ac002c, unsigned int)
+#define DSCR_EMUBUFPD		__SYSREG(0x02ac0054, unsigned int)
+
+#define DSCR_LOCKVAL		     0x0f0a0b00
+
+#define DSCR_B_PERCFG0_TCP	     BIT(0)
+#define DSCR_B_PERCFG0_VCP	     BIT(2)
+#define DSCR_B_PERCFG0_EMAC	     BIT(4)
+#define DSCR_B_PERCFG0_TIMER0	     BIT(6)
+#define DSCR_B_PERCFG0_TIMER1	     BIT(8)
+#define DSCR_B_PERCFG0_GPIO	     BIT(10)
+#define DSCR_B_PERCFG0_I2C	     BIT(12)
+#define DSCR_B_PERCFG0_BSP0	     BIT(14)
+#define DSCR_B_PERCFG0_BSP1	     BIT(16)
+#define DSCR_B_PERCFG0_HPI	     BIT(18)
+#define DSCR_B_PERCFG0_PCI	     BIT(20)
+#define DSCR_B_PERCFG0_UTOPIA	     BIT(22)
+
+#define DSCR_B_PERCFG1_EMIFA	     BIT(0)
+#define DSCR_B_PERCFG1_DDR2	     BIT(1)
+
+#define DSCR_B_EMACCFG_RMIIRST	     (1<<19)
+
+/* Using SGMII */
+#define DEVSTAT_MACSEL_OFFSET	     0
+#define DEVSTAT_MACSEL_MASK	     0
+
+#endif	/* CONFIG_SOC_TMS320C6474 */
+
+#if defined(CONFIG_SOC_TMS320C6472)
+#define DSCR_DEVSTAT		__SYSREG(0x2a80000, unsigned int)
+#define DSCR_PRIALLOC		__SYSREG(0x2a80004, unsigned int)
+#define DSCR_DEVID		__SYSREG(0x2a80008, unsigned int)
+#define DSCR_DEVCTL		__SYSREG(0x2a80200, unsigned int)
+#define DSCR_PERLOCK		__SYSREG(0x2a80204, unsigned int)
+#define DSCR_RMIIRESET0		__SYSREG(0x2a80208, unsigned int)
+#define DSCR_RMIIRESET1		__SYSREG(0x2a8020c, unsigned int)
+#define DSCR_HOSTPRIV		__SYSREG(0x2a8040c, unsigned int)
+#define DSCR_PRIVPERM		__SYSREG(0x2a8041c, unsigned int)
+#define DSCR_PRIVKEY		__SYSREG(0x2a80420, unsigned int)
+#define DSCR_NMIGR0		__SYSREG(0x2a80500, unsigned int)
+#define DSCR_NMIGR1		__SYSREG(0x2a80504, unsigned int)
+#define DSCR_NMIGR2		__SYSREG(0x2a80508, unsigned int)
+#define DSCR_NMIGR3		__SYSREG(0x2a8050c, unsigned int)
+#define DSCR_NMIGR4		__SYSREG(0x2a80510, unsigned int)
+#define DSCR_NMIGR5		__SYSREG(0x2a80514, unsigned int)
+#define DSCR_IPCGR0		__SYSREG(0x2a80540, unsigned int)
+#define DSCR_IPCGR1		__SYSREG(0x2a80544, unsigned int)
+#define DSCR_IPCGR2		__SYSREG(0x2a80548, unsigned int)
+#define DSCR_IPCGR3		__SYSREG(0x2a8054c, unsigned int)
+#define DSCR_IPCGR4		__SYSREG(0x2a80550, unsigned int)
+#define DSCR_IPCGR5		__SYSREG(0x2a80554, unsigned int)
+#define DSCR_IPCGRH		__SYSREG(0x2a8057c, unsigned int)
+#define DSCR_IPCAR0		__SYSREG(0x2a80580, unsigned int)
+#define DSCR_IPCAR1		__SYSREG(0x2a80584, unsigned int)
+#define DSCR_IPCAR2		__SYSREG(0x2a80588, unsigned int)
+#define DSCR_IPCAR3		__SYSREG(0x2a8058c, unsigned int)
+#define DSCR_IPCAR4		__SYSREG(0x2a80590, unsigned int)
+#define DSCR_IPCAR5		__SYSREG(0x2a80594, unsigned int)
+#define DSCR_IPCARH		__SYSREG(0x2a805bc, unsigned int)
+#define DSCR_TPMGR		__SYSREG(0x2a80714, unsigned int)
+#define DSCR_RSTMUX0		__SYSREG(0x2a80718, unsigned int)
+#define DSCR_RSTMUX1		__SYSREG(0x2a8071c, unsigned int)
+#define DSCR_RSTMUX2		__SYSREG(0x2a80720, unsigned int)
+#define DSCR_RSTMUX3		__SYSREG(0x2a80724, unsigned int)
+#define DSCR_RSTMUX4		__SYSREG(0x2a80728, unsigned int)
+#define DSCR_RSTMUX5		__SYSREG(0x2a8072c, unsigned int)
+
+#define DSCR_LOCKVAL		     0xa1e183a
+
+#define DSCR_B_DEVCTL_EMAC1	     BIT(12)
+
+#define DEVSTAT_B_EMAC0_MACSEL	     0x00000700
+#define DEVSTAT_B_EMAC0_OFFSET	     8
+#define DEVSTAT_B_EMAC1_MACSEL	     0x00C00000
+#define DEVSTAT_B_EMAC1_OFFSET	     22
+
+#define DEVSTAT_MACSEL_OFFSET	     8
+#define DEVSTAT_MACSEL_MASK	     7
+
+#endif	 /* CONFIG_SOC_TMS320C6472 */
+
+/*
+ * MDIO interfaces
+ */
+#define DEVSTAT_MACSEL_MII	     0
+#define DEVSTAT_MACSEL_RMII	     1
+#define DEVSTAT_MACSEL_GMII	     2
+#define DEVSTAT_MACSEL_RGMII	     3
+#define DEVSTAT_MACSEL_S3MII	     5
+#define DEVSTAT_MACSEL_DISABLE	     7
+
+#endif /* __MACH_C6X_DSCR_H */
+
diff --git a/arch/c6x/platforms/include/mach/emif.h b/arch/c6x/platforms/include/mach/emif.h
new file mode 100644
index 0000000..056d206
--- /dev/null
+++ b/arch/c6x/platforms/include/mach/emif.h
@@ -0,0 +1,63 @@
+/*
+ *  linux/arch/c6x/platforms/include/mach/emif.h
+ *
+ *  External Memory Interface for Texas Instruments C64x+
+ *
+ *  Copyright (C) 2011 Texas Instruments Incorporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef __MACH_C6X_EMIF_H
+#define __MACH_C6X_EMIF_H
+
+#if defined(CONFIG_SOC_TMS320C6455)
+#define EMIFA_BASE 0x70000000
+#elif defined(CONFIG_SOC_TMS320C6457)
+#define EMIFA_BASE 0x70000000
+#else
+#error "EMIFA not supported on this SoC"
+#endif
+
+#define EMIFA_MIDR	__SYSREG(EMIFA_BASE + 0x00, uint32_t)
+#define EMIFA_STAT	__SYSREG(EMIFA_BASE + 0x04, uint32_t)
+#define EMIFA_BPRIO	__SYSREG(EMIFA_BASE + 0x20, uint32_t)
+#define EMIFA_CE2CFG	__SYSREG(EMIFA_BASE + 0x80, uint32_t)
+#define EMIFA_CE3CFG	__SYSREG(EMIFA_BASE + 0x84, uint32_t)
+#define EMIFA_CE4CFG	__SYSREG(EMIFA_BASE + 0x88, uint32_t)
+#define EMIFA_CE5CFG	__SYSREG(EMIFA_BASE + 0x8C, uint32_t)
+#define EMIFA_AWCC	__SYSREG(EMIFA_BASE + 0xA0, uint32_t)
+#define EMIFA_INTRAW	__SYSREG(EMIFA_BASE + 0xC0, uint32_t)
+#define EMIFA_INTMSK	__SYSREG(EMIFA_BASE + 0xC4, uint32_t)
+#define EMIFA_INTMSKSET	__SYSREG(EMIFA_BASE + 0xC8, uint32_t)
+#define EMIFA_INTMSKCLR	__SYSREG(EMIFA_BASE + 0x0C, uint32_t)
+
+/* Layout of CEnCFG register for Sync mode */
+#define EMIFA_CFG_SYNC		BIT(31)
+#define EMIFA_CFG_RD_BE_EN	BIT(10)
+#define EMIFA_CFG_CE_EXT	BIT(9)
+#define EMIFA_CFG_R_ENABLE	BIT(8)
+#define EMIFA_CFG_W_LTNCY(n)	(((n) & 3) << 6)
+#define EMIFA_CFG_R_LTNCY(n)	(((n) & 3) << 2)
+#define EMIFA_CFG_WIDTH_8	0
+#define EMIFA_CFG_WIDTH_16	1
+#define EMIFA_CFG_WIDTH_32	2
+#define EMIFA_CFG_WIDTH_64	3
+
+/* Layout of CEnCFG register for Async mode */
+#define EMIFA_CFG_ASYNC		(0 << 31)
+#define EMIFA_CFG_SS		BIT(30)
+#define EMIFA_CFG_BWEM		BIT(29)
+#define EMIFA_CFG_AE		BIT(28)
+#define EMIFA_CFG_W_SETUP(n)	((((n) - 1) & 0x0f) << 24)
+#define EMIFA_CFG_W_STROBE(n)	((((n) - 1) & 0x3f) << 18)
+#define EMIFA_CFG_W_HOLD(n)	((((n) - 1) & 0x07) << 15)
+#define EMIFA_CFG_R_SETUP(n)	((((n) - 1) & 0x0f) << 11)
+#define EMIFA_CFG_R_STROBE(n)	((((n) - 1) & 0x3f) << 5)
+#define EMIFA_CFG_R_HOLD(n)	((((n) - 1) & 0x07) << 2)
+/* Bus width same as Sync mode */
+
+
+#endif /* __MACH_C6X_EMIF_H */
diff --git a/arch/c6x/platforms/include/mach/gemac.h b/arch/c6x/platforms/include/mach/gemac.h
new file mode 100644
index 0000000..ba82036
--- /dev/null
+++ b/arch/c6x/platforms/include/mach/gemac.h
@@ -0,0 +1,763 @@
+/*
+ *  linux/arch/c6x/platforms/include/mach/gemac.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2010 Texas Instruments Incorporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *	    Aurelien Jacquiot <a-jacquiot@ti.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef __MACH_C6X_GEMAC_H
+#define __MACH_C6X_GEMAC_H
+
+#include <linux/io.h>
+#include <mach/board.h>
+
+/*
+ * Packet flags (16 bits)
+ */
+#define EMAC_DESC_FLAG_SOP	  0x80000000
+#define EMAC_DESC_FLAG_EOP	  0x40000000
+#define EMAC_DESC_FLAG_OWNER	  0x20000000
+#define EMAC_DESC_FLAG_EOQ	  0x10000000
+#define EMAC_DESC_FLAG_TDOWNCMPLT 0x08000000
+#define EMAC_DESC_FLAG_PASSCRC	  0x04000000
+#define EMAC_DESC_FLAG_JABBER	  0x02000000
+#define EMAC_DESC_FLAG_OVERSIZE   0x01000000
+#define EMAC_DESC_FLAG_FRAGMENT   0x00800000
+#define EMAC_DESC_FLAG_UNDERSIZED 0x00400000
+#define EMAC_DESC_FLAG_CONTROL	  0x00200000
+#define EMAC_DESC_FLAG_OVERRUN	  0x00100000
+#define EMAC_DESC_FLAG_CODEERROR  0x00080000
+#define EMAC_DESC_FLAG_ALIGNERROR 0x00040000
+#define EMAC_DESC_FLAG_CRCERROR   0x00020000
+#define EMAC_DESC_FLAG_NOMATCH	  0x00010000
+
+#define EMAC_PACKET_LEN_MASK	  0x000007FF
+
+/*
+ * EMAC registers
+ */
+#define EMAC_TXIDVER		  0x000 /* TX ID and Version */
+#define EMAC_TXCONTROL		  0x004 /* TX Control */
+#define EMAC_TXTEARDOWN		  0x008 /* TX Teardown */
+#define EMAC_RXIDVER		  0x010 /* RX ID and Version */
+#define EMAC_RXCONTROL		  0x014 /* RX Control */
+#define EMAC_RXTEARDOWN		  0x018 /* RX Teardown */
+#define EMAC_TXINTSTATRAW	  0x080 /* TX IRQ Status Register (Unmasked) */
+#define EMAC_TXINTSTATMASKED	  0x084 /* TX IRQ Status Register (Masked) */
+#define EMAC_TXINTMASKSET	  0x088 /* TX Interrupt Mask Set Register */
+#define EMAC_TXINTMASKCLEAR	  0x08C /* TX Interrupt Mask Clear Register */
+#define EMAC_MACINVECTOR	  0x090 /* MAC Input Vector Register */
+#define EMAC_MACEOIVECTOR	  0x094 /* MAC End of IRQ Vector Register */
+#define EMAC_RXINTSTATRAW	  0x0A0 /* RX IRQ Status Register (Unmasked) */
+#define EMAC_RXINTSTATMASKED	  0x0A4 /* RX IRQ Status Register (Masked) */
+#define EMAC_RXINTMASKSET	  0x0A8 /* RX IRQ Mask Set Register */
+#define EMAC_RXINTMASKCLEAR	  0x0AC /* RX IRQ Mask Clear Register */
+#define EMAC_MACINTSTATRAW	  0x0B0 /* MAC IRQ Status Register (Unmasked) */
+#define EMAC_MACINTSTATMASKED	  0x0B4 /* MAC IRQ Status Register (Masked) */
+#define EMAC_MACINTMASKSET	  0x0B8 /* MAC IRQ Mask Set Register */
+#define EMAC_MACINTMASKCLEAR	  0x0BC /* MAC IRQ Mask Clear Register */
+#define EMAC_RXMBPENABLE	  0x100 /* RX Mulicast/Bcast/Promisc Enable */
+#define EMAC_RXUNICASTSET	  0x104 /* RX Unicast Set Register */
+#define EMAC_RXUNICASTCLEAR	  0x108 /* RX Unicast Clear Register */
+#define EMAC_RXMAXLEN		  0x10c /* RX Maximum Length Register */
+#define EMAC_RXBUFFEROFFSET	  0x110 /* RX Buffer Offset Register */
+#define EMAC_RXFILTERLOWTHRESH	  0x114 /* RX Filer Low Priority Packets Threshhold */
+#define EMAC_RX0FLOWTHRESH	  0x120 /* RX Channel 0 Flow Control Threshhold */
+#define EMAC_RX1FLOWTHRESH	  0x124 /* RX Channel 1 Flow Control Threshhold */
+#define EMAC_RX2FLOWTHRESH	  0x128 /* RX Channel 2 Flow Control Threshhold */
+#define EMAC_RX3FLOWTHRESH	  0x12c /* RX Channel 3 Flow Control Threshhold */
+#define EMAC_RX4FLOWTHRESH	  0x130 /* RX Channel 4 Flow Control Threshhold */
+#define EMAC_RX5FLOWTHRESH	  0x134 /* RX Channel 5 Flow Control Threshhold */
+#define EMAC_RX6FLOWTHRESH	  0x138 /* RX Channel 6 Flow Control Threshhold */
+#define EMAC_RX7FLOWTHRESH	  0x13c /* RX Channel 7 Flow Control Threshhold */
+#define EMAC_RX0FREEBUFFER	  0x140 /* RX Channel 0 Free Buffer Count Register */
+#define EMAC_RX1FREEBUFFER	  0x144 /* RX Channel 1 Free Buffer Count Register */
+#define EMAC_RX2FREEBUFFER	  0x148 /* RX Channel 2 Free Buffer Count Register */
+#define EMAC_RX3FREEBUFFER	  0x14c /* RX Channel 3 Free Buffer Count Register */
+#define EMAC_RX4FREEBUFFER	  0x150 /* RX Channel 4 Free Buffer Count Register */
+#define EMAC_RX5FREEBUFFER	  0x154 /* RX Channel 5 Free Buffer Count Register */
+#define EMAC_RX6FREEBUFFER	  0x158 /* RX Channel 6 Free Buffer Count Register */
+#define EMAC_RX7FREEBUFFER	  0x15c /* RX Channel 7 Free Buffer Count Register */
+#define EMAC_MACCONTROL		  0x160 /* MAC Control Register */
+#define EMAC_MACSTATUS		  0x164 /* MAC Status Register */
+#define EMAC_EMCONTROL		  0x168 /* Emulation Control Register */
+#define EMAC_FIFOCONTROL	  0x16C /* FIFO Control Register */
+#define EMAC_MACCONFIG		  0x170 /* MAC Configuration Register */
+#define EMAC_SOFTRESET		  0x174 /* Soft Reset Register */
+#define EMAC_MACSRCADDRLO	  0x1D0 /* MAC Source Address Low Bytes Register */
+#define EMAC_MACSRCADDRHI	  0x1D4 /* MAC Source Address High Bytes Register */
+#define EMAC_MACHASH1		  0x1D8 /* MAC Address Hash 1 Register */
+#define EMAC_MACHASH2		  0x1DC /* MAC Address Hash 2 Register */
+#define EMAC_BOFFTEST		  0x1E0 /* Backoff Test Register */
+#define EMAC_TPACETEST		  0x1E4 /* Transmit Pacing Test Register */
+#define EMAC_RXPAUSE		  0x1E8 /* Receive Pause Timer Register */
+#define EMAC_TXPAUSE		  0x1EC /* Transmit Pause Timer Register */
+#define EMAC_RXGOODFRAMES	  0x200 /* Number of Good Frames Received */
+#define EMAC_RXBCASTFRAMES	  0x204 /* Number of Good Broadcast Frames Received */
+#define EMAC_RXMCASTFRAMES	  0x208 /* Number of Good Multicast Frames Received */
+#define EMAC_RXPAUSEFRAMES	  0x20c /* Number of PauseRX Frames Received */
+#define EMAC_RXCRCERRORS	  0x210 /* Number of Frames Received with CRC Errors */
+#define EMAC_RXALIGNCODEERRORS	  0x214 /* Number of Frames Received with Alignment/Code Errors */
+#define EMAC_RXOVERSIZED	  0x218 /* Number of Oversized Frames Received */
+#define EMAC_RXJABBER		  0x21c /* Number of Jabber Frames Received */
+#define EMAC_RXUNDERSIZED	  0x220 /* Number of Undersized Frames Received */
+#define EMAC_RXFRAGMENTS	  0x224 /* Number of RX Frame Fragments Received */
+#define EMAC_RXFILTERED		  0x228 /* Number of RX Frames Filtered Based on Address */
+#define EMAC_RXQOSFILTERED	  0x22c /* Number of RX Frames Filtered Based on QoS Filtering */
+#define EMAC_RXOCTETS		  0x230 /* Total Number of Received Bytes in Good Frames */
+#define EMAC_TXGOODFRAMES	  0x234 /* Number of Good Frames Sent */
+#define EMAC_TXBCASTFRAMES	  0x238 /* Number of Good Broadcast Frames Sent */
+#define EMAC_TXMCASTFRAMES	  0x23c /* Number of Good Multicast Frames Sent */
+#define EMAC_TXPAUSEFRAMES	  0x240 /* Number of PauseTX Frames Sent */
+#define EMAC_TXDEFERRED		  0x244 /* Number of Frames Where Transmission was Deferred */
+#define EMAC_TXCOLLISION	  0x248 /* Total Number of Frames Sent That Experienced a Collision */
+#define EMAC_TXSINGLECOLL	  0x24c /* Number of Frames Sent with Exactly One Collision */
+#define EMAC_TXMULTICOLL	  0x250 /* Number of Frames Sent with Multiple Colisions */
+#define EMAC_TXEXCESSIVECOLL	  0x254 /* Number of TX Frames Lost Due to Excessive Collisions */
+#define EMAC_TXLATECOLL		  0x258 /* Number of TX Frames Lost Due to a Late Collision */
+#define EMAC_TXUNDERRUN		  0x25c /* Number of TX Frames Lost with Transmit Underrun Error */
+#define EMAC_TXCARRIERSLOSS	  0x260 /* Numebr of TX Frames Lost Due to Carrier Sense Loss */
+#define EMAC_TXOCTETS		  0x264 /* Total Nu,ber of Transmitted Bytes in Good Frames */
+#define EMAC_FRAME64		  0x268 /* Total TX & RX Frames with Octet Size of 64 */
+#define EMAC_FRAME65T127	  0x26c /* Total TX & RX Frames with Octet Size of 65 to 127 */
+#define EMAC_FRAME128T255	  0x270 /* Total TX & RX Frames with Octet Size of 128 to 255 */
+#define EMAC_FRAME256T511	  0x274 /* Total TX & RX Frames with Octet Size of 256 to 511 */
+#define EMAC_FRAME512T1023	  0x278 /* Total TX & RX Frames with Octet Size of 512 to 1023 */
+#define EMAC_FRAME1024TUP	  0x27c /* Total TX & RX Frames with Octet Size of 1024 or above */
+#define EMAC_NETOCTETS		  0x280 /* Sum of all Octets Sent or Received on the Network */
+#define EMAC_RXSOFOVERRUNS	  0x284 /* Total RX Start of Frame Overruns (FIFO or DMA) */
+#define EMAC_RXMOFOVERRUNS	  0x288 /* Total RX Middle of Frame Overruns (FIFO or DMA) */
+#define EMAC_RXDMAOVERRUNS	  0x28c /* Total RX DMA Overruns */
+#define EMAC_MACADDRLO		  0x500 /* MAC Address Low Bytes Register (rcv match) */
+#define EMAC_MACADDRHI		  0x504 /* MAC Address High Bytes Register (rcv match) */
+#define EMAC_MACINDEX		  0x508 /* MAC Index Register */
+#define EMAC_TX0HDP		  0x600 /* TX Channel 0 DMA Head Descriptor Pointer Register */
+#define EMAC_TX1HDP		  0x604 /* TX Channel 1 DMA Head Descriptor Pointer Register */
+#define EMAC_TX2HDP		  0x608 /* TX Channel 2 DMA Head Descriptor Pointer Register */
+#define EMAC_TX3HDP		  0x60c /* TX Channel 3 DMA Head Descriptor Pointer Register */
+#define EMAC_TX4HDP		  0x610 /* TX Channel 4 DMA Head Descriptor Pointer Register */
+#define EMAC_TX5HDP		  0x614 /* TX Channel 5 DMA Head Descriptor Pointer Register */
+#define EMAC_TX6HDP		  0x618 /* TX Channel 6 DMA Head Descriptor Pointer Register */
+#define EMAC_TX7HDP		  0x61c /* TX Channel 7 DMA Head Descriptor Pointer Register */
+#define EMAC_RX0HDP		  0x620 /* RX Channel 0 DMA Head Descriptor Pointer Register */
+#define EMAC_RX1HDP		  0x624 /* RX Channel 1 DMA Head Descriptor Pointer Register */
+#define EMAC_RX2HDP		  0x628 /* RX Channel 2 DMA Head Descriptor Pointer Register */
+#define EMAC_RX3HDP		  0x62c /* RX Channel 3 DMA Head Descriptor Pointer Register */
+#define EMAC_RX4HDP		  0x630 /* RX Channel 4 DMA Head Descriptor Pointer Register */
+#define EMAC_RX5HDP		  0x634 /* RX Channel 5 DMA Head Descriptor Pointer Register */
+#define EMAC_RX6HDP		  0x638 /* RX Channel 6 DMA Head Descriptor Pointer Register */
+#define EMAC_RX7HDP		  0x63c /* RX Channel 7 DMA Head Descriptor Pointer Register */
+#define EMAC_TX0INTACK		  0x640 /* TX Channel 0 Interrupt Acknowledge Register */
+#define EMAC_TX1INTACK		  0x644 /* TX Channel 1 Interrupt Acknowledge Register */
+#define EMAC_TX2INTACK		  0x648 /* TX Channel 2 Interrupt Acknowledge Register */
+#define EMAC_TX3INTACK		  0x64c /* TX Channel 3 Interrupt Acknowledge Register */
+#define EMAC_TX4INTACK		  0x650 /* TX Channel 4 Interrupt Acknowledge Register */
+#define EMAC_TX5INTACK		  0x654 /* TX Channel 5 Interrupt Acknowledge Register */
+#define EMAC_TX6INTACK		  0x658 /* TX Channel 6 Interrupt Acknowledge Register */
+#define EMAC_TX7INTACK		  0x65c /* TX Channel 7 Interrupt Acknowledge Register */
+#define EMAC_RX0INTACK		  0x660 /* RX Channel 0 Interrupt Acknowledge Register */
+#define EMAC_RX1INTACK		  0x664 /* RX Channel 1 Interrupt Acknowledge Register */
+#define EMAC_RX2INTACK		  0x668 /* RX Channel 2 Interrupt Acknowledge Register */
+#define EMAC_RX3INTACK		  0x66c /* RX Channel 3 Interrupt Acknowledge Register */
+#define EMAC_RX4INTACK		  0x670 /* RX Channel 4 Interrupt Acknowledge Register */
+#define EMAC_RX5INTACK		  0x674 /* RX Channel 5 Interrupt Acknowledge Register */
+#define EMAC_RX6INTACK		  0x678 /* RX Channel 6 Interrupt Acknowledge Register */
+#define EMAC_RX7INTACK		  0x67c /* RX Channel 7 Interrupt Acknowledge Register */
+
+
+#if !(defined(CONFIG_SOC_TMS320C6474) || defined(CONFIG_SOC_TMS320C6457))
+
+#if defined(CONFIG_SOC_TMS320C6472)
+#define EMAC_EMIC_PID		  0x1000
+#define EMAC_PSCFG		  0x1004
+#define EMAC_RSVD0		  0x1008
+#define EMAC_EWINTCTL0		  0x1020 /* Ethernet Wrapper: Interrupt Control Register */
+#define EMAC_RSVD1		  0x1034
+#define EMAC_RPCFG0		  0x10fc
+#define EMAC_RPSTAT0		  0x111c
+#define EMAC_TPCFG0		  0x113c
+#define EMAC_TPSTAT0		  0x115c
+
+#define EMAC_B_HOST		  (1 << 1)
+#define EMAC_B_STAT		  (1 << 2)
+#define EMAC_B_MDIOLINT		  (1 << 3)
+#define EMAC_B_MDIOUSER		  (1 << 4)
+#define EMAC_B_TX0		  (1 << 8)
+#define EMAC_B_RX0		  (1 << 16)
+
+#else /* defined(CONFIG_SOC_TMS320C6472) */
+
+#define EMAC_EWCTL		  0x1004 /* Interrupt Control Register */
+#define EMAC_EWINTTCNT		  0x1008 /* Interrupt Timer Count */
+
+#endif /* defined(CONFIG_SOC_TMS320C6472) */
+
+#else /* !(defined(CONFIG_SOC_TMS320C6474) || defined(CONFIG_SOC_TMS320C6457)) */
+
+#define ECTL_IDVER		  0x00
+#define ECTL_SOFTRESET		  0x04
+#define ECTL_EMCONTROL		  0x08
+#define ECTL_INTCONTROL		  0x0c
+#define ECTL_RXTHRESTEN		  0x10
+#define ECTL_RXEN		  0x14
+#define ECTL_TXEN		  0x18
+#define ECTL_MISCEN		  0x1c
+
+#define ECTL_RXTHRESTSTAT	  0x40
+#define ECTL_RXSTAT		  0x44
+#define ECTL_TXSTAT		  0x48
+#define ECTL_MISCSTAT		  0x4c
+#define ECTL_RXIMAX		  0x70
+#define ECTL_TXIMAX		  0x74
+
+#endif /* !(defined(CONFIG_SOC_TMS320C6474) || defined(CONFIG_SOC_TMS320C6457)) */
+
+#define EMAC_NUM_STATREGS	  36
+
+/* Bit fields of EMAC registers */
+
+#define EMAC_B_INTEN		  (1 << 0)  /* for EWCTL */
+
+#define EMAC_B_SOFTRST		  (1 << 0)  /* for SOFTRESET */
+
+#define EMAC_B_MULTEN		  (1 << 5)
+#define EMAC_B_BROADEN		  (1 << 13)
+#define EMAC_B_RXCAFEN		  (1 << 21)
+#define EMAC_B_RXCEFEN		  (1 << 22)
+#define EMAC_B_RXCSFEN		  (1 << 23)
+#define EMAC_B_RXCMFEN		  (1 << 24)
+#define EMAC_B_RXNOCHAIN	  (1 << 28)
+#define EMAC_B_RXQOSEN		  (1 << 29)
+#define EMAC_B_RXPASSCRC	  (1 << 30) /* for RXMBPENABLE */
+
+#define EMAC_B_FULLDUPLEX	  (1 << 0)
+#define EMAC_B_LOOPBACK		  (1 << 1)
+#define EMAC_B_RXBUFERFLOWEN	  (1 << 3)
+#define EMAC_B_TXFLOWEN		  (1 << 4)
+#define EMAC_B_GMIIEN		  (1 << 5)
+#define EMAC_B_TXPACE		  (1 << 6)
+#define EMAC_B_GIG		  (1 << 7)
+#define EMAC_B_TXPTYPE		  (1 << 9)
+#define EMAC_B_CMDIDLE		  (1 << 11)
+#define EMAC_B_RXFIFOFLOWEN	  (1 << 12)
+#define EMAC_B_RXOWNERSHIP	  (1 << 13)
+#define EMAC_B_RXOFFLENBLOCK	  (1 << 14)
+#define EMAC_B_RMIISPEED	  (1 << 15)
+#define EMAC_B_RMIIDUPLEXMODE	  (1 << 16)
+#define EMAC_B_GIGFORCE		  (1 << 17)
+#define EMAC_B_RGMIIEN		  (1 << 18)
+#define EMAC_B_CTL_EN		  (1 << 18)
+#define EMAC_B_EXTEN		  (1 << 18) /* for MACCONTROL */
+
+#define EMAC_B_STATINT		  (1 << 0)
+#define EMAC_B_HOSTINT		  (1 << 1)  /* for MACINTMASKSET */
+
+#if defined(CONFIG_SOC_TMS320C6474) || defined(CONFIG_SOC_TMS320C6457)
+#define EMAC_B_RXPEND0		  (1 << 0) /* for MACINVECTOR */
+#define EMAC_B_RXTHRESPEND0	  (1 << 8)
+#define EMAC_B_TXPEND0		  (1 << 16)
+#define EMAC_B_USERINT		  (1 << 24)
+#define EMAC_B_LINKINT		  (1 << 25)
+#define EMAC_B_HOSTPEND		  (1 << 26)
+#define EMAC_B_STATPEND		  (1 << 27)
+#else /* defined(CONFIG_SOC_TMS320C6474) */
+#define EMAC_B_TXPEND0		  (1 << 0)
+#define EMAC_B_RXPEND0		  (1 << 8)
+#define EMAC_B_STATPEND		  (1 << 16)
+#define EMAC_B_HOSTPEND		  (1 << 17) /* for MACINVECTOR */
+#endif /* defined(CONFIG_SOC_TMS320C6474) || defined(CONFIG_SOC_TMS320C6457) */
+
+#define EMAC_V_SOPERROR		  1
+#define EMAC_V_OWNERSHIP	  2
+#define EMAC_V_NOEOP		  3
+#define EMAC_V_NULLPTR		  4
+#define EMAC_V_NULLLEN		  5
+#define EMAC_V_LENRRROR		  6
+#define EMAC_S_RXERRCH		  8
+#define EMAC_S_TXERRCH		  16
+#define EMAC_S_RXERRCODE	  12
+#define EMAC_S_TXERRCODE	  20
+#define EMAC_M_RXERRCH		  0x00000700
+#define EMAC_M_TXERRCH		  0x00070000
+#define EMAC_M_RXERRCODE	  0x0000f000
+#define EMAC_M_TXERRCODE	  0x00f00000 /* for MACSTATUS */
+
+#define EMAC_S_VALID		  20
+#define EMAC_S_MATCHFILTER	  19
+#define EMAC_S_CHANNEL		  16 /* for MACADDRLO */
+
+/* Configuration mode flags */
+#define EMAC_CONFIG_CHPRIORITY	  0x01 /* use Tx channel priority */
+#define EMAC_CONFIG_MACLOOPBACK   0x02 /* MAC internal loopback */
+#define EMAC_CONFIG_RXCRC	  0x04 /* include CRC in RX frames */
+#define EMAC_CONFIG_TXCRC	  0x08 /* Tx frames include CRC */
+#define EMAC_CONFIG_PASSERROR	  0x10 /* pass error frames */
+#define EMAC_CONFIG_PASSCONTROL   0x20 /* pass control frames */
+#define EMAC_CONFIG_PACING	  0x40 /* use interrupt pacing */
+
+#if defined(CONFIG_SGMII)
+
+/*
+ * SGMII registers
+ */
+#define SGMII_REG_BASE		  0x02c40000
+#define SGMII_IDVER_REG		  (SGMII_REG_BASE + 0x000)
+#define SGMII_SRESET_REG	  (SGMII_REG_BASE + 0x004)
+#define SGMII_CTL_REG		  (SGMII_REG_BASE + 0x010)
+#define SGMII_STATUS_REG	  (SGMII_REG_BASE + 0x014)
+#define SGMII_MRADV_REG		  (SGMII_REG_BASE + 0x018)
+#define SGMII_LPADV_REG		  (SGMII_REG_BASE + 0x020)
+#define SGMII_TXCFG_REG		  (SGMII_REG_BASE + 0x030)
+#define SGMII_RXCFG_REG		  (SGMII_REG_BASE + 0x034)
+#define SGMII_AUXCFG_REG	  (SGMII_REG_BASE + 0x038)
+
+#endif /* CONFIG_SGMII*/
+
+#if defined(CONFIG_SOC_TMS320C6474) || defined(CONFIG_SOC_TMS320C6457)
+
+/*
+ * TCI6488/C6474/C6457 dependent definitions
+ */
+#define EMAC0_REG_BASE		  0x02c80000
+#define ECTL0_REG_BASE		  0x02c81000
+#define EMAC0_DSC_BASE		  0x02c82000
+
+#define EMAC_MAX_INSTANCE	  1
+#define PTR_TO_HW(x)		  (x)
+#define HW_TO_PTR(x)		  (x)
+#define _INTFLAG		  0
+#define get_emac_idx()		  (get_coreid())
+
+#define emac_arch_get_hash1()	  emac_get_reg(EMAC_MACHASH1)
+#define emac_arch_get_hash2()	  emac_get_reg(EMAC_MACHASH2)
+#define emac_arch_get_promisc()   (emac_get_reg(EMAC_RXMBPENABLE) & EMAC_B_RXCAFEN)
+#define emac_arch_get_control()   (emac_get_reg(EMAC_MACCONTROL) &	\
+				       (EMAC_B_FULLDUPLEX | EMAC_B_RMIIDUPLEXMODE | \
+					EMAC_B_GIG | EMAC_B_RMIISPEED))
+#define emac_arch_set_hash1(a)	  emac_set_reg(EMAC_MACHASH1, a)
+#define emac_arch_set_hash2(a)	  emac_set_reg(EMAC_MACHASH2, a)
+#define emac_arch_set_promisc(a)  if (a) emac_setbit_reg(EMAC_RXMBPENABLE, EMAC_B_RXCAFEN)
+#define emac_arch_set_control(a)  if (a) emac_setbit_reg(EMAC_MACCONTROL, a)
+
+#define emac_arch_init_control(pace)					\
+	emac_setbit_reg(EMAC_MACCONTROL, (pace) ? EMAC_B_EXTEN | EMAC_B_GMIIEN | EMAC_B_TXPACE : \
+			EMAC_B_EXTEN | EMAC_B_GMIIEN)
+
+#define ectl_arch_rx_irq_enter(c) ectl_clearbit_reg(ECTL_RXEN + (get_coreid() << 4), \
+						    1 << (c))
+#define ectl_arch_rx_irq_leave(c) do {					\
+		emac_set_reg(EMAC_MACEOIVECTOR, 0x1 + (get_coreid() << 2)); \
+		ectl_setbit_reg(ECTL_RXEN + (get_coreid() << 4), 1 << (c)); \
+	} while (0)
+#define ectl_arch_tx_irq_enter(c) ectl_clearbit_reg(ECTL_TXEN + (get_coreid() << 4), \
+						    1 << (c))
+#define ectl_arch_tx_irq_leave(c) do {					\
+		emac_set_reg(EMAC_MACEOIVECTOR, 0x2 + (get_coreid() << 2)); \
+		ectl_setbit_reg(ECTL_TXEN + (get_coreid() << 4), 1 << (c)); \
+	} while (0)
+
+#define ectl_arch_enable_irq(c, misc) do {				\
+		if (misc)						\
+			ectl_set_reg(ECTL_MISCEN + (get_coreid() << 4), 0x3); \
+		ectl_setbit_reg(ECTL_RXEN + (get_coreid() << 4), 1 << (c)); \
+		ectl_setbit_reg(ECTL_TXEN + (get_coreid() << 4), 1 << (c)); \
+	} while (0)
+
+#define ectl_arch_disable_irq(c) do {					\
+		ectl_set_reg(ECTL_MISCEN + (get_coreid() << 4), 0);	\
+		ectl_clearbit_reg(ECTL_RXEN + (get_coreid() << 4), 1 << (c)); \
+		ectl_clearbit_reg(ECTL_TXEN + (get_coreid() << 4), 1 << (c)); \
+	} while (0)
+
+
+#define emac_arch_get_int_vector()	    emac_get_reg(EMAC_MACINVECTOR)
+#define emac_arch_get_pending_irq(i, f, c)  ((i) & ((f) << (c)))
+#define emac_arch_enable_irq(reg, c)	    emac_set_reg(reg, 1 << (c))
+
+#define emac_arch_reset_switch()
+
+#define emac_arch_reset_ectl() do {			   \
+		ectl_set_reg(ECTL_INTCONTROL, 0);	   \
+		ectl_set_reg(ECTL_SOFTRESET, 1);	   \
+		while (ectl_get_reg(ECTL_SOFTRESET) != 0)  \
+			;				   \
+	} while (0)
+
+#define emac_arch_set_pacing() do {					\
+		ectl_set_reg(ECTL_INTCONTROL, gemac_int_prescaler());	\
+		ectl_setbit_reg(ECTL_INTCONTROL, (0x3 << (get_coreid() << 1)) << 16); \
+		ectl_set_reg(ECTL_RXIMAX + (get_coreid() << 3), 0x10);	\
+		ectl_set_reg(ECTL_TXIMAX + (get_coreid() << 3), 0x10);	\
+	} while (0)
+
+#define emac_arch_clear_mac_addr()		 \
+	for (i = 0; i < 32; i++) {		 \
+		emac_set_reg(EMAC_MACINDEX, i);	 \
+		emac_set_reg(EMAC_MACADDRHI, 0); \
+		emac_set_reg(EMAC_MACADDRLO, 0); \
+	}
+
+#define emac_arch_set_mac_addr_index(i) emac_set_reg(EMAC_MACINDEX, i)
+#define emac_arch_set_mac_addr_high(a)	emac_set_reg(EMAC_MACADDRHI, a)
+#define emac_arch_set_mac_addr_low(a)	emac_set_reg(EMAC_MACADDRLO, a)
+#define emac_arch_get_mac_addr_high(a)	emac_get_reg(EMAC_MACADDRHI)
+#define emac_arch_get_mac_addr_low(a)	emac_get_reg(EMAC_MACADDRLO)
+
+static inline int emac_check_shared_capability(void)
+{
+#ifdef C6X_SOC_HAS_CORE_REV
+	if (arch_get_silicon_rev() < 0x3)
+		printk(KERN_WARNING "Warning sharing of GEMAC has issues with silicon rev %s!\n",
+		       arch_compute_silicon_rev(arch_get_silicon_rev()));
+#endif
+	return 1;
+}
+
+#ifdef CONFIG_SOC_TMS320C6457
+#include <mach/dscr.h>
+#define EFUSE_REG_MAC_ADDR     DSCR_MACID1
+#endif
+#ifdef CONFIG_SOC_TMS320C6474
+#define EFUSE_REG_MAC_ADDR     0x2880834
+#endif
+
+#define emac_arch_get_mac_addr emac_arch_get_mac_addr_from_efuse
+
+#define EMAC_HAS_SEPARATE_RXTX_IRQS
+#define EMAC_ARCH_HAS_MAC_ADDR
+
+#elif defined(CONFIG_SOC_TMS320C6472)
+
+/*
+ * TCI6486/C6472 dependent definitions
+ */
+#include <mach/dscr.h>
+
+#define EMAC0_REG_BASE		 0x02c80000
+#define ECTL0_REG_BASE		 0x02c81000
+#define EMAC0_DSC_BASE		 0x02c82000
+
+#define EMAC1_REG_BASE		 0x02cc0000
+#define ECTL1_REG_BASE		 0x02cc1000
+#define EMAC1_DSC_BASE		 0x02cc2000
+
+#define EMAC_MAX_INSTANCE	 2
+#define PTR_TO_HW(x)		 (x)
+#define HW_TO_PTR(x)		 (x)
+#define _INTFLAG		 IRQF_DISABLED
+#define get_emac_idx()		 (get_coreid())
+
+#define emac_arch_get_hash1()	 emac_get_reg(EMAC_MACHASH1)
+#define emac_arch_get_hash2()	 emac_get_reg(EMAC_MACHASH2)
+#define emac_arch_get_promisc()  (emac_get_reg(EMAC_RXMBPENABLE) & EMAC_B_RXCAFEN)
+#define emac_arch_get_control()  emac_get_reg(EMAC_MACCONTROL)
+#define emac_arch_set_hash1(a)	 emac_set_reg(EMAC_MACHASH1, a)
+#define emac_arch_set_hash2(a)	 emac_set_reg(EMAC_MACHASH2, a)
+#define emac_arch_set_promisc(a) if (a) emac_setbit_reg(EMAC_RXMBPENABLE, EMAC_B_RXCAFEN)
+#define emac_arch_set_control(a) if (a) emac_setbit_reg(EMAC_MACCONTROL, a)
+
+#define emac_arch_init_control(pace) do {				\
+		unsigned int dev_stat = DSCR_DEVSTAT;			\
+		unsigned int gigabit = 0, macsel;			\
+		if (dev->dev_id == 0) {					\
+			macsel = (dev_stat & DEVSTAT_B_EMAC0_MACSEL) >>	\
+				DEVSTAT_B_EMAC0_OFFSET;			\
+			if ((macsel == DEVSTAT_MACSEL_GMII) ||		\
+			    (macsel == DEVSTAT_MACSEL_RGMII))		\
+				gigabit = 1;				\
+		}							\
+		if (dev->dev_id == 1) {					\
+			macsel = (dev_stat & DEVSTAT_B_EMAC1_MACSEL) >> \
+				DEVSTAT_B_EMAC1_OFFSET;			\
+			if (macsel == DEVSTAT_MACSEL_GMII)		\
+				gigabit = 1;				\
+		}							\
+		if (gigabit == 1)					\
+			emac_set_reg(EMAC_MACCONTROL, EMAC_B_GIG | EMAC_B_RGMIIEN); \
+		else							\
+			emac_set_reg(EMAC_MACCONTROL, EMAC_B_RMIISPEED); \
+		emac_setbit_reg(EMAC_MACCONTROL, (pace) ?		\
+				(EMAC_B_GMIIEN | EMAC_B_TXPACE) :	\
+				EMAC_B_GMIIEN);				\
+	} while (0)
+
+#define ectl_arch_rx_irq_enter(c)
+#define ectl_arch_rx_irq_leave(c)
+#define ectl_arch_tx_irq_enter(c)
+#define ectl_arch_tx_irq_leave(c)
+#define ectl_arch_enable_irq(c, misc)					\
+do {								\
+	if (misc)							\
+		emac_set_reg(EMAC_EWINTCTL0 + (get_coreid() << 2),	\
+			     EMAC_B_STAT | EMAC_B_HOST |		\
+			     (EMAC_B_TX0 << (c)) | (EMAC_B_RX0 << (c))); \
+	else								\
+		emac_set_reg(EMAC_EWINTCTL0 + (get_coreid() << 2),	\
+			     (EMAC_B_TX0 << (c)) | (EMAC_B_RX0 << (c))); \
+} while (0)
+
+#define ectl_arch_disable_irq(c) \
+	emac_set_reg(EMAC_EWINTCTL0 + (get_coreid() << 2), 0)
+
+/*
+ * On Tomahawk, MACINVECTOR can be null even if TX/RX int occurs.
+ * This is probably an hardware bug.
+ */
+#define emac_arch_get_int_vector()	    (emac_get_reg(EMAC_MACINVECTOR) \
+					     | ((emac_get_reg(EMAC_RXINTSTATMASKED) & 0xff) << 8) \
+					     | (emac_get_reg(EMAC_TXINTSTATMASKED) & 0xff))
+#define emac_arch_get_pending_irq(i, f, c)  ((i) & ((f) << (c)))
+#define emac_arch_enable_irq(reg, c)	    emac_set_reg(reg, (1 << (c + 16)) | (1 << c))
+
+#define emac_arch_reset_switch()
+
+/* Disable EMAC/MDIO interrupts in EMIC */
+#define emac_arch_reset_ectl()	  emac_set_reg(EMAC_EWINTCTL0 + (get_coreid() << 2), 0x0)
+
+#define emac_arch_set_pacing() do {					\
+		emac_set_reg(EMAC_RPCFG0 + (get_coreid() << 2), 0x3);	\
+		emac_set_reg(EMAC_TPCFG0 + (get_coreid() << 2), 0x3);	\
+		emac_set_reg(EMAC_PSCFG, gemac_int_prescaler());	\
+	} while (0)
+
+#define emac_arch_clear_mac_addr()		 \
+	for (i = 0; i < 32; i++) {		 \
+		emac_set_reg(EMAC_MACINDEX, i);	 \
+		emac_set_reg(EMAC_MACADDRHI, 0); \
+		emac_set_reg(EMAC_MACADDRLO, 0); \
+	}
+
+#define emac_arch_set_mac_addr_index(i) emac_set_reg(EMAC_MACINDEX, i)
+#define emac_arch_set_mac_addr_high(a)	emac_set_reg(EMAC_MACADDRHI, a)
+#define emac_arch_set_mac_addr_low(a)	emac_set_reg(EMAC_MACADDRLO, a)
+#define emac_arch_get_mac_addr_high(a)	emac_get_reg(EMAC_MACADDRHI)
+#define emac_arch_get_mac_addr_low(a)	emac_get_reg(EMAC_MACADDRLO)
+
+#define emac_check_shared_capability()	1
+
+#define EFUSE_REG_MAC_ADDR		0x2a80700
+#define emac_arch_get_mac_addr		emac_arch_get_mac_addr_from_efuse
+
+#define EMAC_HAS_SEPARATE_RXTX_IRQS
+#define EMAC_ARCH_HAS_MAC_ADDR
+
+#elif defined(CONFIG_SOC_TMS320C6455)
+
+/*
+ * C6455 dependent definitions
+ */
+#include <mach/dscr.h>
+
+#define EMAC0_REG_BASE		 0x02c80000
+#define ECTL0_REG_BASE		 0x02c81000
+#define EMAC0_DSC_BASE		 0x02c82000
+
+#define EMAC_MAX_INSTANCE	 1
+#define PTR_TO_HW(x)		 (x)
+#define HW_TO_PTR(x)		 (x)
+#define _INTFLAG		 0
+#define get_emac_idx()		 0
+
+#define emac_arch_get_hash1()	 emac_get_reg(EMAC_MACHASH1)
+#define emac_arch_get_hash2()	 emac_get_reg(EMAC_MACHASH2)
+#define emac_arch_get_promisc()  (emac_get_reg(EMAC_RXMBPENABLE) & EMAC_B_RXCAFEN)
+#define emac_arch_get_control()  (emac_get_reg(EMAC_MACCONTROL) &	\
+				      (EMAC_B_FULLDUPLEX | EMAC_B_RMIIDUPLEXMODE | \
+				       EMAC_B_GIG | EMAC_B_RMIISPEED))
+#define emac_arch_set_hash1(a)	 emac_set_reg(EMAC_MACHASH1, a)
+#define emac_arch_set_hash2(a)	 emac_set_reg(EMAC_MACHASH2, a)
+#define emac_arch_set_promisc(a)				   \
+	do {							   \
+		if (a)						   \
+			emac_setbit_reg(EMAC_RXMBPENABLE, EMAC_B_RXCAFEN); \
+	} while (0)
+#define emac_arch_set_control(a) \
+	do {					\
+		if (a)						\
+			emac_setbit_reg(EMAC_MACCONTROL, a);	\
+	} while (0)
+#define emac_arch_init_control(pace) \
+	emac_setbit_reg(EMAC_MACCONTROL, (pace) ?			\
+			(EMAC_B_GMIIEN | EMAC_B_TXPACE) :		\
+			EMAC_B_GMIIEN)
+
+#define ectl_arch_rx_irq_enter(c)
+#define ectl_arch_rx_irq_leave(c)
+#define ectl_arch_tx_irq_enter(c)
+#define ectl_arch_tx_irq_leave(c)
+#define ectl_arch_enable_irq(c, misc)  emac_setbit_reg(EMAC_EWCTL, EMAC_B_INTEN)
+#define ectl_arch_disable_irq(c) emac_clearbit_reg(EMAC_EWCTL, EMAC_B_INTEN)
+
+#define emac_arch_get_int_vector()	    emac_get_reg(EMAC_MACINVECTOR)
+#define emac_arch_get_pending_irq(i, f, c)  ((i) & ((f) << (c)))
+#define emac_arch_enable_irq(reg, c)	    emac_set_reg(reg, 1 << (c))
+
+#define emac_arch_reset_switch()
+
+/* Disable EMAC/MDIO interrupts and reset EMAC/MDIO modules */
+#define emac_arch_reset_ectl()	  emac_clearbit_reg(EMAC_EWCTL, EMAC_B_INTEN)
+
+#define emac_arch_set_pacing() do {					\
+		/* Wait at least 100 cycles */				\
+		emac_get_reg(EMAC_EWINTTCNT);				\
+		emac_get_reg(EMAC_EWINTTCNT);				\
+		emac_get_reg(EMAC_EWINTTCNT);				\
+		emac_get_reg(EMAC_EWINTTCNT);				\
+		emac_get_reg(EMAC_EWINTTCNT);				\
+		/* Set interrupt timer count (decremented at cpuclk/6) */ \
+		emac_set_reg(EMAC_EWINTTCNT, 15000);			\
+	} while (0)
+
+#define emac_arch_clear_mac_addr()		 \
+	for (i = 0; i < 32; i++) {		 \
+		emac_set_reg(EMAC_MACINDEX, i);	 \
+		emac_set_reg(EMAC_MACADDRHI, 0); \
+		emac_set_reg(EMAC_MACADDRLO, 0); \
+	}
+
+#define emac_arch_set_mac_addr_index(i) emac_set_reg(EMAC_MACINDEX, i)
+#define emac_arch_set_mac_addr_high(a)	emac_set_reg(EMAC_MACADDRHI, a)
+#define emac_arch_set_mac_addr_low(a)	emac_set_reg(EMAC_MACADDRLO, a)
+#define emac_arch_get_mac_addr_high(a)	emac_get_reg(EMAC_MACADDRHI)
+#define emac_arch_get_mac_addr_low(a)	emac_get_reg(EMAC_MACADDRLO)
+
+/* Take RMII out of reset (the following 2 settings apply only to PG 2.0) */
+#define rmii_arch_fix() do {						\
+		if (intfmacsel == DEVSTAT_MACSEL_RMII)			\
+			DSCR_EMACCFG |= DSCR_B_EMACCFG_RMIIRST;		\
+	} while (0)
+
+#define emac_check_shared_capability()	0
+
+#define EMAC_TIMER_TICK_MDIO
+#define EMAC_DO_INIT_MDIO
+
+#else
+
+/*
+ * Generic definitions
+ */
+
+#define EMAC0_REG_BASE		 0x02c80000
+#define ECTL0_REG_BASE		 0x02c81000
+#define EMAC0_DSC_BASE		 0x02c82000
+
+#define EMAC_MAX_INSTANCE	 1
+#define PTR_TO_HW(x)		 (x)
+#define HW_TO_PTR(x)		 (x)
+#define _INTFLAG		 0
+#define get_emac_idx()		 0
+
+#define emac_arch_get_hash1()	 emac_get_reg(EMAC_MACHASH1)
+#define emac_arch_get_hash2()	 emac_get_reg(EMAC_MACHASH2)
+#define emac_arch_get_promisc()  (emac_get_reg(EMAC_RXMBPENABLE) & EMAC_B_RXCAFEN)
+#define emac_arch_get_control()  (emac_get_reg(EMAC_MACCONTROL) &  \
+				      (EMAC_B_FULLDUPLEX | EMAC_B_RMIIDUPLEXMODE | \
+				      EMAC_B_GIG | EMAC_B_RMIISPEED))
+#define emac_arch_set_hash1(a)	 emac_set_reg(EMAC_MACHASH1, a)
+#define emac_arch_set_hash2(a)	 emac_set_reg(EMAC_MACHASH2, a)
+#define emac_arch_set_promisc(a) \
+	do {								\
+		if (a)							\
+			emac_setbit_reg(EMAC_RXMBPENABLE, EMAC_B_RXCAFEN); \
+	} while (0)
+#define emac_arch_set_control(a) \
+	do { \
+		if (a) \
+			emac_setbit_reg(EMAC_MACCONTROL, a); \
+	} while (0)
+#define emac_arch_init_control(pace) \
+	emac_setbit_reg(EMAC_MACCONTROL, (pace) ? \
+			(EMAC_B_GMIIEN | EMAC_B_TXPACE) : \
+			EMAC_B_GMIIEN)
+
+#define ectl_arch_rx_irq_enter(c)
+#define ectl_arch_rx_irq_leave(c)
+#define ectl_arch_tx_irq_enter(c)
+#define ectl_arch_tx_irq_leave(c)
+#define ectl_arch_enable_irq(c, misc)  emac_setbit_reg(EMAC_EWCTL, EMAC_B_INTEN)
+#define ectl_arch_disable_irq(c) emac_clearbit_reg(EMAC_EWCTL, EMAC_B_INTEN)
+
+#define emac_arch_get_int_vector()	    emac_get_reg(EMAC_MACINVECTOR)
+#define emac_arch_get_pending_irq(i, f, c)  ((i) & ((f) << (c)))
+#define emac_arch_enable_irq(reg, c)	    emac_set_reg(reg, 1 << (c))
+
+#define emac_arch_reset_switch()
+
+/* Disable EMAC/MDIO interrupts and reset EMAC/MDIO modules */
+#define emac_arch_reset_ectl()	  emac_clearbit_reg(EMAC_EWCTL, EMAC_B_INTEN)
+
+#define emac_arch_set_pacing() do {					\
+		/* Wait at least 100 cycles */				\
+		emac_get_reg(EMAC_EWINTTCNT);				\
+		emac_get_reg(EMAC_EWINTTCNT);				\
+		emac_get_reg(EMAC_EWINTTCNT);				\
+		emac_get_reg(EMAC_EWINTTCNT);				\
+		emac_get_reg(EMAC_EWINTTCNT);				\
+		/* Set interrupt timer count (decremented at cpuclk/6) */ \
+		emac_set_reg(EMAC_EWINTTCNT, 15000);			\
+	} while (0)
+
+#define emac_arch_clear_mac_addr()		 \
+	for (i = 0; i < 32; i++) {		 \
+		emac_set_reg(EMAC_MACINDEX, i);	 \
+		emac_set_reg(EMAC_MACADDRHI, 0); \
+		emac_set_reg(EMAC_MACADDRLO, 0); \
+	}
+
+#define emac_arch_set_mac_addr_index(i) emac_set_reg(EMAC_MACINDEX, i)
+#define emac_arch_set_mac_addr_high(a)	emac_set_reg(EMAC_MACADDRHI, a)
+#define emac_arch_set_mac_addr_low(a)	emac_set_reg(EMAC_MACADDRLO, a)
+#define emac_arch_get_mac_addr_high(a)	emac_get_reg(EMAC_MACADDRHI)
+#define emac_arch_get_mac_addr_low(a)	emac_get_reg(EMAC_MACADDRLO)
+
+#define emac_check_shared_capability()	0
+
+#define rmii_arch_fix()
+
+#define EMAC_TIMER_TICK_MDIO
+#define EMAC_DO_INIT_MDIO
+
+#endif
+
+#ifdef EFUSE_REG_MAC_ADDR
+
+#define EFUSE_REG1 __SYSREG(EFUSE_REG_MAC_ADDR + 4, unsigned int)
+#define EFUSE_REG0 __SYSREG(EFUSE_REG_MAC_ADDR, unsigned int)
+
+/* Read the e-fuse value as 32 bit values to be endian independent */
+static inline int emac_arch_get_mac_addr_from_efuse(char *x)
+{
+	unsigned int addr0, addr1;
+
+	addr1 = EFUSE_REG1;
+	addr0 = EFUSE_REG0;
+
+#if defined(CONFIG_SOC_TMS320C6472)
+	x[0] = (addr0 & 0xff000000) >> 24;
+	x[1] = (addr0 & 0x00ff0000) >> 16;
+	x[2] = (addr0 & 0x0000ff00) >> 8;
+	x[3] = addr0 & 0x000000ff;
+	x[4] = (addr1 & 0xff000000) >> 24;
+	x[5] = (addr1 & 0x00ff0000) >> 16;
+#elif defined(CONFIG_SOC_TMS320C6474) || defined(CONFIG_SOC_TMS320C6457)
+	x[0] = (addr1 & 0x0000ff00) >> 8;
+	x[1] = addr1 & 0x000000ff;
+	x[2] = (addr0 & 0xff000000) >> 24;
+	x[3] = (addr0 & 0x00ff0000) >> 16;
+	x[4] = (addr0 & 0x0000ff00) >> 8;
+	x[5] = addr0 & 0x000000ff;
+#else
+#error "Missing SoC support for emac_arch_get_mac_addr"
+#endif
+	return 0;
+}
+#endif /* EFUSE_REG_MAC_ADDR */
+
+#endif /* __MACH_C6X_GEMAC_H */
diff --git a/arch/c6x/platforms/include/mach/gmdio.h b/arch/c6x/platforms/include/mach/gmdio.h
new file mode 100644
index 0000000..aad05ee
--- /dev/null
+++ b/arch/c6x/platforms/include/mach/gmdio.h
@@ -0,0 +1,18 @@
+/*
+ *  linux/arch/c6x/platforms/include/mach/gmdio.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2010 Texas Instruments Incorporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef __MACH_C6X_GMDIO_H
+#define __MACH_C6X_GMDIO_H
+
+#define MDIO_REG_BASE	  0x02c81800
+
+#endif	/* __MACH_C6X_GMDIO_H */
diff --git a/arch/c6x/platforms/include/mach/hardware.h b/arch/c6x/platforms/include/mach/hardware.h
new file mode 100644
index 0000000..526962c
--- /dev/null
+++ b/arch/c6x/platforms/include/mach/hardware.h
@@ -0,0 +1,194 @@
+/*
+ *  linux/arch/c6x/mach-evm6486/include/mach/hardware.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2010, 2011 Texas Instruments Incorporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef __ASM_C6X_MACH_HARDWARE_H
+#define __ASM_C6X_MACH_HARDWARE_H
+
+/*
+ * Misc. hardware defines which should probably have their own home
+ * so we can get rid of hardware.h altogether.
+ */
+
+/*
+ * Memory address space
+ */
+#if defined(CONFIG_SOC_TMS320C6455)
+#define RAM_EMIFA_CE2	  0xa0000000
+#define RAM_EMIFA_CE3	  0xb0000000
+#define RAM_EMIFA_CE4	  0xc0000000
+#define RAM_EMIFA_CE5	  0xd0000000
+#define RAM_DDR2_CE0	  0xe0000000
+#define RAM_MEMORY_START  RAM_DDR2_CE0
+
+#elif defined(CONFIG_SOC_TMS320C6457)
+#define RAM_EMIFA_CE2	  0xa0000000
+#define RAM_EMIFA_CE3	  0xb0000000
+#define RAM_EMIFA_CE4	  0xc0000000
+#define RAM_EMIFA_CE5	  0xd0000000
+#define RAM_DDR2_CE0	  0xe0000000
+#define RAM_MEMORY_START  RAM_DDR2_CE0
+
+#elif defined(CONFIG_SOC_TMS320C6472)
+#define RAM_SRAM	  0x00800000
+#define RAM_SRAM_BASE	  0x10800000
+#define RAM_SRAM_OFFSET   0x01000000
+#define RAM_SRAM_SIZE	  0x00100000
+#define RAM_EMIFA_CE2	  0xa0000000
+#define RAM_EMIFA_CE3	  0xb0000000
+#define RAM_EMIFA_CE4	  0xc0000000
+#define RAM_EMIFA_CE5	  0xd0000000
+#define RAM_DDR2_CE0	  0xe0000000
+#define RAM_MEMORY_START  RAM_DDR2_CE0
+
+#elif defined(CONFIG_SOC_TMS320C6474)
+#define RAM_SRAM	  0x00800000
+#define RAM_SRAM_BASE	  0x10800000
+#define RAM_SRAM_OFFSET   0x01000000
+#define RAM_SRAM_SIZE	  0x00100000
+#define RAM_EMIFA_CE2	  0xa0000000
+#define RAM_EMIFA_CE3	  0xb0000000
+#define RAM_EMIFA_CE4	  0xc0000000
+#define RAM_EMIFA_CE5	  0xd0000000
+#define RAM_DDR2_CE0	  0x80000000
+#define RAM_MEMORY_START  RAM_DDR2_CE0
+
+#else
+#error "No SoC memory address space defines"
+#endif
+
+/*
+ * VBUS clock Rate in MHz (1-255)
+ */
+#define VBUSCLK		  165
+
+/*
+ * GPIO registers base
+ */
+#define GPIO_REG_BASE	  0x02b00000
+
+/*
+ * PSC Registers
+ */
+#if defined(CONFIG_SOC_TMS320C6474)
+#define PSC_PTCMD		     __SYSREG(0x02ac0120, unsigned int)
+#define PSC_PDSTAT0		     __SYSREG(0x02ac0200, unsigned int)
+#define PSC_PDSTAT1		     __SYSREG(0x02ac0204, unsigned int)
+#define PSC_PDSTAT2		     __SYSREG(0x02ac0208, unsigned int)
+#define PSC_PDSTAT3		     __SYSREG(0x02ac020c, unsigned int)
+#define PSC_PDSTAT4		     __SYSREG(0x02ac0210, unsigned int)
+#define PSC_PDSTAT5		     __SYSREG(0x02ac0214, unsigned int)
+#define PSC_PDCTL0		     __SYSREG(0x02ac0300, unsigned int)
+#define PSC_PDCTL1		     __SYSREG(0x02ac0304, unsigned int)
+#define PSC_PDCTL2		     __SYSREG(0x02ac0308, unsigned int)
+#define PSC_PDCTL3		     __SYSREG(0x02ac030c, unsigned int)
+#define PSC_PDCTL4		     __SYSREG(0x02ac0310, unsigned int)
+#define PSC_PDCTL5		     __SYSREG(0x02ac0314, unsigned int)
+#define PSC_MDSTAT0		     __SYSREG(0x02ac0800, unsigned int)
+#define PSC_MDSTAT1		     __SYSREG(0x02ac0804, unsigned int)
+#define PSC_MDSTAT2		     __SYSREG(0x02ac0808, unsigned int)
+#define PSC_MDSTAT3		     __SYSREG(0x02ac080c, unsigned int)
+#define PSC_MDSTAT4		     __SYSREG(0x02ac0810, unsigned int)
+#define PSC_MDSTAT5		     __SYSREG(0x02ac0814, unsigned int)
+#define PSC_MDSTAT6		     __SYSREG(0x02ac0818, unsigned int)
+#define PSC_MDSTAT7		     __SYSREG(0x02ac081c, unsigned int)
+#define PSC_MDSTAT8		     __SYSREG(0x02ac0820, unsigned int)
+#define PSC_MDSTAT9		     __SYSREG(0x02ac0824, unsigned int)
+#define PSC_MDSTAT10		     __SYSREG(0x02ac0828, unsigned int)
+#define PSC_MDCTL0		     __SYSREG(0x02ac0a00, unsigned int)
+#define PSC_MDCTL1		     __SYSREG(0x02ac0a04, unsigned int)
+#define PSC_MDCTL2		     __SYSREG(0x02ac0a08, unsigned int)
+#define PSC_MDCTL3		     __SYSREG(0x02ac0a0c, unsigned int)
+#define PSC_MDCTL4		     __SYSREG(0x02ac0a10, unsigned int)
+#define PSC_MDCTL5		     __SYSREG(0x02ac0a14, unsigned int)
+#define PSC_MDCTL6		     __SYSREG(0x02ac0a18, unsigned int)
+#define PSC_MDCTL7		     __SYSREG(0x02ac0a1c, unsigned int)
+#define PSC_MDCTL8		     __SYSREG(0x02ac0a20, unsigned int)
+#define PSC_MDCTL9		     __SYSREG(0x02ac0a24, unsigned int)
+#define PSC_MDCTL10		     __SYSREG(0x02ac0a28, unsigned int)
+#define PSC_MDCTL11		     __SYSREG(0x02ac0a2c, unsigned int)
+#endif	/* CONFIG_SOC_TMS320C6474 */
+
+#if defined(CONFIG_SOC_TMS320C6472)
+#define PSC_PID			     __SYSREG(0x02ae0000, unsigned int)
+#define PSC_INTEVAL		     __SYSREG(0x02ae0018, unsigned int)
+#define PSC_MERRPR		     __SYSREG(0x02ae0040, unsigned int)
+#define PSC_MERRCR		     __SYSREG(0x02ae0050, unsigned int)
+#define PSC_PTCMD		     __SYSREG(0x02ae0120, unsigned int)
+#define PSC_PTSTAT		     __SYSREG(0x02ae0128, unsigned int)
+#define PSC_MDSTAT0		     __SYSREG(0x02ae0800, unsigned int)
+#define PSC_MDSTAT1		     __SYSREG(0x02ae0804, unsigned int)
+#define PSC_MDSTAT2		     __SYSREG(0x02ae0808, unsigned int)
+#define PSC_MDSTAT3		     __SYSREG(0x02ae080c, unsigned int)
+#define PSC_MDSTAT4		     __SYSREG(0x02ae0810, unsigned int)
+#define PSC_MDSTAT5		     __SYSREG(0x02ae0814, unsigned int)
+#define PSC_MDSTAT6		     __SYSREG(0x02ae0818, unsigned int)
+#define PSC_MDSTAT7		     __SYSREG(0x02ae081c, unsigned int)
+#define PSC_MDSTAT8		     __SYSREG(0x02ae0820, unsigned int)
+#define PSC_MDSTAT9		     __SYSREG(0x02ae0824, unsigned int)
+#define PSC_MDSTAT10		     __SYSREG(0x02ae0828, unsigned int)
+#define PSC_MDSTAT11		     __SYSREG(0x02ae082c, unsigned int)
+#define PSC_MDSTAT12		     __SYSREG(0x02ae0830, unsigned int)
+#define PSC_MDSTAT13		     __SYSREG(0x02ae0834, unsigned int)
+#define PSC_MDCTL0		     __SYSREG(0x02ae0a00, unsigned int)
+#define PSC_MDCTL1		     __SYSREG(0x02ae0a04, unsigned int)
+#define PSC_MDCTL2		     __SYSREG(0x02ae0a08, unsigned int)
+#define PSC_MDCTL3		     __SYSREG(0x02ae0a0c, unsigned int)
+#define PSC_MDCTL4		     __SYSREG(0x02ae0a10, unsigned int)
+#define PSC_MDCTL5		     __SYSREG(0x02ae0a14, unsigned int)
+#define PSC_MDCTL6		     __SYSREG(0x02ae0a18, unsigned int)
+#define PSC_MDCTL7		     __SYSREG(0x02ae0a1c, unsigned int)
+#define PSC_MDCTL8		     __SYSREG(0x02ae0a20, unsigned int)
+#define PSC_MDCTL9		     __SYSREG(0x02ae0a24, unsigned int)
+#define PSC_MDCTL10		     __SYSREG(0x02ae0a28, unsigned int)
+#define PSC_MDCTL11		     __SYSREG(0x02ae0a2c, unsigned int)
+#define PSC_MDCTL12		     __SYSREG(0x02ae0a30, unsigned int)
+#define PSC_MDCTL13		     __SYSREG(0x02ae0a34, unsigned int)
+#endif	/* CONFIG_SOC_TMS320C6472 */
+
+/*
+ * TCI648x megamodules misc registers & constants
+ */
+#define MM_REVID		     0x01812000
+
+#if defined(CONFIG_SOC_TMS320C6474)
+#define CORE_NUM		     3
+#define C6X_SOC_HAS_CORE_REV
+#elif defined(CONFIG_SOC_TMS320C6472)
+#define CORE_NUM		     6
+#else
+#define CORE_NUM		     1
+#endif
+
+/*
+ * Inter-DSP Interrupt Registers
+ */
+#if defined(CONFIG_SOC_TMS320C6474)
+#define IPCGR_BASE		     0x02880900
+#define IPCAR_BASE		     0x02880940
+#endif
+#if defined(CONFIG_SOC_TMS320C6472)
+#define NMIGR_BASE		     0x02a80500
+#define IPCGR_BASE		     0x02a80540
+#define IPCAR_BASE		     0x02a80580
+#endif
+
+#if defined(CONFIG_SOC_TMS320C6474)
+/*
+ * MCBSP registers base
+ */
+#define MCBSP0_BASE_ADDR	     0x028c0000
+#define MCBSP1_BASE_ADDR	     0x028d0000
+#define MCBSP0_EDMA_BASE_ADDR	     0x30000000
+#define MCBSP1_EDMA_BASE_ADDR	     0x34000000
+#endif
+
+#endif	/* __ASM_C6X_MACH_HARDWARE_H */
diff --git a/arch/c6x/platforms/include/mach/irq-c645x.h b/arch/c6x/platforms/include/mach/irq-c645x.h
new file mode 100644
index 0000000..af027ea
--- /dev/null
+++ b/arch/c6x/platforms/include/mach/irq-c645x.h
@@ -0,0 +1,131 @@
+/*
+ *  arch/c6x/platforms/include/mach/irq-c645x.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2006, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef __MACH_IRQ_C645X_H
+#define __MACH_IRQ_C645X_H
+
+/*
+ * C645x peripheral interrupt sources
+ */
+#define IRQ_EVT0	  0   /* combined events */
+#define IRQ_EVT1	  1
+#define IRQ_EVT2	  2
+#define IRQ_EVT3	  3
+#define IRQ_EMUDTDMA	  9   /* emulator events */
+#define IRQ_EMURTDXRX	  11
+#define IRQ_EMURTDXTX	  12
+#define IRQ_IDMAINT0	  13  /* IDMA channel 0 event */
+#define IRQ_IDMAINT1	  14  /* IDMA channel 1 event */
+#define IRQ_DSPINT	  15  /* HPI/PCI-to-DSP event */
+#define IRQ_I2CINT	  16  /* I2C event */
+#define IRQ_EMACINT	  17  /* EMAC event */
+#define IRQ_AEASYNCERR	  18  /* EMIFA error event */
+#define IRQ_RIOINT0	  20  /* RapidIO events */
+#define IRQ_RIOINT1	  21
+#if defined(CONFIG_SOC_TMS320C6455)
+#define IRQ_RIOINT4	  22
+#endif
+#if defined(CONFIG_SOC_TMS320C6457)
+#define IRQ_RIOINT2	  23
+#define IRQ_RIOINT3	  24
+#endif
+#define IRQ_EDMA3CCGINT   24  /* EDMA channel completion event */
+#if defined(CONFIG_SOC_TMS320C6457)
+#define IRQ_EMACRXINT	  25
+#define IRQ_EMACTXINT	  26
+#define IRQ_EMACTHRES	  27
+#define IRQ_RIOINT4	  28
+#define IRQ_RIOINT5	  28
+#define IRQ_RIOINT6	  28
+#else
+#define IRQ_EMACRXINT	  IRQ_EMACINT
+#define IRQ_EMACTXINT	  IRQ_EMACINT
+#endif
+#define IRQ_VCP2INT	  32  /* VCP2 error event */
+#if defined(CONFIG_SOC_TMS320C6455)
+#define IRQ_TCP2INT	  33  /* TCP2 error event */
+#endif
+#if defined(CONFIG_SOC_TMS320C6457)
+#define IRQ_TCP2AINT	  33  /* TCP2 error event */
+#define IRQ_TCP2BINT	  34  /* TCP2 error event */
+#endif
+#define IRQ_UINT	  36  /* UTOPIA event */
+#define IRQ_RINT0	  40  /* McBSP event */
+#define IRQ_XINT0	  41
+#define IRQ_RINT1	  42
+#define IRQ_XINT1	  43
+#define IRQ_GPIO_START	  51
+#define IRQ_GPIO0	  51  /* GPIO events */
+#define IRQ_GPIO1	  52
+#define IRQ_GPIO2	  53
+#define IRQ_GPIO3	  54
+#define IRQ_GPIO4	  55
+#define IRQ_GPIO5	  56
+#define IRQ_GPIO6	  57
+#define IRQ_GPIO7	  58
+#define IRQ_GPIO8	  59
+#define IRQ_GPIO9	  60
+#define IRQ_GPIO10	  61
+#define IRQ_GPIO11	  62
+#define IRQ_GPIO12	  63
+#define IRQ_GPIO13	  64
+#define IRQ_GPIO14	  65
+#define IRQ_GPIO15	  66
+#define IRQ_TINT0	  67  /* timer events */
+#define IRQ_TINTLO0	  67
+#define IRQ_TINTHI0	  68
+#define IRQ_TINT1	  69
+#define IRQ_TINTLO1	  69
+#define IRQ_TINTHI1	  70
+#define IRQ_EDMA3CCINT0   71  /* EDMA events */
+#define IRQ_EDMA3CCINT1   72
+#define IRQ_EDMA3CCINT2   73
+#define IRQ_EDMA3CCINT3   74
+#define IRQ_EDMA3CCINT4   75
+#define IRQ_EDMA3CCINT5   76
+#define IRQ_EDMA3CCINT6   77
+#define IRQ_EDMA3CCINT7   78
+#define IRQ_EDMA3CCERRINT 79
+#define IRQ_EDMA3CCMPINT  80
+#define IRQ_EDMA3C0ERRINT 81
+#define IRQ_EDMA3C1ERRINT 82
+#define IRQ_EDMA3C2ERRINT 83
+#define IRQ_EDMA3C3ERRINT 84
+#if defined(CONFIG_SOC_TMS320C6457)
+#define IRQ_EDMA3CCAET	  85
+#define IRQ_EDMA3C4ERRINT 86
+#define IRQ_EDMA3C5ERRINT 86
+#define IRQ_ETBOVFLINT	  94
+#define IRQ_ETBUNFLINT	  95
+#endif
+#define IRQ_INTERR	  96  /* interrupt controller dropped CPU interrupt event */
+#define IRQ_EMCIDMAERR	  97  /* EMC invalid IDMA parameters */
+#if defined(CONFIG_SOC_TMS320C6457)
+#define IRQ_EFIINTA	  100
+#define IRQ_EFIINTB	  101
+#define IRQ_L1PED1	  113
+#define IRQ_L1ED1	  116
+#define IRQ_L2ED1	  117
+#define IRQ_PDCINT	  118
+#endif
+#define IRQ_L1PCMPA	  120 /* L1P CPU memory protection fault */
+#define IRQ_L1PDMPA	  121 /* L1P DMA memory protection fault */
+#define IRQ_L1DCMPA	  122 /* L1D CPU memory protection fault */
+#define IRQ_L1DDMPA	  123 /* L1D DMA memory protection fault */
+#define IRQ_L2CMPA	  124 /* L2 CPU memory protection fault */
+#define IRQ_L2CDMPA	  125 /* L2 DMA memory protection fault */
+#define IRQ_IDMACMPA	  126 /* IDMA CPU memory protection fault */
+#define IRQ_IDMABUSERR	  127 /* IDMA bus error fault */
+
+#define NR_SOC_IRQS	  128
+
+#endif /* __MACH_IRQ_C645X_H */
diff --git a/arch/c6x/platforms/include/mach/irq-c6472.h b/arch/c6x/platforms/include/mach/irq-c6472.h
new file mode 100644
index 0000000..5c5522f
--- /dev/null
+++ b/arch/c6x/platforms/include/mach/irq-c6472.h
@@ -0,0 +1,138 @@
+/*
+ *  arch/c6x/platforms/include/mach/irq-c6472.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2006, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef __MACH_IRQ_C6472_H
+#define __MACH_IRQ_C6472_H
+
+#define IRQ_EVT0	  0   /* combined events */
+#define IRQ_EVT1	  1
+#define IRQ_EVT2	  2
+#define IRQ_EVT3	  3
+#define IRQ_RIOINT	  4   /* RapidIO individual interrupt */
+#define IRQ_EMACRXINT	  5
+#define IRQ_EMACTXINT	  6
+#define IRQ_EMACRXINT0	  5
+#define IRQ_EMACTXINT0	  6
+#define IRQ_EMACRXINT1	  7
+#define IRQ_EMACTXINT1	  8
+#define IRQ_EMUDTDMA	  9   /* emulator events */
+#define IRQ_RESERVED	  10  /* reserved */
+#define IRQ_EMURTDXRX	  11
+#define IRQ_EMURTDXTX	  12
+#define IRQ_IDMAINT0	  13  /* IDMA channel 0 interrupt */
+#define IRQ_IDMAINT1	  14  /* IDMA channel 1 interrupt */
+#define IRQ_EDMA3CCINT	  15  /* EDMA3CC completion interrupt */
+#define IRQ_TINT	  16  /* timer interrupts */
+#define IRQ_TINTLO	  16
+#define IRQ_TINTHI	  17
+#define IRQ_TINT6	  18
+#define IRQ_TINTLO6	  18
+#define IRQ_TINTHI6	  19
+#define IRQ_TINT7	  20
+#define IRQ_TINTLO7	  20
+#define IRQ_TINTHI7	  21
+#define IRQ_TINT8	  22
+#define IRQ_TINTLO8	  22
+#define IRQ_TINTHI8	  23
+#define IRQ_TINT9	  24
+#define IRQ_TINTLO9	  24
+#define IRQ_TINTHI9	  25
+#define IRQ_TINT10	  26
+#define IRQ_TINTLO10	  26
+#define IRQ_TINTHI10	  27
+#define IRQ_TINT11	  28
+#define IRQ_TINTLO11	  28
+#define IRQ_TINTHI11	  29
+#define IRQ_PRINT	  30  /* UTOPIA-PDMA interrupts */
+#define IRQ_PXINT	  31
+#define IRQ_RFSINT0	  32  /* TSIP interrupts */
+#define IRQ_RSFINT0	  33
+#define IRQ_XFSINT0	  34
+#define IRQ_XSFINT0	  35
+#define IRQ_RFSINT1	  36
+#define IRQ_RSFINT1	  37
+#define IRQ_XFSINT1	  38
+#define IRQ_XSFINT1	  39
+#define IRQ_RFSINT2	  40
+#define IRQ_RSFINT2	  41
+#define IRQ_XFSINT2	  42
+#define IRQ_XSFINT2	  43
+#define IRQ_RIOINT6	  44  /* RapidIO common/error interrupts */
+#define IRQ_RIOINT7	  45
+#define IRQ_ERRINT0	  50  /* TSIP0 error interrupt */
+#define IRQ_ERRINT1	  52
+#define IRQ_ERRINT2	  54
+#define IRQ_UINT	  56  /* UTOPIA interrupt */
+#define IRQ_EDMA3CCERR	  57  /* EDMA3 interrupts */
+#define IRQ_EDMA3CCMP	  58
+#define IRQ_EDMA3TCERR0   59
+#define IRQ_EDMA3TCERR1   60
+#define IRQ_EDMA3TCERR2   61
+#define IRQ_EDMA3TCERR3   62
+#define IRQ_SMCMPINT	  63  /* SMC interrupts */
+#define IRQ_SMCPEVT	  64  /* SMC interrupts */
+#define IRQ_PSCINT	  65  /* PSC interrupt */
+#define IRQ_EDMA3CCAETEVT 66  /* EDMA3 interrupts */
+#define IRQ_EDMA3CCINT6   67
+#define IRQ_EDMA3CCINT7   68
+#define IRQ_EDMA3CCGINT   69
+#define IRQ_EMACINT	  70  /* EMAC interrupts */
+#define IRQ_EMACINT0	  70
+#define IRQ_EMACINT1	  71
+#define IRQ_I2CINT	  72  /* I2C interrupt */
+
+/*
+ * An IRQ from one and only one of GPIO 0-5 gets routed to core 0-5.
+ * core0 gets IRQ_GPIO0, core1 gets IRQ_GPIO1, etc.
+ */
+#define IRQ_GPIO_START	  73
+#define IRQ_GPIOINT	  73
+#define IRQ_GPIO6	  74
+#define IRQ_GPIO7	  75
+#define IRQ_GPIO8	  76
+#define IRQ_GPIO9	  77
+#define IRQ_GPIO10	  78
+#define IRQ_GPIO11	  79
+#define IRQ_GPIO12	  80
+#define IRQ_GPIO13	  81
+#define IRQ_GPIO14	  82
+#define IRQ_GPIO15	  83
+#define IRQ_IPCLOCAL	  84  /* inter DSP interrupt from IPCGR */
+#define IRQ_HPIINT	  85  /* HPI interrupt */
+#define IRQ_CPUINT0	  87
+#define IRQ_CPUINT1	  88
+#define IRQ_CPUINT2	  89
+#define IRQ_CPUINT3	  90
+#define IRQ_CPUINT4	  91
+#define IRQ_CPUINT5	  92
+#define IRQ_L2PDWAKE	  93  /* L2 wake interrupt */
+#define IRQ_INTERR	  96  /* interrupt controller dropped CPU interrupt event */
+#define IRQ_EMCIDMAERR	  97  /* EMC invalid IDMA parameters */
+#define IRQ_PBISTINT	  98  /* PBIS interrupt */
+#define IRQ_EFINTA	  100 /* EFI interrupt from side A */
+#define IRQ_EFINTB	  101 /* EFI interrupt from side B */
+#define IRQ_PMCED	  113 /* single bit error detected during DMA read */
+#define IRQ_UMCED1	  116 /* corrected bit error detected */
+#define IRQ_UMCED2	  117 /* uncorrected bit error detected */
+#define IRQ_PDCINT	  118 /* PDC sleep interrupt */
+#define IRQ_L1PCMPA	  120 /* L1P CPU memory protection fault */
+#define IRQ_L1PDMPA	  121 /* L1P DMA memory protection fault */
+#define IRQ_L1DCMPA	  122 /* L1D CPU memory protection fault */
+#define IRQ_L1DDMPA	  123 /* L1D DMA memory protection fault */
+#define IRQ_L2CMPA	  124 /* L2 CPU memory protection fault */
+#define IRQ_L2CDMPA	  125 /* L2 DMA memory protection fault */
+#define IRQ_EMCCMPA	  126 /* external CPU memory protection fault */
+#define IRQ_EMCBUSERR	  127 /* bus error interrupt */
+
+#define NR_SOC_IRQS	  128
+
+#endif /* __MACH_IRQ_C6472_H */
diff --git a/arch/c6x/platforms/include/mach/irq-c6474.h b/arch/c6x/platforms/include/mach/irq-c6474.h
new file mode 100644
index 0000000..3ede1f6
--- /dev/null
+++ b/arch/c6x/platforms/include/mach/irq-c6474.h
@@ -0,0 +1,323 @@
+/*
+ *  arch/c6x/platforms/include/mach/irq-c6474.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2006, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@jaluna.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef __MACH_IRQ_C6474_H
+#define __MACH_IRQ_C6474_H
+
+#define IRQ_EVT0	0   /* combined events */
+#define IRQ_EVT1	1
+#define IRQ_EVT2	2
+#define IRQ_EVT3	3
+#define IRQ_SEMINT	4   /* semaphore grant interrupt */
+#define IRQ_EMACINT	5   /* EMAC interrupts */
+#define IRQ_EMACRXINT	6
+#define IRQ_EMACTXINT	7
+#define IRQ_EMACTHRES	8
+#define IRQ_EMUDTDMA	9   /* emulator events */
+#define IRQ_RACINT	10  /* RAC interrupt */
+#define IRQ_EMURTDXRX	11
+#define IRQ_EMURTDXTX	12
+#define IRQ_IDMAINT0	13  /* IDMA channel 0 interrupt */
+#define IRQ_IDMAINT1	14  /* IDMA channel 1 interrupt */
+#define IRQ_FSEVT0	15  /* frame synchronization events */
+#define IRQ_FSEVT1	16
+#define IRQ_FSEVT2	17
+#define IRQ_FSEVT3	18
+#define IRQ_FSEVT4	19
+#define IRQ_FSEVT5	29
+#define IRQ_FSEVT6	21
+#define IRQ_FSEVT7	22
+#define IRQ_FSEVT8	23
+#define IRQ_FSEVT9	24
+#define IRQ_FSEVT10	25
+#define IRQ_FSEVT11	26
+#define IRQ_FSEVT12	27
+#define IRQ_FSEVT13	28
+#define IRQ_FSEVT14	29
+#define IRQ_FSEVT15	30
+#define IRQ_FSEVT16	31
+#define IRQ_FSEVT17	32
+#define IRQ_TINT0	33  /* timer interrupts */
+#define IRQ_TINTLO0	33
+#define IRQ_TINTHI0	34
+#define IRQ_TINT1	35
+#define IRQ_TINTLO1	35
+#define IRQ_TINTHI1	36
+#define IRQ_TINT2	37
+#define IRQ_TINTLO2	37
+#define IRQ_TINTHI2	38
+#define IRQ_TINT3	39
+#define IRQ_TINTLO3	39
+#define IRQ_TINTHI3	40
+#define IRQ_TINT4	41
+#define IRQ_TINTLO4	41
+#define IRQ_TINTHI4	42
+#define IRQ_TINT5	43
+#define IRQ_TINTLO5	43
+#define IRQ_TINTHI5	44
+#define IRQ_GPIO_START	45
+#define IRQ_GPIO0	45  /* GPIO events */
+#define IRQ_GPIO1	46
+#define IRQ_GPIO2	47
+#define IRQ_GPIO3	48
+#define IRQ_GPIO4	49
+#define IRQ_GPIO5	50
+#define IRQ_GPIO6	51
+#define IRQ_GPIO7	52
+#define IRQ_GPIO8	53
+#define IRQ_GPIO9	54
+#define IRQ_GPIO10	55
+#define IRQ_GPIO11	56
+#define IRQ_GPIO12	57
+#define IRQ_GPIO13	58
+#define IRQ_GPIO14	59
+#define IRQ_GPIO15	60
+#define IRQ_TPCCGINT	61  /* EDMA channel global completion interrupt */
+#define IRQ_TPCCINT0	62  /* TPCC completion interrupts */
+#define IRQ_TPCCINT1	63
+#define IRQ_TPCCINT2	64
+#define IRQ_TPCCINT3	65
+#define IRQ_TPCCINT4	66
+#define IRQ_TPCCINT5	67
+#define IRQ_TPCCINT6	68
+#define IRQ_TPCCINT7	69
+#define IRQ_RIOINT0	71  /* RapidIO interrupts */
+#define IRQ_RIOINT1	72
+#define IRQ_AIFEVT0	73  /* error/alarm events*/
+#define IRQ_AIFEVT1	74
+#define IRQ_IPCLOCAL	76  /* inter DSP interrupt from IPCGR */
+
+#define CIC_MAPBASE	80  /* start of system events from CIC */
+#define CIC_MAPLEN	14  /* number of events from CIC */
+
+#define IRQ_CICEVT0	80
+#define IRQ_CICEVT1	81
+#define IRQ_CICEVT2	82
+#define IRQ_CICEVT3	83
+#define IRQ_CICEVT4	84
+#define IRQ_CICEVT5	85
+#define IRQ_CICEVT6	86
+#define IRQ_CICEVT7	87
+#define IRQ_CICEVT8	88
+#define IRQ_CICEVT9	89
+#define IRQ_CICEVT10	90
+#define IRQ_CICEVT11	91
+#define IRQ_CICEVT12	92
+#define IRQ_CICEVT13	93
+
+#define IRQ_INTERR	96  /* irq controller dropped CPU interrupt event */
+#define IRQ_EMCIDMAERR	97  /* EMC invalid IDMA parameters */
+#define IRQ_EFINTA	100 /* EFI interrupt from side A */
+#define IRQ_EFINTB	101 /* EFI interrupt from side B */
+#define IRQ_PMCED	113 /* single bit error detected during DMA read */
+#define IRQ_UMCED1	116 /* corrected bit error detected */
+#define IRQ_UMCED2	117 /* uncorrected bit error detected */
+#define IRQ_PDCINT	118 /* PDC sleep interrupt */
+#define IRQ_SYSCMPA	119 /* CPU memory protection fault */
+#define IRQ_L1PCMPA	120 /* L1P CPU memory protection fault */
+#define IRQ_L1PDMPA	121 /* L1P DMA memory protection fault */
+#define IRQ_L1DCMPA	122 /* L1D CPU memory protection fault */
+#define IRQ_L1DDMPA	123 /* L1D DMA memory protection fault */
+#define IRQ_L2CMPA	124 /* L2 CPU memory protection fault */
+#define IRQ_L2CDMPA	125 /* L2 DMA memory protection fault */
+#define IRQ_EMCCMPA	126 /* external CPU memory protection fault */
+#define IRQ_EMCBUSERR	127 /* bus error interrupt */
+
+/*
+ * C6x Chip Interrupt Controller (CIC) events
+ */
+#define IRQ_CIC_START	128
+#define IRQ_I2CINT	(IRQ_CIC_START + 4)  /* I2C event */
+#define IRQ_FSERR1	(IRQ_CIC_START + 5)  /* error/alarm interrupts */
+#define IRQ_RIOINT7	(IRQ_CIC_START + 6)
+#define IRQ_FSERR2	(IRQ_CIC_START + 7)
+#define IRQ_VCPINT	(IRQ_CIC_START + 8)
+#define IRQ_TCPINT	(IRQ_CIC_START + 9)
+#define IRQ_RINT0	(IRQ_CIC_START + 10) /* McBSP event */
+#define IRQ_XINT0	(IRQ_CIC_START + 11)
+#define IRQ_RINT1	(IRQ_CIC_START + 12)
+#define IRQ_XINT1	(IRQ_CIC_START + 13)
+#define IRQ_REVT0	(IRQ_CIC_START + 14)
+#define IRQ_XEVT0	(IRQ_CIC_START + 15)
+#define IRQ_REVT1	(IRQ_CIC_START + 16)
+#define IRQ_XEVT1	(IRQ_CIC_START + 17)
+#define IRQ_IREVT1	(IRQ_CIC_START + 18) /* I2C EDMA events */
+#define IRQ_IXEVT1	(IRQ_CIC_START + 19)
+#define IRQ_FSEVT18	(IRQ_CIC_START + 20) /* frame synchronization events */
+#define IRQ_FSEVT19	(IRQ_CIC_START + 21)
+#define IRQ_FSEVT20	(IRQ_CIC_START + 22)
+#define IRQ_FSEVT21	(IRQ_CIC_START + 23)
+#define IRQ_FSEVT22	(IRQ_CIC_START + 24)
+#define IRQ_FSEVT23	(IRQ_CIC_START + 25)
+#define IRQ_FSEVT24	(IRQ_CIC_START + 26)
+#define IRQ_FSEVT25	(IRQ_CIC_START + 27)
+#define IRQ_FSEVT26	(IRQ_CIC_START + 28)
+#define IRQ_FSEVT27	(IRQ_CIC_START + 29)
+#define IRQ_FSEVT28	(IRQ_CIC_START + 30)
+#define IRQ_FSEVT29	(IRQ_CIC_START + 31)
+#define IRQ_VCPREVT	(IRQ_CIC_START + 32) /* VCP events */
+#define IRQ_VCPXEVT	(IRQ_CIC_START + 33)
+#define IRQ_TCPREVT	(IRQ_CIC_START + 34) /* TCP events */
+#define IRQ_TCPXEVT	(IRQ_CIC_START + 35)
+#define IRQ_TPCCERRINT	(IRQ_CIC_START + 36) /* TPCC error interrupt */
+#define IRQ_TPCCMPINT	(IRQ_CIC_START + 37) /* TPCSS memory protection interrupt */
+#define IRQ_TPTCERRINT0 (IRQ_CIC_START + 38) /* TPTC error interrupts */
+#define IRQ_TPTCERRINT1 (IRQ_CIC_START + 39)
+#define IRQ_TPTCERRINT2 (IRQ_CIC_START + 40)
+#define IRQ_TPTCERRINT3 (IRQ_CIC_START + 41)
+#define IRQ_TPTCERRINT4 (IRQ_CIC_START + 42)
+#define IRQ_TPTCERRINT5 (IRQ_CIC_START + 43)
+#define IRQ_TPTCAETEVT	(IRQ_CIC_START + 44) /* TPTC AET event */
+#define IRQ_AIFEVT2	(IRQ_CIC_START + 45) /* AIF CPU interrupts */
+#define IRQ_AIFEVT3	(IRQ_CIC_START + 46)
+#define IRQ_AIFPSEVT0	(IRQ_CIC_START + 47) /* packet switched transfer events */
+#define IRQ_AIFPSEVT1	(IRQ_CIC_START + 48)
+#define IRQ_AIFPSEVT2	(IRQ_CIC_START + 49)
+#define IRQ_AIFPSEVT3	(IRQ_CIC_START + 50)
+#define IRQ_AIFPSEVT4	(IRQ_CIC_START + 51)
+#define IRQ_AIFPSEVT5	(IRQ_CIC_START + 52)
+#define IRQ_AIFPSEVT6	(IRQ_CIC_START + 53)
+#define IRQ_AIFBUFEVT	(IRQ_CIC_START + 54)
+#define IRQ_RACDEVENT0	(IRQ_CIC_START + 56) /* debug events */
+#define IRQ_RACDEVENT1	(IRQ_CIC_START + 57)
+#define IRQ_SEMERR	(IRQ_CIC_START + 58)
+
+#define NR_CIC_IRQS	64
+
+#define NR_SOC_IRQS	(IRQ_CIC_START + NR_CIC_IRQS)
+
+/*
+ * C6x Chip Interrupt Controller (CIC) register layout
+ */
+#define CIC_REG_BASE(corenum) (0x02880000 + (0x100 * (corenum)))
+
+#define CIC_EVTFLAG(n)	__SYSREGA(CIC_REG_BASE(n) + 0x00, uint32_t)
+#define CIC_EVTSET(n)	__SYSREGA(CIC_REG_BASE(n) + 0x10, uint32_t)
+#define CIC_EVTCLR(n)	__SYSREGA(CIC_REG_BASE(n) + 0x20, uint32_t)
+#define CIC_EVTMASK(n)	__SYSREGA(CIC_REG_BASE(n) + 0x30, uint32_t)
+#define CIC_MEVTFLAG(n)	__SYSREGA(CIC_REG_BASE(n) + 0x40, uint32_t)
+#define CIC_MUX(n)	__SYSREGA(CIC_REG_BASE(n) + 0x50, uint32_t)
+
+#define CIC0_EVTFLAG	__SYSREGA(CIC_REG_BASE(0) + 0x00, uint32_t)
+#define CIC0_EVTSET	__SYSREGA(CIC_REG_BASE(0) + 0x10, uint32_t)
+#define CIC0_EVTCLR	__SYSREGA(CIC_REG_BASE(0) + 0x20, uint32_t)
+#define CIC0_EVTMASK	__SYSREGA(CIC_REG_BASE(0) + 0x30, uint32_t)
+#define CIC0_MEVTFLAG	__SYSREGA(CIC_REG_BASE(0) + 0x40, uint32_t)
+#define CIC0_MUX	__SYSREGA(CIC_REG_BASE(0) + 0x50, uint32_t)
+
+#define CIC1_EVTFLAG	__SYSREGA(CIC_REG_BASE(1) + 0x00, uint32_t)
+#define CIC1_EVTSET	__SYSREGA(CIC_REG_BASE(1) + 0x10, uint32_t)
+#define CIC1_EVTCLR	__SYSREGA(CIC_REG_BASE(1) + 0x20, uint32_t)
+#define CIC1_EVTMASK	__SYSREGA(CIC_REG_BASE(1) + 0x30, uint32_t)
+#define CIC1_MEVTFLAG	__SYSREGA(CIC_REG_BASE(1) + 0x40, uint32_t)
+#define CIC1_MUX	__SYSREGA(CIC_REG_BASE(1) + 0x50, uint32_t)
+
+#define CIC2_EVTFLAG	__SYSREGA(CIC_REG_BASE(2) + 0x00, uint32_t)
+#define CIC2_EVTSET	__SYSREGA(CIC_REG_BASE(2) + 0x10, uint32_t)
+#define CIC2_EVTCLR	__SYSREGA(CIC_REG_BASE(2) + 0x20, uint32_t)
+#define CIC2_EVTMASK	__SYSREGA(CIC_REG_BASE(2) + 0x30, uint32_t)
+#define CIC2_MEVTFLAG	__SYSREGA(CIC_REG_BASE(2) + 0x40, uint32_t)
+#define CIC2_MUX	__SYSREGA(CIC_REG_BASE(2) + 0x50, uint32_t)
+
+#define CIC3_EVTFLAG	__SYSREGA(CIC_REG_BASE(3) + 0x00, uint32_t)
+#define CIC3_EVTSET	__SYSREGA(CIC_REG_BASE(3) + 0x10, uint32_t)
+#define CIC3_EVTCLR	__SYSREGA(CIC_REG_BASE(3) + 0x20, uint32_t)
+#define CIC3_EVTMASK	__SYSREGA(CIC_REG_BASE(3) + 0x30, uint32_t)
+#define CIC3_MEVTFLAG	__SYSREGA(CIC_REG_BASE(3) + 0x40, uint32_t)
+#define CIC3_MUX	__SYSREGA(CIC_REG_BASE(3) + 0x50, uint32_t)
+
+/*
+ * CIC output events (16)
+ */
+#define CIC0		   0
+#define CIC1		   1
+#define CIC2		   2
+#define CIC3		   3
+#define CIC4		   4
+#define CIC5		   5
+#define CIC6		   6
+#define CIC7		   7
+#define CIC8		   8
+#define CIC9		   9
+#define CIC10		   10
+#define CIC11		   11
+#define CIC12		   12
+#define CIC13		   13
+#define CIC14		   14
+#define CIC15		   15
+
+/*
+ * CIC events for CIC3 (CIC TPCC)
+ */
+#define CIC_TPCC	  3   /* CIC TPPC is CIC3 */
+
+#define CIC_TPCC_EVT0	  0   /* combined events */
+#define CIC_TPCC_EVT1	  1
+#define CIC_TPCC_FSEVT0   2   /* frame synchronization events */
+#define CIC_TPCC_FSEVT1   3
+#define CIC_TPCC_FSEVT2   4
+#define CIC_TPCC_FSEVT3   5
+#define CIC_TPCC_FSEVT14  6
+#define CIC_TPCC_FSEVT15  7
+#define CIC_TPCC_FSEVT16  8
+#define CIC_TPCC_FSEVT17  9
+#define CIC_TPCC_FSEVT18  10
+#define CIC_TPCC_FSEVT19  11
+#define CIC_TPCC_FSEVT20  12
+#define CIC_TPCC_FSEVT21  13
+#define CIC_TPCC_FSEVT22  14
+#define CIC_TPCC_FSEVT23  15
+#define CIC_TPCC_FSEVT24  16
+#define CIC_TPCC_FSEVT25  17
+#define CIC_TPCC_FSEVT26  18
+#define CIC_TPCC_FSEVT27  19
+#define CIC_TPCC_FSEVT28  20
+#define CIC_TPCC_RIOINT0  21
+#define CIC_TPCC_RIOINT1  22
+#define CIC_TPCC_RIOINT2  23
+#define CIC_TPCC_RIOINT3  24
+#define CIC_TPCC_RIOINT4  25
+#define CIC_TPCC_RIOINT5  26
+#define CIC_TPCC_RIOINT7  27
+#define CIC_TPCC_MACINT0  28
+#define CIC_TPCC_MACRINT0 29
+#define CIC_TPCC_MACTINT0 30
+#define CIC_TPCC_MACINT1  31
+#define CIC_TPCC_MACRINT1 32
+#define CIC_TPCC_MACTINT1 33
+#define CIC_TPCC_MACINT2  34
+#define CIC_TPCC_MACRINT2 35
+#define CIC_TPCC_MACTINT2 36
+#define CIC_TPCC_SEMERR0  37
+#define CIC_TPCC_SEMERR1  38
+#define CIC_TPCC_SEMERR2  39
+#define CIC_TPCC_TINT3L   43
+#define CIC_TPCC_TINT3H   44
+#define CIC_TPCC_TINT4L   45
+#define CIC_TPCC_TINT4H   46
+#define CIC_TPCC_TINT5L   47
+#define CIC_TPCC_TINT5H   48
+#define CIC_TPCC_AIFTEVT0 49
+#define CIC_TPCC_AIFTEVT1 50
+#define CIC_TPCC_GPINT0   53
+#define CIC_TPCC_GPINT1   54
+#define CIC_TPCC_GPINT2   55
+#define CIC_TPCC_GPINT3   56
+#define CIC_TPCC_GPINT4   57
+#define CIC_TPCC_CIC0E14  58
+#define CIC_TPCC_CIC0E15  59
+#define CIC_TPCC_CIC1E14  60
+#define CIC_TPCC_CIC1E15  61
+#define CIC_TPCC_CIC2E14  62
+#define CIC_TPCC_CIC2E15  63
+
+#endif /* __MACH_IRQ_C6474_H */
diff --git a/arch/c6x/platforms/include/mach/irq.h b/arch/c6x/platforms/include/mach/irq.h
new file mode 100644
index 0000000..1d9b78c
--- /dev/null
+++ b/arch/c6x/platforms/include/mach/irq.h
@@ -0,0 +1,52 @@
+/*
+ *  linux/arch/c6x/platforms/include/mach/irq.h
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2010 Texas Instruments Incorporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#ifndef __MACH_C6X_IRQ_H
+#define __MACH_C6X_IRQ_H
+
+#if defined(CONFIG_SOC_TMS320C6455) || defined(CONFIG_SOC_TMS320C6457)
+#include <mach/irq-c645x.h>
+#elif defined(CONFIG_SOC_TMS320C6472)
+#include <mach/irq-c6472.h>
+#elif defined(CONFIG_SOC_TMS320C6474)
+#include <mach/irq-c6474.h>
+#else
+#error "No machine IRQ definitions"
+#endif
+
+#ifdef __KERNEL__
+
+#define IC_EVTFLAG	__SYSREGA(0x01800000, uint32_t)
+#define IC_EVTSET	__SYSREGA(0x01800020, uint32_t)
+#define IC_EVTCLR	__SYSREGA(0x01800040, uint32_t)
+#define IC_EVTMASK	__SYSREGA(0x01800080, uint32_t)
+#define IC_MEVTFLAG	__SYSREGA(0x018000a0, uint32_t)
+#define IC_EXPMASK	__SYSREGA(0x018000c0, uint32_t)
+#define IC_MEXPMASK	__SYSREGA(0x018000e0, uint32_t)
+#define IC_INTMUX	__SYSREGA(0x01800100, uint32_t)
+#define IC_AEGMUX	__SYSREGA(0x01800140, uint32_t)
+#define IC_INTXSTAT	__SYSREG(0x01800180, uint32_t)
+#define IC_INTXCLR	__SYSREG(0x01800184, uint32_t)
+#define IC_INTDMASK	__SYSREG(0x01800188, uint32_t)
+#define IC_EVTASRT	__SYSREG(0x018001c0, uint32_t)
+
+/*
+ * EVTASRT bits
+ */
+#define IC_B_EVTPULSE4	 (1 << 4)
+
+#define assert_event(evt) (IC_EVTASRT = (evt))
+
+#define NR_BOARD_IRQS	 0 /* Not used */
+
+#endif /* __KERNEL__ */
+#endif /* __MACH_C6X_IRQ_H */
diff --git a/arch/c6x/platforms/include/mach/pll.h b/arch/c6x/platforms/include/mach/pll.h
new file mode 100644
index 0000000..4d90775
--- /dev/null
+++ b/arch/c6x/platforms/include/mach/pll.h
@@ -0,0 +1,134 @@
+/*
+ *  linux/arch/c6x/platforms/include/mach/pll.h
+ *
+ *  PLL definitions for Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2010 Texas Instruments Incorporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#ifndef __MACH_C6X_PLL_H
+#define __MACH_C6X_PLL_H
+
+#if defined(CONFIG_SOC_TMS320C6455)
+#define ARCH_PLL1_BASE 0x029A0000
+#define ARCH_PLL2_BASE 0x029C0000
+
+/*
+ * Datasheet recommends a wait for 4 CLKIN cycles to ensure that the
+ * PLL has switched to bypass mode. Delay of 1us ensures we are good for
+ * all > 4MHz CLKIN inputs. Typically the input is ~25MHz.
+ * Units are micro seconds.
+ */
+#define PLL_BYPASS_TIME		1
+
+#define PLL_RESET_TIME		128
+#define PLL_LOCK_TIME		2000
+
+#elif defined(CONFIG_SOC_TMS320C6457)
+#define ARCH_PLL1_BASE 0x029A0000
+
+/*
+ * Datasheet recommends a wait for 4 CLKIN cycles to ensure that the
+ * PLL has switched to bypass mode. Delay of 1us ensures we are good for
+ * all > 4MHz CLKIN inputs. Typically the input is ~25MHz.
+ * Units are micro seconds.
+ */
+#define PLL_BYPASS_TIME		1
+
+#define PLL_RESET_TIME		1000
+#define PLL_LOCK_TIME		2000
+
+#elif defined(CONFIG_SOC_TMS320C6472)
+#define ARCH_PLL1_BASE 0x029A0000
+#define ARCH_PLL2_BASE 0x029C0000
+#define ARCH_PLL3_BASE 0x029C0400
+
+/*
+ * Datasheet recommends a wait for 4 CLKIN cycles to ensure that the
+ * PLL has switched to bypass mode. Delay of 1us ensures we are good for
+ * all > 4MHz CLKIN inputs. Typically the input is ~25MHz.
+ * Units are micro seconds.
+ */
+#define PLL_BYPASS_TIME		1
+
+#define PLL_RESET_TIME		256
+#define PLL_LOCK_TIME		2000
+
+#elif defined(CONFIG_SOC_TMS320C6474)
+#define ARCH_PLL1_BASE 0x029A0000
+
+/*
+ * Datasheet recommends a wait for 4 CLKIN cycles to ensure that the
+ * PLL has switched to bypass mode. Delay of 1us ensures we are good for
+ * all > 4MHz CLKIN inputs. Typically the input is ~25MHz.
+ * Units are micro seconds.
+ */
+#define PLL_BYPASS_TIME		1
+
+#define PLL_RESET_TIME		256
+#define PLL_LOCK_TIME		2000
+
+#endif
+
+/* PLL/Reset register offsets */
+#define PLLCTL		0x100
+#define PLLM		0x110
+#define PREDIV		0x114
+#define PLLDIV1		0x118
+#define PLLDIV2		0x11c
+#define PLLDIV3		0x120
+#define PLLPOSTDIV	0x128
+#define PLLCMD		0x138
+#define PLLSTAT		0x13c
+#define PLLALNCTL	0x140
+#define PLLDCHANGE	0x144
+#define PLLCKEN		0x148
+#define PLLCKSTAT	0x14c
+#define PLLSYSTAT	0x150
+#define PLLDIV4		0x160
+#define PLLDIV5		0x164
+#define PLLDIV6		0x168
+#define PLLDIV7		0x16c
+#define PLLDIV8		0x170
+#define PLLDIV9		0x174
+#define PLLDIV10	0x178
+#define PLLDIV11	0x17c
+#define PLLDIV12	0x180
+#define PLLDIV13	0x184
+#define PLLDIV14	0x188
+#define PLLDIV15	0x18c
+#define PLLDIV16	0x190
+
+/* PLLM register bits */
+#define PLLM_PLLM_MASK	0xff
+#define PLLM_VAL(x)	((x) - 1)
+
+/* PREDIV register bits */
+#define PLLPREDIV_EN	BIT(15)
+#define PLLPREDIV_VAL(x) ((x) - 1)
+
+/* PLLCTL register bits */
+#define PLLCTL_PLLEN	BIT(0)
+#define PLLCTL_PLLPWRDN	BIT(1)
+#define PLLCTL_PLLRST	BIT(3)
+#define PLLCTL_PLLDIS	BIT(4)
+#define PLLCTL_PLLENSRC	BIT(5)
+#define PLLCTL_CLKMODE	BIT(8)
+
+/* PLLCMD register bits */
+#define PLLCMD_GOSTAT	BIT(0)
+
+/* PLLSTAT register bits */
+#define PLLSTAT_GOSTAT	BIT(0)
+
+/* PLLDIV register bits */
+#define PLLDIV_EN	BIT(15)
+#define PLLDIV_RATIO_MASK 0x1f
+#define PLLDIV_RATIO(x) ((x) - 1)
+
+#endif /* __MACH_C6X_PLL_H */
diff --git a/arch/c6x/platforms/include/mach/timer.h b/arch/c6x/platforms/include/mach/timer.h
new file mode 100644
index 0000000..634b321
--- /dev/null
+++ b/arch/c6x/platforms/include/mach/timer.h
@@ -0,0 +1,104 @@
+/*
+ *  linux/arch/c6x/platforms/include/mach/timer.h
+ *
+ *  Timer definitions for Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2010, 2011 Texas Instruments Incorporated
+ *  Author: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#ifndef __MACH_C6X_TIMER_H
+#define __MACH_C6X_TIMER_H
+
+/*
+ * Timers register base
+ */
+#if defined(CONFIG_SOC_TMS320C6455) || defined(CONFIG_SOC_TMS320C6457)
+#define TIMER_BASE_ADDR   0x02940000
+#define TIMER_CHAN_MULT   0x40000
+#elif defined(CONFIG_SOC_TMS320C6472)
+#define TIMER_BASE_ADDR   0x025e0000
+#define TIMER_CHAN_MULT   0x10000
+#elif defined(CONFIG_SOC_TMS320C6474)
+#define TIMER_BASE_ADDR   0x02910000
+#define TIMER_CHAN_MULT   0x10000
+
+#define TIMER_TINPSEL	__SYSREG(0x02900000, unsigned int)
+#define TIMER_TOUTPSEL	__SYSREG(0x02900004, unsigned int)
+#define TIMER_WDRSTSEL	__SYSREG(0x02900008, unsigned int)
+#else
+#error "no timer base defined"
+#endif
+
+/*
+ * Timers management
+ */
+#define TIMER_BASE(chan)		(TIMER_BASE_ADDR + \
+					 ((chan) * TIMER_CHAN_MULT))
+#define TIMER_EMUMGTCLKSPD_REG(chan)	(TIMER_BASE(chan) + 0x04)
+#define TIMER_CNTLO_REG(chan)		(TIMER_BASE(chan) + 0x10)
+#define TIMER_CNTHI_REG(chan)		(TIMER_BASE(chan) + 0x14)
+#define TIMER_PRDLO_REG(chan)		(TIMER_BASE(chan) + 0x18)
+#define TIMER_PRDHI_REG(chan)		(TIMER_BASE(chan) + 0x1c)
+#define TIMER_TCR_REG(chan)		(TIMER_BASE(chan) + 0x20)
+#define TIMER_TGCR_REG(chan)		(TIMER_BASE(chan) + 0x24)
+#define TIMER_WDTCR_REG(chan)		(TIMER_BASE(chan) + 0x28)
+
+#define TIMER_B_TCR_TSTATLO	     0x001
+#define TIMER_B_TCR_INVOUTPLO	     0x002
+#define TIMER_B_TCR_INVINPLO	     0x004
+#define TIMER_B_TCR_CPLO	     0x008
+#define TIMER_B_TCR_ENAMODELO_ONCE   0x040
+#define TIMER_B_TCR_ENAMODELO_CONT   0x080
+#define TIMER_B_TCR_ENAMODELO_MASK   0x0c0
+#define TIMER_B_TCR_PWIDLO_MASK      0x030
+#define TIMER_B_TCR_CLKSRCLO	     0x100
+#define TIMER_B_TCR_TIENLO	     0x200
+#define TIMER_B_TCR_TSTATHI	     (0x001 << 16)
+#define TIMER_B_TCR_INVOUTPHI	     (0x002 << 16)
+#define TIMER_B_TCR_CPHI	     (0x008 << 16)
+#define TIMER_B_TCR_PWIDHI_MASK      (0x030 << 16)
+#define TIMER_B_TCR_ENAMODEHI_ONCE   (0x040 << 16)
+#define TIMER_B_TCR_ENAMODEHI_CONT   (0x080 << 16)
+#define TIMER_B_TCR_ENAMODEHI_MASK   (0x0c0 << 16)
+
+#define TIMER_B_TGCR_TIMLORS	     0x001
+#define TIMER_B_TGCR_TIMHIRS	     0x002
+#define TIMER_B_TGCR_TIMMODE_UD32    0x004
+#define TIMER_B_TGCR_TIMMODE_WDT64   0x008
+#define TIMER_B_TGCR_TIMMODE_CD32    0x00c
+#define TIMER_B_TGCR_TIMMODE_MASK    0x00c
+#define TIMER_B_TGCR_PSCHI_MASK      (0x00f << 8)
+#define TIMER_B_TGCR_TDDRHI_MASK     (0x00f << 12)
+
+#define TIMER_0			     0
+#define TIMER_1			     1
+
+#if defined(CONFIG_SOC_TMS320C6472) || defined(CONFIG_SOC_TMS320C6474)
+#define TIMER_2			     2
+#define TIMER_3			     3
+#define TIMER_4			     4
+#define TIMER_5			     5
+#define TIMER_6			     6
+#define TIMER_7			     7
+#define TIMER_8			     8
+#define TIMER_9			     9
+#define TIMER_10		     10
+#define TIMER_11		     11
+#endif /* defined(CONFIG_SOC_TMS320C6472) || defined(CONFIG_SOC_TMS320C6474) */
+
+/*
+ * Timer clocks are divided down from the CPU clock
+ * The divisor is in the EMUMGTCLKSPD register
+ */
+#define TIMER_DIVISOR(t) \
+	((TIMER_REG(TIMER_EMUMGTCLKSPD_REG((t))) & (0xf << 16)) >> 16)
+
+#define timer_period(f, d)	      (((f) * 1000000) / ((d) * HZ))
+#define ticks2usecs(f, d, x)	      (((x) * (d)) / (f))
+
+#endif
diff --git a/arch/c6x/platforms/phy.c b/arch/c6x/platforms/phy.c
new file mode 100644
index 0000000..f15e606
--- /dev/null
+++ b/arch/c6x/platforms/phy.c
@@ -0,0 +1,141 @@
+/*
+ *  linux/arch/c6x/drivers/phy.c
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2007, 2009, 2010 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@virtuallogix.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+
+#include <linux/kernel.h>
+#include <linux/delay.h>
+#include <linux/types.h>
+
+#include <asm/setup.h>
+#include <asm/io.h>
+#include <asm/gmdio.h>
+#include <asm/sgmii.h>
+
+static int phy_init(void)
+{
+#ifdef CONFIG_ARCH_BOARD_EVM6472
+
+	mdio_set_reg(MDIO_CONTROL, 0x4000001f); /* enable MII interface */
+
+	__delay(145844);
+
+	/* Port 0 */
+	mdio_phy_write(27, 0x18, 0x848b); /* set RGMII to copper mode */
+	mdio_phy_wait();
+
+	mdio_phy_write(20, 0x18, 0xce0); /* Rx-clock delayed */
+	mdio_phy_wait();
+
+	mdio_phy_write(24, 0x18, 0x4101); /* leds */
+	mdio_phy_wait();
+
+	mdio_phy_write(0, 0x18, 0x9140); /* soft-reset */
+	mdio_phy_wait();
+
+	__delay(145844);
+
+	/* Port 1 */
+	mdio_phy_write(27, 0x19, 0x848b); /* set RGMII to copper mode */
+	mdio_phy_wait();
+
+	mdio_phy_write(20, 0x19, 0xce0); /* Rx-clock delayed */
+	mdio_phy_wait();
+
+	mdio_phy_write(24, 0x19, 0x4101); /* leds */
+	mdio_phy_wait();
+
+	mdio_phy_write(0, 0x19, 0x9140); /* soft-reset */
+	mdio_phy_wait();
+
+	__delay(145844);
+
+#else /* !CONFIG_ARCH_BOARD_EVM6472 */
+
+	mdio_set_reg(MDIO_CONTROL, 0x4004001f); /* enable MII interface */
+
+	__delay(145844);
+
+	mdio_phy_write(4, 27, 0x81); /* turn PPU off to make copper PHY visible at SMI address 0x01 */
+	mdio_phy_wait();
+
+	__delay(8763);
+
+	mdio_phy_write(26, 0xe, 0x47); /* set PHY port 6 SERDES to 0.7V swing */
+	mdio_phy_wait();
+
+#ifdef CONFIG_ARCH_BOARD_EVM6474
+	mdio_phy_write(26, 0xd, 0x47); /* set PHY port 5 SERDES to 0.7V swing */
+	mdio_phy_wait();
+#endif
+
+	mdio_phy_write(0, 0xe, 0x8140); /* configure PHY port 6 SERDES --> DSP 1 at 1000mpbs, full duplex */
+	mdio_phy_wait();
+
+#ifdef CONFIG_ARCH_BOARD_EVM6474
+	mdio_phy_write(0, 0xd, 0x8140); /* configure PHY port 5 SERDES --> DSP 2 at 1000mbps, full duplex */
+	mdio_phy_wait();
+
+	mdio_phy_write(1, 0x15, 0x43e); /* force internal switch --> port 5 SERDES to 1000MPBS, full Duplex */
+	mdio_phy_wait();
+#endif
+
+	mdio_phy_write(1, 0x16, 0x43e); /* force internal switch --> port 6 SERDES to 1000MBPS, full Duplex */
+	mdio_phy_wait();
+
+#endif /* !CONFIG_ARCH_BOARD_EVM6472 */
+
+#if 0  /* Use autoneg at PHY level */
+
+	/* force 1000 or 100mps at copper PHY, disable auto-negotiate */
+	mdio_phy_write(0, 1, 0xa100); /* 0xa100 = 100mbps, 0x8140 = 1000mbps */
+	mdio_phy_wait();
+
+	/* wait for link establishment (~5 sec) */
+	{
+		int i;
+		for (i = 0; i < 5000; i++)
+			udelay(1000); /* 1ms */
+	}
+#endif
+	return 0;
+}
+
+static int evm_phy_init(void)
+{
+#if !defined(CONFIG_ARCH_BOARD_EVM6472)
+	struct sgmii_config_s sgmiic;
+
+	/* SGMII setup */
+	sgmii_reset();
+
+	sgmiic.master	 = 1;
+	sgmiic.loopback  = 0;
+	sgmiic.autoneg	 = 0;
+	sgmiic.txconfig  = 0x00000e23;
+	sgmiic.rxconfig  = 0x00081023; /* programming serdes to be in master mode */
+	sgmiic.auxconfig = 0x0000000b; /* PLL multiplier */
+
+#ifdef CONFIG_ARCH_BOARD_EVM6474
+	/* EVMC6474 board is wired up with TX differential +/- swapped. */
+	sgmiic.txconfig  |= 0x80;
+#endif /* CONFIG_ARCH_BOARD_EVM6474 */
+
+	sgmii_config(&sgmiic);
+
+#endif /* !defined(CONFIG_ARCH_BOARD_EVM6472) */
+
+	phy_init();
+
+	return 0;
+}
+
+arch_initcall(evm_phy_init);
diff --git a/arch/c6x/platforms/platform-c64xx.c b/arch/c6x/platforms/platform-c64xx.c
new file mode 100644
index 0000000..28d9244
--- /dev/null
+++ b/arch/c6x/platforms/platform-c64xx.c
@@ -0,0 +1,439 @@
+/*
+ *  linux/arch/c6x/platforms/platform-c64xx.c
+ *
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2007, 2009, 2010, 2011 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@virtuallogix.com)
+ *  Updated: Mark Salter <msalter@redhat.com>
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/delay.h>
+#include <linux/interrupt.h>
+#include <linux/fs.h>
+#include <linux/genhd.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/delay.h>
+#include <linux/ioport.h>
+#include <linux/init.h>
+#include <linux/kernel_stat.h>
+#include <linux/types.h>
+#include <linux/ioport.h>
+#include <linux/platform_device.h>
+#include <linux/mtd/mtd.h>
+#include <linux/mtd/partitions.h>
+#include <linux/mtd/plat-ram.h>
+#include <linux/mtd/physmap.h>
+
+#include <asm/pll.h>
+#include <asm/timer.h>
+#include <asm/setup.h>
+#include <asm/irq.h>
+#include <asm/traps.h>
+
+#include <mach/dscr.h>
+#include <mach/board.h>
+#include <mach/gemac.h>
+
+/*
+ * Resources present on the SoC
+ */
+static struct resource c6x_soc_res = {
+	.name = "C64X+ SOC peripherals",
+#if defined(CONFIG_SOC_TMS320C6472) || defined(CONFIG_SOC_TMS320C6474)
+	.start = 0x01800000, .end = 0x02f60000,
+#elif defined(CONFIG_SOC_TMS320C6455) || defined(CONFIG_SOC_TMS320C6457)
+	.start = 0x01800000, .end = 0x2cffffff,
+#else
+#error "No SoC peripheral address space defined"
+#endif
+};
+
+#if defined(CONFIG_MTD_PLATRAM) || defined(CONFIG_MTD_PLATRAM_MODULE)
+
+#ifdef CONFIG_MTD_PARTITIONS
+static const char *part_probe_types[] = { "cmdlinepart", NULL };
+#endif
+
+static struct platdata_mtd_ram c6x_plat_data = {
+	.mapname   = "DRAM",
+#ifdef CONFIG_MTD_PARTITIONS
+	.probes    = (const char **) part_probe_types,
+#endif
+	.bankwidth = 4,
+};
+
+static struct resource c6x_platram_resource = {
+	.start = 0,
+	.end   = 0,
+	.flags = IORESOURCE_MEM,
+};
+
+static struct platform_device c6x_platram_device = {
+	.name          = "mtd-ram",
+	.id            = 8,
+	.dev = {
+		.platform_data = &c6x_plat_data,
+	},
+	.num_resources = 1,
+	.resource      = &c6x_platram_resource,
+};
+#endif
+
+#ifdef CONFIG_TMS320C64X_GEMAC
+#if defined(CONFIG_TMS320C64X_GEMAC_0) || !defined(CONFIG_SOC_TMS320C6472)
+static struct resource emac_resources0[] = {
+	{
+		.name           = "EMAC_REG_BASE",
+		.start          =  EMAC0_REG_BASE,
+		.end            =  EMAC0_REG_BASE + 0xFFF,
+		.flags          =  IORESOURCE_MEM,
+	},
+	{
+		.name           = "ECTL_REG_BASE",
+		.start          =  ECTL0_REG_BASE,
+		.end            =  ECTL0_REG_BASE + 0x7FF,
+		.flags          =  IORESOURCE_MEM,
+	},
+	{
+		.name           = "EMAC_DSC_BASE",
+		.start          =  EMAC0_DSC_BASE,
+		.end            =  EMAC0_DSC_BASE + 0x17FF,
+		.flags          =  IORESOURCE_MEM,
+	},
+	{
+		.name           = "IRQ_SRC",
+		.start          =  IRQ_EMACRXINT,
+		.end            =  IRQ_EMACTXINT,
+		.flags          =  IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device emac_dev0 = {
+	.name		= "EMAC",
+	.id		= 0,
+	.resource       = emac_resources0,
+	.num_resources	= ARRAY_SIZE(emac_resources0),
+};
+#endif
+
+#ifdef CONFIG_TMS320C64X_GEMAC_1
+static struct resource emac_resources1[] = {
+	{
+		.name           = "EMAC_REG_BASE",
+		.start          =  EMAC1_REG_BASE,
+		.end            =  EMAC1_REG_BASE + 0xFFF,
+		.flags          =  IORESOURCE_MEM,
+	},
+	{
+		.name           = "ECTL_REG_BASE",
+		.start          =  ECTL1_REG_BASE,
+		.end            =  ECTL1_REG_BASE + 0x7FF,
+		.flags          =  IORESOURCE_MEM,
+	},
+	{
+		.name           = "EMAC_DSC_BASE",
+		.start          =  EMAC1_DSC_BASE,
+		.end            =  EMAC1_DSC_BASE + 0x17FF,
+		.flags          =  IORESOURCE_MEM,
+	},
+	{
+		.name           = "IRQ_SRC",
+		.start          =  IRQ_EMACRXINT1,
+		.end            =  IRQ_EMACTXINT1,
+		.flags          =  IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device emac_dev1 = {
+	.name		= "EMAC",
+	.id		= 1,
+	.resource	= emac_resources1,
+	.num_resources	= ARRAY_SIZE(emac_resources1),
+};
+#endif
+
+static void setup_emac(void)
+{
+	int status;
+
+#if defined(CONFIG_TMS320C64X_GEMAC_0) || !defined(CONFIG_SOC_TMS320C6472)
+	status	= platform_device_register(&emac_dev0);
+	if (status != 0)
+		pr_debug("setup_emac0 --> %d\n", status);
+#ifdef CONFIG_SOC_TMS320C6455
+	else {
+		unsigned long val;
+
+		/* Enable EMAC device (in regs PERLOCK & PERCFG0) */
+		val = DSCR_PERCFG0 | DSCR_B_PERCFG0_EMAC;
+		while (DSCR_PERCFG0 != val) {
+			DSCR_PERLOCK = DSCR_LOCKVAL;
+			DSCR_PERCFG0 = val;
+		}
+
+		/* Wait for enabling (reg PERSTAT0) */
+		while (((DSCR_PERSTAT0 & 0x1C0) >> 6) != 0x1)
+			;
+	}
+#endif /* CONFIG_SOC_TMS320C6455 */
+#endif /* defined(CONFIG_TMS320C64X_GEMAC_0) || !defined(CONFIG_SOC_TMS320C6472) */
+
+#ifdef CONFIG_TMS320C64X_GEMAC_1
+	status	= platform_device_register(&emac_dev1);
+	if (status != 0)
+		pr_debug("setup_emac1 --> %d\n", status);
+#ifdef CONFIG_SOC_TMS320C6472
+	else {
+		unsigned long val;
+		val = DSCR_DEVCTL | DSCR_B_DEVCTL_EMAC1;
+		while (DSCR_DEVCTL != val) {
+			DSCR_PERLOCK = DSCR_LOCKVAL;
+			DSCR_DEVCTL = val;
+		}
+	}
+#endif /* CONFIG_SOC_TMS320C6472 */
+#endif /* CONFIG_TMS320C64X_GEMAC_1 */
+}
+#else /* CONFIG_TMS320C64X_GEMAC */
+static void setup_emac(void) {}
+#endif /* CONFIG_TMS320C64X_GEMAC */
+
+#if defined(CONFIG_SOC_TMS320C6474)
+unsigned int arch_get_silicon_rev(void)
+{
+	u32   jtagid_val  = *(u32 *) DSCR_JTAGID;
+	u32   silicon_rev = (jtagid_val >> 28) & 0xf;
+
+	return silicon_rev;
+}
+
+char *arch_compute_silicon_rev(u32 silicon_rev)
+{
+	char *str;
+	switch (silicon_rev) {
+	case 0x1:
+		str = "1.2";
+		break;
+	case 0x2:
+		str = "1.3";
+		break;
+	case 0x3:
+		str = "2.0";
+		break;
+	case 0x4:
+		str = "2.1";
+		break;
+	default:
+		str = "unknown";
+		break;
+	}
+	return str;
+}
+#endif
+
+static void init_pll(void)
+{
+#if defined(CONFIG_SOC_TMS320C6474) /* should be done elsewhere */
+	pll1_clearbit_reg(PLLCTL, PLLCTL_PLLENSRC);
+	pll1_clearbit_reg(PLLCTL, PLLCTL_PLLEN);
+
+	/* Wait 4 cycles of the slowest of PLLOUT or reference clock source (CLKIN).*/
+	__delay(100);
+
+	pll1_setbit_reg(PLLCTL, PLLCTL_PLLRST);
+	pll1_set_reg(PLLM, PLLM_VAL(20));
+
+	/*
+	 * This can't be right. There is no previder here...
+	pll1_set_reg(PLLPREDIV, PLLPREDIV_VAL(10) | PLLPREDIV_EN);
+	*/
+
+	pll1_wait_gostat();
+
+	/* Wait until GOSTAT bit is cleared*/
+	/* while(pll1_get_reg(PLL_PLLSTAT) & PLLSTAT_GOSTAT); */
+
+	pll1_set_reg(PLLDIV11, PLLDIV_RATIO(10) | PLLDIV_EN);
+	pll1_set_reg(PLLDIV13, PLLDIV_RATIO(6)  | PLLDIV_EN);
+
+	pll1_setbit_reg(PLLCMD, PLLCMD_GOSTAT);
+
+	pll1_wait_gostat();
+
+	/* Wait until GOSTAT bit is cleared*/
+	/* while(pll1_get_reg(PLLSTAT) & PLLSTAT_GOSTAT); */
+
+	__delay(1000);
+
+	pll1_clearbit_reg(PLLCTL, PLLCTL_PLLRST);
+
+	__delay(4000);
+
+	pll1_setbit_reg(PLLCTL, PLLCTL_PLLEN);
+#endif
+
+#if defined(CONFIG_SOC_TMS320C6472) && defined(CONFIG_TMS320C64X_GEMAC)
+	/* PLL2 configuration (EMAC) */
+	pll2_clearbit_reg(PLLCTL, PLLCTL_PLLENSRC);
+	pll2_clearbit_reg(PLLCTL, PLLCTL_PLLEN);
+
+	/* Wait 4 cycles of the slowest of PLLOUT or reference clock source (CLKIN).*/
+	__delay(100);
+
+	pll2_setbit_reg(PLLCTL, PLLCTL_PLLRST);
+
+	/* Wait for PLL to properly reset.*/
+	__delay(4000);
+
+	pll2_clearbit_reg(PLLCTL, PLLCTL_PLLRST);
+
+	/* Wait for PLL to lock */
+	__delay(4000);
+
+	pll2_setbit_reg(PLLCTL, PLLCTL_PLLEN);
+#endif
+}
+
+static void init_power(void)
+{
+#if defined(CONFIG_SOC_TMS320C6474)
+
+	PSC_PDCTL0 |= 0x00000001;
+	PSC_MDCTL0 |= 0x00000003;
+	PSC_MDCTL1 |= 0x00000003;
+	PSC_MDCTL2 |= 0x00000003;
+
+	PSC_PDCTL1 |= 0x00000001;
+	PSC_MDCTL6 |= 0x00000003;
+
+	PSC_PDCTL2 |= 0x00000001;
+	PSC_MDCTL7 |= 0x00000003;
+
+	PSC_PDCTL3 |= 0x00000001;
+	PSC_MDCTL8 |= 0x00000003;
+
+	PSC_PDCTL4 |= 0x00000001;
+	PSC_MDCTL9 |= 0x00000003;
+
+	PSC_PDCTL5 |= 0x00000001;
+	PSC_MDCTL10 |= 0x00000003;
+
+	PSC_PTCMD  |= 0x0000003f;
+
+#ifdef CONFIG_RAPIDIO_TCI648X
+	PSC_PDCTL2 |= 1;
+	PSC_MDCTL7 |= 3; /* sRIO */
+	PSC_PTCMD  |= 4;
+
+#endif /* CONFIG_RAPIDIO_TCI648X */
+#endif /* CONFIG_SOC_TMS320C6474 */
+
+#ifdef CONFIG_SOC_TMS320C6472
+
+#ifdef CONFIG_TMS320C64X_GEMAC_0
+	PSC_MDCTL7 |= 0x00000103; /* GEMAC0 */
+#endif /* CONFIG_TMS320C64X_GEMAC_0 */
+
+#ifdef CONFIG_TMS320C64X_GEMAC_1
+	PSC_MDCTL8 |= 0x00000103; /* GEMAC1 */
+#endif /* CONFIG_TMS320C64X_GEMAC_1 */
+
+#ifdef CONFIG_RAPIDIO_TCI648X
+	PSC_MDCTL6 |= 0x00000103; /* SRIO */
+#endif /* CONFIG_RAPIDIO_TCI648X */
+
+	PSC_PTCMD  |= 0x00000001;
+
+#endif/* CONFIG_SOC_TMS320C6472 */
+}
+
+void c6x_soc_setup_arch(void)
+{
+#if defined(CONFIG_SOC_TMS320C6474)
+	unsigned long val;
+#endif
+
+	/* Initialize C64x+ IRQs */
+	set_creg(ICR, -1);
+
+	init_pll();
+
+	init_power();
+
+#if defined(CONFIG_SOC_TMS320C6474)
+	/* Enable timers and devices (in regs PERLOCK & PERCFG0) */
+	DSCR_PERLOCK = DSCR_LOCKVAL;
+
+	DSCR_PERCFG0 = DSCR_B_PERCFG0_TIMER0
+		| DSCR_B_PERCFG0_TIMER1
+		| DSCR_B_PERCFG0_I2C
+		| DSCR_B_PERCFG0_GPIO
+		| DSCR_B_PERCFG0_EMAC; /* 0xc0015555 */
+
+	/* read for enabling (reg PERSTAT0) */
+	val = DSCR_PERSTAT0;
+
+	/* Wait 128 cycles */
+	__delay(22);
+#endif /* defined(CONFIG_SOC_TMS320C6474) */
+
+#if defined(CONFIG_SOC_TMS320C6472)
+
+	/* Do not allow user mode to access SoC device I/O */
+	DSCR_PRIVKEY = 0xbea7;
+	DSCR_PRIVPERM = 0xaaaaaaaa;
+	DSCR_PRIVKEY = 0;
+
+#endif /*defined(CONFIG_SOC_TMS320C6472) */
+
+#if defined(CONFIG_SOC_TMS320C6455)
+	/* Enable timers (in regs PERLOCK & PERCFG0) */
+	{
+		unsigned int mask = DSCR_B_PERCFG0_TIMER0 |
+				    DSCR_B_PERCFG0_TIMER1;
+
+		while ((DSCR_PERCFG0 & mask) != mask) {
+			DSCR_PERLOCK = DSCR_LOCKVAL;
+			DSCR_PERCFG0 |= mask;
+		}
+	}
+
+	/* Wait for enabling (reg PERSTAT0) */
+	while (((DSCR_PERSTAT0 & 0x3E00) >> 9) != 0x9)
+		;
+#endif /* defined(CONFIG_SOC_TMS320C6455) */
+
+	/* Initialize SoC resources */
+	iomem_resource.name = "Memory";
+	request_resource(&iomem_resource, &c6x_soc_res);
+}
+
+static int __init platform_arch_init(void)
+{
+	int status = 0;
+
+	/* Intialize EMAC SoC resources */
+	setup_emac();
+
+#if defined(CONFIG_MTD_PLATRAM) || defined(CONFIG_MTD_PLATRAM_MODULE)
+	if (c6x_platram_size) {
+
+		c6x_platram_resource.start = c6x_platram_start;
+		c6x_platram_resource.end = c6x_platram_start + c6x_platram_size - 1;
+
+		status  = platform_device_register(&c6x_platram_device);
+			printk(KERN_ERR "Could not register platram device: %d\n", status);
+	}
+#endif
+	return status;
+}
+
+arch_initcall(platform_arch_init);
+
diff --git a/arch/c6x/platforms/sgmii.c b/arch/c6x/platforms/sgmii.c
new file mode 100644
index 0000000..90f62d0
--- /dev/null
+++ b/arch/c6x/platforms/sgmii.c
@@ -0,0 +1,83 @@
+/*
+ *  Port on Texas Instruments TMS320C6x architecture
+ *
+ *  Copyright (C) 2007, 2009 Texas Instruments Incorporated
+ *  Author: Aurelien Jacquiot (aurelien.jacquiot@virtuallogix.com)
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ */
+#include <linux/kernel.h>
+#include <linux/sched.h>
+#include <linux/netdevice.h>
+
+#include <asm/setup.h>
+#include <asm/sgmii.h>
+#include <asm/gemac.h>
+
+int sgmii_reset(void)
+{
+	sgmii_setbit_reg(SGMII_SRESET_REG, SGMII_SRESET_RESET); /* soft reset */
+	while (sgmii_get_reg(SGMII_SRESET_REG) != 0x0)
+		;
+	sgmii_setbit_reg(SGMII_CTL_REG, SGMII_CTL_MASTER);
+
+	return 0;
+}
+
+int sgmii_config(struct sgmii_config_s *config)
+{
+	unsigned int val1 = 0, val2 = 0;
+
+	if (!config)
+		return -1;
+
+	if (config->loopback) {
+		val1 = SGMII_CTL_MASTER | SGMII_CTL_LOOPBACK | SGMII_CTL_AUTONEG; /* 0x35 */
+		val2 = 0x9801;
+	}
+
+	if (config->master) {
+		val1 = SGMII_CTL_MASTER;
+		val2 = 0x9801;	 /* advertise fullduplex gigabit */
+	} else {
+		val1 = 0;
+		val2 = 0x01;	 /* advertise fullduplex gigabit */
+	}
+
+	if (config->autoneg)
+		val1 |= SGMII_CTL_AUTONEG;
+
+	sgmii_set_reg(SGMII_SRESET_REG, SGMII_SRESET_RTRESET); /* RT soft reset */
+	sgmii_set_reg(SGMII_CTL_REG, val1);
+	sgmii_clearbit_reg(SGMII_SRESET_REG, SGMII_SRESET_RTRESET);
+
+	sgmii_set_reg(SGMII_MRADV_REG, val2);
+#ifndef CONFIG_TMS320DM648
+	sgmii_set_reg(SGMII_TXCFG_REG, config->txconfig);
+	sgmii_set_reg(SGMII_RXCFG_REG, config->rxconfig);
+	sgmii_set_reg(SGMII_AUXCFG_REG, config->auxconfig);
+#else
+	sgmii_set_reg(SERDES_KEY_REG, SERDES_KEY_VAL);
+	sgmii_set_reg(SERDES_PLL_REG, config->auxconfig);
+	for (i = 0; i < 2500; i++)
+		asm("	 nop");
+	sgmii_set_reg(SERDES_RX0_REG, config->rxconfig);
+	sgmii_set_reg(SERDES_TX0_REG, config->txconfig);
+#endif
+	if (config->autoneg) {
+		unsigned int done = 0x5;
+		unsigned int stat;
+
+		/* Wait for auto-negotiation*/
+		do {
+			stat = sgmii_get_reg(SGMII_STATUS_REG);
+			stat &= done;
+		} while (stat != done);
+	}
+
+	return 0;
+}
+
+
-- 
1.6.2.5

