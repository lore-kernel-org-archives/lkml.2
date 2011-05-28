Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355Ab1E1PlS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 11:41:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:50254 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665Ab1E1PlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 11:41:17 -0400
Date: Sat, 28 May 2011 15:40:54 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-weqbs0tkk2u0qp1xxdxxosfg@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf top: Remove unused macro
Git-Commit-ID: 59fb1ee95e74e8e0777289c44300cbe812aca836
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 28 May 2011 15:40:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  59fb1ee95e74e8e0777289c44300cbe812aca836
Gitweb:     http://git.kernel.org/tip/59fb1ee95e74e8e0777289c44300cbe812aca836
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 27 May 2011 11:14:00 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 27 May 2011 16:02:20 -0300

perf top: Remove unused macro

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Link: http://lkml.kernel.org/n/tip-weqbs0tkk2u0qp1xxdxxosfg@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 2d7934e..375ed16 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -62,8 +62,6 @@
 #include <linux/unistd.h>
 #include <linux/types.h>
 
-#define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
-
 static struct perf_top top = {
 	.count_filter		= 5,
 	.delay_secs		= 2,
