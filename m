Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933579Ab0HEPLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:11:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39335 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933555Ab0HEPLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:11:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=gi1QB6WuEtiE7/ET7JLeUhYmDUuZJhzHKt4DKgScoKHGc3pywxYJYYglj94Tf1Sdux
         zE03DEGempM+92YvJ9A5T3kBKen3ND2BJ7m91ez/XRR/WYpEzbdqX4mPD+CMvf9NfCdE
         ZCGGEKqeiBsw5y39L070uIPP6s/ADtLxB7q/g=
From: John Kacur <jkacur@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 2/2] [TRIVIAL] fix grammar by adding a missing "to" in the comments
Date: Thu,  5 Aug 2010 17:10:54 +0200
Message-Id: <1281021054-4228-2-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1281021054-4228-1-git-send-email-jkacur@redhat.com>
References: <1281021054-4228-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a minor grammar problem in the comments in hung_task.c

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 kernel/hung_task.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index bca9423..53ead17 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -111,7 +111,7 @@ static void check_hung_task(struct task_struct *t, unsigned long timeout)
  * periodically exit the critical section and enter a new one.
  *
  * For preemptible RCU it is sufficient to call rcu_read_unlock in order
- * exit the grace period. For classic RCU, a reschedule is required.
+ * to exit the grace period. For classic RCU, a reschedule is required.
  */
 static void rcu_lock_break(struct task_struct *g, struct task_struct *t)
 {
-- 
1.7.2

