Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754620Ab2BBCGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 21:06:06 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:38860 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754391Ab2BBCGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 21:06:04 -0500
Message-ID: <4F29FD22.2050004@xenotime.net>
Date: Wed, 01 Feb 2012 19:04:02 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: gregkh@linuxfoundation.org
Subject: [PATCH] staging: fix go7007-usb license
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Add MODULE_LICENSE() for this source module to fix build warning:

WARNING: modpost: missing MODULE_LICENSE() in drivers/staging/media/go7007/go7007-usb.o
see include/linux/module.h for more information

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Ross Cohen <rcohen@snurgle.org>
---
 drivers/staging/media/go7007/go7007-usb.c |    1 +
 1 file changed, 1 insertion(+)

--- lnx-33-rc2.orig/drivers/staging/media/go7007/go7007-usb.c
+++ lnx-33-rc2/drivers/staging/media/go7007/go7007-usb.c
@@ -1279,3 +1279,4 @@ static struct usb_driver go7007_usb_driv
 };
 
 module_usb_driver(go7007_usb_driver);
+MODULE_LICENSE("GPL v2");
