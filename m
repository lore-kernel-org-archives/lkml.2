Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077Ab1DKKPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 06:15:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50537 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395Ab1DKKPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 06:15:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=ojPqUQtoep8K3tgmVFvRvvYwvxRHMMngjGZMKX/vQfqTIQCtZpgLpsVVLmV/Qh9kaw
         51ArnMFPIFOfwShRXQ9CBXQBYSfjRaaKkKZkSl8RJv+pUpPp9qX7BNoroahbl3zSgj9G
         dNnY0piq3wVsq3Mb5w4Fcq1RuCUmszaAzDdKU=
From: =?UTF-8?q?Weiping=20Pan=28=E6=BD=98=E5=8D=AB=E5=B9=B3=29?= 
	<panweiping3@gmail.com>
Cc: =?UTF-8?q?Weiping=20Pan (=E6=BD=98=E5=8D=AB=E5=B9=B3) ?= 
	<panweiping3@gmail.com>,
        Jay Vosburgh <fubar@us.ibm.com> (supporter:BONDING DRIVER),
        Andy Gospodarek <andy@greyhouse.net> (supporter:BONDING DRIVER),
        netdev@vger.kernel.org (open list:BONDING DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 4/4] bonding:fix two typos
Date: Mon, 11 Apr 2011 18:16:32 +0800
Message-Id: <1302516993-9612-1-git-send-email-panweiping3@gmail.com>
X-Mailer: git-send-email 1.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace relpy with reply.
replace premanent with permanent.

Signed-off-by: Weiping Pan(潘卫平) <panweiping3@gmail.com>
---
 drivers/net/bonding/bond_alb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 9bc5de3..6e176d6 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -701,7 +701,7 @@ static struct slave *rlb_arp_xmit(struct sk_buff *skb, struct bonding *bond)
 		 */
 		rlb_choose_channel(skb, bond);
 
-		/* The ARP relpy packets must be delayed so that
+		/* The ARP reply packets must be delayed so that
 		 * they can cancel out the influence of the ARP request.
 		 */
 		bond->alb_info.rlb_update_delay_counter = RLB_UPDATE_DELAY;
@@ -1042,7 +1042,7 @@ static void alb_change_hw_addr_on_detach(struct bonding *bond, struct slave *sla
  *
  * If the permanent hw address of @slave is @bond's hw address, we need to
  * find a different hw address to give @slave, that isn't in use by any other
- * slave in the bond. This address must be, of course, one of the premanent
+ * slave in the bond. This address must be, of course, one of the permanent
  * addresses of the other slaves.
  *
  * We go over the slave list, and for each slave there we compare its
-- 
1.7.4

