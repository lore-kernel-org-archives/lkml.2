Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030517Ab2K3RJ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:09:58 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54231 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758514Ab2K3RJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:09:50 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 25/32] staging: wlags49_h2: wl_priv: fixes incorrect #include
Date: Fri, 30 Nov 2012 18:58:50 +0200
Message-Id: <1354294737-5735-25-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
References: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit forces the file to use <linux/uaccess.h> instead of
<asm/uaccess.h>. Everything still compiles a-OK.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/wl_priv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wlags49_h2/wl_priv.c b/drivers/staging/wlags49_h2/wl_priv.c
index 23403e9..e2615a1 100644
--- a/drivers/staging/wlags49_h2/wl_priv.c
+++ b/drivers/staging/wlags49_h2/wl_priv.c
@@ -67,7 +67,7 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 
 #include <debug.h>
 #include <hcf.h>
-- 
1.7.10.4

