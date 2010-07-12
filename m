Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab0GLPPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 11:15:52 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38615 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab0GLPPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 11:15:49 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/3] staging/trivial: fix typos concerning "address"
Date: Mon, 12 Jul 2010 17:15:46 +0200
Message-Id: <1278947746-11253-3-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1278947746-11253-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1278947746-11253-1-git-send-email-u.kleine-koenig@pengutronix.de>
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
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 .../staging/comedi/drivers/addi-data/addi_eeprom.c |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3120.c      |    8 ++++----
 drivers/staging/comedi/drivers/ni_660x.c           |    2 +-
 drivers/staging/comedi/drivers/usbdux.c            |    2 +-
 drivers/staging/comedi/drivers/usbduxfast.c        |    2 +-
 drivers/staging/octeon/cvmx-fau.h                  |    2 +-
 drivers/staging/otus/80211core/ctxrx.c             |    2 +-
 drivers/staging/pohmelfs/inode.c                   |    2 +-
 drivers/staging/sep/sep_driver_api.h               |    2 +-
 drivers/staging/winbond/wbusb.c                    |    2 +-
 drivers/staging/wlags49_h2/mdd.h                   |    4 ++--
 11 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/addi_eeprom.c b/drivers/staging/comedi/drivers/addi-data/addi_eeprom.c
