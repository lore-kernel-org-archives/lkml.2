Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729Ab0JZCpM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:45:12 -0400
Received: from mail.perches.com ([173.55.12.10]:3557 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756994Ab0JZCoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:44:34 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/10] drivers/scsi:mvsas/mv_sas.c: Remove KERN_DEBUG from mv_dprintk use
Date: Mon, 25 Oct 2010 19:44:26 -0700
Message-Id: <df0b06c1f6f55bc1571296f07fc1bc059fc070bc.1288059486.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.90.gd4c43
In-Reply-To: <cover.1288059486.git.joe@perches.com>
References: <cover.1288059486.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/mvsas/mv_sas.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index adedaa9..f8bed25 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1698,7 +1698,7 @@ int mvs_abort_task(struct sas_task *task)
 			struct task_status_struct *tstat;
 			u32 slot_idx = (u32)(slot - mvi->slot_info);
 			tstat = &task->task_status;
-			mv_dprintk(KERN_DEBUG "mv_abort_task() mvi=%p task=%p "
+			mv_dprintk("mv_abort_task() mvi=%p task=%p "
 				   "slot=%p slot_idx=x%x\n",
 				   mvi, task, slot, slot_idx);
 			tstat->stat = SAS_ABORTED_TASK;
-- 
1.7.3.dirty

