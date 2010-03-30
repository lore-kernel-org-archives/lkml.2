Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab0CaADL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:03:11 -0400
Received: from kroah.org ([198.145.64.141]:45340 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932277Ab0C3XSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:18:39 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:52 2010
Message-Id: <20100330225651.458930082@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:55:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Paulius Zaleckas <paulius.zaleckas@gmail.com>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [081/116] if_tunnel.h: add missing ams/byteorder.h include
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Paulius Zaleckas <paulius.zaleckas@gmail.com>

commit 9bf35c8dddd56f7f247a27346f74f5adc18071f4 upstream.

When compiling userspace application which includes
if_tunnel.h and uses GRE_* defines you will get undefined
reference to __cpu_to_be16.

Fix this by adding missing #include <asm/byteorder.h>

Signed-off-by: Paulius Zaleckas <paulius.zaleckas@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/if_tunnel.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/if_tunnel.h
+++ b/include/linux/if_tunnel.h
@@ -2,6 +2,7 @@
 #define _IF_TUNNEL_H_
 
 #include <linux/types.h>
+#include <asm/byteorder.h>
 
 #ifdef __KERNEL__
 #include <linux/ip.h>


