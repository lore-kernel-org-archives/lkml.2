Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab0J3NBr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 09:01:47 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:25126 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592Ab0J3NBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 09:01:46 -0400
Date: Sat, 30 Oct 2010 14:51:30 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc: Ryan Wilson <hap9@epoch.ncsc.mil>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Xen: Remove duplicate inclusion of header in
 xen-pcifront.c
Message-ID: <alpine.LNX.2.00.1010301445550.7979@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/pci/xen-pcifront.c the xen/xenbus.h header is included twice - 
once is enough.

(please keep me on CC for replies)


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 xen-pcifront.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index a87c498..0579273 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -9,15 +9,14 @@
 #include <xen/xenbus.h>
 #include <xen/events.h>
 #include <xen/grant_table.h>
 #include <xen/page.h>
 #include <linux/spinlock.h>
 #include <linux/pci.h>
 #include <linux/msi.h>
-#include <xen/xenbus.h>
 #include <xen/interface/io/pciif.h>
 #include <asm/xen/pci.h>
 #include <linux/interrupt.h>
 #include <asm/atomic.h>
 #include <linux/workqueue.h>
 #include <linux/bitops.h>
 #include <linux/time.h>


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