index bea329f..16bbdba 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_eeprom.c
+++ b/drivers/staging/comedi/drivers/addi-data/addi_eeprom.c
@@ -635,7 +635,7 @@ void v_EepromSendCommand76(unsigned int dw_Address, unsigned int dw_EepromComman
 
 | Input Parameters  : unsigned int dw_Address : PCI eeprom base address                  |
 
-|		      unsigned short    w_offset : Offset of the adress to read             |
+|		      unsigned short    w_offset : Offset of the address to read             |
 
 |		      unsigned short *   pw_Value : PCI eeprom 16 bit read value.            |
 
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
index f93ddd4..851f71b 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3120.c
@@ -1090,13 +1090,13 @@ int i_APCI3120_CyclicAnalogInput(int mode, struct comedi_device *dev,
  * and put into into an array array used may be for differnet pages
  */
 
-		/*  DMA Start Adress Low */
+		/*  DMA Start Address Low */
 		outw(APCI3120_ADD_ON_MWAR_LOW, devpriv->i_IobaseAddon + 0);
 		outw((devpriv->ul_DmaBufferHw[0] & 0xFFFF),
 			devpriv->i_IobaseAddon + 2);
 
 		/*************************/
-		/* DMA Start Adress High */
+		/* DMA Start Address High */
 		/*************************/
 		outw(APCI3120_ADD_ON_MWAR_HIGH, devpriv->i_IobaseAddon + 0);
 		outw((devpriv->ul_DmaBufferHw[0] / 65536),
@@ -1733,11 +1733,11 @@ void v_APCI3120_InterruptDma(int irq, void *d)
 		var = devpriv->ul_DmaBufferHw[next_dma_buf];
 		high_word = var / 65536;
 
-		/* DMA Start Adress Low */
+		/* DMA Start Address Low */
 		outw(APCI3120_ADD_ON_MWAR_LOW, devpriv->i_IobaseAddon + 0);
 		outw(low_word, devpriv->i_IobaseAddon + 2);
 
-		/* DMA Start Adress High */
+		/* DMA Start Address High */
 		outw(APCI3120_ADD_ON_MWAR_HIGH, devpriv->i_IobaseAddon + 0);
 		outw(high_word, devpriv->i_IobaseAddon + 2);
 
diff --git a/drivers/staging/comedi/drivers/ni_660x.c b/drivers/staging/comedi/drivers/ni_660x.c
index 6a6fae5..098d796 100644
--- a/drivers/staging/comedi/drivers/ni_660x.c
+++ b/drivers/staging/comedi/drivers/ni_660x.c
@@ -382,7 +382,7 @@ enum global_interrupt_config_register_bits {
 	Global_Int_Enable_Bit = 0x80000000
 };
 
-/* Offset of the GPCT chips from the base-adress of the card */
+/* Offset of the GPCT chips from the base-address of the card */
 /* First chip is at base-address + 0x00, etc. */
 static const unsigned GPCT_OFFSET[2] = { 0x0, 0x800 };
 
diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 27b4cb2..493add3 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -111,7 +111,7 @@ sampling rate. If you sample two channels you get 4kHz and so on.
 #define VENDOR_DIR_IN  0xC0
 #define VENDOR_DIR_OUT 0x40
 
-/* internal adresses of the 8051 processor */
+/* internal addresses of the 8051 processor */
 #define USBDUXSUB_CPUCS 0xE600
 
 /*
diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 29c3c01..0a164a9 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -67,7 +67,7 @@
 #define VENDOR_DIR_OUT		0x40
 
 /*
- * internal adresses of the 8051 processor
+ * internal addresses of the 8051 processor
  */
 #define USBDUXFASTSUB_CPUCS	0xE600
 
diff --git a/drivers/staging/octeon/cvmx-fau.h b/drivers/staging/octeon/cvmx-fau.h
index 29bdce6..a6939fc 100644
--- a/drivers/staging/octeon/cvmx-fau.h
+++ b/drivers/staging/octeon/cvmx-fau.h
@@ -299,7 +299,7 @@ cvmx_fau_tagwait_fetch_and_add8(cvmx_fau_reg_8_t reg, int8_t value)
 /**
  * Builds I/O data for async operations
  *
- * @scraddr: Scratch pad byte addres to write to.  Must be 8 byte aligned
+ * @scraddr: Scratch pad byte address to write to.  Must be 8 byte aligned
  * @value:   Signed value to add.
  *                Note: When performing 32 and 64 bit access, only the low
  *                22 bits are available.
diff --git a/drivers/staging/otus/80211core/ctxrx.c b/drivers/staging/otus/80211core/ctxrx.c
index a127196..135167d 100644
--- a/drivers/staging/otus/80211core/ctxrx.c
+++ b/drivers/staging/otus/80211core/ctxrx.c
@@ -3117,7 +3117,7 @@ u16_t zfWlanRxFilter(zdev_t* dev, zbuf_t* buf)
 
     index = (src[2]+up) & (ZM_FILTER_TABLE_ROW-1);
 
-    /* TBD : filter frame with source address == own MAC adress */
+    /* TBD : filter frame with source address == own MAC address */
     if ((wd->macAddr[0] == src[0]) && (wd->macAddr[1] == src[1])
             && (wd->macAddr[2] == src[2]))
     {
diff --git a/drivers/staging/pohmelfs/inode.c b/drivers/staging/pohmelfs/inode.c
index 643b413..3e5de26 100644
--- a/drivers/staging/pohmelfs/inode.c
+++ b/drivers/staging/pohmelfs/inode.c
@@ -815,7 +815,7 @@ static int pohmelfs_readpages(struct file *file, struct address_space *mapping,
 }
 
 /*
- * Small addres space operations for POHMELFS.
+ * Small address space operations for POHMELFS.
  */
 const struct address_space_operations pohmelfs_aops = {
 	.readpage		= pohmelfs_readpage,
diff --git a/drivers/staging/sep/sep_driver_api.h b/drivers/staging/sep/sep_driver_api.h
index 383543d..7ef16da 100644
--- a/drivers/staging/sep/sep_driver_api.h
+++ b/drivers/staging/sep/sep_driver_api.h
@@ -65,7 +65,7 @@
 /* free dynamic data aalocated during table creation */
 #define SEP_IOCFREEDMATABLEDATA                _IO(SEP_IOC_MAGIC_NUMBER , 7)
 
-/* get the static pool area addersses (physical and virtual) */
+/* get the static pool area addresses (physical and virtual) */
 #define SEP_IOCGETSTATICPOOLADDR               _IO(SEP_IOC_MAGIC_NUMBER , 8)
 
 /* set flow id command */
diff --git a/drivers/staging/winbond/wbusb.c b/drivers/staging/winbond/wbusb.c
index 681419d..8c3768c 100644
--- a/drivers/staging/winbond/wbusb.c
+++ b/drivers/staging/winbond/wbusb.c
@@ -700,7 +700,7 @@ static int wb35_hw_init(struct ieee80211_hw *hw)
 	Mds_initial(priv);
 
 	/*
-	 * If no user-defined address in the registry, use the addresss
+	 * If no user-defined address in the registry, use the address
 	 * "burned" on the NIC instead.
 	 */
 	pMacAddr = priv->sLocalPara.ThisMacAddress;
diff --git a/drivers/staging/wlags49_h2/mdd.h b/drivers/staging/wlags49_h2/mdd.h
index b45c7dd..b50b7b0 100644
--- a/drivers/staging/wlags49_h2/mdd.h
+++ b/drivers/staging/wlags49_h2/mdd.h
@@ -727,10 +727,10 @@ XX1( CFG_SCAN,					SCAN_RS_STRCT, scan_result[32]		 ) /*Scan results											*
 #define CFG_FCBE	0xFCBE	//FW codes ahead of available documentation, so ???????
 #define CFG_FCBF	0xFCBF	//FW codes ahead of available documentation, so ???????
 
-#define CFG_HANDOVER_ADDR				0xFCC0		//[AP] Station MAC Adrress re-associated with other AP
+#define CFG_HANDOVER_ADDR				0xFCC0		//[AP] Station MAC Address re-associated with other AP
 #define CFG_SCAN_CHANNEL				0xFCC2		//Channel set for host requested scan
 //;?#define CFG_SCAN_CHANNEL_MASK			0xFCC2		// contains
-#define CFG_DISASSOCIATE_ADDR			0xFCC4		//[AP] Station MAC Adrress to be disassociated
+#define CFG_DISASSOCIATE_ADDR			0xFCC4		//[AP] Station MAC Address to be disassociated
 #define CFG_PROBE_DATA_RATE				0xFCC5		//WARP connection control
 #define CFG_FRAME_BURST_LIMIT			0xFCC6		//
 #define CFG_COEXISTENSE_BEHAVIOUR		0xFCC7		//[AP]
-- 
1.7.1

