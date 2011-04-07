Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab1DGQJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 12:09:51 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:54473 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab1DGQJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 12:09:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kZdmIoOBiJug0+fhuqzxRxI0morM5YyVbUpWkKWl1aBsw2Q0pJMqovy5uxB10e3EOa
         Zuot2rY/xoOUT7j+8+Gqw3wy0reMKE3u0Y9LPOtb2xaRa0eSPKoaxOiOsdPrN8G0nDel
         JkFXHb2mexXclWV64vS++oqO8QahZ4Oz6SZCU=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org
Subject: [RFC 6/6]drivers:staging Fix typo "recieve" in various parts of the kernel.
Date: Thu,  7 Apr 2011 09:09:27 -0700
Message-Id: <1302192567-842-6-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1302192567-842-1-git-send-email-justinmattock@gmail.com>
References: <1302192567-842-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below fixes "recieve" in various parts of the kernel.
Note: This is a mix of code and comments that are fixed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: devel@driverdev.osuosl.org
CC: linux-wireless@vger.kernel.org
---
 .../ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c        |    2 +-
 drivers/staging/bcm/Adapter.h                      |    2 +-
 drivers/staging/bcm/HostMIBSInterface.h            |    2 +-
 drivers/staging/bcm/Qos.c                          |    2 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |    2 +-
 drivers/staging/comedi/drivers/s626.c              |   10 +++++-----
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |    2 +-
 drivers/staging/iio/accel/adis16201.h              |    2 +-
 drivers/staging/iio/accel/adis16203.h              |    2 +-
 drivers/staging/iio/accel/adis16204.h              |    2 +-
 drivers/staging/iio/accel/adis16209.h              |    2 +-
 drivers/staging/iio/accel/adis16220.h              |    2 +-
 drivers/staging/iio/accel/adis16240.h              |    2 +-
 drivers/staging/iio/accel/lis3l02dq.h              |    2 +-
 drivers/staging/iio/accel/lis3l02dq_ring.c         |    2 +-
 drivers/staging/iio/accel/sca3000.h                |    2 +-
 drivers/staging/iio/gyro/adis16060_core.c          |    2 +-
 drivers/staging/iio/gyro/adis16080_core.c          |    2 +-
 drivers/staging/iio/gyro/adis16260.h               |    2 +-
 drivers/staging/iio/iio.h                          |    2 +-
 drivers/staging/iio/imu/adis16300.h                |    2 +-
 drivers/staging/iio/imu/adis16350.h                |    2 +-
 drivers/staging/iio/imu/adis16400.h                |    2 +-
 drivers/staging/iio/meter/ade7753.h                |    2 +-
 drivers/staging/iio/meter/ade7754.h                |    2 +-
 drivers/staging/iio/meter/ade7758.h                |    2 +-
 drivers/staging/iio/meter/ade7759.h                |    2 +-
 drivers/staging/iio/meter/ade7854.h                |    2 +-
 .../staging/intel_sst/intel_sst_app_interface.c    |   12 ++++++------
 drivers/staging/lirc/lirc_ene0100.h                |    2 +-
 drivers/staging/quatech_usb2/quatech_usb2.c        |    4 ++--
 drivers/staging/rt2860/common/cmm_data_usb.c       |    2 +-
 .../staging/westbridge/astoria/api/src/cyasmisc.c  |    4 ++--
 .../westbridge/astoria/block/cyasblkdev_queue.c    |    2 +-
 .../astoria/include/linux/westbridge/cyasstorage.h |   20 ++++++++++----------
 35 files changed, 55 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
index c6488e0..00cdac9 100644
--- a/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
+++ b/drivers/staging/ath6kl/htc2/AR6000/ar6k_gmbox_hciuart.c
@@ -507,7 +507,7 @@ static int HCIUartMessagePending(void *pContext, u8 LookAheadBytes[], int ValidB
         
     } while (false);
         
-        /* check if we need to disable the reciever */
+        /* check if we need to disable the receiver */
     if (status || blockRecv) {
         DevGMboxIRQAction(pProt->pDev, GMBOX_RECV_IRQ_DISABLE, PROC_IO_SYNC); 
     }
