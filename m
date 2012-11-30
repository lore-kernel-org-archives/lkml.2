Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031226Ab2K3REx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:04:53 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:32819 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031101Ab2K3REv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:04:51 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 31/32] staging: wlags49_h2: wl_util: converts C99 // comment
Date: Fri, 30 Nov 2012 18:58:56 +0200
Message-Id: <1354294737-5735-31-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
References: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit converts a C99 // comment to /* */

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/wl_util.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wlags49_h2/wl_util.h b/drivers/staging/wlags49_h2/wl_util.h
index 67ee069..9164c30a 100644
--- a/drivers/staging/wlags49_h2/wl_util.h
+++ b/drivers/staging/wlags49_h2/wl_util.h
@@ -93,4 +93,4 @@ void wl_process_updated_record(struct wl_private *lp);
 void wl_process_assoc_status(struct wl_private *lp);
 void wl_process_security_status(struct wl_private *lp);
 
-#endif  // __WL_UTIL_H__
+#endif  /* __WL_UTIL_H__ */
-- 
1.7.10.4

