Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab2LXE7q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 23:59:46 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:42067 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab2LXE7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 23:59:42 -0500
Date: Sun, 23 Dec 2012 22:53:37 -0600
Message-Id: <E1Tn02j-0003nm-Hh@localhost>
To: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        ralf@linux-mips.org
Subject: [PATCH] MIPS: MSP71xx: Move include files
From: Shane McDonald <mcdonald.shane@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that Yosemite's gone we can move the MSP71xx include files
one level up.

Signed-off-by: Shane McDonald <mcdonald.shane@gmail.com>
---
 .../asm/mach-pmcs-msp71xx/cpu-feature-overrides.h  |   22 +
 arch/mips/include/asm/mach-pmcs-msp71xx/gpio.h     |   46 ++
 .../include/asm/mach-pmcs-msp71xx/msp_cic_int.h    |  151 +++++
 .../asm/mach-pmcs-msp71xx/msp_gpio_macros.h        |  343 ++++++++++
 arch/mips/include/asm/mach-pmcs-msp71xx/msp_int.h  |   43 ++
 arch/mips/include/asm/mach-pmcs-msp71xx/msp_pci.h  |  205 ++++++
 arch/mips/include/asm/mach-pmcs-msp71xx/msp_prom.h |  171 +++++
 .../include/asm/mach-pmcs-msp71xx/msp_regops.h     |  236 +++++++
 arch/mips/include/asm/mach-pmcs-msp71xx/msp_regs.h |  664 ++++++++++++++++++++
 .../include/asm/mach-pmcs-msp71xx/msp_slp_int.h    |  141 +++++
 arch/mips/include/asm/mach-pmcs-msp71xx/msp_usb.h  |  144 +++++
 arch/mips/include/asm/mach-pmcs-msp71xx/war.h      |   29 +
 .../asm/pmc-sierra/msp71xx/cpu-feature-overrides.h |   22 -
 arch/mips/include/asm/pmc-sierra/msp71xx/gpio.h    |   46 --
 .../include/asm/pmc-sierra/msp71xx/msp_cic_int.h   |  151 -----
 .../asm/pmc-sierra/msp71xx/msp_gpio_macros.h       |  343 ----------
 arch/mips/include/asm/pmc-sierra/msp71xx/msp_int.h |   43 --
 arch/mips/include/asm/pmc-sierra/msp71xx/msp_pci.h |  205 ------
 .../mips/include/asm/pmc-sierra/msp71xx/msp_prom.h |  171 -----
 .../include/asm/pmc-sierra/msp71xx/msp_regops.h    |  236 -------
 .../mips/include/asm/pmc-sierra/msp71xx/msp_regs.h |  664 --------------------
 .../include/asm/pmc-sierra/msp71xx/msp_slp_int.h   |  141 -----
 arch/mips/include/asm/pmc-sierra/msp71xx/msp_usb.h |  144 -----
 arch/mips/include/asm/pmc-sierra/msp71xx/war.h     |   29 -
 arch/mips/pmcs-msp71xx/Platform                    |    2 +-
 25 files changed, 2196 insertions(+), 2196 deletions(-)
 create mode 100644 arch/mips/include/asm/mach-pmcs-msp71xx/cpu-feature-overrides.h
 create mode 100644 arch/mips/include/asm/mach-pmcs-msp71xx/gpio.h
 create mode 100644 arch/mips/include/asm/mach-pmcs-msp71xx/msp_cic_int.h
 create mode 100644 arch/mips/include/asm/mach-pmcs-msp71xx/msp_gpio_macros.h
 create mode 100644 arch/mips/include/asm/mach-pmcs-msp71xx/msp_int.h
 create mode 100644 arch/mips/include/asm/mach-pmcs-msp71xx/msp_pci.h
 create mode 100644 arch/mips/include/asm/mach-pmcs-msp71xx/msp_prom.h
 create mode 100644 arch/mips/include/asm/mach-pmcs-msp71xx/msp_regops.h
 create mode 100644 arch/mips/include/asm/mach-pmcs-msp71xx/msp_regs.h
 create mode 100644 arch/mips/include/asm/mach-pmcs-msp71xx/msp_slp_int.h
 create mode 100644 arch/mips/include/asm/mach-pmcs-msp71xx/msp_usb.h
 create mode 100644 arch/mips/include/asm/mach-pmcs-msp71xx/war.h
 delete mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/cpu-feature-overrides.h
 delete mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/gpio.h
 delete mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/msp_cic_int.h
 delete mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/msp_gpio_macros.h
 delete mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/msp_int.h
 delete mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/msp_pci.h
 delete mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/msp_prom.h
 delete mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/msp_regops.h
 delete mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/msp_regs.h
 delete mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/msp_slp_int.h
 delete mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/msp_usb.h
 delete mode 100644 arch/mips/include/asm/pmc-sierra/msp71xx/war.h

