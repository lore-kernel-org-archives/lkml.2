Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab1HSTkw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 15:40:52 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:55649 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150Ab1HSTkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 15:40:35 -0400
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: apatard@mandriva.com, gregkh@suse.de, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/12] staging: xgifb: delete an empty string
Date: Fri, 19 Aug 2011 22:40:30 +0300
Message-Id: <1313782830-31461-13-git-send-email-aaro.koskinen@iki.fi>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1313782830-31461-1-git-send-email-aaro.koskinen@iki.fi>
References: <1313782830-31461-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Delete a string which is always empty.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 drivers/staging/xgifb/XGI_main.h    |    1 -
 drivers/staging/xgifb/XGI_main_26.c |    2 --
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main.h b/drivers/staging/xgifb/XGI_main.h
index 8ba470b..1d49ee5 100644
--- a/drivers/staging/xgifb/XGI_main.h
+++ b/drivers/staging/xgifb/XGI_main.h
@@ -163,7 +163,6 @@ static struct fb_fix_screeninfo XGIfb_fix = {
 	.xpanstep	= 1,
 	.ypanstep	= 1,
 };
-static char myid[20];
 static u32 pseudo_palette[17];
 
 
diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index ae01a6e..58f5ae4 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -1481,8 +1481,6 @@ static int XGIfb_get_fix(struct fb_fix_screeninfo *fix, int con,
 	DEBUGPRN("inside get_fix");
 	memset(fix, 0, sizeof(struct fb_fix_screeninfo));
 
-	strcpy(fix->id, myid);
-
 	fix->smem_start = xgi_video_info.video_base;
 
 	fix->smem_len = xgi_video_info.video_size;
-- 
1.7.2.5

