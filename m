Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab2KTOoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:44:30 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:60686 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab2KTOo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:44:29 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 1/8] staging: wlags49_h2: wl_if.h: fixes macro styling issues
Date: Tue, 20 Nov 2012 16:44:10 +0200
Message-Id: <1353422650-14437-1-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit sorts out macro styling issues that were indicated by
the checkpatch.pl script,

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/wl_if.h |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_if.h b/drivers/staging/wlags49_h2/wl_if.h
index 6d66dab..d070e47 100644
--- a/drivers/staging/wlags49_h2/wl_if.h
+++ b/drivers/staging/wlags49_h2/wl_if.h
@@ -121,7 +121,7 @@
 #define MAX_RTS_BYTES               2347
 
 #define MAX_RATES                   8
-#define MEGABIT                     1024*1024
+#define MEGABIT                     (1024 * 1024)
 
 #define HCF_FAILURE                 0xFF
 #define UIL_FAILURE		            0xFF
@@ -154,15 +154,15 @@ UIL_FUN_GET_INFO
 UIL_FUN_PUT_INFO
 */
 
-#define SIOCSIWNETNAME              SIOCDEVPRIVATE+1
-#define SIOCGIWNETNAME              SIOCDEVPRIVATE+2
-#define SIOCSIWSTANAME              SIOCDEVPRIVATE+3
-#define SIOCGIWSTANAME              SIOCDEVPRIVATE+4
-#define SIOCSIWPORTTYPE             SIOCDEVPRIVATE+5
-#define SIOCGIWPORTTYPE             SIOCDEVPRIVATE+6
+#define SIOCSIWNETNAME              (SIOCDEVPRIVATE + 1)
+#define SIOCGIWNETNAME              (SIOCDEVPRIVATE + 2)
+#define SIOCSIWSTANAME              (SIOCDEVPRIVATE + 3)
+#define SIOCGIWSTANAME              (SIOCDEVPRIVATE + 4)
+#define SIOCSIWPORTTYPE             (SIOCDEVPRIVATE + 5)
+#define SIOCGIWPORTTYPE             (SIOCDEVPRIVATE + 6)
 
 /* IOCTL code for the RTS interface */
-#define WL_IOCTL_RTS                SIOCDEVPRIVATE+7
+#define WL_IOCTL_RTS                (SIOCDEVPRIVATE + 7)
 
 /* IOCTL subcodes for WL_IOCTL_RTS */
 #define WL_IOCTL_RTS_READ           1
-- 
1.7.10.4

