Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab2KNHQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:16:26 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43831 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab2KNHQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:16:23 -0500
Date: Tue, 13 Nov 2012 23:15:58 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-9602681f705830955eff1c2dd18283e5a01be58c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1351634526-1516-20-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-20-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Add attr stat no-inherit test
Git-Commit-ID: 9602681f705830955eff1c2dd18283e5a01be58c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:16:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9602681f705830955eff1c2dd18283e5a01be58c
Gitweb:     http://git.kernel.org/tip/9602681f705830955eff1c2dd18283e5a01be58c
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 30 Oct 2012 23:02:00 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 5 Nov 2012 14:02:30 -0300

perf tests: Add attr stat no-inherit test

Adding test to validate perf_event_attr data for command:
  'stat -i'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351634526-1516-20-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr/test-stat-no-inherit |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/tests/attr/test-stat-no-inherit b/tools/perf/tests/attr/test-stat-no-inherit
new file mode 100644
index 0000000..d54b2a1e
--- /dev/null
+++ b/tools/perf/tests/attr/test-stat-no-inherit
@@ -0,0 +1,7 @@
+[config]
+command = stat
+args    = -i -e cycles kill >/dev/null 2>&1
+ret     = 1
+
+[event:base-stat]
+inherit=0
