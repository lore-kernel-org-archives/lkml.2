Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab0F3Iqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 04:46:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:45681 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508Ab0F3Iqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 04:46:54 -0400
Date: Wed, 30 Jun 2010 08:45:46 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, peterz@infradead.org, isloginov@gmail.com,
       randy.dunlap@oracle.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, peterz@infradead.org, tglx@linutronix.de,
       randy.dunlap@oracle.com, isloginov@gmail.com, mingo@elte.hu
In-Reply-To: <1277887031.1868.82.camel@laptop>
References: <1277887031.1868.82.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] init: Fix comment
Message-ID: <tip-9715856922bf8475f5428c29b6f4a9eebc97d391@git.kernel.org>
Git-Commit-ID: 9715856922bf8475f5428c29b6f4a9eebc97d391
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 30 Jun 2010 08:45:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9715856922bf8475f5428c29b6f4a9eebc97d391
Gitweb:     http://git.kernel.org/tip/9715856922bf8475f5428c29b6f4a9eebc97d391
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 30 Jun 2010 10:37:11 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 30 Jun 2010 10:42:44 +0200

init: Fix comment

Apparently "pid-1" confuses people...

Requested-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: torvalds@linux-foundation.org
Cc: randy.dunlap@oracle.com
Cc: Ilya Loginov <isloginov@gmail.com>
LKML-Reference: <1277887031.1868.82.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 init/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/main.c b/init/main.c
index 633442f..1692df3 100644
--- a/init/main.c
+++ b/init/main.c
@@ -431,7 +431,7 @@ static noinline void __init_refok rest_init(void)
 
 	rcu_scheduler_starting();
 	/*
-	 * We need to spawn init first so that it obtains pid-1, however
+	 * We need to spawn init first so that it obtains pid 1, however
 	 * the init task will end up wanting to create kthreads, which, if
 	 * we schedule it before we create kthreadd, will OOPS.
 	 */
