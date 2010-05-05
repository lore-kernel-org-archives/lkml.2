Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934883Ab0EEObA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 10:31:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41406 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933645Ab0EEOa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 10:30:57 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 4/4] perf tools: Fixup minor doc formatting issues
Date: Wed,  5 May 2010 11:30:48 -0300
Message-Id: <1273069848-22934-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273069848-22934-1-git-send-email-acme@infradead.org>
References: <1273069848-22934-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-annotate.txt     |    2 +-
 tools/perf/Documentation/perf-bench.txt        |    2 +-
 tools/perf/Documentation/perf-diff.txt         |    2 +-
 tools/perf/Documentation/perf-kmem.txt         |    2 +-
 tools/perf/Documentation/perf-trace-python.txt |    2 +-
 tools/perf/Documentation/perf-trace.txt        |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/Documentation/perf-annotate.txt b/tools/perf/Documentation/perf-annotate.txt
index c9dcade..5164a65 100644
--- a/tools/perf/Documentation/perf-annotate.txt
+++ b/tools/perf/Documentation/perf-annotate.txt
@@ -1,5 +1,5 @@
 perf-annotate(1)
-==============
+================
 
 NAME
 ----
diff --git a/tools/perf/Documentation/perf-bench.txt b/tools/perf/Documentation/perf-bench.txt
index 0181ddd..a3dbadb 100644
--- a/tools/perf/Documentation/perf-bench.txt
+++ b/tools/perf/Documentation/perf-bench.txt
@@ -1,5 +1,5 @@
 perf-bench(1)
-============
+=============
 
 NAME
 ----
diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index 8974e20..20d97d8 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -1,5 +1,5 @@
 perf-diff(1)
-==============
+============
 
 NAME
 ----
diff --git a/tools/perf/Documentation/perf-kmem.txt b/tools/perf/Documentation/perf-kmem.txt
index eac4d85..a52fcde 100644
--- a/tools/perf/Documentation/perf-kmem.txt
+++ b/tools/perf/Documentation/perf-kmem.txt
@@ -1,5 +1,5 @@
 perf-kmem(1)
-==============
+============
 
 NAME
 ----
diff --git a/tools/perf/Documentation/perf-trace-python.txt b/tools/perf/Documentation/perf-trace-python.txt
index 16a8650..864aac2 100644
--- a/tools/perf/Documentation/perf-trace-python.txt
+++ b/tools/perf/Documentation/perf-trace-python.txt
@@ -1,5 +1,5 @@
 perf-trace-python(1)
-==================
+====================
 
 NAME
 ----
diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
index 8879299..122ec9d 100644
--- a/tools/perf/Documentation/perf-trace.txt
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -1,5 +1,5 @@
 perf-trace(1)
-==============
+=============
 
 NAME
 ----
-- 
1.6.2.5

