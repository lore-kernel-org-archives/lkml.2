Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab2GUHUr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 03:20:47 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:47369 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab2GUHUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 03:20:46 -0400
From: Devendra Naga <develkernel412222@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Mikko=20Virkkil=C3=A4?= <mikko.virkkila@bluegiga.com>,
        Lauri Hintsala <Lauri.Hintsala@bluegiga.com>,
        =?UTF-8?q?Riku=20Mett=C3=A4l=C3=A4?= <riku.mettala@bluegiga.com>,
        Veli-Pekka Peltola <veli-pekka.peltola@bluegiga.com>,
        Devendra Naga <develkernel412222@gmail.com>
Subject: [PATCH 1/3] staging/csr: coding style fixes in CsrTimeGet
Date: Sat, 21 Jul 2012 13:05:32 +0545
Message-Id: <1342855232-2779-1-git-send-email-develkernel412222@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the following warnings were fixed:
1. removed all spaces before the start of a line and used tabs
2. removed the braces around the if as it encloses only a single statement

Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
---
 drivers/staging/csr/csr_time.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/csr/csr_time.c b/drivers/staging/csr/csr_time.c
index 83586ca..2043f25 100644
--- a/drivers/staging/csr/csr_time.c
+++ b/drivers/staging/csr/csr_time.c
@@ -24,20 +24,18 @@
 
 CsrTime CsrTimeGet(CsrTime *high)
 {
-    struct timespec ts;
-    u64 time;
-    CsrTime low;
+	struct timespec ts;
+	u64 time;
+	CsrTime low;
 
-    ts = current_kernel_time();
-    time = (u64) ts.tv_sec * 1000000 + ts.tv_nsec / 1000;
+	ts = current_kernel_time();
+	time = (u64) ts.tv_sec * 1000000 + ts.tv_nsec / 1000;
 
-    if (high != NULL)
-    {
-        *high = (CsrTime) ((time >> 32) & 0xFFFFFFFF);
-    }
+	if (high != NULL)
+		*high = (CsrTime) ((time >> 32) & 0xFFFFFFFF);
 
-    low = (CsrTime) (time & 0xFFFFFFFF);
+	low = (CsrTime) (time & 0xFFFFFFFF);
 
-    return low;
+	return low;
 }
 EXPORT_SYMBOL_GPL(CsrTimeGet);
-- 
1.7.9.5

