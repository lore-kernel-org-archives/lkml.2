Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab1KCVYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 17:24:44 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:41802 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752036Ab1KCVYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 17:24:42 -0400
Message-ID: <4EB30670.40205@xenotime.net>
Date: Thu, 03 Nov 2011 14:24:00 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mark Einon <mark.einon@gmail.com>, Greg KH <gregkh@suse.de>
Subject: [PATCH -next] staging: et131x depends on NET
References: <20111102165413.8cf3105a12e435f078c813eb@canb.auug.org.au>
In-Reply-To: <20111102165413.8cf3105a12e435f078c813eb@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

ET131X uses netdev interfaces so it should depend on NET.

Fixes these build errors:
ERROR: "ethtool_op_get_link" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "eth_validate_addr" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "register_netdev" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "phy_connect" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "phy_find_first" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "mdiobus_register" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "mdiobus_alloc" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "alloc_etherdev_mqs" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "netif_device_detach" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "phy_stop" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "netif_device_attach" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "phy_start" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "free_netdev" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "mdiobus_free" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "mdiobus_unregister" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "unregister_netdev" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "__netif_schedule" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "phy_print_status" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "dev_kfree_skb_any" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "dev_alloc_skb" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "netif_rx" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "eth_type_trans" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "skb_put" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "phy_ethtool_gset" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "phy_ethtool_sset" [drivers/staging/et131x/et131x.ko] undefined!
ERROR: "phy_mii_ioctl" [drivers/staging/et131x/et131x.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/staging/et131x/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- next-2011-1102.orig/drivers/staging/et131x/Kconfig
+++ next-2011-1102/drivers/staging/et131x/Kconfig
@@ -1,6 +1,6 @@
 config ET131X
 	tristate "Agere ET-1310 Gigabit Ethernet support"
-	depends on PCI
+	depends on PCI && NET
 	default n
 	---help---
 	  This driver supports Agere ET-1310 ethernet adapters.
