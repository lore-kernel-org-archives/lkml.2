Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab0K1JHO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 04:07:14 -0500
Received: from mail.perches.com ([173.55.12.10]:1887 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751945Ab0K1JFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 04:05:50 -0500
From: Joe Perches <joe@perches.com>
To: Amit Kumar Salecha <amit.salecha@qlogic.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] netxen: remove unnecessary [kv][mcz]alloc casts
Date: Sun, 28 Nov 2010 01:05:43 -0800
Message-Id: <91d9c137a3d1b90e3c333bb3c6c49537bdb8283e.1290934782.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
In-Reply-To: <cover.1290934782.git.joe@perches.com>
References: <cover.1290934782.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/netxen/netxen_nic_init.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/netxen/netxen_nic_init.c b/drivers/net/netxen/netxen_nic_init.c
index f946de2..731077d 100644
--- a/drivers/net/netxen/netxen_nic_init.c
+++ b/drivers/net/netxen/netxen_nic_init.c
@@ -278,8 +278,7 @@ int netxen_alloc_sw_resources(struct netxen_adapter *adapter)
 			break;
 
 		}
-		rds_ring->rx_buf_arr = (struct netxen_rx_buffer *)
-			vzalloc(RCV_BUFF_RINGSIZE(rds_ring));
+		rds_ring->rx_buf_arr = vzalloc(RCV_BUFF_RINGSIZE(rds_ring));
 		if (rds_ring->rx_buf_arr == NULL) {
 			printk(KERN_ERR "%s: Failed to allocate "
 				"rx buffer ring %d\n",
-- 
1.7.3.2.245.g03276.dirty

