Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab0DZT2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:28:32 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:51596 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754690Ab0DZT2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:28:30 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: iio-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 02/19] staging:iio: Add new attrs for sampling frequency available and temp_raw
Date: Mon, 26 Apr 2010 20:31:04 +0100
Message-Id: <1272310281-7418-3-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1272310281-7418-2-git-send-email-jic23@cam.ac.uk>
References: <1272310281-7418-1-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-2-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/sysfs.h |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/iio/sysfs.h b/drivers/staging/iio/sysfs.h
index d8fe0e2..afcf5ab 100644
--- a/drivers/staging/iio/sysfs.h
+++ b/drivers/staging/iio/sysfs.h
@@ -144,18 +144,25 @@ struct iio_const_attr {
  *
  * May be mode dependent on some devices
  **/
+/* Deprecated */
 #define IIO_DEV_ATTR_AVAIL_SAMP_FREQ(_show)				\
 	IIO_DEVICE_ATTR(available_sampling_frequency, S_IRUGO, _show, NULL, 0)
 
+#define IIO_DEV_ATTR_SAMP_FREQ_AVAIL(_show)				\
+	IIO_DEVICE_ATTR(sampling_frequency_available, S_IRUGO, _show, NULL, 0)
 /**
  * IIO_CONST_ATTR_AVAIL_SAMP_FREQ - list available sampling frequencies
  * @_string: frequency string for the attribute
  *
  * Constant version
  **/
-#define IIO_CONST_ATTR_AVAIL_SAMP_FREQ(_string)	\
+/* Deprecated */
+#define IIO_CONST_ATTR_AVAIL_SAMP_FREQ(_string)			\
 	IIO_CONST_ATTR(available_sampling_frequency, _string)
 
+#define IIO_CONST_ATTR_SAMP_FREQ_AVAIL(_string)			\
+	IIO_CONST_ATTR(sampling_frequency_available, _string)
+
 /**
  * IIO_DEV_ATTR_SCAN_MODE - select a scan mode
  * @_mode: sysfs file mode/permissions
@@ -234,6 +241,9 @@ struct iio_const_attr {
 #define IIO_DEV_ATTR_TEMP(_show)			\
 	IIO_DEVICE_ATTR(temp, S_IRUGO, _show, NULL, 0)
 
+#define IIO_DEV_ATTR_TEMP_RAW(_show)			\
+	IIO_DEVICE_ATTR(temp_raw, S_IRUGO, _show, NULL, 0)
+
 /**
  * IIO_EVENT_SH - generic shared event handler
  * @_name: event name
-- 
1.6.4.4

