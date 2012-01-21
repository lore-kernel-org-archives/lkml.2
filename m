Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538Ab2AUSEx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 13:04:53 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:60033 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751332Ab2AUSEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 13:04:37 -0500
Message-ID: <4F1B0BE8.9050403@xenotime.net>
Date: Sat, 21 Jan 2012 11:03:04 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
Subject: [PATCH 9/14] kernel-doc: fix new warning in net/phy/mdio_bus.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix new kernel-doc warning:

Warning(drivers/net/phy/mdio_bus.c:49): No description found for parameter 'size'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/net/phy/mdio_bus.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- lnx-33-rc1.orig/drivers/net/phy/mdio_bus.c
+++ lnx-33-rc1/drivers/net/phy/mdio_bus.c
@@ -38,12 +38,11 @@
 
 /**
  * mdiobus_alloc_size - allocate a mii_bus structure
+ * @size: extra amount of memory to allocate for private storage.
+ * If non-zero, then bus->priv is points to that memory.
  *
  * Description: called by a bus driver to allocate an mii_bus
  * structure to fill in.
- *
- * 'size' is an an extra amount of memory to allocate for private storage.
- * If non-zero, then bus->priv is points to that memory.
  */
 struct mii_bus *mdiobus_alloc_size(size_t size)
 {