diff --git a/drivers/staging/bcm/Adapter.h b/drivers/staging/bcm/Adapter.h
index 32909e2..c37d795 100644
--- a/drivers/staging/bcm/Adapter.h
+++ b/drivers/staging/bcm/Adapter.h
@@ -412,7 +412,7 @@ struct _MINI_ADAPTER
 
 	// this to keep track of the Tx and Rx MailBox Registers.
 	atomic_t		    CurrNumFreeTxDesc;
-	// to keep track the no of byte recieved
+	// to keep track the no of byte received
 	USHORT				PrevNumRecvDescs;
 	USHORT				CurrNumRecvDescs;
 	UINT				u32TotalDSD;
diff --git a/drivers/staging/bcm/HostMIBSInterface.h b/drivers/staging/bcm/HostMIBSInterface.h
index f17a4f1..e34531b 100644
--- a/drivers/staging/bcm/HostMIBSInterface.h
+++ b/drivers/staging/bcm/HostMIBSInterface.h
@@ -62,7 +62,7 @@ typedef struct _S_MIBS_HOST_INFO
 	ULONG			NumDesUsed;
 	ULONG			CurrNumFreeDesc;
 	ULONG			PrevNumFreeDesc;
-	// to keep track the no of byte recieved
+	// to keep track the no of byte received
 	ULONG			PrevNumRcevBytes;
 	ULONG			CurrNumRcevBytes;
 
diff --git a/drivers/staging/bcm/Qos.c b/drivers/staging/bcm/Qos.c
index feade94..c97020f 100644
--- a/drivers/staging/bcm/Qos.c
+++ b/drivers/staging/bcm/Qos.c
@@ -727,7 +727,7 @@ static BOOLEAN EthCSMatchVLANRules(S_CLASSIFIER_RULE *pstClassifierRule,struct s
 
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_TX, IPV4_DBG, DBG_LVL_ALL,  "%s  CLS UserPrio:%x CLS VLANID:%x\n",__FUNCTION__,ntohs(*((USHORT *)pstClassifierRule->usUserPriority)),pstClassifierRule->usVLANID);
 
-	/* In case FW didn't recieve the TLV, the priority field should be ignored */
+	/* In case FW didn't receive the TLV, the priority field should be ignored */
 	if(pstClassifierRule->usValidityBitMap & (1<<PKT_CLASSIFICATION_USER_PRIORITY_VALID))
 	{
 		if(pstEthCsPktInfo->eNwpktEthFrameType!=eEth802QVLANFrame)
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 65313fa..71c3571 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -264,7 +264,7 @@ extern SDIOH_API_RC sdioh_disable_func_intr(void)
 }
 #endif				/* defined(OOB_INTR_ONLY) && defined(HW_OOB) */
 
