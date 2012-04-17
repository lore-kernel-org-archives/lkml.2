Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359Ab2DQNzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 09:55:00 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:44631 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932402Ab2DQNyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 09:54:41 -0400
From: Laura Vasilescu <laura@rosedu.org>
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, jack_wang@usish.com, James.Bottomley@suse.de,
        dan.j.williams@intel.com, yuxiangl@marvell.com,
        JBottomley@parallels.com, Laura Vasilescu <laura@rosedu.org>
Subject: [PATCH] scsi: remove unused variable
Date: Tue, 17 Apr 2012 16:54:26 +0300
Message-Id: <1334670866-9800-1-git-send-email-laura@rosedu.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Laura Vasilescu <laura@rosedu.org>
---
 drivers/scsi/mvsas/mv_sas.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index fd3b283..3006ec9 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -885,7 +885,6 @@ static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags,
 				struct completion *completion, int is_tmf,
 				struct mvs_tmf_task *tmf)
 {
-	struct domain_device *dev = task->dev;
 	struct mvs_info *mvi = NULL;
 	u32 rc = 0;
 	u32 pass = 0;
-- 
1.7.1

