Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab1FOD5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 23:57:35 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:35734 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753916Ab1FOD5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 23:57:32 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Alan Cox <alan@linux.intel.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH] serial/8250_pci: delete duplicate data definition
Date: Wed, 15 Jun 2011 12:56:56 +0900
Message-Id: <1308110216-5012-1-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.3.4
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

