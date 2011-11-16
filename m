Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab1KPP16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 10:27:58 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:52989 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab1KPP1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 10:27:16 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH 4/5] TTY: ldisc, remove some unneeded includes
Date: Wed, 16 Nov 2011 16:27:10 +0100
Message-Id: <1321457231-9154-4-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1321457231-9154-1-git-send-email-jslaby@suse.cz>
References: <1321457231-9154-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They were cut&pasted from tty_io. Many of them are not needed in
tty_ldisc.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/tty/tty_ldisc.c |   22 ++--------------------
 1 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 8e0924f..6b344ae 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -1,19 +1,11 @@
 #include <linux/types.h>
-#include <linux/major.h>
 #include <linux/errno.h>
-#include <linux/signal.h>
-#include <linux/fcntl.h>
+#include <linux/kmod.h>
 #include <linux/sched.h>
 #include <linux/interrupt.h>
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
-#include <linux/tty_flip.h>
-#include <linux/devpts_fs.h>
 #include <linux/file.h>
-#include <linux/console.h>
-#include <linux/timer.h>
-#include <linux/ctype.h>
-#include <linux/kd.h>
 #include <linux/mm.h>
 #include <linux/string.h>
 #include <linux/slab.h>
@@ -24,19 +16,9 @@
 #include <linux/device.h>
 #include <linux/wait.h>
 #include <linux/bitops.h>
-#include <linux/delay.h>
 #include <linux/seq_file.h>
-
-#include <linux/uaccess.h>
-#include <asm/system.h>
-
-#include <linux/kbd_kern.h>
-#include <linux/vt_kern.h>
-#include <linux/selection.h>
-
-#include <linux/kmod.h>
-#include <linux/nsproxy.h>
 #include <linux/ratelimit.h>
+#include <linux/uaccess.h>
 
 /*
  *	This guards the refcounted line discipline lists. The lock
-- 
1.7.7.3


