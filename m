Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758504Ab2HXJCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 05:02:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758115Ab2HXJBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 05:01:33 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 11/13] perf test: Add perf_event_attr stat no-inherit test
Date: Fri, 24 Aug 2012 11:00:42 +0200
Message-Id: <1345798844-27423-12-git-send-email-jolsa@redhat.com>
In-Reply-To: <1345798844-27423-1-git-send-email-jolsa@redhat.com>
References: <1345798844-27423-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding test to validate perf_event_attr data for command:
'stat -i'

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/test-attr/test-stat-no-inherit | 7 +++++++
 1 file changed, 7 insertions(+)
 create mode 100644 tools/perf/util/test-attr/test-stat-no-inherit

diff --git a/tools/perf/util/test-attr/test-stat-no-inherit b/tools/perf/util/test-attr/test-stat-no-inherit
new file mode 100644
index 0000000..d54b2a1e
--- /dev/null
+++ b/tools/perf/util/test-attr/test-stat-no-inherit
@@ -0,0 +1,7 @@
+[config]
+command = stat
+args    = -i -e cycles kill >/dev/null 2>&1
+ret     = 1
+
+[event:base-stat]
+inherit=0
-- 
1.7.11.4

