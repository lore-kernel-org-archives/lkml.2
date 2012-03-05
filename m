Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab2CENxf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:53:35 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34865 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964872Ab2CENx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 23/68] TTY: remove serialP.h inclusion from some files
Date: Mon,  5 Mar 2012 14:52:10 +0100
Message-Id: <1330955575-26641-24-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All of them do not use the ugly interface defined in that header.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/xtensa/platforms/iss/console.c |    1 -
 drivers/tty/serial/ioc4_serial.c    |    1 -
 drivers/tty/serial/m32r_sio.c       |    1 -
 3 files changed, 3 deletions(-)

diff --git a/arch/xtensa/platforms/iss/console.c b/arch/xtensa/platforms/iss/console.c
index d1a7861..f9726f6 100644
--- a/arch/xtensa/platforms/iss/console.c
+++ b/arch/xtensa/platforms/iss/console.c
@@ -19,7 +19,6 @@
 #include <linux/param.h>
 #include <linux/seq_file.h>
 #include <linux/serial.h>
-#include <linux/serialP.h>
 
 #include <asm/uaccess.h>
 #include <asm/irq.h>
diff --git a/drivers/tty/serial/ioc4_serial.c b/drivers/tty/serial/ioc4_serial.c
index dfec69a..e16894f 100644
--- a/drivers/tty/serial/ioc4_serial.c
+++ b/drivers/tty/serial/ioc4_serial.c
@@ -16,7 +16,6 @@
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
 #include <linux/serial.h>
-#include <linux/serialP.h>
 #include <linux/circ_buf.h>
 #include <linux/serial_reg.h>
 #include <linux/module.h>
diff --git a/drivers/tty/serial/m32r_sio.c b/drivers/tty/serial/m32r_sio.c
index e465dda..a070362 100644
--- a/drivers/tty/serial/m32r_sio.c
+++ b/drivers/tty/serial/m32r_sio.c
@@ -38,7 +38,6 @@
 #include <linux/console.h>
 #include <linux/sysrq.h>
 #include <linux/serial.h>
-#include <linux/serialP.h>
 #include <linux/delay.h>
 
 #include <asm/m32r.h>
-- 
1.7.9.2


