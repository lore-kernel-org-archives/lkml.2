Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab2KEPuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:50:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44200 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab2KEPuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:50:09 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/4] perf tests: Fix attr watermark field name typo
Date: Mon,  5 Nov 2012 16:49:38 +0100
Message-Id: <1352130579-13451-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1352130579-13451-1-git-send-email-jolsa@redhat.com>
References: <1352130579-13451-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the 'watermark' field is coded as 'watermask'.

As the type is global through the framework and tests,
the typo spawned no error.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/tests/attr.c           | 2 +-
 tools/perf/tests/attr.py          | 2 +-
 tools/perf/tests/attr/base-record | 2 +-
 tools/perf/tests/attr/base-stat   | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/tests/attr.c b/tools/perf/tests/attr.c
index 1389d69..6fa84b7 100644
--- a/tools/perf/tests/attr.c
+++ b/tools/perf/tests/attr.c
@@ -110,7 +110,7 @@ static int store_event(struct perf_event_attr *attr, pid_t pid, int cpu,
 	WRITE_ASS(inherit_stat,   "d");
 	WRITE_ASS(enable_on_exec, "d");
 	WRITE_ASS(task,           "d");
-	WRITE_ASS(watermask,      "d");
+	WRITE_ASS(watermark,      "d");
 	WRITE_ASS(precise_ip,     "d");
 	WRITE_ASS(mmap_data,      "d");
 	WRITE_ASS(sample_id_all,  "d");
diff --git a/tools/perf/tests/attr.py b/tools/perf/tests/attr.py
index e98c726..28c0481 100644
--- a/tools/perf/tests/attr.py
+++ b/tools/perf/tests/attr.py
@@ -45,7 +45,7 @@ class Event(dict):
         'inherit_stat',
         'enable_on_exec',
         'task',
-        'watermask',
+        'watermark',
         'precise_ip',
         'mmap_data',
         'sample_id_all',
diff --git a/tools/perf/tests/attr/base-record b/tools/perf/tests/attr/base-record
index 07beef5..8262794 100644
--- a/tools/perf/tests/attr/base-record
+++ b/tools/perf/tests/attr/base-record
@@ -22,7 +22,7 @@ freq=1
 inherit_stat=0
 enable_on_exec=1
 task=0
-watermask=0
+watermark=0
 precise_ip=0
 mmap_data=0
 sample_id_all=1
diff --git a/tools/perf/tests/attr/base-stat b/tools/perf/tests/attr/base-stat
index 6e1bb8e..46f8851 100644
--- a/tools/perf/tests/attr/base-stat
+++ b/tools/perf/tests/attr/base-stat
@@ -22,7 +22,7 @@ freq=0
 inherit_stat=0
 enable_on_exec=1
 task=0
-watermask=0
+watermark=0
 precise_ip=0
 mmap_data=0
 sample_id_all=0
-- 
1.7.11.7

