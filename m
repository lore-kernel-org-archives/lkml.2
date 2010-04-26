Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755027Ab0DZTac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 15:30:32 -0400
Received: from ppsw-33.csi.cam.ac.uk ([131.111.8.133]:51630 "EHLO
	ppsw-33.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab0DZT2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 15:28:33 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Jonathan Cameron <jic23@cam.ac.uk>
To: iio-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
       Jonathan Cameron <jic23@cam.ac.uk>
Subject: [PATCH 12/19] staging:iio:tsl2563: change lux to illuminanc0_input to match new abi
Date: Mon, 26 Apr 2010 20:31:14 +0100
Message-Id: <1272310281-7418-13-git-send-email-jic23@cam.ac.uk>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1272310281-7418-12-git-send-email-jic23@cam.ac.uk>
References: <1272310281-7418-1-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-2-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-3-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-4-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-5-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-6-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-7-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-8-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-9-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-10-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-11-git-send-email-jic23@cam.ac.uk>
 <1272310281-7418-12-git-send-email-jic23@cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>
---
 drivers/staging/iio/light/tsl2563.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/iio/light/tsl2563.c b/drivers/staging/iio/light/tsl2563.c
index 1ba4aa3..911c898 100644
--- a/drivers/staging/iio/light/tsl2563.c
+++ b/drivers/staging/iio/light/tsl2563.c
@@ -592,7 +592,7 @@ static ssize_t tsl2563_calib1_store(struct device *dev,
  * once I understand what they mean */
 static DEVICE_ATTR(adc0, S_IRUGO, tsl2563_adc0_show, NULL);
 static DEVICE_ATTR(adc1, S_IRUGO, tsl2563_adc1_show, NULL);
-static DEVICE_ATTR(lux, S_IRUGO, tsl2563_lux_show, NULL);
+static DEVICE_ATTR(illuminance0_input, S_IRUGO, tsl2563_lux_show, NULL);
 static DEVICE_ATTR(calib0, S_IRUGO | S_IWUSR,
 		   tsl2563_calib0_show, tsl2563_calib0_store);
 static DEVICE_ATTR(calib1, S_IRUGO | S_IWUSR,
@@ -601,7 +601,7 @@ static DEVICE_ATTR(calib1, S_IRUGO | S_IWUSR,
 static struct attribute *tsl2563_attributes[] = {
 	&dev_attr_adc0.attr,
 	&dev_attr_adc1.attr,
-	&dev_attr_lux.attr,
+	&dev_attr_illuminance0_input.attr,
 	&dev_attr_calib0.attr,
 	&dev_attr_calib1.attr,
 	NULL
-- 
1.6.4.4

