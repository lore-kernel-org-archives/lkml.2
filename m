Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab1KREfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 23:35:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51001 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219Ab1KREfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 23:35:07 -0500
From: Zac Storer <zac.3.14159@gmail.com>
To: FlorianSchandinat@gmx.de
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zac Storer <zac.3.14159@gmail.com>
Subject: [PATCH 3/3] Drivers: video: controlfb: fixed a brace coding style issue
Date: Thu, 17 Nov 2011 21:34:56 -0700
Message-Id: <1321590896-8249-1-git-send-email-zac.3.14159@gmail.com>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a brace coding style issue.

Signed-off-by: Zac Storer <zac.3.14159@gmail.com>
---
 drivers/video/controlfb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/controlfb.c b/drivers/video/controlfb.c
index 7b2c40a..0c189b3 100644
--- a/drivers/video/controlfb.c
+++ b/drivers/video/controlfb.c
@@ -420,7 +420,7 @@ static int __init init_control(struct fb_info_control *p)
 
 	/* Try to pick a video mode out of NVRAM if we have one. */
 #ifdef CONFIG_NVRAM
-	if (default_cmode == CMODE_NVRAM){
+	if (default_cmode == CMODE_NVRAM) {
 		cmode = nvram_read_byte(NV_CMODE);
 		if(cmode < CMODE_8 || cmode > CMODE_32)
 			cmode = CMODE_8;
-- 
1.7.7.3

