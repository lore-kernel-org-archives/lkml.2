Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab0EKXnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 19:43:23 -0400
Received: from kroah.org ([198.145.64.141]:57808 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab0EKXnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 19:43:20 -0400
Subject: patch usb-gadget-f_fs.c-needs-to-include-pagemap.h.patch added to gregkh-2.6 tree
To: randy.dunlap@oracle.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, m.nazarewicz@samsung.com,
       sfr@canb.auug.org.au
From: <gregkh@suse.de>
Date: Tue, 11 May 2010 16:43:06 -0700
In-Reply-To: <20100510105136.eee3e58a.randy.dunlap@oracle.com>
Message-ID: <12736213864040@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: USB: gadget: f_fs.c needs to include pagemap.h

to my gregkh-2.6 tree.  Its filename is

    usb-gadget-f_fs.c-needs-to-include-pagemap.h.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From randy.dunlap@oracle.com  Tue May 11 16:34:16 2010
From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Mon, 10 May 2010 10:51:36 -0700
Subject: USB: gadget: f_fs.c needs to include pagemap.h
To: Stephen Rothwell <sfr@canb.auug.org.au>, Michal Nazarewicz <m.nazarewicz@samsung.com>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, lud <linux-usb@vger.kernel.org>
Message-ID: <20100510105136.eee3e58a.randy.dunlap@oracle.com>


From: Randy Dunlap <randy.dunlap@oracle.com>

Fix g_ffs build error, add a needed header file:

drivers/usb/gadget/f_fs.c:1064:error: 'PAGE_CACHE_SIZE' undeclared (first use in this function)
drivers/usb/gadget/f_fs.c:1065:error: 'PAGE_CACHE_SHIFT' undeclared (first use in this function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Michał Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/gadget/f_fs.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/f_fs.c
+++ b/drivers/usb/gadget/f_fs.c
@@ -28,6 +28,7 @@
 /* #define VERBOSE_DEBUG */
 
 #include <linux/blkdev.h>
+#include <linux/pagemap.h>
 #include <asm/unaligned.h>
 #include <linux/smp_lock.h>
 

