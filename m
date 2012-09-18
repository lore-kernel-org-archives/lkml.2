Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab2IRRLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 13:11:05 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46682 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab2IRRLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 13:11:01 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: alex.bluesman.smirnov@gmail.com
Cc: <dbaryshkov@gmail.com>, davem@davemloft.net,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        trivial@kernel.org, Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 1/3] net/ieee802154/6lowpan.c: Remove unecessary semicolon
Date: Tue, 18 Sep 2012 19:10:43 +0200
Message-Id: <1347988245-31413-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found by http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 net/ieee802154/6lowpan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ieee802154/6lowpan.c b/net/ieee802154/6lowpan.c
index d529111..6d42c17 100644
--- a/net/ieee802154/6lowpan.c
+++ b/net/ieee802154/6lowpan.c
@@ -1256,7 +1256,7 @@ static int lowpan_device_event(struct notifier_block *unused,
 		}
 
 		unregister_netdevice_many(&del_list);
-	};
+	}
 
 out:
 	return NOTIFY_DONE;
-- 
1.7.11.4

