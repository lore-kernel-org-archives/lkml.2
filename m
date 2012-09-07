Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab2IGP14 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:27:56 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62769 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab2IGPZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:25:16 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/10] drivers/bluetooth/hci_ll.c: removes unnecessary semicolon
Date: Fri,  7 Sep 2012 17:24:42 +0200
Message-Id: <1347031488-26598-4-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

removes unnecessary semicolon

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/bluetooth/hci_ll.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/bluetooth/hci_ll.c b/drivers/bluetooth/hci_ll.c
--- a/drivers/bluetooth/hci_ll.c
+++ b/drivers/bluetooth/hci_ll.c
@@ -481,7 +481,7 @@ static int ll_recv(struct hci_uart *hu,
 			hu->hdev->stat.err_rx++;
 			ptr++; count--;
 			continue;
-		};
+		}
 
 		ptr++; count--;
 