-/* Configure callback to client when we recieve client interrupt */
+/* Configure callback to client when we receive client interrupt */
 extern SDIOH_API_RC
 sdioh_interrupt_register(sdioh_info_t *sd, sdioh_cb_fn_t fn, void *argh)
 {
diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index d5ba3ab..b706476 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -1048,7 +1048,7 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 	uint8_t group;
 	uint16_t irqbit;
 
-	DEBUG("s626_irq_handler: interrupt request recieved!!!\n");
+	DEBUG("s626_irq_handler: interrupt request received!!!\n");
 
 	if (dev->attached == 0)
 		return IRQ_NONE;
@@ -1165,7 +1165,7 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 							(16 * group)))
 					    == 1 && cmd->start_src == TRIG_EXT) {
 						DEBUG
-						    ("s626_irq_handler: Edge capture interrupt recieved from channel %d\n",
+						    ("s626_irq_handler: Edge capture interrupt received from channel %d\n",
 						     cmd->start_arg);
 
 						/*  Start executing the RPS program. */
@@ -1194,7 +1194,7 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 					    && cmd->scan_begin_src ==
 					    TRIG_EXT) {
 						DEBUG
-						    ("s626_irq_handler: Edge capture interrupt recieved from channel %d\n",
+						    ("s626_irq_handler: Edge capture interrupt received from channel %d\n",
 						     cmd->scan_begin_arg);
 
 						/*  Trigger ADC scan loop start by setting RPS Signal 0. */
@@ -1236,7 +1236,7 @@ static irqreturn_t s626_irq_handler(int irq, void *d)
 					    == 1
 					    && cmd->convert_src == TRIG_EXT) {
 						DEBUG
-						    ("s626_irq_handler: Edge capture interrupt recieved from channel %d\n",
+						    ("s626_irq_handler: Edge capture interrupt received from channel %d\n",
 						     cmd->convert_arg);
 
 						/*  Trigger ADC scan loop start by setting RPS Signal 0. */
@@ -1805,7 +1805,7 @@ static int s626_ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
 		DEBUG("s626_ai_cmd: NULL command\n");
 		return -EINVAL;
 	} else {
-		DEBUG("s626_ai_cmd: command recieved!!!\n");
+		DEBUG("s626_ai_cmd: command received!!!\n");
 	}
 
 	if (dev->irq == 0) {
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index e047c03..f2ecb3e 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -364,7 +364,7 @@ struct prov_record {
 
 #define ISR_EMPTY			(u8)0x00 	 // no bits set in ISR
 
-#define ISR_DOORBELL_ACK	(u8)0x01		 //  the doorbell i sent has been recieved.
+#define ISR_DOORBELL_ACK	(u8)0x01		 //  the doorbell i sent has been received.
 
 #define ISR_DOORBELL_PEND	(u8)0x02 	 //  doorbell for me
 
diff --git a/drivers/staging/iio/accel/adis16201.h b/drivers/staging/iio/accel/adis16201.h
index c9bf22c..23fe54d 100644
--- a/drivers/staging/iio/accel/adis16201.h
+++ b/drivers/staging/iio/accel/adis16201.h
@@ -70,7 +70,7 @@
  * @indio_dev:		industrial I/O device structure
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct adis16201_state {
diff --git a/drivers/staging/iio/accel/adis16203.h b/drivers/staging/iio/accel/adis16203.h
index b39323e..b886881 100644
--- a/drivers/staging/iio/accel/adis16203.h
+++ b/drivers/staging/iio/accel/adis16203.h
@@ -65,7 +65,7 @@
  * @indio_dev:		industrial I/O device structure
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct adis16203_state {
diff --git a/drivers/staging/iio/accel/adis16204.h b/drivers/staging/iio/accel/adis16204.h
index e9ed7cb..e618446 100644
--- a/drivers/staging/iio/accel/adis16204.h
+++ b/drivers/staging/iio/accel/adis16204.h
@@ -73,7 +73,7 @@
  * @indio_dev:		industrial I/O device structure
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct adis16204_state {
diff --git a/drivers/staging/iio/accel/adis16209.h b/drivers/staging/iio/accel/adis16209.h
index 4e97596..8b0da13 100644
--- a/drivers/staging/iio/accel/adis16209.h
+++ b/drivers/staging/iio/accel/adis16209.h
@@ -109,7 +109,7 @@
  * @indio_dev:		industrial I/O device structure
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct adis16209_state {
diff --git a/drivers/staging/iio/accel/adis16220.h b/drivers/staging/iio/accel/adis16220.h
index 7013314..4d5758c 100644
--- a/drivers/staging/iio/accel/adis16220.h
+++ b/drivers/staging/iio/accel/adis16220.h
@@ -132,7 +132,7 @@
  * @indio_dev:		industrial I/O device structure
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct adis16220_state {
diff --git a/drivers/staging/iio/accel/adis16240.h b/drivers/staging/iio/accel/adis16240.h
index 51a807d..76a4579 100644
--- a/drivers/staging/iio/accel/adis16240.h
+++ b/drivers/staging/iio/accel/adis16240.h
@@ -132,7 +132,7 @@
  * @indio_dev:		industrial I/O device structure
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct adis16240_state {
diff --git a/drivers/staging/iio/accel/lis3l02dq.h b/drivers/staging/iio/accel/lis3l02dq.h
index 579b3a2..c7ee170 100644
--- a/drivers/staging/iio/accel/lis3l02dq.h
+++ b/drivers/staging/iio/accel/lis3l02dq.h
@@ -155,7 +155,7 @@ Form of high byte dependant on justification set in ctrl reg */
  * @inter:		used to check if new interrupt has been triggered
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct lis3l02dq_state {
diff --git a/drivers/staging/iio/accel/lis3l02dq_ring.c b/drivers/staging/iio/accel/lis3l02dq_ring.c
index 2c461a3..6af7e2a 100644
--- a/drivers/staging/iio/accel/lis3l02dq_ring.c
+++ b/drivers/staging/iio/accel/lis3l02dq_ring.c
@@ -217,7 +217,7 @@ static const u8 read_all_tx_array[] = {
 /**
  * lis3l02dq_read_all() Reads all channels currently selected
  * @st:		device specific state
- * @rx_array:	(dma capable) recieve array, must be at least
+ * @rx_array:	(dma capable) receive array, must be at least
  *		4*number of channels
  **/
 static int lis3l02dq_read_all(struct lis3l02dq_state *st, u8 *rx_array)
diff --git a/drivers/staging/iio/accel/sca3000.h b/drivers/staging/iio/accel/sca3000.h
index 2389284..5971f1d 100644
--- a/drivers/staging/iio/accel/sca3000.h
+++ b/drivers/staging/iio/accel/sca3000.h
@@ -213,7 +213,7 @@ struct sca3000_chip_info {
  * sca3000_read_data() read a series of values from the device
  * @dev:		device
  * @reg_address_high:	start address (decremented read)
- * @rx:			pointer where recieved data is placed. Callee
+ * @rx:			pointer where received data is placed. Callee
  *			responsible for freeing this.
  * @len:		number of bytes to read
  *
diff --git a/drivers/staging/iio/gyro/adis16060_core.c b/drivers/staging/iio/gyro/adis16060_core.c
index 700eb39..ae53e71 100644
--- a/drivers/staging/iio/gyro/adis16060_core.c
+++ b/drivers/staging/iio/gyro/adis16060_core.c
@@ -30,7 +30,7 @@
  * @us_w:		actual spi_device to write config
  * @us_r:		actual spi_device to read back data
  * @indio_dev:		industrial I/O device structure
- * @buf:		transmit or recieve buffer
+ * @buf:		transmit or receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct adis16060_state {
diff --git a/drivers/staging/iio/gyro/adis16080_core.c b/drivers/staging/iio/gyro/adis16080_core.c
index fb4336c..ef9e304 100644
--- a/drivers/staging/iio/gyro/adis16080_core.c
+++ b/drivers/staging/iio/gyro/adis16080_core.c
@@ -35,7 +35,7 @@
  * struct adis16080_state - device instance specific data
  * @us:			actual spi_device to write data
  * @indio_dev:		industrial I/O device structure
- * @buf:		transmit or recieve buffer
+ * @buf:		transmit or receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct adis16080_state {
diff --git a/drivers/staging/iio/gyro/adis16260.h b/drivers/staging/iio/gyro/adis16260.h
index c1fd4364..1369501 100644
--- a/drivers/staging/iio/gyro/adis16260.h
+++ b/drivers/staging/iio/gyro/adis16260.h
@@ -91,7 +91,7 @@
  * @indio_dev:		industrial I/O device structure
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  * @negate:		negate the scale parameter
  **/
diff --git a/drivers/staging/iio/iio.h b/drivers/staging/iio/iio.h
index 248bdd2..7127f26 100644
--- a/drivers/staging/iio/iio.h
+++ b/drivers/staging/iio/iio.h
@@ -92,7 +92,7 @@ void iio_remove_event_from_list(struct iio_event_handler_list *el,
  *			changes
  * @available_scan_masks: [DRIVER] optional array of allowed bitmasks
  * @trig:		[INTERN] current device trigger (ring buffer modes)
- * @pollfunc:		[DRIVER] function run on trigger being recieved
+ * @pollfunc:		[DRIVER] function run on trigger being received
  **/
 struct iio_dev {
 	int				id;
diff --git a/drivers/staging/iio/imu/adis16300.h b/drivers/staging/iio/imu/adis16300.h
index 1f25d68..c095759 100644
--- a/drivers/staging/iio/imu/adis16300.h
+++ b/drivers/staging/iio/imu/adis16300.h
@@ -99,7 +99,7 @@
  * @indio_dev:		industrial I/O device structure
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct adis16300_state {
diff --git a/drivers/staging/iio/imu/adis16350.h b/drivers/staging/iio/imu/adis16350.h
index b00001e..b1ad486 100644
--- a/drivers/staging/iio/imu/adis16350.h
+++ b/drivers/staging/iio/imu/adis16350.h
@@ -105,7 +105,7 @@
  * @indio_dev:		industrial I/O device structure
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct adis16350_state {
diff --git a/drivers/staging/iio/imu/adis16400.h b/drivers/staging/iio/imu/adis16400.h
index 6ff33e1..7a12702 100644
--- a/drivers/staging/iio/imu/adis16400.h
+++ b/drivers/staging/iio/imu/adis16400.h
@@ -131,7 +131,7 @@
  * @indio_dev:		industrial I/O device structure
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct adis16400_state {
diff --git a/drivers/staging/iio/meter/ade7753.h b/drivers/staging/iio/meter/ade7753.h
index 70dabae..3b9c7f6 100644
--- a/drivers/staging/iio/meter/ade7753.h
+++ b/drivers/staging/iio/meter/ade7753.h
@@ -62,7 +62,7 @@
  * @us:			actual spi_device
  * @indio_dev:		industrial I/O device structure
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct ade7753_state {
diff --git a/drivers/staging/iio/meter/ade7754.h b/drivers/staging/iio/meter/ade7754.h
index 8faa9b3..0aa0522 100644
--- a/drivers/staging/iio/meter/ade7754.h
+++ b/drivers/staging/iio/meter/ade7754.h
@@ -80,7 +80,7 @@
  * @us:			actual spi_device
  * @indio_dev:		industrial I/O device structure
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct ade7754_state {
diff --git a/drivers/staging/iio/meter/ade7758.h b/drivers/staging/iio/meter/ade7758.h
index df5bb7b..c6fd94f 100644
--- a/drivers/staging/iio/meter/ade7758.h
+++ b/drivers/staging/iio/meter/ade7758.h
@@ -98,7 +98,7 @@
  * @indio_dev:		industrial I/O device structure
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct ade7758_state {
diff --git a/drivers/staging/iio/meter/ade7759.h b/drivers/staging/iio/meter/ade7759.h
index e9d1c43..cc76c2c 100644
--- a/drivers/staging/iio/meter/ade7759.h
+++ b/drivers/staging/iio/meter/ade7759.h
@@ -43,7 +43,7 @@
  * @us:			actual spi_device
  * @indio_dev:		industrial I/O device structure
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct ade7759_state {
diff --git a/drivers/staging/iio/meter/ade7854.h b/drivers/staging/iio/meter/ade7854.h
index 4ad84a3..79a2110 100644
--- a/drivers/staging/iio/meter/ade7854.h
+++ b/drivers/staging/iio/meter/ade7854.h
@@ -149,7 +149,7 @@
  * @spi:			actual spi_device
  * @indio_dev:		industrial I/O device structure
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct ade7854_state {
diff --git a/drivers/staging/intel_sst/intel_sst_app_interface.c b/drivers/staging/intel_sst/intel_sst_app_interface.c
index a367991..3522ee1 100644
--- a/drivers/staging/intel_sst/intel_sst_app_interface.c
+++ b/drivers/staging/intel_sst/intel_sst_app_interface.c
@@ -871,7 +871,7 @@ int sst_send_algo_ipc(struct ipc_post **msg)
 }
 
 /**
- * intel_sst_ioctl_dsp - recieves the device ioctl's
+ * intel_sst_ioctl_dsp - receives the device ioctl's
  *
  * @cmd:Ioctl cmd
  * @arg:data
@@ -1067,7 +1067,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 			retval = -EFAULT;
 			break;
 		}
-		pr_debug("SET_VOLUME recieved for %d!\n",
+		pr_debug("SET_VOLUME received for %d!\n",
 				set_vol.stream_id);
 		if (minor == STREAM_MODULE && set_vol.stream_id == 0) {
 			pr_debug("invalid operation!\n");
@@ -1085,7 +1085,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 			retval = -EFAULT;
 			break;
 		}
-		pr_debug("IOCTL_GET_VOLUME recieved for stream = %d!\n",
+		pr_debug("IOCTL_GET_VOLUME received for stream = %d!\n",
 				get_vol.stream_id);
 		if (minor == STREAM_MODULE && get_vol.stream_id == 0) {
 			pr_debug("invalid operation!\n");
@@ -1117,7 +1117,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 			retval = -EFAULT;
 			break;
 		}
-		pr_debug("SNDRV_SST_SET_VOLUME recieved for %d!\n",
+		pr_debug("SNDRV_SST_SET_VOLUME received for %d!\n",
 			set_mute.stream_id);
 		if (minor == STREAM_MODULE && set_mute.stream_id == 0) {
 			retval = -EPERM;
@@ -1153,7 +1153,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 	case _IOC_NR(SNDRV_SST_MMAP_CAPTURE): {
 		struct snd_sst_mmap_buffs mmap_buf;
 
-		pr_debug("SNDRV_SST_MMAP_PLAY/CAPTURE recieved!\n");
+		pr_debug("SNDRV_SST_MMAP_PLAY/CAPTURE received!\n");
 		if (minor != STREAM_MODULE) {
 			retval = -EBADRQC;
 			break;
@@ -1239,7 +1239,7 @@ long intel_sst_ioctl(struct file *file_ptr, unsigned int cmd, unsigned long arg)
 	case _IOC_NR(SNDRV_SST_SET_TARGET_DEVICE): {
 		struct snd_sst_target_device target_device;
 
-		pr_debug("SET_TARGET_DEVICE recieved!\n");
+		pr_debug("SET_TARGET_DEVICE received!\n");
 		if (copy_from_user(&target_device, (void __user *)arg,
 				sizeof(target_device))) {
 			retval = -EFAULT;
diff --git a/drivers/staging/lirc/lirc_ene0100.h b/drivers/staging/lirc/lirc_ene0100.h
index 776b693..ed39aa8 100644
--- a/drivers/staging/lirc/lirc_ene0100.h
+++ b/drivers/staging/lirc/lirc_ene0100.h
@@ -81,7 +81,7 @@
 
 /* CIR block settings */
 #define ENE_CIR_CONF1		0xFEC0
-#define ENE_CIR_CONF1_ADC_ON	0x7	 /* reciever on gpio40 enabled */
+#define ENE_CIR_CONF1_ADC_ON	0x7	 /* receiver on gpio40 enabled */
 #define ENE_CIR_CONF1_LEARN1	(1 << 3) /* enabled on learning mode */
 #define ENE_CIR_CONF1_TX_ON	0x30	 /* enabled on transmit */
 #define ENE_CIR_CONF1_TX_CARR	(1 << 7) /* send TX carrier or not */
diff --git a/drivers/staging/quatech_usb2/quatech_usb2.c b/drivers/staging/quatech_usb2/quatech_usb2.c
index c45b09e..111b9a0 100644
--- a/drivers/staging/quatech_usb2/quatech_usb2.c
+++ b/drivers/staging/quatech_usb2/quatech_usb2.c
@@ -156,7 +156,7 @@ static struct usb_driver quausb2_usb_driver = {
  * includes the size (excluding header) of URBs that have been submitted but
  * have not yet been sent to to the device, and bytes that have been sent out
  * of the port but not yet reported sent by the "xmit_empty" messages (which
- * indicate the number of bytes sent each time they are recieved, despite the
+ * indicate the number of bytes sent each time they are received, despite the
  * misleading name).
  * - Starts at zero when port is initialised.
  * - is incremented by the size of the data to be written (no headers)
@@ -823,7 +823,7 @@ static int qt2_write_room(struct tty_struct *tty)
 	 * reduce the free space count by the size of the dispatched write.
 	 * When a "transmit empty" message comes back up the USB read stream,
 	 * we decrement the count by the number of bytes reported sent, thus
-	 * keeping track of the difference between sent and recieved bytes.
+	 * keeping track of the difference between sent and received bytes.
 	 */
 
 	room = (QT2_FIFO_DEPTH - port_extra->tx_pending_bytes);
diff --git a/drivers/staging/rt2860/common/cmm_data_usb.c b/drivers/staging/rt2860/common/cmm_data_usb.c
index 7c56c2f..b0de809 100644
--- a/drivers/staging/rt2860/common/cmm_data_usb.c
+++ b/drivers/staging/rt2860/common/cmm_data_usb.c
@@ -702,7 +702,7 @@ Arguments:
 	*pRxPending			pending received packet flag
 
 Return Value:
-    the recieved packet
+    the received packet
 
 Note:
 ========================================================================
diff --git a/drivers/staging/westbridge/astoria/api/src/cyasmisc.c b/drivers/staging/westbridge/astoria/api/src/cyasmisc.c
index 7852410..5748ae6 100644
--- a/drivers/staging/westbridge/astoria/api/src/cyasmisc.c
+++ b/drivers/staging/westbridge/astoria/api/src/cyasmisc.c
@@ -428,7 +428,7 @@ my_misc_callback(cy_as_device *dev_p, uint8_t context,
 				if (v & CY_AS_MEM_P0_VM_SET_CFGMODE)
 					cy_as_hal_print_message(
 					"initialization message "
-					"recieved, but config bit "
+					"received, but config bit "
 					"still set\n");
 
 				v = cy_as_hal_read_register(dev_p->tag,
@@ -436,7 +436,7 @@ my_misc_callback(cy_as_device *dev_p, uint8_t context,
 				if ((v & CY_AS_MEM_RST_RSTCMPT) == 0)
 					cy_as_hal_print_message(
 					"initialization message "
-					"recieved, but reset complete "
+					"received, but reset complete "
 					"bit still not set\n");
 			}
 			break;
diff --git a/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c b/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c
index 0bbb8a3..d1996a2 100644
--- a/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c
+++ b/drivers/staging/westbridge/astoria/block/cyasblkdev_queue.c
@@ -222,7 +222,7 @@ static int cyasblkdev_queue_thread(void *d)
 			continue;
 		}
 
-		/* new req recieved, issue it to the driver  */
+		/* new req received, issue it to the driver  */
 		set_current_state(TASK_RUNNING);
 
 		#ifndef WESTBRIDGE_NDEBUG
diff --git a/drivers/staging/westbridge/astoria/include/linux/westbridge/cyasstorage.h b/drivers/staging/westbridge/astoria/include/linux/westbridge/cyasstorage.h
index 64f078c..8e7096b 100644
--- a/drivers/staging/westbridge/astoria/include/linux/westbridge/cyasstorage.h
+++ b/drivers/staging/westbridge/astoria/include/linux/westbridge/cyasstorage.h
@@ -1985,7 +1985,7 @@ cy_as_storage_erase(
    *	type was made
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory available
    * CY_AS_ERROR_INVALID_RESPONSE - an error message was
-   *	recieved from the firmware
+   *	received from the firmware
    * CY_AS_ERROR_MEDIA_ACCESS_FAILURE - there was error in
    *	reading from the media
    * CY_AS_ERROR_INVALID_FUNCTION - An IO attempt was made to
@@ -2047,7 +2047,7 @@ cy_as_sdio_get_c_i_s_info(
    *	pair does not exist
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory available
    * CY_AS_ERROR_INVALID_RESPONSE - an error message was
-   *	recieved from the firmware
+   *	received from the firmware
 
 */
 cy_as_return_status_t
@@ -2095,7 +2095,7 @@ cy_as_sdio_query_card(
    *	pair does not exist
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory available
    * CY_AS_ERROR_INVALID_RESPONSE - an error message was
-   *	recieved from the firmware
+   *	received from the firmware
    */
 cy_as_return_status_t
 cy_as_sdio_reset_card(
@@ -2139,7 +2139,7 @@ cy_as_sdio_reset_card(
    * CY_AS_ERROR_NO_SUCH_DEVICE - the specified media/device pair
    *	does not exist
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory available
-   * CY_AS_ERROR_INVALID_RESPONSE - an error message was recieved
+   * CY_AS_ERROR_INVALID_RESPONSE - an error message was received
    *	from the firmware
    * CY_AS_ERROR_MEDIA_ACCESS_FAILURE - there was error in reading
    *	from the media
@@ -2198,7 +2198,7 @@ cy_as_sdio_direct_read(
    * CY_AS_ERROR_NO_SUCH_DEVICE - the specified media/device
    * pair does not exist
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory available
-   * CY_AS_ERROR_INVALID_RESPONSE - an error message was recieved
+   * CY_AS_ERROR_INVALID_RESPONSE - an error message was received
    * from the firmware
    * CY_AS_ERROR_MEDIA_ACCESS_FAILURE - there was error in
    * reading from the media
@@ -2262,7 +2262,7 @@ cy_as_sdio_direct_write(
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory
    *	available
    * CY_AS_ERROR_INVALID_RESPONSE - an error message was
-   *	recieved from the firmware
+   *	received from the firmware
    * CY_AS_ERROR_MEDIA_ACCESS_FAILURE - there was error in
    *	reading from the media
    * CY_AS_ERROR_INVALID_FUNCTION - An IO attempt was made
@@ -2319,7 +2319,7 @@ cy_as_sdio_set_blocksize(
    *	pair does not exist
    * CY_AS_ERROR_ASYNC_PENDING - an async operation is pending
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory available
-   * CY_AS_ERROR_INVALID_RESPONSE - an error message was recieved
+   * CY_AS_ERROR_INVALID_RESPONSE - an error message was received
    *	from the firmware
    * CY_AS_ERROR_MEDIA_ACCESS_FAILURE - there was error in
    *	reading from the media
@@ -2396,7 +2396,7 @@ cy_as_sdio_extended_read(
    * CY_AS_ERROR_ASYNC_PENDING - an async operation is pending
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory available
    * CY_AS_ERROR_INVALID_RESPONSE - an error message was
-   *	recieved from the firmware
+   *	received from the firmware
    * CY_AS_ERROR_MEDIA_ACCESS_FAILURE - there was error in
    *	reading from the media
    * CY_AS_ERROR_INVALID_FUNCTION - An IO attempt was made
@@ -2471,7 +2471,7 @@ cy_as_sdio_extended_write(
    * pair does not exist
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory available
    * CY_AS_ERROR_INVALID_RESPONSE - an error message was
-   *	recieved from the firmware
+   *	received from the firmware
    * CY_AS_ERROR_MEDIA_ACCESS_FAILURE - there was error in
    *	reading from the media
    * CY_AS_ERROR_INVALID_FUNCTION - An IO attempt was made
@@ -2714,7 +2714,7 @@ cy_as_sdio_suspend(
    * CY_AS_ERROR_OUT_OF_MEMORY - insufficient memory
    *	available
    * CY_AS_ERROR_INVALID_RESPONSE - an error message was
-   *	recieved from the firmware
+   *	received from the firmware
    * CY_AS_ERROR_MEDIA_ACCESS_FAILURE - there was error
    *	in reading from the media
    * CY_AS_ERROR_INVALID_FUNCTION - An IO attempt was
-- 
1.7.4.2

