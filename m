Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609Ab1FKO5q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jun 2011 10:57:46 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47237 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758552Ab1FKO5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jun 2011 10:57:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=knXjPd4w9BrDTNj0ssmF+Jhq+PRXnmOaDLnlHWpLkTCtQ98PyRUnEOpClV9UtB9/SS
         gHzStGYGkj1kIJOhTjfuyX4XAUt2JtHBbwk5mzXKUsHe852/fPrSvohCtlUIRO8PVcl7
         V6SEdpWlO+cQuKoTZpvsFbszxoZEChOqYLMjE=
From: Wanlong Gao <wanlong.gao@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jaxboe@fusionio.com>, Tejun Heo <tj@kernel.org>,
        Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH] block:fix the comment error in blkdev.h
Date: Sat, 11 Jun 2011 22:57:15 +0800
Message-Id: <1307804235-5658-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is not a function rq_init but blk_rq_init in block/blk-core.c.

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 include/linux/blkdev.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1a23722..36f2e2b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -73,7 +73,7 @@ enum rq_cmd_type_bits {
 
 /*
  * try to put the fields that are referenced together in the same cacheline.
- * if you modify this structure, be sure to check block/blk-core.c:rq_init()
+ * if you modify this structure, be sure to check block/blk-core.c:blk_rq_init()
  * as well!
  */
 struct request {
-- 
1.7.4.1

