Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309Ab1EFAZU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:25:20 -0400
Received: from kroah.org ([198.145.64.141]:36929 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920Ab1EFAZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:10 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:12 2011
Message-Id: <20110506002212.391962847@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:20:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ron Murray <rjmx@rjmx.net>, "David S. Miller" <davem@davemloft.net>
Subject: [073/143] Please add support for Microsoft MN-120 PCMCIA network card
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Ron Murray <rjmx@rjmx.net>

commit 60abe78279568a7109db2bcbc71131766a91c2e5 upstream.

Please add support for Microsoft MN-120 PCMCIA network card. It's an
old card, I know, but adding support is very easy. You just need to
get tulip_core.c to recognise its vendor/device ID.

Patch for kernel 2.6.32.4 (and many previous) attached.

 .....Ron Murray

Signed-off-by: Ron Murray <rjmx@rjmx.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/tulip/tulip_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/tulip/tulip_core.c
+++ b/drivers/net/tulip/tulip_core.c
@@ -249,6 +249,7 @@ static struct pci_device_id tulip_pci_tb
 	{ 0x17B3, 0xAB08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, COMET },
 	{ 0x10b7, 0x9300, PCI_ANY_ID, PCI_ANY_ID, 0, 0, COMET }, /* 3Com 3CSOHO100B-TX */
 	{ 0x14ea, 0xab08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, COMET }, /* Planex FNW-3602-TX */
+	{ 0x1414, 0x0001, PCI_ANY_ID, PCI_ANY_ID, 0, 0, COMET }, /* Microsoft MN-120 */
 	{ 0x1414, 0x0002, PCI_ANY_ID, PCI_ANY_ID, 0, 0, COMET },
 	{ } /* terminate list */
 };


