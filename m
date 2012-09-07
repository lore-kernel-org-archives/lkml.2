Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab2IGPZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:25:37 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:58778 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab2IGPZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:25:20 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] drivers/bluetooth/btuart_cs.c: removes unnecessary semicolon
Date: Fri,  7 Sep 2012 17:24:48 +0200
Message-Id: <1347031488-26598-10-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

removes unnecessary semicolon

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/bluetooth/btuart_cs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/bluetooth/btuart_cs.c b/drivers/bluetooth/btuart_cs.c
--- a/drivers/bluetooth/btuart_cs.c
+++ b/drivers/bluetooth/btuart_cs.c
@@ -446,7 +446,7 @@ static int btuart_hci_send_frame(struct
 	case HCI_SCODATA_PKT:
 		hdev->stat.sco_tx++;
 		break;
-	};
+	}
 
 	/* Prepend skb with frame type */
 	memcpy(skb_push(skb, 1), &bt_cb(skb)->pkt_type, 1);

