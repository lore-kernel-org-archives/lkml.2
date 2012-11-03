Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613Ab2KCWDN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 18:03:13 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35255 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757025Ab2KCWC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 18:02:58 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org
Subject: [PATCH 8/9] isdn: Remove unused variable causing a compile build warning
Date: Sat,  3 Nov 2012 23:02:29 +0100
Message-Id: <1351980150-24145-9-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351980150-24145-1-git-send-email-lee.jones@linaro.org>
References: <1351980150-24145-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes:
drivers/isdn/i4l/isdn_common.c: In function ‘isdn_ioctl’:
drivers/isdn/i4l/isdn_common.c:1278:8: warning: unused variable ‘s’ [-Wunused-variable]

Cc: Karsten Keil <isdn@linux-pingi.de>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/isdn/i4l/isdn_common.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/isdn/i4l/isdn_common.c b/drivers/isdn/i4l/isdn_common.c
index 8c610fa..fb90d40 100644
--- a/drivers/isdn/i4l/isdn_common.c
+++ b/drivers/isdn/i4l/isdn_common.c
@@ -1275,7 +1275,6 @@ isdn_ioctl(struct file *file, uint cmd, ulong arg)
 	int ret;
 	int i;
 	char __user *p;
-	char *s;
 	union iocpar {
 		char name[10];
 		char bname[22];
-- 
1.7.9.5

