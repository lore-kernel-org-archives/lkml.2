Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab2DQKNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 06:13:15 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:62877 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab2DQKNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 06:13:13 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>
Subject: [PATCH] core.c: fix 'the the' typo
Date: Tue, 17 Apr 2012 12:12:57 +0200
Message-Id: <1334657577-16852-1-git-send-email-jacmet@sunsite.dk>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
---
 drivers/base/core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index e28ce98..6cb25f1 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -878,8 +878,8 @@ EXPORT_SYMBOL_GPL(dev_set_name);
  * to NULL prevents an entry from being created.  class->dev_kobj must
  * be set (or cleared) before any devices are registered to the class
  * otherwise device_create_sys_dev_entry() and
- * device_remove_sys_dev_entry() will disagree about the the presence
- * of the link.
+ * device_remove_sys_dev_entry() will disagree about the presence of
+ * the link.
  */
 static struct kobject *device_to_dev_kobj(struct device *dev)
 {
-- 
1.7.8.3

