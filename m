Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab2BXP47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 10:56:59 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48585 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757160Ab2BXP45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 10:56:57 -0500
From: Petr Uzel <petr.uzel@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com> (maintainer:SCSI
	SUBSYSTEM),
        linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM)
Subject: [PATCH 2/2] [resend] [SCSI] sd: Adapt comment and printk string after renaming sd_attach to sd_probe
Date: Fri, 24 Feb 2012 16:56:55 +0100
Message-Id: <1330099015-26893-2-git-send-email-petr.uzel@suse.cz>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330099015-26893-1-git-send-email-petr.uzel@suse.cz>
References: <1330099015-26893-1-git-send-email-petr.uzel@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the comment and printk string match the code.

Signed-off-by: Petr Uzel <petr.uzel@suse.cz>
Acked-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sd.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7c0d345..8eea785 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2562,8 +2562,8 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
  *	(e.g. /dev/sda). More precisely it is the block device major 
  *	and minor number that is chosen here.
  *
- *	Assume sd_attach is not re-entrant (for time being)
- *	Also think about sd_attach() and sd_remove() running coincidentally.
+ *	Assume sd_probe is not re-entrant (for time being)
+ *	Also think about sd_probe() and sd_remove() running coincidentally.
  **/
 static int sd_probe(struct device *dev)
 {
@@ -2578,7 +2578,7 @@ static int sd_probe(struct device *dev)
 		goto out;
 
 	SCSI_LOG_HLQUEUE(3, sdev_printk(KERN_INFO, sdp,
-					"sd_attach\n"));
+					"sd_probe\n"));
 
 	error = -ENOMEM;
 	sdkp = kzalloc(sizeof(*sdkp), GFP_KERNEL);
-- 
1.7.7

