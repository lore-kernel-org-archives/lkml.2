Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab2EEOdK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 10:33:10 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33050 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab2EEOc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 10:32:29 -0400
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: grabner@icg.tugraz.at, andor.daam@googlemail.com, thomas@m3y3r.de,
        jj@chaosbits.net, stefanha@gmail.com,
        Johannes Thumshirn <morbidrsa@googlemail.com>
Subject: [PATCH 4/8] drivers/staging/line6/config.h: changed printk(KERN_INFO, ... to pr_info(
Date: Sat,  5 May 2012 16:31:48 +0200
Message-Id: <1336228312-5379-5-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336228312-5379-1-git-send-email-morbidrsa@googlemail.com>
References: <1336228312-5379-1-git-send-email-morbidrsa@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changed printk(KERN_INFO, ...) call to pr_info call in CHECKPOINT macro

Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
---
 drivers/staging/line6/config.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/line6/config.h b/drivers/staging/line6/config.h
index f8a5149..a82d8bf 100644
--- a/drivers/staging/line6/config.h
+++ b/drivers/staging/line6/config.h
@@ -34,7 +34,7 @@
 #define CREATE_RAW_FILE      0
 
 #if DO_DEBUG_MESSAGES
-#define CHECKPOINT printk(KERN_INFO "line6usb: %s (%s:%d)\n", \
+#define CHECKPOINT pr_info("line6usb: %s (%s:%d)\n", \
 			  __func__, __FILE__, __LINE__)
 #endif
 
-- 
1.7.7.6

