Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755726Ab1BHTll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 14:41:41 -0500
Received: from miraculix-out.informatik.uni-kiel.de ([134.245.248.209]:59692
	"EHLO miraculix.informatik.uni-kiel.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755237Ab1BHTlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 14:41:40 -0500
From: Timo von Holtz <tvh@informatik.uni-kiel.de>
To: gregkh@suse.de
Cc: error27@gmail.com, hjk@linutronix.de, jkosina@suse.cz,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Timo von Holtz <tvh@informatik.uni-kiel.de>
Subject: [PATCH] Staging: quickstart: fixed coding style issues
Date: Tue,  8 Feb 2011 20:41:19 +0100
Message-Id: <1297194079-4336-1-git-send-email-tvh@informatik.uni-kiel.de>
X-Mailer: git-send-email 1.7.4
X-Null-Tag: a9c3fde13fa093d9f1e2af689d4b1059
X-Authenticated-Sender: user tvh from 86.103.149.108
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the Following coding Style Issues:
drivers/staging/quickstart/quickstart.c:8: ERROR: trailing whitespace
drivers/staging/quickstart/quickstart.c:144: ERROR: spaces required around that '?' (ctx:VxV)
drivers/staging/quickstart/quickstart.c:144: ERROR: spaces required around that ':' (ctx:VxV)

Signed-off-by: Timo von Holtz <tvh@informatik.uni-kiel.de>
---
 drivers/staging/quickstart/quickstart.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/quickstart/quickstart.c b/drivers/staging/quickstart/quickstart.c
index d83bec8..c60911c 100644
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
@@ -141,7 +141,8 @@ static ssize_t pressed_button_show(struct device *dev,
 					char *buf)
 {
 	return snprintf(buf, PAGE_SIZE, "%s\n",
-		(quickstart_data.pressed?quickstart_data.pressed->name:"none"));
+			(quickstart_data.pressed ?
+			 quickstart_data.pressed->name : "none"));
 }
 
 
-- 
1.7.4

