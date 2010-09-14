Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274Ab0INEZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 00:25:13 -0400
Received: from mail.perches.com ([173.55.12.10]:2015 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214Ab0INEYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 00:24:21 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Ortiz <samuel@sortiz.org>, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: [PATCH next 15/16] net/irda: Use static const char * const where possible
Date: Mon, 13 Sep 2010 21:24:01 -0700
Message-Id: <d7a719b0edd2bbf0b5a90c02aff635996c15e38d.1284435710.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284435709.git.joe@perches.com>
References: <cover.1284435709.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/net/irda/irlan_event.h |    2 +-
 net/irda/irlan/irlan_event.c   |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/irda/irlan_event.h b/include/net/irda/irlan_event.h
index 6d9539f..018b5a7 100644
--- a/include/net/irda/irlan_event.h
+++ b/include/net/irda/irlan_event.h
@@ -67,7 +67,7 @@ typedef enum {
 	IRLAN_WATCHDOG_TIMEOUT,
 } IRLAN_EVENT;
 
-extern char *irlan_state[];
+extern const char * const irlan_state[];
 
 void irlan_do_client_event(struct irlan_cb *self, IRLAN_EVENT event, 
 			   struct sk_buff *skb);
diff --git a/net/irda/irlan/irlan_event.c b/net/irda/irlan/irlan_event.c
index cbcb4eb..43f1604 100644
--- a/net/irda/irlan/irlan_event.c
+++ b/net/irda/irlan/irlan_event.c
@@ -24,7 +24,7 @@
 
 #include <net/irda/irlan_event.h>
 
-char *irlan_state[] = {
+const char * const irlan_state[] = {
 	"IRLAN_IDLE",
 	"IRLAN_QUERY",
 	"IRLAN_CONN",
-- 
1.7.3.rc1

