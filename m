Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab2KNHOu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:14:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43783 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869Ab2KNHOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:14:48 -0500
Date: Tue, 13 Nov 2012 23:13:56 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-2fa10f2fe370f2da6c48dae5a154bfcd74848538@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1351634526-1516-17-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-17-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Add attr record branch any test
Git-Commit-ID: 2fa10f2fe370f2da6c48dae5a154bfcd74848538
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:14:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2fa10f2fe370f2da6c48dae5a154bfcd74848538
Gitweb:     http://git.kernel.org/tip/2fa10f2fe370f2da6c48dae5a154bfcd74848538
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 30 Oct 2012 23:01:57 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 5 Nov 2012 14:02:18 -0300

perf tests: Add attr record branch any test

Adding test to validate perf_event_attr data for command:
  'record -b'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351634526-1516-17-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr/test-record-branch-any |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/tools/perf/tests/attr/test-record-branch-any b/tools/perf/tests/attr/test-record-branch-any
new file mode 100644
index 0000000..1421960
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-branch-any
@@ -0,0 +1,8 @@
+[config]
+command = record
+args    = -b kill >/dev/null 2>&1
+
+[event:base-record]
+sample_period=4000
+sample_type=2311
+branch_sample_type=8
