Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab1LTTUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:20:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:33887 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab1LTTSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:18:31 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@gmail.com>,
        Johannes Schindelin <Johannes.Schindelin@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/10] perf tools: Remove stale git headlines from top comment
Date: Tue, 20 Dec 2011 17:18:09 -0200
Message-Id: <1324408691-28296-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1324408691-28296-1-git-send-email-acme@infradead.org>
References: <1324408691-28296-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@gmail.com>

These files are part of PERF not GIT although they're come from there :)

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Johannes Schindelin <Johannes.Schindelin@gmx.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1323784323-2150-1-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/config.c |    5 ++++-
 tools/perf/util/usage.c  |    5 ++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/config.c b/tools/perf/util/config.c
index 80d9598..0deac6a 100644
--- a/tools/perf/util/config.c
+++ b/tools/perf/util/config.c
@@ -1,5 +1,8 @@
 /*
- * GIT - The information manager from hell
+ * config.c
+ *
+ * Helper functions for parsing config items.
+ * Originally copied from GIT source.
  *
  * Copyright (C) Linus Torvalds, 2005
  * Copyright (C) Johannes Schindelin, 2005
diff --git a/tools/perf/util/usage.c b/tools/perf/util/usage.c
index e16bf9a..d76d1c0 100644
--- a/tools/perf/util/usage.c
+++ b/tools/perf/util/usage.c
@@ -1,5 +1,8 @@
 /*
- * GIT - The information manager from hell
+ * usage.c
+ *
+ * Various reporting routines.
+ * Originally copied from GIT source.
  *
  * Copyright (C) Linus Torvalds, 2005
  */
-- 
1.7.8.rc0.35.gee6df

