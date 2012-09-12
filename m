Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760788Ab2ILRDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:03:41 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60712 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760760Ab2ILRDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:03:35 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org,
        rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Subject: [PATCH 3/15] drivers/rtc: removes unnecessary semicolon
Date: Wed, 12 Sep 2012 19:03:10 +0200
Message-Id: <1347469402-27557-3-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

removes unnecessary semicolon

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/rtc/rtc-isl12022.c |    2 +-
 drivers/rtc/rtc-pcf8563.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-isl12022.c b/drivers/rtc/rtc-isl12022.c
index 1850104..6b4298e 100644
--- a/drivers/rtc/rtc-isl12022.c
+++ b/drivers/rtc/rtc-isl12022.c
@@ -227,7 +227,7 @@ static int isl12022_set_datetime(struct i2c_client *client, struct rtc_time *tm)
 					 buf[ISL12022_REG_SC + i]);
 		if (ret)
 			return -EIO;
-	};
+	}
 
 	return 0;
 }
diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index c2fe426..3694c9c 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -172,7 +172,7 @@ static int pcf8563_set_datetime(struct i2c_client *client, struct rtc_time *tm)
 				__func__, err, data[0], data[1]);
 			return -EIO;
 		}
-	};
+	}
 
 	return 0;
 }

