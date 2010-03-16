Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937797Ab0CPOmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:42:10 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:52285 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S933040Ab0CPOmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:42:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/1] kernel/user: remove unreachable code
Date: Tue, 16 Mar 2010 15:41:55 +0100
Message-Id: <1268750515-12541-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code which executed this code was removed in 7c9414385ebfdd87cc542
(sched: Remove USER_SCHED). Remove the dangling code too.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Dhaval Giani <dhaval.giani@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
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
1.7.0.1


