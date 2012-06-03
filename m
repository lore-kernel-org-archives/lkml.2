Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab2FCQjQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 12:39:16 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:4650 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751902Ab2FCQjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 12:39:15 -0400
Message-ID: <1338741553.19914.5.camel@x61.thuisdomein>
Subject: [PATCH] [TRIVIAL] renesas_usbhs: cleanup quoted includes
From: Paul Bolle <pebolle@tiscali.nl>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 03 Jun 2012 18:39:13 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 03 Jun 2012 16:39:13.0225 (UTC) FILETIME=[68812390:01CD41A7]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few quoted includes start with a superfluous "./". Clean up those
quoted includes.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Compile tested only.

 drivers/usb/renesas_usbhs/common.c |    2 +-
 drivers/usb/renesas_usbhs/common.h |    4 ++--
 drivers/usb/renesas_usbhs/fifo.c   |    4 ++--
 drivers/usb/renesas_usbhs/mod.c    |    4 ++--
 drivers/usb/renesas_usbhs/mod.h    |    2 +-
 drivers/usb/renesas_usbhs/pipe.c   |    4 ++--
 drivers/usb/renesas_usbhs/pipe.h   |    4 ++--
 7 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/renesas_usbhs/common.c b/drivers/usb/renesas_usbhs/common.c
index a165490..8c9bb1a 100644
--- a/drivers/usb/renesas_usbhs/common.c
+++ b/drivers/usb/renesas_usbhs/common.c
@@ -19,7 +19,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/slab.h>
 #include <linux/sysfs.h>
-#include "./common.h"
+#include "common.h"
 
 /*
  *		image of renesas_usbhs
diff --git a/drivers/usb/renesas_usbhs/common.h b/drivers/usb/renesas_usbhs/common.h
index 3f3ccd3..dddf40a 100644
--- a/drivers/usb/renesas_usbhs/common.h
+++ b/drivers/usb/renesas_usbhs/common.h
@@ -22,8 +22,8 @@
 
 struct usbhs_priv;
 
-#include "./mod.h"
-#include "./pipe.h"
+#include "mod.h"
+#include "pipe.h"
 
 /*
  *
diff --git a/drivers/usb/renesas_usbhs/fifo.c b/drivers/usb/renesas_usbhs/fifo.c
index 6ec7f83..0831357 100644
--- a/drivers/usb/renesas_usbhs/fifo.c
+++ b/drivers/usb/renesas_usbhs/fifo.c
@@ -17,8 +17,8 @@
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/scatterlist.h>
-#include "./common.h"
-#include "./pipe.h"
+#include "common.h"
+#include "pipe.h"
 
 #define usbhsf_get_cfifo(p)	(&((p)->fifo_info.cfifo))
 #define usbhsf_get_d0fifo(p)	(&((p)->fifo_info.d0fifo))
diff --git a/drivers/usb/renesas_usbhs/mod.c b/drivers/usb/renesas_usbhs/mod.c
index 0871e81..82a628f 100644
--- a/drivers/usb/renesas_usbhs/mod.c
+++ b/drivers/usb/renesas_usbhs/mod.c
@@ -16,8 +16,8 @@
  */
 #include <linux/interrupt.h>
 
-#include "./common.h"
-#include "./mod.h"
+#include "common.h"
+#include "mod.h"
 
 #define usbhs_priv_to_modinfo(priv) (&priv->mod_info)
 #define usbhs_mod_info_call(priv, func, param...)	\
diff --git a/drivers/usb/renesas_usbhs/mod.h b/drivers/usb/renesas_usbhs/mod.h
index 6c68755..1ef5bf6 100644
--- a/drivers/usb/renesas_usbhs/mod.h
+++ b/drivers/usb/renesas_usbhs/mod.h
@@ -19,7 +19,7 @@
 
 #include <linux/spinlock.h>
 #include <linux/usb/renesas_usbhs.h>
-#include "./common.h"
+#include "common.h"
 
 /*
  *	struct
diff --git a/drivers/usb/renesas_usbhs/pipe.c b/drivers/usb/renesas_usbhs/pipe.c
index feb06d6..122526c 100644
--- a/drivers/usb/renesas_usbhs/pipe.c
+++ b/drivers/usb/renesas_usbhs/pipe.c
@@ -16,8 +16,8 @@
  */
 #include <linux/delay.h>
 #include <linux/slab.h>
-#include "./common.h"
-#include "./pipe.h"
+#include "common.h"
+#include "pipe.h"
 
 /*
  *		macros
diff --git a/drivers/usb/renesas_usbhs/pipe.h b/drivers/usb/renesas_usbhs/pipe.h
index fa18b7d..08786c0 100644
--- a/drivers/usb/renesas_usbhs/pipe.h
+++ b/drivers/usb/renesas_usbhs/pipe.h
@@ -17,8 +17,8 @@
 #ifndef RENESAS_USB_PIPE_H
 #define RENESAS_USB_PIPE_H
 
-#include "./common.h"
-#include "./fifo.h"
+#include "common.h"
+#include "fifo.h"
 
 /*
  *	struct
-- 
1.7.7.6




