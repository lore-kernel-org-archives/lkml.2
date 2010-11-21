Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab0KUTqc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 14:46:32 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53578 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab0KUTqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 14:46:31 -0500
From: Gary Coulbourne <bear@bears.org>
To: miknix@gmail.com
Cc: linux-kernel@vger.kernel.org, Gary Coulbourne <bear@bears.org>
Subject: [PATCH] Staging: quickstart style fixes
Date: Sun, 21 Nov 2010 14:46:21 -0500
Message-Id: <1290368781-20671-1-git-send-email-bear@bears.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some style issues reported by checkpatch.pl

Signed-off-by: Gary Coulbourne <bear@bears.org>
---
 drivers/staging/quickstart/quickstart.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/quickstart/quickstart.c b/drivers/staging/quickstart/quickstart.c
index d83bec8..e6b53b8 100644
--- a/drivers/staging/quickstart/quickstart.c
+++ b/drivers/staging/quickstart/quickstart.c
@@ -5,7 +5,7 @@
  *  Copyright (C) 2007-2010 Angelo Arrifano <miknix@gmail.com>
  *
  *  Information gathered from disassebled dsdt and from here:
- *  <http://www.microsoft.com/whdc/system/platform/firmware/DirAppLaunch.mspx> 
+ *  <http://www.microsoft.com/whdc/system/platform/firmware/DirAppLaunch.mspx>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -140,8 +140,12 @@ static ssize_t pressed_button_show(struct device *dev,
 					struct device_attribute *attr,
 					char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%s\n",
-		(quickstart_data.pressed?quickstart_data.pressed->name:"none"));
+	char *button_name = "none";
+
+	if (quickstart_data.pressed)
+		button_name = quickstart_data.pressed->name;
+
+	return snprintf(buf, PAGE_SIZE, "%s\n", button_name);
 }
 
 
-- 
1.7.1

