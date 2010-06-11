Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186Ab0FKKRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 06:17:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37033 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760155Ab0FKKRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 06:17:23 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/10] staging/trivial: fix typos concerning "initiali[zs]e"
Date: Fri, 11 Jun 2010 12:17:03 +0200
Message-Id: <1276251424-12806-9-git-send-email-u.kleine-koenig@pengutronix.de>
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

Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/staging/comedi/drivers/usbdux.c  |    2 +-
 drivers/staging/octeon/cvmx-cmd-queue.c  |    6 +++---
 drivers/staging/pohmelfs/inode.c         |    2 +-
 drivers/staging/rt2860/common/cmm_wpa.c  |    4 ++--
 drivers/staging/rtl8192e/r8190_rtl8256.c |    6 +++---
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 27b4cb2..7b8a2da 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -2085,7 +2085,7 @@ static int usbdux_pwm_start(struct comedi_device *dev,
 	if (ret < 0)
 		return ret;
 
-	/* initalise the buffer */
+	/* initialise the buffer */
 	for (i = 0; i < this_usbduxsub->sizePwmBuf; i++)
 		((char *)(this_usbduxsub->urbPwm->transfer_buffer))[i] = 0;
 
diff --git a/drivers/staging/octeon/cvmx-cmd-queue.c b/drivers/staging/octeon/cvmx-cmd-queue.c
index 976227b..e9809d3 100644
--- a/drivers/staging/octeon/cvmx-cmd-queue.c
+++ b/drivers/staging/octeon/cvmx-cmd-queue.c
@@ -140,21 +140,21 @@ cvmx_cmd_queue_result_t cvmx_cmd_queue_initialize(cvmx_cmd_queue_id_t queue_id,
 	if (qstate->base_ptr_div128) {
 		if (max_depth != (int)qstate->max_depth) {
 			cvmx_dprintf("ERROR: cvmx_cmd_queue_initialize: "
-				"Queue already initalized with different "
+				"Queue already initialized with different "
 				"max_depth (%d).\n",
 			     (int)qstate->max_depth);
 			return CVMX_CMD_QUEUE_INVALID_PARAM;
 		}
 		if (fpa_pool != qstate->fpa_pool) {
 			cvmx_dprintf("ERROR: cvmx_cmd_queue_initialize: "
-				"Queue already initalized with different "
+				"Queue already initialized with different "
 				"FPA pool (%u).\n",
 			     qstate->fpa_pool);
 			return CVMX_CMD_QUEUE_INVALID_PARAM;
 		}
 		if ((pool_size >> 3) - 1 != qstate->pool_size_m1) {
 			cvmx_dprintf("ERROR: cvmx_cmd_queue_initialize: "
-				"Queue already initalized with different "
+				"Queue already initialized with different "
 				"FPA pool size (%u).\n",
 			     (qstate->pool_size_m1 + 1) << 3);
 			return CVMX_CMD_QUEUE_INVALID_PARAM;
diff --git a/drivers/staging/pohmelfs/inode.c b/drivers/staging/pohmelfs/inode.c
index 643b413..e3f95f7 100644
--- a/drivers/staging/pohmelfs/inode.c
+++ b/drivers/staging/pohmelfs/inode.c
@@ -847,7 +847,7 @@ static void pohmelfs_destroy_inode(struct inode *inode)
 }
 
 /*
- * ->alloc_inode() callback. Allocates inode and initilizes private data.
+ * ->alloc_inode() callback. Allocates inode and initializes private data.
  */
 static struct inode *pohmelfs_alloc_inode(struct super_block *sb)
 {
diff --git a/drivers/staging/rt2860/common/cmm_wpa.c b/drivers/staging/rt2860/common/cmm_wpa.c
index c16f376..9414aa3 100644
--- a/drivers/staging/rt2860/common/cmm_wpa.c
+++ b/drivers/staging/rt2860/common/cmm_wpa.c
@@ -427,7 +427,7 @@ void RTMPToWirelessSta(struct rt_rtmp_adapter *pAd,
 /*
     ==========================================================================
     Description:
-        This is a function to initilize 4-way handshake
+        This is a function to initialize 4-way handshake
 
     Return:
 
@@ -867,7 +867,7 @@ void PeerPairMsg3Action(struct rt_rtmp_adapter *pAd,
     ==========================================================================
     Description:
         When receiving the last packet of 4-way pairwisekey handshake.
-        Initilize 2-way groupkey handshake following.
+        Initialize 2-way groupkey handshake following.
     Return:
     ==========================================================================
 */
diff --git a/drivers/staging/rtl8192e/r8190_rtl8256.c b/drivers/staging/rtl8192e/r8190_rtl8256.c
index 7391f5f..8bd5b17 100644
--- a/drivers/staging/rtl8192e/r8190_rtl8256.c
+++ b/drivers/staging/rtl8192e/r8190_rtl8256.c
@@ -501,13 +501,13 @@ SetRFPowerState8190(
 				if((priv->ieee80211->eRFPowerState == eRfOff) && RT_IN_PS_LEVEL(pPSC, RT_RF_OFF_LEVL_HALT_NIC))
 				{ // The current RF state is OFF and the RF OFF level is halting the NIC, re-initialize the NIC.
 					bool rtstatus = true;
-					u32 InitilizeCount = 3;
+					u32 InitializeCount = 3;
 					do
 					{
-						InitilizeCount--;
+						InitializeCount--;
 						priv->RegRfOff = false;
 						rtstatus = NicIFEnableNIC(dev);
-					}while( (rtstatus != true) &&(InitilizeCount >0) );
+					}while( (rtstatus != true) &&(InitializeCount >0) );
 
 					if(rtstatus != true)
 					{
-- 
1.7.1

