Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161523Ab1FAIKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:10:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42734 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161183Ab1FAIKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:10:34 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:03:10 2011
Message-Id: <20110601080309.905055632@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:45 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [049/146] ieee802154: Remove hacked CFLAGS in net/ieee802154/Makefile
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------


From: David S. Miller <davem@davemloft.net>

[ Upstream commit bfac3693c426d280b026f6a1b77dc2294ea43fea ]

It adds -Wall (which the kernel carefully controls already) and of all
things -DDEBUG (which should be set by other means if desired, please
we have dynamic-debug these days).

Kill this noise.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 net/ieee802154/Makefile |    2 --
 1 file changed, 2 deletions(-)

--- a/net/ieee802154/Makefile
+++ b/net/ieee802154/Makefile
@@ -1,5 +1,3 @@
 obj-$(CONFIG_IEEE802154) +=	ieee802154.o af_802154.o
 ieee802154-y		:= netlink.o nl-mac.o nl-phy.o nl_policy.o wpan-class.o
 af_802154-y		:= af_ieee802154.o raw.o dgram.o
-
-ccflags-y += -Wall -DDEBUG


