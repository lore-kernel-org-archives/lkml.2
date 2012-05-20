Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab2ETK56 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 06:57:58 -0400
Received: from nm35.bullet.mail.ne1.yahoo.com ([98.138.229.28]:46229 "HELO
	nm35.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751912Ab2ETK54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 06:57:56 -0400
X-Yahoo-Newman-Id: 580027.13034.bm@smtp107.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: mdEiocIVM1lpziNF2W3IgBPxWEwGLqi9Ufk39gEJc45pfbx
 EEJaL.ts7xoSvd3zQah26MdNZ1putTjeFrgxJ9PJRGJBcygKBw8xMiYGlUW.
 HEqddhT6RXDYLNMpxFe_k9FapiyQQhQxtbkEYDqj90U5vUaFea8nKa9ym9EW
 .wdbRhli4k8JOE1.v8XWzS51Ouai7Hpi5I2mNMkycnYcWzFJIKMnacdxnU41
 UVpvqsa.fcbKvbcRcrB7t.uwMiIPjKNilzUl3Frl5a6cpSSDYhGewusBoTLE
 conN071BNXwphi5WfxuDhTVISSiJ3zDP6tk4W9mAsKEKWSdvAaicwAdWBP.b
 s5f4YAGMtHsOtK6_BR58jmKUaIDuvNHpozBmpzwZBurwy5uPBzpkm3dItV_H
 mhED5RMPQL..dZbfPAI0MQaxghN.u2LaOuMEnIuM2sdtJuGB3DvsRYSCQ_0I
 BOXSrnssHM73himTaQCH.ApGgaT.1Ki7Rr_x6sJhg
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: akpm@linux-foundation.org, manfred@colorfullife.com,
        a.p.zijlstra@chello.nl, paulmck@linux.vnet.ibm.com,
        josh@joshtriplett.org
Cc: linux-kernel@vger.kernel.org, ahiliation@yahoo.co.in
Subject: [PATCH]ipc:fixed spacing issues in coding style.
Date: Sun, 20 May 2012 16:31:13 +0530
Message-Id: <1337511673-3485-1-git-send-email-ahiliation@yahoo.co.in>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed spacing issues related to different operators
like * and : found by checkpatch.pl tool in ipc/sem.c

Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 ipc/sem.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/ipc/sem.c b/ipc/sem.c
index 10386b8..9301595 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -964,7 +964,7 @@ static int semctl_nolock(struct ipc_namespace *ns, int semid,
 		up_read(&sem_ids(ns).rw_mutex);
 		if (copy_to_user (arg.__buf, &seminfo, sizeof(struct seminfo))) 
 			return -EFAULT;
-		return (max_id < 0) ? 0: max_id;
+		return (max_id < 0) ? 0 : max_id;
 	}
 	case IPC_STAT:
 	case SEM_STAT:
@@ -1372,7 +1372,7 @@ static struct sem_undo *find_alloc_undo(struct ipc_namespace *ns, int semid)
 	spin_lock(&ulp->lock);
 	un = lookup_undo(ulp, semid);
 	spin_unlock(&ulp->lock);
-	if (likely(un!=NULL))
+	if (likely(un != NULL))
 		goto out;
 	rcu_read_unlock();
 
@@ -1732,7 +1732,7 @@ void exit_sem(struct task_struct *tsk)
 
 		/* perform adjustments registered in un */
 		for (i = 0; i < sma->sem_nsems; i++) {
-			struct sem * semaphore = &sma->sem_base[i];
+			struct sem *semaphore = &sma->sem_base[i];
 			if (un->semadj[i]) {
 				semaphore->semval += un->semadj[i];
 				/*
-- 
1.7.10

