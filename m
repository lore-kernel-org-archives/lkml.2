Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab2KTOp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:45:28 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:58222 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab2KTOpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:45:24 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 4/8] staging: wlags49_h2: wl_if.h: fixes 80 char line length issues
Date: Tue, 20 Nov 2012 16:44:56 +0200
Message-Id: <1353422700-14485-3-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353422700-14485-1-git-send-email-johanmeiring@gmail.com>
References: <1353422700-14485-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit sorts out 80+ char line length issues that were reported
by the checkpatch.pl tool.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/wl_if.h |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_if.h b/drivers/staging/wlags49_h2/wl_if.h
index d1fdf82..61193b3 100644
--- a/drivers/staging/wlags49_h2/wl_if.h
+++ b/drivers/staging/wlags49_h2/wl_if.h
@@ -104,7 +104,8 @@
 #define HCF_MAX_NOISE_LEVEL         HCF_MAX_SIGNAL_LEVEL
 #define HCF_0DBM_OFFSET             (HCF_MAX_SIGNAL_LEVEL + 1)
 #define HCF_MIN_COMM_QUALITY        0
-#define HCF_MAX_COMM_QUALITY        (HCF_MAX_SIGNAL_LEVEL - HCF_MIN_NOISE_LEVEL + 1)
+#define HCF_MAX_COMM_QUALITY        (HCF_MAX_SIGNAL_LEVEL - \
+					HCF_MIN_NOISE_LEVEL + 1)
 
 
 /* For encryption (WEP) */
@@ -207,9 +208,9 @@ struct uilreq
 	__u8        command;
 	__u8        result;
 
-	/* The data field in this structure is typically an LTV of some type. The
-	   len field is the size of the buffer in bytes, as opposed to words (like
-	   the L-field in the LTV */
+	/* The data field in this structure is typically an LTV of some type.
+	   The len field is the size of the buffer in bytes, as opposed to words
+	   (like the L-field in the LTV */
 	__u16       len;
 	void       *data;
 };
-- 
1.7.10.4

