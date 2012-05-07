Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343Ab2EGS2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 14:28:08 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64660 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab2EGS2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 14:28:05 -0400
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: grabner@icg.tugraz.at, andor.daam@googlemail.com, thomas@m3y3r.de,
        jj@chaosbits.net, stefanha@gmail.com,
        Johannes Thumshirn <morbidrsa@googlemail.com>
Subject: [PATCH 36/36] drivers/staging/line6/config.h: Delete CHECKPOINT macro
Date: Mon,  7 May 2012 20:27:53 +0200
Message-Id: <1336415273-11713-1-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kill unused debugging macro CHECKPOINT

Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
---
 drivers/staging/line6/config.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/line6/config.h b/drivers/staging/line6/config.h
index a82d8bf..2493491 100644
--- a/drivers/staging/line6/config.h
+++ b/drivers/staging/line6/config.h
@@ -34,11 +34,6 @@
 #define CREATE_RAW_FILE      0
 
 #if DO_DEBUG_MESSAGES
-#define CHECKPOINT pr_info("line6usb: %s (%s:%d)\n", \
-			  __func__, __FILE__, __LINE__)
-#endif
-
-#if DO_DEBUG_MESSAGES
 #define DEBUG_MESSAGES(x) (x)
 #else
 #define DEBUG_MESSAGES(x)
-- 
1.7.7.6

