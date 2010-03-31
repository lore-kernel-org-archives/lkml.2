Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab0CaDoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 23:44:17 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:26524 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205Ab0CaDoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 23:44:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ldSqjxO7gcZOTiqTvbuawITy3YDBtHktwnfSke9OBFEEYfYTgpbsSN76cW/UrYYwuP
         AvxrkieYSpdVbPSMUFjjWE6BL/3ICLwG3OjOSJc8NNsCprC7CZgH2yl4JxxPVNA3e8fX
         egyFg50azdEoCePYvLCltnHmHbGqw2nSeGFtc=
From: Dan Milway <dan.milway@gmail.com>
To: gregkh@suse.de, andrew@lunn.ch, lindner_marek@yahoo.de,
       siwu@hrz.tu-chemnitz.de, linus.luessing@web.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Dan Milway <dan.milway@gmail.com>
Subject: [PATCH] Staging: batman-adv: fix whitespace coding style issue in proc.c This is a patch to the proc.c file that fixes several whitespace warnings found by the checkpatch.pl tool Signed-off by: Dan Milway <dan.milway@gmail.com>
Date: Tue, 30 Mar 2010 23:43:39 -0400
Message-Id: <1270007019-12414-1-git-send-email-dan.milway@gmail.com>
X-Mailer: git-send-email 1.7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/batman-adv/proc.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/batman-adv/proc.c b/drivers/staging/batman-adv/proc.c
index 7de60e8..1c51a05 100644
--- a/drivers/staging/batman-adv/proc.c
+++ b/drivers/staging/batman-adv/proc.c
@@ -41,7 +41,7 @@ static int proc_interfaces_read(struct seq_file *seq, void *offset)
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(batman_if, &if_list, list) {
-		seq_printf(seq, "[%8s] %s %s \n",
+		seq_printf(seq, "[%8s] %s %s\n",
 			   (batman_if->if_active == IF_ACTIVE ?
 			    "active" : "inactive"),
 			   batman_if->dev,
@@ -188,18 +188,18 @@ static int proc_originators_read(struct seq_file *seq, void *offset)
 	rcu_read_lock();
 	if (list_empty(&if_list)) {
 		rcu_read_unlock();
-		seq_printf(seq, "BATMAN disabled - please specify interfaces to enable it \n");
+		seq_printf(seq, "BATMAN disabled - please specify interfaces to enable it\n");
 		goto end;
 	}
 
 	if (((struct batman_if *)if_list.next)->if_active != IF_ACTIVE) {
 		rcu_read_unlock();
-		seq_printf(seq, "BATMAN disabled - primary interface not active \n");
+		seq_printf(seq, "BATMAN disabled - primary interface not active\n");
 		goto end;
 	}
 
 	seq_printf(seq,
-		   "  %-14s (%s/%i) %17s [%10s]: %20s ... [B.A.T.M.A.N. adv %s%s, MainIF/MAC: %s/%s] \n",
+		   "  %-14s (%s/%i) %17s [%10s]: %20s ... [B.A.T.M.A.N. adv %s%s, MainIF/MAC: %s/%s]\n",
 		   "Originator", "#", TQ_MAX_VALUE, "Nexthop", "outgoingIF",
 		   "Potential nexthops", SOURCE_VERSION, REVISION_VERSION_STR,
 		   ((struct batman_if *)if_list.next)->dev,
@@ -240,7 +240,7 @@ static int proc_originators_read(struct seq_file *seq, void *offset)
 	spin_unlock_irqrestore(&orig_hash_lock, flags);
 
 	if (batman_count == 0)
-		seq_printf(seq, "No batman nodes in range ... \n");
+		seq_printf(seq, "No batman nodes in range ...\n");
 
 end:
 	return 0;
@@ -262,7 +262,7 @@ static int proc_transt_local_read(struct seq_file *seq, void *offset)
 	rcu_read_lock();
 	if (list_empty(&if_list)) {
 		rcu_read_unlock();
-		seq_printf(seq, "BATMAN disabled - please specify interfaces to enable it \n");
+		seq_printf(seq, "BATMAN disabled - please specify interfaces to enable it\n");
 		goto end;
 	}
 
@@ -294,7 +294,7 @@ static int proc_transt_global_read(struct seq_file *seq, void *offset)
 	rcu_read_lock();
 	if (list_empty(&if_list)) {
 		rcu_read_unlock();
-		seq_printf(seq, "BATMAN disabled - please specify interfaces to enable it \n");
+		seq_printf(seq, "BATMAN disabled - please specify interfaces to enable it\n");
 		goto end;
 	}
 	rcu_read_unlock();
@@ -350,9 +350,9 @@ static int proc_vis_srv_read(struct seq_file *seq, void *offset)
 {
 	int vis_server = atomic_read(&vis_mode);
 
-	seq_printf(seq, "[%c] client mode (server disabled) \n",
+	seq_printf(seq, "[%c] client mode (server disabled)\n",
 			(vis_server == VIS_TYPE_CLIENT_UPDATE) ? 'x' : ' ');
-	seq_printf(seq, "[%c] server mode (server enabled) \n",
+	seq_printf(seq, "[%c] server mode (server enabled)\n",
 			(vis_server == VIS_TYPE_SERVER_SYNC) ? 'x' : ' ');
 
 	return 0;
-- 
1.7.0

