Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab1C1Qab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:30:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39860 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab1C1Qa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:30:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=g2OU/uC67Pqtz8Q+0yIdCS6XvzUkHohHVag9//WTj7pINM9S6TWlCA5uAevsL3cGpO
         8CgysbX5lQZKZP8HbS3KyrNJ9/FbkzdYRVE2lFg3vZrERrTibGMzqYqpsYPDGh1+1AbP
         1EiGmGy6mSNlGf5W0HiDXq+MUZuiXJ2AvJ+pc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 14/25]drivers:video Remove version.h since it is unused.
Date: Mon, 28 Mar 2011 09:29:37 -0700
Message-Id: <1301329788-3423-15-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
References: <1301329788-3423-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes <linux/version.h> since it is nolonger
in the kernel.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/video/backlight/adp8860_bl.c |    1 -
 drivers/video/matrox/matroxfb_base.c |    2 --
 drivers/video/pxa3xx-gcu.c           |    1 -
 drivers/video/xilinxfb.c             |    1 -
 4 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/video/backlight/adp8860_bl.c b/drivers/video/backlight/adp8860_bl.c
index d2a96a4..24a6dfd 100644
--- a/drivers/video/backlight/adp8860_bl.c
+++ b/drivers/video/backlight/adp8860_bl.c
@@ -7,7 +7,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/pm.h>
diff --git a/drivers/video/matrox/matroxfb_base.c b/drivers/video/matrox/matroxfb_base.c
index 5ce6fa6..cd09b3f 100644
--- a/drivers/video/matrox/matroxfb_base.c
+++ b/drivers/video/matrox/matroxfb_base.c
@@ -99,8 +99,6 @@
  *
  */
 
-#include <linux/version.h>
-
 #include "matroxfb_base.h"
 #include "matroxfb_misc.h"
 #include "matroxfb_accel.h"
diff --git a/drivers/video/pxa3xx-gcu.c b/drivers/video/pxa3xx-gcu.c
index cf4beb9..7c0521c 100644
--- a/drivers/video/pxa3xx-gcu.c
+++ b/drivers/video/pxa3xx-gcu.c
@@ -31,7 +31,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 
 #include <linux/platform_device.h>
 #include <linux/dma-mapping.h>
diff --git a/drivers/video/xilinxfb.c b/drivers/video/xilinxfb.c
index 77dea01..fcb6cd9 100644
--- a/drivers/video/xilinxfb.c
+++ b/drivers/video/xilinxfb.c
@@ -23,7 +23,6 @@
 #include <linux/device.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/errno.h>
 #include <linux/string.h>
 #include <linux/mm.h>
-- 
1.7.4.1

