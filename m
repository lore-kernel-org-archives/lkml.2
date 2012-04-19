Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab2DSLPw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 07:15:52 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2966 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737Ab2DSLPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 07:15:48 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 19 Apr 2012 04:15:47 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: jic23@cam.ac.uk, gregkh@linuxfoundation.org, max@stro.at,
        jbrenner@taosinc.com, bfreed@chromium.org, lars@metafoo.de,
        grundler@chromium.org
Cc: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 1/2] staging: iio: light: convert multiple spaces to tab
Date: Thu, 19 Apr 2012 16:45:08 +0530
Message-Id: <1334834109-30183-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1334834109-30183-1-git-send-email-ldewangan@nvidia.com>
References: <1334834109-30183-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using tab inplace of multiple spaces for indenting.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
As per Jonathan's feedback, creating this patch for only
indenting cleanups.
No changes from V2.

 drivers/staging/iio/light/Kconfig |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/iio/light/Kconfig b/drivers/staging/iio/light/Kconfig
index 53b49f7..bb633f6 100644
--- a/drivers/staging/iio/light/Kconfig
+++ b/drivers/staging/iio/light/Kconfig
@@ -4,15 +4,15 @@
 menu "Light sensors"
 
 config SENSORS_ISL29018
-        tristate "ISL 29018 light and proximity sensor"
-        depends on I2C
-        default n
-        help
-         If you say yes here you get support for ambient light sensing and
-         proximity infrared sensing from Intersil ISL29018.
-         This driver will provide the measurements of ambient light intensity
-         in lux, proximity infrared sensing and normal infrared sensing.
-         Data from sensor is accessible via sysfs.
+	tristate "ISL 29018 light and proximity sensor"
+	depends on I2C
+	default n
+	help
+	 If you say yes here you get support for ambient light sensing and
+	 proximity infrared sensing from Intersil ISL29018.
+	 This driver will provide the measurements of ambient light intensity
+	 in lux, proximity infrared sensing and normal infrared sensing.
+	 Data from sensor is accessible via sysfs.
 
 config SENSORS_ISL29028
 	tristate "Intersil ISL29028 Concurrent Light and Proximity Sensor"
-- 
1.7.1.1

