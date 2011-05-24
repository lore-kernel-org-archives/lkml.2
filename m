Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab1EXDLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 23:11:30 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55977 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab1EXDL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 23:11:29 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DDB21D8.3090400@jp.fujitsu.com>
Date: Tue, 24 May 2011 12:11:20 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: minchan.kim@gmail.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, rientjes@google.com,
        hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, oleg@redhat.com
Subject: Re: [PATCH 3/5] oom: oom-killer don't use proportion of system-ram
 internally
References: <4DD61F80.1020505@jp.fujitsu.com>	<4DD6204D.5020109@jp.fujitsu.com> <BANLkTinpX59NnwsJVQZNTgt_6X3DVK9WLg@mail.gmail.com> <4DDB0D93.5070005@jp.fujitsu.com>
In-Reply-To: <4DDB0D93.5070005@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ok, removed.

I'm sorry. previous patch has white space damage.
Let's retry send it.


>From 3dda8863e5acdba7a714f0e7506fae931865c442 Mon Sep 17 00:00:00 2001
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Tue, 24 May 2011 10:43:49 +0900
Subject: [PATCH] remove unrelated comments

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/oom_kill.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index ec075cc..b01fa64 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -184,8 +184,6 @@ unsigned long oom_badness(struct task_struct *p, struct mem_cgroup *mem,
 	/*
 	 * Root processes get 3% bonus, just like the __vm_enough_memory()
 	 * implementation used by LSMs.
-	 *
-	 * XXX: Too large bonus, example, if the system have tera-bytes memory..
 	 */
 	if (protect_root && has_capability_noaudit(p, CAP_SYS_ADMIN)) {
 		if (points >= totalpages / 32)
-- 
1.7.3.1



