Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935018Ab0EZXld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:41:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43136 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934981Ab0EZXlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:41:14 -0400
From: Mike Sheldon <mike@mikeasoft.com>
To: greg@kroah.com, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Sheldon <mike@mikeasoft.com>
Subject: [PATCH 11/15] Staging: winbond: Fix spacing around brackets and pointers.
Date: Thu, 27 May 2010 00:39:48 +0100
Message-Id: <1274917192-16962-11-git-send-email-mike@mikeasoft.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
References: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches wb35rx_s.h to correct the spacing around brackets and pointers as reported by checkpatch.pl

Signed-off-by: Mike Sheldon <mike@mikeasoft.com>
---
 drivers/staging/winbond/wb35rx_s.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/winbond/wb35rx_s.h b/drivers/staging/winbond/wb35rx_s.h
index 4b03274..7230a44 100644
--- a/drivers/staging/winbond/wb35rx_s.h
+++ b/drivers/staging/winbond/wb35rx_s.h
@@ -19,9 +19,9 @@ struct wb35_rx {
 	u32			ByteReceived;// For calculating throughput of BulkIn
 	atomic_t		RxFireCounter;// Does Wb35Rx module fire?
 
-	u8	RxBuffer[ MAX_USB_RX_BUFFER_NUMBER ][ ((MAX_USB_RX_BUFFER+3) & ~0x03 ) ];
-	u16	RxBufferSize[ ((MAX_USB_RX_BUFFER_NUMBER+1) & ~0x01) ];
-	u8	RxOwner[ ((MAX_USB_RX_BUFFER_NUMBER+3) & ~0x03 ) ];//Ownership of buffer  0: SW 1:HW
+	u8	RxBuffer[MAX_USB_RX_BUFFER_NUMBER][((MAX_USB_RX_BUFFER+3) & ~0x03)];
+	u16	RxBufferSize[((MAX_USB_RX_BUFFER_NUMBER+1) & ~0x01)];
+	u8	RxOwner[((MAX_USB_RX_BUFFER_NUMBER+3) & ~0x03)];//Ownership of buffer  0: SW 1:HW
 
 	u32	RxProcessIndex;//The next index to process
 	u32	RxBufferId;
@@ -36,9 +36,9 @@ struct wb35_rx {
 	u32	Rx3UrbCancel;
 
 	u32	LastR1; // For RSSI reporting
-	struct urb *				RxUrb;
+	struct urb	*RxUrb;
 	u32		Ep3ErrorCount2; // 20060625.1 Usbd for Rx DMA error count
 
 	int		EP3VM_status;
-	u8 *	pDRx;
+	u8	*pDRx;
 };
-- 
1.7.0.4

