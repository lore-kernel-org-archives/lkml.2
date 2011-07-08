Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab1GIGFi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 02:05:38 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:43806 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751971Ab1GIGBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 02:01:11 -0400
X-Sasl-enc: gAW8ATBYnWum7FW9Sor250ELvrOXT4UC3AI7L4ICKi3H 1310191270
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Jul  8 16:01:12 2011
Message-Id: <20110708230111.917254960@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 08 Jul 2011 16:00:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Liu Aleaxander <Aleaxander@gmail.com>,
        Boaz Harrosh <bharrosh@panasas.com>, Jeff Dike <jdike@addtoit.com>
Subject: [24/35] um: os-linux/mem.c needs sys/stat.h
In-Reply-To: <20110708230122.GA18807@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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


