Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760206Ab0FKKSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 06:18:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37013 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758044Ab0FKKRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 06:17:15 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 08/10] trivial: fix typos concerning "precedence"
Date: Fri, 11 Jun 2010 12:17:02 +0200
Message-Id: <1276251424-12806-8-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100611101624.GD10894@pengutronix.de>
References: <20100611101624.GD10894@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 arch/sh/kernel/clkdev.c                  |    2 +-
 drivers/staging/comedi/drivers/usbdux.c  |    2 +-
 drivers/staging/octeon/cvmx-cmd-queue.c  |    6 +++---
 drivers/staging/pohmelfs/inode.c         |    2 +-
 drivers/staging/rt2860/common/cmm_wpa.c  |    4 ++--
 drivers/staging/rtl8192e/r8190_rtl8256.c |    6 +++---
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/sh/kernel/clkdev.c b/arch/sh/kernel/clkdev.c
index defdd6e..befc255 100644
--- a/arch/sh/kernel/clkdev.c
+++ b/arch/sh/kernel/clkdev.c
@@ -36,7 +36,7 @@ static DEFINE_MUTEX(clocks_mutex);
  *  If an entry has a device ID, it must match
  *  If an entry has a connection ID, it must match
  * Then we take the most specific entry - with the following
- * order of precidence: dev+con > dev only > con only.
+ * order of precedence: dev+con > dev only > con only.
  */
 static struct clk *clk_find(const char *dev_id, const char *con_id)
 {
diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 7b8a2da..27b4cb2 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -2085,7 +2085,7 @@ static int usbdux_pwm_start(struct comedi_device *dev,
 	if (ret < 0)
 		return ret;
 
-	/* initialise the buffer */
+	/* initalise the buffer */
 	for (i = 0; i < this_usbduxsub->sizePwmBuf; i++)
 		((char *)(this_usbduxsub->urbPwm->transfer_buffer))[i] = 0;
 
diff --git a/drivers/staging/octeon/cvmx-cmd-queue.c b/drivers/staging/octeon/cvmx-cmd-queue.c
index e9809d3..976227b 100644
--- a/drivers/staging/octeon/cvmx-cmd-queue.c
+++ b/drivers/staging/octeon/cvmx-cmd-queue.c
@@ -140,21 +140,21 @@ cvmx_cmd_queue_result_t cvmx_cmd_queue_initialize(cvmx_cmd_queue_id_t queue_id,
 	if (qstate->base_ptr_div128) {
 		if (max_depth != (int)qstate->max_depth) {
 			cvmx_dprintf("ERROR: cvmx_cmd_queue_initialize: "
-				"Queue already initialized with different "
+				"Queue already initalized with different "
 				"max_depth (%d).\n",
 			     (int)qstate->max_depth);
 			return CVMX_CMD_QUEUE_INVALID_PARAM;
 		}
 		if (fpa_pool != qstate->fpa_pool) {
 			cvmx_dprintf("ERROR: cvmx_cmd_queue_initialize: "
-				"Queue already initialized with different "
+				"Queue already initalized with different "
 				"FPA pool (%u).\n",
 			     qstate->fpa_pool);
 			return CVMX_CMD_QUEUE_INVALID_PARAM;
 		}
 		if ((pool_size >> 3) - 1 != qstate->pool_size_m1) {
 			cvmx_dprintf("ERROR: cvmx_cmd_queue_initialize: "
-				"Queue already initialized with different "
+				"Queue already initalized with different "
 				"FPA pool size (%u).\n",
 			     (qstate->pool_size_m1 + 1) << 3);
 			return CVMX_CMD_QUEUE_INVALID_PARAM;
diff --git a/drivers/staging/pohmelfs/inode.c b/drivers/staging/pohmelfs/inode.c
index e3f95f7..643b413 100644
--- a/drivers/staging/pohmelfs/inode.c
+++ b/drivers/staging/pohmelfs/inode.c
@@ -847,7 +847,7 @@ static void pohmelfs_destroy_inode(struct inode *inode)
 }
 
 /*
- * ->alloc_inode() callback. Allocates inode and initializes private data.
+ * ->alloc_inode() callback. Allocates inode and initilizes private data.
  */
 static struct inode *pohmelfs_alloc_inode(struct super_block *sb)
 {
diff --git a/drivers/staging/rt2860/common/cmm_wpa.c b/drivers/staging/rt2860/common/cmm_wpa.c
index 9414aa3..c16f376 100644
--- a/drivers/staging/rt2860/common/cmm_wpa.c
+++ b/drivers/staging/rt2860/common/cmm_wpa.c
@@ -427,7 +427,7 @@ void RTMPToWirelessSta(struct rt_rtmp_adapter *pAd,
 /*
     ==========================================================================
     Description:
-        This is a function to initialize 4-way handshake
+        This is a function to initilize 4-way handshake
 
     Return:
 
@@ -867,7 +867,7 @@ void PeerPairMsg3Action(struct rt_rtmp_adapter *pAd,
     ==========================================================================
     Description:
         When receiving the last packet of 4-way pairwisekey handshake.
-        Initialize 2-way groupkey handshake following.
+        Initilize 2-way groupkey handshake following.
     Return:
     ==========================================================================
 */
diff --git a/drivers/staging/rtl8192e/r8190_rtl8256.c b/drivers/staging/rtl8192e/r8190_rtl8256.c
index 8bd5b17..7391f5f 100644
--- a/drivers/staging/rtl8192e/r8190_rtl8256.c
+++ b/drivers/staging/rtl8192e/r8190_rtl8256.c
@@ -501,13 +501,13 @@ SetRFPowerState8190(
 				if((priv->ieee80211->eRFPowerState == eRfOff) && RT_IN_PS_LEVEL(pPSC, RT_RF_OFF_LEVL_HALT_NIC))
 				{ // The current RF state is OFF and the RF OFF level is halting the NIC, re-initialize the NIC.
 					bool rtstatus = true;
-					u32 InitializeCount = 3;
+					u32 InitilizeCount = 3;
 					do
 					{
-						InitializeCount--;
+						InitilizeCount--;
 						priv->RegRfOff = false;
 						rtstatus = NicIFEnableNIC(dev);
-					}while( (rtstatus != true) &&(InitializeCount >0) );
+					}while( (rtstatus != true) &&(InitilizeCount >0) );
 
 					if(rtstatus != true)
 					{
-- 
1.7.1

