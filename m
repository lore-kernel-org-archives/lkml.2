Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422Ab0EJHWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 03:22:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:53972 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863Ab0EJHWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 03:22:34 -0400
Date: Mon, 10 May 2010 07:22:07 GMT
From: tip-bot for Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, dhaval.giani@gmail.com, hpa@zytor.com,
       mingo@redhat.com, lizf@cn.fujitsu.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dhaval.giani@gmail.com,
       linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4BE77C6B.5010402@cn.fujitsu.com>
References: <4BE77C6B.5010402@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove a stale comment
Message-ID: <tip-af507ae8a0512a83728b17d8f8c5fa1561669f50@git.kernel.org>
Git-Commit-ID: af507ae8a0512a83728b17d8f8c5fa1561669f50
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 10 May 2010 07:22:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  af507ae8a0512a83728b17d8f8c5fa1561669f50
Gitweb:     http://git.kernel.org/tip/af507ae8a0512a83728b17d8f8c5fa1561669f50
Author:     Li Zefan <lizf@cn.fujitsu.com>
AuthorDate: Mon, 10 May 2010 11:24:27 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 10 May 2010 08:48:39 +0200

sched: Remove a stale comment

This comment should have been removed together with uids_mutex
when removing user sched.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dhaval Giani <dhaval.giani@gmail.com>
LKML-Reference: <4BE77C6B.5010402@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/user.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/user.c b/kernel/user.c
index 8e1c8c0..7e72614 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -136,7 +136,6 @@ struct user_struct *alloc_uid(struct user_namespace *ns, uid_t uid)
 	struct hlist_head *hashent = uidhashentry(ns, uid);
 	struct user_struct *up, *new;
 
-	/* Make uid_hash_find() + uid_hash_insert() atomic. */
 	spin_lock_irq(&uidhash_lock);
 	up = uid_hash_find(uid, hashent);
 	spin_unlock_irq(&uidhash_lock);
