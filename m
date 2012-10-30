Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934829Ab2J3WIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 18:08:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64961 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753742Ab2J3WCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 18:02:45 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 07/25] perf tests: Add attr record freq test
Date: Tue, 30 Oct 2012 23:01:48 +0100
Message-Id: <1351634526-1516-8-git-send-email-jolsa@redhat.com>
In-Reply-To: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding test to validate perf_event_attr data for command:
  'record -F 100'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/tests/attr/test-record-freq | 6 ++++++
 1 file changed, 6 insertions(+)
 create mode 100644 tools/perf/tests/attr/test-record-freq

diff --git a/tools/perf/tests/attr/test-record-freq b/tools/perf/tests/attr/test-record-freq
new file mode 100644
index 0000000..600d0f8
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-freq
@@ -0,0 +1,6 @@
+[config]
+command = record
+args    = -F 100 kill >/dev/null 2>&1
+
+[event:base-record]
+sample_period=100
-- 
1.7.11.7

