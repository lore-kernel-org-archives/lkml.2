Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab2DAQiJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 12:38:09 -0400
Received: from na3sys010aog114.obsmtp.com ([74.125.245.96]:33857 "HELO
	na3sys010aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751547Ab2DAQiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 12:38:07 -0400
From: Roland Dreier <roland@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Add EWOODBLOCK
Date: Sun,  1 Apr 2012 09:38:00 -0700
Message-Id: <1333298280-4968-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

We have found that in RT Linux applications around control of sawmills
and other lumber handling equipment, there is no good way for the
kernel to report jams or other blockages, and so we ended up adding a
new error code.

We were quite happy to carry this as an out-of-tree patch until we
heard that a group doing functional MRI of politicians' brains had
independently started using EWOODBLOCK.  To enable other innovative
uses of this fundamental advancement in kernel infrastructure, we are
proposing this patch for upstream merge.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 include/asm-generic/errno.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/asm-generic/errno.h b/include/asm-generic/errno.h
index a1331ce..9a337b8 100644
--- a/include/asm-generic/errno.h
+++ b/include/asm-generic/errno.h
@@ -110,4 +110,6 @@
 
 #define EHWPOISON	133	/* Memory page has hardware error */
 
+#define EWOODBLOCK	134	/* logjam */
+
 #endif
-- 
1.7.9.1

