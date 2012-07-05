Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab2GEM1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:27:12 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49709 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab2GEM1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:27:11 -0400
MIME-Version: 1.0
Date: Thu, 5 Jul 2012 20:27:09 +0800
Message-ID: <CAJd=RBAv=5B7FPRYQtEKnxTHCz65eC29d0w+ANoQivMWnhMfhQ@mail.gmail.com>
Subject: [patch] BFS 421-1: cleanup rt_queue
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first patch, a tiny cleanup, in the round of 421-1.

SOB: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched/bfs.c	Thu Jul  5 20:08:04 2012
+++ b/kernel/sched/bfs.c	Thu Jul  5 20:10:36 2012
@@ -84,7 +84,6 @@

 #define rt_prio(prio)		unlikely((prio) < MAX_RT_PRIO)
 #define rt_task(p)		rt_prio((p)->prio)
-#define rt_queue(rq)		rt_prio((rq)->rq_prio)
 #define batch_task(p)		(unlikely((p)->policy == SCHED_BATCH))
 #define is_rt_policy(policy)	((policy) == SCHED_FIFO || \
 					(policy) == SCHED_RR)
--
