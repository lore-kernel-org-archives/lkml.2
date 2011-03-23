Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476Ab1CWKOT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 06:14:19 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:21383 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932419Ab1CWKOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 06:14:17 -0400
X-IronPort-AV: E=Sophos;i="4.63,230,1299474000"; 
   d="scan'208";a="31143247"
From: <cliff.cai@analog.com>
To: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
CC: drivers@analog.com, jic23@cam.ac.uk,
        device-drivers-devel@blackfin.uclinux.org,
        Cliff Cai <cliff.cai@analog.com>
Subject: [PATCH 3/3] Add ABI document for gyro quadrature correction
Date: Wed, 23 Mar 2011 17:15:27 +0800
Message-ID: <1300871727-32239-3-git-send-email-cliff.cai@analog.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1300871727-32239-1-git-send-email-cliff.cai@analog.com>
References: <1300871727-32239-1-git-send-email-cliff.cai@analog.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Cai <cliff.cai@analog.com>

Add ABI description for gyro_z_quadrature_correction_raw.

Signed-off-by: Cliff Cai <cliff.cai@analog.com>
---
 drivers/staging/iio/Documentation/sysfs-bus-iio |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/iio/Documentation/sysfs-bus-iio b/drivers/staging/iio/Documentation/sysfs-bus-iio
index 4915aee..1d42837 100644
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
+		present in the device at a iven time.
-- 
1.7.1

