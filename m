Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab2FTTSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 15:18:52 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13938 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab2FTTSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 15:18:51 -0400
Date: Wed, 20 Jun 2012 21:18:48 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, lm-sensors@lm-sensors.org,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH][Trivial] hwmon: (applesmc) correct email address for Jesper
 Juhl
Message-ID: <alpine.LNX.2.00.1206202117030.7405@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've not had a gmail address for years. This commit updates the
address to my actual working one.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/hwmon/applesmc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index f082e48..2cfbf05 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -8,7 +8,7 @@
  *
  * Based on hdaps.c driver:
  * Copyright (C) 2005 Robert Love <rml@novell.com>
- * Copyright (C) 2005 Jesper Juhl <jesper.juhl@gmail.com>
+ * Copyright (C) 2005 Jesper Juhl <jj@chaosbits.net>
  *
  * Fan control based on smcFanControl:
  * Copyright (C) 2006 Hendrik Holtmann <holtmann@mac.com>
-- 
1.7.11


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

