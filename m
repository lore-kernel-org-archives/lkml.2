Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357Ab2IGP2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:28:19 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:61685 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab2IGPZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:25:15 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        Jouni Malinen <jouni@qca.qualcomm.com>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/10] drivers/net/wireless/ath/ath9k/ar9003_mac.c: removes unnecessary semicolon
Date: Fri,  7 Sep 2012 17:24:41 +0200
Message-Id: <1347031488-26598-3-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

removes unnecessary semicolon

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/net/wireless/ath/ath9k/ar9003_mac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/net/wireless/ath/ath9k/ar9003_mac.c b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
--- a/drivers/net/wireless/ath/ath9k/ar9003_mac.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mac.c
@@ -531,7 +531,7 @@ int ath9k_hw_process_rxdesc_edma(struct
 				rxs->rs_status |= ATH9K_RXERR_PHY;
 				rxs->rs_phyerr = phyerr;
 			}
-		};
+		}
 	}
 
 	if (rxsp->status11 & AR_KeyMiss)

