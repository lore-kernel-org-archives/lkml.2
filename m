Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab1FIHTk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 03:19:40 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:36517 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756882Ab1FIHSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 03:18:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KTwhck5bATVmUADQqpqY0lzT0FpsGcTWoAJeQtjBYc3omkYk/Z+aSzVaQ2ezveIeO6
         52EFnNV7jQL5QZbN7pZSM1lCp0fKC9qzTIMyFGikGTRR4pYaUVbmDN6Oz4bQ5h3reaHO
         DLQzMylupFKBboQ/PDBdfnrKAWVpifrjTLu5s=
From: Weiping Pan <panweiping3@gmail.com>
To: fubar@us.ibm.com, andy@greyhouse.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Weiping Pan <panweiping3@gmail.com>
Subject: [PATCH net-next 4/5] bonding: delete unused ad_timer
Date: Thu,  9 Jun 2011 15:19:04 +0800
Message-Id: <5fd74a13b14c3bd39f6f033dc0ddc48fb9c2c3b6.1307603621.git.panweiping3@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <cover.1307603621.git.panweiping3@gmail.com>
References: <cover.1307603621.git.panweiping3@gmail.com>
In-Reply-To: <cover.1307603621.git.panweiping3@gmail.com>
References: <cover.1307603621.git.panweiping3@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we use agg_select_timer and ad_work.

Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Weiping Pan <panweiping3@gmail.com>
---
 drivers/net/bonding/bond_3ad.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.h b/drivers/net/bonding/bond_3ad.h
index 1682e69..235b2cc 100644
--- a/drivers/net/bonding/bond_3ad.h
+++ b/drivers/net/bonding/bond_3ad.h
@@ -253,7 +253,6 @@ struct ad_system {
 struct ad_bond_info {
 	struct ad_system system;	    /* 802.3ad system structure */
 	u32 agg_select_timer;	    // Timer to select aggregator after all adapter's hand shakes
-	struct timer_list ad_timer;
 };
 
 struct ad_slave_info {
-- 
1.7.4.4

