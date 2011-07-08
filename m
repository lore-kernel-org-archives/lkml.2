Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab1GHFCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:02:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41805 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab1GHFCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:02:12 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:16:56 2011
Message-Id: <20110708001656.211634755@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:16:08 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Evgeniy Polyakov <zbr@ioremap.net>
Subject: [036/107] Connector: Set the CN_NETLINK_USERS correctly
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit ea2c00095c022846dd8dfd211de05154d3e4e1b8 upstream.

The CN_NETLINK_USERS must be set to the highest valid index +1.
Thanks to Evgeniy for pointing this out.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/connector.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/connector.h
+++ b/include/linux/connector.h
@@ -44,7 +44,7 @@
 #define CN_VAL_DRBD			0x1
 #define CN_KVP_IDX			0x9	/* HyperV KVP */
 
-#define CN_NETLINK_USERS		9
+#define CN_NETLINK_USERS		10	/* Highest index + 1 */
 
 /*
  * Maximum connector's message size.


