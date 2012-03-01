Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab2CAGAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 01:00:49 -0500
Received: from mail-pz0-f51.google.com ([209.85.210.51]:53223 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab2CAGAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 01:00:47 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of justinmattock@gmail.com designates 10.68.201.135 as permitted sender) smtp.mail=justinmattock@gmail.com; dkim=pass header.i=justinmattock@gmail.com
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, jic23@cam.ac.uk,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH v2]drivers:staging:iio Fix typos and comments in staging iio.
Date: Wed, 29 Feb 2012 22:00:38 -0800
Message-Id: <1330581638-7003-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

REBASE to linux-next:
The below patch fixes some comments and some typos that I have found
while reading drivers/staging/iio/* 

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/iio/Documentation/device.txt |    2 +-
 drivers/staging/iio/Kconfig                  |    2 +-
 drivers/staging/iio/accel/lis3l02dq_ring.c   |    2 +-
 drivers/staging/iio/accel/sca3000.h          |    2 +-
 drivers/staging/iio/adc/ad7476_ring.c        |    2 +-
 drivers/staging/iio/adc/ad799x_ring.c        |    2 +-
 drivers/staging/iio/adc/max1363_core.c       |    2 +-
 drivers/staging/iio/dac/ad5446.c             |    2 +-
 drivers/staging/iio/iio.h                    |    8 ++++----
 drivers/staging/iio/iio_dummy_evgen.c        |    2 +-
 drivers/staging/iio/industrialio-core.c      |    4 ++--
 drivers/staging/iio/light/tsl2583.c          |    2 +-
 drivers/staging/iio/magnetometer/hmc5843.c   |    6 +++---
 drivers/staging/iio/meter/ade7758_ring.c     |    2 +-
 drivers/staging/iio/meter/meter.h            |    2 +-
 drivers/staging/iio/ring_sw.c                |    4 ++--
 16 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/iio/Documentation/device.txt b/drivers/staging/iio/Documentation/device.txt
index 1abb80c..8926f24 100644
--- a/drivers/staging/iio/Documentation/device.txt
+++ b/drivers/staging/iio/Documentation/device.txt
@@ -62,7 +62,7 @@ Then fill in the following:
 	An optional associated buffer.
 - indio_dev->pollfunc:
 	Poll function related elements. This controls what occurs when a trigger
-	to which this device is attached sends and event.
+	to which this device is attached sends an event.
 - indio_dev->channels:
 	Specification of device channels. Most attributes etc are built
 	form this spec.
diff --git a/drivers/staging/iio/Kconfig b/drivers/staging/iio/Kconfig
index 24c6ed9..fe15867 100644
--- a/drivers/staging/iio/Kconfig
+++ b/drivers/staging/iio/Kconfig
@@ -86,7 +86,7 @@ config IIO_SIMPLE_DUMMY
        help
 	 Driver intended mainly as documentation for how to write
 	 a driver. May also be useful for testing userspace code
-	 without hardward.
+	 without hardware.
 
 if IIO_SIMPLE_DUMMY
 
diff --git a/drivers/staging/iio/accel/lis3l02dq_ring.c b/drivers/staging/iio/accel/lis3l02dq_ring.c
index ca0a1fe..0fc3973 100644
--- a/drivers/staging/iio/accel/lis3l02dq_ring.c
+++ b/drivers/staging/iio/accel/lis3l02dq_ring.c
@@ -239,7 +239,7 @@ static int lis3l02dq_data_rdy_trigger_set_state(struct iio_trigger *trig,
 	__lis3l02dq_write_data_ready_config(&indio_dev->dev, state);
 	if (state == false) {
 		/*
-		 * A possible quirk with teh handler is currently worked around
+		 * A possible quirk with the handler is currently worked around
 		 *  by ensuring outstanding read events are cleared.
 		 */
 		ret = lis3l02dq_read_all(indio_dev, NULL);
