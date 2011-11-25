Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab1KYKCs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 05:02:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40637 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789Ab1KYKCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 05:02:47 -0500
From: Petr Uzel <petr.uzel@suse.cz>
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com> (maintainer:SCSI
	SUBSYSTEM),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/2] [SCSI] sd: Adapt comment and printk string after renaming sd_init_command to sd_prep_fn
Date: Fri, 25 Nov 2011 11:02:44 +0100
Message-Id: <1322215365-15655-1-git-send-email-petr.uzel@suse.cz>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the comment and string in printk match the code after commit
7f9a6bc4e9d59e7fcf03ed23f60cd81ca5d80b65.

Signed-off-by: Petr Uzel <petr.uzel@suse.cz>
---
 drivers/scsi/sd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fa3a591..c368e88 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -633,7 +633,7 @@ static void sd_unprep_fn(struct request_queue *q, struct request *rq)
 }
 
 /**
- *	sd_init_command - build a scsi (read or write) command from
+ *	sd_prep_fn - build a scsi (read or write) command from
  *	information in the request structure.
  *	@SCpnt: pointer to mid-level's per scsi command structure that
  *	contains request and into which the scsi command is written
@@ -680,7 +680,7 @@ static int sd_prep_fn(struct request_queue *q, struct request *rq)
 	ret = BLKPREP_KILL;
 
 	SCSI_LOG_HLQUEUE(1, scmd_printk(KERN_INFO, SCpnt,
-					"sd_init_command: block=%llu, "
+					"sd_prep_fn: block=%llu, "
 					"count=%d\n",
 					(unsigned long long)block,
 					this_count));
-- 
1.7.7

