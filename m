Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab1BVOsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 09:48:30 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:52444 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab1BVOs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 09:48:29 -0500
Date: Tue, 22 Feb 2011 15:48:27 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Update obsolete email addresses for Lennert Buytenhek.
Message-ID: <20110222144826.GH2189@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>

diff --git a/arch/arm/mach-kirkwood/mv88f6281gtw_ge-setup.c b/arch/arm/mach-kirkwood/mv88f6281gtw_ge-setup.c
index 1e5266f..116ff8f 100644
--- a/arch/arm/mach-kirkwood/mv88f6281gtw_ge-setup.c
+++ b/arch/arm/mach-kirkwood/mv88f6281gtw_ge-setup.c
@@ -162,7 +162,7 @@ static int __init mv88f6281gtw_ge_pci_init(void)
 subsys_initcall(mv88f6281gtw_ge_pci_init);
 
 MACHINE_START(MV88F6281GTW_GE, "Marvell 88F6281 GTW GE Board")
-	/* Maintainer: Lennert Buytenhek <buytenh@marvell.com> */
+	/* Maintainer: Lennert Buytenhek <buytenh@wantstofly.org> */
 	.boot_params	= 0x00000100,
 	.init_machine	= mv88f6281gtw_ge_init,
 	.map_io		= kirkwood_map_io,
diff --git a/arch/arm/mach-mv78xx0/db78x00-bp-setup.c b/arch/arm/mach-mv78xx0/db78x00-bp-setup.c
index 207c95e..a63e5e0 100644
--- a/arch/arm/mach-mv78xx0/db78x00-bp-setup.c
+++ b/arch/arm/mach-mv78xx0/db78x00-bp-setup.c
@@ -92,7 +92,7 @@ static int __init db78x00_pci_init(void)
 subsys_initcall(db78x00_pci_init);
 
 MACHINE_START(DB78X00_BP, "Marvell DB-78x00-BP Development Board")
-	/* Maintainer: Lennert Buytenhek <buytenh@marvell.com> */
+	/* Maintainer: Lennert Buytenhek <buytenh@wantstofly.org> */
 	.boot_params	= 0x00000100,
 	.init_machine	= db78x00_init,
 	.map_io		= mv78xx0_map_io,
diff --git a/arch/arm/mach-mv78xx0/rd78x00-masa-setup.c b/arch/arm/mach-mv78xx0/rd78x00-masa-setup.c
index 3511ad4..9dc7137 100644
--- a/arch/arm/mach-mv78xx0/rd78x00-masa-setup.c
+++ b/arch/arm/mach-mv78xx0/rd78x00-masa-setup.c
@@ -77,7 +77,7 @@ static int __init rd78x00_pci_init(void)
 subsys_initcall(rd78x00_pci_init);
 
 MACHINE_START(RD78X00_MASA, "Marvell RD-78x00-MASA Development Board")
-	/* Maintainer: Lennert Buytenhek <buytenh@marvell.com> */
+	/* Maintainer: Lennert Buytenhek <buytenh@wantstofly.org> */
 	.boot_params	= 0x00000100,
 	.init_machine	= rd78x00_masa_init,
 	.map_io		= mv78xx0_map_io,
diff --git a/arch/arm/mach-orion5x/rd88f5181l-ge-setup.c b/arch/arm/mach-orion5x/rd88f5181l-ge-setup.c
index b594290..abb1917 100644
--- a/arch/arm/mach-orion5x/rd88f5181l-ge-setup.c
+++ b/arch/arm/mach-orion5x/rd88f5181l-ge-setup.c
@@ -180,7 +180,7 @@ static int __init rd88f5181l_ge_pci_init(void)
 subsys_initcall(rd88f5181l_ge_pci_init);
 
 MACHINE_START(RD88F5181L_GE, "Marvell Orion-VoIP GE Reference Design")
-	/* Maintainer: Lennert Buytenhek <buytenh@marvell.com> */
+	/* Maintainer: Lennert Buytenhek <buytenh@wantstofly.org> */
 	.boot_params	= 0x00000100,
 	.init_machine	= rd88f5181l_ge_init,
 	.map_io		= orion5x_map_io,
