Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab2BQXhp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 18:37:45 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42705 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab2BQXho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 18:37:44 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jorgyano@gmail.com designates 10.236.197.33 as permitted sender) smtp.mail=jorgyano@gmail.com; dkim=pass header.i=jorgyano@gmail.com
From: Jorgyano Vieira <jorgyano@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        nsankar@broadcom.com, jarod@wilsonet.com,
        Jorgyano Vieira <jorgyano@gmail.com>
Subject: [PATCH 1/3] Staging: crystalhd: crystalhd_misc: Get rid of unused macro
Date: Fri, 17 Feb 2012 21:35:53 -0200
Message-Id: <1329521753-1184-1-git-send-email-jorgyano@gmail.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BCMLOG_LEAVE macro is not used, so there is no reason to keep it.

Signed-off-by: Jorgyano Vieira <jorgyano@gmail.com>
---
 drivers/staging/crystalhd/crystalhd_misc.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/crystalhd/crystalhd_misc.h b/drivers/staging/crystalhd/crystalhd_misc.h
index e0aa361..eedd9b7 100644
--- a/drivers/staging/crystalhd/crystalhd_misc.h
+++ b/drivers/staging/crystalhd/crystalhd_misc.h
@@ -209,11 +209,6 @@ do {								\
 		printk(KERN_DEBUG "Entered %s\n", __func__);	\
 } while (0)
 
-#define BCMLOG_LEAVE						\
-do {								\
-	if (g_linklog_level & BCMLOG_ENTER_LEAVE)		\
-		printk(KERN_DEBUG "Leaving %s\n", __func__);	\
-} while (0)							\
 
 #define BCMLOG(trace, fmt, args...)	\
 do {					\
-- 
1.7.2.5

