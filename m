Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077Ab2HUQa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:30:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32960 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757954Ab2HUQa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:30:27 -0400
Date: Tue, 21 Aug 2012 09:30:15 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-e8d0f400ee3247ad22faa6afabfa7022260ef7a5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1345391182-71825-1-git-send-email-dsahern@gmail.com>
References: <1345391182-71825-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script perl/python:
  Fix libexec scripts path in Documentation
Git-Commit-ID: e8d0f400ee3247ad22faa6afabfa7022260ef7a5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:30:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e8d0f400ee3247ad22faa6afabfa7022260ef7a5
Gitweb:     http://git.kernel.org/tip/e8d0f400ee3247ad22faa6afabfa7022260ef7a5
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sun, 19 Aug 2012 09:46:22 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 20 Aug 2012 09:30:36 -0300

perf script perl/python: Fix libexec scripts path in Documentation

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
