Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933228Ab1CXHB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 03:01:58 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:15637 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933010Ab1CXHB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 03:01:56 -0400
X-IronPort-AV: E=Sophos;i="4.63,236,1299474000"; 
   d="scan'208";a="30737575"
From: <cliff.cai@analog.com>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
CC: drivers@analog.com, jic23@cam.ac.uk,
        device-drivers-devel@blackfin.uclinux.org,
        Cliff Cai <cliff.cai@analog.com>
Subject: [PATCH 2/2 RESEND v2] Add ABI document for gyro quadrature correction
Date: Thu, 24 Mar 2011 14:03:03 +0800
Message-ID: <1300946583-1715-2-git-send-email-cliff.cai@analog.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1300946583-1715-1-git-send-email-cliff.cai@analog.com>
References: <1300946583-1715-1-git-send-email-cliff.cai@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Cai <cliff.cai@analog.com>

Change v2:v1:
	Fix typo

Signed-off-by: Cliff Cai <cliff.cai@analog.com>
---
 drivers/staging/iio/Documentation/sysfs-bus-iio |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio b/drivers/staging/iio/Documentation/sysfs-bus-iio
index 4915aee..824a56c 100644
--- a/drivers/staging/iio/Documentation/sysfs-bus-iio
+++ b/drivers/staging/iio/Documentation/sysfs-bus-iio
@@ -698,3 +698,10 @@ Description:
 		with all _en attributes to establish which channels are present,
 		and the relevant _type attributes to establish the data storage
 		format.
+
+What:		/sys/bus/iio/devices/deviceX/gyro_z_quadrature_correction_raw
+KernelVersion:	2.6.38
+Contact:	linux-iio@vger.kernel.org
+Description:
+		This attribute is used to read the amount of quadrature error
+		present in the device at a given time.
-- 
1.7.1

