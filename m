Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab1B0EgS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 23:36:18 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38124 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab1B0Eer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 23:34:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZIwxQFNtekcRy7WI/gPCSTiTSjLxWUVxevm+O5iIWs+DQM/8m16tqdfCI0/haGumy4
         nDXG2z+vTQIjIPZ+VZdCRjZ0Xt+tos2rkR22bB1C//8iCI8ZR0Hnww3xB3Zxyx+FeLMd
         PDfe1wZdtbH1lE7EETKQVEZB4HB2aH8CnSvSc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org
Subject: [PATCH 10/17]drivers:hwmon:sht15.c Remove one to many n's in a word.
Date: Sat, 26 Feb 2011 20:34:03 -0800
Message-Id: <1298781250-2718-11-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
References: <1298781250-2718-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Patch below removes one to many "n's" in a word..

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
CC: Jean Delvare <khali@linux-fr.org>
CC: Guenter Roeck <guenter.roeck@ericsson.com>
CC: lm-sensors@lm-sensors.org
---
 drivers/hwmon/sht15.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/sht15.c b/drivers/hwmon/sht15.c
index a610e78..3ba7dd8 100644
--- a/drivers/hwmon/sht15.c
+++ b/drivers/hwmon/sht15.c
@@ -610,7 +610,7 @@ static int __devexit sht15_remove(struct platform_device *pdev)
 	struct sht15_data *data = platform_get_drvdata(pdev);
 
 	/* Make sure any reads from the device are done and
-	 * prevent new ones beginnning */
+	 * prevent new ones from beginning */
 	mutex_lock(&data->read_lock);
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&pdev->dev.kobj, &sht15_attr_group);
-- 
1.7.4.1

