Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab2LaINP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 03:13:15 -0500
Received: from mail.active-venture.com ([67.228.131.205]:58163 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab2LaINO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 03:13:14 -0500
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Mon, 31 Dec 2012 02:13:13 -0600
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: lm-sensors <lm-sensors@lm-sensors.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 1/2] hwmon: (vexpress) Remove __devexit and __devexit_p
Date: Mon, 31 Dec 2012 00:13:07 -0800
Message-Id: <1356941588-25249-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/hwmon/vexpress.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/vexpress.c b/drivers/hwmon/vexpress.c
index 59fd126..86d7f6d 100644
--- a/drivers/hwmon/vexpress.c
+++ b/drivers/hwmon/vexpress.c
@@ -196,7 +196,7 @@ error:
 	return err;
 }
 
-static int __devexit vexpress_hwmon_remove(struct platform_device *pdev)
+static int vexpress_hwmon_remove(struct platform_device *pdev)
 {
 	struct vexpress_hwmon_data *data = platform_get_drvdata(pdev);
 	const struct of_device_id *match;
@@ -213,7 +213,7 @@ static int __devexit vexpress_hwmon_remove(struct platform_device *pdev)
 
 static struct platform_driver vexpress_hwmon_driver = {
 	.probe = vexpress_hwmon_probe,
-	.remove = __devexit_p(vexpress_hwmon_remove),
+	.remove = vexpress_hwmon_remove,
 	.driver	= {
 		.name = DRVNAME,
 		.owner = THIS_MODULE,
-- 
1.7.9.7

