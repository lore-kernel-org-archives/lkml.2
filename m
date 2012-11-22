Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab2KVStZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:49:25 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38223 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234Ab2KVStW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:49:22 -0500
From: Yan Hong <clouds.yan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] writeback: fix a typo in comment
Date: Thu, 22 Nov 2012 19:55:00 +0800
Message-Id: <1353585300-4455-1-git-send-email-clouds.yan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---
 fs/fs-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 51ea267..e9e619a 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1032,7 +1032,7 @@ int bdi_writeback_thread(void *data)
 	while (!kthread_freezable_should_stop(NULL)) {
 		/*
 		 * Remove own delayed wake-up timer, since we are already awake
-		 * and we'll take care of the preriodic write-back.
+		 * and we'll take care of the periodic write-back.
 		 */
 		del_timer(&wb->wakeup_timer);
 
-- 
1.7.9.5

