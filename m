Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab2HXJBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 05:01:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757932Ab2HXJB1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 05:01:27 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 09/13] perf test: Add perf_event_attr record no-inherit test
Date: Fri, 24 Aug 2012 11:00:40 +0200
Message-Id: <1345798844-27423-10-git-send-email-jolsa@redhat.com>
In-Reply-To: <1345798844-27423-1-git-send-email-jolsa@redhat.com>
References: <1345798844-27423-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding test to validate perf_event_attr data for command:
  'record -i'

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/test-attr/test-record-no-inherit | 7 +++++++
 1 file changed, 7 insertions(+)
 create mode 100644 tools/perf/util/test-attr/test-record-no-inherit

diff --git a/tools/perf/util/test-attr/test-record-no-inherit b/tools/perf/util/test-attr/test-record-no-inherit
new file mode 100644
index 0000000..9079a25
--- /dev/null
+++ b/tools/perf/util/test-attr/test-record-no-inherit
@@ -0,0 +1,7 @@
+[config]
+command = record
+args    = -i kill >/dev/null 2>&1
+
+[event:base-record]
+sample_type=259
+inherit=0
-- 
1.7.11.4

