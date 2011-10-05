Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716Ab1JEEoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 00:44:21 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:32482 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755439Ab1JEEoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 00:44:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwBACbdi06WZd+d/2dsb2JhbAAMNoRtlFKRUwRSNQImAnKtSJFBgS2EY4ETBKU/
Subject: [PATCH 2/4] atm: solos-pci: Remove annoying line of debugging
From: Nathan Williams <nathan@traverse.com.au>
To: netdev@vger.kernel.org
Cc: linux-atm-general@lists.sourceforge.net,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Oct 2011 15:44:17 +1100
Message-ID: <1317789857.2424.86.camel@dualcore.traverse>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"len: %d" isn't particularly useful for anyone and confuses users.

Signed-off-by: Nathan Williams <nathan@traverse.com.au>
---
 drivers/atm/solos-pci.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/atm/solos-pci.c b/drivers/atm/solos-pci.c
index 5d1d076..bd01aa3 100644
--- a/drivers/atm/solos-pci.c
+++ b/drivers/atm/solos-pci.c
@@ -452,7 +452,6 @@ static ssize_t console_show(struct device *dev, struct device_attribute *attr,
 
 	len = skb->len;
 	memcpy(buf, skb->data, len);
-	dev_dbg(&card->dev->dev, "len: %d\n", len);
 
 	kfree_skb(skb);
 	return len;
-- 
1.7.2.5



