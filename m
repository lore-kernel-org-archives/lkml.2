Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab1L2Uqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Dec 2011 15:46:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39481 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab1L2Uqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Dec 2011 15:46:46 -0500
Date: Thu, 29 Dec 2011 12:46:10 -0800
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-fb2baceb5a64990163e93b77ee205d0173202ee6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, namhyung@gmail.com, mingo@elte.hu
In-Reply-To: <1323703017-6060-8-git-send-email-namhyung@gmail.com>
References: <1323703017-6060-8-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Fix usage string
Git-Commit-ID: fb2baceb5a64990163e93b77ee205d0173202ee6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 29 Dec 2011 12:46:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fb2baceb5a64990163e93b77ee205d0173202ee6
Gitweb:     http://git.kernel.org/tip/fb2baceb5a64990163e93b77ee205d0173202ee6
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Tue, 13 Dec 2011 00:16:56 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 22 Dec 2011 10:23:55 -0200

perf report: Fix usage string

perf report does not take a command from command line.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1323703017-6060-8-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index b2654c9..9051f6b 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -432,7 +432,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 {
 	char callchain_default_opt[] = "fractal,0.5,callee";
 	const char * const report_usage[] = {
-		"perf report [<options>] <command>",
+		"perf report [<options>]",
 		NULL
 	};
 	struct perf_report report = {
