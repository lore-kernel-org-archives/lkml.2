Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab0IMTvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:51:55 -0400
Received: from mail.perches.com ([173.55.12.10]:1894 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755323Ab0IMTsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:48:33 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Ishizaki Kou <kou.ishizaki@toshiba.co.jp>,
        Jens Osterkamp <jens@de.ibm.com>, netdev@vger.kernel.org
Subject: [PATCH 13/25] drivers/net/spider_net.c: Use static const char arrays
Date: Mon, 13 Sep 2010 12:47:51 -0700
Message-Id: <974ba2cf5b07b91ce307fd5b32af34f4c4a35e81.1284406638.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284406638.git.joe@perches.com>
References: <cover.1284406638.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/spider_net.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/spider_net.c b/drivers/net/spider_net.c
index cb6bcca..ece8d75 100644
--- a/drivers/net/spider_net.c
+++ b/drivers/net/spider_net.c
@@ -70,7 +70,7 @@ MODULE_PARM_DESC(rx_descriptors, "number of descriptors used " \
 MODULE_PARM_DESC(tx_descriptors, "number of descriptors used " \
 		 "in tx chain");
 
-char spider_net_driver_name[] = "spidernet";
+const char spider_net_driver_name[] = "spidernet";
 
 static DEFINE_PCI_DEVICE_TABLE(spider_net_pci_tbl) = {
 	{ PCI_VENDOR_ID_TOSHIBA_2, PCI_DEVICE_ID_TOSHIBA_SPIDER_NET,
-- 
1.7.3.rc1

