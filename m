Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab1FKPHf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 11:07:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56733 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758552Ab1FKPHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 11:07:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZyZOu3E1OcAT2pltU1/aVBS9Kq+AYHAp3k+larWUVDwvR/sXqkms+BoKbHETJ9dIv3
         ckzEgXPGXwCFa5OMWqOcIFXQ1H0eYUR4PKKKMyPBPNg/57IaGmM5gzwMOu6An0oQpfEc
         oGI7jCdQQO5tA117SXQ6bzc2oqLHwe0TmMQtc=
From: Wanlong Gao <wanlong.gao@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH] block:remove some spare spaces in genhd.c
Date: Sat, 11 Jun 2011 23:07:07 +0800
Message-Id: <1307804827-5783-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the end-of-line spaces in genhd.c.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 block/genhd.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 95822ae..ed3fe82 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -602,7 +602,7 @@ void add_disk(struct gendisk *disk)
 	disk->major = MAJOR(devt);
 	disk->first_minor = MINOR(devt);
 
-	/* Register BDI before referencing it from bdev */ 
+	/* Register BDI before referencing it from bdev */
 	bdi = &disk->queue->backing_dev_info;
 	bdi_register_dev(bdi, disk_devt(disk));
 
@@ -1148,7 +1148,7 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 				"wsect wuse running use aveq"
 				"\n\n");
 	*/
- 
+
 	disk_part_iter_init(&piter, gp, DISK_PITER_INCL_EMPTY_PART0);
 	while ((hd = disk_part_iter_next(&piter))) {
 		cpu = part_stat_lock();
@@ -1172,7 +1172,7 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 			);
 	}
 	disk_part_iter_exit(&piter);
- 
+
 	return 0;
 }
 
-- 
1.7.4.1

