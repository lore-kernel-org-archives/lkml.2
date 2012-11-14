Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686Ab2KNHAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:00:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43541 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab2KNHAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:00:48 -0500
Date: Tue, 13 Nov 2012 22:59:50 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-da98f8df49eb799b37587eb4a13ea7a1a9f9e47c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1351634526-1516-11-git-send-email-jolsa@redhat.com>
References: <1351634526-1516-11-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Add attr record period test
Git-Commit-ID: da98f8df49eb799b37587eb4a13ea7a1a9f9e47c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 22:59:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  da98f8df49eb799b37587eb4a13ea7a1a9f9e47c
Gitweb:     http://git.kernel.org/tip/da98f8df49eb799b37587eb4a13ea7a1a9f9e47c
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 30 Oct 2012 23:01:51 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 1 Nov 2012 17:08:03 -0300

perf tests: Add attr record period test

Adding test to validate perf_event_attr data for command:
  'record -c 100 -P'

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351634526-1516-11-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 .../attr/{test-record-freq => test-record-period}  |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/tests/attr/test-record-freq b/tools/perf/tests/attr/test-record-period
similarity index 57%
copy from tools/perf/tests/attr/test-record-freq
copy to tools/perf/tests/attr/test-record-period
index 600d0f8..8abc531 100644
--- a/tools/perf/tests/attr/test-record-freq
+++ b/tools/perf/tests/attr/test-record-period
@@ -1,6 +1,7 @@
 [config]
 command = record
-args    = -F 100 kill >/dev/null 2>&1
+args    = -c 100 -P kill >/dev/null 2>&1
 
 [event:base-record]
 sample_period=100
+freq=0
