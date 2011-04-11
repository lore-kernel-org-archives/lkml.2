Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab1DKIQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 04:16:34 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59735 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754967Ab1DKIQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 04:16:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=c1jj/yIUUuLuJpBuHk1M0l0JaQ2KPqmd3sdgy9D3fnnAhp9ox4BvBAO3H2X5LRprRS
         utZE8CG2LRh3W3SEZamCj79n3rh1FiUE4V8TGs7FoeK7gBfbH1eA6pFr23sWOvAyqM3F
         gzlWqTWkfzL4uhYsu6rDuYbnG6u285fpmiLqA=
From: =?UTF-8?q?Weiping=20Pan=28=E6=BD=98=E5=8D=AB=E5=B9=B3=29?= 
	<panweiping3@gmail.com>
To: fubar@us.ibm.com, andy@greyhouse.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Weiping=20Pan (=E6=BD=98=E5=8D=AB=E5=B9=B3) ?= 
	<panweiping3@gmail.com>
Subject: [PATCH 2/2] bonding:delete unused rlb_interval_counter
Date: Mon, 11 Apr 2011 16:17:25 +0800
Message-Id: <dbf419f2037707b09d648931f4ed5913ccfe35d9.1302509480.git.panweiping3@gmail.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <cover.1302509480.git.panweiping3@gmail.com>
References: <cover.1302509480.git.panweiping3@gmail.com>
In-Reply-To: <cover.1302509480.git.panweiping3@gmail.com>
References: <cover.1302509480.git.panweiping3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, alb_bond_info uses rx_ntt,rlb_update_delay_counter and
rlb_update_retry_counter to decide when to call rlb_update_rx_clients().

Signed-off-by: Weiping Pan(潘卫平) <panweiping3@gmail.com>
---
 drivers/net/bonding/bond_alb.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.h b/drivers/net/bonding/bond_alb.h
index f2a1d0a..01ed1fb 100644
--- a/drivers/net/bonding/bond_alb.h
+++ b/drivers/net/bonding/bond_alb.h
@@ -139,7 +139,6 @@ struct alb_bond_info {
 	struct slave		*next_rx_slave;/* next slave to be assigned
 						* to a new rx client for
 						*/
-	u32			rlb_interval_counter;
 	u8			primary_is_promisc;	   /* boolean */
 	u32			rlb_promisc_timeout_counter;/* counts primary
 							     * promiscuity time
-- 
1.7.4

