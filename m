Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab2EWM55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 08:57:57 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39113 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335Ab2EWM54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 08:57:56 -0400
MIME-Version: 1.0
Date: Wed, 23 May 2012 20:57:55 +0800
Message-ID: <CAJd=RBDJ0Bwo_E828bBpz0=G4qb3o6bxBwHaCMhk-GCD5jyfkA@mail.gmail.com>
Subject: Re: BFS 420: remove resched_cpu
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is no longer used, so remove.

--- a/kernel/sched/bfs.c	Mon May 14 20:50:38 2012
+++ b/kernel/sched/bfs.c	Wed May 23 20:07:50 2012
@@ -4988,14 +4988,6 @@ static inline struct sched_domain *lowes

 #endif /*  (CONFIG_SCHED_MC || CONFIG_SCHED_SMT) */

-static inline void resched_cpu(int cpu)
-{
-	unsigned long flags;
-
-	grq_lock_irqsave(&flags);
-	resched_task(cpu_curr(cpu));
-	grq_unlock_irqrestore(&flags);
-}

 /*
  * In the semi idle case, use the nearest busy cpu for migrating timers
--
