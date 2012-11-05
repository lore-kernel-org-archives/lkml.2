Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933073Ab2KER13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 12:27:29 -0500
Received: from casper.infradead.org ([85.118.1.10]:33353 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab2KERSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 12:18:36 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/32] perf tests: Add attr record count test
Date: Mon,  5 Nov 2012 14:17:51 -0300
Message-Id: <1352135893-7564-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1352135893-7564-1-git-send-email-acme@infradead.org>
References: <1352135893-7564-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding test to validate perf_event_attr data for command:
  'record -c 123'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351634526-1516-9-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr/test-record-count |    8 ++++++++
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
1.7.9.2.358.g22243

