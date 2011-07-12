Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab1GLHJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 03:09:20 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:29979 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752276Ab1GLHJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 03:09:19 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Alan Cox <alan@linux.intel.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH RESEND] serial/8250_pci: delete duplicate data definition
Date: Tue, 12 Jul 2011 16:08:49 +0900
Message-Id: <1310454529-8178-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.4.4
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Data definiton "VendorID=10DB, device_id=800D" is already defined.
This patch deletes the duplicate definition.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
 drivers/tty/serial/8250_pci.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/8250_pci.c b/drivers/tty/serial/8250_pci.c
index 2b40fbf..8c5ec2a 100644
--- a/drivers/tty/serial/8250_pci.c
+++ b/drivers/tty/serial/8250_pci.c
@@ -1484,11 +1484,6 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 		.device         = 0x800D,
 		.init		= pci_eg20t_init,
 	},
-	{
-		.vendor         = 0x10DB,
-		.device         = 0x800D,
-		.init		= pci_eg20t_init,
-	},
 	/*
 	 * Default "match everything" terminator entry
 	 */
-- 
1.7.4

