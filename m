Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab2LRVyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 16:54:52 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:49436 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab2LRVyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 16:54:50 -0500
Date: Tue, 18 Dec 2012 22:54:49 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
cc: etdev@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rami Rosen <rosenr@marvell.com>,
        "David S. Miller" <davem@davemloft.net>, trivial@kernel.org
Subject: [PATCH] net: mvneta: remove unneeded version.h include
Message-ID: <alpine.LNX.2.00.1212182225400.14788@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file uses nothing from the version.h header, so there is no reason
to include it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/net/ethernet/marvell/mvneta.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 3f8086b..a1e0e9f 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -12,7 +12,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/platform_device.h>
-- 
1.7.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

