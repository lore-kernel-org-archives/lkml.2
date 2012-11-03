Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab2KCNil (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 09:38:41 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51667 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2KCNij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 09:38:39 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] staging/comedi: fix the spaces issue around that '=' in drivers/ni_670x.c
Date: Sat,  3 Nov 2012 22:38:34 +0900
Message-Id: <1351949914-16198-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch error.
- ERROR: spaces required around that '=' (ctx:WxV)

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/comedi/drivers/ni_670x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/drivers/ni_670x.c b/drivers/staging/comedi/drivers/ni_670x.c
index 36462d5..7a72131 100644
--- a/drivers/staging/comedi/drivers/ni_670x.c
+++ b/drivers/staging/comedi/drivers/ni_670x.c
@@ -322,7 +322,7 @@ static DEFINE_PCI_DEVICE_TABLE(ni_670x_pci_table) = {
 MODULE_DEVICE_TABLE(pci, ni_670x_pci_table);
 
 static struct pci_driver ni_670x_pci_driver = {
-	.name		="ni_670x",
+	.name		= "ni_670x",
 	.id_table	= ni_670x_pci_table,
 	.probe		= ni_670x_pci_probe,
 	.remove		= __devexit_p(ni_670x_pci_remove),
-- 
1.7.9.5

