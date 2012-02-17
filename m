Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab2BQA7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 19:59:53 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:56389 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756686Ab2BQA7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 19:59:49 -0500
X-Sasl-enc: 0tt/+Wb5SYnS0bB8PbqgjZElDQ0XTH7/i2PIo4pceFmy 1329440388
X-Mailbox-Line: From gregkh@linuxfoundation.org Thu Feb 16 16:55:35 2012
Message-Id: <20120217005535.567823665@linuxfoundation.org>
User-Agent: quilt/0.51-15.1
Date: Thu, 16 Feb 2012 16:55:45 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ralf Roesch <ralf.roesch@rw-gmbh.de>,
        Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
        "David S. Miller" <davem@davemloft.net>
Subject: [11/28] net: enable TC35815 for MIPS again
In-Reply-To: <20120217005609.GA17081@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

commit a1728800bed3b93b231d99e97c756f622b9991c2 upstream.

8<----------------------------------------------------------------------
From: Ralf Roesch <ralf.roesch@rw-gmbh.de>
Date: Wed, 16 Nov 2011 09:33:50 +0100
Subject: [11/28] net: enable TC35815 for MIPS again

TX493[8,9] MIPS SoCs support 2 Ethernet channels of type TC35815
which are connected to the internal PCI controller.
And JMR3927 MIPS board has a TC35815 chip on board.
These dependencies were lost on movement to drivers/net/ethernet/toshiba.

Signed-off-by: Ralf Roesch <ralf.roesch@rw-gmbh.de>
Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/toshiba/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/toshiba/Kconfig
+++ b/drivers/net/ethernet/toshiba/Kconfig
@@ -5,7 +5,7 @@
 config NET_VENDOR_TOSHIBA
 	bool "Toshiba devices"
 	default y
-	depends on PCI && (PPC_IBM_CELL_BLADE || PPC_CELLEB) || PPC_PS3
+	depends on PCI && (PPC_IBM_CELL_BLADE || PPC_CELLEB || MIPS) || PPC_PS3
 	---help---
 	  If you have a network (Ethernet) card belonging to this class, say Y
 	  and read the Ethernet-HOWTO, available from


