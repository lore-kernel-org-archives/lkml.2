Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab0KLJXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 04:23:47 -0500
Received: from smtp.nokia.com ([147.243.1.47]:58190 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756253Ab0KLJXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 04:23:32 -0500
From: Emeltchenko Andrei <Andrei.Emeltchenko.news@gmail.com>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCHv3 1/4] OMAP: Serial: Define OMAP uart MDR1 register definitions
Date: Fri, 12 Nov 2010 11:21:39 +0200
Message-Id: <1289553702-28041-2-git-send-email-Andrei.Emeltchenko.news@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1289553702-28041-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
References: <1289553702-28041-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>

Define MDR1 register serial definitions used in serial and
bluetooth drivers. Remove magic numbers there.

Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@nokia.com>
---
 include/linux/serial_reg.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/serial_reg.h b/include/linux/serial_reg.h
index c7a0ce1..6f38234 100644
--- a/include/linux/serial_reg.h
+++ b/include/linux/serial_reg.h
@@ -341,5 +341,17 @@
 #define UART_OMAP_SYSS		0x16	/* System status register */
 #define UART_OMAP_WER		0x17	/* Wake-up enable register */
 
+/*
+ * These are the definitions for the MDR1 register
+ */
+#define UART_OMAP_MDR1_16X_MODE		0x00	/* UART 16x mode */
+#define UART_OMAP_MDR1_SIR_MODE		0x01	/* SIR mode */
+#define UART_OMAP_MDR1_16X_ABAUD_MODE	0x02	/* UART 16x auto-baud */
+#define UART_OMAP_MDR1_13X_MODE		0x03	/* UART 13x mode */
+#define UART_OMAP_MDR1_MIR_MODE		0x04	/* MIR mode */
+#define UART_OMAP_MDR1_FIR_MODE		0x05	/* FIR mode */
+#define UART_OMAP_MDR1_CIR_MODE		0x06	/* CIR mode */
+#define UART_OMAP_MDR1_DISABLE		0x07	/* Disable (default state) */
+
 #endif /* _LINUX_SERIAL_REG_H */
 
-- 
1.7.0.4

