Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab2CKOkh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 10:40:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34924 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab2CKOkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 10:40:35 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: rpurdie@rpsys.net
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] backlight: Fix typo in tosa_lcd.c
Date: Sun, 11 Mar 2012 23:39:57 +0900
Message-Id: <1331476797-19201-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.10.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix typo in drivers/video/backlight/tosa_lcd.c
"tosa_lcd_reume" should be "tosa_lcd_resume".

Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Cc:stable@kernel.org
---
 drivers/video/backlight/tosa_lcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/backlight/tosa_lcd.c b/drivers/video/backlight/tosa_lcd.c
index a2161f6..2231aec 100644
--- a/drivers/video/backlight/tosa_lcd.c
+++ b/drivers/video/backlight/tosa_lcd.c
@@ -271,7 +271,7 @@ static int tosa_lcd_resume(struct spi_device *spi)
 }
 #else
 #define tosa_lcd_suspend	NULL
-#define tosa_lcd_reume NULL
+#define tosa_lcd_resume NULL
 #endif
 
 static struct spi_driver tosa_lcd_driver = {
-- 
1.7.10.rc0

