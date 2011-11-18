Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab1KRIXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 03:23:18 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54066 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012Ab1KRIXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 03:23:14 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: khali@linux-fr.org
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 35/35] Drivers: hwmon: adm1031: fixed indent coding style issue
Date: Fri, 18 Nov 2011 01:23:09 -0700
Message-Id: <1321604589-13325-1-git-send-email-zac.3.14159@gmail.com>
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
index 0bd2ae7..29f8d59 100644
--- a/drivers/hwmon/adm1031.c
+++ b/drivers/hwmon/adm1031.c
@@ -971,7 +971,7 @@ static void adm1031_init_client(struct i2c_client *client)
 	/* Initialize the ADM1031 chip (enables fan speed reading ) */
 	read_val = adm1031_read_value(client, ADM1031_REG_CONF2);
 	if ((read_val | mask) != read_val) {
-	    adm1031_write_value(client, ADM1031_REG_CONF2, read_val | mask);
+		adm1031_write_value(client, ADM1031_REG_CONF2, read_val | mask);
 	}
 
 	read_val = adm1031_read_value(client, ADM1031_REG_CONF1);
-- 
1.7.7.3

