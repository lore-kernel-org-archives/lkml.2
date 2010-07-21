Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab0GUUxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 16:53:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:37528 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136Ab0GUUxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 16:53:06 -0400
Date: Wed, 21 Jul 2010 20:52:44 GMT
From: tip-bot for Josh Hunt <johunt@akamai.com>
Cc: linux-kernel@vger.kernel.org, johunt@akamai.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, johunt@akamai.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1279567876-25418-1-git-send-email-johunt@akamai.com>
References: <1279567876-25418-1-git-send-email-johunt@akamai.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Use correct macro to display sched_child_runs_first in /proc/sched_debug
Message-ID: <tip-eebef74695e1498e04e5f85be9c6f84bd2e7358a@git.kernel.org>
Git-Commit-ID: eebef74695e1498e04e5f85be9c6f84bd2e7358a
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 21 Jul 2010 20:52:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eebef74695e1498e04e5f85be9c6f84bd2e7358a
Gitweb:     http://git.kernel.org/tip/eebef74695e1498e04e5f85be9c6f84bd2e7358a
Author:     Josh Hunt <johunt@akamai.com>
AuthorDate: Mon, 19 Jul 2010 12:31:16 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 21 Jul 2010 21:46:12 +0200

sched: Use correct macro to display sched_child_runs_first in /proc/sched_debug

The sched_child_runs_first value in /proc/sched_debug is
currently displayed using a macro meant to split ns time values.
This patch uses the correct macro to display it as a plain
decimal value.

Signed-off-by: Josh Hunt <johunt@akamai.com>
Cc: peterz@infradead.org
Cc: juhlenko@akamai.com
Cc: efault@gmx.de
LKML-Reference: <1279567876-25418-1-git-send-email-johunt@akamai.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_debug.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
index 3556539..2e1b0d1 100644
--- a/kernel/sched_debug.c
+++ b/kernel/sched_debug.c
@@ -332,7 +332,7 @@ static int sched_debug_show(struct seq_file *m, void *v)
 	PN(sysctl_sched_latency);
 	PN(sysctl_sched_min_granularity);
 	PN(sysctl_sched_wakeup_granularity);
-	PN(sysctl_sched_child_runs_first);
+	P(sysctl_sched_child_runs_first);
 	P(sysctl_sched_features);
 #undef PN
 #undef P
