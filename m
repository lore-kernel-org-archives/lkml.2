Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936Ab2GQQUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 12:20:19 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:37650 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab2GQQUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 12:20:16 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org
Cc: standby24x7@gmail.com
Subject: [PATCH 1/2] [trivial] tools: perf: Fix typo in tools/perf
Date: Wed, 18 Jul 2012 01:20:59 +0900
Message-Id: <1342542059-9756-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.11.2.194.g7bdb748
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in tools/perf.

Signed-off-by: Masanari iida <standby24x7@gmail.com>
---
 tools/perf/util/callchain.h         | 2 +-
 tools/perf/util/parse-events-test.c | 2 +-
 tools/perf/util/python-ext-sources  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 3bdb407..eb34057 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -58,7 +58,7 @@ struct callchain_list {
 /*
  * A callchain cursor is a single linked list that
  * let one feed a callchain progressively.
- * It keeps persitent allocated entries to minimize
+ * It keeps persistent allocated entries to minimize
  * allocations.
  */
 struct callchain_cursor_node {
diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index 76b98e2..8cdf147 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -609,7 +609,7 @@ static int test_pmu(void)
 
 	ret = stat(path, &st);
 	if (ret)
-		pr_debug("ommiting PMU cpu tests\n");
+		pr_debug("omitting PMU cpu tests\n");
 	return !ret;
 }
 
diff --git a/tools/perf/util/python-ext-sources b/tools/perf/util/python-ext-sources
index 2884e67..f4e37ce 100644
--- a/tools/perf/util/python-ext-sources
+++ b/tools/perf/util/python-ext-sources
@@ -1,5 +1,5 @@
 #
-# List of files needed by perf python extention
+# List of files needed by perf python extension
 #
 # Each source file must be placed on its own line so that it can be
 # processed by Makefile and util/setup.py accordingly.
-- 
1.7.11.2.194.g7bdb748

