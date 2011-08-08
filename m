Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870Ab1HHPxK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 11:53:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:50159 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347Ab1HHPxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 11:53:08 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/4] perf tools: Make clean leaves some files
Date: Mon,  8 Aug 2011 12:52:55 -0300
Message-Id: <1312818776-19530-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1312818776-19530-1-git-send-email-acme@infradead.org>
References: <1312818776-19530-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kusanagi Kouichi <slash@ac.auone-net.jp>

Use LIB_OBJS and BUILTIN_OBJS for .o files.

LIB_FILE is already prefixed with OUTPUT.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110807083932.9C0E514C03B@msa103.auone-net.jp
Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d0861bb..5bf48fc 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -892,7 +892,7 @@ quick-install-html:
 ### Cleaning rules
 
 clean:
-	$(RM) $(OUTPUT){*.o,*/*.o,*/*/*.o,*/*/*/*.o,$(LIB_FILE),perf-archive}
+	$(RM) $(LIB_OBJS) $(BUILTIN_OBJS) $(LIB_FILE) $(OUTPUT)perf-archive $(OUTPUT)perf.o $(LANG_BINDINGS)
 	$(RM) $(ALL_PROGRAMS) perf
 	$(RM) *.spec *.pyc *.pyo */*.pyc */*.pyo $(OUTPUT)common-cmds.h TAGS tags cscope*
 	$(MAKE) -C Documentation/ clean
-- 
1.6.2.5

