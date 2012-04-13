Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966324Ab2DMAP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 20:15:27 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2535 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966298Ab2DMAPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 20:15:22 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6678"; a="181249423"
X-IronPort-AV: E=Sophos;i="4.75,411,1330934400"; 
   d="scan'208";a="234901351"
From: xiong <xiong@qca.qualcomm.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: <qca-linux-team@qualcomm.com>, <nic-devel@qualcomm.com>,
        xiong <xiong@qca.qualcomm.com>
Subject: [PATCH 01/37] atl1c: update author contact info & company/driver desciption
Date: Fri, 13 Apr 2012 08:14:26 +0800
Message-ID: <1334276102-15866-2-git-send-email-xiong@qca.qualcomm.com>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1334276102-15866-1-git-send-email-xiong@qca.qualcomm.com>
References: <1334276102-15866-1-git-send-email-xiong@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace unavailable email of the author since he left with a mail-list.
update company info as well, Atheros was acquired by Qualcomm.
insert "100" to driver description since it support 100M controller.

Signed-off-by: xiong <xiong@qca.qualcomm.com>
Tested-by: Liu David <dwliu@qca.qualcomm.com>
---
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 1ef0c92..1f1f9eb 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -54,8 +54,9 @@ static DEFINE_PCI_DEVICE_TABLE(atl1c_pci_tbl) = {
 };
 MODULE_DEVICE_TABLE(pci, atl1c_pci_tbl);
 
-MODULE_AUTHOR("Jie Yang <jie.yang@atheros.com>");
-MODULE_DESCRIPTION("Atheros 1000M Ethernet Network Driver");
+MODULE_AUTHOR("Jie Yang");
+MODULE_AUTHOR("Qualcomm Atheros Inc., <nic-devel@qualcomm.com>");
+MODULE_DESCRIPTION("Qualcom Atheros 100/1000M Ethernet Network Driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(ATL1C_DRV_VERSION);
 
-- 
1.7.7

