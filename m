Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab1BNWjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 17:39:23 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11911 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab1BNWjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 17:39:21 -0500
Date: Mon, 14 Feb 2011 23:38:18 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: b.a.t.m.a.n@lists.open-mesh.org
cc: trivial@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Marek Lindner <lindner_marek@yahoo.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
        Sven Eckelmann <sven@narfation.org>
Subject: [PATCH][trivial] Batman: Remove two duplicate includes.
Message-ID: <alpine.LNX.2.00.1102142335331.4530@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate inclusion of "send.h" and "routing.h" from net/batman-adv/soft-interface.c

Patch is against linux-next as of today.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 soft-interface.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index bd088f8..7e37077 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -29,14 +29,12 @@
 #include "hash.h"
 #include "gateway_common.h"
 #include "gateway_client.h"
-#include "send.h"
 #include "bat_sysfs.h"
 #include <linux/slab.h>
 #include <linux/ethtool.h>
 #include <linux/etherdevice.h>
 #include <linux/if_vlan.h>
 #include "unicast.h"
-#include "routing.h"
 
 
 static int bat_get_settings(struct net_device *dev, struct ethtool_cmd *cmd);


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

