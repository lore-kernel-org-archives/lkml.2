Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab2ACWmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:42:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40512 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932167Ab2ACWmc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:42:32 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:27 2012
Message-Id: <20120103223327.247672610@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:33:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stephen Rothwell <sfr@canb.auug.org.au>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>
Subject: [73/75] ipv4: using prefetch requires including prefetch.h
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Stephen Rothwell <sfr@canb.auug.org.au>

[ Upstream commit b9eda06f80b0db61a73bd87c6b0eb67d8aca55ad ]

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: David Miller <davem@davemloft.net>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ipv4/route.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -91,6 +91,7 @@
 #include <linux/rcupdate.h>
 #include <linux/times.h>
 #include <linux/slab.h>
+#include <linux/prefetch.h>
 #include <net/dst.h>
 #include <net/net_namespace.h>
 #include <net/protocol.h>


