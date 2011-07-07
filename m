Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab1GGTDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:03:01 -0400
Received: from smtp-out.google.com ([216.239.44.51]:15456 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab1GGTCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:02:16 -0400
From: Bryan Freed <bfreed@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: jic23@cam.ac.uk, gregkh@suse.de, rklein@nvidia.com,
        linux-iio@vger.kernel.org, Bryan Freed <bfreed@chromium.org>
Subject: [PATCH v2 1/4] staging:iio: Reorder channel type strings to match the iio.h enums.
Date: Thu,  7 Jul 2011 12:01:54 -0700
Message-Id: <1310065317-3872-2-git-send-email-bfreed@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1310065317-3872-1-git-send-email-bfreed@chromium.org>
References: <1310065317-3872-1-git-send-email-bfreed@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes comparison between the iio_chan_type_name_spec_shared strings
and the iio_chan_type enums easier.

Signed-off-by: Bryan Freed <bfreed@chromium.org>
---
 drivers/staging/iio/industrialio-core.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
index 8fa2be6..52a02af 100644
--- a/drivers/staging/iio/industrialio-core.c
+++ b/drivers/staging/iio/industrialio-core.c
@@ -44,21 +44,21 @@ struct bus_type iio_bus_type = {
 EXPORT_SYMBOL(iio_bus_type);
 
 static const char * const iio_chan_type_name_spec_shared[] = {
-	[IIO_TIMESTAMP] = "timestamp",
-	[IIO_ACCEL] = "accel",
 	[IIO_IN] = "in",
 	[IIO_OUT] = "out",
 	[IIO_CURRENT] = "current",
 	[IIO_POWER] = "power",
+	[IIO_ACCEL] = "accel",
 	[IIO_IN_DIFF] = "in-in",
 	[IIO_GYRO] = "gyro",
-	[IIO_TEMP] = "temp",
 	[IIO_MAGN] = "magn",
+	[IIO_LIGHT] = "illuminance",
+	[IIO_INTENSITY] = "intensity",
+	[IIO_TEMP] = "temp",
 	[IIO_INCLI] = "incli",
 	[IIO_ROT] = "rot",
-	[IIO_INTENSITY] = "intensity",
-	[IIO_LIGHT] = "illuminance",
 	[IIO_ANGL] = "angl",
+	[IIO_TIMESTAMP] = "timestamp",
 };
 
 static const char * const iio_chan_type_name_spec_complex[] = {
-- 
1.7.3.1

