Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab1HGItb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 04:49:31 -0400
Received: from msa103.auone-net.jp ([61.117.18.163]:57285 "EHLO
	msa103.auone-net.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243Ab1HGIta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 04:49:30 -0400
X-Greylist: delayed 594 seconds by postgrey-1.27 at vger.kernel.org; Sun, 07 Aug 2011 04:49:30 EDT
Date: Sun, 7 Aug 2011 17:39:31 +0900
From: Kusanagi Kouichi <slash@ac.auone-net.jp>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] perf tools: make clean leaves some files.
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Message-Id: <20110807083932.9C0E514C03B@msa103.auone-net.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use LIB_OBJS and BUILTIN_OBJS for .o files.
LIB_FILE is already prefixed with OUTPUT.

Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 56d62d3..d63f513 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -895,7 +895,7 @@ quick-install-html:
 ### Cleaning rules
 
 clean:
-	$(RM) $(OUTPUT){*.o,*/*.o,*/*/*.o,*/*/*/*.o,$(LIB_FILE),perf-archive}
+	$(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS)
 	$(RM) $(ALL_PROGRAMS) perf
 	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
 	$(MAKE) -C Documentation/ clean
-- 
1.7.5.4

