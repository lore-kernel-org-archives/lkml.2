Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441Ab2GMUgs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 16:36:48 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41854 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215Ab2GMUgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 16:36:46 -0400
From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net,
        alex.bluesman.smirnov@gmail.com,
        Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Subject: [PATCH] mac802154: fix sparse warning for mac802154_slave_get_priv
Date: Fri, 13 Jul 2012 23:36:10 +0300
Message-Id: <1342211770-4219-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: git-send-email 1.7.11-rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sparse happy by fixing the following error:
	* symbol 'mac802154_slave_get_priv' was not declared. Should it be static?

Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
---
 net/mac802154/mib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac802154/mib.c b/net/mac802154/mib.c
index ab59821..1cf6557 100644
--- a/net/mac802154/mib.c
+++ b/net/mac802154/mib.c
@@ -34,7 +34,7 @@ struct hw_addr_filt_notify_work {
 	unsigned long changed;
 };
 
-struct mac802154_priv *mac802154_slave_get_priv(struct net_device *dev)
+static struct mac802154_priv *mac802154_slave_get_priv(struct net_device *dev)
 {
 	struct mac802154_sub_if_data *priv = netdev_priv(dev);
 
-- 
1.7.11-rc3

