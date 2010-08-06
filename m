Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965471Ab0HFTLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:11:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:49970 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935057Ab0HFTLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:11:32 -0400
From: Stefan Weil <weil@mail.berlios.de>
To: Jiri Kosina <trivial@kernel.org>
Cc: Stefan Weil <weil@mail.berlios.de>, Jiri Kosina <trivial@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Fix spelling fuction -> function in comments
Date: Fri,  6 Aug 2010 21:11:15 +0200
Message-Id: <1281121875-3577-1-git-send-email-weil@mail.berlios.de>
X-Mailer: git-send-email 1.7.1
X-Provags-ID: V02:K0:F2dItdOXgvHpuKQIAVngU/c6zul8uvjpFbBvVLVTEN5
 3jA37ViMBUp3+cS8pCcu9FjECnIkK0qr7uP33PbLewT0jV50aA
 WK2TXMmuCyFi1TDanVMcGSOtjz2AS9jgd/F32If6WbVIEutcgK
 bTQvH8iPNlBlSFAPeJKsTy+XwJDICqKZMJv3FegpJ/NwEOyszY
 Udu5E8j5YCNjbrscU0l0diKxnjOdiAYaGaQnzO8Kw8L0TlZ1gQ
 NI5Uz3DCaHqC8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid more patches, I also fixed other spelling
and grammar bugs when they were in the same or
following line:

successfull -> successful
parse -> parses
controler -> controller
controlers -> controllers

Cc: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Stefan Weil <weil@mail.berlios.de>
---
 arch/blackfin/mach-bf527/boards/ezkit.c            |    2 +-
 arch/blackfin/mach-bf537/boards/stamp.c            |    2 +-
 arch/xtensa/include/asm/uaccess.h                  |    2 +-
 block/blk-core.c                                   |    2 +-
 drivers/base/core.c                                |    2 +-
 drivers/media/video/zoran/videocodec.h             |    2 +-
 drivers/net/depca.c                                |    2 +-
 drivers/net/igb/igb_main.c                         |    2 +-
 drivers/net/skfp/hwt.c                             |    2 +-
 drivers/net/skfp/skfddi.c                          |    2 +-
 drivers/s390/block/dasd_3990_erp.c                 |    2 +-
 drivers/s390/char/tape_3590.c                      |    6 +++---
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |    2 +-
 .../rtl8187se/ieee80211/ieee80211_softmac.c        |    4 ++--
 .../staging/rtl8192e/ieee80211/ieee80211_softmac.c |    2 +-
 .../rtl8192su/ieee80211/ieee80211_softmac.c        |    2 +-
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |    2 +-
 drivers/usb/host/imx21-hcd.c                       |    4 ++--
 net/mac80211/mesh.h                                |    2 +-
 19 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/blackfin/mach-bf527/boards/ezkit.c b/arch/blackfin/mach-bf527/boards/ezkit.c
