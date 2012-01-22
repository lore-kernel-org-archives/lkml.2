Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751268Ab2AVIsc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 03:48:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57719 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab2AVIsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 03:48:31 -0500
From: Sam Hansen <solid.se7en@gmail.com>
To: Arnaud Patard <arnaud.patard@rtp-net.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Sam Hansen <solid.se7en@gmail.com>
Subject: [PATCH] xgifb: pr_fmt kbuild macro
Date: Sun, 22 Jan 2012 00:48:25 -0800
Message-Id: <1327222105-3495-1-git-send-email-solid.se7en@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added the kbuild macro pr_fmt() to XGI_main_26.c

Signed-off-by: Sam Hansen <solid.se7en@gmail.com>
---
 drivers/staging/xgifb/XGI_main_26.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/xgifb/XGI_main_26.c b/drivers/staging/xgifb/XGI_main_26.c
index 2502c49..edd7de7 100644
--- a/drivers/staging/xgifb/XGI_main_26.c
+++ b/drivers/staging/xgifb/XGI_main_26.c
@@ -4,6 +4,8 @@
  * Base on TW's sis fbdev code.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 /* #include <linux/config.h> */
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-- 
1.7.5.4

