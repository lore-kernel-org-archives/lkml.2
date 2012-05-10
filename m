Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099Ab2EJQaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 12:30:24 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:58040 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab2EJQaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 12:30:21 -0400
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: grabner@icg.tugraz.at, andor.daam@googlemail.com, thomas@m3y3r.de,
        jj@chaosbits.net, stefanha@gmail.com,
        Johannes Thumshirn <morbidrsa@googlemail.com>
Subject: [PATCH] drivers/staging/line6/config.h: Remove CHECKPOINT macro
Date: Thu, 10 May 2012 18:30:10 +0200
Message-Id: <1336667410-10035-1-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336415273-11713-1-git-send-email-morbidrsa@googlemail.com>
References: <1336415273-11713-1-git-send-email-morbidrsa@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kill unused debugging macro CHECKPOINT
---
 drivers/staging/line6/config.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/line6/config.h b/drivers/staging/line6/config.h
index f8a5149..2493491 100644
--- a/drivers/staging/line6/config.h
+++ b/drivers/staging/line6/config.h
@@ -34,11 +34,6 @@
 #define CREATE_RAW_FILE      0
 
 #if DO_DEBUG_MESSAGES
-#define CHECKPOINT printk(KERN_INFO "line6usb: %s (%s:%d)\n", \
-			  __func__, __FILE__, __LINE__)
-#endif
-
-#if DO_DEBUG_MESSAGES
 #define DEBUG_MESSAGES(x) (x)
 #else
 #define DEBUG_MESSAGES(x)
-- 
1.7.7.6

