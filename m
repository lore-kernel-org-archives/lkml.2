Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1HJJsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 05:48:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:43295 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043Ab1HJJsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 05:48:10 -0400
Date: Wed, 10 Aug 2011 09:47:53 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-580cabed88ebc631e740b16010f2fa6ba882652f@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110809124651.GD2056@jolsa.brq.redhat.com>
References: <20110809124651.GD2056@jolsa.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf sched: Usage leftover from trace -> script rename
Git-Commit-ID: 580cabed88ebc631e740b16010f2fa6ba882652f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Aug 2011 09:47:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  580cabed88ebc631e740b16010f2fa6ba882652f
Gitweb:     http://git.kernel.org/tip/580cabed88ebc631e740b16010f2fa6ba882652f
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 9 Aug 2011 14:46:51 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 9 Aug 2011 13:32:12 -0300

perf sched: Usage leftover from trace -> script rename

The 'perf sched' command usage still showing 'trace' command instead of
the 'script' command.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20110809124651.GD2056@jolsa.brq.redhat.com
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 3d5702c..5177964 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1777,7 +1777,7 @@ static void __cmd_replay(void)
 
 
 static const char * const sched_usage[] = {
-	"perf sched [<options>] {record|latency|map|replay|trace}",
+	"perf sched [<options>] {record|latency|map|replay|script}",
 	NULL
 };
 
