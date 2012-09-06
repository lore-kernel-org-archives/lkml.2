Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861Ab2IFQJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 12:09:44 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57247 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757680Ab2IFQJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 12:09:42 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org,
        Peter Senna Tschudin <peter.senna@gmail.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/10] drivers/net/usb/sierra_net.c: removes unnecessary semicolon
Date: Thu,  6 Sep 2012 18:09:08 +0200
Message-Id: <1346947757-10481-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

removes unnecessary semicolon

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/net/usb/sierra_net.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/net/usb/sierra_net.c b/drivers/net/usb/sierra_net.c
--- a/drivers/net/usb/sierra_net.c
+++ b/drivers/net/usb/sierra_net.c
@@ -842,7 +842,7 @@ static int sierra_net_rx_fixup(struct us
 				netdev_err(dev->net, "HIP/ETH: Invalid pkt\n");
 
 			dev->net->stats.rx_frame_errors++;
-			/* dev->net->stats.rx_errors incremented by caller */;
+			/* dev->net->stats.rx_errors incremented by caller */
 			return 0;
 		}
 

