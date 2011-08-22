Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab1HVOox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:44:53 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:40940 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab1HVOou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:44:50 -0400
From: Wanlong Gao <wanlong.gao@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH] drivers:char:remove the spare spaces and tabs
Date: Mon, 22 Aug 2011 22:42:40 +0800
Message-Id: <1314024160-6940-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <gaowanlong@cn.fujitsu.com>

Style fix: remove the spare spaces and tabs in misc.c.

Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 drivers/char/misc.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/char/misc.c b/drivers/char/misc.c
index 778273c..93e1d1c3 100644
--- a/drivers/char/misc.c
+++ b/drivers/char/misc.c
@@ -117,14 +117,14 @@ static int misc_open(struct inode * inode, struct file * file)
 	const struct file_operations *old_fops, *new_fops = NULL;
 
 	mutex_lock(&misc_mtx);
-	
+
 	list_for_each_entry(c, &misc_list, list) {
 		if (c->minor == minor) {
-			new_fops = fops_get(c->fops);		
+			new_fops = fops_get(c->fops);
 			break;
 		}
 	}
-		
+
 	if (!new_fops) {
 		mutex_unlock(&misc_mtx);
 		request_module("char-major-%d-%d", MISC_MAJOR, minor);
@@ -168,7 +168,7 @@ static const struct file_operations misc_fops = {
 /**
  *	misc_register	-	register a miscellaneous device
  *	@misc: device structure
- *	
+ *
  *	Register a miscellaneous device with the kernel. If the minor
  *	number is set to %MISC_DYNAMIC_MINOR a minor number is assigned
  *	and placed in the minor field of the structure. For other cases
@@ -180,7 +180,7 @@ static const struct file_operations misc_fops = {
  *	A zero is returned on success and a negative errno code for
  *	failure.
  */
- 
+
 int misc_register(struct miscdevice * misc)
 {
 	struct miscdevice *c;
-- 
1.7.4.1

