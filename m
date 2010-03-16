Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966409Ab0CPOs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:48:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:44606 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966389Ab0CPOsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:48:19 -0400
Date: Tue, 16 Mar 2010 14:47:36 GMT
From: tip-bot for Dan Carpenter <error27@gmail.com>
Cc: linux-kernel@vger.kernel.org, dhaval.giani@gmail.com, hpa@zytor.com,
       mingo@redhat.com, kay.sievers@vrfy.org, error27@gmail.com,
       gregkh@suse.de, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, dhaval.giani@gmail.com,
       linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, error27@gmail.com,
       gregkh@suse.de, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100315082148.GD18181@bicker>
References: <20100315082148.GD18181@bicker>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove some dead code
Message-ID: <tip-6427462bfa50f50dc6c088c07037264fcc73eca1@git.kernel.org>
Git-Commit-ID: 6427462bfa50f50dc6c088c07037264fcc73eca1
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 16 Mar 2010 14:47:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6427462bfa50f50dc6c088c07037264fcc73eca1
Gitweb:     http://git.kernel.org/tip/6427462bfa50f50dc6c088c07037264fcc73eca1
Author:     Dan Carpenter <error27@gmail.com>
AuthorDate: Mon, 15 Mar 2010 11:21:48 +0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 16 Mar 2010 11:05:44 +0100

sched: Remove some dead code

This was left over from "7c9414385e sched: Remove USER_SCHED"

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Dhaval Giani <dhaval.giani@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
LKML-Reference: <20100315082148.GD18181@bicker>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/user.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/user.c b/kernel/user.c
index 766467b..ec3b222 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -178,8 +178,6 @@ struct user_struct *alloc_uid(struct user_namespace *ns, uid_t uid)
 
 	return up;
 
-	put_user_ns(new->user_ns);
-	kmem_cache_free(uid_cachep, new);
 out_unlock:
 	return NULL;
 }
