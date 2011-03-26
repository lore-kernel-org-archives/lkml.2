Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960Ab1CZBkD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 21:40:03 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:33193 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755749Ab1CZBj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 21:39:57 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18H7z4NUQQHY7cQj0SSp2xzlxH4GN72kGQGwrWKpU
	udpmMReCen35ba
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Harry Wei <jiaweiwei.xiyou@gmail.com>,
        Peter Huewe <peterhuewe@gmx.de>
Subject: [PATCH 10/27] staging/iio: Fix common spelling mistakes
Date: Sat, 26 Mar 2011 02:39:19 +0100
Message-Id: <1301103576-16109-10-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1301103576-16109-8-git-send-email-peterhuewe@gmx.de>
References: <1301103576-16109-8-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some very common spelling mistakes in
drivers/staging/iio

WRONG -> RIGHT
occured     -> occurred
interupt	-> interrupt
managable	-> manageable
recieve     -> receive
writen		-> written

Kernel Version: staging/staging-next 20110325 (4bbba111)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/iio/Documentation/iio_utils.h |    2 +-
 drivers/staging/iio/accel/adis16201.h         |    2 +-
 drivers/staging/iio/accel/adis16203.h         |    2 +-
 drivers/staging/iio/accel/adis16204.h         |    2 +-
 drivers/staging/iio/accel/adis16209.h         |    2 +-
 drivers/staging/iio/accel/adis16220.h         |    2 +-
 drivers/staging/iio/accel/adis16240.h         |    2 +-
 drivers/staging/iio/accel/lis3l02dq.h         |   26 ++++++++++++------------
 drivers/staging/iio/accel/lis3l02dq_core.c    |    2 +-
 drivers/staging/iio/accel/lis3l02dq_ring.c    |    4 +-
 drivers/staging/iio/accel/sca3000.h           |    2 +-
 drivers/staging/iio/adc/max1363_core.c        |    2 +-
 drivers/staging/iio/chrdev.h                  |    2 +-
 drivers/staging/iio/gyro/adis16060_core.c     |    2 +-
 drivers/staging/iio/gyro/adis16080_core.c     |    2 +-
 drivers/staging/iio/gyro/adis16260.h          |    2 +-
 drivers/staging/iio/iio.h                     |    2 +-
 drivers/staging/iio/imu/adis16300.h           |    2 +-
 drivers/staging/iio/imu/adis16350.h           |    2 +-
 drivers/staging/iio/imu/adis16400.h           |    2 +-
 drivers/staging/iio/meter/ade7753.h           |    2 +-
 drivers/staging/iio/meter/ade7754.h           |    2 +-
 drivers/staging/iio/meter/ade7758.h           |    2 +-
 drivers/staging/iio/meter/ade7759.h           |    2 +-
 drivers/staging/iio/meter/ade7854.h           |    2 +-
 25 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/iio/Documentation/iio_utils.h b/drivers/staging/iio/Documentation/iio_utils.h
