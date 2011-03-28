Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab1C1QaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:30:25 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39860 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab1C1QaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:30:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Z2NsNHhuxcv0NLOhKB/HSRbNfSsAgsHjliBJKc+zN5jzwA+u5Yh7vjfnDJVKCgN/xy
         MvJFXh+HfqlqSSTeTwOsF7mnXBJDK2CauUDYX1b7NthirsS5H/frhEGRcwmXXgzDVX+o
         iPYRy83C6tP00vzLaXgZ65RLdEVDG4yy4b1Sk=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 10/25]drivers:input Remove version.h since it is unused.
Date: Mon, 28 Mar 2011 09:29:33 -0700
Message-Id: <1301329788-3423-11-git-send-email-justinmattock@gmail.com>
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
 drivers/input/keyboard/adp5588-keys.c |    1 -
 drivers/input/misc/bfin_rotary.c      |    1 -
 drivers/input/mouse/pxa930_trkball.c  |    1 -
 drivers/input/mouse/sentelic.c        |    1 -
 4 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/input/keyboard/adp5588-keys.c b/drivers/input/keyboard/adp5588-keys.c
index af45d27..7b404e5 100644
--- a/drivers/input/keyboard/adp5588-keys.c
+++ b/drivers/input/keyboard/adp5588-keys.c
@@ -9,7 +9,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
diff --git a/drivers/input/misc/bfin_rotary.c b/drivers/input/misc/bfin_rotary.c
index 4f72bdd..d00edc9 100644
--- a/drivers/input/misc/bfin_rotary.c
+++ b/drivers/input/misc/bfin_rotary.c
@@ -6,7 +6,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/irq.h>
diff --git a/drivers/input/mouse/pxa930_trkball.c b/drivers/input/mouse/pxa930_trkball.c
index 943cfec..6c5d84f 100644
--- a/drivers/input/mouse/pxa930_trkball.c
+++ b/drivers/input/mouse/pxa930_trkball.c
@@ -12,7 +12,6 @@
 
 #include <linux/init.h>
 #include <linux/input.h>
-#include <linux/version.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
diff --git a/drivers/input/mouse/sentelic.c b/drivers/input/mouse/sentelic.c
index 1242775..2fc887a 100644
--- a/drivers/input/mouse/sentelic.c
+++ b/drivers/input/mouse/sentelic.c
@@ -20,7 +20,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/input.h>
 #include <linux/ctype.h>
 #include <linux/libps2.h>
-- 
1.7.4.1

