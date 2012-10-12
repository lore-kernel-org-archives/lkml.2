Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943Ab2JLQi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 12:38:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50829 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759867Ab2JLQiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 12:38:55 -0400
From: Adil Mujeeb <mujeeb.adil@gmail.com>
To: pavel@ucw.cz
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Adil Mujeeb <mujeeb.adil@gmail.com>
Subject: [PATCH 9/9] Staging: winbond: wb35tx_s: Fixed coding style issues
Date: Fri, 12 Oct 2012 22:07:15 +0530
Message-Id: <1350059835-5408-10-git-send-email-mujeeb.adil@gmail.com>
X-Mailer: git-send-email 1.7.6.msysgit.0
In-Reply-To: <1350059835-5408-1-git-send-email-mujeeb.adil@gmail.com>
References: <1350059835-5408-1-git-send-email-mujeeb.adil@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed most of the checkpatch.pl reported ERRORs and WARNINGs.
Some "line over 80 characters" warning left.

Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
---
 linux-3.6-rc7/drivers/staging/winbond/wb35tx_s.h |   49 +++++++++------------
 1 files changed, 21 insertions(+), 28 deletions(-)

diff --git a/linux-3.6-rc7/drivers/staging/winbond/wb35tx_s.h b/linux-3.6-rc7/drivers/staging/winbond/wb35tx_s.h
index f70f433..02a1f27 100644
--- a/linux-3.6-rc7/drivers/staging/winbond/wb35tx_s.h
+++ b/linux-3.6-rc7/drivers/staging/winbond/wb35tx_s.h
@@ -3,45 +3,38 @@
 
 #include "mds_s.h"
 
-//====================================
-// IS89C35 Tx related definition
-//====================================
-#define TX_INTERFACE			0	// Interface 1
-#define TX_PIPE					3	// endpoint 4
-#define TX_INTERRUPT			1	// endpoint 2
-#define MAX_INTERRUPT_LENGTH	64	// It must be 64 for EP2 hardware
-
-
-
-//====================================
-// Internal variable for module
-//====================================
+/* IS89C35 Tx related definition */
+#define TX_INTERFACE		0	/* Interface 1 */
+#define TX_PIPE			3	/* endpoint 4 */
+#define TX_INTERRUPT		1	/* endpoint 2 */
+#define MAX_INTERRUPT_LENGTH	64	/* It must be 64 for EP2 hardware */
 
+/* Internal variable for module */
 
 struct wb35_tx {
-	// For Tx buffer
-	u8	TxBuffer[ MAX_USB_TX_BUFFER_NUMBER ][ MAX_USB_TX_BUFFER ];
+	/* For Tx buffer */
+	u8		TxBuffer[MAX_USB_TX_BUFFER_NUMBER][MAX_USB_TX_BUFFER];
 
-	// For Interrupt pipe
-	u8	EP2_buf[MAX_INTERRUPT_LENGTH];
+	/* For Interrupt pipe */
+	u8		EP2_buf[MAX_INTERRUPT_LENGTH];
 
-	atomic_t	TxResultCount;// For thread control of EP2 931130.4.m
-	atomic_t	TxFireCounter;// For thread control of EP4 931130.4.n
-	u32			ByteTransfer;
+	atomic_t	TxResultCount; /* For thread control of EP2 931130.4.m */
+	atomic_t	TxFireCounter; /* For thread control of EP4 931130.4.n */
+	u32		ByteTransfer;
 
-	u32	    TxSendIndex;// The next index of Mds array to be sent
-	u32	    EP2vm_state; // for EP2vm state
-	u32	    EP4vm_state; // for EP4vm state
-	u32	    tx_halt; // Stopping VM
+	u32		TxSendIndex; /* next index of Mds array to be sent */
+	u32		EP2vm_state; /* for EP2vm state */
+	u32		EP4vm_state; /* for EP4vm state */
+	u32		tx_halt; /* Stopping VM */
 
-	struct urb *				Tx4Urb;
-	struct urb *				Tx2Urb;
+	struct urb	*Tx4Urb;
+	struct urb	*Tx2Urb;
 
 	int		EP2VM_status;
 	int		EP4VM_status;
 
-	u32	TxFillCount; // 20060928
-	u32	TxTimer; // 20060928 Add if sending packet not great than 13
+	u32		TxFillCount; /* 20060928 */
+	u32		TxTimer; /* 20060928 Add if sending packet not great than 13 */
 };
 
 #endif
-- 
1.7.7.3

