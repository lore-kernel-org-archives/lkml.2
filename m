Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060Ab1E2Sjy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 14:39:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59730 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795Ab1E2Sjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 14:39:53 -0400
From: Tim Retout <tim@retout.co.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Tim Retout <tim@retout.co.uk>
Subject: [PATCH] staging: sep: clean up some checkpatch.pl issues
Date: Sun, 29 May 2011 19:38:32 +0100
Message-Id: <1306694312-7009-1-git-send-email-tim@retout.co.uk>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use consistent spacing in array indexing, and a whitespace fix.

Signed-off-by: Tim Retout <tim@retout.co.uk>
---
 drivers/staging/sep/sep_driver.c        |    4 ++--
 drivers/staging/sep/sep_driver_config.h |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index 52342c1..be8594e 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -1102,9 +1102,9 @@ static int sep_lock_user_pages(struct sep_device *sep,
 			"lli_array[%x].bus_address is "
 			"%08lx, lli_array[%x].block_size is %x\n",
 			num_pages - 1,
-			(unsigned long)lli_array[num_pages -1].bus_address,
+			(unsigned long)lli_array[num_pages - 1].bus_address,
 			num_pages - 1,
-			lli_array[num_pages -1].block_size);
+			lli_array[num_pages - 1].block_size);
 	}
 
 	/* Set output params according to the in_out flag */
diff --git a/drivers/staging/sep/sep_driver_config.h b/drivers/staging/sep/sep_driver_config.h
index 1033425..d6bfd24 100644
--- a/drivers/staging/sep/sep_driver_config.h
+++ b/drivers/staging/sep/sep_driver_config.h
@@ -180,7 +180,7 @@ held by the process (struct file) */
 /* offset of the caller id area */
 #define SEP_CALLER_ID_OFFSET_BYTES \
 	(SEP_DRIVER_SYSTEM_RAR_MEMORY_OFFSET_IN_BYTES + \
-    SEP_DRIVER_SYSTEM_RAR_MEMORY_SIZE_IN_BYTES)
+	SEP_DRIVER_SYSTEM_RAR_MEMORY_SIZE_IN_BYTES)
 
 /* offset of the DCB area */
 #define SEP_DRIVER_SYSTEM_DCB_MEMORY_OFFSET_IN_BYTES \
-- 
1.7.4.1

