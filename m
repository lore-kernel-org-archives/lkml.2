Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab2EGQSq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 12:18:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50253 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756857Ab2EGQSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 12:18:44 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: devel@driverdev.osuosl.org, linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] staging, iio: Fix typo in iio
Date: Tue,  8 May 2012 01:18:42 +0900
Message-Id: <1336407522-13818-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.10.1.457.g8275905
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in staging/iio

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/staging/iio/TODO                      | 2 +-
 drivers/staging/iio/gyro/adxrs450.h           | 2 +-
 drivers/staging/iio/iio_simple_dummy_buffer.c | 4 ++--
 drivers/staging/iio/iio_simple_dummy_events.c | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/iio/TODO b/drivers/staging/iio/TODO
index d1ad35e..cf3f948 100644
--- a/drivers/staging/iio/TODO
+++ b/drivers/staging/iio/TODO
@@ -67,7 +67,7 @@ e-mailing the normal IIO list (see below).
 
 Documentation
 1) Lots of cleanup and expansion.
-2) Some device require indvidual docs.
+2) Some device require individual docs.
 
 Contact: Jonathan Cameron <jic23@cam.ac.uk>.
 Mailing list: linux-iio@vger.kernel.org
diff --git a/drivers/staging/iio/gyro/adxrs450.h b/drivers/staging/iio/gyro/adxrs450.h
index af0c870..f8cf21f 100644
--- a/drivers/staging/iio/gyro/adxrs450.h
+++ b/drivers/staging/iio/gyro/adxrs450.h
@@ -49,7 +49,7 @@ enum {
  * @us:			actual spi_device
  * @buf_lock:		mutex to protect tx and rx
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  **/
 struct adxrs450_state {
 	struct spi_device	*us;
diff --git a/drivers/staging/iio/iio_simple_dummy_buffer.c b/drivers/staging/iio/iio_simple_dummy_buffer.c
index bb4daf7..389c18a 100644
--- a/drivers/staging/iio/iio_simple_dummy_buffer.c
+++ b/drivers/staging/iio/iio_simple_dummy_buffer.c
@@ -37,7 +37,7 @@ static const s16 fakedata[] = {
  * @irq: the interrupt number
  * @p: private data - always a pointer to the poll func.
  *
- * This is the guts of buffered capture. On a trigger event occuring,
+ * This is the guts of buffered capture. On a trigger event occurring,
  * if the pollfunc is attached then this handler is called as a threaded
  * interrupt (and hence may sleep). It is responsible for grabbing data
  * from the device and pushing it into the associated buffer.
@@ -64,7 +64,7 @@ static irqreturn_t iio_simple_dummy_trigger_h(int irq, void *p)
 		 *   up a fast read.  The capture will consist of all of them.
 		 *   Hence we just call the grab data function and fill the
 		 *   buffer without processing.
-		 * sofware scans: can be considered to be random access
+		 * software scans: can be considered to be random access
 		 *   so efficient reading is just a case of minimal bus
 		 *   transactions.
 		 * software culled hardware scans:
diff --git a/drivers/staging/iio/iio_simple_dummy_events.c b/drivers/staging/iio/iio_simple_dummy_events.c
index 449c7a5..368317b 100644
--- a/drivers/staging/iio/iio_simple_dummy_events.c
+++ b/drivers/staging/iio/iio_simple_dummy_events.c
@@ -122,7 +122,7 @@ int iio_simple_dummy_write_event_value(struct iio_dev *indio_dev,
  * @private: pointer to device instance state.
  *
  * This handler is responsible for querying the device to find out what
- * event occured and for then pushing that event towards userspace.
+ * event occurred and for then pushing that event towards userspace.
  * Here only one event occurs so we push that directly on with locally
  * grabbed timestamp.
  */
-- 
1.7.10.1.457.g8275905

