Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953Ab2AUKNH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 05:13:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44213 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757051Ab2AUKKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 05:10:21 -0500
From: Sam Hansen <solid.se7en@gmail.com>
To: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Hansen <solid.se7en@gmail.com>
Subject: [PATCH 2/3] xgifb: checkpatch cleanup __func__
Date: Sat, 21 Jan 2012 02:10:11 -0800
Message-Id: <1327140612-9694-2-git-send-email-solid.se7en@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1327140612-9694-1-git-send-email-solid.se7en@gmail.com>
References: <1327140612-9694-1-git-send-email-solid.se7en@gmail.com>
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

