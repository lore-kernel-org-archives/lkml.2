Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab2KBGnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 02:43:33 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:45708 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120Ab2KBGnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 02:43:31 -0400
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: gregkh@linuxfoundation.org
Cc: syahn@gctsemi.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: gdm72xx: wm_ioctl.h: fixed a macro coding style
Date: Thu,  1 Nov 2012 23:42:59 -0700
Message-Id: <1351838579-24511-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix for macro coding style.

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/staging/gdm72xx/wm_ioctl.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/gdm72xx/wm_ioctl.h b/drivers/staging/gdm72xx/wm_ioctl.h
index 9f46e06..4ceecc4 100644
--- a/drivers/staging/gdm72xx/wm_ioctl.h
+++ b/drivers/staging/gdm72xx/wm_ioctl.h
@@ -91,7 +91,7 @@ struct wm_req_s {
 };
 
 #ifndef ifr_name
-#define ifr_name	ifr_ifrn.ifrn_name
+#define ifr_name	(ifr_ifrn.ifrn_name)
 #endif
 
 #endif
-- 
1.7.9.5

