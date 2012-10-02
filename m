Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab2JBLyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 07:54:37 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41822 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab2JBLyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 07:54:35 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 2/3] Add parenthesis to macros with complex values in trace.h
Date: Tue,  2 Oct 2012 20:54:28 +0900
Message-Id: <1349178868-29677-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349178827-29643-1-git-send-email-yamanetoshi@gmail.com>
References: <1349178827-29643-1-git-send-email-yamanetoshi@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed some checkpatch below error.
-ERROR: Macros with complex values should be enclosed in parenthesis

Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
---
 drivers/staging/rts_pstor/trace.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rts_pstor/trace.h b/drivers/staging/rts_pstor/trace.h
index 740999c..a34493c 100644
--- a/drivers/staging/rts_pstor/trace.h
+++ b/drivers/staging/rts_pstor/trace.h
@@ -78,8 +78,8 @@ do {													\
 	goto label; 											\
 } while (0)
 #else
-#define TRACE_RET(chip, ret)	return ret
-#define TRACE_GOTO(chip, label)	goto label
+#define TRACE_RET(chip, ret)	return(ret)
+#define TRACE_GOTO(chip, label)	goto(label)
 #endif
 
 #ifdef CONFIG_RTS_PSTOR_DEBUG
-- 
1.7.9.5

