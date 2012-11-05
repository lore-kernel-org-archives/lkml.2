Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933286Ab2KERTP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 12:19:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44895 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809Ab2KERSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 12:18:34 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 31/32] perf tests: Fix attr watermark field name typo
Date: Mon,  5 Nov 2012 14:18:12 -0300
Message-Id: <1352135893-7564-32-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1352135893-7564-1-git-send-email-acme@infradead.org>
References: <1352135893-7564-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Currently the 'watermark' field is coded as 'watermask'.

As the type is global through the framework and tests, the typo spawned
no error.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1352130579-13451-4-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr.c           |    2 +-
 tools/perf/tests/attr.py          |    2 +-
 tools/perf/tests/attr/base-record |    2 +-
 tools/perf/tests/attr/base-stat   |    2 +-
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
1.7.9.2.358.g22243

