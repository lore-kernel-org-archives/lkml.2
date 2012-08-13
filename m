Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab2HMREt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 13:04:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33674 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab2HMREr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 13:04:47 -0400
Date: Mon, 13 Aug 2012 10:04:32 -0700
From: tip-bot for Borislav Petkov <borislav.petkov@amd.com>
Message-ID: <tip-532b1858c5241bedfff5ab863d7cf012e8b81a6b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, borislav.petkov@amd.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, borislav.petkov@amd.com
In-Reply-To: <1344435364-18632-1-git-send-email-bp@amd64.org>
References: <1344435364-18632-1-git-send-email-bp@amd64.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix __sched_period comment
Git-Commit-ID: 532b1858c5241bedfff5ab863d7cf012e8b81a6b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 13 Aug 2012 10:04:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  532b1858c5241bedfff5ab863d7cf012e8b81a6b
Gitweb:     http://git.kernel.org/tip/532b1858c5241bedfff5ab863d7cf012e8b81a6b
Author:     Borislav Petkov <borislav.petkov@amd.com>
AuthorDate: Wed, 8 Aug 2012 16:16:04 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 13 Aug 2012 18:58:15 +0200

sched: Fix __sched_period comment

It should be sched_nr_latency so fix it before it annoys me more.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1344435364-18632-1-git-send-email-bp@amd64.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c219bf8..99285a8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -597,7 +597,7 @@ calc_delta_fair(unsigned long delta, struct sched_entity *se)
 /*
  * The idea is to set a period in which each task runs once.
  *
- * When there are too many tasks (sysctl_sched_nr_latency) we have to stretch
+ * When there are too many tasks (sched_nr_latency) we have to stretch
  * this period because otherwise the slices get too small.
  *
  * p = (nr <= nl) ? l : l*nr/nl
