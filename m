Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752624Ab2AWAtW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 19:49:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47038 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab2AWAtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 19:49:06 -0500
From: Sam Hansen <solid.se7en@gmail.com>
To: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Hansen <solid.se7en@gmail.com>
Subject: [PATCH V2 2/3] xgifb: checkpatch cleanup __func__
Date: Sun, 22 Jan 2012 16:48:52 -0800
Message-Id: <1327279733-3350-3-git-send-email-solid.se7en@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327279733-3350-1-git-send-email-solid.se7en@gmail.com>
References: <1327279733-3350-1-git-send-email-solid.se7en@gmail.com>
In-Reply-To: <originalemailid>
References: <originalemailid>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced an instance of __FUNCTION__ with __func__ in XGI_main_26.c.

Signed-off-by: Sam Hansen <solid.se7en@gmail.com>
---
 drivers/staging/xgifb/XGI_main_26.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index dd97b73..a743e1b 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -55,7 +55,7 @@ static unsigned int refresh_rate;
 #undef XGIFBDEBUG
 
 #ifdef XGIFBDEBUG
-#define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s: " fmt, __FUNCTION__ , ## args)
+#define DPRINTK(fmt, args...) printk(KERN_DEBUG "%s: " fmt, __func__ , ## args)
 #else
 #define DPRINTK(fmt, args...)
 #endif
-- 
1.7.5.4

