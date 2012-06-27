Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757637Ab2F0Vwb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 17:52:31 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59350 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753403Ab2F0Vwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 17:52:30 -0400
From: Konstantin Stepanyuk <konstantin.stepanyuk@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Konstantin Stepanyuk <konstantin.stepanyuk@gmail.com>
Subject: [PATCH] traceevent: make clean fix
Date: Wed, 27 Jun 2012 15:52:14 -0600
Message-Id: <1340833934-18783-1-git-send-email-konstantin.stepanyuk@gmail.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dependency files were not cleaned up. Add missing space to fix the
issue.

Signed-off-by: Konstantin Stepanyuk <konstantin.stepanyuk@gmail.com>
---
 tools/lib/traceevent/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 3d69aa9..423f4b8 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -290,7 +290,7 @@ install_lib: all_cmd install_plugins install_python
 install: install_lib
 
 clean:
-	$(RM) *.o *~ $(TARGETS) *.a *.so $(VERSION_FILES).*.d
+	$(RM) *.o *~ $(TARGETS) *.a *.so $(VERSION_FILES) .*.d
 	$(RM) tags TAGS
 
 endif # skip-makefile
-- 
1.7.10

