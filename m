Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab2EQQOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:14:18 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:33443 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756826Ab2EQQOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:14:17 -0400
Message-ID: <4FB523E0.1000208@xenotime.net>
Date: Thu, 17 May 2012 09:14:24 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH -next] staging: gdm72xx depends on NET
References: <20120517174647.fa4794992f2b856b9e5cf03c@canb.auug.org.au>
In-Reply-To: <20120517174647.fa4794992f2b856b9e5cf03c@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

gdm72xx uses networking interfaces, so it should depend
at least on NET (maybe on WIMAX?).

ERROR: "sock_release" [drivers/staging/gdm72xx/gdmwm.ko] undefined!
ERROR: "netif_carrier_on" [drivers/staging/gdm72xx/gdmwm.ko] undefined!
ERROR: "netif_carrier_off" [drivers/staging/gdm72xx/gdmwm.ko] undefined!
ERROR: "skb_realloc_headroom" [drivers/staging/gdm72xx/gdmwm.ko] undefined!
ERROR: "netif_rx" [drivers/staging/gdm72xx/gdmwm.ko] undefined!
ERROR: "netlink_kernel_create" [drivers/staging/gdm72xx/gdmwm.ko] undefined!
ERROR: "netif_rx_ni" [drivers/staging/gdm72xx/gdmwm.ko] undefined!
ERROR: "dev_alloc_skb" [drivers/staging/gdm72xx/gdmwm.ko] undefined!
ERROR: "free_netdev" [drivers/staging/gdm72xx/gdmwm.ko] undefined!
ERROR: "register_netdev" [drivers/staging/gdm72xx/gdmwm.ko] undefined!
ERROR: "skb_push" [drivers/staging/gdm72xx/gdmwm.ko] undefined!
ERROR: "dev_get_by_index" [drivers/staging/gdm72xx/gdmwm.ko] undefined!
ERROR: "skb_pull" [drivers/staging/gdm72xx/gdmwm.ko] undefined!
ERROR: "init_net" [drivers/staging/gdm72xx/gdmwm.ko] undefined!
ERROR: "__alloc_skb" [drivers/staging/gdm72xx/gdmwm.ko] undefined!
ERROR: "netlink_broadcast" [drivers/staging/gdm72xx/gdmwm.ko] undefined!
ERROR: "kfree_skb" [drivers/staging/gdm72xx/gdmwm.ko] undefined!
ERROR: "alloc_netdev_mqs" [drivers/staging/gdm72xx/gdmwm.ko] undefined!
ERROR: "eth_type_trans" [drivers/staging/gdm72xx/gdmwm.ko] undefined!
ERROR: "ether_setup" [drivers/staging/gdm72xx/gdmwm.ko] undefined!
ERROR: "unregister_netdev" [drivers/staging/gdm72xx/gdmwm.ko] undefined!
ERROR: "__netif_schedule" [drivers/staging/gdm72xx/gdmwm.ko] undefined!
ERROR: "skb_put" [drivers/staging/gdm72xx/gdmwm.ko] undefined!
ERROR: "sock_wfree" [drivers/staging/gdm72xx/gdmwm.ko] undefined!
ERROR: "__nlmsg_put" [drivers/staging/gdm72xx/gdmwm.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
Please add some contact info somewhere.

 drivers/staging/gdm72xx/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20120517.orig/drivers/staging/gdm72xx/Kconfig
+++ linux-next-20120517/drivers/staging/gdm72xx/Kconfig
@@ -4,6 +4,7 @@
 
 menuconfig WIMAX_GDM72XX
 	tristate "GCT GDM72xx WiMAX support"
+	depends on NET
 	help
 	  Support for the GCT GDM72xx WiMAX chip
 