index a05c967..b182afb 100644
--- a/arch/blackfin/mach-bf527/boards/ezkit.c
+++ b/arch/blackfin/mach-bf527/boards/ezkit.c
@@ -884,7 +884,7 @@ static struct adp5520_keys_platform_data adp5520_keys_data = {
 };
 
 	/*
-	 *  ADP5520/5501 Multifuction Device Init Data
+	 *  ADP5520/5501 Multifunction Device Init Data
 	 */
 
 static struct adp5520_platform_data adp5520_pdev_data = {
diff --git a/arch/blackfin/mach-bf537/boards/stamp.c b/arch/blackfin/mach-bf537/boards/stamp.c
index 9eaf5b0..b342e1d 100644
--- a/arch/blackfin/mach-bf537/boards/stamp.c
+++ b/arch/blackfin/mach-bf537/boards/stamp.c
@@ -1644,7 +1644,7 @@ static struct adp5520_keys_platform_data adp5520_keys_data = {
 };
 
 	/*
-	 *  ADP5520/5501 Multifuction Device Init Data
+	 *  ADP5520/5501 Multifunction Device Init Data
 	 */
 
 static struct adp5520_platform_data adp5520_pdev_data = {
diff --git a/arch/xtensa/include/asm/uaccess.h b/arch/xtensa/include/asm/uaccess.h
index b852842..5b0c18c 100644
--- a/arch/xtensa/include/asm/uaccess.h
+++ b/arch/xtensa/include/asm/uaccess.h
@@ -4,7 +4,7 @@
  * User space memory access functions
  *
  * These routines provide basic accessing functions to the user memory
- * space for the kernel. This header file provides fuctions such as:
+ * space for the kernel. This header file provides functions such as:
  *
  * This file is subject to the terms and conditions of the GNU General Public
  * License.  See the file "COPYING" in the main directory of this archive
diff --git a/block/blk-core.c b/block/blk-core.c
index f0640d7..7ac24fa 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1618,7 +1618,7 @@ EXPORT_SYMBOL(submit_bio);
  *    the insertion using this generic function.
  *
  *    This function should also be useful for request stacking drivers
- *    in some cases below, so export this fuction.
+ *    in some cases below, so export this function.
  *    Request stacking drivers like request-based dm may change the queue
  *    limits while requests are in the queue (e.g. dm's table swapping).
  *    Such request stacking drivers should check those requests agaist
diff --git a/drivers/base/core.c b/drivers/base/core.c
index d1b2c9a..aed85f1 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -251,7 +251,7 @@ static int dev_uevent(struct kset *kset, struct kobject *kobj,
 				 __func__, retval);
 	}
 
-	/* have the device type specific fuction add its stuff */
+	/* have the device type specific function add its stuff */
 	if (dev->type && dev->type->uevent) {
 		retval = dev->type->uevent(dev, env);
 		if (retval)
diff --git a/drivers/media/video/zoran/videocodec.h b/drivers/media/video/zoran/videocodec.h
index 5c27b25..b654bff 100644
--- a/drivers/media/video/zoran/videocodec.h
+++ b/drivers/media/video/zoran/videocodec.h
@@ -56,7 +56,7 @@
    the slave is bound to it). Otherwise it doesn't need this functions and
    therfor they may not be initialized.
 
-   The other fuctions are just for convenience, as they are for sure used by
+   The other functions are just for convenience, as they are for sure used by
    most/all of the codecs. The last ones may be ommited, too.
 
    See the structure declaration below for more information and which data has
diff --git a/drivers/net/depca.c b/drivers/net/depca.c
index 44c0694..91b3846 100644
--- a/drivers/net/depca.c
+++ b/drivers/net/depca.c
@@ -1487,7 +1487,7 @@ static void __init depca_platform_probe (void)
 		if (!pldev->dev.driver) {
 		/* The driver was not bound to this device, there was
 		 * no hardware at this address. Unregister it, as the
-		 * release fuction will take care of freeing the
+		 * release function will take care of freeing the
 		 * allocated structure */
 
 			depca_io_ports[i].device = NULL;
diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
index df5dcd2..f0f82dc 100644
--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -3527,7 +3527,7 @@ enum latency_range {
  *      Stores a new ITR value based on strictly on packet size.  This
  *      algorithm is less sophisticated than that used in igb_update_itr,
  *      due to the difficulty of synchronizing statistics across multiple
- *      receive rings.  The divisors and thresholds used by this fuction
+ *      receive rings.  The divisors and thresholds used by this function
  *      were determined based on theoretical maximum wire speed and testing
  *      data, in order to minimize response time while increasing bulk
  *      throughput.
diff --git a/drivers/net/skfp/hwt.c b/drivers/net/skfp/hwt.c
index 0531514..465565e 100644
--- a/drivers/net/skfp/hwt.c
+++ b/drivers/net/skfp/hwt.c
@@ -221,7 +221,7 @@ u_long hwt_quick_read(struct s_smc *smc)
  * para	start		start time
  *	duration	time to wait
  *
- * NOTE: The fuction will return immediately, if the timer is not 
+ * NOTE: The function will return immediately, if the timer is not
  *	 started
  ************************/
 void hwt_wait_time(struct s_smc *smc, u_long start, long int duration)
diff --git a/drivers/net/skfp/skfddi.c b/drivers/net/skfp/skfddi.c
index 31b2dab..0ade12a 100644
--- a/drivers/net/skfp/skfddi.c
+++ b/drivers/net/skfp/skfddi.c
@@ -33,7 +33,7 @@
  *   The driver architecture is based on the DEC FDDI driver by
  *   Lawrence V. Stefani and several ethernet drivers.
  *   I also used an existing Windows NT miniport driver.
- *   All hardware dependent fuctions are handled by the SysKonnect
+ *   All hardware dependent functions are handled by the SysKonnect
  *   Hardware Module.
  *   The only headerfiles that are directly related to this source
  *   are skfddi.c, h/types.h, h/osdef1st.h, h/targetos.h.
diff --git a/drivers/s390/block/dasd_3990_erp.c b/drivers/s390/block/dasd_3990_erp.c
index 85bfd87..e82d427 100644
--- a/drivers/s390/block/dasd_3990_erp.c
+++ b/drivers/s390/block/dasd_3990_erp.c
@@ -2197,7 +2197,7 @@ dasd_3990_erp_inspect_32(struct dasd_ccw_req * erp, char *sense)
 
 /*
  *****************************************************************************
- * main ERP control fuctions (24 and 32 byte sense)
+ * main ERP control functions (24 and 32 byte sense)
  *****************************************************************************
  */
 
diff --git a/drivers/s390/char/tape_3590.c b/drivers/s390/char/tape_3590.c
index fc993ac..deff2c3 100644
--- a/drivers/s390/char/tape_3590.c
+++ b/drivers/s390/char/tape_3590.c
@@ -31,7 +31,7 @@ debug_info_t *TAPE_DBF_AREA = NULL;
 EXPORT_SYMBOL(TAPE_DBF_AREA);
 
 /*******************************************************************
- * Error Recovery fuctions:
+ * Error Recovery functions:
  * - Read Opposite:		 implemented
  * - Read Device (buffered) log: BRA
  * - Read Library log:		 BRA
@@ -798,7 +798,7 @@ tape_3590_done(struct tape_device *device, struct tape_request *request)
 }
 
 /*
- * This fuction is called, when error recovery was successfull
+ * This function is called, when error recovery was successful
  */
 static inline int
 tape_3590_erp_succeded(struct tape_device *device, struct tape_request *request)
@@ -809,7 +809,7 @@ tape_3590_erp_succeded(struct tape_device *device, struct tape_request *request)
 }
 
 /*
- * This fuction is called, when error recovery was not successfull
+ * This function is called, when error recovery was not successful
  */
 static inline int
 tape_3590_erp_failed(struct tape_device *device, struct tape_request *request,
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 0639c99..b37fa20 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5498,7 +5498,7 @@ lpfc_get_rec_conf23(uint8_t *buff, uint32_t size, uint8_t rec_type)
  * @buff: Buffer containing config region 23 data.
  * @size: Size of the data buffer.
  *
- * This fuction parse the FCoE config parameters in config region 23 and
+ * This function parses the FCoE config parameters in config region 23 and
  * populate driver data structure with the parameters.
  */
 void
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
index 1b838a2..652d879 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
@@ -454,7 +454,7 @@ void ieee80211_softmac_scan_syncro(struct ieee80211_device *ieee)
 				goto out; /* scan completed */
 
 		}while(!channel_map[ch]);
-		/* this fuction can be called in two situations
+		/* this function can be called in two situations
 		 * 1- We have switched to ad-hoc mode and we are
 		 *    performing a complete syncro scan before conclude
 		 *    there are no interesting cell and to create a
@@ -517,7 +517,7 @@ void ieee80211_softmac_ips_scan_syncro(struct ieee80211_device *ieee)
 //	printk("=======hh===============>ips scan\n");
      	while(1)
         {
-                /* this fuction can be called in two situations
+                /* this function can be called in two situations
                  * 1- We have switched to ad-hoc mode and we are
                  *    performing a complete syncro scan before conclude
                  *    there are no interesting cell and to create a
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
index b7ec1dd..9f202c7 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
@@ -455,7 +455,7 @@ void ieee80211_softmac_scan_syncro(struct ieee80211_device *ieee)
 		}while(!ieee->channel_map[ch]);
 #endif
 
-		/* this fuction can be called in two situations
+		/* this function can be called in two situations
 		 * 1- We have switched to ad-hoc mode and we are
 		 *    performing a complete syncro scan before conclude
 		 *    there are no interesting cell and to create a
diff --git a/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
index 0285047..f07026e 100644
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
@@ -463,7 +463,7 @@ void ieee80211_softmac_scan_syncro(struct ieee80211_device *ieee)
 				goto out; /* scan completed */
 		}while(!channel_map[ch]);
 
-		/* this fuction can be called in two situations
+		/* this function can be called in two situations
 		 * 1- We have switched to ad-hoc mode and we are
 		 *    performing a complete syncro scan before conclude
 		 *    there are no interesting cell and to create a
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
index a2e84c5..bc8c425 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -449,7 +449,7 @@ void ieee80211_softmac_scan_syncro(struct ieee80211_device *ieee)
 		}while(!ieee->channel_map[ch]);
 #endif
 
-		/* this fuction can be called in two situations
+		/* this function can be called in two situations
 		 * 1- We have switched to ad-hoc mode and we are
 		 *    performing a complete syncro scan before conclude
 		 *    there are no interesting cell and to create a
diff --git a/drivers/usb/host/imx21-hcd.c b/drivers/usb/host/imx21-hcd.c
index ca0e98d..caf116c 100644
--- a/drivers/usb/host/imx21-hcd.c
+++ b/drivers/usb/host/imx21-hcd.c
@@ -27,8 +27,8 @@
   *    * 32 transfer descriptors (called ETDs)
   *    * 4Kb of Data memory
   *
-  * The data memory is shared between the host and fuction controlers
-  * (but this driver only supports the host controler)
+  * The data memory is shared between the host and function controllers
+  * (but this driver only supports the host controller)
   *
   * So setting up a transfer involves:
   *    * Allocating a ETD
diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
index ebd3f1d..58e7411 100644
--- a/net/mac80211/mesh.h
+++ b/net/mac80211/mesh.h
@@ -115,7 +115,7 @@ struct mesh_path {
  * @hash_rnd: random value used for hash computations
  * @entries: number of entries in the table
  * @free_node: function to free nodes of the table
- * @copy_node: fuction to copy nodes of the table
+ * @copy_node: function to copy nodes of the table
  * @size_order: determines size of the table, there will be 2^size_order hash
  *	buckets
  * @mean_chain_len: maximum average length for the hash buckets' list, if it is
-- 
1.5.6.5

