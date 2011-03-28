Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab1C1Qat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:30:49 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39860 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103Ab1C1Qar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:30:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=A4YnaHoYdhgFK+8lFR7w2CObKKDg7eV5RXqwXTTzGSVkf/mjJjrJIDgURsZjck9TEV
         pOPDjio9iCkLxSOL6n4sMt8nsuaihkb8+JkEkJXfH/7t1nbKRXEyl5BDbXFF/jMtC4ur
         Xozm9qIih98zRDJB9XIvl9ynve+NWLaZYcb/k=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 11/25]drivers:usb Remove version.h since it is unused.
Date: Mon, 28 Mar 2011 09:29:34 -0700
Message-Id: <1301329788-3423-12-git-send-email-justinmattock@gmail.com>
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
 drivers/usb/core/hcd.c           |    1 -
 drivers/usb/gadget/uvc_v4l2.c    |    1 -
 drivers/usb/storage/realtek_cr.c |    1 -
 3 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 02b4dbf..ede1fb4 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -23,7 +23,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/completion.h>
diff --git a/drivers/usb/gadget/uvc_v4l2.c b/drivers/usb/gadget/uvc_v4l2.c
index 5e807f0..a715805 100644
--- a/drivers/usb/gadget/uvc_v4l2.c
+++ b/drivers/usb/gadget/uvc_v4l2.c
@@ -16,7 +16,6 @@
 #include <linux/errno.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
-#include <linux/version.h>
 #include <linux/videodev2.h>
 #include <linux/vmalloc.h>
 #include <linux/wait.h>
diff --git a/drivers/usb/storage/realtek_cr.c b/drivers/usb/storage/realtek_cr.c
index d509a4a..fe21104 100644
--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -26,7 +26,6 @@
 #include <linux/sched.h>
 #include <linux/workqueue.h>
 #include <linux/kernel.h>
-#include <linux/version.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
-- 
1.7.4.1

