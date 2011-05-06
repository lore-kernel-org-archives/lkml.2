Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab1EFAYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:24:51 -0400
Received: from kroah.org ([198.145.64.141]:36748 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215Ab1EFAYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:24:44 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:09 2011
Message-Id: <20110506002209.664419146@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [045/143] netx: declare MODULE_FIRMWARE
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 36c04a61f516742dad6f9bad8c6c1a7137a260f5 upstream.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/netx-eth.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/netx-eth.c
+++ b/drivers/net/netx-eth.c
@@ -510,3 +510,6 @@ module_exit(netx_eth_cleanup);
 MODULE_AUTHOR("Sascha Hauer, Pengutronix");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("platform:" CARDNAME);
+MODULE_FIRMWARE("xc0.bin");
+MODULE_FIRMWARE("xc1.bin");
+MODULE_FIRMWARE("xc2.bin");


