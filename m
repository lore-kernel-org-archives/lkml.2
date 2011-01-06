Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab1AFWbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:31:10 -0500
Received: from kroah.org ([198.145.64.141]:55633 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754476Ab1AFWXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:23:39 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg KH <gregkh@suse.de>
Subject: [PATCH 09/36] TTY: include termios.h in tty_driver.h
Date: Thu,  6 Jan 2011 14:22:58 -0800
Message-Id: <1294352605-31906-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110106215404.GA30624@kroah.com>
References: <20110106215404.GA30624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

We reference termios and termiox in tty_driver.h, but we do not include
linux/termios.h where these are defined. Add the #include properly.

Otherwise when we include tty_driver.h, we get compile errors.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.3.2

