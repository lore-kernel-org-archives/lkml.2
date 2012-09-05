Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab2IEABq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 20:01:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57280 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758011Ab2IEAB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 20:01:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Chris Zankel <chris@zankel.net>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Chris Metcalf <cmetcalf@tilera.com>
Subject: [patch 1/3] xtensa: remove duplicate CONFIG_HOTPLUG definition
Date: Tue,  4 Sep 2012 17:01:06 -0700
Message-Id: <20120904235155.064688725@clark.kroah.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120904234803.554552301@clark.kroah.org>
References: <20120904234803.554552301@clark.kroah.org>
Content-Disposition: inline; filename=xtensa-remove-duplicate-config_hotplug-definition.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

As part of the plan to remove CONFIG_HOTPLUG, it was found that xtensa
duplicates this config option for no reason (it's already defined as part of
init/Kconfig).  This patch removes it from the xtensa-only Kconfig file.

Cc: Chris Zankel <chris@zankel.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/xtensa/Kconfig |   18 ------------------
 1 file changed, 18 deletions(-)

--- a/arch/xtensa/Kconfig
+++ b/arch/xtensa/Kconfig
@@ -172,24 +172,6 @@ config CMDLINE
 
 source "mm/Kconfig"
 
-config HOTPLUG
-	bool "Support for hot-pluggable devices"
-	help
-	  Say Y here if you want to plug devices into your computer while
-	  the system is running, and be able to use them quickly.  In many
-	  cases, the devices can likewise be unplugged at any time too.
-
-	  One well known example of this is PCMCIA- or PC-cards, credit-card
-	  size devices such as network cards, modems or hard drives which are
-	  plugged into slots found on all modern laptop computers.  Another
-	  example, used on modern desktops as well as laptops, is USB.
-
-	  Enable HOTPLUG and build a modular kernel.  Get agent software
-	  (from <http://linux-hotplug.sourceforge.net/>) and install it.
-	  Then your kernel will automatically call out to a user mode "policy
-	  agent" (/sbin/hotplug) to load modules and set up software needed
-	  to use devices as you hotplug them.
-
 source "drivers/pcmcia/Kconfig"
 
 source "drivers/pci/hotplug/Kconfig"


