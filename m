Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab2KNHBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:01:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43556 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab2KNHBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:01:22 -0500
Date: Tue, 13 Nov 2012 23:00:51 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-55adeee3aaf745cc8b4e7c5976afbab95bde5697@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1351634526-1516-12-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-12-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Add attr record no samples test
Git-Commit-ID: 55adeee3aaf745cc8b4e7c5976afbab95bde5697
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:00:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  55adeee3aaf745cc8b4e7c5976afbab95bde5697
Gitweb:     http://git.kernel.org/tip/55adeee3aaf745cc8b4e7c5976afbab95bde5697
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 30 Oct 2012 23:01:52 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 1 Nov 2012 17:08:11 -0300

perf tests: Add attr record no samples test

Adding test to validate perf_event_attr data for command:
  'record -n'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351634526-1516-12-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr/test-record-no-samples |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/tests/attr/test-record-no-samples b/tools/perf/tests/attr/test-record-no-samples
new file mode 100644
index 0000000..d0141b2
--- /dev/null
+++ b/tools/perf/tests/attr/test-record-no-samples
@@ -0,0 +1,6 @@
+[config]
+command = record
+args    = -n kill >/dev/null 2>&1
+
+[event:base-record]
+sample_period=0
