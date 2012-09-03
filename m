Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab2ICIU5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 04:20:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:51049 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755584Ab2ICIUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 04:20:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,359,1344236400"; 
   d="scan'208";a="140902974"
From: Feng Tang <feng.tang@intel.com>
To: acme@redhat.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, andi@firstfloor.org,
        namhyung@kernel.org, dsahern@gmail.com, linux-kernel@vger.kernel.org,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH 3/7] perf scripts: Add event_analyzing_sample-record/report
Date: Mon,  3 Sep 2012 16:14:29 +0800
Message-Id: <1346660073-20279-4-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1346660073-20279-1-git-send-email-feng.tang@intel.com>
References: <1346660073-20279-1-git-send-email-feng.tang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that event_analyzing_sample.py can be shown by "perf script -l"

Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 .../python/bin/event_analyzing_sample-record       |    8 ++++++++
 .../python/bin/event_analyzing_sample-report       |    3 +++
 2 files changed, 11 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/scripts/python/bin/event_analyzing_sample-record
 create mode 100644 tools/perf/scripts/python/bin/event_analyzing_sample-report

diff --git a/tools/perf/scripts/python/bin/event_analyzing_sample-record b/tools/perf/scripts/python/bin/event_analyzing_sample-record
new file mode 100644
index 0000000..0d03b41
--- /dev/null
+++ b/tools/perf/scripts/python/bin/event_analyzing_sample-record
@@ -0,0 +1,8 @@
+#!/bin/bash
+
+#
+# event_analyzing_sample.py can cover all type of perf samples including
+# the tracepoints, so no special record requirements, just record what
+# you want to analyze.
+#
+perf record $@
diff --git a/tools/perf/scripts/python/bin/event_analyzing_sample-report b/tools/perf/scripts/python/bin/event_analyzing_sample-report
new file mode 100644
index 0000000..e04f3a6
--- /dev/null
+++ b/tools/perf/scripts/python/bin/event_analyzing_sample-report
@@ -0,0 +1,3 @@
+#!/bin/bash
+# description: analyze all perf samples
+perf script $@ -s "$PERF_EXEC_PATH"/scripts/python/event_analyzing_sample.py
--
1.7.1

