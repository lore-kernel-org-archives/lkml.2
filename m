Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab0C1Rat (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 13:30:49 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:46546 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754681Ab0C1Ras (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 13:30:48 -0400
From: Gilles Espinasse <g.esp@free.fr>
To: jkosina@suse.cz
Cc: linux-kernel@vger.kernel.org, Gilles Espinasse <g.esp@free.fr>
Subject: [PATCH] Fix requr and fragement in comments
Date: Sun, 28 Mar 2010 19:30:36 +0200
Message-Id: <1269797436-4759-1-git-send-email-g.esp@free.fr>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Gilles Espinasse <g.esp@free.fr>
---
 drivers/staging/vt6655/rxtx.c |   14 +++++++-------
 drivers/staging/vt6656/rxtx.c |    6 +++---
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/vt6655/rxtx.c b/drivers/staging/vt6655/rxtx.c
index ed3070e..4fcc435 100644
--- a/drivers/staging/vt6655/rxtx.c
+++ b/drivers/staging/vt6655/rxtx.c
@@ -25,19 +25,19 @@
  * Date: May 20, 2003
  *
  * Functions:
- *      s_vGenerateTxParameter - Generate tx dma requried parameter.
+ *      s_vGenerateTxParameter - Generate tx dma required parameter.
  *      vGenerateMACHeader - Translate 802.3 to 802.11 header
- *      cbGetFragCount - Caculate fragement number count
+ *      cbGetFragCount - Caculate fragment number count
  *      csBeacon_xmit - beacon tx function
  *      csMgmt_xmit - management tx function
  *      s_cbFillTxBufHead - fulfill tx dma buffer header
  *      s_uGetDataDuration - get tx data required duration
  *      s_uFillDataHead- fulfill tx data duration header
- *      s_uGetRTSCTSDuration- get rtx/cts requried duration
+ *      s_uGetRTSCTSDuration- get rtx/cts required duration
  *      s_uGetRTSCTSRsvTime- get rts/cts reserved time
  *      s_uGetTxRsvTime- get frame reserved time
  *      s_vFillCTSHead- fulfill CTS ctl header
- *      s_vFillFragParameter- Set fragement ctl parameter.
+ *      s_vFillFragParameter- Set fragment ctl parameter.
  *      s_vFillRTSHead- fulfill RTS ctl header
  *      s_vFillTxKey- fulfill tx encrypt key
  *      s_vSWencryption- Software encrypt header
@@ -877,7 +877,7 @@ s_vFillRTSHead (
     }
 
     // Note: So far RTSHead dosen't appear in ATIM & Beacom DMA, so we don't need to take them into account.
-    //       Otherwise, we need to modified codes for them.
+    //       Otherwise, we need to modify codes for them.
     if (byPktType == PK_TYPE_11GB || byPktType == PK_TYPE_11GA) {
         if (byFBOption == AUTO_FB_NONE) {
             PSRTS_g pBuf = (PSRTS_g)pvRTS;
@@ -1133,7 +1133,7 @@ s_vFillCTSHead (
  *
  * Parameters:
  *  In:
- *      pDevice         - Pointer to adpater
+ *      pDevice         - Pointer to adapter
  *      pTxDataHead     - Transmit Data Buffer
  *      pTxBufHead      - pTxBufHead
  *      pvRrvTime        - pvRrvTime
@@ -2252,7 +2252,7 @@ vGenerateFIFOHeader (
  *
  * Parameters:
  *  In:
- *      pDevice         - Pointer to adpater
+ *      pDevice         - Pointer to adapter
  *      dwTxBufferAddr  - Transmit Buffer
  *      pPacket         - Packet from upper layer
  *      cbPacketSize    - Transmit Data Length
diff --git a/drivers/staging/vt6656/rxtx.c b/drivers/staging/vt6656/rxtx.c
index d9fa36c..a2ce6fa 100644
--- a/drivers/staging/vt6656/rxtx.c
+++ b/drivers/staging/vt6656/rxtx.c
@@ -25,17 +25,17 @@
  * Date: May 20, 2003
  *
  * Functions:
- *      s_vGenerateTxParameter - Generate tx dma requried parameter.
+ *      s_vGenerateTxParameter - Generate tx dma required parameter.
  *      s_vGenerateMACHeader - Translate 802.3 to 802.11 header
  *      csBeacon_xmit - beacon tx function
  *      csMgmt_xmit - management tx function
  *      s_uGetDataDuration - get tx data required duration
  *      s_uFillDataHead- fulfill tx data duration header
- *      s_uGetRTSCTSDuration- get rtx/cts requried duration
+ *      s_uGetRTSCTSDuration- get rtx/cts required duration
  *      s_uGetRTSCTSRsvTime- get rts/cts reserved time
  *      s_uGetTxRsvTime- get frame reserved time
  *      s_vFillCTSHead- fulfill CTS ctl header
- *      s_vFillFragParameter- Set fragement ctl parameter.
+ *      s_vFillFragParameter- Set fragment ctl parameter.
  *      s_vFillRTSHead- fulfill RTS ctl header
  *      s_vFillTxKey- fulfill tx encrypt key
  *      s_vSWencryption- Software encrypt header
-- 
1.6.4.4

