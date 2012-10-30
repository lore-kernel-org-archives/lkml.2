Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758355Ab2J3WCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 18:02:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758268Ab2J3WCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 18:02:44 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 08/25] perf tests: Add attr record count test
Date: Tue, 30 Oct 2012 23:01:49 +0100
Message-Id: <1351634526-1516-9-git-send-email-jolsa@redhat.com>
In-Reply-To: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding test to validate perf_event_attr data for command:
  'record -c 123'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/tests/attr/test-record-count | 8 ++++++++
 1 file changed, 8 insertions(+)
 create mode 100644 tools/perf/tests/attr/test-record-count

diff --git a/tools/perf/tests/attr/test-record-count b/tools/perf/tests/attr/test-record-count
new file mode 100644
index 0000000..2f841de
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-count
@@ -0,0 +1,8 @@
+[config]
+command = record
+args    = -c 123 kill >/dev/null 2>&1
+
+[event:base-record]
+sample_period=123
+sample_type=7
+freq=0
-- 
1.7.11.7

