Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab2FRL2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:28:55 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:65298 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab2FRL2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:28:53 -0400
X-AuditID: cbfee61a-b7f9f6d0000016a8-a1-4fdf10f4dc4f
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        sameo@linux.intel.com
Cc: "'Liam Girdwood'" <lrg@ti.com>, linux-kernel@vger.kernel.org,
        sbkim01@gmail.com
Subject: [PATCH 2/7] regulator: s5m8767: Modify header file and Kconfig
Date: Mon, 18 Jun 2012 20:28:51 +0900
Message-id: <067401cd4d45$898d8d90$9ca8a8b0$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1NRYlvVVVH0oweSsmgXlsF75Zqug==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jAd0vAvf9DZ6sk7C4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZq25cZC6Yx1Wxt+MQUwPjJY4uRk4OCQETiY0rJ7JC2GISF+6t
	Z+ti5OIQEljEKHH6+gooZy6TxIIv/1lAqtgENCRW7n7LBmKLCPhKXHr5H6ibg4NZIFhi62k9
	kLCwgLtE5/0nTCBhFgFViWVfFEHCvAKGEhPXbWSCsAUlfky+BzaRWUBLYv3O40wQtrzE5jVv
	mUFaJQTUJR791YVYpCdxdlMzM0SJiMS+F+8YJzAKzEIyaRaSSbOQTJqFpGUBI8sqRtHUguSC
	4qT0XEO94sTc4tK8dL3k/NxNjOCgfCa1g3Flg8UhRgEORiUe3gd89/2FWBPLiitzDzFKcDAr
	ifD+4AIK8aYkVlalFuXHF5XmpBYfYpTmYFES522yvuAvJJCeWJKanZpakFoEk2Xi4JRqYGT/
	Ex1orROQz14Tzx++i0n/41Yft72dZYtcv8UsZZZS2bo6Vv3wUnvJ9cl2scrHmltFL71KvHMs
	6PL5aee/nIiesWeF3e6qW6zBjKnbmgSyVnocPX4pcoVRr9TqS9VHjhtsucrrUh8XU/Dpb7Mi
	l0VOtvHuNwHVTinaU2NDWBc6VfTtf6ZuqMRSnJFoqMVcVJwIACRU0mBGAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As name of samsung pmic mfd driver is changed,
Modify s5m8767 regulator header and Kconfig.

Signed-off-by: Sangbeom Kim <sbkim73@samsung.com>
---
 drivers/regulator/Kconfig   |    2 +-
 drivers/regulator/s5m8767.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/Kconfig b/drivers/regulator/Kconfig
index 00ffe05..196aaae 100644
--- a/drivers/regulator/Kconfig
+++ b/drivers/regulator/Kconfig
@@ -243,7 +243,7 @@ config REGULATOR_RC5T583
 
 config REGULATOR_S5M8767
 	tristate "Samsung S5M8767A voltage regulator"
-	depends on MFD_S5M_CORE
+	depends on MFD_SEC_CORE
 	help
 	 This driver supports a Samsung S5M8767A voltage output regulator
 	 via I2C bus. S5M8767A have 9 Bucks and 28 LDOs output and
diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 22642c3..bd9cca8 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -19,8 +19,8 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
-#include <linux/mfd/s5m87xx/s5m-core.h>
-#include <linux/mfd/s5m87xx/s5m-pmic.h>
+#include <linux/mfd/samsung/s5m-core.h>
+#include <linux/mfd/samsung/s5m-pmic.h>
 
 struct s5m8767_info {
 	struct device *dev;
-- 
1.7.1


