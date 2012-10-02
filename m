Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab2JBLx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 07:53:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37283 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2JBLx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 07:53:56 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 1/3] Fix trailing whitespace in trace.h
Date: Tue,  2 Oct 2012 20:53:47 +0900
Message-Id: <1349178827-29643-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch error.

-ERROR: trailing whitespace

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/rts_pstor/trace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rts_pstor/trace.h b/drivers/staging/rts_pstor/trace.h
index cf60a1b..740999c 100644
--- a/drivers/staging/rts_pstor/trace.h
+++ b/drivers/staging/rts_pstor/trace.h
@@ -39,7 +39,7 @@ static inline char *filename(char *path)
 	while (*ptr != '\0') {
 		if ((*ptr == '\\') || (*ptr == '/'))
 			path = ptr + 1;
-		
+
 		ptr++;
 	}
 
-- 
1.7.9.5

