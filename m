Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932955Ab2KERSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 12:18:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:33329 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932758Ab2KERSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 12:18:31 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 17/32] perf tests: Add attr record no delay test
Date: Mon,  5 Nov 2012 14:17:58 -0300
Message-Id: <1352135893-7564-18-git-send-email-acme@infradead.org>
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
  'record -D'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351634526-1516-16-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr/test-record-no-delay |    9 +++++++++
 1 file changed, 9 insertions(+)
 create mode 100644 tools/perf/tests/attr/test-record-no-delay

diff --git a/tools/perf/tests/attr/test-record-no-delay b/tools/perf/tests/attr/test-record-no-delay
new file mode 100644
index 0000000..f253b78
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-no-delay
@@ -0,0 +1,9 @@
+[config]
+command = record
+args    = -D kill >/dev/null 2>&1
+
+[event:base-record]
+sample_period=4000
+sample_type=263
+watermark=0
+wakeup_events=1
-- 
1.7.9.2.358.g22243

