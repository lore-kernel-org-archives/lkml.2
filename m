Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476Ab2FNQNt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 12:13:49 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37470 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756453Ab2FNQNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 12:13:46 -0400
From: Leed Aguilar <leed.aguilar@ti.com>
To: <linux-kernel@vger.kernel.org>, <gregkh@linuxfoundation.org>
CC: <leed.aguilar@ti.com>, Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH] staging:iio:gyro:adis16080: remove sparse warnings
Date: Thu, 14 Jun 2012 11:05:31 -0400
Message-ID: <1339686331-9788-1-git-send-email-leed.aguilar@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed the following sparse warning:

In function 'adis16080_read_raw':
warning: 'ut' may be used uninitialized in this function

Signed-off-by: Leed Aguilar <leed.aguilar@ti.com>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jonathan Cameron <jic23@kernel.org>
---
 drivers/staging/iio/gyro/adis16080_core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/iio/gyro/adis16080_core.c b/drivers/staging/iio/gyro/adis16080_core.c
index 11f1dcc..345e4fa 100644
--- a/drivers/staging/iio/gyro/adis16080_core.c
+++ b/drivers/staging/iio/gyro/adis16080_core.c
@@ -82,7 +82,7 @@ static int adis16080_read_raw(struct iio_dev *indio_dev,
 			     long mask)
 {
 	int ret = -EINVAL;
-	u16 ut;
+	u16 ut = 0;
 	/* Take the iio_dev status lock */
 
 	mutex_lock(&indio_dev->mlock);
-- 
1.7.1

