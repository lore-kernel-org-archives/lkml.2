Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752829Ab0GMH3P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 03:29:15 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:45949 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab0GMH3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 03:29:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=eVEpBnr0nJPdZf0U2PtbG2PCGqpge38x3dYK9o6mjgOtndB2k4hb2s1YwWxQKRu9vc
         sRlIy2V0IExXRKzuFLr/tyuJxKocL6nGKpSt2mh0R/NOpB4XC1AHZ22LN4krjExVsZE3
         j4f/X7GZ5LnOhMsvyBkaSOM4yqpmHzrxRqApU=
From: Changli Gao <xiaosuo@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jens.axboe@oracle.com>, reiserfs-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH, resend] reiserfs: remove unused variable wait
Date: Tue, 13 Jul 2010 15:26:30 +0800
Message-Id: <1279005990-11185-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove unused variable wait

remove unused variable wait

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
----
 fs/reiserfs/journal.c |    1 -
 1 file changed, 1 deletion(-)
diff --git a/fs/reiserfs/journal.c b/fs/reiserfs/journal.c
index 19fbc81..1ec952b 100644
--- a/fs/reiserfs/journal.c
+++ b/fs/reiserfs/journal.c
@@ -983,7 +983,6 @@ static int flush_older_commits(struct super_block *s,
 
 static int reiserfs_async_progress_wait(struct super_block *s)
 {
-	DEFINE_WAIT(wait);
 	struct reiserfs_journal *j = SB_JOURNAL(s);
 
 	if (atomic_read(&j->j_async_throttle)) {
