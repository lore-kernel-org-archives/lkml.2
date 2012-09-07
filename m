Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab2IGPZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:25:17 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45425 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab2IGPZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:25:14 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/10] drivers/bluetooth/hci_ldisc.c: removes unnecessary semicolon
Date: Fri,  7 Sep 2012 17:24:39 +0200
Message-Id: <1347031488-26598-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

removes unnecessary semicolon

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/bluetooth/hci_ldisc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -531,7 +531,7 @@ static int hci_uart_tty_ioctl(struct tty
 	default:
 		err = n_tty_ioctl_helper(tty, file, cmd, arg);
 		break;
-	};
+	}
 
 	return err;
 }

