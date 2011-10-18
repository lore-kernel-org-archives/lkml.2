Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab1JRTdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 15:33:32 -0400
Received: from mail.fuel7.com ([74.222.0.51]:38250 "EHLO mail.fuel7.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338Ab1JRTdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 15:33:31 -0400
X-Greylist: delayed 1904 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Oct 2011 15:33:31 EDT
From: Patrick Trantham <patrick.trantham@fuel7.com>
To: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, patrick.trantham@fuel7.com,
        kyle.manna@fuel7.com
Subject: [PATCH] rtc: ISL12022: Add support for ISL12020
Date: Tue, 18 Oct 2011 14:01:32 -0500
Message-Id: <1318964492-19805-1-git-send-email-patrick.trantham@fuel7.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the ISL12022 device id array to support the ISL12020 which has
been tested and verified using this driver.

Signed-off-by: Patrick Trantham <patrick.trantham@fuel7.com>
Tested-by: Kyle Manna <kyle.manna@fuel7.com>
---
 drivers/rtc/rtc-isl12022.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/rtc-isl12022.c b/drivers/rtc/rtc-isl12022.c
index ddbc797..e114507 100644
--- a/drivers/rtc/rtc-isl12022.c
+++ b/drivers/rtc/rtc-isl12022.c
@@ -295,6 +295,7 @@ static int isl12022_remove(struct i2c_client *client)
 static const struct i2c_device_id isl12022_id[] = {
 	{ "isl12022", 0 },
 	{ "rtc8564", 0 },
+	{ "isl12020", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, isl12022_id);
-- 
1.7.4.1

