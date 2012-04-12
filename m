Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762713Ab2DLUfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 16:35:04 -0400
Received: from mail.tpi.com ([70.99.223.143]:3318 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756068Ab2DLUfB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 16:35:01 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Jon Mason <jdmason@kudzu.us>,
        netdev@vger.kernel.org
Subject: [PATCH net-next] net: vxge: Add MODULE_FIRMWARE
Date: Thu, 12 Apr 2012 14:34:42 -0600
Message-Id: <1334262882-96973-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Jon Mason <jdmason@kudzu.us>
Cc: netdev@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/net/ethernet/neterion/vxge/vxge-main.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 51387c3..dcef72d 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -4856,3 +4856,5 @@ vxge_closer(void)
 }
 module_init(vxge_starter);
 module_exit(vxge_closer);
+MODULE_FIRMWARE("vxge/X3fw-pxe.ncf");
+MODULE_FIRMWARE("vxge/X3fw.ncf");
-- 
1.7.9.5