diff --git a/drivers/staging/iio/accel/sca3000.h b/drivers/staging/iio/accel/sca3000.h
index ad38dd9..131daac 100644
--- a/drivers/staging/iio/accel/sca3000.h
+++ b/drivers/staging/iio/accel/sca3000.h
@@ -136,7 +136,7 @@
 #define SCA3000_INT_MASK_ACTIVE_HIGH		0x01
 #define SCA3000_INT_MASK_ACTIVE_LOW		0x00
 
-/* Values of mulipexed registers (write to ctrl_data after select) */
+/* Values of multiplexed registers (write to ctrl_data after select) */
 #define SCA3000_REG_ADDR_CTRL_DATA		0x22
 
 /* Measurement modes available on some sca3000 series chips. Code assumes others
diff --git a/drivers/staging/iio/adc/ad7476_ring.c b/drivers/staging/iio/adc/ad7476_ring.c
index 35a8576..d6af6c0 100644
--- a/drivers/staging/iio/adc/ad7476_ring.c
+++ b/drivers/staging/iio/adc/ad7476_ring.c
@@ -23,7 +23,7 @@
 /**
  * ad7476_ring_preenable() setup the parameters of the ring before enabling
  *
- * The complex nature of the setting of the nuber of bytes per datum is due
+ * The complex nature of the setting of the number of bytes per datum is due
  * to this driver currently ensuring that the timestamp is stored at an 8
  * byte boundary.
  **/
diff --git a/drivers/staging/iio/adc/ad799x_ring.c b/drivers/staging/iio/adc/ad799x_ring.c
index 28e9a41..069765c 100644
--- a/drivers/staging/iio/adc/ad799x_ring.c
+++ b/drivers/staging/iio/adc/ad799x_ring.c
@@ -26,7 +26,7 @@
 /**
  * ad799x_ring_preenable() setup the parameters of the ring before enabling
  *
- * The complex nature of the setting of the nuber of bytes per datum is due
+ * The complex nature of the setting of the number of bytes per datum is due
  * to this driver currently ensuring that the timestamp is stored at an 8
  * byte boundary.
  **/
diff --git a/drivers/staging/iio/adc/max1363_core.c b/drivers/staging/iio/adc/max1363_core.c
index 7f39ca3..cf3e2ca 100644
--- a/drivers/staging/iio/adc/max1363_core.c
+++ b/drivers/staging/iio/adc/max1363_core.c
@@ -341,7 +341,7 @@ static struct iio_chan_spec max1361_channels[] =
 static struct iio_chan_spec max1363_channels[] =
 	MAX1363_4X_CHANS(12, MAX1363_EV_M);
 
