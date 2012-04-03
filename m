Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab2DCVxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 17:53:15 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39420 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754642Ab2DCVxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 17:53:14 -0400
Message-ID: <1333489992.2695.17.camel@joe2Laptop>
Subject: [PATCH net-next] vxge: Remove unnecessary ; in do {} while (0) macro
From: Joe Perches <joe@perches.com>
To: Jon Mason <jdmason@kudzu.us>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 03 Apr 2012 14:53:12 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro doesn't need a terminating ; so just remove it.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/ethernet/neterion/vxge/vxge-main.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.h b/drivers/net/ethernet/neterion/vxge/vxge-main.h
index f52a42d..372406c 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.h
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.h
@@ -421,7 +421,7 @@ struct vxge_tx_priv {
 		timer.function = handle; \
 		timer.data = (unsigned long) arg; \
 		mod_timer(&timer, (jiffies + exp)); \
-	} while (0);
+	} while (0)
 
 void vxge_initialize_ethtool_ops(struct net_device *ndev);
 enum vxge_hw_status vxge_reset_all_vpaths(struct vxgedev *vdev);


