Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab2HTQcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:32:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56306 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253Ab2HTQ0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:26:38 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 19/24] perf script perl/python: Fix libexec scripts path in Documentation
Date: Mon, 20 Aug 2012 13:26:20 -0300
Message-Id: <1345479985-18669-20-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1345479985-18669-1-git-send-email-acme@infradead.org>
References: <1345479985-18669-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

The libexec path is /libexec/perf-core/scripts/*/Perf-Trace-Util.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1345391182-71825-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-script-perl.txt   |    4 ++--
 tools/perf/Documentation/perf-script-python.txt |   10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/Documentation/perf-script-perl.txt b/tools/perf/Documentation/perf-script-perl.txt
index 3152cca..d00bef2 100644
--- a/tools/perf/Documentation/perf-script-perl.txt
+++ b/tools/perf/Documentation/perf-script-perl.txt
@@ -116,8 +116,8 @@ search path and 'use'ing a few support modules (see module
 descriptions below):
 
 ----
- use lib "$ENV{'PERF_EXEC_PATH'}/scripts/perl/perf-script-Util/lib";
- use lib "./perf-script-Util/lib";
+ use lib "$ENV{'PERF_EXEC_PATH'}/scripts/perl/Perf-Trace-Util/lib";
+ use lib "./Perf-Trace-Util/lib";
  use Perf::Trace::Core;
  use Perf::Trace::Context;
  use Perf::Trace::Util;
diff --git a/tools/perf/Documentation/perf-script-python.txt b/tools/perf/Documentation/perf-script-python.txt
index 4710220..a4027f2 100644
--- a/tools/perf/Documentation/perf-script-python.txt
+++ b/tools/perf/Documentation/perf-script-python.txt
@@ -129,7 +129,7 @@ import os
 import sys
 
 sys.path.append(os.environ['PERF_EXEC_PATH'] + \
-	'/scripts/python/perf-script-Util/lib/Perf/Trace')
+	'/scripts/python/Perf-Trace-Util/lib/Perf/Trace')
 
 from perf_trace_context import *
 from Core import *
@@ -216,7 +216,7 @@ import os
 import sys
 
 sys.path.append(os.environ['PERF_EXEC_PATH'] + \
-	'/scripts/python/perf-script-Util/lib/Perf/Trace')
+	'/scripts/python/Perf-Trace-Util/lib/Perf/Trace')
 
 from perf_trace_context import *
 from Core import *
@@ -279,7 +279,7 @@ import os
 import sys
 
 sys.path.append(os.environ['PERF_EXEC_PATH'] + \
-	'/scripts/python/perf-script-Util/lib/Perf/Trace')
+	'/scripts/python/Perf-Trace-Util/lib/Perf/Trace')
 
 from perf_trace_context import *
 from Core import *
@@ -391,7 +391,7 @@ drwxr-xr-x 4 trz trz 4096 2010-01-26 22:30 .
 drwxr-xr-x 4 trz trz 4096 2010-01-26 22:29 ..
 drwxr-xr-x 2 trz trz 4096 2010-01-26 22:29 bin
 -rw-r--r-- 1 trz trz 2548 2010-01-26 22:29 check-perf-script.py
-drwxr-xr-x 3 trz trz 4096 2010-01-26 22:49 perf-script-Util
+drwxr-xr-x 3 trz trz 4096 2010-01-26 22:49 Perf-Trace-Util
 -rw-r--r-- 1 trz trz 1462 2010-01-26 22:30 syscall-counts.py
 ----
 
@@ -518,7 +518,7 @@ descriptions below):
  import sys
 
  sys.path.append(os.environ['PERF_EXEC_PATH'] + \
-	      '/scripts/python/perf-script-Util/lib/Perf/Trace')
+	      '/scripts/python/Perf-Trace-Util/lib/Perf/Trace')
 
  from perf_trace_context import *
  from Core import *
-- 
1.7.1

