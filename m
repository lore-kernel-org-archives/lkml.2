Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab2KKMxA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:53:00 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62817 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271Ab2KKMwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:52:49 -0500
From: Stefan Hajnoczi <stefanha@gmail.com>
To: devel@driverdev.osuosl.org
Cc: Markus Grabner <grabner@icg.tugraz.at>, Daniel Mack <zonque@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        line6linux-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@gmail.com>
Subject: [PATCH 3/3] staging: line6: drop unused CONFIG_LINE6_USB_DEBUG
Date: Sun, 11 Nov 2012 13:52:26 +0100
Message-Id: <1352638346-32273-4-git-send-email-stefanha@gmail.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1352638346-32273-1-git-send-email-stefanha@gmail.com>
References: <1352638346-32273-1-git-send-email-stefanha@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_LINE6_USB_DEBUG option is no longer relevant since dyndbg
dev_dbg() is now used instead of a compile-time decision whether to
enable debug messages or not.

Signed-off-by: Stefan Hajnoczi <stefanha@gmail.com>
---
 drivers/staging/line6/Kconfig | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/staging/line6/Kconfig b/drivers/staging/line6/Kconfig
index 43120ff..a5ded12 100644
--- a/drivers/staging/line6/Kconfig
+++ b/drivers/staging/line6/Kconfig
@@ -23,14 +23,6 @@ menuconfig LINE6_USB
 
 if LINE6_USB
 
-config LINE6_USB_DEBUG
-	bool "print debug messages"
-	default n
-	help
-	  Say Y here to write debug messages to the syslog.
-
-	  If unsure, say N.
-
 config LINE6_USB_DUMP_CTRL
 	bool "dump control messages"
 	default n
-- 
1.7.12.1

