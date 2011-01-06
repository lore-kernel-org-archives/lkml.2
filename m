Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab1AFWYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:24:09 -0500
Received: from kroah.org ([198.145.64.141]:55706 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754610Ab1AFWYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:24:00 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Timur Tabi <timur@freescale.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 31/36] tty: fix typos/errors in tty_driver.h comments
Date: Thu,  6 Jan 2011 14:23:20 -0800
Message-Id: <1294352605-31906-31-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110106215404.GA30624@kroah.com>
References: <20110106215404.GA30624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Timur Tabi <timur@freescale.com>

Fix various typos and other errors in comments of tty_driver.h.  The most
significant is the wrong name of a function for the description of
TTY_DRIVER_DYNAMIC_DEV.

Signed-off-by: Timur Tabi <timur@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/tty_driver.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 09678ed..c3d43eb 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -102,7 +102,7 @@
  * 	    unsigned int cmd, unsigned long arg);
  *
  * 	This routine allows the tty driver to implement
- *	device-specific ioctl's.  If the ioctl number passed in cmd
+ *	device-specific ioctls.  If the ioctl number passed in cmd
  * 	is not recognized by the driver, it should return ENOIOCTLCMD.
  *
  *	Optional
@@ -167,12 +167,12 @@
  * 
  * void (*hangup)(struct tty_struct *tty);
  *
- * 	This routine notifies the tty driver that it should hangup the
+ * 	This routine notifies the tty driver that it should hang up the
  * 	tty device.
  *
  *	Optional:
  *
- * int (*break_ctl)(struct tty_stuct *tty, int state);
+ * int (*break_ctl)(struct tty_struct *tty, int state);
  *
  * 	This optional routine requests the tty driver to turn on or
  * 	off BREAK status on the RS-232 port.  If state is -1,
@@ -358,7 +358,7 @@ static inline struct tty_driver *tty_driver_kref_get(struct tty_driver *d)
  * 	overruns, either.)
  *
  * TTY_DRIVER_DYNAMIC_DEV --- if set, the individual tty devices need
- *	to be registered with a call to tty_register_driver() when the
+ *	to be registered with a call to tty_register_device() when the
  *	device is found in the system and unregistered with a call to
  *	tty_unregister_device() so the devices will be show up
  *	properly in sysfs.  If not set, driver->num entries will be
-- 
1.7.3.2

