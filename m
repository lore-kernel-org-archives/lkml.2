Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934838Ab2J3WGU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 18:06:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934794Ab2J3WDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 18:03:00 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 14/25] perf tests: Add attr record raw test
Date: Tue, 30 Oct 2012 23:01:55 +0100
Message-Id: <1351634526-1516-15-git-send-email-jolsa@redhat.com>
In-Reply-To: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "jolsa@redhat.com" <jolsa@redhat.com>

Adding test to validate perf_event_attr data for command:
  'record -R'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/tests/attr/test-record-raw | 7 +++++++
 1 file changed, 7 insertions(+)
 create mode 100644 tools/perf/tests/attr/test-record-raw

diff --git a/tools/perf/tests/attr/test-record-raw b/tools/perf/tests/attr/test-record-raw
new file mode 100644
index 0000000..4a8ef25
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-raw
@@ -0,0 +1,7 @@
+[config]
+command = record
+args    = -R kill >/dev/null 2>&1
+
+[event:base-record]
+sample_period=4000
+sample_type=1415
-- 
1.7.11.7