-/* Appies to max1236, max1237 */
+/* Applies to max1236, max1237 */
 static const enum max1363_modes max1236_mode_list[] = {
 	_s0, _s1, _s2, _s3,
 	s0to1, s0to2, s0to3,
diff --git a/drivers/staging/iio/dac/ad5446.c b/drivers/staging/iio/dac/ad5446.c
index e439bae..633ffbb 100644
--- a/drivers/staging/iio/dac/ad5446.c
+++ b/drivers/staging/iio/dac/ad5446.c
@@ -334,7 +334,7 @@ static int __devinit ad5446_probe(struct spi_device *spi)
 	st->reg = reg;
 	st->spi = spi;
 
-	/* Estabilish that the iio_dev is a child of the spi device */
+	/* Establish that the iio_dev is a child of the spi device */
 	indio_dev->dev.parent = &spi->dev;
 	indio_dev->name = spi_get_device_id(spi)->name;
 	if (st->chip_info->store_pwr_down)
diff --git a/drivers/staging/iio/iio.h b/drivers/staging/iio/iio.h
index 76a3f50..6aa31e5 100644
--- a/drivers/staging/iio/iio.h
+++ b/drivers/staging/iio/iio.h
@@ -26,7 +26,7 @@ enum iio_data_type {
 
 /* Could add the raw attributes as well - allowing buffer only devices */
 enum iio_chan_info_enum {
-	/* 0 is reserverd for raw attributes */
+	/* 0 is reserved for raw attributes */
 	IIO_CHAN_INFO_SCALE = 1,
 	IIO_CHAN_INFO_OFFSET,
 	IIO_CHAN_INFO_CALIBSCALE,
@@ -110,7 +110,7 @@ struct iio_chan_spec_ext_info {
 /**
  * struct iio_chan_spec - specification of a single channel
  * @type:		What type of measurement is the channel making.
- * @channel:		What number or name do we wish to asign the channel.
+ * @channel:		What number or name do we wish to assign the channel.
  * @channel2:		If there is a second number for a differential
  *			channel then this is it. If modified is set then the
  *			value here specifies the modifier.
@@ -133,7 +133,7 @@ struct iio_chan_spec_ext_info {
  *			informative name. Note this has no effect codes etc,
  *			unlike modifiers.
  * @datasheet_name:	A name used in in kernel mapping of channels. It should
- *			corrspond to the first name that the channel is referred
+ *			correspond to the first name that the channel is referred
  *			to by in the datasheet (e.g. IND), or the nearest
  *			possible compound name (e.g. IND-INC).
  * @processed_val:	Flag to specify the data access attribute should be
@@ -243,7 +243,7 @@ struct iio_dev;
  * @write_event_config:	set if the event is enabled.
  * @read_event_value:	read a value associated with the event. Meaning
  *			is event dependant. event_code specifies which event.
- * @write_event_value:	write the value associate with the event.
+ * @write_event_value:	write the value associated with the event.
  *			Meaning is event dependent.
  * @validate_trigger:	function to validate the trigger when the
  *			current trigger gets changed.
diff --git a/drivers/staging/iio/iio_dummy_evgen.c b/drivers/staging/iio/iio_dummy_evgen.c
index cdbf289..f39f346 100644
--- a/drivers/staging/iio/iio_dummy_evgen.c
+++ b/drivers/staging/iio/iio_dummy_evgen.c
@@ -32,7 +32,7 @@
  * @chip: irq chip we are faking
  * @base: base of irq range
  * @enabled: mask of which irqs are enabled
- * @inuse: mask of which irqs actually have anyone connected
+ * @inuse: mask of which irqs are connected
  * @lock: protect the evgen state
  */
 struct iio_dummy_eventgen {
diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index 645bb45..0b8ba8f 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -313,7 +313,7 @@ int __iio_device_attr_init(struct device_attribute *dev_attr,
 		goto error_ret;
 	}
 
-	if (chan->differential) { /* Differential  can not have modifier */
+	if (chan->differential) { /* Differential can not have modifier */
 		if (generic)
 			name_format
 				= kasprintf(GFP_KERNEL, "%s_%s-%s_%s",
@@ -547,7 +547,7 @@ static int iio_device_register_sysfs(struct iio_dev *indio_dev)
 	attrcount = attrcount_orig;
 	/*
 	 * New channel registration method - relies on the fact a group does
-	 *  not need to be initialized if it is name is NULL.
+	 * not need to be initialized if it is name is NULL.
 	 */
 	INIT_LIST_HEAD(&indio_dev->channel_attr_list);
 	if (indio_dev->channels)
diff --git a/drivers/staging/iio/light/tsl2583.c b/drivers/staging/iio/light/tsl2583.c
index 9fe9a67..8671d98 100644
--- a/drivers/staging/iio/light/tsl2583.c
+++ b/drivers/staging/iio/light/tsl2583.c
@@ -113,7 +113,7 @@ struct taos_lux {
 
 /* This structure is intentionally large to accommodate updates via sysfs. */
 /* Sized to 11 = max 10 segments + 1 termination segment */
-/* Assumption is is one and only one type of glass used  */
+/* Assumption is one and only one type of glass used  */
 static struct taos_lux taos_device_lux[11] = {
 	{  9830,  8520, 15729 },
 	{ 12452, 10807, 23344 },
diff --git a/drivers/staging/iio/magnetometer/hmc5843.c b/drivers/staging/iio/magnetometer/hmc5843.c
index d24992c..91dd3da 100644
--- a/drivers/staging/iio/magnetometer/hmc5843.c
+++ b/drivers/staging/iio/magnetometer/hmc5843.c
@@ -86,7 +86,7 @@
 #define	RATE_NOT_USED				0x07
 
 /*
- * Device Configutration
+ * Device Configuration
  */
 #define	CONF_NORMAL				0x00
 #define	CONF_POSITIVE_BIAS			0x01
@@ -142,7 +142,7 @@ static s32 hmc5843_configure(struct i2c_client *client,
 					(operating_mode & 0x03));
 }
 
-/* Return the measurement value from the  specified channel */
+/* Return the measurement value from the specified channel */
 static int hmc5843_read_measurement(struct iio_dev *indio_dev,
 				    int address,
 				    int *val)
@@ -169,7 +169,7 @@ static int hmc5843_read_measurement(struct iio_dev *indio_dev,
 /*
  * From the datasheet
  * 0 - Continuous-Conversion Mode: In continuous-conversion mode, the
- * device continuously performs conversions an places the result in the
+ * device continuously performs conversions and places the result in the
  * data register.
  *
  * 1 - Single-Conversion Mode : device performs a single measurement,
diff --git a/drivers/staging/iio/meter/ade7758_ring.c b/drivers/staging/iio/meter/ade7758_ring.c
index c5c522b..c45b23b 100644
--- a/drivers/staging/iio/meter/ade7758_ring.c
+++ b/drivers/staging/iio/meter/ade7758_ring.c
@@ -85,7 +85,7 @@ static irqreturn_t ade7758_trigger_handler(int irq, void *p)
 /**
  * ade7758_ring_preenable() setup the parameters of the ring before enabling
  *
- * The complex nature of the setting of the nuber of bytes per datum is due
+ * The complex nature of the setting of the number of bytes per datum is due
  * to this driver currently ensuring that the timestamp is stored at an 8
  * byte boundary.
  **/
diff --git a/drivers/staging/iio/meter/meter.h b/drivers/staging/iio/meter/meter.h
index 142c50d..6a3db14 100644
--- a/drivers/staging/iio/meter/meter.h
+++ b/drivers/staging/iio/meter/meter.h
@@ -362,7 +362,7 @@
 #define IIO_EVENT_ATTR_CYCEND(_evlist, _show, _store, _mask) \
 	IIO_EVENT_ATTR_SH(cycend, _evlist, _show, _store, _mask)
 
-/* on the rising and falling edge of the the voltage waveform */
+/* on the rising and falling edge of the voltage waveform */
 #define IIO_EVENT_ATTR_ZERO_CROSS(_evlist, _show, _store, _mask) \
 	IIO_EVENT_ATTR_SH(zero_cross, _evlist, _show, _store, _mask)
 
diff --git a/drivers/staging/iio/ring_sw.c b/drivers/staging/iio/ring_sw.c
index eeac0da..b9945ec 100644
--- a/drivers/staging/iio/ring_sw.c
+++ b/drivers/staging/iio/ring_sw.c
@@ -147,7 +147,7 @@ static int iio_read_first_n_sw_rb(struct iio_buffer *r,
 	size_t data_available, buffer_size;
 
 	/* A userspace program has probably made an error if it tries to
-	 *  read something that is not a whole number of bpds.
+	 * read something that is not a whole number of bpds.
 	 * Return an error.
 	 */
 	if (n % ring->buf.bytes_per_datum) {
@@ -229,7 +229,7 @@ static int iio_read_first_n_sw_rb(struct iio_buffer *r,
 
 	/* setup the next read position */
 	/* Beware, this may fail due to concurrency fun and games.
-	 *  Possible that sufficient fill commands have run to push the read
+	 * Possible that sufficient fill commands have run to push the read
 	 * pointer past where we would be after the rip. If this occurs, leave
 	 * it be.
 	 */
-- 
1.7.5.4

