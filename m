Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab1DLOtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:49:31 -0400
Received: from kroah.org ([198.145.64.141]:57627 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932262Ab1DLOiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:20 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:54 2011
Message-Id: <20110412143554.181505970@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:47 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [058/105] staging: IIO: IMU: ADIS16400: Fix addresses of GYRO and ACCEL calibration offset
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Hennerich <michael.hennerich@analog.com>

commit b181119723d62b19904e1f12e467e996631c5a29 upstream.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/iio/imu/adis16400_core.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/staging/iio/imu/adis16400_core.c
+++ b/drivers/staging/iio/imu/adis16400_core.c
@@ -495,12 +495,12 @@ err_ret:
 			_reg)
 
 static ADIS16400_DEV_ATTR_CALIBBIAS(GYRO_X, ADIS16400_XGYRO_OFF);
-static ADIS16400_DEV_ATTR_CALIBBIAS(GYRO_Y, ADIS16400_XGYRO_OFF);
-static ADIS16400_DEV_ATTR_CALIBBIAS(GYRO_Z, ADIS16400_XGYRO_OFF);
+static ADIS16400_DEV_ATTR_CALIBBIAS(GYRO_Y, ADIS16400_YGYRO_OFF);
+static ADIS16400_DEV_ATTR_CALIBBIAS(GYRO_Z, ADIS16400_ZGYRO_OFF);
 
 static ADIS16400_DEV_ATTR_CALIBBIAS(ACCEL_X, ADIS16400_XACCL_OFF);
-static ADIS16400_DEV_ATTR_CALIBBIAS(ACCEL_Y, ADIS16400_XACCL_OFF);
-static ADIS16400_DEV_ATTR_CALIBBIAS(ACCEL_Z, ADIS16400_XACCL_OFF);
+static ADIS16400_DEV_ATTR_CALIBBIAS(ACCEL_Y, ADIS16400_YACCL_OFF);
+static ADIS16400_DEV_ATTR_CALIBBIAS(ACCEL_Z, ADIS16400_ZACCL_OFF);
 
 
 static IIO_DEV_ATTR_IN_NAMED_RAW(0, supply, adis16400_read_14bit_signed,