index 8095727..fd78e4f 100644
--- a/drivers/staging/iio/Documentation/iio_utils.h
+++ b/drivers/staging/iio/Documentation/iio_utils.h
@@ -556,7 +556,7 @@ int _write_sysfs_string(char *filename, char *basedir, char *val, int verify)
 		if (strcmp(temp, val) != 0) {
 			printf("Possible failure in string write of %s "
 				"Should be %s "
-				"writen to %s\%s\n",
+				"written to %s\%s\n",
 				temp,
 				val,
 				basedir,
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
index 579b3a2..3e4dd00 100644
--- a/drivers/staging/iio/accel/lis3l02dq.h
+++ b/drivers/staging/iio/accel/lis3l02dq.h
@@ -57,7 +57,7 @@
 /* Reboot memory content */
 #define LIS3L02DQ_REG_CTRL_2_REBOOT_MEMORY	0x10
 
-/* Interupt Enable - applies data ready to the RDY pad */
+/* Interrupt Enable - applies data ready to the RDY pad */
 #define LIS3L02DQ_REG_CTRL_2_ENABLE_INTERRUPT	0x08
 
 /* Enable Data Ready Generation - relationship with previous unclear in docs */
@@ -70,36 +70,36 @@
  * - option for 16 bit left justified */
 #define LIS3L02DQ_REG_CTRL_2_DATA_ALIGNMENT_16_BIT_LEFT_JUSTIFIED	0x01
 
-/* Interupt related stuff */
+/* Interrupt related stuff */
 #define LIS3L02DQ_REG_WAKE_UP_CFG_ADDR			0x23
 
 /* Switch from or combination fo conditions to and */
 #define LIS3L02DQ_REG_WAKE_UP_CFG_BOOLEAN_AND		0x80
 
-/* Latch interupt request,
+/* Latch interrupt request,
  * if on ack must be given by reading the ack register */
 #define LIS3L02DQ_REG_WAKE_UP_CFG_LATCH_SRC		0x40
 
-/* Z Interupt on High (above threshold)*/
+/* Z Interrupt on High (above threshold)*/
 #define LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_Z_HIGH	0x20
-/* Z Interupt on Low */
+/* Z Interrupt on Low */
 #define LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_Z_LOW	0x10
-/* Y Interupt on High */
+/* Y Interrupt on High */
 #define LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_Y_HIGH	0x08
-/* Y Interupt on Low */
+/* Y Interrupt on Low */
 #define LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_Y_LOW	0x04
-/* X Interupt on High */
+/* X Interrupt on High */
 #define LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_X_HIGH	0x02
-/* X Interupt on Low */
+/* X Interrupt on Low */
 #define LIS3L02DQ_REG_WAKE_UP_CFG_INTERRUPT_X_LOW 0x01
 
-/* Register that gives description of what caused interupt
+/* Register that gives description of what caused interrupt
  * - latched if set in CFG_ADDRES */
 #define LIS3L02DQ_REG_WAKE_UP_SRC_ADDR			0x24
 /* top bit ignored */
-/* Interupt Active */
+/* Interrupt Active */
 #define LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_ACTIVATED	0x40
-/* Interupts that have been triggered */
+/* Interrupts that have been triggered */
 #define LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Z_HIGH	0x20
 #define LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Z_LOW	0x10
 #define LIS3L02DQ_REG_WAKE_UP_SRC_INTERRUPT_Y_HIGH	0x08
@@ -155,7 +155,7 @@ Form of high byte dependant on justification set in ctrl reg */
  * @inter:		used to check if new interrupt has been triggered
  * @trig:		data ready trigger registered with iio
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct lis3l02dq_state {
diff --git a/drivers/staging/iio/accel/lis3l02dq_core.c b/drivers/staging/iio/accel/lis3l02dq_core.c
index c4b4ab7..3067f96 100644
--- a/drivers/staging/iio/accel/lis3l02dq_core.c
+++ b/drivers/staging/iio/accel/lis3l02dq_core.c
@@ -77,7 +77,7 @@ int lis3l02dq_spi_read_reg_8(struct device *dev, u8 reg_address, u8 *val)
 /**
  * lis3l02dq_spi_write_reg_8() - write single byte to a register
  * @dev: device associated with child of actual device (iio_dev or iio_trig)
- * @reg_address: the address of the register to be writen
+ * @reg_address: the address of the register to be written
  * @val: the value to write
  **/
 int lis3l02dq_spi_write_reg_8(struct device *dev,
diff --git a/drivers/staging/iio/accel/lis3l02dq_ring.c b/drivers/staging/iio/accel/lis3l02dq_ring.c
index 2c461a3..529a3cc 100644
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
@@ -409,7 +409,7 @@ static const struct attribute_group lis3l02dq_trigger_attr_group = {
  *
  * As the trigger may occur on any data element being updated it is
  * really rather likely to occur during the read from the previous
- * trigger event.  The only way to discover if this has occured on
+ * trigger event.  The only way to discover if this has occurred on
  * boards not supporting level interrupts is to take a look at the line.
  * If it is indicating another interrupt and we don't seem to have a
  * handler looking at it, then we need to notify the core that we need
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
diff --git a/drivers/staging/iio/adc/max1363_core.c b/drivers/staging/iio/adc/max1363_core.c
index dde097a..adef546 100644
--- a/drivers/staging/iio/adc/max1363_core.c
+++ b/drivers/staging/iio/adc/max1363_core.c
@@ -1425,7 +1425,7 @@ error_ret:
 }
 
 /*
- * To keep this managable we always use one of 3 scan modes.
+ * To keep this manageable we always use one of 3 scan modes.
  * Scan 0...3, 0-1,2-3 and 1-0,3-2
  */
 static inline int __max1363_check_event_mask(int thismask, int checkmask)
diff --git a/drivers/staging/iio/chrdev.h b/drivers/staging/iio/chrdev.h
index 98d1a2c..bfbb22e 100644
--- a/drivers/staging/iio/chrdev.h
+++ b/drivers/staging/iio/chrdev.h
@@ -42,7 +42,7 @@ struct iio_event_data {
 };
 
 /**
- * struct iio_detected_event_list - list element for events that have occured
+ * struct iio_detected_event_list - list element for events that have occurred
  * @list:		linked list header
  * @ev:			the event itself
  * @shared_pointer:	used when the event is shared - i.e. can be escallated
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
-- 
1.7.3.4

