Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003Ab0FQQOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 12:14:33 -0400
Received: from govinda.solana.com ([198.99.130.30]:51043 "EHLO
	govinda.addtoit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932982Ab0FQQOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 12:14:31 -0400
X-Greylist: delayed 817 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Jun 2010 12:14:31 EDT
Date: Thu, 17 Jun 2010 12:00:45 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Alan Cox <alan@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Remove Hayes ESP ioctls
Message-ID: <20100617160045.GA13743@c-98-229-117-200.hsd1.ma.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit e6b14f5bc9803589241bc2aae1565fa0c5bd0ce1
Author: Jeff Dike <jdike@linux.intel.com>
Date:   Thu Jun 17 11:54:24 2010 -0400

    Remove Hayes ESP ioctls
    
    The Hayes ESP driver has been removed from the tree:
        commit f53a2ade0bb9f2a81f473e6469155172a96b7c38
        ("tty: esp: remove broken driver")
    so its ioctls aren't needed any more.

diff --git a/include/asm-generic/ioctls.h b/include/asm-generic/ioctls.h
index a799e20..16218ac 100644
--- a/include/asm-generic/ioctls.h
+++ b/include/asm-generic/ioctls.h
@@ -86,16 +86,6 @@
 #define TIOCMIWAIT	0x545C	/* wait for a change on serial input line(s) */
 #define TIOCGICOUNT	0x545D	/* read serial port inline interrupt counts */
 
-/*
- * some architectures define FIOQSIZE as 0x545E, which is used for
- * TIOCGHAYESESP on others
- */
-#ifndef FIOQSIZE
-# define TIOCGHAYESESP	0x545E  /* Get Hayes ESP configuration */
-# define TIOCSHAYESESP	0x545F  /* Set Hayes ESP configuration */
-# define FIOQSIZE	0x5460
-#endif
-
 /* Used for packet mode */
 #define TIOCPKT_DATA		 0
 #define TIOCPKT_FLUSHREAD	 1
