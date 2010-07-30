Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186Ab0G3Sde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:33:34 -0400
Received: from kroah.org ([198.145.64.141]:58082 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759858Ab0G3Ry4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:54:56 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:38 2010
Message-Id: <20100730175138.105488052@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:51:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [050/205] p54pci: add Symbol AP-300 minipci adapters pciid
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joerg Albert <jal2@gmx.de>

commit 50900f1698f68127e54c67fdfe829e4a97b1be2b upstream.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/p54/p54pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -41,6 +41,8 @@ static DEFINE_PCI_DEVICE_TABLE(p54p_tabl
 	{ PCI_DEVICE(0x1260, 0x3877) },
 	/* Intersil PRISM Javelin/Xbow Wireless LAN adapter */
 	{ PCI_DEVICE(0x1260, 0x3886) },
+	/* Intersil PRISM Xbow Wireless LAN adapter (Symbol AP-300) */
+	{ PCI_DEVICE(0x1260, 0xffff) },
 	{ },
 };
 


