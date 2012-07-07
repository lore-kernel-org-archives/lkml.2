Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab2GGMGc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 08:06:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51955 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab2GGMF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 08:05:58 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 7/8] staging/ft1000-pcmcia: fix checkpatch warnings
Date: Sat,  7 Jul 2012 17:35:18 +0530
Message-Id: <1341662719-25752-7-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341662719-25752-1-git-send-email-devendra.aaru@gmail.com>
References: <1341662719-25752-1-git-send-email-devendra.aaru@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below checkpatch warns fixed,

drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c:38: ERROR: that open brace { should be on the previous line
drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c:45: ERROR: that open brace { should be on the previous line
drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c:57: ERROR: that open brace { should be on the previous line

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
index 71aaad3..72727c6 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
@@ -34,16 +34,14 @@
 
 #define PUTX_TO_PAGE(len, page, message, size, var) \
 	len += snprintf(page+len, PAGE_SIZE - len, message); \
-	for(i = 0; i < (size - 1); i++) \
-	{ \
+	for(i = 0; i < (size - 1); i++) { \
 		len += snprintf(page+len, PAGE_SIZE - len, "%02x:", var[i]); \
 	} \
 	len += snprintf(page+len, PAGE_SIZE - len, "%02x\n", var[i])
 
 #define PUTD_TO_PAGE(len, page, message, size, var) \
 	len += snprintf(page+len, PAGE_SIZE - len, message); \
-	for(i = 0; i < (size - 1); i++) \
-	{ \
+	for(i = 0; i < (size - 1); i++) { \
 		len += snprintf(page+len, PAGE_SIZE - len, "%d.", var[i]); \
 	} \
 	len += snprintf(page+len, PAGE_SIZE - len, "%d\n", var[i])
@@ -55,8 +53,8 @@ static int ft1000ReadProc(char *page, char **start, off_t off,
 	int len;
 	int i;
 	struct ft1000_info *info;
-	char *status[] =
-		{ "Idle (Disconnect)", "Searching", "Active (Connected)",
+	char *status[] = {
+		"Idle (Disconnect)", "Searching", "Active (Connected)",
 		"Waiting for L2", "Sleep", "No Coverage", "", ""
 	};
 	char *signal[] = { "", "*", "**", "***", "****" };
-- 
1.7.9.5

