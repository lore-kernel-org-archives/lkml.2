Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab0KAPi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 11:38:57 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:44913 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758144Ab0KAPix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 11:38:53 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h)
X-FB-SS: 0,
From: Timur Tabi <timur@freescale.com>
To: <linux-kernel@vger.kernel.org>, <jslaby@suse.cz>
Subject: [PATCH] tty: fix typos/errors in tty_driver.h comments
Date: Mon, 1 Nov 2010 10:38:46 -0500
Message-ID: <1288625926-26293-1-git-send-email-timur@freescale.com>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: de01egw01.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix various typos and other errors in comments of tty_driver.h.  The most
significant is the wrong name of a function for the description of
TTY_DRIVER_DYNAMIC_DEV.

Signed-off-by: Timur Tabi <timur@freescale.com>
---
 include/linux/tty_driver.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index b086779..6c4e42f 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -102,7 +102,7 @@
  * 	    unsigned int cmd, unsigned long arg);
  *
  * 	This routine allows the tty driver to implement
- *	device-specific ioctl's.  If the ioctl number passed in cmd
+ * 	device-specific ioctls.  If the ioctl number passed in cmd
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
@@ -348,7 +348,7 @@ static inline struct tty_driver *tty_driver_kref_get(struct tty_driver *d)
  * 	overruns, either.)
  *
  * TTY_DRIVER_DYNAMIC_DEV --- if set, the individual tty devices need
- *	to be registered with a call to tty_register_driver() when the
+ *	to be registered with a call to tty_register_device() when the
  *	device is found in the system and unregistered with a call to
  *	tty_unregister_device() so the devices will be show up
  *	properly in sysfs.  If not set, driver->num entries will be
-- 
1.7.2.3


