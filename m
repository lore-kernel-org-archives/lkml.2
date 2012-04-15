Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab2DOQHe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 12:07:34 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:45209 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab2DOQHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 12:07:33 -0400
From: Nicola Lamacchia <nicola.lamacchia@gmail.com>
To: tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org,
        Nicola Lamacchia <nicola.lamacchia@gmail.com>
Subject: [PATCH] Kernel: time: timer_stats: fix indentation issue.
Date: Sun, 15 Apr 2012 18:07:21 +0200
Message-Id: <1334506041-18612-1-git-send-email-nicola.lamacchia@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a coding style issue (bad indentation).

Signed-off-by: Nicola Lamacchia <nicola.lamacchia@gmail.com>
---
 kernel/time/timer_stats.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/timer_stats.c b/kernel/time/timer_stats.c
index 0b537f2..0aa0eb9 100644
--- a/kernel/time/timer_stats.c
+++ b/kernel/time/timer_stats.c
@@ -306,7 +306,7 @@ static int tstats_show(struct seq_file *m, void *v)
 
 	for (i = 0; i < nr_entries; i++) {
 		entry = entries + i;
- 		if (entry->timer_flag & TIMER_STATS_FLAG_DEFERRABLE) {
+		if (entry->timer_flag & TIMER_STATS_FLAG_DEFERRABLE) {
 			seq_printf(m, "%4luD, %5d %-16s ",
 				entry->count, entry->pid, entry->comm);
 		} else {
-- 
1.7.5.4

