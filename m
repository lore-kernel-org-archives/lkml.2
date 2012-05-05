Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab2EEOdL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 10:33:11 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59792 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab2EEOca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 10:32:30 -0400
From: Johannes Thumshirn <morbidrsa@googlemail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: grabner@icg.tugraz.at, andor.daam@googlemail.com, thomas@m3y3r.de,
        jj@chaosbits.net, stefanha@gmail.com,
        Johannes Thumshirn <morbidrsa@googlemail.com>
Subject: [PATCH 5/8] drivers/staging/line6/driver.h: Changed printk(KERN_ERR, .. to pr_err Changed printk(KERN_ERR, ...) call to pr_err() call in MISSING_CASE macro
Date: Sat,  5 May 2012 16:31:49 +0200
Message-Id: <1336228312-5379-6-git-send-email-morbidrsa@googlemail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1336228312-5379-1-git-send-email-morbidrsa@googlemail.com>
References: <1336228312-5379-1-git-send-email-morbidrsa@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Johannes Thumshirn <morbidrsa@googlemail.com>
---
 drivers/staging/line6/driver.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/line6/driver.h b/drivers/staging/line6/driver.h
index 117bf99..ea97b32 100644
--- a/drivers/staging/line6/driver.h
+++ b/drivers/staging/line6/driver.h
@@ -60,7 +60,7 @@
 #endif
 
 #define MISSING_CASE	\
-	printk(KERN_ERR "line6usb driver bug: missing case in %s:%d\n", \
+	pr_err("line6usb driver bug: missing case in %s:%d\n", \
 		__FILE__, __LINE__)
 
 #define CHECK_RETURN(x)		\
-- 
1.7.7.6