diff --git a/arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c b/arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c
index 02ff45f..df80460 100644
--- a/arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c
+++ b/arch/arm/mach-orion5x/rd88f6183ap-ge-setup.c
@@ -122,7 +122,7 @@ static int __init rd88f6183ap_ge_pci_init(void)
 subsys_initcall(rd88f6183ap_ge_pci_init);
 
 MACHINE_START(RD88F6183AP_GE, "Marvell Orion-1-90 AP GE Reference Design")
-	/* Maintainer: Lennert Buytenhek <buytenh@marvell.com> */
+	/* Maintainer: Lennert Buytenhek <buytenh@wantstofly.org> */
 	.boot_params	= 0x00000100,
 	.init_machine	= rd88f6183ap_ge_init,
 	.map_io		= orion5x_map_io,
diff --git a/arch/arm/mach-orion5x/tsx09-common.c b/arch/arm/mach-orion5x/tsx09-common.c
index c9abb8f..fc5f0cc 100644
--- a/arch/arm/mach-orion5x/tsx09-common.c
+++ b/arch/arm/mach-orion5x/tsx09-common.c
@@ -1,7 +1,7 @@
 /*
  * QNAP TS-x09 Boards common functions
  *
- * Maintainers: Lennert Buytenhek <buytenh@marvell.com>
+ * Maintainers: Lennert Buytenhek <buytenh@wantstofly.org>
  *		Byron Bradley <byron.bbradley@gmail.com>
  *
  * This program is free software; you can redistribute it and/or
diff --git a/arch/arm/mach-orion5x/wrt350n-v2-setup.c b/arch/arm/mach-orion5x/wrt350n-v2-setup.c
index a5989b7..4ce9305 100644
--- a/arch/arm/mach-orion5x/wrt350n-v2-setup.c
+++ b/arch/arm/mach-orion5x/wrt350n-v2-setup.c
@@ -259,7 +259,7 @@ static int __init wrt350n_v2_pci_init(void)
 subsys_initcall(wrt350n_v2_pci_init);
 
 MACHINE_START(WRT350N_V2, "Linksys WRT350N v2")
-	/* Maintainer: Lennert Buytenhek <buytenh@marvell.com> */
+	/* Maintainer: Lennert Buytenhek <buytenh@wantstofly.org> */
 	.boot_params	= 0x00000100,
 	.init_machine	= wrt350n_v2_init,
 	.map_io		= orion5x_map_io,
diff --git a/arch/um/drivers/daemon_kern.c b/arch/um/drivers/daemon_kern.c
index b4a1522..92a8d17 100644
--- a/arch/um/drivers/daemon_kern.c
+++ b/arch/um/drivers/daemon_kern.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and
+ * Copyright (C) 2001 Lennert Buytenhek (buytenh@wantstofly.org) and
  * James Leu (jleu@mindspring.net).
  * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Copyright (C) 2001 by various other people who didn't put their name here.
diff --git a/arch/um/drivers/daemon_user.c b/arch/um/drivers/daemon_user.c
index f8e85e0..57adca1 100644
--- a/arch/um/drivers/daemon_user.c
+++ b/arch/um/drivers/daemon_user.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
- * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and
+ * Copyright (C) 2001 Lennert Buytenhek (buytenh@wantstofly.org) and
  * James Leu (jleu@mindspring.net).
  * Copyright (C) 2001 by various other people who didn't put their name here.
  * Licensed under the GPL.
diff --git a/arch/um/drivers/mcast_kern.c b/arch/um/drivers/mcast_kern.c
index ffc6416..d77c7ed 100644
--- a/arch/um/drivers/mcast_kern.c
+++ b/arch/um/drivers/mcast_kern.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  *
  * based on the existing uml-networking code, which is
- * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and
+ * Copyright (C) 2001 Lennert Buytenhek (buytenh@wantstofly.org) and
  * James Leu (jleu@mindspring.net).
  * Copyright (C) 2001 by various other people who didn't put their name here.
  *
