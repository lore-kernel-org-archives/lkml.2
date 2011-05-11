Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab1EKP6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:58:17 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58316 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756486Ab1EKP6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:58:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Mt9JRuK3QxC4X0FNNLfn8ogQVLjNUKpvEefkculcF0SLR7XEaRQcwbEJoAxVIf5bF7
         8Scly2WLvsgq+1W0oa0oDivCStRoj5LSIWspPSJXb6G46Co3XWQdFASFDTQFf/iIx7Jx
         Od4Hf/3vkR6ZJt1p7LQVrbmW55P/ncXibmio4=
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH] blk-throttle: fix a typo in blk_throtl_init()
Date: Wed, 11 May 2011 22:01:02 +0900
Message-Id: <1305118862-4861-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

s/td/tg/

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 0475a22a420d..e7986b8a0085 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -1072,7 +1072,7 @@ int blk_throtl_init(struct request_queue *q)
 	/* Practically unlimited BW */
 	tg->bps[0] = tg->bps[1] = -1;
 	tg->iops[0] = tg->iops[1] = -1;
-	td->limits_changed = false;
+	tg->limits_changed = false;
 
 	/*
 	 * Set root group reference to 2. One reference will be dropped when
-- 
1.7.5

