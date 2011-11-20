Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab1KTVHN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 16:07:13 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:10811 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab1KTVHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 16:07:11 -0500
Date: Sun, 20 Nov 2011 22:07:09 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-can@vger.kernel.org, netdev@vger.kernel.org
cc: linux-kernel@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Wolfgang Grandegger <wg@grandegger.com>
Subject: [PATCH] net, sja1000: Don't include version.h in peak_pci.c when
 not needed
Message-ID: <alpine.LNX.2.00.1111202204480.17195@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was pointed out by "make versioncheck" that we do not need to include
version.h in drivers/net/can/sja1000/peak_pci.c
This patch removes the unneeded include.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/net/can/sja1000/peak_pci.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

 note: patch is compile tested only.

diff --git a/drivers/net/can/sja1000/peak_pci.c b/drivers/net/can/sja1000/peak_pci.c
index 905bce0..2c7f503 100644
--- a/drivers/net/can/sja1000/peak_pci.c
+++ b/drivers/net/can/sja1000/peak_pci.c
@@ -20,7 +20,6 @@
  */
 
 #include <linux/kernel.h>
-#include <linux/version.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
 #include <linux/netdevice.h>
-- 
1.7.7.3


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

