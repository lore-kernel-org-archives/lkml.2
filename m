Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236Ab1KRIa2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 03:30:28 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42360 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab1KRIa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 03:30:27 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: khali@linux-fr.org
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH] Drivers: hwmon: adm1031: fixed indent coding style issue
Date: Fri, 18 Nov 2011 01:30:20 -0700
Message-Id: <1321605020-13458-1-git-send-email-zac.3.14159@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed indent coding style issue.

Signed-off-by: Zac Storer <zac.3.14159@gmail.com>
---
 drivers/hwmon/adm1031.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/adm1031.c b/drivers/hwmon/adm1031.c
index 0683e6b..70fb6ac 100644
--- a/drivers/hwmon/adm1031.c
+++ b/drivers/hwmon/adm1031.c
@@ -976,7 +976,7 @@ static void adm1031_init_client(struct i2c_client *client)
 
 	read_val = adm1031_read_value(client, ADM1031_REG_CONF1);
 	if ((read_val | ADM1031_CONF1_MONITOR_ENABLE) != read_val) {
-	    adm1031_write_value(client, ADM1031_REG_CONF1, read_val |
+		adm1031_write_value(client, ADM1031_REG_CONF1, read_val |
 				ADM1031_CONF1_MONITOR_ENABLE);
 	}
 
-- 
1.7.7.3

