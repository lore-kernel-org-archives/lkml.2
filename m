Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760800Ab2ILRG3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:06:29 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52901 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760768Ab2ILRDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:03:39 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/15] drivers/usb/host/xhci-ring.c: removes unnecessary semicolon
Date: Wed, 12 Sep 2012 19:03:17 +0200
Message-Id: <1347469402-27557-10-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>

removes unnecessary semicolon

Found by Coccinelle: http://coccinelle.lip6.fr/

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
 drivers/usb/host/xhci-ring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 643c2f3..ecd6946 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2580,7 +2580,7 @@ static int prepare_ring(struct xhci_hcd *xhci, struct xhci_ring *ep_ring,
 			xhci_err(xhci, "Ring expansion failed\n");
 			return -ENOMEM;
 		}
-	};
+	}
 
 	if (enqueue_is_link_trb(ep_ring)) {
 		struct xhci_ring *ring = ep_ring;

