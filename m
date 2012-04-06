Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab2DEWh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 18:37:26 -0400
Received: from ip-relay-002.utdallas.edu ([129.110.20.112]:50564 "EHLO
	ip-relay-002.utdallas.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab2DEWhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 18:37:24 -0400
X-Greylist: delayed 575 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Apr 2012 18:37:24 EDT
X-Group: RELAYLIST
X-IronPort-AV: E=Sophos;i="4.75,378,1330927200"; 
   d="scan'208";a="90232828"
From: Qasim Javed <qasimj@gmail.com>
To: linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qasim Javed <qasimj@gmail.com>
Subject: [PATCH] ath5k: Remove extraneous statements from ath5k_hw_proc_4word_tx_status and ath5k_hw_proc_2word_status.
Date: Thu,  5 Apr 2012 20:40:15 -0500
Message-Id: <1333676415-17329-1-git-send-email-qasimj@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Qasim Javed <qasimj@gmail.com>
---
 drivers/net/wireless/ath/ath5k/desc.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/desc.c b/drivers/net/wireless/ath/ath5k/desc.c
index f8bfa3a..97b92c3 100644
--- a/drivers/net/wireless/ath/ath5k/desc.c
+++ b/drivers/net/wireless/ath/ath5k/desc.c
@@ -441,10 +441,8 @@ ath5k_hw_proc_2word_tx_status(struct ath5k_hw *ah,
 				struct ath5k_desc *desc,
 				struct ath5k_tx_status *ts)
 {
-	struct ath5k_hw_2w_tx_ctl *tx_ctl;
 	struct ath5k_hw_tx_status *tx_status;
 
-	tx_ctl = &desc->ud.ds_tx5210.tx_ctl;
 	tx_status = &desc->ud.ds_tx5210.tx_stat;
 
 	/* No frame has been send or error */
@@ -495,11 +493,9 @@ ath5k_hw_proc_4word_tx_status(struct ath5k_hw *ah,
 				struct ath5k_desc *desc,
 				struct ath5k_tx_status *ts)
 {
-	struct ath5k_hw_4w_tx_ctl *tx_ctl;
 	struct ath5k_hw_tx_status *tx_status;
 	u32 txstat0, txstat1;
 
-	tx_ctl = &desc->ud.ds_tx5212.tx_ctl;
 	tx_status = &desc->ud.ds_tx5212.tx_stat;
 
 	txstat1 = ACCESS_ONCE(tx_status->tx_status_1);
-- 
1.7.8.2

