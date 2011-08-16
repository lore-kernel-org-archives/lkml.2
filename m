Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab1HPAZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 20:25:49 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50607 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab1HPAZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 20:25:46 -0400
From: Akshay Joshi <me@akshayjoshi.com>
To: Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        Pekka Enberg <penberg@kernel.org>, Akshay Joshi <me@akshayjoshi.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Karthigan Srinivasan <karthigan.srinivasan2@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] Staging: Winbond: Fix spacing issues for spaces before tabs.
Date: Mon, 15 Aug 2011 20:24:31 -0400
Message-Id: <1313454275-5604-5-git-send-email-me@akshayjoshi.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313454275-5604-1-git-send-email-me@akshayjoshi.com>
References: <1313454275-5604-1-git-send-email-me@akshayjoshi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the spaces-before-tabs issues that occur within the Winbond driver
code.

Signed-off-by: Akshay Joshi <me@akshayjoshi.com>
---
 drivers/staging/winbond/wb35reg.c   |    2 +-
 drivers/staging/winbond/wb35reg_s.h |    2 +-
 drivers/staging/winbond/wb35rx_f.h  |    6 +++---
 drivers/staging/winbond/wb35rx_s.h  |    6 +++---
 drivers/staging/winbond/wb35tx.c    |    2 +-
 drivers/staging/winbond/wb35tx_s.h  |    2 +-
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/winbond/wb35reg.c b/drivers/staging/winbond/wb35reg.c
index 742636c..f2a411f 100644
--- a/drivers/staging/winbond/wb35reg.c
+++ b/drivers/staging/winbond/wb35reg.c
@@ -69,7 +69,7 @@ unsigned char Wb35Reg_BurstWrite(struct hw_data *pHwData, u16 RegisterNo, u32 *p
 		kfree(reg_queue);
 		return false;
 	}
-   return false;
+	return false;
 }
 
 void Wb35Reg_Update(struct hw_data *pHwData,  u16 RegisterNo,  u32 RegisterValue)
diff --git a/drivers/staging/winbond/wb35reg_s.h b/drivers/staging/winbond/wb35reg_s.h
index dc79faa..cdbbf35 100644
--- a/drivers/staging/winbond/wb35reg_s.h
+++ b/drivers/staging/winbond/wb35reg_s.h
@@ -12,7 +12,7 @@ struct hw_data;
  *			HAL setting function
  *
  *		========================================
- *		|Uxx| 	|Dxx|	|Mxx|	|BB|	|RF|
+ *		|Uxx|	|Dxx|	|Mxx|	|BB|	|RF|
  *		========================================
  *			|					|
  *		Wb35Reg_Read		Wb35Reg_Write
diff --git a/drivers/staging/winbond/wb35rx_f.h b/drivers/staging/winbond/wb35rx_f.h
index bb408e9..4efc790 100644
--- a/drivers/staging/winbond/wb35rx_f.h
+++ b/drivers/staging/winbond/wb35rx_f.h
@@ -7,9 +7,9 @@
 /*
  * Interface function declare
  */
-unsigned char		Wb35Rx_initial(  struct hw_data * pHwData );
-void		Wb35Rx_destroy(  struct hw_data * pHwData );
-void		Wb35Rx_stop(  struct hw_data * pHwData );
+unsigned char		Wb35Rx_initial(struct hw_data *pHwData);
+void		Wb35Rx_destroy(struct hw_data * pHwData);
+void		Wb35Rx_stop(struct hw_data * pHwData);
 void		Wb35Rx_start(struct ieee80211_hw *hw);
 
 #endif
diff --git a/drivers/staging/winbond/wb35rx_s.h b/drivers/staging/winbond/wb35rx_s.h
index c896337..949e4f5 100644
--- a/drivers/staging/winbond/wb35rx_s.h
+++ b/drivers/staging/winbond/wb35rx_s.h
@@ -18,10 +18,10 @@ struct wb35_rx {
 	u32			ByteReceived;/* For calculating throughput of BulkIn */
 	atomic_t		RxFireCounter;/* Does Wb35Rx module fire? */
 
-	u8	RxBuffer[ MAX_USB_RX_BUFFER_NUMBER ][ ((MAX_USB_RX_BUFFER+3) & ~0x03 ) ];
+	u8	RxBuffer[MAX_USB_RX_BUFFER_NUMBER][((MAX_USB_RX_BUFFER+3) & ~0x03)];
 	/* Ownership of buffer  0: SW 1:HW */
-	u16	RxBufferSize[ ((MAX_USB_RX_BUFFER_NUMBER+1) & ~0x01) ];
-	u8	RxOwner[ ((MAX_USB_RX_BUFFER_NUMBER+3) & ~0x03 ) ];
+	u16	RxBufferSize[((MAX_USB_RX_BUFFER_NUMBER+1) & ~0x01)];
+	u8	RxOwner[((MAX_USB_RX_BUFFER_NUMBER+3) & ~0x03)];
 	u32	RxProcessIndex; /* The next index to process */
 	u32	RxBufferId;
 	u32	EP3vm_state;
diff --git a/drivers/staging/winbond/wb35tx.c b/drivers/staging/winbond/wb35tx.c
index a8dd4c9..a06212a 100644
--- a/drivers/staging/winbond/wb35tx.c
+++ b/drivers/staging/winbond/wb35tx.c
@@ -71,7 +71,7 @@ static void Wb35Tx(struct wbsoft_priv *adapter)
 	u8		*pTxBufferAddress;
 	struct wb35_mds *pMds = &adapter->Mds;
 	struct urb *	pUrb = (struct urb *)pWb35Tx->Tx4Urb;
-	int         	retv;
+	int		retv;
 	u32		SendIndex;
 
 
diff --git a/drivers/staging/winbond/wb35tx_s.h b/drivers/staging/winbond/wb35tx_s.h
index 1befbcb..83b4b0f 100644
--- a/drivers/staging/winbond/wb35tx_s.h
+++ b/drivers/staging/winbond/wb35tx_s.h
@@ -17,7 +17,7 @@
 
 struct wb35_tx {
 	/* For Tx buffer */
-	u8	TxBuffer[ MAX_USB_TX_BUFFER_NUMBER ][ MAX_USB_TX_BUFFER ];
+	u8	TxBuffer[MAX_USB_TX_BUFFER_NUMBER][MAX_USB_TX_BUFFER];
 
 	/* For Interrupt pipe */
 	u8	EP2_buf[MAX_INTERRUPT_LENGTH];
-- 
1.7.5.4

