Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab3AIIlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 03:41:13 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:57258 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190Ab3AIIlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 03:41:12 -0500
From: Patrik Karlin <patrik.karlin@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Patrik Karlin <patrik.karlin@gmail.com>
Subject: =?UTF-8?q?=5BPATCH=203/3=5D=20staging=3A=20rtl8192u=3A=20fixed=20coding=20style=20issues=20in=20r8192U=5Fcore=2Ec?=
Date: Wed,  9 Jan 2013 09:40:56 +0100
Message-Id: <1357720856-4308-1-git-send-email-patrik.karlin@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <n>
References: <n>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes some coding style issuses in r8192U_core.c
No logic is changed

Signed-off-by: Patrik Kårlin <patrik.karlin@gmail.com>
---
 drivers/staging/rtl8192u/r8192U_core.c |   35 ++++++++++++++------------------
 1 file changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 193822e..8f82163 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -510,55 +510,50 @@ static int proc_get_registers(char *page, char **start,
 	int max=0xff;
 
 	/* This dump the current register page */
-len += snprintf(page + len, count - len,
+	len += snprintf(page + len, count - len,
 			"\n####################page 0##################\n ");
 
-	for(n=0;n<=max;)
-	{
+	for (n=0;n<=max;) {
 		//printk( "\nD: %2x> ", n);
 		len += snprintf(page + len, count - len,
 			"\nD:  %2x > ",n);
 
-		for(i=0;i<16 && n<=max;i++,n++)
-		len += snprintf(page + len, count - len,
-			"%2x ",read_nic_byte(dev,0x000|n));
+		for (i=0;i<16 && n<=max;i++,n++)
+			len += snprintf(page + len, count - len,
+					"%2x ",read_nic_byte(dev,0x000|n));
 
 		//	printk("%2x ",read_nic_byte(dev,n));
 	}
-len += snprintf(page + len, count - len,
+	len += snprintf(page + len, count - len,
 			"\n####################page 1##################\n ");
-	for(n=0;n<=max;)
-	{
+	for (n=0;n<=max;) {
 		//printk( "\nD: %2x> ", n);
 		len += snprintf(page + len, count - len,
-			"\nD:  %2x > ",n);
+				"\nD:  %2x > ",n);
 
-		for(i=0;i<16 && n<=max;i++,n++)
-		len += snprintf(page + len, count - len,
-			"%2x ",read_nic_byte(dev,0x100|n));
+		for (i=0;i<16 && n<=max;i++,n++)
+			len += snprintf(page + len, count - len,
+					"%2x ",read_nic_byte(dev,0x100|n));
 
 		//      printk("%2x ",read_nic_byte(dev,n));
 	}
-len += snprintf(page + len, count - len,
+	len += snprintf(page + len, count - len,
 			"\n####################page 3##################\n ");
-	for(n=0;n<=max;)
-	{
+	for (n=0;n<=max;) {
 		//printk( "\nD: %2x> ", n);
 		len += snprintf(page + len, count - len,
 			"\nD:  %2x > ",n);
 
 		for(i=0;i<16 && n<=max;i++,n++)
-		len += snprintf(page + len, count - len,
-			"%2x ",read_nic_byte(dev,0x300|n));
+			len += snprintf(page + len, count - len,
+					"%2x ",read_nic_byte(dev,0x300|n));
 
 		//      printk("%2x ",read_nic_byte(dev,n));
 	}
 
-
 	len += snprintf(page + len, count - len,"\n");
 	*eof = 1;
 	return len;
-
 }
 
 
-- 
1.7.10.4

