Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754443Ab1EAMfc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 08:35:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58187 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab1EAMfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 08:35:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UDS8kBs9WE9tlifHlAsAvXJumReGJ3ef8SZO6WtRRSzlAQglT2qwaKtTjLeXokofcF
         wNLy9GBUthK2VSnlanAHMrLG1YPMIsM+e/FYBfWX02KrtjuZUCTxukB1M+OJe8iv6Bo9
         4mmePrmblETokP6lZSQHaBGi7hIMeTRLiKIew=
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH] block: remove unwanted semicolons
Date: Sun,  1 May 2011 21:35:18 +0900
Message-Id: <1304253318-26909-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since those defined functions require additional semicolon
from the caller, they could cause potential syntax errors
when used in if-else statements.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
---
 include/linux/blkdev.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2ad95fa1d130..5560454534c6 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1271,8 +1271,8 @@ queue_max_integrity_segments(struct request_queue *q)
 #define blk_get_integrity(a)			(0)
 #define blk_integrity_compare(a, b)		(0)
 #define blk_integrity_register(a, b)		(0)
-#define blk_integrity_unregister(a)		do { } while (0);
-#define blk_queue_max_integrity_segments(a, b)	do { } while (0);
+#define blk_integrity_unregister(a)		do { } while (0)
+#define blk_queue_max_integrity_segments(a, b)	do { } while (0)
 #define queue_max_integrity_segments(a)		(0)
 #define blk_integrity_merge_rq(a, b, c)		(0)
 #define blk_integrity_merge_bio(a, b, c)	(0)
-- 
1.7.5

