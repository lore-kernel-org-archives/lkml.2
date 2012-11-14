Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab2KNHLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:11:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43725 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab2KNHLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:11:14 -0500
Date: Tue, 13 Nov 2012 23:10:53 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-23823641ff8415ef500483af06a58069f7470d23@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1351634526-1516-14-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-14-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Add attr record data test
Git-Commit-ID: 23823641ff8415ef500483af06a58069f7470d23
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:10:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  23823641ff8415ef500483af06a58069f7470d23
Gitweb:     http://git.kernel.org/tip/23823641ff8415ef500483af06a58069f7470d23
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 30 Oct 2012 23:01:54 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 5 Nov 2012 14:02:02 -0300

perf tests: Add attr record data test

Adding test to validate perf_event_attr data for command:
  'record -d'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351634526-1516-14-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr/test-record-data |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/tools/perf/tests/attr/test-record-data b/tools/perf/tests/attr/test-record-data
new file mode 100644
index 0000000..6627c3e
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-data
@@ -0,0 +1,8 @@
+[config]
+command = record
+args    = -d kill >/dev/null 2>&1
+
+[event:base-record]
+sample_period=4000
+sample_type=271
+mmap_data=1
