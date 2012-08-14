Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080Ab2HNPGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 11:06:46 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37087 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756640Ab2HNPGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 11:06:42 -0400
From: Jiri Pirko <jiri@resnulli.us>
To: netdev@vger.kernel.org
Cc: davem@davemloft.net, edumazet@google.com, faisal.latif@intel.com,
        roland@kernel.org, sean.hefty@intel.com, hal.rosenstock@gmail.com,
        fubar@us.ibm.com, andy@greyhouse.net, divy@chelsio.com,
        jitendra.kalsaria@qlogic.com, sony.chacko@qlogic.com,
        linux-driver@qlogic.com, kaber@trash.net, ursula.braun@de.ibm.com,
        blaschka@linux.vnet.ibm.com, linux390@de.ibm.com,
        shemminger@vyatta.com, bhutchings@solarflare.com, therbert@google.com,
        xiyou.wangcong@gmail.com, joe@perches.com, gregory.v.rose@intel.com,
        john.r.fastabend@intel.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        bridge@lists.linux-foundation.org, fbl@redhat.com
Subject: [patch net-next v2 15/15] net: kill dev->master
Date: Tue, 14 Aug 2012 17:05:48 +0200
Message-Id: <1344956748-2099-16-git-send-email-jiri@resnulli.us>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1344956748-2099-1-git-send-email-jiri@resnulli.us>
References: <1344956748-2099-1-git-send-email-jiri@resnulli.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobody uses this now. Remove it.

Signed-off-by: Jiri Pirko <jiri@resnulli.us>
---
 include/linux/netdevice.h |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index c689593..8459f72 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1168,10 +1168,6 @@ struct net_device {
 						 * avoid dirtying this cache line.
 						 */
 
-	struct net_device	*master; /* Pointer to master device of a group,
-					  * which this device is member of.
-					  */
-
 	struct list_head	upper_dev_list; /* List of upper devices */
 
 	/* Interface address info used in eth_type_trans() */
-- 
1.7.10.4

