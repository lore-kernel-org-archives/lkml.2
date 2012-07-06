Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab2GFNrl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 09:47:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54062 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab2GFNri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 09:47:38 -0400
Date: Fri, 6 Jul 2012 06:47:20 -0700
From: tip-bot for Namhyung Kim <namhyung@kernel.org>
Message-ID: <tip-95c0d71dcb853c2eca5f2231ebbd4c1d3af775b7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1341326251-4140-1-git-send-email-namhyung@kernel.org>
References: <1341326251-4140-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] MAINTAINERS/sched:
  Update scheduler file pattern
Git-Commit-ID: 95c0d71dcb853c2eca5f2231ebbd4c1d3af775b7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 06:47:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  95c0d71dcb853c2eca5f2231ebbd4c1d3af775b7
Gitweb:     http://git.kernel.org/tip/95c0d71dcb853c2eca5f2231ebbd4c1d3af775b7
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 3 Jul 2012 23:37:31 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 6 Jul 2012 12:55:35 +0200

MAINTAINERS/sched: Update scheduler file pattern

The commit 391e43da797a ("sched: Move all scheduler bits into
kernel/sched/") moved all scheduler codes to the kernel/sched/
directory, but missed the MAINTAINERS. Since it still expects
files from kernel/ directory, get_maintainer script has to rely
on the git (log) fallback mechanism.

 $ scripts/get_maintainer.pl -f kernel/sched/core.c --nogit-fallback
 linux-kernel@vger.kernel.org (open list)

With this patch:

 $ scripts/get_maintainer.pl -f kernel/sched/core.c --nogit-fallback
 Ingo Molnar <mingo@redhat.com> (maintainer:SCHEDULER)
 Peter Zijlstra <peterz@infradead.org> (maintainer:SCHEDULER)
 linux-kernel@vger.kernel.org (open list)

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1341326251-4140-1-git-send-email-namhyung@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 03df1d1..214d754 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5909,7 +5909,7 @@ M:	Ingo Molnar <mingo@redhat.com>
 M:	Peter Zijlstra <peterz@infradead.org>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git sched/core
 S:	Maintained
-F:	kernel/sched*
+F:	kernel/sched/
 F:	include/linux/sched.h
 
 SCORE ARCHITECTURE
