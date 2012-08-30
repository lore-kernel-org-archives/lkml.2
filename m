Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab2H3Qb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 12:31:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57727 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab2H3Qb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 12:31:58 -0400
From: anish kumar <anish198519851985@gmail.com>
To: cw00.choi@samsung.com, myungjoo.ham@samsung.com
Cc: linux-kernel@vger.kernel.org, anish kumar <anish198519851985@gmail.com>
Subject: [PATCH] extcon: checkpatch warning removal
Date: Thu, 30 Aug 2012 22:01:36 +0530
Message-Id: <1346344296-14693-1-git-send-email-anish198519851985@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: anish kumar <anish198519851985@gmail.com>

without this patch we get below warning:
WARNING: externs should be avoided in .c files
132: FILE: extcon/extcon-class.c:
int extcon_set_state(struct extcon_dev *edev, u32 state);

So just removed the declaration.

Signed-off-by: anish kumar <anish198519851985@gmail.com>
---
 drivers/extcon/extcon-class.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-class.c
index 06df95a..6f3391b 100644
--- a/drivers/extcon/extcon-class.c
+++ b/drivers/extcon/extcon-class.c
@@ -129,7 +129,6 @@ static ssize_t state_show(struct device *dev, struct device_attribute *attr,
 	return count;
 }
 
-int extcon_set_state(struct extcon_dev *edev, u32 state);
 static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 			   const char *buf, size_t count)
 {
-- 
1.7.1

