Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab2LYOEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 09:04:01 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:43611 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab2LYOD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 09:03:58 -0500
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Dec 2012 09:03:57 EST
From: Cong Ding <dinggnu@gmail.com>
To: Nadia Yvette Chambers <nyc@holomorphy.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] kernel/wait.c: fix 80 characters issue
Date: Tue, 25 Dec 2012 14:58:14 +0100
Message-Id: <1356443898-28635-1-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix 80 characters issue

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 kernel/wait.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/wait.c b/kernel/wait.c
index 6698e0c..a80a9e4 100644
--- a/kernel/wait.c
+++ b/kernel/wait.c
@@ -10,7 +10,8 @@
 #include <linux/wait.h>
 #include <linux/hash.h>
 
-void __init_waitqueue_head(wait_queue_head_t *q, const char *name, struct lock_class_key *key)
+void __init_waitqueue_head(wait_queue_head_t *q, const char *name,
+		struct lock_class_key *key)
 {
 	spin_lock_init(&q->lock);
 	lockdep_set_class_and_name(&q->lock, key, name);
@@ -160,7 +161,8 @@ void abort_exclusive_wait(wait_queue_head_t *q, wait_queue_t *wait,
 }
 EXPORT_SYMBOL(abort_exclusive_wait);
 
-int autoremove_wake_function(wait_queue_t *wait, unsigned mode, int sync, void *key)
+int autoremove_wake_function(wait_queue_t *wait, unsigned mode, int sync,
+		void *key)
 {
 	int ret = default_wake_function(wait, mode, sync, key);
 
-- 
1.7.10.4

