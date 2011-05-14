Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab1ENK53 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 06:57:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49778 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755496Ab1ENK4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 06:56:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=lSkjKNa51wyhv5uZFD/6cnux5EzoRQAHVF4u4hkaWNfI043QCmhuNIefXMHUoP8fnT
         rrbdAh0uh+mt58V2TnzR1bDGOYu/NnvnQtWKNoTDYHs7AGsO7NX3Sq/liKmhRunoytqo
         /HtHAYryHNaOh8UGWI1P46WIWJBHERU0TTlBY=
From: matt mooney <mfmooney@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/14] staging: usbip: userspace: remove revision $Id$
Date: Sat, 14 May 2011 03:55:16 -0700
Message-Id: <17778cd929853f5e8f442171aa5a61d84a78957b.1305369176.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305369175.git.mfm@muteddisk.com>
References: <cover.1305369175.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: matt mooney <mfm@muteddisk.com>

This is git not CVS!

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/src/bind-driver.c  |    1 -
 drivers/staging/usbip/userspace/src/usbip.c        |    4 +---
 .../staging/usbip/userspace/src/usbip_network.c    |    1 -
 drivers/staging/usbip/userspace/src/usbipd.c       |    4 +---
 drivers/staging/usbip/userspace/src/utils.c        |    1 -
 5 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/bind-driver.c b/drivers/staging/usbip/userspace/src/bind-driver.c
index 12918c1..955c86b 100644
--- a/drivers/staging/usbip/userspace/src/bind-driver.c
+++ b/drivers/staging/usbip/userspace/src/bind-driver.c
@@ -1,5 +1,4 @@
 /*
- * $Id$
  *
  * Copyright (C) 2005-2007 Takahiro Hirofuchi
  */
diff --git a/drivers/staging/usbip/userspace/src/usbip.c b/drivers/staging/usbip/userspace/src/usbip.c
index 3943d15..01a5628 100644
--- a/drivers/staging/usbip/userspace/src/usbip.c
+++ b/drivers/staging/usbip/userspace/src/usbip.c
@@ -1,5 +1,4 @@
 /*
- * $Id$
  *
  * Copyright (C) 2005-2007 Takahiro Hirofuchi
  */
@@ -17,8 +16,7 @@
 #include <fcntl.h>
 #include <glib.h>
 
-static const char version[] = PACKAGE_STRING
-	" ($Id$)";
+static const char version[] = PACKAGE_STRING;
 
 
 /* /sys/devices/platform/vhci_hcd/usb6/6-1/6-1:1.1  -> 1 */
diff --git a/drivers/staging/usbip/userspace/src/usbip_network.c b/drivers/staging/usbip/userspace/src/usbip_network.c
index a3a955b..726173e 100644
--- a/drivers/staging/usbip/userspace/src/usbip_network.c
+++ b/drivers/staging/usbip/userspace/src/usbip_network.c
@@ -1,5 +1,4 @@
 /*
- * $Id$
  *
  * Copyright (C) 2005-2007 Takahiro Hirofuchi
  */
diff --git a/drivers/staging/usbip/userspace/src/usbipd.c b/drivers/staging/usbip/userspace/src/usbipd.c
index 441dcde..409d064 100644
--- a/drivers/staging/usbip/userspace/src/usbipd.c
+++ b/drivers/staging/usbip/userspace/src/usbipd.c
@@ -1,5 +1,4 @@
 /*
- * $Id$
  *
  * Copyright (C) 2005-2007 Takahiro Hirofuchi
  */
@@ -31,8 +30,7 @@
 
 #include <glib.h>
 
-static const char version[] = PACKAGE_STRING
-	" ($Id$)";
+static const char version[] = PACKAGE_STRING;
 
 
 static int send_reply_devlist(int sockfd)
diff --git a/drivers/staging/usbip/userspace/src/utils.c b/drivers/staging/usbip/userspace/src/utils.c
index 403c30f..8f44108 100644
--- a/drivers/staging/usbip/userspace/src/utils.c
+++ b/drivers/staging/usbip/userspace/src/utils.c
@@ -1,5 +1,4 @@
 /*
- * $Id$
  *
  * Copyright (C) 2005-2007 Takahiro Hirofuchi
  */
-- 
1.7.5.1

