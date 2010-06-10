Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933Ab0FJLLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:11:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39178 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758887Ab0FJLK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:10:59 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20100610110.764742110@firstfloor.org>
In-Reply-To: <20100610110.764742110@firstfloor.org>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [22/23] BLOCK: Fix unused but set variables in blk-merge
Message-Id: <20100610111058.60EEFB1A2B@basil.firstfloor.org>
Date: Thu, 10 Jun 2010 13:10:58 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Just some dead code.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 block/blk-merge.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6.35-rc2-gcc/block/blk-merge.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/block/blk-merge.c
+++ linux-2.6.35-rc2-gcc/block/blk-merge.c
@@ -12,7 +12,6 @@
 static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 					     struct bio *bio)
 {
-	unsigned int phys_size;
 	struct bio_vec *bv, *bvprv = NULL;
 	int cluster, i, high, highprv = 1;
 	unsigned int seg_size, nr_phys_segs;
@@ -24,7 +23,7 @@ static unsigned int __blk_recalc_rq_segm
 	fbio = bio;
 	cluster = test_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
 	seg_size = 0;
-	phys_size = nr_phys_segs = 0;
+	nr_phys_segs = 0;
 	for_each_bio(bio) {
 		bio_for_each_segment(bv, bio, i) {
 			/*
