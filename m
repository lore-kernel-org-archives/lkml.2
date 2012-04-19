Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab2DSJAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 05:00:47 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16411 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab2DSJAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 05:00:34 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 19 Apr 2012 02:00:13 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: jic23@cam.ac.uk, gregkh@linuxfoundation.org, max@stro.at,
        jbrenner@taosinc.com, bfreed@chromium.org, lars@metafoo.de,
        grundler@chromium.org
Cc: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCHi V2 1/2] staging: iio: light: convert multiple spaces to tab
Date: Thu, 19 Apr 2012 14:29:34 +0530
Message-Id: <1334825975-7062-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1334825975-7062-1-git-send-email-ldewangan@nvidia.com>
References: <1334825975-7062-1-git-send-email-ldewangan@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using tab inplace of multiple spaces for indenting.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
As per Jonathan's feedback, creating this patch for only
indenting cleanups.

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

