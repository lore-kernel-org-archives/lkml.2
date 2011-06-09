Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082Ab1FICvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 22:51:33 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48316 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab1FICv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 22:51:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=rFY8FR5a+DSNqzjiHWTlVSQIOgDfYHryta8vZSgmQKhWzLtAsNCSCQhKSQYYbGdDyk
         s0o9C5ieFwp9PFGMuORYAjb3iRh0sPzvjrJOeWifKHWon+jSxcT74i1np5W24AfK7Cd1
         s4wZw1qbnOC9W3vCEwCeN4qt9y3+/vxK20DXA=
From: Weiping Pan <panweiping3@gmail.com>
To: fubar@us.ibm.com, andy@greyhouse.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Weiping Pan <panweiping3@gmail.com>
Subject: [PATCH net-next 1/2] bonding: delete unused ad_timer
Date: Thu,  9 Jun 2011 10:51:33 +0800
Message-Id: <1d1a90d2f5c7c2ced5eaf8eabffa4fdb770b0e6b.1307587586.git.panweiping3@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <cover.1307587586.git.panweiping3@gmail.com>
References: <cover.1307587586.git.panweiping3@gmail.com>
In-Reply-To: <cover.1307587586.git.panweiping3@gmail.com>
References: <cover.1307587586.git.panweiping3@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now we use agg_select_timer and ad_work.

Signed-off-by: Weiping Pan <panweiping3@gmail.com>
---
 drivers/net/bonding/bond_3ad.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/bonding/bond_3ad.h b/drivers/net/bonding/bond_3ad.h
index 0ee3f16..fb67185 100644
--- a/drivers/net/bonding/bond_3ad.h
+++ b/drivers/net/bonding/bond_3ad.h
@@ -257,7 +257,6 @@ struct ad_bond_info {
 	int lacp_fast;		/* whether fast periodic tx should be
 				 * requested
 				 */
-	struct timer_list ad_timer;
 };
 
 struct ad_slave_info {
-- 
1.7.4.4

