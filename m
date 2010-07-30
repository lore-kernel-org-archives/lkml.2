Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148Ab0G3SXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:23:42 -0400
Received: from kroah.org ([198.145.64.141]:58596 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932302Ab0G3R4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:56:04 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:42 2010
Message-Id: <20100730175142.217237871@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:51:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Liu Aleaxander <Aleaxander@gmail.com>,
        Boaz Harrosh <bharrosh@panasas.com>, Jeff Dike <jdike@addtoit.com>
Subject: [094/205] um: os-linux/mem.c needs sys/stat.h
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Liu Aleaxander <aleaxander@gmail.com>

commit fb967ecc584c20c74a007de749ca597068b0fcac upstream.

The os-linux/mem.c file calls fchmod function, which is declared in sys/stat.h
header file, so include it.  Fixes build breakage under FC13.

Signed-off-by: Liu Aleaxander <Aleaxander@gmail.com>
Acked-by: Boaz Harrosh <bharrosh@panasas.com>
Cc: Jeff Dike <jdike@addtoit.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/os-Linux/mem.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/um/os-Linux/mem.c
+++ b/arch/um/os-Linux/mem.c
@@ -10,6 +10,7 @@
 #include <errno.h>
 #include <fcntl.h>
 #include <string.h>
+#include <sys/stat.h>
 #include <sys/mman.h>
 #include <sys/param.h>
 #include "init.h"


