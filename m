Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933373Ab0HLALF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:11:05 -0400
Received: from kroah.org ([198.145.64.141]:47971 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933269Ab0HLAJC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:09:02 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:18 2010
Message-Id: <20100812000618.328434116@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:06:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        James Chapman <jchapman@katalix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [61/67] l2tp: fix export of header file for userspace
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: James Chapman <jchapman@katalix.com>

commit 4565956dc0847985c0403c9ebbf274b6a122e1e2 upstream.

The header file l2tp.h should be exported to the installed include/linux/
tree for userspace programs.

This patch fixes compilation errors in L2TP userspace apps which want to
use the new L2TP support introduced in 2.6.35.

Signed-off-by: James Chapman <jchapman@katalix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/Kbuild |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -276,6 +276,7 @@ ifneq ($(wildcard $(srctree)/arch/$(SRCA
 		  $(srctree)/include/asm-$(SRCARCH)/kvm_para.h),)
 unifdef-y += kvm_para.h
 endif
+unifdef-y += l2tp.h
 unifdef-y += llc.h
 unifdef-y += loop.h
 unifdef-y += lp.h


