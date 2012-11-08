Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab2KHUYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 15:24:24 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:43210 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696Ab2KHUYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 15:24:22 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Shreyas Bhatewara <sbhatewara@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>, netdev@vger.kernel.org
Subject: [PATCH] vmxnet3: convert BUG_ON(true) into a simple BUG()
Date: Thu,  8 Nov 2012 15:23:03 -0500
Message-Id: <1352406191-14303-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 0ae1bcc..7e9622f 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1922,7 +1922,7 @@ vmxnet3_free_irqs(struct vmxnet3_adapter *adapter)
 		free_irq(adapter->pdev->irq, adapter->netdev);
 		break;
 	default:
-		BUG_ON(true);
+		BUG();
 	}
 }
 
-- 
1.7.10.4

