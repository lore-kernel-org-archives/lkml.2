Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab1HPAZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 20:25:32 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33289 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab1HPAZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 20:25:29 -0400
From: Akshay Joshi <me@akshayjoshi.com>
To: Pavel Machek <pavel@ucw.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        Pekka Enberg <penberg@kernel.org>, Akshay Joshi <me@akshayjoshi.com>,
        Karthigan Srinivasan <karthigan.srinivasan2@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] Staging: Winbond: Fix pointer style in wb35tx.c.
Date: Mon, 15 Aug 2011 20:24:28 -0400
Message-Id: <1313454275-5604-2-git-send-email-me@akshayjoshi.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1313454275-5604-1-git-send-email-me@akshayjoshi.com>
References: <1313454275-5604-1-git-send-email-me@akshayjoshi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pointers should be prefixed with a single space according to the kernel
coding style.

Signed-off-by: Akshay Joshi <me@akshayjoshi.com>
---
 drivers/staging/winbond/wb35tx.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/winbond/wb35tx.c b/drivers/staging/winbond/wb35tx.c
index 5df39d4..21edbc9 100644
--- a/drivers/staging/winbond/wb35tx.c
+++ b/drivers/staging/winbond/wb35tx.c
@@ -15,7 +15,7 @@
 #include "mds_f.h"
 
 unsigned char
-Wb35Tx_get_tx_buffer(struct hw_data * pHwData, u8 **pBuffer)
+Wb35Tx_get_tx_buffer(struct hw_data *pHwData, u8 **pBuffer)
 {
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 
@@ -25,10 +25,10 @@ Wb35Tx_get_tx_buffer(struct hw_data * pHwData, u8 **pBuffer)
 
 static void Wb35Tx(struct wbsoft_priv *adapter);
 
-static void Wb35Tx_complete(struct urb * pUrb)
+static void Wb35Tx_complete(struct urb *pUrb)
 {
 	struct wbsoft_priv *adapter = pUrb->context;
-	struct hw_data *	pHwData = &adapter->sHwData;
+	struct hw_data *pHwData = &adapter->sHwData;
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 	struct wb35_mds *pMds = &adapter->Mds;
 
@@ -64,7 +64,7 @@ error:
 
 static void Wb35Tx(struct wbsoft_priv *adapter)
 {
-	struct hw_data *	pHwData = &adapter->sHwData;
+	struct hw_data *pHwData = &adapter->sHwData;
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 	u8		*pTxBufferAddress;
 	struct wb35_mds *pMds = &adapter->Mds;
@@ -115,7 +115,7 @@ static void Wb35Tx(struct wbsoft_priv *adapter)
 
 void Wb35Tx_start(struct wbsoft_priv *adapter)
 {
-	struct hw_data * pHwData = &adapter->sHwData;
+	struct hw_data *pHwData = &adapter->sHwData;
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 
 	// Allow only one thread to run into function
@@ -126,7 +126,7 @@ void Wb35Tx_start(struct wbsoft_priv *adapter)
 		atomic_dec(&pWb35Tx->TxFireCounter);
 }
 
-unsigned char Wb35Tx_initial(struct hw_data * pHwData)
+unsigned char Wb35Tx_initial(struct hw_data *pHwData)
 {
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 
@@ -145,7 +145,7 @@ unsigned char Wb35Tx_initial(struct hw_data * pHwData)
 }
 
 //======================================================
-void Wb35Tx_stop(struct hw_data * pHwData)
+void Wb35Tx_stop(struct hw_data *pHwData)
 {
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 
@@ -161,7 +161,7 @@ void Wb35Tx_stop(struct hw_data * pHwData)
 }
 
 //======================================================
-void Wb35Tx_destroy(struct hw_data * pHwData)
+void Wb35Tx_destroy(struct hw_data *pHwData)
 {
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 
@@ -182,7 +182,7 @@ void Wb35Tx_destroy(struct hw_data * pHwData)
 
 void Wb35Tx_CurrentTime(struct wbsoft_priv *adapter, u32 TimeCount)
 {
-	struct hw_data * pHwData = &adapter->sHwData;
+	struct hw_data *pHwData = &adapter->sHwData;
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 	unsigned char Trigger = false;
 
@@ -199,10 +199,10 @@ void Wb35Tx_CurrentTime(struct wbsoft_priv *adapter, u32 TimeCount)
 
 static void Wb35Tx_EP2VM(struct wbsoft_priv *adapter);
 
-static void Wb35Tx_EP2VM_complete(struct urb * pUrb)
+static void Wb35Tx_EP2VM_complete(struct urb *pUrb)
 {
 	struct wbsoft_priv *adapter = pUrb->context;
-	struct hw_data *	pHwData = &adapter->sHwData;
+	struct hw_data *pHwData = &adapter->sHwData;
 	struct T02_descriptor	T02, TSTATUS;
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 	u32 *		pltmp = (u32 *)pWb35Tx->EP2_buf;
@@ -250,7 +250,7 @@ error:
 
 static void Wb35Tx_EP2VM(struct wbsoft_priv *adapter)
 {
-	struct hw_data *	pHwData = &adapter->sHwData;
+	struct hw_data *pHwData = &adapter->sHwData;
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 	struct urb *	pUrb = (struct urb *)pWb35Tx->Tx2Urb;
 	u32 *	pltmp = (u32 *)pWb35Tx->EP2_buf;
@@ -284,7 +284,7 @@ error:
 
 void Wb35Tx_EP2VM_start(struct wbsoft_priv *adapter)
 {
-	struct hw_data * pHwData = &adapter->sHwData;
+	struct hw_data *pHwData = &adapter->sHwData;
 	struct wb35_tx *pWb35Tx = &pHwData->Wb35Tx;
 
 	// Allow only one thread to run into function
-- 
1.7.5.4

