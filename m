Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab1HCXkL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:40:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33773 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756115Ab1HCX21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:28:27 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:50 2011
Message-Id: <20110803221250.578309923@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Randy Dunlap <rdunlap@xenotime.net>,
        Mike Frysinger <vapier@gentoo.org>
Subject: [065/102] drivers/firmware/sigma.c needs MODULE_LICENSE
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Randy Dunlap <rdunlap@xenotime.net>

commit 27c46a2546c75c6814562e85b751e3d64c188ad5 upstream.

Fix module tainting message:

  sigma: module license 'unspecified' taints kernel.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/firmware/sigma.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/firmware/sigma.c
+++ b/drivers/firmware/sigma.c
@@ -11,6 +11,7 @@
 #include <linux/firmware.h>
 #include <linux/kernel.h>
 #include <linux/i2c.h>
+#include <linux/module.h>
 #include <linux/sigma.h>
 
 /* Return: 0==OK, <0==error, =1 ==no more actions */
@@ -113,3 +114,5 @@ int process_sigma_firmware(struct i2c_cl
 	return ret;
 }
 EXPORT_SYMBOL(process_sigma_firmware);
+
+MODULE_LICENSE("GPL");


