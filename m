Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965615Ab2JaOtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 10:49:12 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:43587 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965266Ab2JaOtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 10:49:08 -0400
From: Edgar Neukirchner <edgar.neukirchner@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Edgar Neukirchner <edgar.neukirchner@gmail.com>
Subject: [PATCH] Staging: rtl8192e: rtllib_tx.c: fixed an asterisk coding style issue
Date: Wed, 31 Oct 2012 15:48:58 +0100
Message-Id: <1351694938-2354-1-git-send-email-edgar.neukirchner@gmail.com>
X-Mailer: git-send-email 1.7.11.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style issue

Signed-off-by: Edgar Neukirchner <edgar.neukirchner@gmail.com>
---
 drivers/staging/rtl8192e/rtllib_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192e/rtllib_tx.c b/drivers/staging/rtl8192e/rtllib_tx.c
index 42900ee..759d7c7 100644
--- a/drivers/staging/rtl8192e/rtllib_tx.c
+++ b/drivers/staging/rtl8192e/rtllib_tx.c
@@ -287,7 +287,7 @@ static void rtllib_tx_query_agg_cap(struct rtllib_device *ieee,
 {
 	struct rt_hi_throughput *pHTInfo = ieee->pHTInfo;
 	struct tx_ts_record *pTxTs = NULL;
-	struct rtllib_hdr_1addr* hdr = (struct rtllib_hdr_1addr *)skb->data;
+	struct rtllib_hdr_1addr *hdr = (struct rtllib_hdr_1addr *)skb->data;
 
 	if (rtllib_act_scanning(ieee, false))
 		return;
-- 
1.7.11.7

