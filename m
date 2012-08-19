Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab2HSPqb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 11:46:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47078 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab2HSPq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 11:46:29 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH] perf perl/python: Fix libexec scripts path in Documentation
Date: Sun, 19 Aug 2012 09:46:22 -0600
Message-Id: <1345391182-71825-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

libexec path is /libexec/perf-core/scripts/*/Perf-Trace-Util

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
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
1.7.10.1

