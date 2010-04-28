Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab0D1Hhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 03:37:48 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50129 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab0D1Hhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 03:37:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OW8lBWo12dkmChrnA8Re+lVMnNiGiI6Xp8Pxp62/slNLwyW2jwfZ59RisogTszft9T
         MX2fmKWGPi89zxZcF03cnc+RUyQS/q2DzFtp8uTXYE+jubrg+2ehRiD5lB/Mz4FYa5LA
         WilVohF1uhzdKniKs2+DHZtqAoyjrt7QYIIDg=
From: Changli Gao <xiaosuo@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, reiserfs-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] reiserfs: remove unused variable wait
Date: Wed, 28 Apr 2010 15:10:57 +0800
Message-Id: <1272438657-28086-1-git-send-email-xiaosuo@gmail.com>
X-Mailer: git-send-email 1.6.4.4
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
