Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab1EaLpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 07:45:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64102 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab1EaLo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 07:44:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=AECIZwt47Rc5R6gbyJfOAs2ve/hZB98Ud0dMp2/sI3sX+/91JetLYOK8xw29cLkUMg
         apAk+7MBlpJC1rqP2S/KgeB4t6xEtPgubqms0pxn4PejzKEoVPw3ZTiK1pPBvRuvHaWP
         bHzx6neRiF3EG1BON//UOVoWbykeSp52/FBxY=
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] block: remove unwanted semicolons
Date: Tue, 31 May 2011 20:44:53 +0900
Message-Id: <1306842293-17108-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since those defined functions require additional semicolon
from the caller, they could cause potential syntax errors
when used in if-else statements.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 include/linux/blkdev.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index ae9091a68480..1a23722e8878 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1282,8 +1282,8 @@ queue_max_integrity_segments(struct request_queue *q)
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
1.7.5.2

