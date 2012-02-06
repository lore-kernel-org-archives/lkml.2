Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab2BFCBY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 21:01:24 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50858 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab2BFCBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 21:01:23 -0500
From: Kashyap Gada <gada.kashyap@gmail.com>
To: marek.belisko@gmail.com
Cc: gregkh@linuxfoundation.com, linux@rainbow-software.org,
        paul.gortmaker@windriver.com, gada.kashyap@gmail.com, jeffm@suse.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Kashyap Gada <kashyap.gada@linux-82zy.site>
Subject: [PATCH] Staging: ft1000: ft1000-pcmia: fix space required after that ',' in ft1000_proc.c
Date: Mon,  6 Feb 2012 02:01:16 +0000
Message-Id: <1328493676-2477-1-git-send-email-kashyap.gada@linux-82zy.site>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ft1000_proc.c that fixes up space required after ',' errors found by the checkpatch.pl tool

Signed-off-by: Kashyap Gada <gada.kashyap@gmail.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
index 7faeada..71aaad3 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
@@ -29,10 +29,10 @@
 #define FT1000_PROC "ft1000"
 #define MAX_FILE_LEN 255
 
-#define PUTM_TO_PAGE(len,page,args...) \
+#define PUTM_TO_PAGE(len, page, args...) \
 	len += snprintf(page+len, PAGE_SIZE - len, args)
 
-#define PUTX_TO_PAGE(len,page,message,size,var) \
+#define PUTX_TO_PAGE(len, page, message, size, var) \
 	len += snprintf(page+len, PAGE_SIZE - len, message); \
 	for(i = 0; i < (size - 1); i++) \
 	{ \
@@ -40,7 +40,7 @@
 	 \
 	len += snprintf(page+len, PAGE_SIZE - len, "%02x\n", var[i])
 
-#define PUTD_TO_PAGE(len,page,message,size,var) \
+#define PUTD_TO_PAGE(len, page, message, size, var) \
 	len += snprintf(page+len, PAGE_SIZE - len, message); \
 	for(i = 0; i < (size - 1); i++) \
 	{ \
-- 
1.7.7

