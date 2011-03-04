Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932578Ab1CDVIM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 16:08:12 -0500
Received: from alternativer.internetendpunkt.de ([88.198.24.89]:59041 "EHLO
	geheimer.internetendpunkt.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932452Ab1CDVIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 16:08:10 -0500
From: Hagen Paul Pfeifer <hagen@jauu.net>
To: linux-kernel@vger.kernel.org
Cc: Hagen Paul Pfeifer <hagen@jauu.net>
Subject: [PATCH 2/4] af_packet: struct socket declared/assigned but unused
Date: Fri,  4 Mar 2011 22:08:01 +0100
Message-Id: <1299272883-32499-2-git-send-email-hagen@jauu.net>
X-Mailer: git-send-email 1.7.4.1.57.g0466.dirty
In-Reply-To: <1299272883-32499-1-git-send-email-hagen@jauu.net>
References: <1299272883-32499-1-git-send-email-hagen@jauu.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Hagen Paul Pfeifer <hagen@jauu.net>
---
 net/packet/af_packet.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 5efef5b..b5362e9 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -966,7 +966,6 @@ static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
 
 static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 {
-	struct socket *sock;
 	struct sk_buff *skb;
 	struct net_device *dev;
 	__be16 proto;
@@ -978,8 +977,6 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
 	int len_sum = 0;
 	int status = 0;
 
-	sock = po->sk.sk_socket;
-
 	mutex_lock(&po->pg_vec_lock);
 
 	err = -EBUSY;
-- 
1.7.4.1.57.g0466.dirty

