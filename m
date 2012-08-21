Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab2HUMUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 08:20:35 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:52456 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756095Ab2HUMU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 08:20:26 -0400
From: Felipe Balbi <balbi@ti.com>
To: alan@linux.intel.com
Cc: Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        linux-serial@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Shubhrajyoti Datta <shubhrajyoti@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH v2 05/13] serial: add OMAP-specific defines
Date: Tue, 21 Aug 2012 15:16:03 +0300
Message-Id: <1345551371-18862-6-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.12.rc3
In-Reply-To: <1345551371-18862-1-git-send-email-balbi@ti.com>
References: <1345540555-24359-1-git-send-email-balbi@ti.com>
 <1345551371-18862-1-git-send-email-balbi@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP has some extra Interrupt types which can
be really useful for SW. Let's define them
so we can later use those in OMAP's serial driver.

Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 include/linux/serial_reg.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/serial_reg.h b/include/linux/serial_reg.h
index 8ce70d7..5ed325e 100644
--- a/include/linux/serial_reg.h
+++ b/include/linux/serial_reg.h
@@ -40,6 +40,10 @@
 
 #define UART_IIR_BUSY		0x07 /* DesignWare APB Busy Detect */
 
+#define UART_IIR_RX_TIMEOUT	0x0c /* OMAP RX Timeout interrupt */
+#define UART_IIR_XOFF		0x10 /* OMAP XOFF/Special Character */
+#define UART_IIR_CTS_RTS_DSR	0x20 /* OMAP CTS/RTS/DSR Change */
+
 #define UART_FCR	2	/* Out: FIFO Control Register */
 #define UART_FCR_ENABLE_FIFO	0x01 /* Enable the FIFO */
 #define UART_FCR_CLEAR_RCVR	0x02 /* Clear the RCVR FIFO */
-- 
1.7.12.rc3