diff --git a/arch/mips/include/asm/mach-pmcs-msp71xx/cpu-feature-overrides.h b/arch/mips/include/asm/mach-pmcs-msp71xx/cpu-feature-overrides.h
new file mode 100644
index 0000000..016fa94
--- /dev/null
+++ b/arch/mips/include/asm/mach-pmcs-msp71xx/cpu-feature-overrides.h
@@ -0,0 +1,22 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2003, 04, 07 Ralf Baechle (ralf@linux-mips.org)
+ */
+#ifndef __ASM_MACH_MSP71XX_CPU_FEATURE_OVERRIDES_H
+#define __ASM_MACH_MSP71XX_CPU_FEATURE_OVERRIDES_H
+
+#define cpu_has_mips16		1
+#define cpu_has_dsp		1
+/* #define cpu_has_dsp2		??? - do runtime detection */
+#define cpu_has_mipsmt		1
+#define cpu_has_fpu		0
+
+#define cpu_has_mips32r1	0
+#define cpu_has_mips32r2	1
+#define cpu_has_mips64r1	0
+#define cpu_has_mips64r2	0
+
+#endif /* __ASM_MACH_MSP71XX_CPU_FEATURE_OVERRIDES_H */
diff --git a/arch/mips/include/asm/mach-pmcs-msp71xx/gpio.h b/arch/mips/include/asm/mach-pmcs-msp71xx/gpio.h
new file mode 100644
index 0000000..ebdbab9
--- /dev/null
+++ b/arch/mips/include/asm/mach-pmcs-msp71xx/gpio.h
@@ -0,0 +1,46 @@
+/*
+ * include/asm-mips/pmc-sierra/msp71xx/gpio.h
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * @author Patrick Glass <patrickglass@gmail.com>
+ */
+
+#ifndef __PMC_MSP71XX_GPIO_H
+#define __PMC_MSP71XX_GPIO_H
+
+/* Max number of gpio's is 28 on chip plus 3 banks of I2C IO Expanders */
+#define ARCH_NR_GPIOS (28 + (3 * 8))
+
+/* new generic GPIO API - see Documentation/gpio.txt */
+#include <asm-generic/gpio.h>
+
+#define gpio_get_value	__gpio_get_value
+#define gpio_set_value	__gpio_set_value
+#define gpio_cansleep	__gpio_cansleep
+
+/* Setup calls for the gpio and gpio extended */
+extern void msp71xx_init_gpio(void);
+extern void msp71xx_init_gpio_extended(void);
+extern int msp71xx_set_output_drive(unsigned gpio, int value);
+
+/* Custom output drive functionss */
+static inline int gpio_set_output_drive(unsigned gpio, int value)
+{
+	return msp71xx_set_output_drive(gpio, value);
+}
+
+/* IRQ's are not supported for gpio lines */
+static inline int gpio_to_irq(unsigned gpio)
+{
+	return -EINVAL;
+}
+
+static inline int irq_to_gpio(unsigned irq)
+{
+	return -EINVAL;
+}
+
+#endif /* __PMC_MSP71XX_GPIO_H */
diff --git a/arch/mips/include/asm/mach-pmcs-msp71xx/msp_cic_int.h b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_cic_int.h
new file mode 100644
index 0000000..c84bcf9
--- /dev/null
+++ b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_cic_int.h
@@ -0,0 +1,151 @@
+/*
+ * Defines for the MSP interrupt controller.
+ *
+ * Copyright (C) 1999 MIPS Technologies, Inc.  All rights reserved.
+ * Author: Carsten Langgaard, carstenl@mips.com
+ *
+ * ########################################################################
+ *
+ *  This program is free software; you can distribute it and/or modify it
+ *  under the terms of the GNU General Public License (Version 2) as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope it will be useful, but WITHOUT
+ *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ *  for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
+ *
+ * ########################################################################
+ */
+
+#ifndef _MSP_CIC_INT_H
+#define _MSP_CIC_INT_H
+
+/*
+ * The PMC-Sierra CIC interrupts are all centrally managed by the
+ * CIC sub-system.
+ * We attempt to keep the interrupt numbers as consistent as possible
+ * across all of the MSP devices, but some differences will creep in ...
+ * The interrupts which are directly forwarded to the MIPS core interrupts
+ * are assigned interrupts in the range 0-7, interrupts cascaded through
+ * the CIC are assigned interrupts 8-39.  The cascade occurs on C_IRQ4
+ * (MSP_INT_CIC).  Currently we don't really distinguish between VPE1
+ * and VPE0 (or thread contexts for that matter).  Will have to fix.
+ * The PER interrupts are assigned interrupts in the range 40-71.
+*/
+
+
+/*
+ * IRQs directly forwarded to the CPU
+ */
+#define MSP_MIPS_INTBASE	0
+#define MSP_INT_SW0		0	/* IRQ for swint0,       C_SW0  */
+#define MSP_INT_SW1		1	/* IRQ for swint1,       C_SW1  */
+#define MSP_INT_MAC0		2	/* IRQ for MAC 0,        C_IRQ0 */
+#define MSP_INT_MAC1		3	/* IRQ for MAC 1,        C_IRQ1 */
+#define MSP_INT_USB		4	/* IRQ for USB,          C_IRQ2 */
+#define MSP_INT_SAR		5	/* IRQ for ADSL2+ SAR,   C_IRQ3 */
+#define MSP_INT_CIC		6	/* IRQ for CIC block,    C_IRQ4 */
+#define MSP_INT_SEC		7	/* IRQ for Sec engine,   C_IRQ5 */
+
+/*
+ * IRQs cascaded on CPU interrupt 4 (CAUSE bit 12, C_IRQ4)
+ * These defines should be tied to the register definitions for the CIC
+ * interrupt routine.  For now, just use hard-coded values.
+ */
+#define MSP_CIC_INTBASE		(MSP_MIPS_INTBASE + 8)
+#define MSP_INT_EXT0		(MSP_CIC_INTBASE + 0)
+					/* External interrupt 0         */
+#define MSP_INT_EXT1		(MSP_CIC_INTBASE + 1)
+					/* External interrupt 1         */
+#define MSP_INT_EXT2		(MSP_CIC_INTBASE + 2)
+					/* External interrupt 2         */
+#define MSP_INT_EXT3		(MSP_CIC_INTBASE + 3)
+					/* External interrupt 3         */
+#define MSP_INT_CPUIF		(MSP_CIC_INTBASE + 4)
+					/* CPU interface interrupt      */
+#define MSP_INT_EXT4		(MSP_CIC_INTBASE + 5)
+					/* External interrupt 4         */
+#define MSP_INT_CIC_USB		(MSP_CIC_INTBASE + 6)
+					/* Cascaded IRQ for USB         */
+#define MSP_INT_MBOX		(MSP_CIC_INTBASE + 7)
+					/* Sec engine mailbox IRQ       */
+#define MSP_INT_EXT5		(MSP_CIC_INTBASE + 8)
+					/* External interrupt 5         */
+#define MSP_INT_TDM		(MSP_CIC_INTBASE + 9)
+					/* TDM interrupt                */
+#define MSP_INT_CIC_MAC0	(MSP_CIC_INTBASE + 10)
+					/* Cascaded IRQ for MAC 0       */
+#define MSP_INT_CIC_MAC1	(MSP_CIC_INTBASE + 11)
+					/* Cascaded IRQ for MAC 1       */
+#define MSP_INT_CIC_SEC		(MSP_CIC_INTBASE + 12)
+					/* Cascaded IRQ for sec engine  */
+#define	MSP_INT_PER		(MSP_CIC_INTBASE + 13)
+					/* Peripheral interrupt         */
+#define	MSP_INT_TIMER0		(MSP_CIC_INTBASE + 14)
+					/* SLP timer 0                  */
+#define	MSP_INT_TIMER1		(MSP_CIC_INTBASE + 15)
+					/* SLP timer 1                  */
+#define	MSP_INT_TIMER2		(MSP_CIC_INTBASE + 16)
+					/* SLP timer 2                  */
+#define	MSP_INT_VPE0_TIMER	(MSP_CIC_INTBASE + 17)
+					/* VPE0 MIPS timer              */
+#define MSP_INT_BLKCP		(MSP_CIC_INTBASE + 18)
+					/* Block Copy                   */
+#define MSP_INT_UART0		(MSP_CIC_INTBASE + 19)
+					/* UART 0                       */
+#define MSP_INT_PCI		(MSP_CIC_INTBASE + 20)
+					/* PCI subsystem                */
+#define MSP_INT_EXT6		(MSP_CIC_INTBASE + 21)
+					/* External interrupt 5         */
+#define MSP_INT_PCI_MSI		(MSP_CIC_INTBASE + 22)
+					/* PCI Message Signal           */
+#define MSP_INT_CIC_SAR		(MSP_CIC_INTBASE + 23)
+					/* Cascaded ADSL2+ SAR IRQ      */
+#define MSP_INT_DSL		(MSP_CIC_INTBASE + 24)
+					/* ADSL2+ IRQ                   */
+#define MSP_INT_CIC_ERR		(MSP_CIC_INTBASE + 25)
+					/* SLP error condition          */
+#define MSP_INT_VPE1_TIMER	(MSP_CIC_INTBASE + 26)
+					/* VPE1 MIPS timer              */
+#define MSP_INT_VPE0_PC		(MSP_CIC_INTBASE + 27)
+					/* VPE0 Performance counter     */
+#define MSP_INT_VPE1_PC		(MSP_CIC_INTBASE + 28)
+					/* VPE1 Performance counter     */
+#define MSP_INT_EXT7		(MSP_CIC_INTBASE + 29)
+					/* External interrupt 5         */
+#define MSP_INT_VPE0_SW		(MSP_CIC_INTBASE + 30)
+					/* VPE0 Software interrupt      */
+#define MSP_INT_VPE1_SW		(MSP_CIC_INTBASE + 31)
+					/* VPE0 Software interrupt      */
+
+/*
+ * IRQs cascaded on CIC PER interrupt (MSP_INT_PER)
+ */
+#define MSP_PER_INTBASE		(MSP_CIC_INTBASE + 32)
+/* Reserved					   0-1                  */
+#define MSP_INT_UART1		(MSP_PER_INTBASE + 2)
+					/* UART 1                       */
+/* Reserved					   3-5                  */
+#define MSP_INT_2WIRE		(MSP_PER_INTBASE + 6)
+					/* 2-wire                       */
+#define MSP_INT_TM0		(MSP_PER_INTBASE + 7)
+					/* Peripheral timer block out 0 */
+#define MSP_INT_TM1		(MSP_PER_INTBASE + 8)
+					/* Peripheral timer block out 1 */
+/* Reserved					   9                    */
+#define MSP_INT_SPRX		(MSP_PER_INTBASE + 10)
+					/* SPI RX complete              */
+#define MSP_INT_SPTX		(MSP_PER_INTBASE + 11)
+					/* SPI TX complete              */
+#define MSP_INT_GPIO		(MSP_PER_INTBASE + 12)
+					/* GPIO                         */
+#define MSP_INT_PER_ERR		(MSP_PER_INTBASE + 13)
+					/* Peripheral error             */
+/* Reserved					   14-31                */
+
+#endif /* !_MSP_CIC_INT_H */
diff --git a/arch/mips/include/asm/mach-pmcs-msp71xx/msp_gpio_macros.h b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_gpio_macros.h
new file mode 100644
index 0000000..156f320
--- /dev/null
+++ b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_gpio_macros.h
@@ -0,0 +1,343 @@
+/*
+ *
+ * Macros for external SMP-safe access to the PMC MSP71xx reference
+ * board GPIO pins
+ *
+ * Copyright 2010 PMC-Sierra, Inc.
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
+ *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
+ *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
+ *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
+ *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
+ *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
+ *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
+ *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
+ *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *  You should have received a copy of the  GNU General Public License along
+ *  with this program; if not, write  to the Free Software Foundation, Inc.,
+ *  675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef __MSP_GPIO_MACROS_H__
+#define __MSP_GPIO_MACROS_H__
+
+#include <msp_regops.h>
+#include <msp_regs.h>
+
+#ifdef CONFIG_PMC_MSP7120_GW
+#define MSP_NUM_GPIOS		20
+#else
+#define MSP_NUM_GPIOS		28
+#endif
+
+/* -- GPIO Enumerations -- */
+enum msp_gpio_data {
+	MSP_GPIO_LO = 0,
+	MSP_GPIO_HI = 1,
+	MSP_GPIO_NONE,		/* Special - Means pin is out of range */
+	MSP_GPIO_TOGGLE,	/* Special - Sets pin to opposite */
+};
+
+enum msp_gpio_mode {
+	MSP_GPIO_INPUT		= 0x0,
+	/* MSP_GPIO_ INTERRUPT	= 0x1,	Not supported yet */
+	MSP_GPIO_UART_INPUT	= 0x2,	/* Only GPIO 4 or 5 */
+	MSP_GPIO_OUTPUT		= 0x8,
+	MSP_GPIO_UART_OUTPUT	= 0x9,	/* Only GPIO 2 or 3 */
+	MSP_GPIO_PERIF_TIMERA	= 0x9,	/* Only GPIO 0 or 1 */
+	MSP_GPIO_PERIF_TIMERB	= 0xa,	/* Only GPIO 0 or 1 */
+	MSP_GPIO_UNKNOWN	= 0xb,  /* No such GPIO or mode */
+};
+
+/* -- Static Tables -- */
+
+/* Maps pins to data register */
+static volatile u32 * const MSP_GPIO_DATA_REGISTER[] = {
+	/* GPIO 0 and 1 on the first register */
+	GPIO_DATA1_REG, GPIO_DATA1_REG,
+	/* GPIO 2, 3, 4, and 5 on the second register */
+	GPIO_DATA2_REG, GPIO_DATA2_REG, GPIO_DATA2_REG, GPIO_DATA2_REG,
+	/* GPIO 6, 7, 8, and 9 on the third register */
+	GPIO_DATA3_REG, GPIO_DATA3_REG, GPIO_DATA3_REG, GPIO_DATA3_REG,
+	/* GPIO 10, 11, 12, 13, 14, and 15 on the fourth register */
+	GPIO_DATA4_REG, GPIO_DATA4_REG, GPIO_DATA4_REG, GPIO_DATA4_REG,
+	GPIO_DATA4_REG, GPIO_DATA4_REG,
+	/* GPIO 16 - 23 on the first strange EXTENDED register */
+	EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG,
+	EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG,
+	EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG,
+	/* GPIO 24 - 27 on the second strange EXTENDED register */
+	EXTENDED_GPIO2_REG, EXTENDED_GPIO2_REG, EXTENDED_GPIO2_REG,
+	EXTENDED_GPIO2_REG,
+};
+
+/* Maps pins to mode register */
+static volatile u32 * const MSP_GPIO_MODE_REGISTER[] = {
+	/* GPIO 0 and 1 on the first register */
+	GPIO_CFG1_REG, GPIO_CFG1_REG,
+	/* GPIO 2, 3, 4, and 5 on the second register */
+	GPIO_CFG2_REG, GPIO_CFG2_REG, GPIO_CFG2_REG, GPIO_CFG2_REG,
+	/* GPIO 6, 7, 8, and 9 on the third register */
+	GPIO_CFG3_REG, GPIO_CFG3_REG, GPIO_CFG3_REG, GPIO_CFG3_REG,
+	/* GPIO 10, 11, 12, 13, 14, and 15 on the fourth register */
+	GPIO_CFG4_REG, GPIO_CFG4_REG, GPIO_CFG4_REG, GPIO_CFG4_REG,
+	GPIO_CFG4_REG, GPIO_CFG4_REG,
+	/* GPIO 16 - 23 on the first strange EXTENDED register */
+	EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG,
+	EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG,
+	EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG,
+	/* GPIO 24 - 27 on the second strange EXTENDED register */
+	EXTENDED_GPIO2_REG, EXTENDED_GPIO2_REG, EXTENDED_GPIO2_REG,
+	EXTENDED_GPIO2_REG,
+};
+
+/* Maps 'basic' pins to relative offset from 0 per register */
+static int MSP_GPIO_OFFSET[] = {
+	/* GPIO 0 and 1 on the first register */
+	0, 0,
+	/* GPIO 2, 3, 4, and 5 on the second register */
+	2, 2, 2, 2,
+	/* GPIO 6, 7, 8, and 9 on the third register */
+	6, 6, 6, 6,
+	/* GPIO 10, 11, 12, 13, 14, and 15 on the fourth register */
+	10, 10, 10, 10, 10, 10,
+};
+
+/* Maps MODE to allowed pin mask */
+static unsigned int MSP_GPIO_MODE_ALLOWED[] = {
+	0xffffffff,	/* Mode 0 - INPUT */
+	0x00000,	/* Mode 1 - INTERRUPT */
+	0x00030,	/* Mode 2 - UART_INPUT (GPIO 4, 5)*/
+	0, 0, 0, 0, 0,	/* Modes 3, 4, 5, 6, and 7 are reserved */
+	0xffffffff,	/* Mode 8 - OUTPUT */
+	0x0000f,	/* Mode 9 - UART_OUTPUT/
+				PERF_TIMERA (GPIO 0, 1, 2, 3) */
+	0x00003,	/* Mode a - PERF_TIMERB (GPIO 0, 1) */
+	0x00000,	/* Mode b - Not really a mode! */
+};
+
+/* -- Bit masks -- */
+
+/* This gives you the 'register relative offset gpio' number */
+#define OFFSET_GPIO_NUMBER(gpio)	(gpio - MSP_GPIO_OFFSET[gpio])
+
+/* These take the 'register relative offset gpio' number */
+#define BASIC_DATA_REG_MASK(ogpio)		(1 << ogpio)
+#define BASIC_MODE_REG_VALUE(mode, ogpio)	\
+	(mode << BASIC_MODE_REG_SHIFT(ogpio))
+#define BASIC_MODE_REG_MASK(ogpio)		\
+	BASIC_MODE_REG_VALUE(0xf, ogpio)
+#define BASIC_MODE_REG_SHIFT(ogpio)		(ogpio * 4)
+#define BASIC_MODE_REG_FROM_REG(data, ogpio)	\
+	((data & BASIC_MODE_REG_MASK(ogpio)) >> BASIC_MODE_REG_SHIFT(ogpio))
+
+/* These take the actual GPIO number (0 through 15) */
+#define BASIC_DATA_MASK(gpio)	\
+	BASIC_DATA_REG_MASK(OFFSET_GPIO_NUMBER(gpio))
+#define BASIC_MODE_MASK(gpio)	\
+	BASIC_MODE_REG_MASK(OFFSET_GPIO_NUMBER(gpio))
+#define BASIC_MODE(mode, gpio)	\
+	BASIC_MODE_REG_VALUE(mode, OFFSET_GPIO_NUMBER(gpio))
+#define BASIC_MODE_SHIFT(gpio)	\
+	BASIC_MODE_REG_SHIFT(OFFSET_GPIO_NUMBER(gpio))
+#define BASIC_MODE_FROM_REG(data, gpio)	\
+	BASIC_MODE_REG_FROM_REG(data, OFFSET_GPIO_NUMBER(gpio))
+
+/*
+ * Each extended GPIO register is 32 bits long and is responsible for up to
+ * eight GPIOs. The least significant 16 bits contain the set and clear bit
+ * pair for each of the GPIOs. The most significant 16 bits contain the
+ * disable and enable bit pair for each of the GPIOs. For example, the
+ * extended GPIO reg for GPIOs 16-23 is as follows:
+ *
+ *	31: GPIO23_DISABLE
+ *	...
+ *	19: GPIO17_DISABLE
+ *	18: GPIO17_ENABLE
+ *	17: GPIO16_DISABLE
+ *	16: GPIO16_ENABLE
+ *	...
+ *	3:  GPIO17_SET
+ *	2:  GPIO17_CLEAR
+ *	1:  GPIO16_SET
+ *	0:  GPIO16_CLEAR
+ */
+
+/* This gives the 'register relative offset gpio' number */
+#define EXTENDED_OFFSET_GPIO(gpio)	(gpio < 24 ? gpio - 16 : gpio - 24)
+
+/* These take the 'register relative offset gpio' number */
+#define EXTENDED_REG_DISABLE(ogpio)	(0x2 << ((ogpio * 2) + 16))
+#define EXTENDED_REG_ENABLE(ogpio)	(0x1 << ((ogpio * 2) + 16))
+#define EXTENDED_REG_SET(ogpio)		(0x2 << (ogpio * 2))
+#define EXTENDED_REG_CLR(ogpio)		(0x1 << (ogpio * 2))
+
+/* These take the actual GPIO number (16 through 27) */
+#define EXTENDED_DISABLE(gpio)	\
+	EXTENDED_REG_DISABLE(EXTENDED_OFFSET_GPIO(gpio))
+#define EXTENDED_ENABLE(gpio)	\
+	EXTENDED_REG_ENABLE(EXTENDED_OFFSET_GPIO(gpio))
+#define EXTENDED_SET(gpio)	\
+	EXTENDED_REG_SET(EXTENDED_OFFSET_GPIO(gpio))
+#define EXTENDED_CLR(gpio)	\
+	EXTENDED_REG_CLR(EXTENDED_OFFSET_GPIO(gpio))
+
+#define EXTENDED_FULL_MASK		(0xffffffff)
+
+/* -- API inline-functions -- */
+
+/*
+ * Gets the current value of the specified pin
+ */
+static inline enum msp_gpio_data msp_gpio_pin_get(unsigned int gpio)
+{
+	u32 pinhi_mask = 0, pinhi_mask2 = 0;
+
+	if (gpio >= MSP_NUM_GPIOS)
+		return MSP_GPIO_NONE;
+
+	if (gpio < 16) {
+		pinhi_mask = BASIC_DATA_MASK(gpio);
+	} else {
+		/*
+		 * Two cases are possible with the EXTENDED register:
+		 *  - In output mode (ENABLED flag set), check the CLR bit
+		 *  - In input mode (ENABLED flag not set), check the SET bit
+		 */
+		pinhi_mask = EXTENDED_ENABLE(gpio) | EXTENDED_CLR(gpio);
+		pinhi_mask2 = EXTENDED_SET(gpio);
+	}
+	if (((*MSP_GPIO_DATA_REGISTER[gpio] & pinhi_mask) == pinhi_mask) ||
+	    (*MSP_GPIO_DATA_REGISTER[gpio] & pinhi_mask2))
+		return MSP_GPIO_HI;
+	else
+		return MSP_GPIO_LO;
+}
+
+/* Sets the specified pin to the specified value */
+static inline void msp_gpio_pin_set(enum msp_gpio_data data, unsigned int gpio)
+{
+	if (gpio >= MSP_NUM_GPIOS)
+		return;
+
+	if (gpio < 16) {
+		if (data == MSP_GPIO_TOGGLE)
+			toggle_reg32(MSP_GPIO_DATA_REGISTER[gpio],
+					BASIC_DATA_MASK(gpio));
+		else if (data == MSP_GPIO_HI)
+			set_reg32(MSP_GPIO_DATA_REGISTER[gpio],
+					BASIC_DATA_MASK(gpio));
+		else
+			clear_reg32(MSP_GPIO_DATA_REGISTER[gpio],
+					BASIC_DATA_MASK(gpio));
+	} else {
+		if (data == MSP_GPIO_TOGGLE) {
+			/* Special ugly case:
+			 *   We have to read the CLR bit.
+			 *   If set, we write the CLR bit.
+			 *   If not, we write the SET bit.
+			 */
+			u32 tmpdata;
+
+			custom_read_reg32(MSP_GPIO_DATA_REGISTER[gpio],
+								tmpdata);
+			if (tmpdata & EXTENDED_CLR(gpio))
+				tmpdata = EXTENDED_CLR(gpio);
+			else
+				tmpdata = EXTENDED_SET(gpio);
+			custom_write_reg32(MSP_GPIO_DATA_REGISTER[gpio],
+								tmpdata);
+		} else {
+			u32 newdata;
+
+			if (data == MSP_GPIO_HI)
+				newdata = EXTENDED_SET(gpio);
+			else
+				newdata = EXTENDED_CLR(gpio);
+			set_value_reg32(MSP_GPIO_DATA_REGISTER[gpio],
+						EXTENDED_FULL_MASK, newdata);
+		}
+	}
+}
+
+/* Sets the specified pin to the specified value */
+static inline void msp_gpio_pin_hi(unsigned int gpio)
+{
+	msp_gpio_pin_set(MSP_GPIO_HI, gpio);
+}
+
+/* Sets the specified pin to the specified value */
+static inline void msp_gpio_pin_lo(unsigned int gpio)
+{
+	msp_gpio_pin_set(MSP_GPIO_LO, gpio);
+}
+
+/* Sets the specified pin to the opposite value */
+static inline void msp_gpio_pin_toggle(unsigned int gpio)
+{
+	msp_gpio_pin_set(MSP_GPIO_TOGGLE, gpio);
+}
+
+/* Gets the mode of the specified pin */
+static inline enum msp_gpio_mode msp_gpio_pin_get_mode(unsigned int gpio)
+{
+	enum msp_gpio_mode retval = MSP_GPIO_UNKNOWN;
+	uint32_t data;
+
+	if (gpio >= MSP_NUM_GPIOS)
+		return retval;
+
+	data = *MSP_GPIO_MODE_REGISTER[gpio];
+
+	if (gpio < 16) {
+		retval = BASIC_MODE_FROM_REG(data, gpio);
+	} else {
+		/* Extended pins can only be either INPUT or OUTPUT */
+		if (data & EXTENDED_ENABLE(gpio))
+			retval = MSP_GPIO_OUTPUT;
+		else
+			retval = MSP_GPIO_INPUT;
+	}
+
+	return retval;
+}
+
+/*
+ * Sets the specified mode on the requested pin
+ * Returns 0 on success, or -1 if that mode is not allowed on this pin
+ */
+static inline int msp_gpio_pin_mode(enum msp_gpio_mode mode, unsigned int gpio)
+{
+	u32 modemask, newmode;
+
+	if ((1 << gpio) & ~MSP_GPIO_MODE_ALLOWED[mode])
+		return -1;
+
+	if (gpio >= MSP_NUM_GPIOS)
+		return -1;
+
+	if (gpio < 16) {
+		modemask = BASIC_MODE_MASK(gpio);
+		newmode =  BASIC_MODE(mode, gpio);
+	} else {
+		modemask = EXTENDED_FULL_MASK;
+		if (mode == MSP_GPIO_INPUT)
+			newmode = EXTENDED_DISABLE(gpio);
+		else
+			newmode = EXTENDED_ENABLE(gpio);
+	}
+	/* Do the set atomically */
+	set_value_reg32(MSP_GPIO_MODE_REGISTER[gpio], modemask, newmode);
+
+	return 0;
+}
+
+#endif /* __MSP_GPIO_MACROS_H__ */
diff --git a/arch/mips/include/asm/mach-pmcs-msp71xx/msp_int.h b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_int.h
new file mode 100644
index 0000000..1d9f054
--- /dev/null
+++ b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_int.h
@@ -0,0 +1,43 @@
+/*
+ * Defines for the MSP interrupt handlers.
+ *
+ * Copyright (C) 2005, PMC-Sierra, Inc.  All rights reserved.
+ * Author: Andrew Hughes, Andrew_Hughes@pmc-sierra.com
+ *
+ * ########################################################################
+ *
+ *  This program is free software; you can distribute it and/or modify it
+ *  under the terms of the GNU General Public License (Version 2) as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope it will be useful, but WITHOUT
+ *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ *  for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
+ *
+ * ########################################################################
+ */
+
+#ifndef _MSP_INT_H
+#define _MSP_INT_H
+
+/*
+ * The PMC-Sierra MSP product line has at least two different interrupt
+ * controllers, the SLP register based scheme and the CIC interrupt
+ * controller block mechanism.  This file distinguishes between them
+ * so that devices see a uniform interface.
+ */
+
+#if defined(CONFIG_IRQ_MSP_SLP)
+	#include "msp_slp_int.h"
+#elif defined(CONFIG_IRQ_MSP_CIC)
+	#include "msp_cic_int.h"
+#else
+	#error "What sort of interrupt controller does *your* MSP have?"
+#endif
+
+#endif /* !_MSP_INT_H */
diff --git a/arch/mips/include/asm/mach-pmcs-msp71xx/msp_pci.h b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_pci.h
new file mode 100644
index 0000000..4156069
--- /dev/null
+++ b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_pci.h
@@ -0,0 +1,205 @@
+/*
+ * Copyright (c) 2000-2006 PMC-Sierra INC.
+ *
+ *     This program is free software; you can redistribute it
+ *     and/or modify it under the terms of the GNU General
+ *     Public License as published by the Free Software
+ *     Foundation; either version 2 of the License, or (at your
+ *     option) any later version.
+ *
+ *     This program is distributed in the hope that it will be
+ *     useful, but WITHOUT ANY WARRANTY; without even the implied
+ *     warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
+ *     PURPOSE.  See the GNU General Public License for more
+ *     details.
+ *
+ *     You should have received a copy of the GNU General Public
+ *     License along with this program; if not, write to the Free
+ *     Software Foundation, Inc., 675 Mass Ave, Cambridge, MA
+ *     02139, USA.
+ *
+ * PMC-SIERRA INC. DISCLAIMS ANY LIABILITY OF ANY KIND
+ * FOR ANY DAMAGES WHATSOEVER RESULTING FROM THE USE OF THIS
+ * SOFTWARE.
+ */
+
+#ifndef _MSP_PCI_H_
+#define _MSP_PCI_H_
+
+#define MSP_HAS_PCI(ID)	(((u32)(ID) <= 0x4236) && ((u32)(ID) >= 0x4220))
+
+/*
+ * It is convenient to program the OATRAN register so that
+ * Athena virtual address space and PCI address space are
+ * the same. This is not a requirement, just a convenience.
+ *
+ * The only hard restrictions on the value of OATRAN is that
+ * OATRAN must not be programmed to allow translated memory
+ * addresses to fall within the lowest 512MB of
+ * PCI address space. This region is hardcoded
+ * for use as Athena PCI Host Controller target
+ * access memory space to the Athena's SDRAM.
+ *
+ * Note that OATRAN applies only to memory accesses, not
+ * to I/O accesses.
+ *
+ * To program OATRAN to make Athena virtual address space
+ * and PCI address space have the same values, OATRAN
+ * is to be programmed to 0xB8000000. The top seven
+ * bits of the value mimic the seven bits clipped off
+ * by the PCI Host controller.
+ *
+ * With OATRAN at the said value, when the CPU does
+ * an access to its virtual address at, say 0xB900_5000,
+ * the address appearing on the PCI bus will be
+ * 0xB900_5000.
+ *    - Michael Penner
+ */
+#define MSP_PCI_OATRAN		0xB8000000UL
+
+#define MSP_PCI_SPACE_BASE	(MSP_PCI_OATRAN + 0x1002000UL)
+#define MSP_PCI_SPACE_SIZE	(0x3000000UL - 0x2000)
+#define MSP_PCI_SPACE_END \
+		(MSP_PCI_SPACE_BASE + MSP_PCI_SPACE_SIZE - 1)
+#define MSP_PCI_IOSPACE_BASE	(MSP_PCI_OATRAN + 0x1001000UL)
+#define MSP_PCI_IOSPACE_SIZE	0x1000
+#define MSP_PCI_IOSPACE_END  \
+		(MSP_PCI_IOSPACE_BASE + MSP_PCI_IOSPACE_SIZE - 1)
+
+/* IRQ for PCI status interrupts */
+#define PCI_STAT_IRQ	20
+
+#define QFLUSH_REG_1	0xB7F40000
+
+typedef volatile unsigned int pcireg;
+typedef void * volatile ppcireg;
+
+struct pci_block_copy
+{
+    pcireg   unused1; /* +0x00 */
+    pcireg   unused2; /* +0x04 */
+    ppcireg  unused3; /* +0x08 */
+    ppcireg  unused4; /* +0x0C */
+    pcireg   unused5; /* +0x10 */
+    pcireg   unused6; /* +0x14 */
+    pcireg   unused7; /* +0x18 */
+    ppcireg  unused8; /* +0x1C */
+    ppcireg  unused9; /* +0x20 */
+    pcireg   unusedA; /* +0x24 */
+    ppcireg  unusedB; /* +0x28 */
+    ppcireg  unusedC; /* +0x2C */
+};
+
+enum
+{
+    config_device_vendor,  /* 0 */
+    config_status_command, /* 1 */
+    config_class_revision, /* 2 */
+    config_BIST_header_latency_cache, /* 3 */
+    config_BAR0,           /* 4 */
+    config_BAR1,           /* 5 */
+    config_BAR2,           /* 6 */
+    config_not_used7,      /* 7 */
+    config_not_used8,      /* 8 */
+    config_not_used9,      /* 9 */
+    config_CIS,            /* 10 */
+    config_subsystem,      /* 11 */
+    config_not_used12,     /* 12 */
+    config_capabilities,   /* 13 */
+    config_not_used14,     /* 14 */
+    config_lat_grant_irq,  /* 15 */
+    config_message_control,/* 16 */
+    config_message_addr,   /* 17 */
+    config_message_data,   /* 18 */
+    config_VPD_addr,       /* 19 */
+    config_VPD_data,       /* 20 */
+    config_maxregs         /* 21 - number of registers */
+};
+
+struct msp_pci_regs
+{
+    pcireg hop_unused_00; /* +0x00 */
+    pcireg hop_unused_04; /* +0x04 */
+    pcireg hop_unused_08; /* +0x08 */
+    pcireg hop_unused_0C; /* +0x0C */
+    pcireg hop_unused_10; /* +0x10 */
+    pcireg hop_unused_14; /* +0x14 */
+    pcireg hop_unused_18; /* +0x18 */
+    pcireg hop_unused_1C; /* +0x1C */
+    pcireg hop_unused_20; /* +0x20 */
+    pcireg hop_unused_24; /* +0x24 */
+    pcireg hop_unused_28; /* +0x28 */
+    pcireg hop_unused_2C; /* +0x2C */
+    pcireg hop_unused_30; /* +0x30 */
+    pcireg hop_unused_34; /* +0x34 */
+    pcireg if_control;    /* +0x38 */
+    pcireg oatran;        /* +0x3C */
+    pcireg reset_ctl;     /* +0x40 */
+    pcireg config_addr;   /* +0x44 */
+    pcireg hop_unused_48; /* +0x48 */
+    pcireg msg_signaled_int_status; /* +0x4C */
+    pcireg msg_signaled_int_mask;   /* +0x50 */
+    pcireg if_status;     /* +0x54 */
+    pcireg if_mask;       /* +0x58 */
+    pcireg hop_unused_5C; /* +0x5C */
+    pcireg hop_unused_60; /* +0x60 */
+    pcireg hop_unused_64; /* +0x64 */
+    pcireg hop_unused_68; /* +0x68 */
+    pcireg hop_unused_6C; /* +0x6C */
+    pcireg hop_unused_70; /* +0x70 */
+
+    struct pci_block_copy pci_bc[2] __attribute__((aligned(64)));
+
+    pcireg error_hdr1; /* +0xE0 */
+    pcireg error_hdr2; /* +0xE4 */
+
+    pcireg config[config_maxregs] __attribute__((aligned(256)));
+
+};
+
+#define BPCI_CFGADDR_BUSNUM_SHF 16
+#define BPCI_CFGADDR_FUNCTNUM_SHF 8
+#define BPCI_CFGADDR_REGNUM_SHF 2
+#define BPCI_CFGADDR_ENABLE (1<<31)
+
+#define BPCI_IFCONTROL_RTO (1<<20) /* Retry timeout */
+#define BPCI_IFCONTROL_HCE (1<<16) /* Host configuration enable */
+#define BPCI_IFCONTROL_CTO_SHF 12  /* Shift count for CTO bits */
+#define BPCI_IFCONTROL_SE  (1<<5)  /* Enable exceptions on errors */
+#define BPCI_IFCONTROL_BIST (1<<4) /* Use BIST in per. mode */
+#define BPCI_IFCONTROL_CAP (1<<3)  /* Enable capabilities */
+#define BPCI_IFCONTROL_MMC_SHF 0   /* Shift count for MMC bits */
+
+#define BPCI_IFSTATUS_MGT  (1<<8)  /* Master Grant timeout */
+#define BPCI_IFSTATUS_MTT  (1<<9)  /* Master TRDY timeout */
+#define BPCI_IFSTATUS_MRT  (1<<10) /* Master retry timeout */
+#define BPCI_IFSTATUS_BC0F (1<<13) /* Block copy 0 fault */
+#define BPCI_IFSTATUS_BC1F (1<<14) /* Block copy 1 fault */
+#define BPCI_IFSTATUS_PCIU (1<<15) /* PCI unable to respond */
+#define BPCI_IFSTATUS_BSIZ (1<<16) /* PCI access with illegal size */
+#define BPCI_IFSTATUS_BADD (1<<17) /* PCI access with illegal addr */
+#define BPCI_IFSTATUS_RTO  (1<<18) /* Retry time out */
+#define BPCI_IFSTATUS_SER  (1<<19) /* System error */
+#define BPCI_IFSTATUS_PER  (1<<20) /* Parity error */
+#define BPCI_IFSTATUS_LCA  (1<<21) /* Local CPU abort */
+#define BPCI_IFSTATUS_MEM  (1<<22) /* Memory prot. violation */
+#define BPCI_IFSTATUS_ARB  (1<<23) /* Arbiter timed out */
+#define BPCI_IFSTATUS_STA  (1<<27) /* Signaled target abort */
+#define BPCI_IFSTATUS_TA   (1<<28) /* Target abort */
+#define BPCI_IFSTATUS_MA   (1<<29) /* Master abort */
+#define BPCI_IFSTATUS_PEI  (1<<30) /* Parity error as initiator */
+#define BPCI_IFSTATUS_PET  (1<<31) /* Parity error as target */
+
+#define BPCI_RESETCTL_PR (1<<0)    /* True if reset asserted */
+#define BPCI_RESETCTL_RT (1<<4)    /* Release time */
+#define BPCI_RESETCTL_CT (1<<8)    /* Config time */
+#define BPCI_RESETCTL_PE (1<<12)   /* PCI enabled */
+#define BPCI_RESETCTL_HM (1<<13)   /* PCI host mode */
+#define BPCI_RESETCTL_RI (1<<14)   /* PCI reset in */
+
+extern struct msp_pci_regs msp_pci_regs
+			__attribute__((section(".register")));
+extern unsigned long msp_pci_config_space
+			__attribute__((section(".register")));
+
+#endif /* !_MSP_PCI_H_ */
diff --git a/arch/mips/include/asm/mach-pmcs-msp71xx/msp_prom.h b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_prom.h
new file mode 100644
index 0000000..786d82d
--- /dev/null
+++ b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_prom.h
@@ -0,0 +1,171 @@
+/*
+ * MIPS boards bootprom interface for the Linux kernel.
+ *
+ * Copyright (C) 2000 MIPS Technologies, Inc.  All rights reserved.
+ * Author: Carsten Langgaard, carstenl@mips.com
+ *
+ * ########################################################################
+ *
+ *  This program is free software; you can distribute it and/or modify it
+ *  under the terms of the GNU General Public License (Version 2) as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope it will be useful, but WITHOUT
+ *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ *  for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
+ *
+ * ########################################################################
+ */
+
+#ifndef _ASM_MSP_PROM_H
+#define _ASM_MSP_PROM_H
+
+#include <linux/types.h>
+
+#define DEVICEID			"deviceid"
+#define FEATURES			"features"
+#define PROM_ENV			"prom_env"
+#define PROM_ENV_FILE			"/proc/"PROM_ENV
+#define PROM_ENV_SIZE			256
+
+#define CPU_DEVID_FAMILY		0x0000ff00
+#define CPU_DEVID_REVISION		0x000000ff
+
+#define FPGA_IS_POLO(revision) \
+		(((revision >= 0xb0) && (revision < 0xd0)))
+#define FPGA_IS_5000(revision) \
+		((revision >= 0x80) && (revision <= 0x90))
+#define	FPGA_IS_ZEUS(revision)		((revision < 0x7f))
+#define FPGA_IS_DUET(revision) \
+		(((revision >= 0xa0) && (revision < 0xb0)))
+#define FPGA_IS_MSP4200(revision)	((revision >= 0xd0))
+#define FPGA_IS_MSP7100(revision)	((revision >= 0xd0))
+
+#define MACHINE_TYPE_POLO		"POLO"
+#define MACHINE_TYPE_DUET		"DUET"
+#define	MACHINE_TYPE_ZEUS		"ZEUS"
+#define MACHINE_TYPE_MSP2000REVB	"MSP2000REVB"
+#define MACHINE_TYPE_MSP5000		"MSP5000"
+#define MACHINE_TYPE_MSP4200		"MSP4200"
+#define MACHINE_TYPE_MSP7120		"MSP7120"
+#define MACHINE_TYPE_MSP7130		"MSP7130"
+#define MACHINE_TYPE_OTHER		"OTHER"
+
+#define MACHINE_TYPE_POLO_FPGA		"POLO-FPGA"
+#define MACHINE_TYPE_DUET_FPGA		"DUET-FPGA"
+#define	MACHINE_TYPE_ZEUS_FPGA		"ZEUS_FPGA"
+#define MACHINE_TYPE_MSP2000REVB_FPGA	"MSP2000REVB-FPGA"
+#define MACHINE_TYPE_MSP5000_FPGA	"MSP5000-FPGA"
+#define MACHINE_TYPE_MSP4200_FPGA	"MSP4200-FPGA"
+#define MACHINE_TYPE_MSP7100_FPGA	"MSP7100-FPGA"
+#define MACHINE_TYPE_OTHER_FPGA		"OTHER-FPGA"
+
+/* Device Family definitions */
+#define FAMILY_FPGA			0x0000
+#define FAMILY_ZEUS			0x1000
+#define FAMILY_POLO			0x2000
+#define FAMILY_DUET			0x4000
+#define FAMILY_TRIAD			0x5000
+#define FAMILY_MSP4200			0x4200
+#define FAMILY_MSP4200_FPGA		0x4f00
+#define FAMILY_MSP7100			0x7100
+#define FAMILY_MSP7100_FPGA		0x7f00
+
+/* Device Type definitions */
+#define TYPE_MSP7120			0x7120
+#define TYPE_MSP7130			0x7130
+
+#define ENET_KEY		'E'
+#define ENETTXD_KEY		'e'
+#define PCI_KEY			'P'
+#define PCIMUX_KEY		'p'
+#define SEC_KEY			'S'
+#define SPAD_KEY		'D'
+#define TDM_KEY			'T'
+#define ZSP_KEY			'Z'
+
+#define FEATURE_NOEXIST		'-'
+#define FEATURE_EXIST		'+'
+
+#define ENET_MII		'M'
+#define ENET_RMII		'R'
+
+#define	ENETTXD_FALLING		'F'
+#define ENETTXD_RISING		'R'
+
+#define PCI_HOST		'H'
+#define PCI_PERIPHERAL		'P'
+
+#define PCIMUX_FULL		'F'
+#define PCIMUX_SINGLE		'S'
+
+#define SEC_DUET		'D'
+#define SEC_POLO		'P'
+#define SEC_SLOW		'S'
+#define SEC_TRIAD		'T'
+
+#define SPAD_POLO		'P'
+
+#define TDM_DUET		'D'	/* DUET TDMs might exist */
+#define TDM_POLO		'P'	/* POLO TDMs might exist */
+#define TDM_TRIAD		'T'	/* TRIAD TDMs might exist */
+
+#define ZSP_DUET		'D'	/* one DUET zsp engine */
+#define ZSP_TRIAD		'T'	/* two TRIAD zsp engines */
+
+extern char *prom_getenv(char *name);
+extern void prom_init_cmdline(void);
+extern void prom_meminit(void);
+extern void prom_fixup_mem_map(unsigned long start_mem,
+			       unsigned long end_mem);
+
+extern int get_ethernet_addr(char *ethaddr_name, char *ethernet_addr);
+extern unsigned long get_deviceid(void);
+extern char identify_enet(unsigned long interface_num);
+extern char identify_enetTxD(unsigned long interface_num);
+extern char identify_pci(void);
+extern char identify_sec(void);
+extern char identify_spad(void);
+extern char identify_sec(void);
+extern char identify_tdm(void);
+extern char identify_zsp(void);
+extern unsigned long identify_family(void);
+extern unsigned long identify_revision(void);
+
+/*
+ * The following macro calls prom_printf and puts the format string
+ * into an init section so it can be reclaimed.
+ */
+#define ppfinit(f, x...) \
+	do { \
+		static char _f[] __initdata = KERN_INFO f; \
+		printk(_f, ## x); \
+	} while (0)
+
+/* Memory descriptor management. */
+#define PROM_MAX_PMEMBLOCKS    7	/* 6 used */
+
+enum yamon_memtypes {
+	yamon_dontuse,
+	yamon_prom,
+	yamon_free,
+};
+
+struct prom_pmemblock {
+	unsigned long base; /* Within KSEG0. */
+	unsigned int size;  /* In bytes. */
+	unsigned int type;  /* free or prom memory */
+};
+
+extern int prom_argc;
+extern char **prom_argv;
+extern char **prom_envp;
+extern int *prom_vec;
+extern struct prom_pmemblock *prom_getmdesc(void);
+
+#endif /* !_ASM_MSP_PROM_H */
diff --git a/arch/mips/include/asm/mach-pmcs-msp71xx/msp_regops.h b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_regops.h
new file mode 100644
index 0000000..7d41474
--- /dev/null
+++ b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_regops.h
@@ -0,0 +1,236 @@
+/*
+ * SMP/VPE-safe functions to access "registers" (see note).
+ *
+ * NOTES:
+* - These macros use ll/sc instructions, so it is your responsibility to
+ * ensure these are available on your platform before including this file.
+ * - The MIPS32 spec states that ll/sc results are undefined for uncached
+ * accesses. This means they can't be used on HW registers accessed
+ * through kseg1. Code which requires these macros for this purpose must
+ * front-end the registers with cached memory "registers" and have a single
+ * thread update the actual HW registers.
+ * - A maximum of 2k of code can be inserted between ll and sc. Every
+ * memory accesses between the instructions will increase the chance of
+ * sc failing and having to loop.
+ * - When using custom_read_reg32/custom_write_reg32 only perform the
+ * necessary logical operations on the register value in between these
+ * two calls. All other logic should be performed before the first call.
+  * - There is a bug on the R10000 chips which has a workaround. If you
+ * are affected by this bug, make sure to define the symbol 'R10000_LLSC_WAR'
+ * to be non-zero.  If you are using this header from within linux, you may
+ * include <asm/war.h> before including this file to have this defined
+ * appropriately for you.
+ *
+ * Copyright 2005-2007 PMC-Sierra, Inc.
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
+ *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
+ *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
+ *  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
+ *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ *  LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF USE,
+ *  DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ *  THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
+ *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
+ *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *  You should have received a copy of the  GNU General Public License along
+ *  with this program; if not, write  to the Free Software Foundation, Inc., 675
+ *  Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef __ASM_REGOPS_H__
+#define __ASM_REGOPS_H__
+
+#include <linux/types.h>
+
+#include <asm/war.h>
+
+#ifndef R10000_LLSC_WAR
+#define R10000_LLSC_WAR 0
+#endif
+
+#if R10000_LLSC_WAR == 1
+#define __beqz	"beqzl	"
+#else
+#define __beqz	"beqz	"
+#endif
+
+#ifndef _LINUX_TYPES_H
+typedef unsigned int u32;
+#endif
+
+/*
+ * Sets all the masked bits to the corresponding value bits
+ */
+static inline void set_value_reg32(volatile u32 *const addr,
+					u32 const mask,
+					u32 const value)
+{
+	u32 temp;
+
+	__asm__ __volatile__(
+	"	.set	push				\n"
+	"	.set	mips3				\n"
+	"1:	ll	%0, %1	# set_value_reg32	\n"
+	"	and	%0, %2				\n"
+	"	or	%0, %3				\n"
+	"	sc	%0, %1				\n"
+	"	"__beqz"%0, 1b				\n"
+	"	nop					\n"
+	"	.set	pop				\n"
+	: "=&r" (temp), "=m" (*addr)
+	: "ir" (~mask), "ir" (value), "m" (*addr));
+}
+
+/*
+ * Sets all the masked bits to '1'
+ */
+static inline void set_reg32(volatile u32 *const addr,
+				u32 const mask)
+{
+	u32 temp;
+
+	__asm__ __volatile__(
+	"	.set	push				\n"
+	"	.set	mips3				\n"
+	"1:	ll	%0, %1		# set_reg32	\n"
+	"	or	%0, %2				\n"
+	"	sc	%0, %1				\n"
+	"	"__beqz"%0, 1b				\n"
+	"	nop					\n"
+	"	.set	pop				\n"
+	: "=&r" (temp), "=m" (*addr)
+	: "ir" (mask), "m" (*addr));
+}
+
+/*
+ * Sets all the masked bits to '0'
+ */
+static inline void clear_reg32(volatile u32 *const addr,
+				u32 const mask)
+{
+	u32 temp;
+
+	__asm__ __volatile__(
+	"	.set	push				\n"
+	"	.set	mips3				\n"
+	"1:	ll	%0, %1		# clear_reg32	\n"
+	"	and	%0, %2				\n"
+	"	sc	%0, %1				\n"
+	"	"__beqz"%0, 1b				\n"
+	"	nop					\n"
+	"	.set	pop				\n"
+	: "=&r" (temp), "=m" (*addr)
+	: "ir" (~mask), "m" (*addr));
+}
+
+/*
+ * Toggles all masked bits from '0' to '1' and '1' to '0'
+ */
+static inline void toggle_reg32(volatile u32 *const addr,
+				u32 const mask)
+{
+	u32 temp;
+
+	__asm__ __volatile__(
+	"	.set	push				\n"
+	"	.set	mips3				\n"
+	"1:	ll	%0, %1		# toggle_reg32	\n"
+	"	xor	%0, %2				\n"
+	"	sc	%0, %1				\n"
+	"	"__beqz"%0, 1b				\n"
+	"	nop					\n"
+	"	.set	pop				\n"
+	: "=&r" (temp), "=m" (*addr)
+	: "ir" (mask), "m" (*addr));
+}
+
+/*
+ * Read all masked bits others are returned as '0'
+ */
+static inline u32 read_reg32(volatile u32 *const addr,
+				u32 const mask)
+{
+	u32 temp;
+
+	__asm__ __volatile__(
+	"	.set	push				\n"
+	"	.set	noreorder			\n"
+	"	lw	%0, %1		# read		\n"
+	"	and	%0, %2		# mask		\n"
+	"	.set	pop				\n"
+	: "=&r" (temp)
+	: "m" (*addr), "ir" (mask));
+
+	return temp;
+}
+
+/*
+ * blocking_read_reg32 - Read address with blocking load
+ *
+ * Uncached writes need to be read back to ensure they reach RAM.
+ * The returned value must be 'used' to prevent from becoming a
+ * non-blocking load.
+ */
+static inline u32 blocking_read_reg32(volatile u32 *const addr)
+{
+	u32 temp;
+
+	__asm__ __volatile__(
+	"	.set	push				\n"
+	"	.set	noreorder			\n"
+	"	lw	%0, %1		# read		\n"
+	"	move	%0, %0		# block		\n"
+	"	.set	pop				\n"
+	: "=&r" (temp)
+	: "m" (*addr));
+
+	return temp;
+}
+
+/*
+ * For special strange cases only:
+ *
+ * If you need custom processing within a ll/sc loop, use the following macros
+ * VERY CAREFULLY:
+ *
+ *   u32 tmp;				<-- Define a variable to hold the data
+ *
+ *   custom_read_reg32(address, tmp);	<-- Reads the address and put the value
+ *						in the 'tmp' variable given
+ *
+ *	From here on out, you are (basically) atomic, so don't do anything too
+ *	fancy!
+ *	Also, this code may loop if the end of this block fails to write
+ *	everything back safely due do the other CPU, so do NOT do anything
+ *	with side-effects!
+ *
+ *   custom_write_reg32(address, tmp);	<-- Writes back 'tmp' safely.
+ */
+#define custom_read_reg32(address, tmp)				\
+	__asm__ __volatile__(					\
+	"	.set	push				\n"	\
+	"	.set	mips3				\n"	\
+	"1:	ll	%0, %1	#custom_read_reg32	\n"	\
+	"	.set	pop				\n"	\
+	: "=r" (tmp), "=m" (*address)				\
+	: "m" (*address))
+
+#define custom_write_reg32(address, tmp)			\
+	__asm__ __volatile__(					\
+	"	.set	push				\n"	\
+	"	.set	mips3				\n"	\
+	"	sc	%0, %1	#custom_write_reg32	\n"	\
+	"	"__beqz"%0, 1b				\n"	\
+	"	nop					\n"	\
+	"	.set	pop				\n"	\
+	: "=&r" (tmp), "=m" (*address)				\
+	: "0" (tmp), "m" (*address))
+
+#endif  /* __ASM_REGOPS_H__ */
diff --git a/arch/mips/include/asm/mach-pmcs-msp71xx/msp_regs.h b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_regs.h
new file mode 100644
index 0000000..692c1b6
--- /dev/null
+++ b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_regs.h
@@ -0,0 +1,664 @@
+/*
+ * Defines for the address space, registers and register configuration
+ * (bit masks, access macros etc) for the PMC-Sierra line of MSP products.
+ * This file contains addess maps for all the devices in the line of
+ * products but only has register definitions and configuration masks for
+ * registers which aren't definitely associated with any device.  Things
+ * like clock settings, reset access, the ELB etc.  Individual device
+ * drivers will reference the appropriate XXX_BASE value defined here
+ * and have individual registers offset from that.
+ *
+ * Copyright (C) 2005-2007 PMC-Sierra, Inc.  All rights reserved.
+ * Author: Andrew Hughes, Andrew_Hughes@pmc-sierra.com
+ *
+ * ########################################################################
+ *
+ *  This program is free software; you can distribute it and/or modify it
+ *  under the terms of the GNU General Public License (Version 2) as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope it will be useful, but WITHOUT
+ *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ *  for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
+ *
+ * ########################################################################
+ */
+
+#include <asm/addrspace.h>
+#include <linux/types.h>
+
+#ifndef _ASM_MSP_REGS_H
+#define _ASM_MSP_REGS_H
+
+/*
+ ########################################################################
+ #  Address space and device base definitions                           #
+ ########################################################################
+ */
+
+/*
+ ***************************************************************************
+ * System Logic and Peripherals (ELB, UART0, etc) device address space     *
+ ***************************************************************************
+ */
+#define MSP_SLP_BASE		0x1c000000
+					/* System Logic and Peripherals */
+#define MSP_RST_BASE		(MSP_SLP_BASE + 0x10)
+					/* System reset register base	*/
+#define MSP_RST_SIZE		0x0C	/* System reset register space	*/
+
+#define MSP_WTIMER_BASE		(MSP_SLP_BASE + 0x04C)
+					/* watchdog timer base          */
+#define MSP_ITIMER_BASE		(MSP_SLP_BASE + 0x054)
+					/* internal timer base          */
+#define MSP_UART0_BASE		(MSP_SLP_BASE + 0x100)
+					/* UART0 controller base        */
+#define MSP_BCPY_CTRL_BASE	(MSP_SLP_BASE + 0x120)
+					/* Block Copy controller base   */
+#define MSP_BCPY_DESC_BASE	(MSP_SLP_BASE + 0x160)
+					/* Block Copy descriptor base   */
+
+/*
+ ***************************************************************************
+ * PCI address space                                                       *
+ ***************************************************************************
+ */
+#define MSP_PCI_BASE		0x19000000
+
+/*
+ ***************************************************************************
+ * MSbus device address space                                              *
+ ***************************************************************************
+ */
+#define MSP_MSB_BASE		0x18000000
+					/* MSbus address start          */
+#define MSP_PER_BASE		(MSP_MSB_BASE + 0x400000)
+					/* Peripheral device registers  */
+#define MSP_MAC0_BASE		(MSP_MSB_BASE + 0x600000)
+					/* MAC A device registers       */
+#define MSP_MAC1_BASE		(MSP_MSB_BASE + 0x700000)
+					/* MAC B device registers       */
+#define MSP_MAC_SIZE		0xE0	/* MAC register space		*/
+
+#define MSP_SEC_BASE		(MSP_MSB_BASE + 0x800000)
+					/* Security Engine registers    */
+#define MSP_MAC2_BASE		(MSP_MSB_BASE + 0x900000)
+					/* MAC C device registers       */
+#define MSP_ADSL2_BASE		(MSP_MSB_BASE + 0xA80000)
+					/* ADSL2 device registers       */
+#define MSP_USB0_BASE		(MSP_MSB_BASE + 0xB00000)
+					/* USB0 device registers        */
+#define MSP_USB1_BASE		(MSP_MSB_BASE + 0x300000)
+					/* USB1 device registers	*/
+#define MSP_CPUIF_BASE		(MSP_MSB_BASE + 0xC00000)
+					/* CPU interface registers      */
+
+/* Devices within the MSbus peripheral block */
+#define MSP_UART1_BASE		(MSP_PER_BASE + 0x030)
+					/* UART1 controller base        */
+#define MSP_SPI_BASE		(MSP_PER_BASE + 0x058)
+					/* SPI/MPI control registers    */
+#define MSP_TWI_BASE		(MSP_PER_BASE + 0x090)
+					/* Two-wire control registers   */
+#define MSP_PTIMER_BASE		(MSP_PER_BASE + 0x0F0)
+					/* Programmable timer control   */
+
+/*
+ ***************************************************************************
+ * Physical Memory configuration address space                             *
+ ***************************************************************************
+ */
+#define MSP_MEM_CFG_BASE	0x17f00000
+
+#define MSP_MEM_INDIRECT_CTL_10	0x10
+
+/*
+ * Notes:
+ *  1) The SPI registers are split into two blocks, one offset from the
+ *     MSP_SPI_BASE by 0x00 and the other offset from the MSP_SPI_BASE by
+ *     0x68.  The SPI driver definitions for the register must be aware
+ *     of this.
+ *  2) The block copy engine register are divided into two regions, one
+ *     for the control/configuration of the engine proper and one for the
+ *     values of the descriptors used in the copy process.  These have
+ *     different base defines (CTRL_BASE vs DESC_BASE)
+ *  3) These constants are for physical addresses which means that they
+ *     work correctly with "ioremap" and friends.  This means that device
+ *     drivers will need to remap these addresses using ioremap and perhaps
+ *     the readw/writew macros.  Or they could use the regptr() macro
+ *     defined below, but the readw/writew calls are the correct thing.
+ *  4) The UARTs have an additional status register offset from the base
+ *     address.  This register isn't used in the standard 8250 driver but
+ *     may be used in other software.  Consult the hardware datasheet for
+ *     offset details.
+ *  5) For some unknown reason the security engine (MSP_SEC_BASE) registers
+ *     start at an offset of 0x84 from the base address but the block of
+ *     registers before this is reserved for the security engine.  The
+ *     driver will have to be aware of this but it makes the register
+ *     definitions line up better with the documentation.
+ */
+
+/*
+ ########################################################################
+ #  System register definitions.  Not associated with a specific device #
+ ########################################################################
+ */
+
+/*
+ * This macro maps the physical register number into uncached space
+ * and (for C code) casts it into a u32 pointer so it can be dereferenced
+ * Normally these would be accessed with ioremap and readX/writeX, but
+ * these are convenient for a lot of internal kernel code.
+ */
+#ifdef __ASSEMBLER__
+	#define regptr(addr) (KSEG1ADDR(addr))
+#else
+	#define regptr(addr) ((volatile u32 *const)(KSEG1ADDR(addr)))
+#endif
+
+/*
+ ***************************************************************************
+ * System Logic and Peripherals (RESET, ELB, etc) registers                *
+ ***************************************************************************
+ */
+
+/* System Control register definitions */
+#define	DEV_ID_REG	regptr(MSP_SLP_BASE + 0x00)
+					/* Device-ID                 RO */
+#define	FWR_ID_REG	regptr(MSP_SLP_BASE + 0x04)
+					/* Firmware-ID Register      RW */
+#define	SYS_ID_REG0	regptr(MSP_SLP_BASE + 0x08)
+					/* System-ID Register-0      RW */
+#define	SYS_ID_REG1	regptr(MSP_SLP_BASE + 0x0C)
+					/* System-ID Register-1      RW */
+
+/* System Reset register definitions */
+#define	RST_STS_REG	regptr(MSP_SLP_BASE + 0x10)
+					/* System Reset Status       RO */
+#define	RST_SET_REG	regptr(MSP_SLP_BASE + 0x14)
+					/* System Set Reset          WO */
+#define	RST_CLR_REG	regptr(MSP_SLP_BASE + 0x18)
+					/* System Clear Reset        WO */
+
+/* System Clock Registers */
+#define PCI_SLP_REG	regptr(MSP_SLP_BASE + 0x1C)
+					/* PCI clock generator       RW */
+#define URT_SLP_REG	regptr(MSP_SLP_BASE + 0x20)
+					/* UART clock generator      RW */
+/* reserved		      (MSP_SLP_BASE + 0x24)                     */
+/* reserved		      (MSP_SLP_BASE + 0x28)                     */
+#define PLL1_SLP_REG	regptr(MSP_SLP_BASE + 0x2C)
+					/* PLL1 clock generator      RW */
+#define PLL0_SLP_REG	regptr(MSP_SLP_BASE + 0x30)
+					/* PLL0 clock generator      RW */
+#define MIPS_SLP_REG	regptr(MSP_SLP_BASE + 0x34)
+					/* MIPS clock generator      RW */
+#define	VE_SLP_REG	regptr(MSP_SLP_BASE + 0x38)
+					/* Voice Eng clock generator RW */
+/* reserved		      (MSP_SLP_BASE + 0x3C)                     */
+#define MSB_SLP_REG	regptr(MSP_SLP_BASE + 0x40)
+					/* MS-Bus clock generator    RW */
+#define SMAC_SLP_REG	regptr(MSP_SLP_BASE + 0x44)
+					/* Sec & MAC clock generator RW */
+#define PERF_SLP_REG	regptr(MSP_SLP_BASE + 0x48)
+					/* Per & TDM clock generator RW */
+
+/* Interrupt Controller Registers */
+#define SLP_INT_STS_REG regptr(MSP_SLP_BASE + 0x70)
+					/* Interrupt status register RW */
+#define SLP_INT_MSK_REG regptr(MSP_SLP_BASE + 0x74)
+					/* Interrupt enable/mask     RW */
+#define SE_MBOX_REG	regptr(MSP_SLP_BASE + 0x78)
+					/* Security Engine mailbox   RW */
+#define VE_MBOX_REG	regptr(MSP_SLP_BASE + 0x7C)
+					/* Voice Engine mailbox      RW */
+
+/* ELB Controller Registers */
+#define CS0_CNFG_REG	regptr(MSP_SLP_BASE + 0x80)
+					/* ELB CS0 Configuration Reg    */
+#define CS0_ADDR_REG	regptr(MSP_SLP_BASE + 0x84)
+					/* ELB CS0 Base Address Reg     */
+#define CS0_MASK_REG	regptr(MSP_SLP_BASE + 0x88)
+					/* ELB CS0 Mask Register        */
+#define CS0_ACCESS_REG	regptr(MSP_SLP_BASE + 0x8C)
+					/* ELB CS0 access register      */
+
+#define CS1_CNFG_REG	regptr(MSP_SLP_BASE + 0x90)
+					/* ELB CS1 Configuration Reg    */
+#define CS1_ADDR_REG	regptr(MSP_SLP_BASE + 0x94)
+					/* ELB CS1 Base Address Reg     */
+#define CS1_MASK_REG	regptr(MSP_SLP_BASE + 0x98)
+					/* ELB CS1 Mask Register        */
+#define CS1_ACCESS_REG	regptr(MSP_SLP_BASE + 0x9C)
+					/* ELB CS1 access register      */
+
+#define CS2_CNFG_REG	regptr(MSP_SLP_BASE + 0xA0)
+					/* ELB CS2 Configuration Reg    */
+#define CS2_ADDR_REG	regptr(MSP_SLP_BASE + 0xA4)
+					/* ELB CS2 Base Address Reg     */
+#define CS2_MASK_REG	regptr(MSP_SLP_BASE + 0xA8)
+					/* ELB CS2 Mask Register        */
+#define CS2_ACCESS_REG	regptr(MSP_SLP_BASE + 0xAC)
+					/* ELB CS2 access register      */
+
+#define CS3_CNFG_REG	regptr(MSP_SLP_BASE + 0xB0)
+					/* ELB CS3 Configuration Reg    */
+#define CS3_ADDR_REG	regptr(MSP_SLP_BASE + 0xB4)
+					/* ELB CS3 Base Address Reg     */
+#define CS3_MASK_REG	regptr(MSP_SLP_BASE + 0xB8)
+					/* ELB CS3 Mask Register        */
+#define CS3_ACCESS_REG	regptr(MSP_SLP_BASE + 0xBC)
+					/* ELB CS3 access register      */
+
+#define CS4_CNFG_REG	regptr(MSP_SLP_BASE + 0xC0)
+					/* ELB CS4 Configuration Reg    */
+#define CS4_ADDR_REG	regptr(MSP_SLP_BASE + 0xC4)
+					/* ELB CS4 Base Address Reg     */
+#define CS4_MASK_REG	regptr(MSP_SLP_BASE + 0xC8)
+					/* ELB CS4 Mask Register        */
+#define CS4_ACCESS_REG	regptr(MSP_SLP_BASE + 0xCC)
+					/* ELB CS4 access register      */
+
+#define CS5_CNFG_REG	regptr(MSP_SLP_BASE + 0xD0)
+					/* ELB CS5 Configuration Reg    */
+#define CS5_ADDR_REG	regptr(MSP_SLP_BASE + 0xD4)
+					/* ELB CS5 Base Address Reg     */
+#define CS5_MASK_REG	regptr(MSP_SLP_BASE + 0xD8)
+					/* ELB CS5 Mask Register        */
+#define CS5_ACCESS_REG	regptr(MSP_SLP_BASE + 0xDC)
+					/* ELB CS5 access register      */
+
+/* reserved			       0xE0 - 0xE8                      */
+#define ELB_1PC_EN_REG	regptr(MSP_SLP_BASE + 0xEC)
+					/* ELB single PC card detect    */
+
+/* reserved			       0xF0 - 0xF8                      */
+#define ELB_CLK_CFG_REG	regptr(MSP_SLP_BASE + 0xFC)
+					/* SDRAM read/ELB timing Reg    */
+
+/* Extended UART status registers */
+#define UART0_STATUS_REG	regptr(MSP_UART0_BASE + 0x0c0)
+					/* UART Status Register 0       */
+#define UART1_STATUS_REG	regptr(MSP_UART1_BASE + 0x170)
+					/* UART Status Register 1       */
+
+/* Performance monitoring registers */
+#define PERF_MON_CTRL_REG	regptr(MSP_SLP_BASE + 0x140)
+					/* Performance monitor control  */
+#define PERF_MON_CLR_REG	regptr(MSP_SLP_BASE + 0x144)
+					/* Performance monitor clear    */
+#define PERF_MON_CNTH_REG	regptr(MSP_SLP_BASE + 0x148)
+					/* Perf monitor counter high    */
+#define PERF_MON_CNTL_REG	regptr(MSP_SLP_BASE + 0x14C)
+					/* Perf monitor counter low     */
+
+/* System control registers */
+#define SYS_CTRL_REG		regptr(MSP_SLP_BASE + 0x150)
+					/* System control register      */
+#define SYS_ERR1_REG		regptr(MSP_SLP_BASE + 0x154)
+					/* System Error status 1        */
+#define SYS_ERR2_REG		regptr(MSP_SLP_BASE + 0x158)
+					/* System Error status 2        */
+#define SYS_INT_CFG_REG		regptr(MSP_SLP_BASE + 0x15C)
+					/* System Interrupt config      */
+
+/* Voice Engine Memory configuration */
+#define VE_MEM_REG		regptr(MSP_SLP_BASE + 0x17C)
+					/* Voice engine memory config   */
+
+/* CPU/SLP Error Status registers */
+#define CPU_ERR1_REG		regptr(MSP_SLP_BASE + 0x180)
+					/* CPU/SLP Error status 1       */
+#define CPU_ERR2_REG		regptr(MSP_SLP_BASE + 0x184)
+					/* CPU/SLP Error status 1       */
+
+/* Extended GPIO registers       */
+#define EXTENDED_GPIO1_REG	regptr(MSP_SLP_BASE + 0x188)
+#define EXTENDED_GPIO2_REG	regptr(MSP_SLP_BASE + 0x18c)
+#define EXTENDED_GPIO_REG	EXTENDED_GPIO1_REG
+					/* Backward-compatibility	*/
+
+/* System Error registers */
+#define SLP_ERR_STS_REG		regptr(MSP_SLP_BASE + 0x190)
+					/* Int status for SLP errors    */
+#define SLP_ERR_MSK_REG		regptr(MSP_SLP_BASE + 0x194)
+					/* Int mask for SLP errors      */
+#define SLP_ELB_ERST_REG	regptr(MSP_SLP_BASE + 0x198)
+					/* External ELB reset           */
+#define SLP_BOOT_STS_REG	regptr(MSP_SLP_BASE + 0x19C)
+					/* Boot Status                  */
+
+/* Extended ELB addressing */
+#define CS0_EXT_ADDR_REG	regptr(MSP_SLP_BASE + 0x1A0)
+					/* CS0 Extended address         */
+#define CS1_EXT_ADDR_REG	regptr(MSP_SLP_BASE + 0x1A4)
+					/* CS1 Extended address         */
+#define CS2_EXT_ADDR_REG	regptr(MSP_SLP_BASE + 0x1A8)
+					/* CS2 Extended address         */
+#define CS3_EXT_ADDR_REG	regptr(MSP_SLP_BASE + 0x1AC)
+					/* CS3 Extended address         */
+/* reserved					      0x1B0             */
+#define CS5_EXT_ADDR_REG	regptr(MSP_SLP_BASE + 0x1B4)
+					/* CS5 Extended address         */
+
+/* PLL Adjustment registers */
+#define PLL_LOCK_REG		regptr(MSP_SLP_BASE + 0x200)
+					/* PLL0 lock status             */
+#define PLL_ARST_REG		regptr(MSP_SLP_BASE + 0x204)
+					/* PLL Analog reset status      */
+#define PLL0_ADJ_REG		regptr(MSP_SLP_BASE + 0x208)
+					/* PLL0 Adjustment value        */
+#define PLL1_ADJ_REG		regptr(MSP_SLP_BASE + 0x20C)
+					/* PLL1 Adjustment value        */
+
+/*
+ ***************************************************************************
+ * Peripheral Register definitions                                         *
+ ***************************************************************************
+ */
+
+/* Peripheral status */
+#define PER_CTRL_REG		regptr(MSP_PER_BASE + 0x50)
+					/* Peripheral control register  */
+#define PER_STS_REG		regptr(MSP_PER_BASE + 0x54)
+					/* Peripheral status register   */
+
+/* SPI/MPI Registers */
+#define SMPI_TX_SZ_REG		regptr(MSP_PER_BASE + 0x58)
+					/* SPI/MPI Tx Size register     */
+#define SMPI_RX_SZ_REG		regptr(MSP_PER_BASE + 0x5C)
+					/* SPI/MPI Rx Size register     */
+#define SMPI_CTL_REG		regptr(MSP_PER_BASE + 0x60)
+					/* SPI/MPI Control register     */
+#define SMPI_MS_REG		regptr(MSP_PER_BASE + 0x64)
+					/* SPI/MPI Chip Select reg      */
+#define SMPI_CORE_DATA_REG	regptr(MSP_PER_BASE + 0xC0)
+					/* SPI/MPI Core Data reg        */
+#define SMPI_CORE_CTRL_REG	regptr(MSP_PER_BASE + 0xC4)
+					/* SPI/MPI Core Control reg     */
+#define SMPI_CORE_STAT_REG	regptr(MSP_PER_BASE + 0xC8)
+					/* SPI/MPI Core Status reg      */
+#define SMPI_CORE_SSEL_REG	regptr(MSP_PER_BASE + 0xCC)
+					/* SPI/MPI Core Ssel reg        */
+#define SMPI_FIFO_REG		regptr(MSP_PER_BASE + 0xD0)
+					/* SPI/MPI Data FIFO reg        */
+
+/* Peripheral Block Error Registers           */
+#define PER_ERR_STS_REG		regptr(MSP_PER_BASE + 0x70)
+					/* Error Bit Status Register    */
+#define PER_ERR_MSK_REG		regptr(MSP_PER_BASE + 0x74)
+					/* Error Bit Mask Register      */
+#define PER_HDR1_REG		regptr(MSP_PER_BASE + 0x78)
+					/* Error Header 1 Register      */
+#define PER_HDR2_REG		regptr(MSP_PER_BASE + 0x7C)
+					/* Error Header 2 Register      */
+
+/* Peripheral Block Interrupt Registers       */
+#define PER_INT_STS_REG		regptr(MSP_PER_BASE + 0x80)
+					/* Interrupt status register    */
+#define PER_INT_MSK_REG		regptr(MSP_PER_BASE + 0x84)
+					/* Interrupt Mask Register      */
+#define GPIO_INT_STS_REG	regptr(MSP_PER_BASE + 0x88)
+					/* GPIO interrupt status reg    */
+#define GPIO_INT_MSK_REG	regptr(MSP_PER_BASE + 0x8C)
+					/* GPIO interrupt MASK Reg      */
+
+/* POLO GPIO registers                        */
+#define POLO_GPIO_DAT1_REG	regptr(MSP_PER_BASE + 0x0E0)
+					/* Polo GPIO[8:0]  data reg     */
+#define POLO_GPIO_CFG1_REG	regptr(MSP_PER_BASE + 0x0E4)
+					/* Polo GPIO[7:0]  config reg   */
+#define POLO_GPIO_CFG2_REG	regptr(MSP_PER_BASE + 0x0E8)
+					/* Polo GPIO[15:8] config reg   */
+#define POLO_GPIO_OD1_REG	regptr(MSP_PER_BASE + 0x0EC)
+					/* Polo GPIO[31:0] output drive */
+#define POLO_GPIO_CFG3_REG	regptr(MSP_PER_BASE + 0x170)
+					/* Polo GPIO[23:16] config reg  */
+#define POLO_GPIO_DAT2_REG	regptr(MSP_PER_BASE + 0x174)
+					/* Polo GPIO[15:9]  data reg    */
+#define POLO_GPIO_DAT3_REG	regptr(MSP_PER_BASE + 0x178)
+					/* Polo GPIO[23:16]  data reg   */
+#define POLO_GPIO_DAT4_REG	regptr(MSP_PER_BASE + 0x17C)
+					/* Polo GPIO[31:24]  data reg   */
+#define POLO_GPIO_DAT5_REG	regptr(MSP_PER_BASE + 0x180)
+					/* Polo GPIO[39:32]  data reg   */
+#define POLO_GPIO_DAT6_REG	regptr(MSP_PER_BASE + 0x184)
+					/* Polo GPIO[47:40]  data reg   */
+#define POLO_GPIO_DAT7_REG	regptr(MSP_PER_BASE + 0x188)
+					/* Polo GPIO[54:48]  data reg   */
+#define POLO_GPIO_CFG4_REG	regptr(MSP_PER_BASE + 0x18C)
+					/* Polo GPIO[31:24] config reg  */
+#define POLO_GPIO_CFG5_REG	regptr(MSP_PER_BASE + 0x190)
+					/* Polo GPIO[39:32] config reg  */
+#define POLO_GPIO_CFG6_REG	regptr(MSP_PER_BASE + 0x194)
+					/* Polo GPIO[47:40] config reg  */
+#define POLO_GPIO_CFG7_REG	regptr(MSP_PER_BASE + 0x198)
+					/* Polo GPIO[54:48] config reg  */
+#define POLO_GPIO_OD2_REG	regptr(MSP_PER_BASE + 0x19C)
+					/* Polo GPIO[54:32] output drive */
+
+/* Generic GPIO registers                     */
+#define GPIO_DATA1_REG		regptr(MSP_PER_BASE + 0x170)
+					/* GPIO[1:0] data register      */
+#define GPIO_DATA2_REG		regptr(MSP_PER_BASE + 0x174)
+					/* GPIO[5:2] data register      */
+#define GPIO_DATA3_REG		regptr(MSP_PER_BASE + 0x178)
+					/* GPIO[9:6] data register      */
+#define GPIO_DATA4_REG		regptr(MSP_PER_BASE + 0x17C)
+					/* GPIO[15:10] data register    */
+#define GPIO_CFG1_REG		regptr(MSP_PER_BASE + 0x180)
+					/* GPIO[1:0] config register    */
+#define GPIO_CFG2_REG		regptr(MSP_PER_BASE + 0x184)
+					/* GPIO[5:2] config register    */
+#define GPIO_CFG3_REG		regptr(MSP_PER_BASE + 0x188)
+					/* GPIO[9:6] config register    */
+#define GPIO_CFG4_REG		regptr(MSP_PER_BASE + 0x18C)
+					/* GPIO[15:10] config register  */
+#define GPIO_OD_REG		regptr(MSP_PER_BASE + 0x190)
+					/* GPIO[15:0] output drive      */
+
+/*
+ ***************************************************************************
+ * CPU Interface register definitions                                      *
+ ***************************************************************************
+ */
+#define PCI_FLUSH_REG		regptr(MSP_CPUIF_BASE + 0x00)
+					/* PCI-SDRAM queue flush trigger */
+#define OCP_ERR1_REG		regptr(MSP_CPUIF_BASE + 0x04)
+					/* OCP Error Attribute 1        */
+#define OCP_ERR2_REG		regptr(MSP_CPUIF_BASE + 0x08)
+					/* OCP Error Attribute 2        */
+#define OCP_STS_REG		regptr(MSP_CPUIF_BASE + 0x0C)
+					/* OCP Error Status             */
+#define CPUIF_PM_REG		regptr(MSP_CPUIF_BASE + 0x10)
+					/* CPU policy configuration     */
+#define CPUIF_CFG_REG		regptr(MSP_CPUIF_BASE + 0x10)
+					/* Misc configuration options   */
+
+/* Central Interrupt Controller Registers */
+#define MSP_CIC_BASE		(MSP_CPUIF_BASE + 0x8000)
+					/* Central Interrupt registers  */
+#define CIC_EXT_CFG_REG		regptr(MSP_CIC_BASE + 0x00)
+					/* External interrupt config    */
+#define CIC_STS_REG		regptr(MSP_CIC_BASE + 0x04)
+					/* CIC Interrupt Status         */
+#define CIC_VPE0_MSK_REG	regptr(MSP_CIC_BASE + 0x08)
+					/* VPE0 Interrupt Mask          */
+#define CIC_VPE1_MSK_REG	regptr(MSP_CIC_BASE + 0x0C)
+					/* VPE1 Interrupt Mask          */
+#define CIC_TC0_MSK_REG		regptr(MSP_CIC_BASE + 0x10)
+					/* Thread Context 0 Int Mask    */
+#define CIC_TC1_MSK_REG		regptr(MSP_CIC_BASE + 0x14)
+					/* Thread Context 1 Int Mask    */
+#define CIC_TC2_MSK_REG		regptr(MSP_CIC_BASE + 0x18)
+					/* Thread Context 2 Int Mask    */
+#define CIC_TC3_MSK_REG		regptr(MSP_CIC_BASE + 0x18)
+					/* Thread Context 3 Int Mask    */
+#define CIC_TC4_MSK_REG		regptr(MSP_CIC_BASE + 0x18)
+					/* Thread Context 4 Int Mask    */
+#define CIC_PCIMSI_STS_REG	regptr(MSP_CIC_BASE + 0x18)
+#define CIC_PCIMSI_MSK_REG	regptr(MSP_CIC_BASE + 0x18)
+#define CIC_PCIFLSH_REG		regptr(MSP_CIC_BASE + 0x18)
+#define CIC_VPE0_SWINT_REG	regptr(MSP_CIC_BASE + 0x08)
+
+
+/*
+ ***************************************************************************
+ * Memory controller registers                                             *
+ ***************************************************************************
+ */
+#define MEM_CFG1_REG		regptr(MSP_MEM_CFG_BASE + 0x00)
+#define MEM_SS_ADDR		regptr(MSP_MEM_CFG_BASE + 0x00)
+#define MEM_SS_DATA		regptr(MSP_MEM_CFG_BASE + 0x04)
+#define MEM_SS_WRITE		regptr(MSP_MEM_CFG_BASE + 0x08)
+
+/*
+ ***************************************************************************
+ * PCI controller registers                                                *
+ ***************************************************************************
+ */
+#define PCI_BASE_REG		regptr(MSP_PCI_BASE + 0x00)
+#define PCI_CONFIG_SPACE_REG	regptr(MSP_PCI_BASE + 0x800)
+#define PCI_JTAG_DEVID_REG	regptr(MSP_SLP_BASE + 0x13c)
+
+/*
+ ########################################################################
+ #  Register content & macro definitions                                #
+ ########################################################################
+ */
+
+/*
+ ***************************************************************************
+ * DEV_ID defines                                                          *
+ ***************************************************************************
+ */
+#define DEV_ID_PCI_DIS		(1 << 26)       /* Set if PCI disabled */
+#define DEV_ID_PCI_HOST		(1 << 20)       /* Set if PCI host */
+#define DEV_ID_SINGLE_PC	(1 << 19)       /* Set if single PC Card */
+#define DEV_ID_FAMILY		(0xff << 8)     /* family ID code */
+#define POLO_ZEUS_SUB_FAMILY	(0x7  << 16)    /* sub family for Polo/Zeus */
+
+#define MSPFPGA_ID		(0x00  << 8)    /* you are on your own here */
+#define MSP5000_ID		(0x50  << 8)
+#define MSP4F00_ID		(0x4f  << 8)    /* FPGA version of MSP4200 */
+#define MSP4E00_ID		(0x4f  << 8)    /* FPGA version of MSP7120 */
+#define MSP4200_ID		(0x42  << 8)
+#define MSP4000_ID		(0x40  << 8)
+#define MSP2XXX_ID		(0x20  << 8)
+#define MSPZEUS_ID		(0x10  << 8)
+
+#define MSP2004_SUB_ID		(0x0   << 16)
+#define MSP2005_SUB_ID		(0x1   << 16)
+#define MSP2006_SUB_ID		(0x1   << 16)
+#define MSP2007_SUB_ID		(0x2   << 16)
+#define MSP2010_SUB_ID		(0x3   << 16)
+#define MSP2015_SUB_ID		(0x4   << 16)
+#define MSP2020_SUB_ID		(0x5   << 16)
+#define MSP2100_SUB_ID		(0x6   << 16)
+
+/*
+ ***************************************************************************
+ * RESET defines                                                           *
+ ***************************************************************************
+ */
+#define MSP_GR_RST		(0x01 << 0)     /* Global reset bit     */
+#define MSP_MR_RST		(0x01 << 1)     /* MIPS reset bit       */
+#define MSP_PD_RST		(0x01 << 2)     /* PVC DMA reset bit    */
+#define MSP_PP_RST		(0x01 << 3)     /* PVC reset bit        */
+/* reserved                                                             */
+#define MSP_EA_RST		(0x01 << 6)     /* Mac A reset bit      */
+#define MSP_EB_RST		(0x01 << 7)     /* Mac B reset bit      */
+#define MSP_SE_RST		(0x01 << 8)     /* Security Eng reset bit */
+#define MSP_PB_RST		(0x01 << 9)     /* Per block reset bit  */
+#define MSP_EC_RST		(0x01 << 10)    /* Mac C reset bit      */
+#define MSP_TW_RST		(0x01 << 11)    /* TWI reset bit        */
+#define MSP_SPI_RST		(0x01 << 12)    /* SPI/MPI reset bit    */
+#define MSP_U1_RST		(0x01 << 13)    /* UART1 reset bit      */
+#define MSP_U0_RST		(0x01 << 14)    /* UART0 reset bit      */
+
+/*
+ ***************************************************************************
+ * UART defines                                                            *
+ ***************************************************************************
+ */
+#define MSP_BASE_BAUD		25000000
+#define MSP_UART_REG_LEN	0x20
+
+/*
+ ***************************************************************************
+ * ELB defines                                                             *
+ ***************************************************************************
+ */
+#define PCCARD_32		0x02    /* Set if is PCCARD 32 (Cardbus) */
+#define SINGLE_PCCARD		0x01    /* Set to enable single PC card */
+
+/*
+ ***************************************************************************
+ * CIC defines                                                             *
+ ***************************************************************************
+ */
+
+/* CIC_EXT_CFG_REG */
+#define EXT_INT_POL(eirq)			(1 << (eirq + 8))
+#define EXT_INT_EDGE(eirq)			(1 << eirq)
+
+#define CIC_EXT_SET_TRIGGER_LEVEL(reg, eirq)	(reg &= ~EXT_INT_EDGE(eirq))
+#define CIC_EXT_SET_TRIGGER_EDGE(reg, eirq)	(reg |= EXT_INT_EDGE(eirq))
+#define CIC_EXT_SET_ACTIVE_HI(reg, eirq)	(reg |= EXT_INT_POL(eirq))
+#define CIC_EXT_SET_ACTIVE_LO(reg, eirq)	(reg &= ~EXT_INT_POL(eirq))
+#define CIC_EXT_SET_ACTIVE_RISING		CIC_EXT_SET_ACTIVE_HI
+#define CIC_EXT_SET_ACTIVE_FALLING		CIC_EXT_SET_ACTIVE_LO
+
+#define CIC_EXT_IS_TRIGGER_LEVEL(reg, eirq) \
+				((reg & EXT_INT_EDGE(eirq)) == 0)
+#define CIC_EXT_IS_TRIGGER_EDGE(reg, eirq)	(reg & EXT_INT_EDGE(eirq))
+#define CIC_EXT_IS_ACTIVE_HI(reg, eirq)		(reg & EXT_INT_POL(eirq))
+#define CIC_EXT_IS_ACTIVE_LO(reg, eirq) \
+				((reg & EXT_INT_POL(eirq)) == 0)
+#define CIC_EXT_IS_ACTIVE_RISING		CIC_EXT_IS_ACTIVE_HI
+#define CIC_EXT_IS_ACTIVE_FALLING		CIC_EXT_IS_ACTIVE_LO
+
+/*
+ ***************************************************************************
+ * Memory Controller defines                                               *
+ ***************************************************************************
+ */
+
+/* Indirect memory controller registers */
+#define DDRC_CFG(n)		(n)
+#define DDRC_DEBUG(n)		(0x04 + n)
+#define DDRC_CTL(n)		(0x40 + n)
+
+/* Macro to perform DDRC indirect write */
+#define DDRC_INDIRECT_WRITE(reg, mask, value) \
+({ \
+	*MEM_SS_ADDR = (((mask) & 0xf) << 8) | ((reg) & 0xff); \
+	*MEM_SS_DATA = (value); \
+	*MEM_SS_WRITE = 1; \
+})
+
+/*
+ ***************************************************************************
+ * SPI/MPI Mode                                                            *
+ ***************************************************************************
+ */
+#define SPI_MPI_RX_BUSY		0x00008000	/* SPI/MPI Receive Busy */
+#define SPI_MPI_FIFO_EMPTY	0x00004000	/* SPI/MPI Fifo Empty   */
+#define SPI_MPI_TX_BUSY		0x00002000	/* SPI/MPI Transmit Busy */
+#define SPI_MPI_FIFO_FULL	0x00001000	/* SPI/MPU FIFO full    */
+
+/*
+ ***************************************************************************
+ * SPI/MPI Control Register                                                *
+ ***************************************************************************
+ */
+#define SPI_MPI_RX_START	0x00000004	/* Start receive command */
+#define SPI_MPI_FLUSH_Q		0x00000002	/* Flush SPI/MPI Queue */
+#define SPI_MPI_TX_START	0x00000001	/* Start Transmit Command */
+
+#endif /* !_ASM_MSP_REGS_H */
diff --git a/arch/mips/include/asm/mach-pmcs-msp71xx/msp_slp_int.h b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_slp_int.h
new file mode 100644
index 0000000..96d4c8c
--- /dev/null
+++ b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_slp_int.h
@@ -0,0 +1,141 @@
+/*
+ * Defines for the MSP interrupt controller.
+ *
+ * Copyright (C) 1999 MIPS Technologies, Inc.  All rights reserved.
+ * Author: Carsten Langgaard, carstenl@mips.com
+ *
+ * ########################################################################
+ *
+ *  This program is free software; you can distribute it and/or modify it
+ *  under the terms of the GNU General Public License (Version 2) as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope it will be useful, but WITHOUT
+ *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ *  for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
+ *
+ * ########################################################################
+ */
+
+#ifndef _MSP_SLP_INT_H
+#define _MSP_SLP_INT_H
+
+/*
+ * The PMC-Sierra SLP interrupts are arranged in a 3 level cascaded
+ * hierarchical system.  The first level are the direct MIPS interrupts
+ * and are assigned the interrupt range 0-7.  The second level is the SLM
+ * interrupt controller and is assigned the range 8-39.  The third level
+ * comprises the Peripherial block, the PCI block, the PCI MSI block and
+ * the SLP.  The PCI interrupts and the SLP errors are handled by the
+ * relevant subsystems so the core interrupt code needs only concern
+ * itself with the Peripheral block.  These are assigned interrupts in
+ * the range 40-71.
+ */
+
+/*
+ * IRQs directly connected to CPU
+ */
+#define MSP_MIPS_INTBASE	0
+#define MSP_INT_SW0		0  /* IRQ for swint0,         C_SW0  */
+#define MSP_INT_SW1		1  /* IRQ for swint1,         C_SW1  */
+#define MSP_INT_MAC0 		2  /* IRQ for MAC 0,          C_IRQ0 */
+#define MSP_INT_MAC1		3  /* IRQ for MAC 1,          C_IRQ1 */
+#define MSP_INT_C_IRQ2		4  /* Wired off,              C_IRQ2 */
+#define MSP_INT_VE		5  /* IRQ for Voice Engine,   C_IRQ3 */
+#define MSP_INT_SLP		6  /* IRQ for SLM block,      C_IRQ4 */
+#define MSP_INT_TIMER		7  /* IRQ for the MIPS timer, C_IRQ5 */
+
+/*
+ * IRQs cascaded on CPU interrupt 4 (CAUSE bit 12, C_IRQ4)
+ * These defines should be tied to the register definition for the SLM
+ * interrupt routine.  For now, just use hard-coded values.
+ */
+#define MSP_SLP_INTBASE		(MSP_MIPS_INTBASE + 8)
+#define MSP_INT_EXT0		(MSP_SLP_INTBASE + 0)
+					/* External interrupt 0         */
+#define MSP_INT_EXT1		(MSP_SLP_INTBASE + 1)
+					/* External interrupt 1         */
+#define MSP_INT_EXT2		(MSP_SLP_INTBASE + 2)
+					/* External interrupt 2         */
+#define MSP_INT_EXT3		(MSP_SLP_INTBASE + 3)
+					/* External interrupt 3         */
+/* Reserved					   4-7                  */
+
+/*
+ *************************************************************************
+ * DANGER/DANGER/DANGER/DANGER/DANGER/DANGER/DANGER/DANGER/DANGER/DANGER *
+ * Some MSP produces have this interrupt labelled as Voice and some are  *
+ * SEC mbox ...                                                          *
+ *************************************************************************
+ */
+#define MSP_INT_SLP_VE		(MSP_SLP_INTBASE + 8)
+					/* Cascaded IRQ for Voice Engine*/
+#define MSP_INT_SLP_TDM		(MSP_SLP_INTBASE + 9)
+					/* TDM interrupt                */
+#define MSP_INT_SLP_MAC0	(MSP_SLP_INTBASE + 10)
+					/* Cascaded IRQ for MAC 0       */
+#define MSP_INT_SLP_MAC1	(MSP_SLP_INTBASE + 11)
+					/* Cascaded IRQ for MAC 1       */
+#define MSP_INT_SEC		(MSP_SLP_INTBASE + 12)
+					/* IRQ for security engine      */
+#define	MSP_INT_PER		(MSP_SLP_INTBASE + 13)
+					/* Peripheral interrupt         */
+#define	MSP_INT_TIMER0		(MSP_SLP_INTBASE + 14)
+					/* SLP timer 0                  */
+#define	MSP_INT_TIMER1		(MSP_SLP_INTBASE + 15)
+					/* SLP timer 1                  */
+#define	MSP_INT_TIMER2		(MSP_SLP_INTBASE + 16)
+					/* SLP timer 2                  */
+#define	MSP_INT_SLP_TIMER	(MSP_SLP_INTBASE + 17)
+					/* Cascaded MIPS timer          */
+#define MSP_INT_BLKCP		(MSP_SLP_INTBASE + 18)
+					/* Block Copy                   */
+#define MSP_INT_UART0		(MSP_SLP_INTBASE + 19)
+					/* UART 0                       */
+#define MSP_INT_PCI		(MSP_SLP_INTBASE + 20)
+					/* PCI subsystem                */
+#define MSP_INT_PCI_DBELL	(MSP_SLP_INTBASE + 21)
+					/* PCI doorbell                 */
+#define MSP_INT_PCI_MSI		(MSP_SLP_INTBASE + 22)
+					/* PCI Message Signal           */
+#define MSP_INT_PCI_BC0		(MSP_SLP_INTBASE + 23)
+					/* PCI Block Copy 0             */
+#define MSP_INT_PCI_BC1		(MSP_SLP_INTBASE + 24)
+					/* PCI Block Copy 1             */
+#define MSP_INT_SLP_ERR		(MSP_SLP_INTBASE + 25)
+					/* SLP error condition          */
+#define MSP_INT_MAC2		(MSP_SLP_INTBASE + 26)
+					/* IRQ for MAC2                 */
+/* Reserved					   26-31                */
+
+/*
+ * IRQs cascaded on SLP PER interrupt (MSP_INT_PER)
+ */
+#define MSP_PER_INTBASE		(MSP_SLP_INTBASE + 32)
+/* Reserved					   0-1                  */
+#define MSP_INT_UART1		(MSP_PER_INTBASE + 2)
+					/* UART 1                       */
+/* Reserved					   3-5                  */
+#define MSP_INT_2WIRE		(MSP_PER_INTBASE + 6)
+					/* 2-wire                       */
+#define MSP_INT_TM0		(MSP_PER_INTBASE + 7)
+					/* Peripheral timer block out 0 */
+#define MSP_INT_TM1		(MSP_PER_INTBASE + 8)
+					/* Peripheral timer block out 1 */
+/* Reserved					   9                    */
+#define MSP_INT_SPRX		(MSP_PER_INTBASE + 10)
+					/* SPI RX complete              */
+#define MSP_INT_SPTX		(MSP_PER_INTBASE + 11)
+					/* SPI TX complete              */
+#define MSP_INT_GPIO		(MSP_PER_INTBASE + 12)
+					/* GPIO                         */
+#define MSP_INT_PER_ERR		(MSP_PER_INTBASE + 13)
+					/* Peripheral error             */
+/* Reserved					   14-31                */
+
+#endif /* !_MSP_SLP_INT_H */
diff --git a/arch/mips/include/asm/mach-pmcs-msp71xx/msp_usb.h b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_usb.h
new file mode 100644
index 0000000..4c9348d
--- /dev/null
+++ b/arch/mips/include/asm/mach-pmcs-msp71xx/msp_usb.h
@@ -0,0 +1,144 @@
+/******************************************************************
+ * Copyright (c) 2000-2007 PMC-Sierra INC.
+ *
+ *     This program is free software; you can redistribute it
+ *     and/or modify it under the terms of the GNU General
+ *     Public License as published by the Free Software
+ *     Foundation; either version 2 of the License, or (at your
+ *     option) any later version.
+ *
+ *     This program is distributed in the hope that it will be
+ *     useful, but WITHOUT ANY WARRANTY; without even the implied
+ *     warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
+ *     PURPOSE.  See the GNU General Public License for more
+ *     details.
+ *
+ *     You should have received a copy of the GNU General Public
+ *     License along with this program; if not, write to the Free
+ *     Software Foundation, Inc., 675 Mass Ave, Cambridge, MA
+ *     02139, USA.
+ *
+ * PMC-SIERRA INC. DISCLAIMS ANY LIABILITY OF ANY KIND
+ * FOR ANY DAMAGES WHATSOEVER RESULTING FROM THE USE OF THIS
+ * SOFTWARE.
+ */
+#ifndef MSP_USB_H_
+#define MSP_USB_H_
+
+#ifdef CONFIG_MSP_HAS_DUAL_USB
+#define NUM_USB_DEVS   2
+#else
+#define NUM_USB_DEVS   1
+#endif
+
+/* Register spaces for USB host 0 */
+#define MSP_USB0_MAB_START	(MSP_USB0_BASE + 0x0)
+#define MSP_USB0_MAB_END	(MSP_USB0_BASE + 0x17)
+#define MSP_USB0_ID_START	(MSP_USB0_BASE + 0x40000)
+#define MSP_USB0_ID_END		(MSP_USB0_BASE + 0x4008f)
+#define MSP_USB0_HS_START	(MSP_USB0_BASE + 0x40100)
+#define MSP_USB0_HS_END		(MSP_USB0_BASE + 0x401FF)
+
+/* Register spaces for USB host 1 */
+#define	MSP_USB1_MAB_START	(MSP_USB1_BASE + 0x0)
+#define MSP_USB1_MAB_END	(MSP_USB1_BASE + 0x17)
+#define MSP_USB1_ID_START	(MSP_USB1_BASE + 0x40000)
+#define MSP_USB1_ID_END		(MSP_USB1_BASE + 0x4008f)
+#define MSP_USB1_HS_START	(MSP_USB1_BASE + 0x40100)
+#define MSP_USB1_HS_END		(MSP_USB1_BASE + 0x401ff)
+
+/* USB Identification registers */
+struct msp_usbid_regs {
+	u32 id;		/* 0x0: Identification register */
+	u32 hwgen;	/* 0x4: General HW params */
+	u32 hwhost;	/* 0x8: Host HW params */
+	u32 hwdev;	/* 0xc: Device HW params */
+	u32 hwtxbuf;	/* 0x10: Tx buffer HW params */
+	u32 hwrxbuf;	/* 0x14: Rx buffer HW params */
+	u32 reserved[26];
+	u32 timer0_load; /* 0x80: General-purpose timer 0 load*/
+	u32 timer0_ctrl; /* 0x84: General-purpose timer 0 control */
+	u32 timer1_load; /* 0x88: General-purpose timer 1 load*/
+	u32 timer1_ctrl; /* 0x8c: General-purpose timer 1 control */
+};
+
+/* MSBus to AMBA registers */
+struct msp_mab_regs {
+	u32 isr;	/* 0x0: Interrupt status */
+	u32 imr;	/* 0x4: Interrupt mask */
+	u32 thcr0;	/* 0x8: Transaction header capture 0 */
+	u32 thcr1;	/* 0xc: Transaction header capture 1 */
+	u32 int_stat;	/* 0x10: Interrupt status summary */
+	u32 phy_cfg;	/* 0x14: USB phy config */
+};
+
+/* EHCI registers */
+struct msp_usbhs_regs {
+	u32 hciver;	/* 0x0: Version and offset to operational regs */
+	u32 hcsparams;	/* 0x4: Host control structural parameters */
+	u32 hccparams;	/* 0x8: Host control capability parameters */
+	u32 reserved0[5];
+	u32 dciver;	/* 0x20: Device interface version */
+	u32 dccparams;	/* 0x24: Device control capability parameters */
+	u32 reserved1[6];
+	u32 cmd;	/* 0x40: USB command */
+	u32 sts;	/* 0x44: USB status */
+	u32 int_ena;	/* 0x48: USB interrupt enable */
+	u32 frindex;	/* 0x4c: Frame index */
+	u32 reserved3;
+	union {
+		struct {
+			u32 flb_addr; /* 0x54: Frame list base address */
+			u32 next_async_addr; /* 0x58: next asynchronous addr */
+			u32 ttctrl; /* 0x5c: embedded transaction translator
+							async buffer status */
+			u32 burst_size; /* 0x60: Controller burst size */
+			u32 tx_fifo_ctrl; /* 0x64: Tx latency FIFO tuning */
+			u32 reserved0[4];
+			u32 endpt_nak; /* 0x78: Endpoint NAK */
+			u32 endpt_nak_ena; /* 0x7c: Endpoint NAK enable */
+			u32 cfg_flag; /* 0x80: Config flag */
+			u32 port_sc1; /* 0x84: Port status & control 1 */
+			u32 reserved1[7];
+			u32 otgsc;	/* 0xa4: OTG status & control */
+			u32 mode;	/* 0xa8: USB controller mode */
+		} host;
+
+		struct {
+			u32 dev_addr; /* 0x54: Device address */
+			u32 endpt_list_addr; /* 0x58: Endpoint list address */
+			u32 reserved0[7];
+			u32 endpt_nak;	/* 0x74 */
+			u32 endpt_nak_ctrl; /* 0x78 */
+			u32 cfg_flag; /* 0x80 */
+			u32 port_sc1; /* 0x84: Port status & control 1 */
+			u32 reserved[7];
+			u32 otgsc;	/* 0xa4: OTG status & control */
+			u32 mode;	/* 0xa8: USB controller mode */
+			u32 endpt_setup_stat; /* 0xac */
+			u32 endpt_prime; /* 0xb0 */
+			u32 endpt_flush; /* 0xb4 */
+			u32 endpt_stat; /* 0xb8 */
+			u32 endpt_complete; /* 0xbc */
+			u32 endpt_ctrl0; /* 0xc0 */
+			u32 endpt_ctrl1; /* 0xc4 */
+			u32 endpt_ctrl2; /* 0xc8 */
+			u32 endpt_ctrl3; /* 0xcc */
+		} device;
+	} u;
+};
+/*
+ * Container for the more-generic platform_device.
+ * This exists mainly as a way to map the non-standard register
+ * spaces and make them accessible to the USB ISR.
+ */
+struct mspusb_device {
+	struct msp_mab_regs   __iomem *mab_regs;
+	struct msp_usbid_regs __iomem *usbid_regs;
+	struct msp_usbhs_regs __iomem *usbhs_regs;
+	struct platform_device dev;
+};
+
+#define to_mspusb_device(x) container_of((x), struct mspusb_device, dev)
+#define TO_HOST_ID(x) ((x) & 0x3)
+#endif /*MSP_USB_H_*/
diff --git a/arch/mips/include/asm/mach-pmcs-msp71xx/war.h b/arch/mips/include/asm/mach-pmcs-msp71xx/war.h
new file mode 100644
index 0000000..c74eb16
--- /dev/null
+++ b/arch/mips/include/asm/mach-pmcs-msp71xx/war.h
@@ -0,0 +1,29 @@
+/*
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License.  See the file "COPYING" in the main directory of this archive
+ * for more details.
+ *
+ * Copyright (C) 2002, 2004, 2007 by Ralf Baechle <ralf@linux-mips.org>
+ */
+#ifndef __ASM_MIPS_PMC_SIERRA_WAR_H
+#define __ASM_MIPS_PMC_SIERRA_WAR_H
+
+#define R4600_V1_INDEX_ICACHEOP_WAR	0
+#define R4600_V1_HIT_CACHEOP_WAR	0
+#define R4600_V2_HIT_CACHEOP_WAR	0
+#define R5432_CP0_INTERRUPT_WAR		0
+#define BCM1250_M3_WAR			0
+#define SIBYTE_1956_WAR			0
+#define MIPS4K_ICACHE_REFILL_WAR	0
+#define MIPS_CACHE_SYNC_WAR		0
+#define TX49XX_ICACHE_INDEX_INV_WAR	0
+#define ICACHE_REFILLS_WORKAROUND_WAR	0
+#define R10000_LLSC_WAR			0
+#if defined(CONFIG_PMC_MSP7120_EVAL) || defined(CONFIG_PMC_MSP7120_GW) || \
+	defined(CONFIG_PMC_MSP7120_FPGA)
+#define MIPS34K_MISSED_ITLB_WAR         1
+#else
+#define MIPS34K_MISSED_ITLB_WAR         0
+#endif
+
+#endif /* __ASM_MIPS_PMC_SIERRA_WAR_H */
diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/cpu-feature-overrides.h b/arch/mips/include/asm/pmc-sierra/msp71xx/cpu-feature-overrides.h
deleted file mode 100644
index 016fa94..0000000
--- a/arch/mips/include/asm/pmc-sierra/msp71xx/cpu-feature-overrides.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2003, 04, 07 Ralf Baechle (ralf@linux-mips.org)
- */
-#ifndef __ASM_MACH_MSP71XX_CPU_FEATURE_OVERRIDES_H
-#define __ASM_MACH_MSP71XX_CPU_FEATURE_OVERRIDES_H
-
-#define cpu_has_mips16		1
-#define cpu_has_dsp		1
-/* #define cpu_has_dsp2		??? - do runtime detection */
-#define cpu_has_mipsmt		1
-#define cpu_has_fpu		0
-
-#define cpu_has_mips32r1	0
-#define cpu_has_mips32r2	1
-#define cpu_has_mips64r1	0
-#define cpu_has_mips64r2	0
-
-#endif /* __ASM_MACH_MSP71XX_CPU_FEATURE_OVERRIDES_H */
diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/gpio.h b/arch/mips/include/asm/pmc-sierra/msp71xx/gpio.h
deleted file mode 100644
index ebdbab9..0000000
--- a/arch/mips/include/asm/pmc-sierra/msp71xx/gpio.h
+++ /dev/null
@@ -1,46 +0,0 @@
-/*
- * include/asm-mips/pmc-sierra/msp71xx/gpio.h
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * @author Patrick Glass <patrickglass@gmail.com>
- */
-
-#ifndef __PMC_MSP71XX_GPIO_H
-#define __PMC_MSP71XX_GPIO_H
-
-/* Max number of gpio's is 28 on chip plus 3 banks of I2C IO Expanders */
-#define ARCH_NR_GPIOS (28 + (3 * 8))
-
-/* new generic GPIO API - see Documentation/gpio.txt */
-#include <asm-generic/gpio.h>
-
-#define gpio_get_value	__gpio_get_value
-#define gpio_set_value	__gpio_set_value
-#define gpio_cansleep	__gpio_cansleep
-
-/* Setup calls for the gpio and gpio extended */
-extern void msp71xx_init_gpio(void);
-extern void msp71xx_init_gpio_extended(void);
-extern int msp71xx_set_output_drive(unsigned gpio, int value);
-
-/* Custom output drive functionss */
-static inline int gpio_set_output_drive(unsigned gpio, int value)
-{
-	return msp71xx_set_output_drive(gpio, value);
-}
-
-/* IRQ's are not supported for gpio lines */
-static inline int gpio_to_irq(unsigned gpio)
-{
-	return -EINVAL;
-}
-
-static inline int irq_to_gpio(unsigned irq)
-{
-	return -EINVAL;
-}
-
-#endif /* __PMC_MSP71XX_GPIO_H */
diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_cic_int.h b/arch/mips/include/asm/pmc-sierra/msp71xx/msp_cic_int.h
deleted file mode 100644
index c84bcf9..0000000
--- a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_cic_int.h
+++ /dev/null
@@ -1,151 +0,0 @@
-/*
- * Defines for the MSP interrupt controller.
- *
- * Copyright (C) 1999 MIPS Technologies, Inc.  All rights reserved.
- * Author: Carsten Langgaard, carstenl@mips.com
- *
- * ########################################################################
- *
- *  This program is free software; you can distribute it and/or modify it
- *  under the terms of the GNU General Public License (Version 2) as
- *  published by the Free Software Foundation.
- *
- *  This program is distributed in the hope it will be useful, but WITHOUT
- *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
- *  for more details.
- *
- *  You should have received a copy of the GNU General Public License along
- *  with this program; if not, write to the Free Software Foundation, Inc.,
- *  59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
- *
- * ########################################################################
- */
-
-#ifndef _MSP_CIC_INT_H
-#define _MSP_CIC_INT_H
-
-/*
- * The PMC-Sierra CIC interrupts are all centrally managed by the
- * CIC sub-system.
- * We attempt to keep the interrupt numbers as consistent as possible
- * across all of the MSP devices, but some differences will creep in ...
- * The interrupts which are directly forwarded to the MIPS core interrupts
- * are assigned interrupts in the range 0-7, interrupts cascaded through
- * the CIC are assigned interrupts 8-39.  The cascade occurs on C_IRQ4
- * (MSP_INT_CIC).  Currently we don't really distinguish between VPE1
- * and VPE0 (or thread contexts for that matter).  Will have to fix.
- * The PER interrupts are assigned interrupts in the range 40-71.
-*/
-
-
-/*
- * IRQs directly forwarded to the CPU
- */
-#define MSP_MIPS_INTBASE	0
-#define MSP_INT_SW0		0	/* IRQ for swint0,       C_SW0  */
-#define MSP_INT_SW1		1	/* IRQ for swint1,       C_SW1  */
-#define MSP_INT_MAC0		2	/* IRQ for MAC 0,        C_IRQ0 */
-#define MSP_INT_MAC1		3	/* IRQ for MAC 1,        C_IRQ1 */
-#define MSP_INT_USB		4	/* IRQ for USB,          C_IRQ2 */
-#define MSP_INT_SAR		5	/* IRQ for ADSL2+ SAR,   C_IRQ3 */
-#define MSP_INT_CIC		6	/* IRQ for CIC block,    C_IRQ4 */
-#define MSP_INT_SEC		7	/* IRQ for Sec engine,   C_IRQ5 */
-
-/*
- * IRQs cascaded on CPU interrupt 4 (CAUSE bit 12, C_IRQ4)
- * These defines should be tied to the register definitions for the CIC
- * interrupt routine.  For now, just use hard-coded values.
- */
-#define MSP_CIC_INTBASE		(MSP_MIPS_INTBASE + 8)
-#define MSP_INT_EXT0		(MSP_CIC_INTBASE + 0)
-					/* External interrupt 0         */
-#define MSP_INT_EXT1		(MSP_CIC_INTBASE + 1)
-					/* External interrupt 1         */
-#define MSP_INT_EXT2		(MSP_CIC_INTBASE + 2)
-					/* External interrupt 2         */
-#define MSP_INT_EXT3		(MSP_CIC_INTBASE + 3)
-					/* External interrupt 3         */
-#define MSP_INT_CPUIF		(MSP_CIC_INTBASE + 4)
-					/* CPU interface interrupt      */
-#define MSP_INT_EXT4		(MSP_CIC_INTBASE + 5)
-					/* External interrupt 4         */
-#define MSP_INT_CIC_USB		(MSP_CIC_INTBASE + 6)
-					/* Cascaded IRQ for USB         */
-#define MSP_INT_MBOX		(MSP_CIC_INTBASE + 7)
-					/* Sec engine mailbox IRQ       */
-#define MSP_INT_EXT5		(MSP_CIC_INTBASE + 8)
-					/* External interrupt 5         */
-#define MSP_INT_TDM		(MSP_CIC_INTBASE + 9)
-					/* TDM interrupt                */
-#define MSP_INT_CIC_MAC0	(MSP_CIC_INTBASE + 10)
-					/* Cascaded IRQ for MAC 0       */
-#define MSP_INT_CIC_MAC1	(MSP_CIC_INTBASE + 11)
-					/* Cascaded IRQ for MAC 1       */
-#define MSP_INT_CIC_SEC		(MSP_CIC_INTBASE + 12)
-					/* Cascaded IRQ for sec engine  */
-#define	MSP_INT_PER		(MSP_CIC_INTBASE + 13)
-					/* Peripheral interrupt         */
-#define	MSP_INT_TIMER0		(MSP_CIC_INTBASE + 14)
-					/* SLP timer 0                  */
-#define	MSP_INT_TIMER1		(MSP_CIC_INTBASE + 15)
-					/* SLP timer 1                  */
-#define	MSP_INT_TIMER2		(MSP_CIC_INTBASE + 16)
-					/* SLP timer 2                  */
-#define	MSP_INT_VPE0_TIMER	(MSP_CIC_INTBASE + 17)
-					/* VPE0 MIPS timer              */
-#define MSP_INT_BLKCP		(MSP_CIC_INTBASE + 18)
-					/* Block Copy                   */
-#define MSP_INT_UART0		(MSP_CIC_INTBASE + 19)
-					/* UART 0                       */
-#define MSP_INT_PCI		(MSP_CIC_INTBASE + 20)
-					/* PCI subsystem                */
-#define MSP_INT_EXT6		(MSP_CIC_INTBASE + 21)
-					/* External interrupt 5         */
-#define MSP_INT_PCI_MSI		(MSP_CIC_INTBASE + 22)
-					/* PCI Message Signal           */
-#define MSP_INT_CIC_SAR		(MSP_CIC_INTBASE + 23)
-					/* Cascaded ADSL2+ SAR IRQ      */
-#define MSP_INT_DSL		(MSP_CIC_INTBASE + 24)
-					/* ADSL2+ IRQ                   */
-#define MSP_INT_CIC_ERR		(MSP_CIC_INTBASE + 25)
-					/* SLP error condition          */
-#define MSP_INT_VPE1_TIMER	(MSP_CIC_INTBASE + 26)
-					/* VPE1 MIPS timer              */
-#define MSP_INT_VPE0_PC		(MSP_CIC_INTBASE + 27)
-					/* VPE0 Performance counter     */
-#define MSP_INT_VPE1_PC		(MSP_CIC_INTBASE + 28)
-					/* VPE1 Performance counter     */
-#define MSP_INT_EXT7		(MSP_CIC_INTBASE + 29)
-					/* External interrupt 5         */
-#define MSP_INT_VPE0_SW		(MSP_CIC_INTBASE + 30)
-					/* VPE0 Software interrupt      */
-#define MSP_INT_VPE1_SW		(MSP_CIC_INTBASE + 31)
-					/* VPE0 Software interrupt      */
-
-/*
- * IRQs cascaded on CIC PER interrupt (MSP_INT_PER)
- */
-#define MSP_PER_INTBASE		(MSP_CIC_INTBASE + 32)
-/* Reserved					   0-1                  */
-#define MSP_INT_UART1		(MSP_PER_INTBASE + 2)
-					/* UART 1                       */
-/* Reserved					   3-5                  */
-#define MSP_INT_2WIRE		(MSP_PER_INTBASE + 6)
-					/* 2-wire                       */
-#define MSP_INT_TM0		(MSP_PER_INTBASE + 7)
-					/* Peripheral timer block out 0 */
-#define MSP_INT_TM1		(MSP_PER_INTBASE + 8)
-					/* Peripheral timer block out 1 */
-/* Reserved					   9                    */
-#define MSP_INT_SPRX		(MSP_PER_INTBASE + 10)
-					/* SPI RX complete              */
-#define MSP_INT_SPTX		(MSP_PER_INTBASE + 11)
-					/* SPI TX complete              */
-#define MSP_INT_GPIO		(MSP_PER_INTBASE + 12)
-					/* GPIO                         */
-#define MSP_INT_PER_ERR		(MSP_PER_INTBASE + 13)
-					/* Peripheral error             */
-/* Reserved					   14-31                */
-
-#endif /* !_MSP_CIC_INT_H */
diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_gpio_macros.h b/arch/mips/include/asm/pmc-sierra/msp71xx/msp_gpio_macros.h
deleted file mode 100644
index 156f320..0000000
--- a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_gpio_macros.h
+++ /dev/null
@@ -1,343 +0,0 @@
-/*
- *
- * Macros for external SMP-safe access to the PMC MSP71xx reference
- * board GPIO pins
- *
- * Copyright 2010 PMC-Sierra, Inc.
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- *
- *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
- *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
- *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN
- *  NO  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
- *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
- *  NOT LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF
- *  USE, DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
- *  ANY THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
- *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
- *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *  You should have received a copy of the  GNU General Public License along
- *  with this program; if not, write  to the Free Software Foundation, Inc.,
- *  675 Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#ifndef __MSP_GPIO_MACROS_H__
-#define __MSP_GPIO_MACROS_H__
-
-#include <msp_regops.h>
-#include <msp_regs.h>
-
-#ifdef CONFIG_PMC_MSP7120_GW
-#define MSP_NUM_GPIOS		20
-#else
-#define MSP_NUM_GPIOS		28
-#endif
-
-/* -- GPIO Enumerations -- */
-enum msp_gpio_data {
-	MSP_GPIO_LO = 0,
-	MSP_GPIO_HI = 1,
-	MSP_GPIO_NONE,		/* Special - Means pin is out of range */
-	MSP_GPIO_TOGGLE,	/* Special - Sets pin to opposite */
-};
-
-enum msp_gpio_mode {
-	MSP_GPIO_INPUT		= 0x0,
-	/* MSP_GPIO_ INTERRUPT	= 0x1,	Not supported yet */
-	MSP_GPIO_UART_INPUT	= 0x2,	/* Only GPIO 4 or 5 */
-	MSP_GPIO_OUTPUT		= 0x8,
-	MSP_GPIO_UART_OUTPUT	= 0x9,	/* Only GPIO 2 or 3 */
-	MSP_GPIO_PERIF_TIMERA	= 0x9,	/* Only GPIO 0 or 1 */
-	MSP_GPIO_PERIF_TIMERB	= 0xa,	/* Only GPIO 0 or 1 */
-	MSP_GPIO_UNKNOWN	= 0xb,  /* No such GPIO or mode */
-};
-
-/* -- Static Tables -- */
-
-/* Maps pins to data register */
-static volatile u32 * const MSP_GPIO_DATA_REGISTER[] = {
-	/* GPIO 0 and 1 on the first register */
-	GPIO_DATA1_REG, GPIO_DATA1_REG,
-	/* GPIO 2, 3, 4, and 5 on the second register */
-	GPIO_DATA2_REG, GPIO_DATA2_REG, GPIO_DATA2_REG, GPIO_DATA2_REG,
-	/* GPIO 6, 7, 8, and 9 on the third register */
-	GPIO_DATA3_REG, GPIO_DATA3_REG, GPIO_DATA3_REG, GPIO_DATA3_REG,
-	/* GPIO 10, 11, 12, 13, 14, and 15 on the fourth register */
-	GPIO_DATA4_REG, GPIO_DATA4_REG, GPIO_DATA4_REG, GPIO_DATA4_REG,
-	GPIO_DATA4_REG, GPIO_DATA4_REG,
-	/* GPIO 16 - 23 on the first strange EXTENDED register */
-	EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG,
-	EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG,
-	EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG,
-	/* GPIO 24 - 27 on the second strange EXTENDED register */
-	EXTENDED_GPIO2_REG, EXTENDED_GPIO2_REG, EXTENDED_GPIO2_REG,
-	EXTENDED_GPIO2_REG,
-};
-
-/* Maps pins to mode register */
-static volatile u32 * const MSP_GPIO_MODE_REGISTER[] = {
-	/* GPIO 0 and 1 on the first register */
-	GPIO_CFG1_REG, GPIO_CFG1_REG,
-	/* GPIO 2, 3, 4, and 5 on the second register */
-	GPIO_CFG2_REG, GPIO_CFG2_REG, GPIO_CFG2_REG, GPIO_CFG2_REG,
-	/* GPIO 6, 7, 8, and 9 on the third register */
-	GPIO_CFG3_REG, GPIO_CFG3_REG, GPIO_CFG3_REG, GPIO_CFG3_REG,
-	/* GPIO 10, 11, 12, 13, 14, and 15 on the fourth register */
-	GPIO_CFG4_REG, GPIO_CFG4_REG, GPIO_CFG4_REG, GPIO_CFG4_REG,
-	GPIO_CFG4_REG, GPIO_CFG4_REG,
-	/* GPIO 16 - 23 on the first strange EXTENDED register */
-	EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG,
-	EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG,
-	EXTENDED_GPIO1_REG, EXTENDED_GPIO1_REG,
-	/* GPIO 24 - 27 on the second strange EXTENDED register */
-	EXTENDED_GPIO2_REG, EXTENDED_GPIO2_REG, EXTENDED_GPIO2_REG,
-	EXTENDED_GPIO2_REG,
-};
-
-/* Maps 'basic' pins to relative offset from 0 per register */
-static int MSP_GPIO_OFFSET[] = {
-	/* GPIO 0 and 1 on the first register */
-	0, 0,
-	/* GPIO 2, 3, 4, and 5 on the second register */
-	2, 2, 2, 2,
-	/* GPIO 6, 7, 8, and 9 on the third register */
-	6, 6, 6, 6,
-	/* GPIO 10, 11, 12, 13, 14, and 15 on the fourth register */
-	10, 10, 10, 10, 10, 10,
-};
-
-/* Maps MODE to allowed pin mask */
-static unsigned int MSP_GPIO_MODE_ALLOWED[] = {
-	0xffffffff,	/* Mode 0 - INPUT */
-	0x00000,	/* Mode 1 - INTERRUPT */
-	0x00030,	/* Mode 2 - UART_INPUT (GPIO 4, 5)*/
-	0, 0, 0, 0, 0,	/* Modes 3, 4, 5, 6, and 7 are reserved */
-	0xffffffff,	/* Mode 8 - OUTPUT */
-	0x0000f,	/* Mode 9 - UART_OUTPUT/
-				PERF_TIMERA (GPIO 0, 1, 2, 3) */
-	0x00003,	/* Mode a - PERF_TIMERB (GPIO 0, 1) */
-	0x00000,	/* Mode b - Not really a mode! */
-};
-
-/* -- Bit masks -- */
-
-/* This gives you the 'register relative offset gpio' number */
-#define OFFSET_GPIO_NUMBER(gpio)	(gpio - MSP_GPIO_OFFSET[gpio])
-
-/* These take the 'register relative offset gpio' number */
-#define BASIC_DATA_REG_MASK(ogpio)		(1 << ogpio)
-#define BASIC_MODE_REG_VALUE(mode, ogpio)	\
-	(mode << BASIC_MODE_REG_SHIFT(ogpio))
-#define BASIC_MODE_REG_MASK(ogpio)		\
-	BASIC_MODE_REG_VALUE(0xf, ogpio)
-#define BASIC_MODE_REG_SHIFT(ogpio)		(ogpio * 4)
-#define BASIC_MODE_REG_FROM_REG(data, ogpio)	\
-	((data & BASIC_MODE_REG_MASK(ogpio)) >> BASIC_MODE_REG_SHIFT(ogpio))
-
-/* These take the actual GPIO number (0 through 15) */
-#define BASIC_DATA_MASK(gpio)	\
-	BASIC_DATA_REG_MASK(OFFSET_GPIO_NUMBER(gpio))
-#define BASIC_MODE_MASK(gpio)	\
-	BASIC_MODE_REG_MASK(OFFSET_GPIO_NUMBER(gpio))
-#define BASIC_MODE(mode, gpio)	\
-	BASIC_MODE_REG_VALUE(mode, OFFSET_GPIO_NUMBER(gpio))
-#define BASIC_MODE_SHIFT(gpio)	\
-	BASIC_MODE_REG_SHIFT(OFFSET_GPIO_NUMBER(gpio))
-#define BASIC_MODE_FROM_REG(data, gpio)	\
-	BASIC_MODE_REG_FROM_REG(data, OFFSET_GPIO_NUMBER(gpio))
-
-/*
- * Each extended GPIO register is 32 bits long and is responsible for up to
- * eight GPIOs. The least significant 16 bits contain the set and clear bit
- * pair for each of the GPIOs. The most significant 16 bits contain the
- * disable and enable bit pair for each of the GPIOs. For example, the
- * extended GPIO reg for GPIOs 16-23 is as follows:
- *
- *	31: GPIO23_DISABLE
- *	...
- *	19: GPIO17_DISABLE
- *	18: GPIO17_ENABLE
- *	17: GPIO16_DISABLE
- *	16: GPIO16_ENABLE
- *	...
- *	3:  GPIO17_SET
- *	2:  GPIO17_CLEAR
- *	1:  GPIO16_SET
- *	0:  GPIO16_CLEAR
- */
-
-/* This gives the 'register relative offset gpio' number */
-#define EXTENDED_OFFSET_GPIO(gpio)	(gpio < 24 ? gpio - 16 : gpio - 24)
-
-/* These take the 'register relative offset gpio' number */
-#define EXTENDED_REG_DISABLE(ogpio)	(0x2 << ((ogpio * 2) + 16))
-#define EXTENDED_REG_ENABLE(ogpio)	(0x1 << ((ogpio * 2) + 16))
-#define EXTENDED_REG_SET(ogpio)		(0x2 << (ogpio * 2))
-#define EXTENDED_REG_CLR(ogpio)		(0x1 << (ogpio * 2))
-
-/* These take the actual GPIO number (16 through 27) */
-#define EXTENDED_DISABLE(gpio)	\
-	EXTENDED_REG_DISABLE(EXTENDED_OFFSET_GPIO(gpio))
-#define EXTENDED_ENABLE(gpio)	\
-	EXTENDED_REG_ENABLE(EXTENDED_OFFSET_GPIO(gpio))
-#define EXTENDED_SET(gpio)	\
-	EXTENDED_REG_SET(EXTENDED_OFFSET_GPIO(gpio))
-#define EXTENDED_CLR(gpio)	\
-	EXTENDED_REG_CLR(EXTENDED_OFFSET_GPIO(gpio))
-
-#define EXTENDED_FULL_MASK		(0xffffffff)
-
-/* -- API inline-functions -- */
-
-/*
- * Gets the current value of the specified pin
- */
-static inline enum msp_gpio_data msp_gpio_pin_get(unsigned int gpio)
-{
-	u32 pinhi_mask = 0, pinhi_mask2 = 0;
-
-	if (gpio >= MSP_NUM_GPIOS)
-		return MSP_GPIO_NONE;
-
-	if (gpio < 16) {
-		pinhi_mask = BASIC_DATA_MASK(gpio);
-	} else {
-		/*
-		 * Two cases are possible with the EXTENDED register:
-		 *  - In output mode (ENABLED flag set), check the CLR bit
-		 *  - In input mode (ENABLED flag not set), check the SET bit
-		 */
-		pinhi_mask = EXTENDED_ENABLE(gpio) | EXTENDED_CLR(gpio);
-		pinhi_mask2 = EXTENDED_SET(gpio);
-	}
-	if (((*MSP_GPIO_DATA_REGISTER[gpio] & pinhi_mask) == pinhi_mask) ||
-	    (*MSP_GPIO_DATA_REGISTER[gpio] & pinhi_mask2))
-		return MSP_GPIO_HI;
-	else
-		return MSP_GPIO_LO;
-}
-
-/* Sets the specified pin to the specified value */
-static inline void msp_gpio_pin_set(enum msp_gpio_data data, unsigned int gpio)
-{
-	if (gpio >= MSP_NUM_GPIOS)
-		return;
-
-	if (gpio < 16) {
-		if (data == MSP_GPIO_TOGGLE)
-			toggle_reg32(MSP_GPIO_DATA_REGISTER[gpio],
-					BASIC_DATA_MASK(gpio));
-		else if (data == MSP_GPIO_HI)
-			set_reg32(MSP_GPIO_DATA_REGISTER[gpio],
-					BASIC_DATA_MASK(gpio));
-		else
-			clear_reg32(MSP_GPIO_DATA_REGISTER[gpio],
-					BASIC_DATA_MASK(gpio));
-	} else {
-		if (data == MSP_GPIO_TOGGLE) {
-			/* Special ugly case:
-			 *   We have to read the CLR bit.
-			 *   If set, we write the CLR bit.
-			 *   If not, we write the SET bit.
-			 */
-			u32 tmpdata;
-
-			custom_read_reg32(MSP_GPIO_DATA_REGISTER[gpio],
-								tmpdata);
-			if (tmpdata & EXTENDED_CLR(gpio))
-				tmpdata = EXTENDED_CLR(gpio);
-			else
-				tmpdata = EXTENDED_SET(gpio);
-			custom_write_reg32(MSP_GPIO_DATA_REGISTER[gpio],
-								tmpdata);
-		} else {
-			u32 newdata;
-
-			if (data == MSP_GPIO_HI)
-				newdata = EXTENDED_SET(gpio);
-			else
-				newdata = EXTENDED_CLR(gpio);
-			set_value_reg32(MSP_GPIO_DATA_REGISTER[gpio],
-						EXTENDED_FULL_MASK, newdata);
-		}
-	}
-}
-
-/* Sets the specified pin to the specified value */
-static inline void msp_gpio_pin_hi(unsigned int gpio)
-{
-	msp_gpio_pin_set(MSP_GPIO_HI, gpio);
-}
-
-/* Sets the specified pin to the specified value */
-static inline void msp_gpio_pin_lo(unsigned int gpio)
-{
-	msp_gpio_pin_set(MSP_GPIO_LO, gpio);
-}
-
-/* Sets the specified pin to the opposite value */
-static inline void msp_gpio_pin_toggle(unsigned int gpio)
-{
-	msp_gpio_pin_set(MSP_GPIO_TOGGLE, gpio);
-}
-
-/* Gets the mode of the specified pin */
-static inline enum msp_gpio_mode msp_gpio_pin_get_mode(unsigned int gpio)
-{
-	enum msp_gpio_mode retval = MSP_GPIO_UNKNOWN;
-	uint32_t data;
-
-	if (gpio >= MSP_NUM_GPIOS)
-		return retval;
-
-	data = *MSP_GPIO_MODE_REGISTER[gpio];
-
-	if (gpio < 16) {
-		retval = BASIC_MODE_FROM_REG(data, gpio);
-	} else {
-		/* Extended pins can only be either INPUT or OUTPUT */
-		if (data & EXTENDED_ENABLE(gpio))
-			retval = MSP_GPIO_OUTPUT;
-		else
-			retval = MSP_GPIO_INPUT;
-	}
-
-	return retval;
-}
-
-/*
- * Sets the specified mode on the requested pin
- * Returns 0 on success, or -1 if that mode is not allowed on this pin
- */
-static inline int msp_gpio_pin_mode(enum msp_gpio_mode mode, unsigned int gpio)
-{
-	u32 modemask, newmode;
-
-	if ((1 << gpio) & ~MSP_GPIO_MODE_ALLOWED[mode])
-		return -1;
-
-	if (gpio >= MSP_NUM_GPIOS)
-		return -1;
-
-	if (gpio < 16) {
-		modemask = BASIC_MODE_MASK(gpio);
-		newmode =  BASIC_MODE(mode, gpio);
-	} else {
-		modemask = EXTENDED_FULL_MASK;
-		if (mode == MSP_GPIO_INPUT)
-			newmode = EXTENDED_DISABLE(gpio);
-		else
-			newmode = EXTENDED_ENABLE(gpio);
-	}
-	/* Do the set atomically */
-	set_value_reg32(MSP_GPIO_MODE_REGISTER[gpio], modemask, newmode);
-
-	return 0;
-}
-
-#endif /* __MSP_GPIO_MACROS_H__ */
diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_int.h b/arch/mips/include/asm/pmc-sierra/msp71xx/msp_int.h
deleted file mode 100644
index 1d9f054..0000000
--- a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_int.h
+++ /dev/null
@@ -1,43 +0,0 @@
-/*
- * Defines for the MSP interrupt handlers.
- *
- * Copyright (C) 2005, PMC-Sierra, Inc.  All rights reserved.
- * Author: Andrew Hughes, Andrew_Hughes@pmc-sierra.com
- *
- * ########################################################################
- *
- *  This program is free software; you can distribute it and/or modify it
- *  under the terms of the GNU General Public License (Version 2) as
- *  published by the Free Software Foundation.
- *
- *  This program is distributed in the hope it will be useful, but WITHOUT
- *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
- *  for more details.
- *
- *  You should have received a copy of the GNU General Public License along
- *  with this program; if not, write to the Free Software Foundation, Inc.,
- *  59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
- *
- * ########################################################################
- */
-
-#ifndef _MSP_INT_H
-#define _MSP_INT_H
-
-/*
- * The PMC-Sierra MSP product line has at least two different interrupt
- * controllers, the SLP register based scheme and the CIC interrupt
- * controller block mechanism.  This file distinguishes between them
- * so that devices see a uniform interface.
- */
-
-#if defined(CONFIG_IRQ_MSP_SLP)
-	#include "msp_slp_int.h"
-#elif defined(CONFIG_IRQ_MSP_CIC)
-	#include "msp_cic_int.h"
-#else
-	#error "What sort of interrupt controller does *your* MSP have?"
-#endif
-
-#endif /* !_MSP_INT_H */
diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_pci.h b/arch/mips/include/asm/pmc-sierra/msp71xx/msp_pci.h
deleted file mode 100644
index 4156069..0000000
--- a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_pci.h
+++ /dev/null
@@ -1,205 +0,0 @@
-/*
- * Copyright (c) 2000-2006 PMC-Sierra INC.
- *
- *     This program is free software; you can redistribute it
- *     and/or modify it under the terms of the GNU General
- *     Public License as published by the Free Software
- *     Foundation; either version 2 of the License, or (at your
- *     option) any later version.
- *
- *     This program is distributed in the hope that it will be
- *     useful, but WITHOUT ANY WARRANTY; without even the implied
- *     warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
- *     PURPOSE.  See the GNU General Public License for more
- *     details.
- *
- *     You should have received a copy of the GNU General Public
- *     License along with this program; if not, write to the Free
- *     Software Foundation, Inc., 675 Mass Ave, Cambridge, MA
- *     02139, USA.
- *
- * PMC-SIERRA INC. DISCLAIMS ANY LIABILITY OF ANY KIND
- * FOR ANY DAMAGES WHATSOEVER RESULTING FROM THE USE OF THIS
- * SOFTWARE.
- */
-
-#ifndef _MSP_PCI_H_
-#define _MSP_PCI_H_
-
-#define MSP_HAS_PCI(ID)	(((u32)(ID) <= 0x4236) && ((u32)(ID) >= 0x4220))
-
-/*
- * It is convenient to program the OATRAN register so that
- * Athena virtual address space and PCI address space are
- * the same. This is not a requirement, just a convenience.
- *
- * The only hard restrictions on the value of OATRAN is that
- * OATRAN must not be programmed to allow translated memory
- * addresses to fall within the lowest 512MB of
- * PCI address space. This region is hardcoded
- * for use as Athena PCI Host Controller target
- * access memory space to the Athena's SDRAM.
- *
- * Note that OATRAN applies only to memory accesses, not
- * to I/O accesses.
- *
- * To program OATRAN to make Athena virtual address space
- * and PCI address space have the same values, OATRAN
- * is to be programmed to 0xB8000000. The top seven
- * bits of the value mimic the seven bits clipped off
- * by the PCI Host controller.
- *
- * With OATRAN at the said value, when the CPU does
- * an access to its virtual address at, say 0xB900_5000,
- * the address appearing on the PCI bus will be
- * 0xB900_5000.
- *    - Michael Penner
- */
-#define MSP_PCI_OATRAN		0xB8000000UL
-
-#define MSP_PCI_SPACE_BASE	(MSP_PCI_OATRAN + 0x1002000UL)
-#define MSP_PCI_SPACE_SIZE	(0x3000000UL - 0x2000)
-#define MSP_PCI_SPACE_END \
-		(MSP_PCI_SPACE_BASE + MSP_PCI_SPACE_SIZE - 1)
-#define MSP_PCI_IOSPACE_BASE	(MSP_PCI_OATRAN + 0x1001000UL)
-#define MSP_PCI_IOSPACE_SIZE	0x1000
-#define MSP_PCI_IOSPACE_END  \
-		(MSP_PCI_IOSPACE_BASE + MSP_PCI_IOSPACE_SIZE - 1)
-
-/* IRQ for PCI status interrupts */
-#define PCI_STAT_IRQ	20
-
-#define QFLUSH_REG_1	0xB7F40000
-
-typedef volatile unsigned int pcireg;
-typedef void * volatile ppcireg;
-
-struct pci_block_copy
-{
-    pcireg   unused1; /* +0x00 */
-    pcireg   unused2; /* +0x04 */
-    ppcireg  unused3; /* +0x08 */
-    ppcireg  unused4; /* +0x0C */
-    pcireg   unused5; /* +0x10 */
-    pcireg   unused6; /* +0x14 */
-    pcireg   unused7; /* +0x18 */
-    ppcireg  unused8; /* +0x1C */
-    ppcireg  unused9; /* +0x20 */
-    pcireg   unusedA; /* +0x24 */
-    ppcireg  unusedB; /* +0x28 */
-    ppcireg  unusedC; /* +0x2C */
-};
-
-enum
-{
-    config_device_vendor,  /* 0 */
-    config_status_command, /* 1 */
-    config_class_revision, /* 2 */
-    config_BIST_header_latency_cache, /* 3 */
-    config_BAR0,           /* 4 */
-    config_BAR1,           /* 5 */
-    config_BAR2,           /* 6 */
-    config_not_used7,      /* 7 */
-    config_not_used8,      /* 8 */
-    config_not_used9,      /* 9 */
-    config_CIS,            /* 10 */
-    config_subsystem,      /* 11 */
-    config_not_used12,     /* 12 */
-    config_capabilities,   /* 13 */
-    config_not_used14,     /* 14 */
-    config_lat_grant_irq,  /* 15 */
-    config_message_control,/* 16 */
-    config_message_addr,   /* 17 */
-    config_message_data,   /* 18 */
-    config_VPD_addr,       /* 19 */
-    config_VPD_data,       /* 20 */
-    config_maxregs         /* 21 - number of registers */
-};
-
-struct msp_pci_regs
-{
-    pcireg hop_unused_00; /* +0x00 */
-    pcireg hop_unused_04; /* +0x04 */
-    pcireg hop_unused_08; /* +0x08 */
-    pcireg hop_unused_0C; /* +0x0C */
-    pcireg hop_unused_10; /* +0x10 */
-    pcireg hop_unused_14; /* +0x14 */
-    pcireg hop_unused_18; /* +0x18 */
-    pcireg hop_unused_1C; /* +0x1C */
-    pcireg hop_unused_20; /* +0x20 */
-    pcireg hop_unused_24; /* +0x24 */
-    pcireg hop_unused_28; /* +0x28 */
-    pcireg hop_unused_2C; /* +0x2C */
-    pcireg hop_unused_30; /* +0x30 */
-    pcireg hop_unused_34; /* +0x34 */
-    pcireg if_control;    /* +0x38 */
-    pcireg oatran;        /* +0x3C */
-    pcireg reset_ctl;     /* +0x40 */
-    pcireg config_addr;   /* +0x44 */
-    pcireg hop_unused_48; /* +0x48 */
-    pcireg msg_signaled_int_status; /* +0x4C */
-    pcireg msg_signaled_int_mask;   /* +0x50 */
-    pcireg if_status;     /* +0x54 */
-    pcireg if_mask;       /* +0x58 */
-    pcireg hop_unused_5C; /* +0x5C */
-    pcireg hop_unused_60; /* +0x60 */
-    pcireg hop_unused_64; /* +0x64 */
-    pcireg hop_unused_68; /* +0x68 */
-    pcireg hop_unused_6C; /* +0x6C */
-    pcireg hop_unused_70; /* +0x70 */
-
-    struct pci_block_copy pci_bc[2] __attribute__((aligned(64)));
-
-    pcireg error_hdr1; /* +0xE0 */
-    pcireg error_hdr2; /* +0xE4 */
-
-    pcireg config[config_maxregs] __attribute__((aligned(256)));
-
-};
-
-#define BPCI_CFGADDR_BUSNUM_SHF 16
-#define BPCI_CFGADDR_FUNCTNUM_SHF 8
-#define BPCI_CFGADDR_REGNUM_SHF 2
-#define BPCI_CFGADDR_ENABLE (1<<31)
-
-#define BPCI_IFCONTROL_RTO (1<<20) /* Retry timeout */
-#define BPCI_IFCONTROL_HCE (1<<16) /* Host configuration enable */
-#define BPCI_IFCONTROL_CTO_SHF 12  /* Shift count for CTO bits */
-#define BPCI_IFCONTROL_SE  (1<<5)  /* Enable exceptions on errors */
-#define BPCI_IFCONTROL_BIST (1<<4) /* Use BIST in per. mode */
-#define BPCI_IFCONTROL_CAP (1<<3)  /* Enable capabilities */
-#define BPCI_IFCONTROL_MMC_SHF 0   /* Shift count for MMC bits */
-
-#define BPCI_IFSTATUS_MGT  (1<<8)  /* Master Grant timeout */
-#define BPCI_IFSTATUS_MTT  (1<<9)  /* Master TRDY timeout */
-#define BPCI_IFSTATUS_MRT  (1<<10) /* Master retry timeout */
-#define BPCI_IFSTATUS_BC0F (1<<13) /* Block copy 0 fault */
-#define BPCI_IFSTATUS_BC1F (1<<14) /* Block copy 1 fault */
-#define BPCI_IFSTATUS_PCIU (1<<15) /* PCI unable to respond */
-#define BPCI_IFSTATUS_BSIZ (1<<16) /* PCI access with illegal size */
-#define BPCI_IFSTATUS_BADD (1<<17) /* PCI access with illegal addr */
-#define BPCI_IFSTATUS_RTO  (1<<18) /* Retry time out */
-#define BPCI_IFSTATUS_SER  (1<<19) /* System error */
-#define BPCI_IFSTATUS_PER  (1<<20) /* Parity error */
-#define BPCI_IFSTATUS_LCA  (1<<21) /* Local CPU abort */
-#define BPCI_IFSTATUS_MEM  (1<<22) /* Memory prot. violation */
-#define BPCI_IFSTATUS_ARB  (1<<23) /* Arbiter timed out */
-#define BPCI_IFSTATUS_STA  (1<<27) /* Signaled target abort */
-#define BPCI_IFSTATUS_TA   (1<<28) /* Target abort */
-#define BPCI_IFSTATUS_MA   (1<<29) /* Master abort */
-#define BPCI_IFSTATUS_PEI  (1<<30) /* Parity error as initiator */
-#define BPCI_IFSTATUS_PET  (1<<31) /* Parity error as target */
-
-#define BPCI_RESETCTL_PR (1<<0)    /* True if reset asserted */
-#define BPCI_RESETCTL_RT (1<<4)    /* Release time */
-#define BPCI_RESETCTL_CT (1<<8)    /* Config time */
-#define BPCI_RESETCTL_PE (1<<12)   /* PCI enabled */
-#define BPCI_RESETCTL_HM (1<<13)   /* PCI host mode */
-#define BPCI_RESETCTL_RI (1<<14)   /* PCI reset in */
-
-extern struct msp_pci_regs msp_pci_regs
-			__attribute__((section(".register")));
-extern unsigned long msp_pci_config_space
-			__attribute__((section(".register")));
-
-#endif /* !_MSP_PCI_H_ */
diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_prom.h b/arch/mips/include/asm/pmc-sierra/msp71xx/msp_prom.h
deleted file mode 100644
index 786d82d..0000000
--- a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_prom.h
+++ /dev/null
@@ -1,171 +0,0 @@
-/*
- * MIPS boards bootprom interface for the Linux kernel.
- *
- * Copyright (C) 2000 MIPS Technologies, Inc.  All rights reserved.
- * Author: Carsten Langgaard, carstenl@mips.com
- *
- * ########################################################################
- *
- *  This program is free software; you can distribute it and/or modify it
- *  under the terms of the GNU General Public License (Version 2) as
- *  published by the Free Software Foundation.
- *
- *  This program is distributed in the hope it will be useful, but WITHOUT
- *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
- *  for more details.
- *
- *  You should have received a copy of the GNU General Public License along
- *  with this program; if not, write to the Free Software Foundation, Inc.,
- *  59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
- *
- * ########################################################################
- */
-
-#ifndef _ASM_MSP_PROM_H
-#define _ASM_MSP_PROM_H
-
-#include <linux/types.h>
-
-#define DEVICEID			"deviceid"
-#define FEATURES			"features"
-#define PROM_ENV			"prom_env"
-#define PROM_ENV_FILE			"/proc/"PROM_ENV
-#define PROM_ENV_SIZE			256
-
-#define CPU_DEVID_FAMILY		0x0000ff00
-#define CPU_DEVID_REVISION		0x000000ff
-
-#define FPGA_IS_POLO(revision) \
-		(((revision >= 0xb0) && (revision < 0xd0)))
-#define FPGA_IS_5000(revision) \
-		((revision >= 0x80) && (revision <= 0x90))
-#define	FPGA_IS_ZEUS(revision)		((revision < 0x7f))
-#define FPGA_IS_DUET(revision) \
-		(((revision >= 0xa0) && (revision < 0xb0)))
-#define FPGA_IS_MSP4200(revision)	((revision >= 0xd0))
-#define FPGA_IS_MSP7100(revision)	((revision >= 0xd0))
-
-#define MACHINE_TYPE_POLO		"POLO"
-#define MACHINE_TYPE_DUET		"DUET"
-#define	MACHINE_TYPE_ZEUS		"ZEUS"
-#define MACHINE_TYPE_MSP2000REVB	"MSP2000REVB"
-#define MACHINE_TYPE_MSP5000		"MSP5000"
-#define MACHINE_TYPE_MSP4200		"MSP4200"
-#define MACHINE_TYPE_MSP7120		"MSP7120"
-#define MACHINE_TYPE_MSP7130		"MSP7130"
-#define MACHINE_TYPE_OTHER		"OTHER"
-
-#define MACHINE_TYPE_POLO_FPGA		"POLO-FPGA"
-#define MACHINE_TYPE_DUET_FPGA		"DUET-FPGA"
-#define	MACHINE_TYPE_ZEUS_FPGA		"ZEUS_FPGA"
-#define MACHINE_TYPE_MSP2000REVB_FPGA	"MSP2000REVB-FPGA"
-#define MACHINE_TYPE_MSP5000_FPGA	"MSP5000-FPGA"
-#define MACHINE_TYPE_MSP4200_FPGA	"MSP4200-FPGA"
-#define MACHINE_TYPE_MSP7100_FPGA	"MSP7100-FPGA"
-#define MACHINE_TYPE_OTHER_FPGA		"OTHER-FPGA"
-
-/* Device Family definitions */
-#define FAMILY_FPGA			0x0000
-#define FAMILY_ZEUS			0x1000
-#define FAMILY_POLO			0x2000
-#define FAMILY_DUET			0x4000
-#define FAMILY_TRIAD			0x5000
-#define FAMILY_MSP4200			0x4200
-#define FAMILY_MSP4200_FPGA		0x4f00
-#define FAMILY_MSP7100			0x7100
-#define FAMILY_MSP7100_FPGA		0x7f00
-
-/* Device Type definitions */
-#define TYPE_MSP7120			0x7120
-#define TYPE_MSP7130			0x7130
-
-#define ENET_KEY		'E'
-#define ENETTXD_KEY		'e'
-#define PCI_KEY			'P'
-#define PCIMUX_KEY		'p'
-#define SEC_KEY			'S'
-#define SPAD_KEY		'D'
-#define TDM_KEY			'T'
-#define ZSP_KEY			'Z'
-
-#define FEATURE_NOEXIST		'-'
-#define FEATURE_EXIST		'+'
-
-#define ENET_MII		'M'
-#define ENET_RMII		'R'
-
-#define	ENETTXD_FALLING		'F'
-#define ENETTXD_RISING		'R'
-
-#define PCI_HOST		'H'
-#define PCI_PERIPHERAL		'P'
-
-#define PCIMUX_FULL		'F'
-#define PCIMUX_SINGLE		'S'
-
-#define SEC_DUET		'D'
-#define SEC_POLO		'P'
-#define SEC_SLOW		'S'
-#define SEC_TRIAD		'T'
-
-#define SPAD_POLO		'P'
-
-#define TDM_DUET		'D'	/* DUET TDMs might exist */
-#define TDM_POLO		'P'	/* POLO TDMs might exist */
-#define TDM_TRIAD		'T'	/* TRIAD TDMs might exist */
-
-#define ZSP_DUET		'D'	/* one DUET zsp engine */
-#define ZSP_TRIAD		'T'	/* two TRIAD zsp engines */
-
-extern char *prom_getenv(char *name);
-extern void prom_init_cmdline(void);
-extern void prom_meminit(void);
-extern void prom_fixup_mem_map(unsigned long start_mem,
-			       unsigned long end_mem);
-
-extern int get_ethernet_addr(char *ethaddr_name, char *ethernet_addr);
-extern unsigned long get_deviceid(void);
-extern char identify_enet(unsigned long interface_num);
-extern char identify_enetTxD(unsigned long interface_num);
-extern char identify_pci(void);
-extern char identify_sec(void);
-extern char identify_spad(void);
-extern char identify_sec(void);
-extern char identify_tdm(void);
-extern char identify_zsp(void);
-extern unsigned long identify_family(void);
-extern unsigned long identify_revision(void);
-
-/*
- * The following macro calls prom_printf and puts the format string
- * into an init section so it can be reclaimed.
- */
-#define ppfinit(f, x...) \
-	do { \
-		static char _f[] __initdata = KERN_INFO f; \
-		printk(_f, ## x); \
-	} while (0)
-
-/* Memory descriptor management. */
-#define PROM_MAX_PMEMBLOCKS    7	/* 6 used */
-
-enum yamon_memtypes {
-	yamon_dontuse,
-	yamon_prom,
-	yamon_free,
-};
-
-struct prom_pmemblock {
-	unsigned long base; /* Within KSEG0. */
-	unsigned int size;  /* In bytes. */
-	unsigned int type;  /* free or prom memory */
-};
-
-extern int prom_argc;
-extern char **prom_argv;
-extern char **prom_envp;
-extern int *prom_vec;
-extern struct prom_pmemblock *prom_getmdesc(void);
-
-#endif /* !_ASM_MSP_PROM_H */
diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_regops.h b/arch/mips/include/asm/pmc-sierra/msp71xx/msp_regops.h
deleted file mode 100644
index 7d41474..0000000
--- a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_regops.h
+++ /dev/null
@@ -1,236 +0,0 @@
-/*
- * SMP/VPE-safe functions to access "registers" (see note).
- *
- * NOTES:
-* - These macros use ll/sc instructions, so it is your responsibility to
- * ensure these are available on your platform before including this file.
- * - The MIPS32 spec states that ll/sc results are undefined for uncached
- * accesses. This means they can't be used on HW registers accessed
- * through kseg1. Code which requires these macros for this purpose must
- * front-end the registers with cached memory "registers" and have a single
- * thread update the actual HW registers.
- * - A maximum of 2k of code can be inserted between ll and sc. Every
- * memory accesses between the instructions will increase the chance of
- * sc failing and having to loop.
- * - When using custom_read_reg32/custom_write_reg32 only perform the
- * necessary logical operations on the register value in between these
- * two calls. All other logic should be performed before the first call.
-  * - There is a bug on the R10000 chips which has a workaround. If you
- * are affected by this bug, make sure to define the symbol 'R10000_LLSC_WAR'
- * to be non-zero.  If you are using this header from within linux, you may
- * include <asm/war.h> before including this file to have this defined
- * appropriately for you.
- *
- * Copyright 2005-2007 PMC-Sierra, Inc.
- *
- *  This program is free software; you can redistribute  it and/or modify it
- *  under  the terms of  the GNU General  Public License as published by the
- *  Free Software Foundation;  either version 2 of the  License, or (at your
- *  option) any later version.
- *
- *  THIS  SOFTWARE  IS PROVIDED   ``AS  IS'' AND   ANY  EXPRESS OR IMPLIED
- *  WARRANTIES,   INCLUDING, BUT NOT  LIMITED  TO, THE IMPLIED WARRANTIES OF
- *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
- *  EVENT  SHALL   THE AUTHOR  BE    LIABLE FOR ANY   DIRECT, INDIRECT,
- *  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- *  LIMITED   TO, PROCUREMENT OF  SUBSTITUTE GOODS  OR SERVICES; LOSS OF USE,
- *  DATA,  OR PROFITS; OR  BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- *  THEORY OF LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT
- *  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
- *  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
- *
- *  You should have received a copy of the  GNU General Public License along
- *  with this program; if not, write  to the Free Software Foundation, Inc., 675
- *  Mass Ave, Cambridge, MA 02139, USA.
- */
-
-#ifndef __ASM_REGOPS_H__
-#define __ASM_REGOPS_H__
-
-#include <linux/types.h>
-
-#include <asm/war.h>
-
-#ifndef R10000_LLSC_WAR
-#define R10000_LLSC_WAR 0
-#endif
-
-#if R10000_LLSC_WAR == 1
-#define __beqz	"beqzl	"
-#else
-#define __beqz	"beqz	"
-#endif
-
-#ifndef _LINUX_TYPES_H
-typedef unsigned int u32;
-#endif
-
-/*
- * Sets all the masked bits to the corresponding value bits
- */
-static inline void set_value_reg32(volatile u32 *const addr,
-					u32 const mask,
-					u32 const value)
-{
-	u32 temp;
-
-	__asm__ __volatile__(
-	"	.set	push				\n"
-	"	.set	mips3				\n"
-	"1:	ll	%0, %1	# set_value_reg32	\n"
-	"	and	%0, %2				\n"
-	"	or	%0, %3				\n"
-	"	sc	%0, %1				\n"
-	"	"__beqz"%0, 1b				\n"
-	"	nop					\n"
-	"	.set	pop				\n"
-	: "=&r" (temp), "=m" (*addr)
-	: "ir" (~mask), "ir" (value), "m" (*addr));
-}
-
-/*
- * Sets all the masked bits to '1'
- */
-static inline void set_reg32(volatile u32 *const addr,
-				u32 const mask)
-{
-	u32 temp;
-
-	__asm__ __volatile__(
-	"	.set	push				\n"
-	"	.set	mips3				\n"
-	"1:	ll	%0, %1		# set_reg32	\n"
-	"	or	%0, %2				\n"
-	"	sc	%0, %1				\n"
-	"	"__beqz"%0, 1b				\n"
-	"	nop					\n"
-	"	.set	pop				\n"
-	: "=&r" (temp), "=m" (*addr)
-	: "ir" (mask), "m" (*addr));
-}
-
-/*
- * Sets all the masked bits to '0'
- */
-static inline void clear_reg32(volatile u32 *const addr,
-				u32 const mask)
-{
-	u32 temp;
-
-	__asm__ __volatile__(
-	"	.set	push				\n"
-	"	.set	mips3				\n"
-	"1:	ll	%0, %1		# clear_reg32	\n"
-	"	and	%0, %2				\n"
-	"	sc	%0, %1				\n"
-	"	"__beqz"%0, 1b				\n"
-	"	nop					\n"
-	"	.set	pop				\n"
-	: "=&r" (temp), "=m" (*addr)
-	: "ir" (~mask), "m" (*addr));
-}
-
-/*
- * Toggles all masked bits from '0' to '1' and '1' to '0'
- */
-static inline void toggle_reg32(volatile u32 *const addr,
-				u32 const mask)
-{
-	u32 temp;
-
-	__asm__ __volatile__(
-	"	.set	push				\n"
-	"	.set	mips3				\n"
-	"1:	ll	%0, %1		# toggle_reg32	\n"
-	"	xor	%0, %2				\n"
-	"	sc	%0, %1				\n"
-	"	"__beqz"%0, 1b				\n"
-	"	nop					\n"
-	"	.set	pop				\n"
-	: "=&r" (temp), "=m" (*addr)
-	: "ir" (mask), "m" (*addr));
-}
-
-/*
- * Read all masked bits others are returned as '0'
- */
-static inline u32 read_reg32(volatile u32 *const addr,
-				u32 const mask)
-{
-	u32 temp;
-
-	__asm__ __volatile__(
-	"	.set	push				\n"
-	"	.set	noreorder			\n"
-	"	lw	%0, %1		# read		\n"
-	"	and	%0, %2		# mask		\n"
-	"	.set	pop				\n"
-	: "=&r" (temp)
-	: "m" (*addr), "ir" (mask));
-
-	return temp;
-}
-
-/*
- * blocking_read_reg32 - Read address with blocking load
- *
- * Uncached writes need to be read back to ensure they reach RAM.
- * The returned value must be 'used' to prevent from becoming a
- * non-blocking load.
- */
-static inline u32 blocking_read_reg32(volatile u32 *const addr)
-{
-	u32 temp;
-
-	__asm__ __volatile__(
-	"	.set	push				\n"
-	"	.set	noreorder			\n"
-	"	lw	%0, %1		# read		\n"
-	"	move	%0, %0		# block		\n"
-	"	.set	pop				\n"
-	: "=&r" (temp)
-	: "m" (*addr));
-
-	return temp;
-}
-
-/*
- * For special strange cases only:
- *
- * If you need custom processing within a ll/sc loop, use the following macros
- * VERY CAREFULLY:
- *
- *   u32 tmp;				<-- Define a variable to hold the data
- *
- *   custom_read_reg32(address, tmp);	<-- Reads the address and put the value
- *						in the 'tmp' variable given
- *
- *	From here on out, you are (basically) atomic, so don't do anything too
- *	fancy!
- *	Also, this code may loop if the end of this block fails to write
- *	everything back safely due do the other CPU, so do NOT do anything
- *	with side-effects!
- *
- *   custom_write_reg32(address, tmp);	<-- Writes back 'tmp' safely.
- */
-#define custom_read_reg32(address, tmp)				\
-	__asm__ __volatile__(					\
-	"	.set	push				\n"	\
-	"	.set	mips3				\n"	\
-	"1:	ll	%0, %1	#custom_read_reg32	\n"	\
-	"	.set	pop				\n"	\
-	: "=r" (tmp), "=m" (*address)				\
-	: "m" (*address))
-
-#define custom_write_reg32(address, tmp)			\
-	__asm__ __volatile__(					\
-	"	.set	push				\n"	\
-	"	.set	mips3				\n"	\
-	"	sc	%0, %1	#custom_write_reg32	\n"	\
-	"	"__beqz"%0, 1b				\n"	\
-	"	nop					\n"	\
-	"	.set	pop				\n"	\
-	: "=&r" (tmp), "=m" (*address)				\
-	: "0" (tmp), "m" (*address))
-
-#endif  /* __ASM_REGOPS_H__ */
diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_regs.h b/arch/mips/include/asm/pmc-sierra/msp71xx/msp_regs.h
deleted file mode 100644
index 692c1b6..0000000
--- a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_regs.h
+++ /dev/null
@@ -1,664 +0,0 @@
-/*
- * Defines for the address space, registers and register configuration
- * (bit masks, access macros etc) for the PMC-Sierra line of MSP products.
- * This file contains addess maps for all the devices in the line of
- * products but only has register definitions and configuration masks for
- * registers which aren't definitely associated with any device.  Things
- * like clock settings, reset access, the ELB etc.  Individual device
- * drivers will reference the appropriate XXX_BASE value defined here
- * and have individual registers offset from that.
- *
- * Copyright (C) 2005-2007 PMC-Sierra, Inc.  All rights reserved.
- * Author: Andrew Hughes, Andrew_Hughes@pmc-sierra.com
- *
- * ########################################################################
- *
- *  This program is free software; you can distribute it and/or modify it
- *  under the terms of the GNU General Public License (Version 2) as
- *  published by the Free Software Foundation.
- *
- *  This program is distributed in the hope it will be useful, but WITHOUT
- *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
- *  for more details.
- *
- *  You should have received a copy of the GNU General Public License along
- *  with this program; if not, write to the Free Software Foundation, Inc.,
- *  59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
- *
- * ########################################################################
- */
-
-#include <asm/addrspace.h>
-#include <linux/types.h>
-
-#ifndef _ASM_MSP_REGS_H
-#define _ASM_MSP_REGS_H
-
-/*
- ########################################################################
- #  Address space and device base definitions                           #
- ########################################################################
- */
-
-/*
- ***************************************************************************
- * System Logic and Peripherals (ELB, UART0, etc) device address space     *
- ***************************************************************************
- */
-#define MSP_SLP_BASE		0x1c000000
-					/* System Logic and Peripherals */
-#define MSP_RST_BASE		(MSP_SLP_BASE + 0x10)
-					/* System reset register base	*/
-#define MSP_RST_SIZE		0x0C	/* System reset register space	*/
-
-#define MSP_WTIMER_BASE		(MSP_SLP_BASE + 0x04C)
-					/* watchdog timer base          */
-#define MSP_ITIMER_BASE		(MSP_SLP_BASE + 0x054)
-					/* internal timer base          */
-#define MSP_UART0_BASE		(MSP_SLP_BASE + 0x100)
-					/* UART0 controller base        */
-#define MSP_BCPY_CTRL_BASE	(MSP_SLP_BASE + 0x120)
-					/* Block Copy controller base   */
-#define MSP_BCPY_DESC_BASE	(MSP_SLP_BASE + 0x160)
-					/* Block Copy descriptor base   */
-
-/*
- ***************************************************************************
- * PCI address space                                                       *
- ***************************************************************************
- */
-#define MSP_PCI_BASE		0x19000000
-
-/*
- ***************************************************************************
- * MSbus device address space                                              *
- ***************************************************************************
- */
-#define MSP_MSB_BASE		0x18000000
-					/* MSbus address start          */
-#define MSP_PER_BASE		(MSP_MSB_BASE + 0x400000)
-					/* Peripheral device registers  */
-#define MSP_MAC0_BASE		(MSP_MSB_BASE + 0x600000)
-					/* MAC A device registers       */
-#define MSP_MAC1_BASE		(MSP_MSB_BASE + 0x700000)
-					/* MAC B device registers       */
-#define MSP_MAC_SIZE		0xE0	/* MAC register space		*/
-
-#define MSP_SEC_BASE		(MSP_MSB_BASE + 0x800000)
-					/* Security Engine registers    */
-#define MSP_MAC2_BASE		(MSP_MSB_BASE + 0x900000)
-					/* MAC C device registers       */
-#define MSP_ADSL2_BASE		(MSP_MSB_BASE + 0xA80000)
-					/* ADSL2 device registers       */
-#define MSP_USB0_BASE		(MSP_MSB_BASE + 0xB00000)
-					/* USB0 device registers        */
-#define MSP_USB1_BASE		(MSP_MSB_BASE + 0x300000)
-					/* USB1 device registers	*/
-#define MSP_CPUIF_BASE		(MSP_MSB_BASE + 0xC00000)
-					/* CPU interface registers      */
-
-/* Devices within the MSbus peripheral block */
-#define MSP_UART1_BASE		(MSP_PER_BASE + 0x030)
-					/* UART1 controller base        */
-#define MSP_SPI_BASE		(MSP_PER_BASE + 0x058)
-					/* SPI/MPI control registers    */
-#define MSP_TWI_BASE		(MSP_PER_BASE + 0x090)
-					/* Two-wire control registers   */
-#define MSP_PTIMER_BASE		(MSP_PER_BASE + 0x0F0)
-					/* Programmable timer control   */
-
-/*
- ***************************************************************************
- * Physical Memory configuration address space                             *
- ***************************************************************************
- */
-#define MSP_MEM_CFG_BASE	0x17f00000
-
-#define MSP_MEM_INDIRECT_CTL_10	0x10
-
-/*
- * Notes:
- *  1) The SPI registers are split into two blocks, one offset from the
- *     MSP_SPI_BASE by 0x00 and the other offset from the MSP_SPI_BASE by
- *     0x68.  The SPI driver definitions for the register must be aware
- *     of this.
- *  2) The block copy engine register are divided into two regions, one
- *     for the control/configuration of the engine proper and one for the
- *     values of the descriptors used in the copy process.  These have
- *     different base defines (CTRL_BASE vs DESC_BASE)
- *  3) These constants are for physical addresses which means that they
- *     work correctly with "ioremap" and friends.  This means that device
- *     drivers will need to remap these addresses using ioremap and perhaps
- *     the readw/writew macros.  Or they could use the regptr() macro
- *     defined below, but the readw/writew calls are the correct thing.
- *  4) The UARTs have an additional status register offset from the base
- *     address.  This register isn't used in the standard 8250 driver but
- *     may be used in other software.  Consult the hardware datasheet for
- *     offset details.
- *  5) For some unknown reason the security engine (MSP_SEC_BASE) registers
- *     start at an offset of 0x84 from the base address but the block of
- *     registers before this is reserved for the security engine.  The
- *     driver will have to be aware of this but it makes the register
- *     definitions line up better with the documentation.
- */
-
-/*
- ########################################################################
- #  System register definitions.  Not associated with a specific device #
- ########################################################################
- */
-
-/*
- * This macro maps the physical register number into uncached space
- * and (for C code) casts it into a u32 pointer so it can be dereferenced
- * Normally these would be accessed with ioremap and readX/writeX, but
- * these are convenient for a lot of internal kernel code.
- */
-#ifdef __ASSEMBLER__
-	#define regptr(addr) (KSEG1ADDR(addr))
-#else
-	#define regptr(addr) ((volatile u32 *const)(KSEG1ADDR(addr)))
-#endif
-
-/*
- ***************************************************************************
- * System Logic and Peripherals (RESET, ELB, etc) registers                *
- ***************************************************************************
- */
-
-/* System Control register definitions */
-#define	DEV_ID_REG	regptr(MSP_SLP_BASE + 0x00)
-					/* Device-ID                 RO */
-#define	FWR_ID_REG	regptr(MSP_SLP_BASE + 0x04)
-					/* Firmware-ID Register      RW */
-#define	SYS_ID_REG0	regptr(MSP_SLP_BASE + 0x08)
-					/* System-ID Register-0      RW */
-#define	SYS_ID_REG1	regptr(MSP_SLP_BASE + 0x0C)
-					/* System-ID Register-1      RW */
-
-/* System Reset register definitions */
-#define	RST_STS_REG	regptr(MSP_SLP_BASE + 0x10)
-					/* System Reset Status       RO */
-#define	RST_SET_REG	regptr(MSP_SLP_BASE + 0x14)
-					/* System Set Reset          WO */
-#define	RST_CLR_REG	regptr(MSP_SLP_BASE + 0x18)
-					/* System Clear Reset        WO */
-
-/* System Clock Registers */
-#define PCI_SLP_REG	regptr(MSP_SLP_BASE + 0x1C)
-					/* PCI clock generator       RW */
-#define URT_SLP_REG	regptr(MSP_SLP_BASE + 0x20)
-					/* UART clock generator      RW */
-/* reserved		      (MSP_SLP_BASE + 0x24)                     */
-/* reserved		      (MSP_SLP_BASE + 0x28)                     */
-#define PLL1_SLP_REG	regptr(MSP_SLP_BASE + 0x2C)
-					/* PLL1 clock generator      RW */
-#define PLL0_SLP_REG	regptr(MSP_SLP_BASE + 0x30)
-					/* PLL0 clock generator      RW */
-#define MIPS_SLP_REG	regptr(MSP_SLP_BASE + 0x34)
-					/* MIPS clock generator      RW */
-#define	VE_SLP_REG	regptr(MSP_SLP_BASE + 0x38)
-					/* Voice Eng clock generator RW */
-/* reserved		      (MSP_SLP_BASE + 0x3C)                     */
-#define MSB_SLP_REG	regptr(MSP_SLP_BASE + 0x40)
-					/* MS-Bus clock generator    RW */
-#define SMAC_SLP_REG	regptr(MSP_SLP_BASE + 0x44)
-					/* Sec & MAC clock generator RW */
-#define PERF_SLP_REG	regptr(MSP_SLP_BASE + 0x48)
-					/* Per & TDM clock generator RW */
-
-/* Interrupt Controller Registers */
-#define SLP_INT_STS_REG regptr(MSP_SLP_BASE + 0x70)
-					/* Interrupt status register RW */
-#define SLP_INT_MSK_REG regptr(MSP_SLP_BASE + 0x74)
-					/* Interrupt enable/mask     RW */
-#define SE_MBOX_REG	regptr(MSP_SLP_BASE + 0x78)
-					/* Security Engine mailbox   RW */
-#define VE_MBOX_REG	regptr(MSP_SLP_BASE + 0x7C)
-					/* Voice Engine mailbox      RW */
-
-/* ELB Controller Registers */
-#define CS0_CNFG_REG	regptr(MSP_SLP_BASE + 0x80)
-					/* ELB CS0 Configuration Reg    */
-#define CS0_ADDR_REG	regptr(MSP_SLP_BASE + 0x84)
-					/* ELB CS0 Base Address Reg     */
-#define CS0_MASK_REG	regptr(MSP_SLP_BASE + 0x88)
-					/* ELB CS0 Mask Register        */
-#define CS0_ACCESS_REG	regptr(MSP_SLP_BASE + 0x8C)
-					/* ELB CS0 access register      */
-
-#define CS1_CNFG_REG	regptr(MSP_SLP_BASE + 0x90)
-					/* ELB CS1 Configuration Reg    */
-#define CS1_ADDR_REG	regptr(MSP_SLP_BASE + 0x94)
-					/* ELB CS1 Base Address Reg     */
-#define CS1_MASK_REG	regptr(MSP_SLP_BASE + 0x98)
-					/* ELB CS1 Mask Register        */
-#define CS1_ACCESS_REG	regptr(MSP_SLP_BASE + 0x9C)
-					/* ELB CS1 access register      */
-
-#define CS2_CNFG_REG	regptr(MSP_SLP_BASE + 0xA0)
-					/* ELB CS2 Configuration Reg    */
-#define CS2_ADDR_REG	regptr(MSP_SLP_BASE + 0xA4)
-					/* ELB CS2 Base Address Reg     */
-#define CS2_MASK_REG	regptr(MSP_SLP_BASE + 0xA8)
-					/* ELB CS2 Mask Register        */
-#define CS2_ACCESS_REG	regptr(MSP_SLP_BASE + 0xAC)
-					/* ELB CS2 access register      */
-
-#define CS3_CNFG_REG	regptr(MSP_SLP_BASE + 0xB0)
-					/* ELB CS3 Configuration Reg    */
-#define CS3_ADDR_REG	regptr(MSP_SLP_BASE + 0xB4)
-					/* ELB CS3 Base Address Reg     */
-#define CS3_MASK_REG	regptr(MSP_SLP_BASE + 0xB8)
-					/* ELB CS3 Mask Register        */
-#define CS3_ACCESS_REG	regptr(MSP_SLP_BASE + 0xBC)
-					/* ELB CS3 access register      */
-
-#define CS4_CNFG_REG	regptr(MSP_SLP_BASE + 0xC0)
-					/* ELB CS4 Configuration Reg    */
-#define CS4_ADDR_REG	regptr(MSP_SLP_BASE + 0xC4)
-					/* ELB CS4 Base Address Reg     */
-#define CS4_MASK_REG	regptr(MSP_SLP_BASE + 0xC8)
-					/* ELB CS4 Mask Register        */
-#define CS4_ACCESS_REG	regptr(MSP_SLP_BASE + 0xCC)
-					/* ELB CS4 access register      */
-
-#define CS5_CNFG_REG	regptr(MSP_SLP_BASE + 0xD0)
-					/* ELB CS5 Configuration Reg    */
-#define CS5_ADDR_REG	regptr(MSP_SLP_BASE + 0xD4)
-					/* ELB CS5 Base Address Reg     */
-#define CS5_MASK_REG	regptr(MSP_SLP_BASE + 0xD8)
-					/* ELB CS5 Mask Register        */
-#define CS5_ACCESS_REG	regptr(MSP_SLP_BASE + 0xDC)
-					/* ELB CS5 access register      */
-
-/* reserved			       0xE0 - 0xE8                      */
-#define ELB_1PC_EN_REG	regptr(MSP_SLP_BASE + 0xEC)
-					/* ELB single PC card detect    */
-
-/* reserved			       0xF0 - 0xF8                      */
-#define ELB_CLK_CFG_REG	regptr(MSP_SLP_BASE + 0xFC)
-					/* SDRAM read/ELB timing Reg    */
-
-/* Extended UART status registers */
-#define UART0_STATUS_REG	regptr(MSP_UART0_BASE + 0x0c0)
-					/* UART Status Register 0       */
-#define UART1_STATUS_REG	regptr(MSP_UART1_BASE + 0x170)
-					/* UART Status Register 1       */
-
-/* Performance monitoring registers */
-#define PERF_MON_CTRL_REG	regptr(MSP_SLP_BASE + 0x140)
-					/* Performance monitor control  */
-#define PERF_MON_CLR_REG	regptr(MSP_SLP_BASE + 0x144)
-					/* Performance monitor clear    */
-#define PERF_MON_CNTH_REG	regptr(MSP_SLP_BASE + 0x148)
-					/* Perf monitor counter high    */
-#define PERF_MON_CNTL_REG	regptr(MSP_SLP_BASE + 0x14C)
-					/* Perf monitor counter low     */
-
-/* System control registers */
-#define SYS_CTRL_REG		regptr(MSP_SLP_BASE + 0x150)
-					/* System control register      */
-#define SYS_ERR1_REG		regptr(MSP_SLP_BASE + 0x154)
-					/* System Error status 1        */
-#define SYS_ERR2_REG		regptr(MSP_SLP_BASE + 0x158)
-					/* System Error status 2        */
-#define SYS_INT_CFG_REG		regptr(MSP_SLP_BASE + 0x15C)
-					/* System Interrupt config      */
-
-/* Voice Engine Memory configuration */
-#define VE_MEM_REG		regptr(MSP_SLP_BASE + 0x17C)
-					/* Voice engine memory config   */
-
-/* CPU/SLP Error Status registers */
-#define CPU_ERR1_REG		regptr(MSP_SLP_BASE + 0x180)
-					/* CPU/SLP Error status 1       */
-#define CPU_ERR2_REG		regptr(MSP_SLP_BASE + 0x184)
-					/* CPU/SLP Error status 1       */
-
-/* Extended GPIO registers       */
-#define EXTENDED_GPIO1_REG	regptr(MSP_SLP_BASE + 0x188)
-#define EXTENDED_GPIO2_REG	regptr(MSP_SLP_BASE + 0x18c)
-#define EXTENDED_GPIO_REG	EXTENDED_GPIO1_REG
-					/* Backward-compatibility	*/
-
-/* System Error registers */
-#define SLP_ERR_STS_REG		regptr(MSP_SLP_BASE + 0x190)
-					/* Int status for SLP errors    */
-#define SLP_ERR_MSK_REG		regptr(MSP_SLP_BASE + 0x194)
-					/* Int mask for SLP errors      */
-#define SLP_ELB_ERST_REG	regptr(MSP_SLP_BASE + 0x198)
-					/* External ELB reset           */
-#define SLP_BOOT_STS_REG	regptr(MSP_SLP_BASE + 0x19C)
-					/* Boot Status                  */
-
-/* Extended ELB addressing */
-#define CS0_EXT_ADDR_REG	regptr(MSP_SLP_BASE + 0x1A0)
-					/* CS0 Extended address         */
-#define CS1_EXT_ADDR_REG	regptr(MSP_SLP_BASE + 0x1A4)
-					/* CS1 Extended address         */
-#define CS2_EXT_ADDR_REG	regptr(MSP_SLP_BASE + 0x1A8)
-					/* CS2 Extended address         */
-#define CS3_EXT_ADDR_REG	regptr(MSP_SLP_BASE + 0x1AC)
-					/* CS3 Extended address         */
-/* reserved					      0x1B0             */
-#define CS5_EXT_ADDR_REG	regptr(MSP_SLP_BASE + 0x1B4)
-					/* CS5 Extended address         */
-
-/* PLL Adjustment registers */
-#define PLL_LOCK_REG		regptr(MSP_SLP_BASE + 0x200)
-					/* PLL0 lock status             */
-#define PLL_ARST_REG		regptr(MSP_SLP_BASE + 0x204)
-					/* PLL Analog reset status      */
-#define PLL0_ADJ_REG		regptr(MSP_SLP_BASE + 0x208)
-					/* PLL0 Adjustment value        */
-#define PLL1_ADJ_REG		regptr(MSP_SLP_BASE + 0x20C)
-					/* PLL1 Adjustment value        */
-
-/*
- ***************************************************************************
- * Peripheral Register definitions                                         *
- ***************************************************************************
- */
-
-/* Peripheral status */
-#define PER_CTRL_REG		regptr(MSP_PER_BASE + 0x50)
-					/* Peripheral control register  */
-#define PER_STS_REG		regptr(MSP_PER_BASE + 0x54)
-					/* Peripheral status register   */
-
-/* SPI/MPI Registers */
-#define SMPI_TX_SZ_REG		regptr(MSP_PER_BASE + 0x58)
-					/* SPI/MPI Tx Size register     */
-#define SMPI_RX_SZ_REG		regptr(MSP_PER_BASE + 0x5C)
-					/* SPI/MPI Rx Size register     */
-#define SMPI_CTL_REG		regptr(MSP_PER_BASE + 0x60)
-					/* SPI/MPI Control register     */
-#define SMPI_MS_REG		regptr(MSP_PER_BASE + 0x64)
-					/* SPI/MPI Chip Select reg      */
-#define SMPI_CORE_DATA_REG	regptr(MSP_PER_BASE + 0xC0)
-					/* SPI/MPI Core Data reg        */
-#define SMPI_CORE_CTRL_REG	regptr(MSP_PER_BASE + 0xC4)
-					/* SPI/MPI Core Control reg     */
-#define SMPI_CORE_STAT_REG	regptr(MSP_PER_BASE + 0xC8)
-					/* SPI/MPI Core Status reg      */
-#define SMPI_CORE_SSEL_REG	regptr(MSP_PER_BASE + 0xCC)
-					/* SPI/MPI Core Ssel reg        */
-#define SMPI_FIFO_REG		regptr(MSP_PER_BASE + 0xD0)
-					/* SPI/MPI Data FIFO reg        */
-
-/* Peripheral Block Error Registers           */
-#define PER_ERR_STS_REG		regptr(MSP_PER_BASE + 0x70)
-					/* Error Bit Status Register    */
-#define PER_ERR_MSK_REG		regptr(MSP_PER_BASE + 0x74)
-					/* Error Bit Mask Register      */
-#define PER_HDR1_REG		regptr(MSP_PER_BASE + 0x78)
-					/* Error Header 1 Register      */
-#define PER_HDR2_REG		regptr(MSP_PER_BASE + 0x7C)
-					/* Error Header 2 Register      */
-
-/* Peripheral Block Interrupt Registers       */
-#define PER_INT_STS_REG		regptr(MSP_PER_BASE + 0x80)
-					/* Interrupt status register    */
-#define PER_INT_MSK_REG		regptr(MSP_PER_BASE + 0x84)
-					/* Interrupt Mask Register      */
-#define GPIO_INT_STS_REG	regptr(MSP_PER_BASE + 0x88)
-					/* GPIO interrupt status reg    */
-#define GPIO_INT_MSK_REG	regptr(MSP_PER_BASE + 0x8C)
-					/* GPIO interrupt MASK Reg      */
-
-/* POLO GPIO registers                        */
-#define POLO_GPIO_DAT1_REG	regptr(MSP_PER_BASE + 0x0E0)
-					/* Polo GPIO[8:0]  data reg     */
-#define POLO_GPIO_CFG1_REG	regptr(MSP_PER_BASE + 0x0E4)
-					/* Polo GPIO[7:0]  config reg   */
-#define POLO_GPIO_CFG2_REG	regptr(MSP_PER_BASE + 0x0E8)
-					/* Polo GPIO[15:8] config reg   */
-#define POLO_GPIO_OD1_REG	regptr(MSP_PER_BASE + 0x0EC)
-					/* Polo GPIO[31:0] output drive */
-#define POLO_GPIO_CFG3_REG	regptr(MSP_PER_BASE + 0x170)
-					/* Polo GPIO[23:16] config reg  */
-#define POLO_GPIO_DAT2_REG	regptr(MSP_PER_BASE + 0x174)
-					/* Polo GPIO[15:9]  data reg    */
-#define POLO_GPIO_DAT3_REG	regptr(MSP_PER_BASE + 0x178)
-					/* Polo GPIO[23:16]  data reg   */
-#define POLO_GPIO_DAT4_REG	regptr(MSP_PER_BASE + 0x17C)
-					/* Polo GPIO[31:24]  data reg   */
-#define POLO_GPIO_DAT5_REG	regptr(MSP_PER_BASE + 0x180)
-					/* Polo GPIO[39:32]  data reg   */
-#define POLO_GPIO_DAT6_REG	regptr(MSP_PER_BASE + 0x184)
-					/* Polo GPIO[47:40]  data reg   */
-#define POLO_GPIO_DAT7_REG	regptr(MSP_PER_BASE + 0x188)
-					/* Polo GPIO[54:48]  data reg   */
-#define POLO_GPIO_CFG4_REG	regptr(MSP_PER_BASE + 0x18C)
-					/* Polo GPIO[31:24] config reg  */
-#define POLO_GPIO_CFG5_REG	regptr(MSP_PER_BASE + 0x190)
-					/* Polo GPIO[39:32] config reg  */
-#define POLO_GPIO_CFG6_REG	regptr(MSP_PER_BASE + 0x194)
-					/* Polo GPIO[47:40] config reg  */
-#define POLO_GPIO_CFG7_REG	regptr(MSP_PER_BASE + 0x198)
-					/* Polo GPIO[54:48] config reg  */
-#define POLO_GPIO_OD2_REG	regptr(MSP_PER_BASE + 0x19C)
-					/* Polo GPIO[54:32] output drive */
-
-/* Generic GPIO registers                     */
-#define GPIO_DATA1_REG		regptr(MSP_PER_BASE + 0x170)
-					/* GPIO[1:0] data register      */
-#define GPIO_DATA2_REG		regptr(MSP_PER_BASE + 0x174)
-					/* GPIO[5:2] data register      */
-#define GPIO_DATA3_REG		regptr(MSP_PER_BASE + 0x178)
-					/* GPIO[9:6] data register      */
-#define GPIO_DATA4_REG		regptr(MSP_PER_BASE + 0x17C)
-					/* GPIO[15:10] data register    */
-#define GPIO_CFG1_REG		regptr(MSP_PER_BASE + 0x180)
-					/* GPIO[1:0] config register    */
-#define GPIO_CFG2_REG		regptr(MSP_PER_BASE + 0x184)
-					/* GPIO[5:2] config register    */
-#define GPIO_CFG3_REG		regptr(MSP_PER_BASE + 0x188)
-					/* GPIO[9:6] config register    */
-#define GPIO_CFG4_REG		regptr(MSP_PER_BASE + 0x18C)
-					/* GPIO[15:10] config register  */
-#define GPIO_OD_REG		regptr(MSP_PER_BASE + 0x190)
-					/* GPIO[15:0] output drive      */
-
-/*
- ***************************************************************************
- * CPU Interface register definitions                                      *
- ***************************************************************************
- */
-#define PCI_FLUSH_REG		regptr(MSP_CPUIF_BASE + 0x00)
-					/* PCI-SDRAM queue flush trigger */
-#define OCP_ERR1_REG		regptr(MSP_CPUIF_BASE + 0x04)
-					/* OCP Error Attribute 1        */
-#define OCP_ERR2_REG		regptr(MSP_CPUIF_BASE + 0x08)
-					/* OCP Error Attribute 2        */
-#define OCP_STS_REG		regptr(MSP_CPUIF_BASE + 0x0C)
-					/* OCP Error Status             */
-#define CPUIF_PM_REG		regptr(MSP_CPUIF_BASE + 0x10)
-					/* CPU policy configuration     */
-#define CPUIF_CFG_REG		regptr(MSP_CPUIF_BASE + 0x10)
-					/* Misc configuration options   */
-
-/* Central Interrupt Controller Registers */
-#define MSP_CIC_BASE		(MSP_CPUIF_BASE + 0x8000)
-					/* Central Interrupt registers  */
-#define CIC_EXT_CFG_REG		regptr(MSP_CIC_BASE + 0x00)
-					/* External interrupt config    */
-#define CIC_STS_REG		regptr(MSP_CIC_BASE + 0x04)
-					/* CIC Interrupt Status         */
-#define CIC_VPE0_MSK_REG	regptr(MSP_CIC_BASE + 0x08)
-					/* VPE0 Interrupt Mask          */
-#define CIC_VPE1_MSK_REG	regptr(MSP_CIC_BASE + 0x0C)
-					/* VPE1 Interrupt Mask          */
-#define CIC_TC0_MSK_REG		regptr(MSP_CIC_BASE + 0x10)
-					/* Thread Context 0 Int Mask    */
-#define CIC_TC1_MSK_REG		regptr(MSP_CIC_BASE + 0x14)
-					/* Thread Context 1 Int Mask    */
-#define CIC_TC2_MSK_REG		regptr(MSP_CIC_BASE + 0x18)
-					/* Thread Context 2 Int Mask    */
-#define CIC_TC3_MSK_REG		regptr(MSP_CIC_BASE + 0x18)
-					/* Thread Context 3 Int Mask    */
-#define CIC_TC4_MSK_REG		regptr(MSP_CIC_BASE + 0x18)
-					/* Thread Context 4 Int Mask    */
-#define CIC_PCIMSI_STS_REG	regptr(MSP_CIC_BASE + 0x18)
-#define CIC_PCIMSI_MSK_REG	regptr(MSP_CIC_BASE + 0x18)
-#define CIC_PCIFLSH_REG		regptr(MSP_CIC_BASE + 0x18)
-#define CIC_VPE0_SWINT_REG	regptr(MSP_CIC_BASE + 0x08)
-
-
-/*
- ***************************************************************************
- * Memory controller registers                                             *
- ***************************************************************************
- */
-#define MEM_CFG1_REG		regptr(MSP_MEM_CFG_BASE + 0x00)
-#define MEM_SS_ADDR		regptr(MSP_MEM_CFG_BASE + 0x00)
-#define MEM_SS_DATA		regptr(MSP_MEM_CFG_BASE + 0x04)
-#define MEM_SS_WRITE		regptr(MSP_MEM_CFG_BASE + 0x08)
-
-/*
- ***************************************************************************
- * PCI controller registers                                                *
- ***************************************************************************
- */
-#define PCI_BASE_REG		regptr(MSP_PCI_BASE + 0x00)
-#define PCI_CONFIG_SPACE_REG	regptr(MSP_PCI_BASE + 0x800)
-#define PCI_JTAG_DEVID_REG	regptr(MSP_SLP_BASE + 0x13c)
-
-/*
- ########################################################################
- #  Register content & macro definitions                                #
- ########################################################################
- */
-
-/*
- ***************************************************************************
- * DEV_ID defines                                                          *
- ***************************************************************************
- */
-#define DEV_ID_PCI_DIS		(1 << 26)       /* Set if PCI disabled */
-#define DEV_ID_PCI_HOST		(1 << 20)       /* Set if PCI host */
-#define DEV_ID_SINGLE_PC	(1 << 19)       /* Set if single PC Card */
-#define DEV_ID_FAMILY		(0xff << 8)     /* family ID code */
-#define POLO_ZEUS_SUB_FAMILY	(0x7  << 16)    /* sub family for Polo/Zeus */
-
-#define MSPFPGA_ID		(0x00  << 8)    /* you are on your own here */
-#define MSP5000_ID		(0x50  << 8)
-#define MSP4F00_ID		(0x4f  << 8)    /* FPGA version of MSP4200 */
-#define MSP4E00_ID		(0x4f  << 8)    /* FPGA version of MSP7120 */
-#define MSP4200_ID		(0x42  << 8)
-#define MSP4000_ID		(0x40  << 8)
-#define MSP2XXX_ID		(0x20  << 8)
-#define MSPZEUS_ID		(0x10  << 8)
-
-#define MSP2004_SUB_ID		(0x0   << 16)
-#define MSP2005_SUB_ID		(0x1   << 16)
-#define MSP2006_SUB_ID		(0x1   << 16)
-#define MSP2007_SUB_ID		(0x2   << 16)
-#define MSP2010_SUB_ID		(0x3   << 16)
-#define MSP2015_SUB_ID		(0x4   << 16)
-#define MSP2020_SUB_ID		(0x5   << 16)
-#define MSP2100_SUB_ID		(0x6   << 16)
-
-/*
- ***************************************************************************
- * RESET defines                                                           *
- ***************************************************************************
- */
-#define MSP_GR_RST		(0x01 << 0)     /* Global reset bit     */
-#define MSP_MR_RST		(0x01 << 1)     /* MIPS reset bit       */
-#define MSP_PD_RST		(0x01 << 2)     /* PVC DMA reset bit    */
-#define MSP_PP_RST		(0x01 << 3)     /* PVC reset bit        */
-/* reserved                                                             */
-#define MSP_EA_RST		(0x01 << 6)     /* Mac A reset bit      */
-#define MSP_EB_RST		(0x01 << 7)     /* Mac B reset bit      */
-#define MSP_SE_RST		(0x01 << 8)     /* Security Eng reset bit */
-#define MSP_PB_RST		(0x01 << 9)     /* Per block reset bit  */
-#define MSP_EC_RST		(0x01 << 10)    /* Mac C reset bit      */
-#define MSP_TW_RST		(0x01 << 11)    /* TWI reset bit        */
-#define MSP_SPI_RST		(0x01 << 12)    /* SPI/MPI reset bit    */
-#define MSP_U1_RST		(0x01 << 13)    /* UART1 reset bit      */
-#define MSP_U0_RST		(0x01 << 14)    /* UART0 reset bit      */
-
-/*
- ***************************************************************************
- * UART defines                                                            *
- ***************************************************************************
- */
-#define MSP_BASE_BAUD		25000000
-#define MSP_UART_REG_LEN	0x20
-
-/*
- ***************************************************************************
- * ELB defines                                                             *
- ***************************************************************************
- */
-#define PCCARD_32		0x02    /* Set if is PCCARD 32 (Cardbus) */
-#define SINGLE_PCCARD		0x01    /* Set to enable single PC card */
-
-/*
- ***************************************************************************
- * CIC defines                                                             *
- ***************************************************************************
- */
-
-/* CIC_EXT_CFG_REG */
-#define EXT_INT_POL(eirq)			(1 << (eirq + 8))
-#define EXT_INT_EDGE(eirq)			(1 << eirq)
-
-#define CIC_EXT_SET_TRIGGER_LEVEL(reg, eirq)	(reg &= ~EXT_INT_EDGE(eirq))
-#define CIC_EXT_SET_TRIGGER_EDGE(reg, eirq)	(reg |= EXT_INT_EDGE(eirq))
-#define CIC_EXT_SET_ACTIVE_HI(reg, eirq)	(reg |= EXT_INT_POL(eirq))
-#define CIC_EXT_SET_ACTIVE_LO(reg, eirq)	(reg &= ~EXT_INT_POL(eirq))
-#define CIC_EXT_SET_ACTIVE_RISING		CIC_EXT_SET_ACTIVE_HI
-#define CIC_EXT_SET_ACTIVE_FALLING		CIC_EXT_SET_ACTIVE_LO
-
-#define CIC_EXT_IS_TRIGGER_LEVEL(reg, eirq) \
-				((reg & EXT_INT_EDGE(eirq)) == 0)
-#define CIC_EXT_IS_TRIGGER_EDGE(reg, eirq)	(reg & EXT_INT_EDGE(eirq))
-#define CIC_EXT_IS_ACTIVE_HI(reg, eirq)		(reg & EXT_INT_POL(eirq))
-#define CIC_EXT_IS_ACTIVE_LO(reg, eirq) \
-				((reg & EXT_INT_POL(eirq)) == 0)
-#define CIC_EXT_IS_ACTIVE_RISING		CIC_EXT_IS_ACTIVE_HI
-#define CIC_EXT_IS_ACTIVE_FALLING		CIC_EXT_IS_ACTIVE_LO
-
-/*
- ***************************************************************************
- * Memory Controller defines                                               *
- ***************************************************************************
- */
-
-/* Indirect memory controller registers */
-#define DDRC_CFG(n)		(n)
-#define DDRC_DEBUG(n)		(0x04 + n)
-#define DDRC_CTL(n)		(0x40 + n)
-
-/* Macro to perform DDRC indirect write */
-#define DDRC_INDIRECT_WRITE(reg, mask, value) \
-({ \
-	*MEM_SS_ADDR = (((mask) & 0xf) << 8) | ((reg) & 0xff); \
-	*MEM_SS_DATA = (value); \
-	*MEM_SS_WRITE = 1; \
-})
-
-/*
- ***************************************************************************
- * SPI/MPI Mode                                                            *
- ***************************************************************************
- */
-#define SPI_MPI_RX_BUSY		0x00008000	/* SPI/MPI Receive Busy */
-#define SPI_MPI_FIFO_EMPTY	0x00004000	/* SPI/MPI Fifo Empty   */
-#define SPI_MPI_TX_BUSY		0x00002000	/* SPI/MPI Transmit Busy */
-#define SPI_MPI_FIFO_FULL	0x00001000	/* SPI/MPU FIFO full    */
-
-/*
- ***************************************************************************
- * SPI/MPI Control Register                                                *
- ***************************************************************************
- */
-#define SPI_MPI_RX_START	0x00000004	/* Start receive command */
-#define SPI_MPI_FLUSH_Q		0x00000002	/* Flush SPI/MPI Queue */
-#define SPI_MPI_TX_START	0x00000001	/* Start Transmit Command */
-
-#endif /* !_ASM_MSP_REGS_H */
diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_slp_int.h b/arch/mips/include/asm/pmc-sierra/msp71xx/msp_slp_int.h
deleted file mode 100644
index 96d4c8c..0000000
--- a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_slp_int.h
+++ /dev/null
@@ -1,141 +0,0 @@
-/*
- * Defines for the MSP interrupt controller.
- *
- * Copyright (C) 1999 MIPS Technologies, Inc.  All rights reserved.
- * Author: Carsten Langgaard, carstenl@mips.com
- *
- * ########################################################################
- *
- *  This program is free software; you can distribute it and/or modify it
- *  under the terms of the GNU General Public License (Version 2) as
- *  published by the Free Software Foundation.
- *
- *  This program is distributed in the hope it will be useful, but WITHOUT
- *  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- *  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
- *  for more details.
- *
- *  You should have received a copy of the GNU General Public License along
- *  with this program; if not, write to the Free Software Foundation, Inc.,
- *  59 Temple Place - Suite 330, Boston MA 02111-1307, USA.
- *
- * ########################################################################
- */
-
-#ifndef _MSP_SLP_INT_H
-#define _MSP_SLP_INT_H
-
-/*
- * The PMC-Sierra SLP interrupts are arranged in a 3 level cascaded
- * hierarchical system.  The first level are the direct MIPS interrupts
- * and are assigned the interrupt range 0-7.  The second level is the SLM
- * interrupt controller and is assigned the range 8-39.  The third level
- * comprises the Peripherial block, the PCI block, the PCI MSI block and
- * the SLP.  The PCI interrupts and the SLP errors are handled by the
- * relevant subsystems so the core interrupt code needs only concern
- * itself with the Peripheral block.  These are assigned interrupts in
- * the range 40-71.
- */
-
-/*
- * IRQs directly connected to CPU
- */
-#define MSP_MIPS_INTBASE	0
-#define MSP_INT_SW0		0  /* IRQ for swint0,         C_SW0  */
-#define MSP_INT_SW1		1  /* IRQ for swint1,         C_SW1  */
-#define MSP_INT_MAC0 		2  /* IRQ for MAC 0,          C_IRQ0 */
-#define MSP_INT_MAC1		3  /* IRQ for MAC 1,          C_IRQ1 */
-#define MSP_INT_C_IRQ2		4  /* Wired off,              C_IRQ2 */
-#define MSP_INT_VE		5  /* IRQ for Voice Engine,   C_IRQ3 */
-#define MSP_INT_SLP		6  /* IRQ for SLM block,      C_IRQ4 */
-#define MSP_INT_TIMER		7  /* IRQ for the MIPS timer, C_IRQ5 */
-
-/*
- * IRQs cascaded on CPU interrupt 4 (CAUSE bit 12, C_IRQ4)
- * These defines should be tied to the register definition for the SLM
- * interrupt routine.  For now, just use hard-coded values.
- */
-#define MSP_SLP_INTBASE		(MSP_MIPS_INTBASE + 8)
-#define MSP_INT_EXT0		(MSP_SLP_INTBASE + 0)
-					/* External interrupt 0         */
-#define MSP_INT_EXT1		(MSP_SLP_INTBASE + 1)
-					/* External interrupt 1         */
-#define MSP_INT_EXT2		(MSP_SLP_INTBASE + 2)
-					/* External interrupt 2         */
-#define MSP_INT_EXT3		(MSP_SLP_INTBASE + 3)
-					/* External interrupt 3         */
-/* Reserved					   4-7                  */
-
-/*
- *************************************************************************
- * DANGER/DANGER/DANGER/DANGER/DANGER/DANGER/DANGER/DANGER/DANGER/DANGER *
- * Some MSP produces have this interrupt labelled as Voice and some are  *
- * SEC mbox ...                                                          *
- *************************************************************************
- */
-#define MSP_INT_SLP_VE		(MSP_SLP_INTBASE + 8)
-					/* Cascaded IRQ for Voice Engine*/
-#define MSP_INT_SLP_TDM		(MSP_SLP_INTBASE + 9)
-					/* TDM interrupt                */
-#define MSP_INT_SLP_MAC0	(MSP_SLP_INTBASE + 10)
-					/* Cascaded IRQ for MAC 0       */
-#define MSP_INT_SLP_MAC1	(MSP_SLP_INTBASE + 11)
-					/* Cascaded IRQ for MAC 1       */
-#define MSP_INT_SEC		(MSP_SLP_INTBASE + 12)
-					/* IRQ for security engine      */
-#define	MSP_INT_PER		(MSP_SLP_INTBASE + 13)
-					/* Peripheral interrupt         */
-#define	MSP_INT_TIMER0		(MSP_SLP_INTBASE + 14)
-					/* SLP timer 0                  */
-#define	MSP_INT_TIMER1		(MSP_SLP_INTBASE + 15)
-					/* SLP timer 1                  */
-#define	MSP_INT_TIMER2		(MSP_SLP_INTBASE + 16)
-					/* SLP timer 2                  */
-#define	MSP_INT_SLP_TIMER	(MSP_SLP_INTBASE + 17)
-					/* Cascaded MIPS timer          */
-#define MSP_INT_BLKCP		(MSP_SLP_INTBASE + 18)
-					/* Block Copy                   */
-#define MSP_INT_UART0		(MSP_SLP_INTBASE + 19)
-					/* UART 0                       */
-#define MSP_INT_PCI		(MSP_SLP_INTBASE + 20)
-					/* PCI subsystem                */
-#define MSP_INT_PCI_DBELL	(MSP_SLP_INTBASE + 21)
-					/* PCI doorbell                 */
-#define MSP_INT_PCI_MSI		(MSP_SLP_INTBASE + 22)
-					/* PCI Message Signal           */
-#define MSP_INT_PCI_BC0		(MSP_SLP_INTBASE + 23)
-					/* PCI Block Copy 0             */
-#define MSP_INT_PCI_BC1		(MSP_SLP_INTBASE + 24)
-					/* PCI Block Copy 1             */
-#define MSP_INT_SLP_ERR		(MSP_SLP_INTBASE + 25)
-					/* SLP error condition          */
-#define MSP_INT_MAC2		(MSP_SLP_INTBASE + 26)
-					/* IRQ for MAC2                 */
-/* Reserved					   26-31                */
-
-/*
- * IRQs cascaded on SLP PER interrupt (MSP_INT_PER)
- */
-#define MSP_PER_INTBASE		(MSP_SLP_INTBASE + 32)
-/* Reserved					   0-1                  */
-#define MSP_INT_UART1		(MSP_PER_INTBASE + 2)
-					/* UART 1                       */
-/* Reserved					   3-5                  */
-#define MSP_INT_2WIRE		(MSP_PER_INTBASE + 6)
-					/* 2-wire                       */
-#define MSP_INT_TM0		(MSP_PER_INTBASE + 7)
-					/* Peripheral timer block out 0 */
-#define MSP_INT_TM1		(MSP_PER_INTBASE + 8)
-					/* Peripheral timer block out 1 */
-/* Reserved					   9                    */
-#define MSP_INT_SPRX		(MSP_PER_INTBASE + 10)
-					/* SPI RX complete              */
-#define MSP_INT_SPTX		(MSP_PER_INTBASE + 11)
-					/* SPI TX complete              */
-#define MSP_INT_GPIO		(MSP_PER_INTBASE + 12)
-					/* GPIO                         */
-#define MSP_INT_PER_ERR		(MSP_PER_INTBASE + 13)
-					/* Peripheral error             */
-/* Reserved					   14-31                */
-
-#endif /* !_MSP_SLP_INT_H */
diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_usb.h b/arch/mips/include/asm/pmc-sierra/msp71xx/msp_usb.h
deleted file mode 100644
index 4c9348d..0000000
--- a/arch/mips/include/asm/pmc-sierra/msp71xx/msp_usb.h
+++ /dev/null
@@ -1,144 +0,0 @@
-/******************************************************************
- * Copyright (c) 2000-2007 PMC-Sierra INC.
- *
- *     This program is free software; you can redistribute it
- *     and/or modify it under the terms of the GNU General
- *     Public License as published by the Free Software
- *     Foundation; either version 2 of the License, or (at your
- *     option) any later version.
- *
- *     This program is distributed in the hope that it will be
- *     useful, but WITHOUT ANY WARRANTY; without even the implied
- *     warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
- *     PURPOSE.  See the GNU General Public License for more
- *     details.
- *
- *     You should have received a copy of the GNU General Public
- *     License along with this program; if not, write to the Free
- *     Software Foundation, Inc., 675 Mass Ave, Cambridge, MA
- *     02139, USA.
- *
- * PMC-SIERRA INC. DISCLAIMS ANY LIABILITY OF ANY KIND
- * FOR ANY DAMAGES WHATSOEVER RESULTING FROM THE USE OF THIS
- * SOFTWARE.
- */
-#ifndef MSP_USB_H_
-#define MSP_USB_H_
-
-#ifdef CONFIG_MSP_HAS_DUAL_USB
-#define NUM_USB_DEVS   2
-#else
-#define NUM_USB_DEVS   1
-#endif
-
-/* Register spaces for USB host 0 */
-#define MSP_USB0_MAB_START	(MSP_USB0_BASE + 0x0)
-#define MSP_USB0_MAB_END	(MSP_USB0_BASE + 0x17)
-#define MSP_USB0_ID_START	(MSP_USB0_BASE + 0x40000)
-#define MSP_USB0_ID_END		(MSP_USB0_BASE + 0x4008f)
-#define MSP_USB0_HS_START	(MSP_USB0_BASE + 0x40100)
-#define MSP_USB0_HS_END		(MSP_USB0_BASE + 0x401FF)
-
-/* Register spaces for USB host 1 */
-#define	MSP_USB1_MAB_START	(MSP_USB1_BASE + 0x0)
-#define MSP_USB1_MAB_END	(MSP_USB1_BASE + 0x17)
-#define MSP_USB1_ID_START	(MSP_USB1_BASE + 0x40000)
-#define MSP_USB1_ID_END		(MSP_USB1_BASE + 0x4008f)
-#define MSP_USB1_HS_START	(MSP_USB1_BASE + 0x40100)
-#define MSP_USB1_HS_END		(MSP_USB1_BASE + 0x401ff)
-
-/* USB Identification registers */
-struct msp_usbid_regs {
-	u32 id;		/* 0x0: Identification register */
-	u32 hwgen;	/* 0x4: General HW params */
-	u32 hwhost;	/* 0x8: Host HW params */
-	u32 hwdev;	/* 0xc: Device HW params */
-	u32 hwtxbuf;	/* 0x10: Tx buffer HW params */
-	u32 hwrxbuf;	/* 0x14: Rx buffer HW params */
-	u32 reserved[26];
-	u32 timer0_load; /* 0x80: General-purpose timer 0 load*/
-	u32 timer0_ctrl; /* 0x84: General-purpose timer 0 control */
-	u32 timer1_load; /* 0x88: General-purpose timer 1 load*/
-	u32 timer1_ctrl; /* 0x8c: General-purpose timer 1 control */
-};
-
-/* MSBus to AMBA registers */
-struct msp_mab_regs {
-	u32 isr;	/* 0x0: Interrupt status */
-	u32 imr;	/* 0x4: Interrupt mask */
-	u32 thcr0;	/* 0x8: Transaction header capture 0 */
-	u32 thcr1;	/* 0xc: Transaction header capture 1 */
-	u32 int_stat;	/* 0x10: Interrupt status summary */
-	u32 phy_cfg;	/* 0x14: USB phy config */
-};
-
-/* EHCI registers */
-struct msp_usbhs_regs {
-	u32 hciver;	/* 0x0: Version and offset to operational regs */
-	u32 hcsparams;	/* 0x4: Host control structural parameters */
-	u32 hccparams;	/* 0x8: Host control capability parameters */
-	u32 reserved0[5];
-	u32 dciver;	/* 0x20: Device interface version */
-	u32 dccparams;	/* 0x24: Device control capability parameters */
-	u32 reserved1[6];
-	u32 cmd;	/* 0x40: USB command */
-	u32 sts;	/* 0x44: USB status */
-	u32 int_ena;	/* 0x48: USB interrupt enable */
-	u32 frindex;	/* 0x4c: Frame index */
-	u32 reserved3;
-	union {
-		struct {
-			u32 flb_addr; /* 0x54: Frame list base address */
-			u32 next_async_addr; /* 0x58: next asynchronous addr */
-			u32 ttctrl; /* 0x5c: embedded transaction translator
-							async buffer status */
-			u32 burst_size; /* 0x60: Controller burst size */
-			u32 tx_fifo_ctrl; /* 0x64: Tx latency FIFO tuning */
-			u32 reserved0[4];
-			u32 endpt_nak; /* 0x78: Endpoint NAK */
-			u32 endpt_nak_ena; /* 0x7c: Endpoint NAK enable */
-			u32 cfg_flag; /* 0x80: Config flag */
-			u32 port_sc1; /* 0x84: Port status & control 1 */
-			u32 reserved1[7];
-			u32 otgsc;	/* 0xa4: OTG status & control */
-			u32 mode;	/* 0xa8: USB controller mode */
-		} host;
-
-		struct {
-			u32 dev_addr; /* 0x54: Device address */
-			u32 endpt_list_addr; /* 0x58: Endpoint list address */
-			u32 reserved0[7];
-			u32 endpt_nak;	/* 0x74 */
-			u32 endpt_nak_ctrl; /* 0x78 */
-			u32 cfg_flag; /* 0x80 */
-			u32 port_sc1; /* 0x84: Port status & control 1 */
-			u32 reserved[7];
-			u32 otgsc;	/* 0xa4: OTG status & control */
-			u32 mode;	/* 0xa8: USB controller mode */
-			u32 endpt_setup_stat; /* 0xac */
-			u32 endpt_prime; /* 0xb0 */
-			u32 endpt_flush; /* 0xb4 */
-			u32 endpt_stat; /* 0xb8 */
-			u32 endpt_complete; /* 0xbc */
-			u32 endpt_ctrl0; /* 0xc0 */
-			u32 endpt_ctrl1; /* 0xc4 */
-			u32 endpt_ctrl2; /* 0xc8 */
-			u32 endpt_ctrl3; /* 0xcc */
-		} device;
-	} u;
-};
-/*
- * Container for the more-generic platform_device.
- * This exists mainly as a way to map the non-standard register
- * spaces and make them accessible to the USB ISR.
- */
-struct mspusb_device {
-	struct msp_mab_regs   __iomem *mab_regs;
-	struct msp_usbid_regs __iomem *usbid_regs;
-	struct msp_usbhs_regs __iomem *usbhs_regs;
-	struct platform_device dev;
-};
-
-#define to_mspusb_device(x) container_of((x), struct mspusb_device, dev)
-#define TO_HOST_ID(x) ((x) & 0x3)
-#endif /*MSP_USB_H_*/
diff --git a/arch/mips/include/asm/pmc-sierra/msp71xx/war.h b/arch/mips/include/asm/pmc-sierra/msp71xx/war.h
deleted file mode 100644
index c74eb16..0000000
--- a/arch/mips/include/asm/pmc-sierra/msp71xx/war.h
+++ /dev/null
@@ -1,29 +0,0 @@
-/*
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- *
- * Copyright (C) 2002, 2004, 2007 by Ralf Baechle <ralf@linux-mips.org>
- */
-#ifndef __ASM_MIPS_PMC_SIERRA_WAR_H
-#define __ASM_MIPS_PMC_SIERRA_WAR_H
-
-#define R4600_V1_INDEX_ICACHEOP_WAR	0
-#define R4600_V1_HIT_CACHEOP_WAR	0
-#define R4600_V2_HIT_CACHEOP_WAR	0
-#define R5432_CP0_INTERRUPT_WAR		0
-#define BCM1250_M3_WAR			0
-#define SIBYTE_1956_WAR			0
-#define MIPS4K_ICACHE_REFILL_WAR	0
-#define MIPS_CACHE_SYNC_WAR		0
-#define TX49XX_ICACHE_INDEX_INV_WAR	0
-#define ICACHE_REFILLS_WORKAROUND_WAR	0
-#define R10000_LLSC_WAR			0
-#if defined(CONFIG_PMC_MSP7120_EVAL) || defined(CONFIG_PMC_MSP7120_GW) || \
-	defined(CONFIG_PMC_MSP7120_FPGA)
-#define MIPS34K_MISSED_ITLB_WAR         1
-#else
-#define MIPS34K_MISSED_ITLB_WAR         0
-#endif
-
-#endif /* __ASM_MIPS_PMC_SIERRA_WAR_H */
diff --git a/arch/mips/pmcs-msp71xx/Platform b/arch/mips/pmcs-msp71xx/Platform
index 9a86e29..7af0734 100644
--- a/arch/mips/pmcs-msp71xx/Platform
+++ b/arch/mips/pmcs-msp71xx/Platform
@@ -2,6 +2,6 @@
 # PMC-Sierra MSP SOCs
 #
 platform-$(CONFIG_PMC_MSP)	+= pmcs-msp71xx/
-cflags-$(CONFIG_PMC_MSP)	+= -I$(srctree)/arch/mips/include/asm/pmc-sierra/msp71xx \
+cflags-$(CONFIG_PMC_MSP)	+= -I$(srctree)/arch/mips/include/asm/mach-pmcs-msp71xx \
 					-mno-branch-likely
 load-$(CONFIG_PMC_MSP)		+= 0xffffffff80100000
-- 
1.7.2.5

