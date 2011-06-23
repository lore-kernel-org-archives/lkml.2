Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933312Ab1FWSVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:21:00 -0400
Received: from mail.windriver.com ([147.11.1.11]:34231 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932928Ab1FWRf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:35:57 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Carpenter <error27@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 082/247] sched: Remove some dead code
Date: Thu, 23 Jun 2011 13:32:30 -0400
Message-Id: <1308850515-15242-23-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 6427462bfa50f50dc6c088c07037264fcc73eca1 upstream.

This was left over from "7c9414385e sched: Remove USER_SCHED"

Signed-off-by: Dan Carpenter <error27@gmail.com>
Acked-by: Dhaval Giani <dhaval.giani@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
LKML-Reference: <20100315082148.GD18181@bicker>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
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
-- 
1.7.4.4

