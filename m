Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760933Ab2EJRjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:39:39 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46175 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760717Ab2EJRhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:37:01 -0400
Message-Id: <20120510173137.157384310@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 10 May 2012 10:32:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sam Bradshaw <sbradshaw@micron.com>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [ 49/52] block: mtip32xx: remove HOTPLUG_PCI_PCIE dependancy
In-Reply-To: <20120510173229.GA5678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 63634806519b49bb43f37e53a1e8366eb3e846a4 upstream.

This removes the HOTPLUG_PCI_PCIE dependency on the driver and makes it
depend on PCI.

Cc: Sam Bradshaw <sbradshaw@micron.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Asai Thambi S P <asamymuthupa@micron.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---
 drivers/block/mtip32xx/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/block/mtip32xx/Kconfig
+++ b/drivers/block/mtip32xx/Kconfig
@@ -4,6 +4,6 @@
 
 config BLK_DEV_PCIESSD_MTIP32XX
 	tristate "Block Device Driver for Micron PCIe SSDs"
-	depends on HOTPLUG_PCI_PCIE
+	depends on PCI
 	help
           This enables the block driver for Micron PCIe SSDs.


