Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab2KTOpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:45:20 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:58222 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab2KTOpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:45:18 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 3/8] staging: wlags49_h2: wl_if.h: fixes spaces-before-tabs issue
Date: Tue, 20 Nov 2012 16:44:55 +0200
Message-Id: <1353422700-14485-2-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353422700-14485-1-git-send-email-johanmeiring@gmail.com>
References: <1353422700-14485-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes a spaces-before-tabs problem that was reported by
the checkpatch.pl tool.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/wl_if.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wlags49_h2/wl_if.h b/drivers/staging/wlags49_h2/wl_if.h
index 5c6b2b5..d1fdf82 100644
--- a/drivers/staging/wlags49_h2/wl_if.h
+++ b/drivers/staging/wlags49_h2/wl_if.h
@@ -75,7 +75,7 @@
 
 #define HCF_MAX_MULTICAST           16
 #define HCF_MAX_NAME_LEN            32
-#define MAX_LINE_SIZE   			256
+#define MAX_LINE_SIZE               256
 #define HCF_NUM_IO_PORTS            0x80
 #define TX_TIMEOUT                  ((800 * HZ) / 1000)
 
-- 
1.7.10.4