diff --git a/arch/um/drivers/mcast_user.c b/arch/um/drivers/mcast_user.c
index ee19e91..b01482e 100644
--- a/arch/um/drivers/mcast_user.c
+++ b/arch/um/drivers/mcast_user.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2001 by Harald Welte <laforge@gnumonks.org>
  *
  * based on the existing uml-networking code, which is
- * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and
+ * Copyright (C) 2001 Lennert Buytenhek (buytenh@wantstofly.org) and
  * James Leu (jleu@mindspring.net).
  * Copyright (C) 2001 by various other people who didn't put their name here.
  *
diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
index 975613b..89dc032 100644
--- a/arch/um/drivers/mconsole_kern.c
+++ b/arch/um/drivers/mconsole_kern.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org)
+ * Copyright (C) 2001 Lennert Buytenhek (buytenh@wantstofly.org)
  * Copyright (C) 2001 - 2008 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
diff --git a/arch/um/drivers/mconsole_user.c b/arch/um/drivers/mconsole_user.c
index f8cf4c8..1fb9ef6 100644
--- a/arch/um/drivers/mconsole_user.c
+++ b/arch/um/drivers/mconsole_user.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org)
+ * Copyright (C) 2001 Lennert Buytenhek (buytenh@wantstofly.org)
  * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
diff --git a/arch/um/drivers/net_kern.c b/arch/um/drivers/net_kern.c
index 47d0c37..079640c 100644
--- a/arch/um/drivers/net_kern.c
+++ b/arch/um/drivers/net_kern.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
- * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and
+ * Copyright (C) 2001 Lennert Buytenhek (buytenh@wantstofly.org) and
  * James Leu (jleu@mindspring.net).
  * Copyright (C) 2001 by various other people who didn't put their name here.
  * Licensed under the GPL.
diff --git a/arch/um/include/shared/mconsole.h b/arch/um/include/shared/mconsole.h
index c139ae1..1f66173 100644
--- a/arch/um/include/shared/mconsole.h
+++ b/arch/um/include/shared/mconsole.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org)
+ * Copyright (C) 2001 Lennert Buytenhek (buytenh@wantstofly.org)
  * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Licensed under the GPL
  */
diff --git a/arch/um/os-Linux/drivers/ethertap_kern.c b/arch/um/os-Linux/drivers/ethertap_kern.c
index 7f6f9a7..e9d8ec3 100644
--- a/arch/um/os-Linux/drivers/ethertap_kern.c
+++ b/arch/um/os-Linux/drivers/ethertap_kern.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and
+ * Copyright (C) 2001 Lennert Buytenhek (buytenh@wantstofly.org) and
  * James Leu (jleu@mindspring.net).
  * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
  * Copyright (C) 2001 by various other people who didn't put their name here.
diff --git a/arch/um/os-Linux/drivers/ethertap_user.c b/arch/um/os-Linux/drivers/ethertap_user.c
index cc72cb2..81280d6 100644
--- a/arch/um/os-Linux/drivers/ethertap_user.c
+++ b/arch/um/os-Linux/drivers/ethertap_user.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2001 - 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
- * Copyright (C) 2001 Lennert Buytenhek (buytenh@gnu.org) and
+ * Copyright (C) 2001 Lennert Buytenhek (buytenh@wantstofly.org) and
  * James Leu (jleu@mindspring.net).
  * Copyright (C) 2001 by various other people who didn't put their name here.
  * Licensed under the GPL.
diff --git a/drivers/net/mv643xx_eth.c b/drivers/net/mv643xx_eth.c
index 02076e1..7eb2464 100644
--- a/drivers/net/mv643xx_eth.c
+++ b/drivers/net/mv643xx_eth.c
@@ -18,7 +18,7 @@
  *				     <sjhill@realitydiluted.com>
  *
  * Copyright (C) 2007-2008 Marvell Semiconductor
- *			   Lennert Buytenhek <buytenh@marvell.com>
+ *			   Lennert Buytenhek <buytenh@wantstofly.org>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 9ecf840..1867587 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -4586,5 +4586,5 @@ module_exit(mwl8k_exit);
 
 MODULE_DESCRIPTION(MWL8K_DESC);
 MODULE_VERSION(MWL8K_VERSION);
