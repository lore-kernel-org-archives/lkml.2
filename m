Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933670Ab0HLAjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:39:25 -0400
Received: from kroah.org ([198.145.64.141]:40217 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758851Ab0HKX6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:07 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:54:59 2010
Message-Id: <20100811235458.998542349@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [038/111] net: Fix NETDEV_NOTIFY_PEERS to not conflict with NETDEV_BONDING_DESLAVE.
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

commit 38117d1495e587fbb10d6e55733139a27893cef5 upstream.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/notifier.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -201,7 +201,7 @@ static inline int notifier_to_errno(int
 #define NETDEV_PRE_UP		0x000D
 #define NETDEV_BONDING_OLDTYPE  0x000E
 #define NETDEV_BONDING_NEWTYPE  0x000F
-#define NETDEV_NOTIFY_PEERS	0x0012
+#define NETDEV_NOTIFY_PEERS	0x0013
 
 #define SYS_DOWN	0x0001	/* Notify of system down */
 #define SYS_RESTART	SYS_DOWN


