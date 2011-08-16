Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab1HPAZx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 20:25:53 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40180 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab1HPAZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 20:25:50 -0400
From: Akshay Joshi <me@akshayjoshi.com>
To: Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        Akshay Joshi <me@akshayjoshi.com>, Pekka Enberg <penberg@kernel.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] Staging: Winbond: Remove spacing issues related to pointers.
Date: Mon, 15 Aug 2011 20:24:32 -0400
Message-Id: <1313454275-5604-6-git-send-email-me@akshayjoshi.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313454275-5604-1-git-send-email-me@akshayjoshi.com>
References: <1313454275-5604-1-git-send-email-me@akshayjoshi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch ensures that spacing around pointers is consistent and
follows the kernel coding style.

Signed-off-by: Akshay Joshi <me@akshayjoshi.com>
---
 drivers/staging/winbond/wb35rx_f.h |    4 ++--
 drivers/staging/winbond/wb35rx_s.h |    4 ++--
 drivers/staging/winbond/wb35tx_s.h |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/winbond/wb35rx_f.h b/drivers/staging/winbond/wb35rx_f.h
index 4efc790..8f51136 100644
--- a/drivers/staging/winbond/wb35rx_f.h
+++ b/drivers/staging/winbond/wb35rx_f.h
@@ -8,8 +8,8 @@
  * Interface function declare
  */
 unsigned char		Wb35Rx_initial(struct hw_data *pHwData);
-void		Wb35Rx_destroy(struct hw_data * pHwData);
-void		Wb35Rx_stop(struct hw_data * pHwData);
+void		Wb35Rx_destroy(struct hw_data *pHwData);
+void		Wb35Rx_stop(struct hw_data *pHwData);
 void		Wb35Rx_start(struct ieee80211_hw *hw);
 
 #endif
diff --git a/drivers/staging/winbond/wb35rx_s.h b/drivers/staging/winbond/wb35rx_s.h
index 949e4f5..e99475db 100644
--- a/drivers/staging/winbond/wb35rx_s.h
+++ b/drivers/staging/winbond/wb35rx_s.h
@@ -35,9 +35,9 @@ struct wb35_rx {
 	u32	Rx3UrbCancel;
 
 	u32	LastR1; /* For RSSI reporting */
-	struct urb *				RxUrb;
+	struct urb *RxUrb;
 	u32		Ep3ErrorCount2; /* 20060625.1 Usbd for Rx DMA error count */
 
 	int		EP3VM_status;
-	u8 *	pDRx;
+	u8 *pDRx;
 };
diff --git a/drivers/staging/winbond/wb35tx_s.h b/drivers/staging/winbond/wb35tx_s.h
index 83b4b0f..fda18d6 100644
--- a/drivers/staging/winbond/wb35tx_s.h
+++ b/drivers/staging/winbond/wb35tx_s.h
@@ -31,8 +31,8 @@ struct wb35_tx {
 	u32	    EP4vm_state; /* for EP4vm state */
 	u32	    tx_halt; /* Stopping VM */
 
-	struct urb *				Tx4Urb;
-	struct urb *				Tx2Urb;
+	struct urb *Tx4Urb;
+	struct urb *Tx2Urb;
 
 	int		EP2VM_status;
 	int		EP4VM_status;
-- 
1.7.5.4

