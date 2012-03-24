Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab2CXQAk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 12:00:40 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:48820 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab2CXQAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 12:00:14 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]drivers:net:ethernet:realtek:r8169.c Typo in r8169.c
Date: Sat, 24 Mar 2012 09:00:04 -0700
Message-Id: <1332604804-11617-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The below patch fixes a typo that I found while reading the code.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/ethernet/realtek/r8169.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 27c358c..324cd96 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -5669,7 +5669,7 @@ static int rtl_open(struct net_device *dev)
 	pm_runtime_get_sync(&pdev->dev);
 
 	/*
-	 * Rx and Tx desscriptors needs 256 bytes alignment.
+	 * Rx and Tx descriptors needs 256 bytes alignment.
 	 * dma_alloc_coherent provides more.
 	 */
 	tp->TxDescArray = dma_alloc_coherent(&pdev->dev, R8169_TX_RING_BYTES,
-- 
1.7.5.4