-MODULE_AUTHOR("Lennert Buytenhek <buytenh@marvell.com>");
+MODULE_AUTHOR("Lennert Buytenhek <buytenh@wantstofly.org>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/video/pxa168fb.c b/drivers/video/pxa168fb.c
index 35f61dd..e61269f 100644
--- a/drivers/video/pxa168fb.c
+++ b/drivers/video/pxa168fb.c
@@ -841,7 +841,7 @@ static void __exit pxa168fb_exit(void)
 }
 module_exit(pxa168fb_exit);
 
-MODULE_AUTHOR("Lennert Buytenhek <buytenh@marvell.com> "
+MODULE_AUTHOR("Lennert Buytenhek <buytenh@wantstofly.org> "
 	      "Green Wan <gwan@marvell.com>");
 MODULE_DESCRIPTION("Framebuffer driver for PXA168/910");
 MODULE_LICENSE("GPL");
diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index dd3f201..fb39f44 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -2,7 +2,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek		<buytenh@wantstofly.org>
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/bridge/br.c b/net/bridge/br.c
index 84bbb82..9ca234f 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -3,7 +3,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek		<buytenh@wantstofly.org>
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 5564435..1383fed 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -3,7 +3,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek		<buytenh@wantstofly.org>
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 88485cc..de4d5cd 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -3,7 +3,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek		<buytenh@wantstofly.org>
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index ee64287..490ff02 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -3,7 +3,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek		<buytenh@wantstofly.org>
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index d9d1e2b..aa22e50 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -3,7 +3,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek		<buytenh@wantstofly.org>
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index 88e4aa9..b5288c1 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -3,7 +3,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek		<buytenh@wantstofly.org>
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/bridge/br_ioctl.c b/net/bridge/br_ioctl.c
index cb43312..f9f41a6 100644
--- a/net/bridge/br_ioctl.c
+++ b/net/bridge/br_ioctl.c
@@ -3,7 +3,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek		<buytenh@wantstofly.org>
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index 4b5b66d..d6f8b76 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -3,7 +3,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek		<buytenh@wantstofly.org>
  *	Bart De Schuymer		<bdschuym@pandora.be>
  *
  *	This program is free software; you can redistribute it and/or
diff --git a/net/bridge/br_notify.c b/net/bridge/br_notify.c
index 7d337c9..5cf2ea5 100644
--- a/net/bridge/br_notify.c
+++ b/net/bridge/br_notify.c
@@ -3,7 +3,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek		<buytenh@wantstofly.org>
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 4e1b620..2734b4e 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -2,7 +2,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek		<buytenh@wantstofly.org>
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/bridge/br_private_stp.h b/net/bridge/br_private_stp.h
index 8b650f7..3b73e99 100644
--- a/net/bridge/br_private_stp.h
+++ b/net/bridge/br_private_stp.h
@@ -2,7 +2,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek		<buytenh@wantstofly.org>
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index 57186d8..4f9a004 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -3,7 +3,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek		<buytenh@wantstofly.org>
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/bridge/br_stp_bpdu.c b/net/bridge/br_stp_bpdu.c
index 289646e..24a411b 100644
--- a/net/bridge/br_stp_bpdu.c
+++ b/net/bridge/br_stp_bpdu.c
@@ -3,7 +3,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek		<buytenh@wantstofly.org>
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/bridge/br_stp_if.c b/net/bridge/br_stp_if.c
index 79372d4..98fa18d 100644
--- a/net/bridge/br_stp_if.c
+++ b/net/bridge/br_stp_if.c
@@ -3,7 +3,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek		<buytenh@wantstofly.org>
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
diff --git a/net/bridge/br_stp_timer.c b/net/bridge/br_stp_timer.c
index 7b22456..d296735 100644
--- a/net/bridge/br_stp_timer.c
+++ b/net/bridge/br_stp_timer.c
@@ -3,7 +3,7 @@
  *	Linux ethernet bridge
  *
  *	Authors:
- *	Lennert Buytenhek		<buytenh@gnu.org>
+ *	Lennert Buytenhek		<buytenh@wantstofly.org>
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
