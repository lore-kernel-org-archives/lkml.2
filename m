Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760870Ab2BNOtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 09:49:42 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:51168
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760781Ab2BNOtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 09:49:39 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, standby24x7@gmail.com
Subject: [PATCH] [trivial] scsi: Fix typo in mv_sas.c
Date: Tue, 14 Feb 2012 23:49:12 +0900
Message-Id: <1329230952-2201-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "internel" to "internal" in
drivers/scsi/mvsas/mv_sas.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/scsi/mvsas/mv_sas.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index a4884a5..1c910c7 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -1411,7 +1411,7 @@ static int mvs_exec_internal_tmf_task(struct domain_device *dev,
 
 		if (res) {
 			del_timer(&task->timer);
-			mv_printk("executing internel task failed:%d\n", res);
+			mv_printk("executing internal task failed:%d\n", res);
 			goto ex_err;
 		}
 
-- 
1.7.6.5

