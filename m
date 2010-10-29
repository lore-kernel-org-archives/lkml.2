Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760352Ab0J2C6D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 22:58:03 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:36884 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760083Ab0J2C54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 22:57:56 -0400
From: Tao Ma <tao.ma@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Tao Ma <tao.ma@oracle.com>,
        Jiri Kosina <trivial@kernel.org>
Subject: [PATCH] drivers/net/igb: remove unused variable in igb_xmit_frame_ring_adv.
Date: Fri, 29 Oct 2010 10:55:49 +0800
Message-Id: <1288320949-5136-1-git-send-email-tao.ma@oracle.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/net/igb/igb_main.c: In function ‘igb_xmit_frame_ring_adv’:
drivers/net/igb/igb_main.c:4110: warning: unused variable ‘adapter’

Cc: Jiri Kosina <trivial@kernel.org>
Signed-off-by: Tao Ma <tao.ma@oracle.com>
---
 drivers/net/igb/igb_main.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
index 14db09e..892d196 100644
--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -4107,7 +4107,6 @@ static inline int igb_maybe_stop_tx(struct igb_ring *tx_ring, int size)
 netdev_tx_t igb_xmit_frame_ring_adv(struct sk_buff *skb,
 				    struct igb_ring *tx_ring)
 {
-	struct igb_adapter *adapter = netdev_priv(tx_ring->netdev);
 	int tso = 0, count;
 	u32 tx_flags = 0;
 	u16 first;
-- 
1.7.1.GIT

