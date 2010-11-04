Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396Ab0KDPVZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:21:25 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:33084 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab0KDPVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:21:21 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: werner@suse.de, alan@lxorguk.ukuu.org.uk, gregkh@suse.de,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH v2 4/5] TTY: include termios.h in tty_driver.h
Date: Thu,  4 Nov 2010 16:20:23 +0100
Message-Id: <1288884024-23873-4-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1288884024-23873-1-git-send-email-jslaby@suse.cz>
References: <1288884024-23873-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We reference termios and termiox in tty_driver.h, but we do not include
linux/termios.h where these are defined. Add the #include properly.

Otherwise when we include tty_driver.h, we get compile errors.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@suse.de>
---
 include/linux/tty_driver.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index db2d227..09678ed 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -235,6 +235,7 @@
 #include <linux/fs.h>
 #include <linux/list.h>
 #include <linux/cdev.h>
+#include <linux/termios.h>
 
 struct tty_struct;
 struct tty_driver;
-- 
1.7.3.1


