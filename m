Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab2HFN6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 09:58:53 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:56142 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756261Ab2HFN6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 09:58:50 -0400
From: Dongjin Kim <tobetter@gmail.com>
Cc: Dongjin Kim <dongjin.kim@agreeyamobility.net>,
        Jingoo Han <jg1.han@samsung.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] video: s3c-fb: Fix compile error/warning if CONFIG_OF is not selected
Date: Mon,  6 Aug 2012 22:57:42 +0900
Message-Id: <1344261462-14183-5-git-send-email-dongjin.kim@agreeyamobility.net>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344261462-14183-1-git-send-email-dongjin.kim@agreeyamobility.net>
References: <1344261462-14183-1-git-send-email-dongjin.kim@agreeyamobility.net>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change-Id: I5d7ff6f0070a10225d5b064b362d3d8f214787fd
Signed-off-by: Dongjin Kim <dongjin.kim@agreeyamobility.net>
---
 drivers/video/s3c-fb.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/video/s3c-fb.c b/drivers/video/s3c-fb.c
index 8c8adb5..268be0c 100644
--- a/drivers/video/s3c-fb.c
+++ b/drivers/video/s3c-fb.c
@@ -1527,13 +1527,11 @@ static int s3c_fb_dt_parse_gpios(struct device *dev, struct s3c_fb *sfb,
 
 static void s3c_fb_dt_free_gpios(struct s3c_fb *sfb)
 {
-	return 0;
 }
 
-static int s3c_fb_dt_parse_pdata(struct device *dev,
-					struct s3c_fb_platdata **pdata)
+static struct s3c_fb_platdata *s3c_fb_dt_parse_pdata(struct device *dev)
 {
-	return 0;
+	return NULL;
 }
 #endif /* CONFIG_OF */
 
-- 
1.7.9.5

