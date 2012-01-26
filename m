Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab2AZRNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:13:11 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:46416 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab2AZRNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:13:10 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: robherring2@gmail.com, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, plagnioj@jcrosoft.com,
        Dan Liang <dan.liang@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 1/6] ARM: at91/at91sam9x5: overall definition
Date: Thu, 26 Jan 2012 18:12:32 +0100
Message-Id: <15809998b6ca8f1bf69546bfcac18301a70625ef.1327596859.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327597957-32662-1-git-send-email-nicolas.ferre@atmel.com>
References: <1327597957-32662-1-git-send-email-nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Liang <dan.liang@atmel.com>

Add the definitions of peripheral and system registers for sam9x5 chips family.

Signed-off-by: Dan Liang <dan.liang@atmel.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
---
 arch/arm/mach-at91/include/mach/at91sam9x5.h       |   80 ++++++++++++++++++++
 .../arm/mach-at91/include/mach/at91sam9x5_matrix.h |   53 +++++++++++++
 2 files changed, 133 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-at91/include/mach/at91sam9x5.h
 create mode 100644 arch/arm/mach-at91/include/mach/at91sam9x5_matrix.h

diff --git a/arch/arm/mach-at91/include/mach/at91sam9x5.h b/arch/arm/mach-at91/include/mach/at91sam9x5.h
new file mode 100644
index 0000000..8476871
--- /dev/null
+++ b/arch/arm/mach-at91/include/mach/at91sam9x5.h
@@ -0,0 +1,80 @@
+/*
+ * Chip-specific header file for the AT91SAM9x5 family
+ *
+ *  Copyright (C) 2009-2012 Atmel Corporation.
+ *
+ * Common definitions.
+ * Based on AT91SAM9x5 datasheet.
+ *
+ * Licensed under GPLv2 or later.
+ */
+
+#ifndef AT91SAM9X5_H
+#define AT91SAM9X5_H
+
+/*
+ * Peripheral identifiers/interrupts.
+ */
+#define AT91SAM9X5_ID_PIOAB	2	/* Parallel I/O Controller A and B */
+#define AT91SAM9X5_ID_PIOCD	3	/* Parallel I/O Controller C and D */
+#define AT91SAM9X5_ID_SMD	4	/* SMD Soft Modem (SMD) */
+#define AT91SAM9X5_ID_USART0	5	/* USART 0 */
+#define AT91SAM9X5_ID_USART1	6	/* USART 1 */
+#define AT91SAM9X5_ID_USART2	7	/* USART 2 */
+#define AT91SAM9X5_ID_USART3	8	/* USART 3 */
+#define AT91SAM9X5_ID_TWI0	9	/* Two-Wire Interface 0 */
+#define AT91SAM9X5_ID_TWI1	10	/* Two-Wire Interface 1 */
+#define AT91SAM9X5_ID_TWI2	11	/* Two-Wire Interface 2 */
+#define AT91SAM9X5_ID_MCI0	12	/* High Speed Multimedia Card Interface 0 */
+#define AT91SAM9X5_ID_SPI0	13	/* Serial Peripheral Interface 0 */
+#define AT91SAM9X5_ID_SPI1	14	/* Serial Peripheral Interface 1 */
+#define AT91SAM9X5_ID_UART0	15	/* UART 0 */
+#define AT91SAM9X5_ID_UART1	16	/* UART 1 */
+#define AT91SAM9X5_ID_TCB	17	/* Timer Counter 0, 1, 2, 3, 4 and 5 */
+#define AT91SAM9X5_ID_PWM	18	/* Pulse Width Modulation Controller */
+#define AT91SAM9X5_ID_ADC	19	/* ADC Controller */
+#define AT91SAM9X5_ID_DMA0	20	/* DMA Controller 0 */
+#define AT91SAM9X5_ID_DMA1	21	/* DMA Controller 1 */
+#define AT91SAM9X5_ID_UHPHS	22	/* USB Host High Speed */
+#define AT91SAM9X5_ID_UDPHS	23	/* USB Device High Speed */
+#define AT91SAM9X5_ID_EMAC0	24	/* Ethernet MAC0 */
+#define AT91SAM9X5_ID_LCDC	25	/* LCD Controller */
+#define AT91SAM9X5_ID_ISI	25	/* Image Sensor Interface */
+#define AT91SAM9X5_ID_MCI1	26	/* High Speed Multimedia Card Interface 1 */
+#define AT91SAM9X5_ID_EMAC1	27	/* Ethernet MAC1 */
+#define AT91SAM9X5_ID_SSC	28	/* Synchronous Serial Controller */
+#define AT91SAM9X5_ID_CAN0	29	/* CAN Controller 0 */
+#define AT91SAM9X5_ID_CAN1	30	/* CAN Controller 1 */
+#define AT91SAM9X5_ID_IRQ0	31	/* Advanced Interrupt Controller */
+
+/*
+ * User Peripheral physical base addresses.
+ */
+#define AT91SAM9X5_BASE_USART0	0xf801c000
+#define AT91SAM9X5_BASE_USART1	0xf8020000
+#define AT91SAM9X5_BASE_USART2	0xf8024000
+
+/*
+ * System Peripherals (offset from AT91_BASE_SYS)
+ */
+#define AT91_DDRSDRC0	(0xffffe800 - AT91_BASE_SYS)
+#define AT91_PMC	(0xfffffc00 - AT91_BASE_SYS)
+
+/*
+ * Base addresses for early serial code (uncompress.h)
+ */
+#define AT91_DBGU	AT91_BASE_DBGU0
+#define AT91_USART0	AT91SAM9X5_BASE_USART0
+#define AT91_USART1	AT91SAM9X5_BASE_USART1
+#define AT91_USART2	AT91SAM9X5_BASE_USART2
+
+/*
+ * Internal Memory.
+ */
+#define AT91SAM9X5_SRAM_BASE	0x00300000	/* Internal SRAM base address */
+#define AT91SAM9X5_SRAM_SIZE	SZ_32K		/* Internal SRAM size (32Kb) */
+
+#define AT91SAM9X5_ROM_BASE	0x00400000	/* Internal ROM base address */
+#define AT91SAM9X5_ROM_SIZE	SZ_64K		/* Internal ROM size (64Kb) */
+
+#endif
diff --git a/arch/arm/mach-at91/include/mach/at91sam9x5_matrix.h b/arch/arm/mach-at91/include/mach/at91sam9x5_matrix.h
new file mode 100644
index 0000000..a606d39
--- /dev/null
+++ b/arch/arm/mach-at91/include/mach/at91sam9x5_matrix.h
@@ -0,0 +1,53 @@
+/*
+ * Matrix-centric header file for the AT91SAM9x5 family
+ *
+ *  Copyright (C) 2009-2012 Atmel Corporation.
+ *
+ * Only EBI related registers.
+ * Write Protect register definitions may be useful.
+ *
+ * Licensed under GPLv2 or later.
+ */
+
+#ifndef AT91SAM9X5_MATRIX_H
+#define AT91SAM9X5_MATRIX_H
+
+#define AT91_MATRIX_EBICSA	(AT91_MATRIX + 0x120)	/* EBI Chip Select Assignment Register */
+#define		AT91_MATRIX_EBI_CS1A		(1 << 1)	/* Chip Select 1 Assignment */
+#define			AT91_MATRIX_EBI_CS1A_SMC		(0 << 1)
+#define			AT91_MATRIX_EBI_CS1A_SDRAMC		(1 << 1)
+#define		AT91_MATRIX_EBI_CS3A		(1 << 3)	/* Chip Select 3 Assignment */
+#define			AT91_MATRIX_EBI_CS3A_SMC		(0 << 3)
+#define			AT91_MATRIX_EBI_CS3A_SMC_NANDFLASH	(1 << 3)
+#define		AT91_MATRIX_EBI_DBPUC		(1 << 8)	/* Data Bus Pull-up Configuration */
+#define			AT91_MATRIX_EBI_DBPU_ON			(0 << 8)
+#define			AT91_MATRIX_EBI_DBPU_OFF		(1 << 8)
+#define		AT91_MATRIX_EBI_VDDIOMSEL	(1 << 16)	/* Memory voltage selection */
+#define			AT91_MATRIX_EBI_VDDIOMSEL_1_8V		(0 << 16)
+#define			AT91_MATRIX_EBI_VDDIOMSEL_3_3V		(1 << 16)
+#define		AT91_MATRIX_EBI_EBI_IOSR	(1 << 17)	/* EBI I/O slew rate selection */
+#define			AT91_MATRIX_EBI_EBI_IOSR_REDUCED	(0 << 17)
+#define			AT91_MATRIX_EBI_EBI_IOSR_NORMAL		(1 << 17)
+#define		AT91_MATRIX_EBI_DDR_IOSR	(1 << 18)	/* DDR2 dedicated port I/O slew rate selection */
+#define			AT91_MATRIX_EBI_DDR_IOSR_REDUCED	(0 << 18)
+#define			AT91_MATRIX_EBI_DDR_IOSR_NORMAL		(1 << 18)
+#define		AT91_MATRIX_NFD0_SELECT		(1 << 24)	/* NAND Flash Data Bus Selection */
+#define			AT91_MATRIX_NFD0_ON_D0			(0 << 24)
+#define			AT91_MATRIX_NFD0_ON_D16			(1 << 24)
+#define		AT91_MATRIX_DDR_MP_EN		(1 << 25)	/* DDR Multi-port Enable */
+#define			AT91_MATRIX_MP_OFF			(0 << 25)
+#define			AT91_MATRIX_MP_ON			(1 << 25)
+
+#define AT91_MATRIX_WPMR	(AT91_MATRIX + 0x1E4)	/* Write Protect Mode Register */
+#define		AT91_MATRIX_WPMR_WPEN		(1 << 0)	/* Write Protect ENable */
+#define			AT91_MATRIX_WPMR_WP_WPDIS		(0 << 0)
+#define			AT91_MATRIX_WPMR_WP_WPEN		(1 << 0)
+#define		AT91_MATRIX_WPMR_WPKEY		(0xFFFFFF << 8)	/* Write Protect KEY */
+
+#define AT91_MATRIX_WPSR	(AT91_MATRIX + 0x1E8)	/* Write Protect Status Register */
+#define		AT91_MATRIX_WPSR_WPVS		(1 << 0)	/* Write Protect Violation Status */
+#define			AT91_MATRIX_WPSR_NO_WPV		(0 << 0)
+#define			AT91_MATRIX_WPSR_WPV		(1 << 0)
+#define		AT91_MATRIX_WPSR_WPVSRC		(0xFFFF << 8)	/* Write Protect Violation Source */
+
+#endif
-- 
1.7.5.4

