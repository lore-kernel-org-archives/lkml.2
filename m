Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968110Ab2ERVs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 17:48:58 -0400
Received: from nm32-vm3.bullet.mail.bf1.yahoo.com ([72.30.239.139]:27574 "HELO
	nm32-vm3.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S968062Ab2ERVsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 17:48:55 -0400
X-Yahoo-Newman-Id: 629036.71487.bm@smtp208.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: EP9vkCEVM1kPPIGTzKUGSGKtq.NKLmMm8yz36UPR4Vzi3rX
 sB3HaJt5rr_MeRZrvHWdq2qVDUaIahi7ifnXPSqcq5rwz1tABXx_8JGWoeMA
 xrAVr2a172soK9Oaa6ReEuos50ULCqXRmyBAIc6opT4BFoVFuXUixmFFOUGO
 h1J51.L9fJeAJbSCuIbS1WavXmMqVA_A42xjXw79gfauhGczryjSe5GIUh9r
 rOhgKMX0K1mJwtikEtT0ko.dWqVcw25FwMGQo8RfKRndo5OyfFkfw2a06.tb
 XYE8B4B47JbbI5Cbrcwx4cycPM5ZNCN5I.k_zT7twL6SCVL6QCbnzx3REupt
 CohPUoVzjmb0yWR0wnL1XIN7CP3jcZAFNeMTsCyI7U2vdgvV_Ac_veRF9U_.
 JeqLK4wiNxQCtoZ7weeKWs2du4NDC9K2hbGcYroM1oJ66kZzN5eKkPaJAUEd
 r3xhwpkK8iFgytvukQrMLlAz_U3poCBMA4qQic6BtsiI3qRAg2jKkOz1n73f
 rKnxt
X-Yahoo-SMTP: dNW5aIGswBCf1iV6QK8RWrBgWyjShXs-
From: Jeffrin Jose <ahiliation@yahoo.co.in>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ahiliation@yahoo.co.in
Subject: [PATCH 1/1]net:ethernet:fixed a coding style issue relating space.
Date: Sat, 19 May 2012 03:15:37 +0530
Message-Id: <1337377537-4636-1-git-send-email-ahiliation@yahoo.co.in>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a coding style issue relating to  space found
by checkpatch.pl tool in net/ethernet/eth.c

Signed-off-by: Jeffrin Jose <ahiliation@yahoo.co.in>
---
 net/ethernet/eth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
index 36e5880..c847aa6 100644
--- a/net/ethernet/eth.c
+++ b/net/ethernet/eth.c
@@ -178,7 +178,7 @@ __be16 eth_type_trans(struct sk_buff *skb, struct net_device *dev)
 	 *      seems to set IFF_PROMISC.
 	 */
 
-	else if (1 /*dev->flags&IFF_PROMISC */ ) {
+	else if (1 /*dev->flags&IFF_PROMISC */) {
 		if (unlikely(!ether_addr_equal_64bits(eth->h_dest,
 						      dev->dev_addr)))
 			skb->pkt_type = PACKET_OTHERHOST;
-- 
1.7.10

