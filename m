Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab2JRB5j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 21:57:39 -0400
Received: from noserose.net ([66.220.18.76]:33139 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753243Ab2JRB5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 21:57:38 -0400
Date: Wed, 17 Oct 2012 18:57:31 -0700
Message-Id: <c62271a5f3868451b7cde9fb91b380671cc2a3b8.1350524227.git.ecashin@coraid.com>
In-Reply-To: <cover.1350524227.git.ecashin@coraid.com>
References: <cover.1350524227.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 8/9] aoe: whitespace cleanup
To: akpm@linux-foundation.org
Cc: ecashin@coraid.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h     |    2 +-
 drivers/block/aoe/aoechr.c  |    2 +-
 drivers/block/aoe/aoecmd.c  |    6 +++---
 drivers/block/aoe/aoemain.c |    2 +-
 drivers/block/aoe/aoenet.c  |    4 ++--
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index 52f75c0..8e8da1c 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -151,7 +151,7 @@ struct aoedev {
 	struct work_struct work;/* disk create work struct */
 	struct gendisk *gd;
 	struct request_queue *blkq;
-	struct hd_geometry geo; 
+	struct hd_geometry geo;
 	sector_t ssize;
 	struct timer_list timer;
 	spinlock_t lock;
diff --git a/drivers/block/aoe/aoechr.c b/drivers/block/aoe/aoechr.c
index 2bf6273..42e67ad 100644
--- a/drivers/block/aoe/aoechr.c
+++ b/drivers/block/aoe/aoechr.c
@@ -287,7 +287,7 @@ aoechr_init(void)
 	int n, i;
 
 	n = register_chrdev(AOE_MAJOR, "aoechr", &aoe_fops);
-	if (n < 0) { 
+	if (n < 0) {
 		printk(KERN_ERR "aoe: can't register char device\n");
 		return n;
 	}
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 82e16c4..c491fba 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -978,7 +978,7 @@ ktiocomplete(struct frame *f)
 		pr_err("aoe: ata error cmd=%2.2Xh stat=%2.2Xh from e%ld.%d\n",
 			ahout->cmdstat, ahin->cmdstat,
 			d->aoemajor, d->aoeminor);
-noskb:	if (buf)
+noskb:		if (buf)
 			clear_bit(BIO_UPTODATE, &buf->bio->bi_flags);
 		goto badrsp;
 	}
@@ -1191,7 +1191,7 @@ aoecmd_cfg(ushort aoemajor, unsigned char aoeminor)
 	aoecmd_cfg_pkts(aoemajor, aoeminor, &queue);
 	aoenet_xmit(&queue);
 }
- 
+
 struct sk_buff *
 aoecmd_ata_id(struct aoedev *d)
 {
@@ -1230,7 +1230,7 @@ aoecmd_ata_id(struct aoedev *d)
 
 	return skb_clone(skb, GFP_ATOMIC);
 }
- 
+
 static struct aoetgt *
 addtgt(struct aoedev *d, char *addr, ulong nframes)
 {
diff --git a/drivers/block/aoe/aoemain.c b/drivers/block/aoe/aoemain.c
index 04793c2..4b987c2 100644
--- a/drivers/block/aoe/aoemain.c
+++ b/drivers/block/aoe/aoemain.c
@@ -105,7 +105,7 @@ aoe_init(void)
 	aoechr_exit();
  chr_fail:
 	aoedev_exit();
-	
+
 	printk(KERN_INFO "aoe: initialisation failure.\n");
 	return ret;
 }
diff --git a/drivers/block/aoe/aoenet.c b/drivers/block/aoe/aoenet.c
index 3cf068b..ae56828 100644
--- a/drivers/block/aoe/aoenet.c
+++ b/drivers/block/aoe/aoenet.c
@@ -122,8 +122,8 @@ aoenet_xmit(struct sk_buff_head *queue)
 	}
 }
 
-/* 
- * (1) len doesn't include the header by default.  I want this. 
+/*
+ * (1) len doesn't include the header by default.  I want this.
  */
 static int
 aoenet_rcv(struct sk_buff *skb, struct net_device *ifp, struct packet_type *pt, struct net_device *orig_dev)
-- 
1.7.1

