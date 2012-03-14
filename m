Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761224Ab2CNRCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 13:02:43 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:34900 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761199Ab2CNRCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 13:02:39 -0400
Message-ID: <4F60CF2F.5050505@xenotime.net>
Date: Wed, 14 Mar 2012 10:02:39 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Chris Kelly <ckelly@ozmodevices.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH -next] staging: ozwpan depends on NET
References: <20120314181921.59451eca117c276461f7dc28@canb.auug.org.au>
In-Reply-To: <20120314181921.59451eca117c276461f7dc28@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix build errors:  add depends on NET.

ERROR: "skb_clone" [drivers/staging/ozwpan/ozwpan.ko] undefined!
ERROR: "dev_get_by_name" [drivers/staging/ozwpan/ozwpan.ko] undefined!
ERROR: "dev_remove_pack" [drivers/staging/ozwpan/ozwpan.ko] undefined!
ERROR: "init_net" [drivers/staging/ozwpan/ozwpan.ko] undefined!
ERROR: "__alloc_skb" [drivers/staging/ozwpan/ozwpan.ko] undefined!
ERROR: "kfree_skb" [drivers/staging/ozwpan/ozwpan.ko] undefined!
ERROR: "dev_add_pack" [drivers/staging/ozwpan/ozwpan.ko] undefined!
ERROR: "consume_skb" [drivers/staging/ozwpan/ozwpan.ko] undefined!
ERROR: "dev_queue_xmit" [drivers/staging/ozwpan/ozwpan.ko] undefined!
ERROR: "skb_put" [drivers/staging/ozwpan/ozwpan.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Chris Kelly <ckelly@ozmodevices.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/ozwpan/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20120314.orig/drivers/staging/ozwpan/Kconfig
+++ linux-next-20120314/drivers/staging/ozwpan/Kconfig
@@ -1,6 +1,6 @@
 config USB_WPAN_HCD
 	tristate "USB over WiFi Host Controller"
-	depends on USB
+	depends on USB && NET
 	help
 	  A driver for USB Host Controllers that are compatible with
 	  Ozmo Devices USB over WiFi technology.
