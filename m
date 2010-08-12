Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656Ab0HLAFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:05:05 -0400
Received: from kroah.org ([198.145.64.141]:60343 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932536Ab0HLAEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:04:40 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:01:27 2010
Message-Id: <20100812000127.587675341@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:01:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>
Subject: [47/54] net: Fix NETDEV_NOTIFY_PEERS to not conflict with NETDEV_BONDING_DESLAVE.
In-Reply-To: <20100812000249.GA30948@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

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
@@ -203,7 +203,7 @@ static inline int notifier_to_errno(int
 #define NETDEV_BONDING_NEWTYPE  0x000F
 #define NETDEV_POST_INIT	0x0010
 #define NETDEV_UNREGISTER_BATCH 0x0011
-#define NETDEV_NOTIFY_PEERS	0x0012
+#define NETDEV_NOTIFY_PEERS	0x0013
 
 #define SYS_DOWN	0x0001	/* Notify of system down */
 #define SYS_RESTART	SYS_DOWN


