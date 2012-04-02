Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab2DBMK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 08:10:57 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:47938 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab2DBLzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 07:55:00 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Jan Dumon <j.dumon@option.com>
Subject: [PATCH 19/69] TTY: hso, do not set TTY MAGIC
Date: Mon,  2 Apr 2012 13:54:03 +0200
Message-Id: <1333367693-3244-20-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
References: <1333367693-3244-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is set in alloc_tty_driver already. No need to re-set.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Jan Dumon <j.dumon@option.com>
---
 drivers/net/usb/hso.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 2d2a688..abe47ad 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -3312,7 +3312,6 @@ static int __init hso_init(void)
 		return -ENOMEM;
 
 	/* fill in all needed values */
-	tty_drv->magic = TTY_DRIVER_MAGIC;
 	tty_drv->driver_name = driver_name;
 	tty_drv->name = tty_filename;
 
-- 
1.7.9.2


