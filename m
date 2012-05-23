Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291Ab2EWNy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 09:54:59 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:59608 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759890Ab2EWNyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 09:54:54 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAJHrvE9bdWOb/2dsb2JhbABDtDOBB4IWAQUnUhBRVwYBEogSukuLGIU3A5Ucj3CCbIFU
X-IronPort-AV: E=Sophos;i="4.75,645,1330902000"; 
   d="scan'208";a="518630132"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc: Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] Staging: ipack/bridges/tpci200: fix indention.
Date: Wed, 23 May 2012 15:54:45 +0200
Message-Id: <1337781287-28628-7-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1337781287-28628-1-git-send-email-siglesias@igalia.com>
References: <1337781287-28628-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index ee26d9a..24070a3 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -582,7 +582,7 @@ static int tpci200_slot_unmap_space(struct ipack_device *dev, int space)
 		if (dev->mem_space.address == NULL) {
 			pr_info("Slot [%d:%d] MEM space not mapped !\n",
 				dev->bus_nr, dev->slot);
-		goto out_unlock;
+			goto out_unlock;
 		}
 		virt_addr_space = &dev->mem_space;
 		break;
-- 
1.7.10

