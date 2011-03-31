Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933853Ab1CaGpR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 02:45:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61895 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932720Ab1CaGpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 02:45:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=V1AjNda6REmeH/fi73JJVAxy6m4ZlltRjXkDtjNGpDc6NwmuP4GddaLIDQF8l16u7l
         v4AAIaaMdkW98ru4g2YNa+OCXV9IAg20aVe/ipdGMLWZsjmB3aiZ/hz/hHqXH6G31ub7
         qDtGp8lQCvEHXst2wygI2DmHWYhnCu6vRZpwQ=
From: Pan Weiping <panweiping3@gmail.com>
Cc: Pan Weiping <panweiping3@gmail.com>,
        Jay Vosburgh <fubar@us.ibm.com> (supporter:BONDING DRIVER),
        Andy Gospodarek <andy@greyhouse.net> (supporter:BONDING DRIVER),
        netdev@vger.kernel.org (open list:BONDING DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/3] bonding:typo in comment
Date: Thu, 31 Mar 2011 14:46:19 +0800
Message-Id: <1301553980-29096-1-git-send-email-panweiping3@gmail.com>
X-Mailer: git-send-email 1.7.4
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use accumulates instead of acumulates.
Signed-off-by: Pan Weiping <panweiping3@gmail.com>
---
 drivers/net/bonding/bond_alb.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.h b/drivers/net/bonding/bond_alb.h
index 118c28a..4b3e358 100644
--- a/drivers/net/bonding/bond_alb.h
+++ b/drivers/net/bonding/bond_alb.h
@@ -74,7 +74,7 @@ struct tlb_client_info {
 				 * packets to a Client that the Hash function
 				 * gave this entry index.
 				 */
-	u32 tx_bytes;		/* Each Client acumulates the BytesTx that
+	u32 tx_bytes;		/* Each Client accumulates the BytesTx that
 				 * were tranmitted to it, and after each
 				 * CallBack the LoadHistory is devided
 				 * by the balance interval
-- 
1.7.4

