Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab0IANk6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 09:40:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38933 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab0IANk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 09:40:56 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] staging/trivial: fix typos concerning "initiali[zs]e"
Date: Wed,  1 Sep 2010 15:40:25 +0200
Message-Id: <1283348427-6183-4-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283348427-6183-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1283348427-6183-1-git-send-email-u.kleine-koenig@pengutronix.de>
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
 drivers/staging/et131x/et131x_initpci.c            |    2 +-
 drivers/staging/frontier/alphatrack.c              |    2 +-
 drivers/staging/frontier/tranzport.c               |    2 +-
 drivers/staging/mrst-touchscreen/intel-mid-touch.c |    2 +-
 drivers/staging/quatech_usb2/quatech_usb2.c        |    2 +-
 drivers/staging/rt2860/common/rtmp_init.c          |    6 +++---
 drivers/staging/rtl8192e/r819xE_firmware.c         |    2 +-
 drivers/staging/rtl8192su/r8192S_firmware.c        |    2 +-
 drivers/staging/rtl8192u/r8192U_core.c             |    2 +-
 drivers/staging/rtl8192u/r819xU_firmware.c         |    2 +-
 .../staging/tidspbridge/include/dspbridge/drv.h    |    2 +-
 .../staging/tidspbridge/include/dspbridge/mgr.h    |    2 +-
 .../staging/tidspbridge/include/dspbridge/wdt.h    |    2 +-
 drivers/staging/wlags49_h2/wl_main.c               |    2 +-
 drivers/staging/wlan-ng/hfa384x_usb.c              |    2 +-
 15 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/et131x/et131x_initpci.c b/drivers/staging/et131x/et131x_initpci.c
