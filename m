Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778Ab0KODNW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:13:22 -0500
Received: from mail.perches.com ([173.55.12.10]:1151 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932629Ab0KODFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:05:33 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/44] drivers/misc: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:04:29 -0800
Message-Id: <f1f1ff72045c075062d3fbe8d2bfcf67bdb1571d.1289789604.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/misc/bmp085.c   |    2 +-
 drivers/misc/isl29020.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/bmp085.c b/drivers/misc/bmp085.c
index 63ee4c1..6b8a394 100644
--- a/drivers/misc/bmp085.c
+++ b/drivers/misc/bmp085.c
@@ -216,7 +216,7 @@ static s32 bmp085_get_temperature(struct bmp085_data *data, int *temperature)
 		*temperature = (x1+x2+8) >> 4;
 
 exit:
-	return status;;
+	return status;
 }
 
 /*
diff --git a/drivers/misc/isl29020.c b/drivers/misc/isl29020.c
index ca47e62..e6bbf13 100644
--- a/drivers/misc/isl29020.c
+++ b/drivers/misc/isl29020.c
@@ -158,7 +158,7 @@ static int als_set_default_config(struct i2c_client *client)
 		dev_err(&client->dev, "default write failed.");
 		return retval;
 	}
-	return 0;;
+	return 0;
 }
 
 static int  isl29020_probe(struct i2c_client *client,
-- 
1.7.3.1.g432b3.dirty

