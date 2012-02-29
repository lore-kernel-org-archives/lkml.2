Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965893Ab2B2A2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 19:28:11 -0500
Received: from mail.windriver.com ([147.11.1.11]:45017 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423Ab2B2A2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 19:28:09 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: broonie@opensource.wolfsonmicro.com
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] regmap: delete unused module.h from drivers/base/regmap files
Date: Tue, 28 Feb 2012 19:28:02 -0500
Message-Id: <1330475282-15284-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused module.h and/or replace with export.h
as required.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 6f39747..890f554c 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -11,7 +11,6 @@
  */
 
 #include <linux/slab.h>
-#include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 6555803..e4fbeaa 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -11,7 +11,7 @@
  */
 
 #include <linux/slab.h>
-#include <linux/module.h>
+#include <linux/export.h>
 #include <linux/mutex.h>
 #include <linux/err.h>
 
-- 
1.7.9.1