index 47baab3..10bcb45 100644
--- a/drivers/staging/et131x/et131x_initpci.c
+++ b/drivers/staging/et131x/et131x_initpci.c
@@ -726,7 +726,7 @@ static int __devinit et131x_pci_setup(struct pci_dev *pdev,
 	/* Initialize link state */
 	et131x_link_detection_handler((unsigned long)adapter);
 
-	/* Intialize variable for counting how long we do not have
+	/* Initialize variable for counting how long we do not have
 							link status */
 	adapter->PoMgmt.TransPhyComaModeOnBoot = 0;
 
diff --git a/drivers/staging/frontier/alphatrack.c b/drivers/staging/frontier/alphatrack.c
index 4e52105..4b44d7c 100644
--- a/drivers/staging/frontier/alphatrack.c
+++ b/drivers/staging/frontier/alphatrack.c
@@ -671,7 +671,7 @@ static int usb_alphatrack_probe(struct usb_interface *intf,
 	int true_size;
 	int retval = -ENOMEM;
 
-	/* allocate memory for our device state and intialize it */
+	/* allocate memory for our device state and initialize it */
 
 	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (dev == NULL) {
diff --git a/drivers/staging/frontier/tranzport.c b/drivers/staging/frontier/tranzport.c
index eed74f0..d33e176 100644
--- a/drivers/staging/frontier/tranzport.c
+++ b/drivers/staging/frontier/tranzport.c
@@ -795,7 +795,7 @@ static int usb_tranzport_probe(struct usb_interface *intf,
 	int true_size;
 	int retval = -ENOMEM;
 
-	/* allocate memory for our device state and intialize it */
+	/* allocate memory for our device state and initialize it */
 
 	 dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 	if (dev == NULL) {
diff --git a/drivers/staging/mrst-touchscreen/intel-mid-touch.c b/drivers/staging/mrst-touchscreen/intel-mid-touch.c
index abba22f..531e7d4 100644
--- a/drivers/staging/mrst-touchscreen/intel-mid-touch.c
+++ b/drivers/staging/mrst-touchscreen/intel-mid-touch.c
@@ -689,7 +689,7 @@ static irqreturn_t pendet_intr_handler(int irq, void *handle)
 	return IRQ_HANDLED;
 }
 
-/* Intializes input device and registers with input subsystem */
+/* Initializes input device and registers with input subsystem */
 static int ts_input_dev_init(struct mrstouch_dev *tsdev, struct spi_device *spi)
 {
 	int err = 0;
diff --git a/drivers/staging/quatech_usb2/quatech_usb2.c b/drivers/staging/quatech_usb2/quatech_usb2.c
index 9838ea2..ed58f48 100644
--- a/drivers/staging/quatech_usb2/quatech_usb2.c
+++ b/drivers/staging/quatech_usb2/quatech_usb2.c
@@ -577,7 +577,7 @@ int qt2_open(struct tty_struct *tty, struct usb_serial_port *port)
 			port0->bulk_in_buffer,
 			port0->bulk_in_size,
 			qt2_read_bulk_callback, serial);
-		dbg("port0 bulk in URB intialised");
+		dbg("port0 bulk in URB initialised");
 
 		/* submit URB, i.e. start reading from device (async) */
 		dev_extra->ReadBulkStopped = false;
diff --git a/drivers/staging/rt2860/common/rtmp_init.c b/drivers/staging/rt2860/common/rtmp_init.c
index a090385..701eb89 100644
--- a/drivers/staging/rt2860/common/rtmp_init.c
+++ b/drivers/staging/rt2860/common/rtmp_init.c
@@ -704,7 +704,7 @@ void NICReadEEPROMParameters(struct rt_rtmp_adapter *pAd, u8 *mac_addr)
 	DBGPRINT(RT_DEBUG_TRACE,
 		 ("--> EEPROMAddressNum = %d\n", pAd->EEPROMAddressNum));
 
-	/* RT2860 MAC no longer auto load MAC address from E2PROM. Driver has to intialize */
+	/* RT2860 MAC no longer auto load MAC address from E2PROM. Driver has to initialize */
 	/* MAC address registers according to E2PROM setting */
 	if (mac_addr == NULL ||
 	    strlen((char *)mac_addr) != 17 ||
@@ -2507,7 +2507,7 @@ void UserCfgInit(struct rt_rtmp_adapter *pAd)
 	DBGPRINT(RT_DEBUG_TRACE, ("--> UserCfgInit\n"));
 
 	/* */
-	/*  part I. intialize common configuration */
+	/*  part I. initialize common configuration */
 	/* */
 #ifdef RTMP_MAC_USB
 	pAd->BulkOutReq = 0;
@@ -2646,7 +2646,7 @@ void UserCfgInit(struct rt_rtmp_adapter *pAd)
 	pAd->CommonCfg.BeaconPeriod = 100;	/* in mSec */
 
 	/* */
-	/* part II. intialize STA specific configuration */
+	/* part II. initialize STA specific configuration */
 	/* */
 	{
 		RX_FILTER_SET_FLAG(pAd, fRX_FILTER_ACCEPT_DIRECT);
diff --git a/drivers/staging/rtl8192e/r819xE_firmware.c b/drivers/staging/rtl8192e/r819xE_firmware.c
index 793a175..273ee01 100644
--- a/drivers/staging/rtl8192e/r819xE_firmware.c
+++ b/drivers/staging/rtl8192e/r819xE_firmware.c
@@ -1,7 +1,7 @@
 /*
  * Procedure: Init boot code/firmware code/data session
  *
- * Description: This routine will intialize firmware. If any error occurs
+ * Description: This routine will initialize firmware. If any error occurs
  *		during the initialization process, the routine shall terminate
  *		immediately and return fail.  NIC driver should call
  *		NdisOpenFile only from MiniportInitialize.
diff --git a/drivers/staging/rtl8192su/r8192S_firmware.c b/drivers/staging/rtl8192su/r8192S_firmware.c
index db0d2d5..7c00981 100644
--- a/drivers/staging/rtl8192su/r8192S_firmware.c
+++ b/drivers/staging/rtl8192su/r8192S_firmware.c
@@ -29,7 +29,7 @@
 #define   byte(x,n)  ( (x >> (8 * n)) & 0xff  )
 
 //
-// Description:   This routine will intialize firmware. If any error occurs during the initialization
+// Description:   This routine will initialize firmware. If any error occurs during the initialization
 //				process, the routine shall terminate immediately and return fail.
 //
 // Arguments:   The pointer of the adapter
diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 1ff7850..51bcd01 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -1534,7 +1534,7 @@ static void rtl8192_tx_isr(struct urb *tx_urb)
 				 * 1. check whether there's tx irq available, for it's a completion return
 				 *    function, it should contain enough tx irq;
 				 * 2. check pakcet type;
-				 * 3. intialize sendlist, check whether the to-be send packet no greater than 1
+				 * 3. initialize sendlist, check whether the to-be send packet no greater than 1
 				 * 4. aggregation the packets, and fill firmware info and tx desc to it, etc.
 				 * 5. check whehter the packet could be sent, otherwise just insert to wait head
 				 * */
diff --git a/drivers/staging/rtl8192u/r819xU_firmware.c b/drivers/staging/rtl8192u/r819xU_firmware.c
index b136ee4..49ae170 100644
--- a/drivers/staging/rtl8192u/r819xU_firmware.c
+++ b/drivers/staging/rtl8192u/r819xU_firmware.c
@@ -1,7 +1,7 @@
 /**************************************************************************************************
  * Procedure:    Init boot code/firmware code/data session
  *
- * Description: This routine will intialize firmware. If any error occurs during the initialization
+ * Description: This routine will initialize firmware. If any error occurs during the initialization
  * 		process, the routine shall terminate immediately and return fail.
  *		NIC driver should call NdisOpenFile only from MiniportInitialize.
  *
diff --git a/drivers/staging/tidspbridge/include/dspbridge/drv.h b/drivers/staging/tidspbridge/include/dspbridge/drv.h
index f365015..c1f363e 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/drv.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/drv.h
@@ -193,7 +193,7 @@ struct process_context {
  *  Ensures:
  *      0:        - *drv_obj is a valid DRV interface to the device.
  *                      - List of DevObject Created and Initialized.
- *                      - List of dev_node String created and intialized.
+ *                      - List of dev_node String created and initialized.
  *                      - Registry is updated with the DRV Object.
  *      !0:       DRV Object not created
  *  Details:
diff --git a/drivers/staging/tidspbridge/include/dspbridge/mgr.h b/drivers/staging/tidspbridge/include/dspbridge/mgr.h
index 99f7dc0..e506c4d 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/mgr.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/mgr.h
@@ -192,7 +192,7 @@ extern int mgr_get_dcd_handle(struct mgr_object
  *  ======== mgr_init ========
  *  Purpose:
  *      Initialize MGR's private state, keeping a reference count on each
- *      call. Intializes the DCD.
+ *      call. Initializes the DCD.
  *  Parameters:
  *  Returns:
  *      TRUE if initialized; FALSE if error occured.
diff --git a/drivers/staging/tidspbridge/include/dspbridge/wdt.h b/drivers/staging/tidspbridge/include/dspbridge/wdt.h
index 4c00ba5..36193db 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/wdt.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/wdt.h
@@ -44,7 +44,7 @@ struct dsp_wdt_setting {
 /**
  * dsp_wdt_init() - initialize wdt3 module.
  *
- * This function initilize to wdt3 module, so that
+ * This function initialize to wdt3 module, so that
  * other wdt3 function can be used.
  */
 int dsp_wdt_init(void);
diff --git a/drivers/staging/wlags49_h2/wl_main.c b/drivers/staging/wlags49_h2/wl_main.c
index 88d0d47..a2bc76a 100644
--- a/drivers/staging/wlags49_h2/wl_main.c
+++ b/drivers/staging/wlags49_h2/wl_main.c
@@ -450,7 +450,7 @@ int wl_insert( struct net_device *dev )
 	/* Initialize the adapter parameters. */
 	spin_lock_init( &( lp->slock ));
 
-	/* Intialize states */
+	/* Initialize states */
 	//lp->lockcount = 0; //PE1DNN
         lp->is_handling_int = WL_NOT_HANDLING_INT;
 	lp->firmware_present = WL_FRIMWARE_NOT_PRESENT;
diff --git a/drivers/staging/wlan-ng/hfa384x_usb.c b/drivers/staging/wlan-ng/hfa384x_usb.c
index ea81cb5..a6efc03 100644
--- a/drivers/staging/wlan-ng/hfa384x_usb.c
+++ b/drivers/staging/wlan-ng/hfa384x_usb.c
@@ -511,7 +511,7 @@ static void hfa384x_usb_defer(struct work_struct *data)
 * hfa384x_create
 *
 * Sets up the hfa384x_t data structure for use.  Note this
-* does _not_ intialize the actual hardware, just the data structures
+* does _not_ initialize the actual hardware, just the data structures
 * we use to keep track of its state.
 *
 * Arguments:
-- 
1.7.1

