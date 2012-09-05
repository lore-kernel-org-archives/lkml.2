Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab2IEAJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 20:09:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36235 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab2IEAJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 20:09:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Chris Zankel <chris@zankel.net>
Subject: [patch 2/3] tile: remove duplicate CONFIG_HOTPLUG definition
Date: Tue,  4 Sep 2012 17:01:07 -0700
Message-Id: <20120904235155.138994400@clark.kroah.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120904234803.554552301@clark.kroah.org>
References: <20120904234803.554552301@clark.kroah.org>
Content-Disposition: inline; filename=tile-remove-duplicate-config_hotplug-definition.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

As part of the plan to remove CONFIG_HOTPLUG, it was found that tile
duplicates this config option for no reason (it's already defined as part of
init/Kconfig).  This patch removes it from the tile-only Kconfig file.

Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/tile/Kconfig |    8 --------
 1 file changed, 8 deletions(-)

--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -412,14 +412,6 @@ config TILE_USB
 config NEED_BOUNCE_POOL
 	def_bool USB_OHCI_HCD
 
-config HOTPLUG
-	bool "Support for hot-pluggable devices"
-	---help---
-	  Say Y here if you want to plug devices into your computer while
-	  the system is running, and be able to use them quickly.  In many
-	  cases, the devices can likewise be unplugged at any time too.
-	  One well-known example of this is USB.
-
 source "drivers/pci/hotplug/Kconfig"
 
 endmenu


